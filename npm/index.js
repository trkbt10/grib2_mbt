/**
 * GRIB2 WASM Module Loader
 *
 * This module provides a JavaScript interface to the GRIB2 parser
 * compiled from MoonBit to WebAssembly.
 */

const fs = require('fs');
const path = require('path');

let wasmModule = null;
let wasmInstance = null;

/**
 * Initialize the WASM module.
 * Must be called before using any other functions.
 *
 * @returns {Promise<void>}
 */
async function init() {
  if (wasmInstance) return;

  const wasmPath = path.join(__dirname, 'grib2.wasm');
  const wasmBuffer = fs.readFileSync(wasmPath);

  const importObject = {
    env: {
      // Add any required imports here
    }
  };

  const result = await WebAssembly.instantiate(wasmBuffer, importObject);
  wasmModule = result.module;
  wasmInstance = result.instance;
}

/**
 * Initialize the WASM module for browser environment.
 *
 * @param {string|URL} wasmUrl - URL to the WASM file
 * @returns {Promise<void>}
 */
async function initBrowser(wasmUrl) {
  if (wasmInstance) return;

  const importObject = {
    env: {}
  };

  const result = await WebAssembly.instantiateStreaming(fetch(wasmUrl), importObject);
  wasmModule = result.module;
  wasmInstance = result.instance;
}

/**
 * Parse GRIB2 data from a Uint8Array.
 *
 * @param {Uint8Array} data - GRIB2 file contents
 * @returns {number} - Handle to the parsed context, or -1 on error
 */
function parseGrib2(data) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }

  // Note: Actual implementation depends on how MoonBit exports handle Bytes
  // This is a placeholder that shows the intended interface
  const exports = wasmInstance.exports;
  if (exports.parseGrib2) {
    return exports.parseGrib2(data);
  }
  throw new Error('parseGrib2 export not found');
}

/**
 * Get the number of messages in a parsed GRIB2 file.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @returns {number} - Number of messages, or -1 on error
 */
function getMessageCount(handle) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }

  const exports = wasmInstance.exports;
  if (exports.getMessageCount) {
    return exports.getMessageCount(handle);
  }
  throw new Error('getMessageCount export not found');
}

/**
 * Get the number of records in a parsed GRIB2 file.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @returns {number} - Number of records, or -1 on error
 */
function getRecordCount(handle) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }

  const exports = wasmInstance.exports;
  if (exports.getRecordCount) {
    return exports.getRecordCount(handle);
  }
  throw new Error('getRecordCount export not found');
}

/**
 * Decode records and return as JSON.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @returns {Array<Object>} - Array of record metadata objects
 */
function decodeRecords(handle) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }

  const exports = wasmInstance.exports;
  if (exports.decodeRecordsJson) {
    const jsonStr = exports.decodeRecordsJson(handle);
    if (!jsonStr) return [];
    return JSON.parse(jsonStr);
  }
  throw new Error('decodeRecordsJson export not found');
}

/**
 * Inventory mode constants.
 */
const InventoryMode = {
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
};

/**
 * Render inventory lines.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} mode - Inventory mode (use InventoryMode constants)
 * @returns {Array<string>} - Array of inventory lines
 */
function renderInventory(handle, mode = InventoryMode.DEFAULT) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }

  const exports = wasmInstance.exports;
  if (exports.renderInventory) {
    const jsonStr = exports.renderInventory(handle, mode);
    if (!jsonStr) return [];
    return JSON.parse(jsonStr);
  }
  throw new Error('renderInventory export not found');
}

/**
 * Decode a record's grid-point values.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} recordIndex - 1-based record index
 * @returns {Object} - Decoded grid data
 */
function decodeRecordGrid(handle, recordIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }

  const exports = wasmInstance.exports;
  if (exports.decodeRecordGridJson) {
    const jsonStr = exports.decodeRecordGridJson(handle, recordIndex);
    if (!jsonStr) {
      throw new Error('decodeRecordGridJson returned empty response');
    }
    const parsed = JSON.parse(jsonStr);
    if (parsed && parsed.error) {
      throw new Error(parsed.error);
    }
    return parsed;
  }
  throw new Error('decodeRecordGridJson export not found');
}

module.exports = {
  init,
  initBrowser,
  parseGrib2,
  getMessageCount,
  getRecordCount,
  decodeRecords,
  decodeRecordGrid,
  renderInventory,
  InventoryMode
};
