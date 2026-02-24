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


// =============================================================================
// Section Accessor Functions (Low-Level API)
// =============================================================================

/**
 * Convert latin1 string to Float32Array (little-endian).
 */
function latin1ToFloat32Array(latin1) {
  const bytes = new Uint8Array(latin1.length);
  for (let i = 0; i < latin1.length; i++) {
    bytes[i] = latin1.charCodeAt(i);
  }
  return new Float32Array(bytes.buffer);
}

/**
 * Get Section 1 (Identification Section) data.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} messageIndex - 0-based message index
 * @returns {Object} - Section 1 data
 */
function getSection1(handle, messageIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }
  const exports = wasmInstance.exports;
  if (exports.getSection1) {
    const jsonStr = exports.getSection1(handle, messageIndex);
    if (!jsonStr) {
      throw new Error('getSection1 returned empty response');
    }
    const parsed = JSON.parse(jsonStr);
    if (parsed && parsed.error) {
      throw new Error(parsed.error);
    }
    return parsed;
  }
  throw new Error('getSection1 export not found');
}

/**
 * Get Section 3 (Grid Definition Section) data.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} recordIndex - 1-based record index
 * @returns {Object} - Section 3 data
 */
function getSection3(handle, recordIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }
  const exports = wasmInstance.exports;
  if (exports.getSection3) {
    const jsonStr = exports.getSection3(handle, recordIndex);
    if (!jsonStr) {
      throw new Error('getSection3 returned empty response');
    }
    const parsed = JSON.parse(jsonStr);
    if (parsed && parsed.error) {
      throw new Error(parsed.error);
    }
    return parsed;
  }
  throw new Error('getSection3 export not found');
}

/**
 * Get Section 4 (Product Definition Section) data.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} recordIndex - 1-based record index
 * @returns {Object} - Section 4 data
 */
function getSection4(handle, recordIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }
  const exports = wasmInstance.exports;
  if (exports.getSection4) {
    const jsonStr = exports.getSection4(handle, recordIndex);
    if (!jsonStr) {
      throw new Error('getSection4 returned empty response');
    }
    const parsed = JSON.parse(jsonStr);
    if (parsed && parsed.error) {
      throw new Error(parsed.error);
    }
    return parsed;
  }
  throw new Error('getSection4 export not found');
}

/**
 * Get Section 5 (Data Representation Section) data.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} recordIndex - 1-based record index
 * @returns {Object} - Section 5 data
 */
function getSection5(handle, recordIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }
  const exports = wasmInstance.exports;
  if (exports.getSection5) {
    const jsonStr = exports.getSection5(handle, recordIndex);
    if (!jsonStr) {
      throw new Error('getSection5 returned empty response');
    }
    const parsed = JSON.parse(jsonStr);
    if (parsed && parsed.error) {
      throw new Error(parsed.error);
    }
    return parsed;
  }
  throw new Error('getSection5 export not found');
}

/**
 * Get Section 6 (Bit-Map Section) data.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} recordIndex - 1-based record index
 * @returns {Object} - Section 6 data
 */
function getSection6(handle, recordIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }
  const exports = wasmInstance.exports;
  if (exports.getSection6) {
    const jsonStr = exports.getSection6(handle, recordIndex);
    if (!jsonStr) {
      throw new Error('getSection6 returned empty response');
    }
    const parsed = JSON.parse(jsonStr);
    if (parsed && parsed.error) {
      throw new Error(parsed.error);
    }
    return parsed;
  }
  throw new Error('getSection6 export not found');
}

/**
 * Get latitude coordinates for a record's grid.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} recordIndex - 1-based record index
 * @returns {Float32Array} - Latitude values in degrees
 */
function getLatitudes(handle, recordIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }
  const exports = wasmInstance.exports;
  if (exports.getLatitudes) {
    const latin1 = exports.getLatitudes(handle, recordIndex);
    if (!latin1) {
      throw new Error('getLatitudes returned empty response');
    }
    return latin1ToFloat32Array(latin1);
  }
  throw new Error('getLatitudes export not found');
}

/**
 * Get longitude coordinates for a record's grid.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} recordIndex - 1-based record index
 * @returns {Float32Array} - Longitude values in degrees
 */
function getLongitudes(handle, recordIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }
  const exports = wasmInstance.exports;
  if (exports.getLongitudes) {
    const latin1 = exports.getLongitudes(handle, recordIndex);
    if (!latin1) {
      throw new Error('getLongitudes returned empty response');
    }
    return latin1ToFloat32Array(latin1);
  }
  throw new Error('getLongitudes export not found');
}

/**
 * Get grid data values for a record.
 *
 * @param {number} handle - Context handle from parseGrib2
 * @param {number} recordIndex - 1-based record index
 * @returns {Float32Array} - Grid data values
 */
function getGridData(handle, recordIndex) {
  if (!wasmInstance) {
    throw new Error('WASM module not initialized. Call init() first.');
  }
  const exports = wasmInstance.exports;
  if (exports.getGridData) {
    const latin1 = exports.getGridData(handle, recordIndex);
    if (!latin1) {
      throw new Error('getGridData returned empty response');
    }
    return latin1ToFloat32Array(latin1);
  }
  throw new Error('getGridData export not found');
}

module.exports = {
  init,
  initBrowser,
  parseGrib2,
  getMessageCount,
  getRecordCount,
  // Low-level section accessor functions
  getSection1,
  getSection3,
  getSection4,
  getSection5,
  getSection6,
  getLatitudes,
  getLongitudes,
  getGridData
};
