/**
 * Common type definitions for GRIB2 WASM Demo
 */

// =============================================================================
// Section Data Types (Low-Level API)
// =============================================================================

export interface Section1Data {
  center: number;
  subcenter: number;
  masterTableVersion: number;
  localTableVersion: number;
  significanceOfRefTime: number;
  year: number;
  month: number;
  day: number;
  hour: number;
  minute: number;
  second: number;
  productionStatus: number;
  typeOfData: number;
}

export interface Section3Data {
  template: number;
  gridDefinitionSource: number;
  numberOfPoints: number;
  ni?: number;
  nj?: number;
  lat1Microdeg?: number;
  lon1Microdeg?: number;
  lat2Microdeg?: number;
  lon2Microdeg?: number;
  diMicrodeg?: number;
  djMicrodeg?: number;
  scanMode?: number;
  resolutionFlags?: number;
}

export interface Section4Data {
  template: number;
  parameterCategory?: number;
  parameterNumber?: number;
  typeOfGeneratingProcess?: number;
  indicatorOfUnitOfTimeRange?: number;
  forecastTime?: number;
  typeOfFirstFixedSurface?: number;
  scaleFactorOfFirstFixedSurface?: number;
  scaledValueOfFirstFixedSurface?: number;
  typeOfSecondFixedSurface?: number | null;
  scaleFactorOfSecondFixedSurface?: number | null;
  scaledValueOfSecondFixedSurface?: number | null;
  // Template-specific optional fields
  ensembleType?: number;
  perturbationNumber?: number;
  numberOfEnsembleMembers?: number;
  probabilityType?: number;
}

export interface Section5Data {
  template: number;
  numberOfPoints: number;
  referenceValue?: number;
  binaryScaleFactor?: number;
  decimalScaleFactor?: number;
  bitsPerValue?: number;
}

export interface Section6Data {
  bitmapIndicator: number;
}

// =============================================================================
// Time Series Types (Demo-specific)
// =============================================================================

import type { Grib2File, Grib2Record } from './grib2';

/**
 * Loaded GRIB2 file with metadata.
 */
export interface LoadedFile {
  name: string;
  grib2: Grib2File;
}

/**
 * A single frame in a time series.
 */
export interface TimeSeriesFrame {
  forecastHour: number;
  record: Grib2Record;
}

/**
 * Grid data values (for rendering).
 */
export interface GridData {
  numPoints: number;
  values: Float32Array;
}
