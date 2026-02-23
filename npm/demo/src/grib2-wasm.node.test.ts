/**
 * Node.js tests for GRIB2 WASM module.
 *
 * Note: The WASM-GC module with js-string builtins requires browser environment
 * (Chrome 119+, Firefox 120+). The WASM loading tests are skipped in Node.js
 * and should be run via Playwright E2E tests instead.
 */

import { describe, it, expect } from 'vitest';
import { bytesToLatin1, latin1ToBytes } from './grib2-browser';

// WASM-GC with js-string builtins is not fully supported in Node.js
// These tests require browser environment - run via Playwright E2E
describe.skip('GRIB2 WASM Module (Browser only)', () => {
  it('requires browser with WebAssembly GC and js-string builtins support', () => {
    // This test suite is skipped in Node.js
    // Run `npm run test:e2e` for browser-based WASM tests
    expect(true).toBe(true);
  });
});

describe('bytesToLatin1', () => {
  it('should convert Uint8Array to latin1 string', () => {
    const bytes = new Uint8Array([71, 82, 73, 66]); // "GRIB"
    const latin1 = bytesToLatin1(bytes);
    expect(latin1).toBe('GRIB');
  });

  it('should handle high byte values', () => {
    const bytes = new Uint8Array([0xFF, 0x00, 0x80, 0x7F]);
    const latin1 = bytesToLatin1(bytes);
    expect(latin1.charCodeAt(0)).toBe(255);
    expect(latin1.charCodeAt(1)).toBe(0);
    expect(latin1.charCodeAt(2)).toBe(128);
    expect(latin1.charCodeAt(3)).toBe(127);
  });

  it('should handle large arrays efficiently', () => {
    const size = 100000;
    const bytes = new Uint8Array(size);
    for (let i = 0; i < size; i++) bytes[i] = i % 256;

    const latin1 = bytesToLatin1(bytes);
    expect(latin1.length).toBe(size);
    expect(latin1.charCodeAt(0)).toBe(0);
    expect(latin1.charCodeAt(255)).toBe(255);
    expect(latin1.charCodeAt(256)).toBe(0);
  });
});
