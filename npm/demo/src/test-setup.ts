/**
 * Test setup file for Vitest
 * Polyfills browser APIs not available in jsdom
 */

// Polyfill ImageData if not available
if (typeof globalThis.ImageData === 'undefined') {
  class ImageDataPolyfill {
    readonly width: number
    readonly height: number
    readonly data: Uint8ClampedArray

    constructor(width: number, height: number) {
      this.width = width
      this.height = height
      this.data = new Uint8ClampedArray(width * height * 4)
    }
  }

  globalThis.ImageData = ImageDataPolyfill as unknown as typeof ImageData
}

// Polyfill MediaRecorder if not available
if (typeof globalThis.MediaRecorder === 'undefined') {
  globalThis.MediaRecorder = class {
    static isTypeSupported(_type: string): boolean {
      return false
    }
  } as unknown as typeof MediaRecorder
}
