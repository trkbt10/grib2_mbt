/**
 * GRIB2 WASM Module Type Definitions
 */

// =============================================================================
// Section Data Types (Low-Level API)
// =============================================================================

/**
 * Section 1: Identification Section data
 */
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

/**
 * Section 3: Grid Definition Section data
 */
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

/**
 * Section 4: Product Definition Section data
 */
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

/**
 * Section 5: Data Representation Section data
 */
export interface Section5Data {
  template: number;
  numberOfPoints: number;
  referenceValue?: number;
  binaryScaleFactor?: number;
  decimalScaleFactor?: number;
  bitsPerValue?: number;
}

/**
 * Section 6: Bit-Map Section data
 */
export interface Section6Data {
  bitmapIndicator: number;
}

// =============================================================================
// Initialization Functions
// =============================================================================

/**
 * Initialize the WASM module (Node.js).
 * Must be called before using any other functions.
 */
export function init(): Promise<void>;

/**
 * Initialize the WASM module (Browser).
 * @param wasmUrl - URL to the WASM file
 */
export function initBrowser(wasmUrl: string | URL): Promise<void>;

/**
 * Parse GRIB2 data from a Uint8Array.
 * @param data - GRIB2 file contents
 * @returns Handle to the parsed context, or -1 on error
 */
export function parseGrib2(data: Uint8Array): number;

/**
 * Get the number of messages in a parsed GRIB2 file.
 * @param handle - Context handle from parseGrib2
 * @returns Number of messages, or -1 on error
 */
export function getMessageCount(handle: number): number;

/**
 * Get the number of records in a parsed GRIB2 file.
 * @param handle - Context handle from parseGrib2
 * @returns Number of records, or -1 on error
 */
export function getRecordCount(handle: number): number;

// =============================================================================
// Section Accessor Functions (Low-Level API)
// =============================================================================

/**
 * Get Section 1 (Identification Section) data.
 * @param handle - Context handle from parseGrib2
 * @param messageIndex - 0-based message index
 * @returns Section 1 data
 */
export function getSection1(handle: number, messageIndex: number): Section1Data;

/**
 * Get Section 3 (Grid Definition Section) data.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 * @returns Section 3 data
 */
export function getSection3(handle: number, recordIndex: number): Section3Data;

/**
 * Get Section 4 (Product Definition Section) data.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 * @returns Section 4 data
 */
export function getSection4(handle: number, recordIndex: number): Section4Data;

/**
 * Get Section 5 (Data Representation Section) data.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 * @returns Section 5 data
 */
export function getSection5(handle: number, recordIndex: number): Section5Data;

/**
 * Get Section 6 (Bit-Map Section) data.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 * @returns Section 6 data
 */
export function getSection6(handle: number, recordIndex: number): Section6Data;

/**
 * Get latitude coordinates for a record's grid.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 * @returns Float32Array of latitude values in degrees
 */
export function getLatitudes(handle: number, recordIndex: number): Float32Array;

/**
 * Get longitude coordinates for a record's grid.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 * @returns Float32Array of longitude values in degrees
 */
export function getLongitudes(handle: number, recordIndex: number): Float32Array;

/**
 * Get grid data values for a record.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 * @returns Float32Array of grid data values
 */
export function getGridData(handle: number, recordIndex: number): Float32Array;
