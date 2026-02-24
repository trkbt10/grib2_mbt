/**
 * Time series processing and moving average
 */

import type { LoadedFile, TimeSeriesFrame, GridData } from './types';
import type { Grib2Record } from './grib2';

// Parameter name lookup table (Category.Number -> name)
const PARAM_NAMES: Record<string, string> = {
  '0.0': 'TMP',      // Temperature
  '0.2': 'POT',      // Potential temperature
  '0.6': 'DPT',      // Dew point temperature
  '2.2': 'UGRD',     // U-component of wind
  '2.3': 'VGRD',     // V-component of wind
  '3.0': 'PRES',     // Pressure
  '3.1': 'PRMSL',    // Pressure reduced to MSL
  '3.5': 'HGT',      // Geopotential height
  '1.1': 'RH',       // Relative humidity
  '1.8': 'APCP',     // Total precipitation
};

// Level type lookup table (type code -> name format)
const LEVEL_NAMES: Record<number, (value: number) => string> = {
  100: (v) => `${v / 100} hPa`,  // Isobaric surface (Pa -> hPa)
  101: () => 'mean sea level',
  102: () => 'specific altitude above mean sea level',
  103: (v) => `${v} m above ground`,
  104: () => 'sigma level',
  105: () => 'hybrid level',
  1: () => 'surface',
  2: () => 'cloud base',
  3: () => 'cloud top',
  4: () => '0 degC isotherm',
  6: () => 'max wind',
  7: () => 'tropopause',
  8: () => 'nominal top of atmosphere',
  200: () => 'entire atmosphere',
  204: () => 'highest tropospheric freezing level',
};

/**
 * Get parameter name from category and number.
 */
export function getParameterName(category: number, number: number): string {
  const key = `${category}.${number}`;
  return PARAM_NAMES[key] ?? `PARAM_${category}_${number}`;
}

/**
 * Get level name from type and value.
 */
export function getLevelName(type: number, scaleFactor: number, scaledValue: number): string {
  const formatter = LEVEL_NAMES[type];
  if (formatter) {
    const value = scaledValue * Math.pow(10, -scaleFactor);
    return formatter(value);
  }
  return `level_${type}`;
}

/**
 * Extract forecast hour from Section 4 forecast time.
 * Converts to hours based on time unit indicator.
 */
export function extractForecastHour(record: Grib2Record): number {
  const s4 = record.section4;
  const forecastTime = s4.forecastTime ?? 0;
  const timeUnit = s4.indicatorOfUnitOfTimeRange ?? 1;

  switch (timeUnit) {
    case 0: return Math.floor(forecastTime / 60);  // Minutes -> hours
    case 1: return forecastTime;                    // Hours
    case 2: return forecastTime * 24;               // Days -> hours
    case 3: return forecastTime * 24 * 30;          // Months -> hours (approx)
    case 4: return forecastTime * 24 * 365;         // Years -> hours (approx)
    default: return forecastTime;
  }
}

function toPressureLevelHpa(scaleFactor: number, scaledValue: number): number {
  const levelPa = scaledValue * Math.pow(10, -scaleFactor);
  return levelPa / 100;
}

function formatPressureLevel(level: number): string {
  if (!Number.isFinite(level)) {
    return String(level);
  }
  const abs = Math.abs(level);
  if (abs !== 0 && (abs < 1e-3 || abs >= 1e6)) {
    return level.toExponential(6).replace(/\.?0+e/, 'e');
  }
  return String(Number(level.toFixed(6)));
}

function samePressureLevel(a: number, b: number): boolean {
  const diff = Math.abs(a - b);
  const tol = Math.max(1e-12, Math.max(Math.abs(a), Math.abs(b)) * 1e-9);
  return diff <= tol;
}

function buildPressureLevelKey(scaleFactor: number, scaledValue: number): string {
  return `100:${scaleFactor}:${scaledValue}`;
}

interface IsobaricLevelSpec {
  key: string;
  hpa: number;
}

function getIsobaricLevelSpec(record: Grib2Record): IsobaricLevelSpec | null {
  const s4 = record.section4;
  if (s4.typeOfFirstFixedSurface !== 100) {
    return null;
  }
  const scaledValue = s4.scaledValueOfFirstFixedSurface ?? 0;
  const scaleFactor = s4.scaleFactorOfFirstFixedSurface ?? 0;
  return {
    key: buildPressureLevelKey(scaleFactor, scaledValue),
    hpa: toPressureLevelHpa(scaleFactor, scaledValue),
  };
}

export interface PressureLevelOption {
  key: string;
  hpa: number;
  label: string;
}

/**
 * TimeSeriesManager: Manages multiple files and their records as a time series.
 */
export class TimeSeriesManager {
  private files: LoadedFile[] = [];

  /**
   * Add a loaded file to the manager.
   */
  addFile(file: LoadedFile): void {
    this.files.push(file);
  }

  /**
   * Clear all files.
   */
  clear(): void {
    this.files = [];
  }

  /**
   * Get all available parameter names.
   */
  getParameterNames(): string[] {
    const names = new Set<string>();
    for (const file of this.files) {
      for (const record of file.grib2.records()) {
        const s4 = record.section4;
        const name = getParameterName(s4.parameterCategory ?? 0, s4.parameterNumber ?? 0);
        names.add(name);
      }
    }
    return Array.from(names).sort();
  }

  /**
   * Get all available pressure levels for a parameter.
   */
  getPressureLevelOptions(parameterName: string): PressureLevelOption[] {
    const levels = new Map<string, number>();
    for (const file of this.files) {
      for (const record of file.grib2.records()) {
        const s4 = record.section4;
        const name = getParameterName(s4.parameterCategory ?? 0, s4.parameterNumber ?? 0);
        if (name !== parameterName) continue;

        const level = getIsobaricLevelSpec(record);
        if (!level) continue;
        levels.set(level.key, level.hpa);
      }
    }
    return Array.from(levels.entries())
      .map(([key, hpa]) => ({ key, hpa, label: `${formatPressureLevel(hpa)} mb` }))
      .sort((a, b) => b.hpa - a.hpa);
  }

  /**
   * Backward-compatible helper: returns only hPa numeric values.
   */
  getPressureLevels(parameterName: string): number[] {
    return this.getPressureLevelOptions(parameterName).map((v) => v.hpa);
  }

  /**
   * Build time series frames for a specific parameter and pressure level key.
   */
  buildTimeSeriesByLevelKey(parameterName: string, levelKey: string): TimeSeriesFrame[] {
    const frames: TimeSeriesFrame[] = [];
    for (const file of this.files) {
      for (const record of file.grib2.records()) {
        const s4 = record.section4;
        const name = getParameterName(s4.parameterCategory ?? 0, s4.parameterNumber ?? 0);
        if (name !== parameterName) continue;
        const level = getIsobaricLevelSpec(record);
        if (!level || level.key !== levelKey) continue;
        const forecastHour = extractForecastHour(record);
        frames.push({ forecastHour, record });
      }
    }
    frames.sort((a, b) => a.forecastHour - b.forecastHour);
    return frames;
  }

  /**
   * Build time series frames for a specific parameter and pressure level.
   */
  buildTimeSeries(parameterName: string, pressureLevel: number): TimeSeriesFrame[] {
    const frames: TimeSeriesFrame[] = [];

    for (const file of this.files) {
      for (const record of file.grib2.records()) {
        const s4 = record.section4;
        const name = getParameterName(s4.parameterCategory ?? 0, s4.parameterNumber ?? 0);
        if (name !== parameterName) continue;

        const level = getIsobaricLevelSpec(record);
        if (!level) continue;
        const levelHpa = level.hpa;
        if (!samePressureLevel(levelHpa, pressureLevel)) continue;

        const forecastHour = extractForecastHour(record);

        frames.push({
          forecastHour,
          record,
        });
      }
    }

    // Sort by forecast hour
    frames.sort((a, b) => a.forecastHour - b.forecastHour);
    return frames;
  }
}

/**
 * Apply temporal moving average across frames.
 */
export function applyTemporalMovingAverage(
  frames: TimeSeriesFrame[],
  centerIndex: number,
  radius: number
): GridData | null {
  if (frames.length === 0 || centerIndex < 0 || centerIndex >= frames.length) {
    return null;
  }

  if (radius === 0) {
    // No averaging, just return the center frame
    const frame = frames[centerIndex];
    const values = frame.record.getValues();
    return { numPoints: values.length, values };
  }

  // Collect grids within the window
  const grids: Float32Array[] = [];
  const startIdx = Math.max(0, centerIndex - radius);
  const endIdx = Math.min(frames.length - 1, centerIndex + radius);

  for (let i = startIdx; i <= endIdx; i++) {
    const frame = frames[i];
    try {
      grids.push(frame.record.getValues());
    } catch {
      // Skip failed grids
    }
  }

  if (grids.length === 0) {
    return null;
  }

  // Calculate average
  const centerGrid = grids[Math.floor(grids.length / 2)];
  const numPoints = centerGrid.length;
  const avgValues = new Float32Array(numPoints);

  for (let p = 0; p < numPoints; p++) {
    let sum = 0;
    let count = 0;

    for (const grid of grids) {
      const v = grid[p];
      if (!Number.isNaN(v)) {
        sum += v;
        count++;
      }
    }

    avgValues[p] = count > 0 ? sum / count : NaN;
  }

  return { numPoints, values: avgValues };
}
