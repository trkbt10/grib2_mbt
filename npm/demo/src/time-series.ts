/**
 * Time series processing and moving average
 */

import type { RecordMeta, RecordGrid, TimeSeriesFrame, LoadedFile } from './types';
import { decodeRecordGrid } from './grib2-browser';

/**
 * Extract forecast hour from levelName.
 * Example: "500 hPa, 3 hour forecast" -> 3
 */
export function extractForecastHour(levelName: string): number {
  const match = levelName.match(/(\d+)\s*hour\s*forecast/i);
  if (match) {
    return parseInt(match[1], 10);
  }
  // Analysis time (0 hour forecast)
  if (levelName.includes('analysis') || !levelName.includes('forecast')) {
    return 0;
  }
  return 0;
}

/**
 * TimeSeriesManager: Manages multiple files and their records as a time series.
 */
export class TimeSeriesManager {
  private files: LoadedFile[] = [];
  private frames: TimeSeriesFrame[] = [];

  /**
   * Add a loaded file to the manager.
   */
  addFile(file: LoadedFile): void {
    this.files.push(file);
    this.rebuildFrames();
  }

  /**
   * Clear all files.
   */
  clear(): void {
    this.files = [];
    this.frames = [];
  }

  /**
   * Get all available parameter names.
   */
  getParameterNames(): string[] {
    const names = new Set<string>();
    for (const file of this.files) {
      for (const record of file.records) {
        names.add(record.parameterName);
      }
    }
    return Array.from(names).sort();
  }

  /**
   * Get all available pressure levels for a parameter.
   */
  getPressureLevels(parameterName: string): number[] {
    const levels = new Set<number>();
    for (const file of this.files) {
      for (const record of file.records) {
        if (record.parameterName === parameterName) {
          // Extract pressure level from levelName
          // Formats: "500 hPa", "500 mb", "5 mb" (for 500 Pa = 5 hPa)
          const hPaMatch = record.levelName.match(/^(\d+)\s*hPa/i);
          const mbMatch = record.levelName.match(/^(\d+)\s*mb/i);
          if (hPaMatch) {
            levels.add(parseInt(hPaMatch[1], 10));
          } else if (mbMatch) {
            // mb is same as hPa (1 mb = 1 hPa)
            levels.add(parseInt(mbMatch[1], 10));
          }
        }
      }
    }
    return Array.from(levels).sort((a, b) => b - a);
  }

  /**
   * Build time series frames for a specific parameter and pressure level.
   */
  buildTimeSeries(parameterName: string, pressureLevel: number): TimeSeriesFrame[] {
    const frames: TimeSeriesFrame[] = [];

    for (const file of this.files) {
      for (const record of file.records) {
        if (record.parameterName !== parameterName) continue;

        // Check pressure level (supports both hPa and mb formats)
        const hPaMatch = record.levelName.match(/^(\d+)\s*hPa/i);
        const mbMatch = record.levelName.match(/^(\d+)\s*mb/i);
        const levelMatch = hPaMatch || mbMatch;
        if (!levelMatch || parseInt(levelMatch[1], 10) !== pressureLevel) continue;

        const forecastHour = extractForecastHour(record.levelName);

        frames.push({
          forecastHour,
          recordIndex: record.recordIndex,
          handle: file.handle,
          meta: record
        });
      }
    }

    // Sort by forecast hour
    frames.sort((a, b) => a.forecastHour - b.forecastHour);
    return frames;
  }

  private rebuildFrames(): void {
    // Default to TMP at 500 hPa if available
    const paramNames = this.getParameterNames();
    const tmpParam = paramNames.find(n => n.includes('TMP') || n.includes('Temperature'));
    if (tmpParam) {
      const levels = this.getPressureLevels(tmpParam);
      const level500 = levels.find(l => l === 500) ?? levels[0];
      if (level500) {
        this.frames = this.buildTimeSeries(tmpParam, level500);
      }
    }
  }

  /**
   * Get current frames.
   */
  getFrames(): TimeSeriesFrame[] {
    return this.frames;
  }

  /**
   * Get frame count.
   */
  get frameCount(): number {
    return this.frames.length;
  }
}

/**
 * Apply temporal moving average across frames.
 */
export function applyTemporalMovingAverage(
  frames: TimeSeriesFrame[],
  centerIndex: number,
  radius: number
): RecordGrid | null {
  if (frames.length === 0 || centerIndex < 0 || centerIndex >= frames.length) {
    return null;
  }

  if (radius === 0) {
    // No averaging, just return the center frame
    const frame = frames[centerIndex];
    return decodeRecordGrid(frame.handle, frame.recordIndex);
  }

  // Collect grids within the window
  const grids: RecordGrid[] = [];
  const startIdx = Math.max(0, centerIndex - radius);
  const endIdx = Math.min(frames.length - 1, centerIndex + radius);

  for (let i = startIdx; i <= endIdx; i++) {
    const frame = frames[i];
    try {
      const grid = decodeRecordGrid(frame.handle, frame.recordIndex);
      grids.push(grid);
    } catch {
      // Skip failed grids
    }
  }

  if (grids.length === 0) {
    return null;
  }

  // Calculate average
  const centerGrid = grids[Math.floor(grids.length / 2)];
  const numPoints = centerGrid.numPoints;
  const avgValues: Array<number | null> = new Array(numPoints);

  for (let p = 0; p < numPoints; p++) {
    let sum = 0;
    let count = 0;

    for (const grid of grids) {
      const v = grid.values[p];
      if (v !== null) {
        sum += v;
        count++;
      }
    }

    avgValues[p] = count > 0 ? sum / count : null;
  }

  return {
    recordIndex: centerGrid.recordIndex,
    numPoints,
    section5Template: centerGrid.section5Template,
    hasBitmap: centerGrid.hasBitmap,
    values: avgValues
  };
}
