/**
 * Test script for Base64 binary transfer verification
 * Works with both Node.js and Bun
 */

import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

// Dynamically load WASM with js-string builtins support
async function loadWasm() {
  const wasmPath = join(__dirname, 'grib2.wasm');
  const wasmBuffer = readFileSync(wasmPath);

  // Check if running in Bun or Node.js
  const isBun = typeof Bun !== 'undefined';
  console.log(`Runtime: ${isBun ? 'Bun' : 'Node.js'}`);

  try {
    // Try with js-string builtins (requires Node 22+ or Bun with WASM-GC support)
    const result = await WebAssembly.instantiate(wasmBuffer, {}, {
      builtins: ['js-string'],
      importedStringConstants: '_'
    });
    return result.instance;
  } catch (e) {
    console.error('Failed to load WASM with js-string builtins:', e.message);
    console.error('Ensure Node.js 22+ with --experimental-wasm-jspi or Bun with WASM-GC support');
    process.exit(1);
  }
}

/**
 * Convert Uint8Array to latin1 string
 */
function bytesToLatin1(bytes) {
  const chunks = [];
  const CHUNK = 8192;
  for (let i = 0; i < bytes.length; i += CHUNK) {
    chunks.push(String.fromCharCode.apply(null, Array.from(bytes.subarray(i, i + CHUNK))));
  }
  return chunks.join('');
}

/**
 * Decode Base64 to Float32Array (browser/Node.js/Bun compatible)
 */
function decodeBase64ToFloat32Array(base64) {
  const binaryStr = atob(base64);
  const bytes = new Uint8Array(binaryStr.length);
  for (let i = 0; i < binaryStr.length; i++) {
    bytes[i] = binaryStr.charCodeAt(i);
  }
  return new Float32Array(bytes.buffer);
}

async function main() {
  console.log('=== Base64 Binary Transfer Test ===\n');

  const instance = await loadWasm();
  const exports = instance.exports;

  // Load test GRIB2 file
  const gribPath = join(__dirname, '../fixtures/grib2_jpeg2000/eccodes_jpeg.grib2');
  const gribData = readFileSync(gribPath);
  const latin1 = bytesToLatin1(gribData);

  console.log(`Test file: ${gribPath}`);
  console.log(`File size: ${gribData.length} bytes\n`);

  // Parse GRIB2
  const handle = exports.parseGrib2(latin1);
  if (handle < 0) {
    console.error('Failed to parse GRIB2 file');
    process.exit(1);
  }

  const recordCount = exports.getRecordCount(handle);
  console.log(`Record count: ${recordCount}\n`);

  // Test both JSON and Base64 methods
  for (let i = 1; i <= Math.min(recordCount, 3); i++) {
    console.log(`--- Record ${i} ---`);

    // JSON method
    console.time('JSON decode');
    const jsonResult = exports.decodeRecordGridJson(handle, i);
    console.timeEnd('JSON decode');
    const jsonParsed = JSON.parse(jsonResult);

    // Base64 method
    console.time('Base64 decode');
    const base64Result = exports.decodeRecordGridBase64(handle, i);
    console.timeEnd('Base64 decode');
    const base64Parsed = JSON.parse(base64Result);

    // Decode Base64 to Float32Array
    console.time('Base64 to Float32');
    const float32 = decodeBase64ToFloat32Array(base64Parsed.valuesBase64);
    console.timeEnd('Base64 to Float32');

    // Compare sizes
    const jsonSize = jsonResult.length;
    const base64Size = base64Result.length;
    const reduction = ((jsonSize - base64Size) / jsonSize * 100).toFixed(1);

    console.log(`JSON size: ${jsonSize} bytes`);
    console.log(`Base64 size: ${base64Size} bytes`);
    console.log(`Size reduction: ${reduction}%`);
    console.log(`Num points: ${jsonParsed.numPoints}`);

    // Verify values match (allowing Float32 precision loss)
    const jsonValues = jsonParsed.values;
    let mismatch = 0;
    for (let j = 0; j < Math.min(jsonValues.length, float32.length); j++) {
      const jsonVal = jsonValues[j];
      const binVal = float32[j];
      const jsonIsNull = jsonVal === null;
      const binIsNaN = Number.isNaN(binVal);

      if (jsonIsNull !== binIsNaN) {
        mismatch++;
      } else if (!jsonIsNull) {
        // Allow relative error of 1e-6 for Float32 precision
        const relErr = Math.abs(jsonVal - binVal) / (Math.abs(jsonVal) + 1e-10);
        if (relErr > 1e-6) {
          mismatch++;
        }
      }
    }

    if (mismatch === 0) {
      console.log('Values match: OK');
    } else {
      console.log(`Values mismatch: ${mismatch} differences`);
    }
    console.log('');
  }

  console.log('=== Test Complete ===');
}

main().catch(console.error);
