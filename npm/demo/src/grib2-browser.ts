/**
 * ESM wrapper for GRIB2 WASM module (browser environment)
 *
 * Uses WebAssembly GC with js-string builtins for efficient string handling.
 */

import type { RecordMeta, RecordGrid } from './types';

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

/**
 * Decode records and return as objects.
 */
export function decodeRecords(handle: number): RecordMeta[] {
  const exports = getExports();
  const fn = exports.decodeRecordsJson as (h: number) => string;
  const jsonStr = fn(handle);
  if (!jsonStr) return [];
  return JSON.parse(jsonStr);
}

/**
 * Decode one record's grid-point values.
 */
export function decodeRecordGrid(handle: number, recordIndex: number): RecordGrid {
  const exports = getExports();
  const fn = exports.decodeRecordGridJson as (h: number, r: number) => string;
  const jsonStr = fn(handle, recordIndex);
  if (!jsonStr) {
    throw new Error('decodeRecordGridJson returned empty response');
  }
  const parsed = JSON.parse(jsonStr);
  if (parsed && parsed.error) {
    throw new Error(parsed.error);
  }
  return parsed;
}

/**
 * Inventory mode constants.
 */
export const InventoryMode = {
  DEFAULT: 0,
  SHORT: 1,
  SEC0: 2,
  SEC3: 3,
  SEC4: 4,
  SEC5: 5,
  SEC6: 6,
  SEC_LEN: 7,
  N: 8,
  RANGE: 9,
  VAR: 10,
  LEV: 11,
  FTIME: 12,
  GRID: 13,
  VAR_LEV: 14
} as const;

/**
 * Render inventory lines.
 */
export function renderInventory(handle: number, mode: number = InventoryMode.DEFAULT): string[] {
  const exports = getExports();
  const fn = exports.renderInventory as (h: number, m: number) => string;
  const jsonStr = fn(handle, mode);
  if (!jsonStr) return [];
  return JSON.parse(jsonStr);
}
