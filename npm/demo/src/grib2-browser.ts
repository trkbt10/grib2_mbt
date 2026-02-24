/**
 * ESM wrapper for GRIB2 WASM module (browser environment)
 *
 * Uses WebAssembly GC with js-string builtins for efficient string handling.
 */

import type {
  Section1Data,
  Section3Data,
  Section4Data,
  Section5Data,
  Section6Data,
} from './types';

let wasmInstance: WebAssembly.Instance | null = null;

/**
 * Convert Uint8Array to latin1 string (each byte -> char code 0-255).
 */
export function bytesToLatin1(bytes: Uint8Array): string {
  const chunks: string[] = [];
  const CHUNK = 8192;
  for (let i = 0; i < bytes.length; i += CHUNK) {
    chunks.push(
      String.fromCharCode.apply(null, Array.from(bytes.subarray(i, i + CHUNK))),
    );
  }
  return chunks.join('');
}

/**
 * Convert latin1 string back to Uint8Array.
 */
export function latin1ToBytes(str: string): Uint8Array {
  const bytes = new Uint8Array(str.length);
  for (let i = 0; i < str.length; i++) {
    bytes[i] = str.charCodeAt(i);
  }
  return bytes;
}

/**
 * Initialize the WASM module for browser environment.
 * Uses WebAssembly GC with js-string builtins.
 */
export async function initBrowser(wasmUrl: string | URL): Promise<void> {
  if (wasmInstance) return;

  const result = await WebAssembly.instantiateStreaming(
    fetch(wasmUrl),
    {},
    // @ts-expect-error wasm-gc builtins not yet in TypeScript types
    { builtins: ['js-string'], importedStringConstants: '_' },
  );
  wasmInstance = result.instance;
}

/**
 * Check if WASM is initialized.
 */
export function isInitialized(): boolean {
  return wasmInstance !== null;
}

/**
 * Get the WASM exports object.
 */
function getExports(): Record<string, unknown> {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call initBrowser() first.');
  }
  return wasmInstance.exports as Record<string, unknown>;
}

/**
 * Parse GRIB2 data from a Uint8Array.
 * Converts data to latin1 string for WASM-GC compatibility.
 */
export function parseGrib2(data: Uint8Array): number {
  const exports = getExports();
  const fn = exports.parseGrib2 as (data: string) => number;
  const latin1 = bytesToLatin1(data);
  return fn(latin1);
}

/**
 * Get the number of records in a parsed GRIB2 file.
 */
export function getRecordCount(handle: number): number {
  const exports = getExports();
  const fn = exports.getRecordCount as (h: number) => number;
  return fn(handle);
}

// =============================================================================
// Section Accessor Functions (Low-Level API)
// =============================================================================

/**
 * Convert latin1 string to Float32Array (little-endian).
 */
function latin1ToFloat32Array(latin1: string): Float32Array {
  const bytes = new Uint8Array(latin1.length);
  for (let i = 0; i < latin1.length; i++) {
    bytes[i] = latin1.charCodeAt(i);
  }
  return new Float32Array(bytes.buffer);
}

/**
 * Get Section 1 (Identification Section) data.
 * @param handle - Context handle from parseGrib2
 * @param messageIndex - 0-based message index
 */
export function getSection1(handle: number, messageIndex: number): Section1Data {
  const exports = getExports();
  const fn = exports.getSection1 as (h: number, m: number) => string;
  const jsonStr = fn(handle, messageIndex);
  if (!jsonStr) {
    throw new Error('getSection1 returned empty response');
  }
  const parsed = JSON.parse(jsonStr);
  if (parsed && parsed.error) {
    throw new Error(parsed.error);
  }
  return parsed;
}

/**
 * Get Section 3 (Grid Definition Section) data.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 */
export function getSection3(handle: number, recordIndex: number): Section3Data {
  const exports = getExports();
  const fn = exports.getSection3 as (h: number, r: number) => string;
  const jsonStr = fn(handle, recordIndex);
  if (!jsonStr) {
    throw new Error('getSection3 returned empty response');
  }
  const parsed = JSON.parse(jsonStr);
  if (parsed && parsed.error) {
    throw new Error(parsed.error);
  }
  return parsed;
}

/**
 * Get Section 4 (Product Definition Section) data.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 */
export function getSection4(handle: number, recordIndex: number): Section4Data {
  const exports = getExports();
  const fn = exports.getSection4 as (h: number, r: number) => string;
  const jsonStr = fn(handle, recordIndex);
  if (!jsonStr) {
    throw new Error('getSection4 returned empty response');
  }
  const parsed = JSON.parse(jsonStr);
  if (parsed && parsed.error) {
    throw new Error(parsed.error);
  }
  return parsed;
}

/**
 * Get Section 5 (Data Representation Section) data.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 */
export function getSection5(handle: number, recordIndex: number): Section5Data {
  const exports = getExports();
  const fn = exports.getSection5 as (h: number, r: number) => string;
  const jsonStr = fn(handle, recordIndex);
  if (!jsonStr) {
    throw new Error('getSection5 returned empty response');
  }
  const parsed = JSON.parse(jsonStr);
  if (parsed && parsed.error) {
    throw new Error(parsed.error);
  }
  return parsed;
}

/**
 * Get Section 6 (Bit-Map Section) data.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 */
export function getSection6(handle: number, recordIndex: number): Section6Data {
  const exports = getExports();
  const fn = exports.getSection6 as (h: number, r: number) => string;
  const jsonStr = fn(handle, recordIndex);
  if (!jsonStr) {
    throw new Error('getSection6 returned empty response');
  }
  const parsed = JSON.parse(jsonStr);
  if (parsed && parsed.error) {
    throw new Error(parsed.error);
  }
  return parsed;
}

/**
 * Get latitude coordinates for a record's grid.
 * Uses efficient latin1 binary transfer.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 */
export function getLatitudes(handle: number, recordIndex: number): Float32Array {
  const exports = getExports();
  const fn = exports.getLatitudes as (h: number, r: number) => string;
  const latin1 = fn(handle, recordIndex);
  if (!latin1) {
    throw new Error('getLatitudes returned empty response');
  }
  return latin1ToFloat32Array(latin1);
}

/**
 * Get longitude coordinates for a record's grid.
 * Uses efficient latin1 binary transfer.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 */
export function getLongitudes(handle: number, recordIndex: number): Float32Array {
  const exports = getExports();
  const fn = exports.getLongitudes as (h: number, r: number) => string;
  const latin1 = fn(handle, recordIndex);
  if (!latin1) {
    throw new Error('getLongitudes returned empty response');
  }
  return latin1ToFloat32Array(latin1);
}

/**
 * Get grid data values for a record.
 * Uses efficient latin1 binary transfer.
 * @param handle - Context handle from parseGrib2
 * @param recordIndex - 1-based record index
 */
export function getGridData(handle: number, recordIndex: number): Float32Array {
  const exports = getExports();
  const fn = exports.getGridData as (h: number, r: number) => string;
  const latin1 = fn(handle, recordIndex);
  if (!latin1) {
    throw new Error('getGridData returned empty response');
  }
  return latin1ToFloat32Array(latin1);
}
