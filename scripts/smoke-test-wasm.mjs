#!/usr/bin/env node
/**
 * WASM Smoke Test
 *
 * Verifies that the WASM module exports required functions.
 * This test prevents regressions by checking all expected exports.
 *
 * Uses WebAssembly.Module.exports() to check exports without full instantiation,
 * which is useful for WASM-GC modules that require js-string builtins.
 */

import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const REQUIRED_EXPORTS = [
  'parseGrib2',
  'getMessageCount',
  'getRecordCount',
  'getSection1',
  'getSection3',
  'getSection4',
  'getSection5',
  'getSection6',
  'getLatitudes',
  'getLongitudes',
  'getGridData',
];

async function runSmokeTest() {
  console.log('WASM Smoke Test');
  console.log('================');
  console.log('');

  const wasmPath = join(__dirname, '..', 'npm', 'grib2.wasm');

  console.log(`Loading WASM from: ${wasmPath}`);

  let wasmBuffer;
  try {
    wasmBuffer = readFileSync(wasmPath);
  } catch (err) {
    console.error(`Error: Failed to read WASM file: ${err.message}`);
    console.error('Run ./scripts/build-wasm.sh first');
    process.exit(1);
  }

  console.log(`WASM file size: ${(wasmBuffer.length / 1024).toFixed(1)} KB`);
  console.log('');

  // Compile module to check exports (without instantiation)
  let wasmModule;
  try {
    wasmModule = await WebAssembly.compile(wasmBuffer);
    console.log('WASM module compiled successfully');
  } catch (err) {
    console.error(`Error: Failed to compile WASM: ${err.message}`);
    process.exit(1);
  }

  // Get exports using WebAssembly.Module.exports()
  const moduleExports = WebAssembly.Module.exports(wasmModule);
  const exportMap = new Map(moduleExports.map(e => [e.name, e.kind]));

  console.log(`Total exports: ${moduleExports.length}`);
  console.log('');
  console.log('Checking required exports:');

  let allPassed = true;
  const missing = [];
  const found = [];

  for (const name of REQUIRED_EXPORTS) {
    const kind = exportMap.get(name);
    if (kind === 'function') {
      found.push(name);
      console.log(`  [OK] ${name}`);
    } else if (kind !== undefined) {
      console.log(`  [WARN] ${name} exists but is not a function (kind: ${kind})`);
      missing.push(name);
      allPassed = false;
    } else {
      console.log(`  [FAIL] ${name} - NOT FOUND`);
      missing.push(name);
      allPassed = false;
    }
  }

  console.log('');

  // List any extra function exports
  const extraExports = moduleExports.filter(
    e => !REQUIRED_EXPORTS.includes(e.name) && e.kind === 'function'
  );
  if (extraExports.length > 0) {
    console.log(`Additional function exports (${extraExports.length}):`);
    for (const exp of extraExports.slice(0, 10)) {
      console.log(`  - ${exp.name}`);
    }
    if (extraExports.length > 10) {
      console.log(`  ... and ${extraExports.length - 10} more`);
    }
    console.log('');
  }

  if (allPassed) {
    console.log(`All ${REQUIRED_EXPORTS.length} required exports found!`);
    console.log('');
    console.log('Smoke test PASSED');
    process.exit(0);
  } else {
    console.error('');
    console.error(`Missing exports: ${missing.join(', ')}`);
    console.error('');
    console.error('Smoke test FAILED');
    console.error('');
    console.error('Check that moon.pkg exports are configured correctly:');
    console.error('  - Verify moon.pkg "link.wasm-gc.exports" section');
    console.error('  - Ensure pub fn names match export names');
    process.exit(1);
  }
}

runSmokeTest().catch(err => {
  console.error('Unexpected error:', err);
  process.exit(1);
});
