/**
 * Common type definitions for GRIB2 WASM Demo
 */

export interface RecordMeta {
  recordIndex: number;
  recordId: string;
  messageOffset: number;
  messageTotalLength: number;
  referenceTime: string;
  discipline: number;
  edition: number;
  parameterName: string;
  levelName: string;
  section3Template: number;
  section4Template: number;
  section5Template: number;
  section3Ni: number;
  section3Nj: number;
  section3Lat1Microdeg: number;
  section3Lon1Microdeg: number;
  section3Lat2Microdeg: number;
  section3Lon2Microdeg: number;
  section5NumDefinedPoints: number;
}

export interface RecordGrid {
  recordIndex: number;
  numPoints: number;
  section5Template: number;
  hasBitmap: boolean;
  values: Array<number | null>;
}

export interface TimeSeriesFrame {
  forecastHour: number;
  recordIndex: number;
  handle: number;
  meta: RecordMeta;
}

export interface LoadedFile {
  name: string;
  handle: number;
  records: RecordMeta[];
}
