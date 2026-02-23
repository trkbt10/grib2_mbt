/**
 * GRIB2 WASM Module Type Definitions
 */

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

/**
 * Record metadata from a GRIB2 file.
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

/**
 * Decode records and return as objects.
 * @param handle - Context handle from parseGrib2
 * @returns Array of record metadata objects
 */
export function decodeRecords(handle: number): RecordMeta[];

/**
 * Inventory mode constants.
 */
export const InventoryMode: {
  readonly DEFAULT: 0;
  readonly SHORT: 1;
  readonly SEC0: 2;
  readonly SEC3: 3;
  readonly SEC4: 4;
  readonly SEC5: 5;
  readonly SEC6: 6;
  readonly SEC_LEN: 7;
  readonly N: 8;
  readonly RANGE: 9;
  readonly VAR: 10;
  readonly LEV: 11;
  readonly FTIME: 12;
  readonly GRID: 13;
  readonly VAR_LEV: 14;
};

/**
 * Render inventory lines.
 * @param handle - Context handle from parseGrib2
 * @param mode - Inventory mode (use InventoryMode constants)
 * @returns Array of inventory lines
 */
export function renderInventory(handle: number, mode?: number): string[];
