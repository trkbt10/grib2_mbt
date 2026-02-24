/**
 * High-level GRIB2 API
 *
 * Provides a fluent interface for working with GRIB2 files.
 * Inspired by cfgrib, D3.js, and Lodash patterns.
 */

import {
  parseGrib2,
  getRecordCount,
  getSection1,
  getSection3,
  getSection4,
  getSection5,
  getSection6,
  getLatitudes,
  getLongitudes,
  getGridData,
  initBrowser,
  isInitialized,
  bytesToLatin1,
} from './grib2-browser';

import type {
  Section1Data,
  Section3Data,
  Section4Data,
  Section5Data,
  Section6Data,
} from './types';

export { initBrowser, isInitialized };

// =============================================================================
// Grib2File Class
// =============================================================================

/**
 * Represents a parsed GRIB2 file.
 * Entry point for the high-level API.
 */
export class Grib2File {
  private readonly _handle: number;
  private _recordCount: number | null = null;

  constructor(handle: number) {
    if (handle < 0) {
      throw new Error('Invalid GRIB2 handle');
    }
    this._handle = handle;
  }

  /**
   * Get the internal handle for low-level operations.
   */
  get handle(): number {
    return this._handle;
  }

  /**
   * Get the number of records in the file.
   */
  get recordCount(): number {
    if (this._recordCount === null) {
      this._recordCount = getRecordCount(this._handle);
    }
    return this._recordCount;
  }

  /**
   * Get all records as an iterator.
   */
  records(): RecordIterator {
    const records: Grib2Record[] = [];
    for (let i = 1; i <= this.recordCount; i++) {
      records.push(new Grib2Record(this._handle, i));
    }
    return new RecordIterator(records);
  }

  /**
   * Get a single record by 1-based index.
   */
  record(index: number): Grib2Record {
    if (index < 1 || index > this.recordCount) {
      throw new Error(`Record index ${index} out of range (1-${this.recordCount})`);
    }
    return new Grib2Record(this._handle, index);
  }
}

// =============================================================================
// Grib2Record Class
// =============================================================================

/**
 * Represents a single GRIB2 record (submessage).
 * Section data is lazily loaded on first access.
 */
export class Grib2Record {
  private readonly _handle: number;
  private readonly _index: number;

  // Cached section data (lazy loading)
  private _section1: Section1Data | null = null;
  private _section3: Section3Data | null = null;
  private _section4: Section4Data | null = null;
  private _section5: Section5Data | null = null;
  private _section6: Section6Data | null = null;

  constructor(handle: number, index: number) {
    this._handle = handle;
    this._index = index;
  }

  /**
   * Get the 1-based record index.
   */
  get index(): number {
    return this._index;
  }

  /**
   * Get the internal handle for low-level operations.
   */
  get handle(): number {
    return this._handle;
  }

  // =========================================================================
  // Section Accessors (Lazy Loading)
  // =========================================================================

  /**
   * Get Section 1 (Identification Section) data.
   */
  get section1(): Section1Data {
    if (this._section1 === null) {
      // Section 1 is message-level, use message index 0 for simplicity
      this._section1 = getSection1(this._handle, 0);
    }
    return this._section1;
  }

  /**
   * Get Section 3 (Grid Definition Section) data.
   */
  get section3(): Section3Data {
    if (this._section3 === null) {
      this._section3 = getSection3(this._handle, this._index);
    }
    return this._section3;
  }

  /**
   * Get Section 4 (Product Definition Section) data.
   */
  get section4(): Section4Data {
    if (this._section4 === null) {
      this._section4 = getSection4(this._handle, this._index);
    }
    return this._section4;
  }

  /**
   * Get Section 5 (Data Representation Section) data.
   */
  get section5(): Section5Data {
    if (this._section5 === null) {
      this._section5 = getSection5(this._handle, this._index);
    }
    return this._section5;
  }

  /**
   * Get Section 6 (Bit-Map Section) data.
   */
  get section6(): Section6Data {
    if (this._section6 === null) {
      this._section6 = getSection6(this._handle, this._index);
    }
    return this._section6;
  }

  // =========================================================================
  // Convenience Accessors
  // =========================================================================

  /**
   * Get the parameter category (from Section 4).
   */
  get parameterCategory(): number {
    return this.section4.parameterCategory ?? -1;
  }

  /**
   * Get the parameter number (from Section 4).
   */
  get parameterNumber(): number {
    return this.section4.parameterNumber ?? -1;
  }

  /**
   * Get the forecast time (from Section 4).
   */
  get forecastTime(): number {
    return this.section4.forecastTime ?? 0;
  }

  /**
   * Get the first fixed surface type (level type, from Section 4).
   */
  get levelType(): number {
    return this.section4.typeOfFirstFixedSurface ?? -1;
  }

  /**
   * Get the first fixed surface value (level value, from Section 4).
   */
  get levelValue(): number {
    return this.section4.scaledValueOfFirstFixedSurface ?? 0;
  }

  /**
   * Get the grid dimensions (from Section 3).
   */
  get gridDimensions(): { ni: number; nj: number } {
    const s3 = this.section3;
    return {
      ni: s3.ni ?? 0,
      nj: s3.nj ?? 0,
    };
  }

  /**
   * Get the number of grid points (from Section 3).
   */
  get numPoints(): number {
    return this.section3.numberOfPoints;
  }

  // =========================================================================
  // Data Access Methods
  // =========================================================================

  /**
   * Get the grid data values.
   */
  getValues(): Float32Array {
    return getGridData(this._handle, this._index);
  }

  /**
   * Get the latitude coordinates.
   */
  getLatitudes(): Float32Array {
    return getLatitudes(this._handle, this._index);
  }

  /**
   * Get the longitude coordinates.
   */
  getLongitudes(): Float32Array {
    return getLongitudes(this._handle, this._index);
  }

  /**
   * Get both latitude and longitude coordinates.
   */
  getCoordinates(): { lats: Float32Array; lons: Float32Array } {
    return {
      lats: this.getLatitudes(),
      lons: this.getLongitudes(),
    };
  }
}

// =============================================================================
// RecordIterator Class
// =============================================================================

/**
 * Iterator for filtering and mapping over GRIB2 records.
 * Supports method chaining (lazy evaluation until toArray/first is called).
 */
export class RecordIterator implements Iterable<Grib2Record> {
  private readonly _records: Grib2Record[];

  constructor(records: Grib2Record[]) {
    this._records = records;
  }

  /**
   * Filter records based on a predicate function.
   */
  filter(predicate: (record: Grib2Record) => boolean): RecordIterator {
    return new RecordIterator(this._records.filter(predicate));
  }

  /**
   * Map records to another type.
   */
  map<T>(fn: (record: Grib2Record) => T): T[] {
    return this._records.map(fn);
  }

  /**
   * Convert to array.
   */
  toArray(): Grib2Record[] {
    return [...this._records];
  }

  /**
   * Get the first record, or undefined if empty.
   */
  first(): Grib2Record | undefined {
    return this._records[0];
  }

  /**
   * Get the number of records.
   */
  get length(): number {
    return this._records.length;
  }

  /**
   * Make iterable.
   */
  [Symbol.iterator](): Iterator<Grib2Record> {
    return this._records[Symbol.iterator]();
  }
}

// =============================================================================
// Factory Function
// =============================================================================

/**
 * Open a GRIB2 file from a Uint8Array.
 */
export function openGrib2(data: Uint8Array): Grib2File {
  const handle = parseGrib2(data);
  return new Grib2File(handle);
}
