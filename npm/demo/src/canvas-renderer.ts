/**
 * Canvas rendering utilities for GRIB2 grid data
 */

import { temperatureColormap, createColorScale, type RGB } from './colormap';

export interface RenderOptions {
  minValue?: number;
  maxValue?: number;
  colormap?: (t: number) => RGB;
}

/**
 * Render grid values to a canvas.
 * Values are normalized and mapped to colors using the colormap.
 */
export function renderGrid(
  canvas: HTMLCanvasElement,
  values: Array<number | null>,
  ni: number,
  nj: number,
  options: RenderOptions = {}
): void {
  const ctx = canvas.getContext('2d');
  if (!ctx) {
    throw new Error('Failed to get 2D context');
  }

  canvas.width = ni;
  canvas.height = nj;

  const imageData = ctx.createImageData(ni, nj);
  const data = imageData.data;

  // Calculate min/max if not provided
  let minVal = options.minValue;
  let maxVal = options.maxValue;

  if (minVal === undefined || maxVal === undefined) {
    let computedMin = Infinity;
    let computedMax = -Infinity;

    for (const v of values) {
      if (v !== null) {
        computedMin = Math.min(computedMin, v);
        computedMax = Math.max(computedMax, v);
      }
    }

    minVal = minVal ?? computedMin;
    maxVal = maxVal ?? computedMax;
  }

  const range = maxVal - minVal || 1;
  const colormap = options.colormap ?? temperatureColormap;

  // GRIB2 data is stored north to south (j=0 is north)
  // Canvas y=0 is also at top, so no Y flip needed
  for (let j = 0; j < nj; j++) {
    for (let i = 0; i < ni; i++) {
      const srcIdx = j * ni + i;
      const dstIdx = (j * ni + i) * 4;

      const value = values[srcIdx];

      if (value === null) {
        // Transparent for null values
        data[dstIdx] = 0;
        data[dstIdx + 1] = 0;
        data[dstIdx + 2] = 0;
        data[dstIdx + 3] = 0;
      } else {
        const normalized = (value - minVal) / range;
        const [r, g, b] = colormap(normalized);
        data[dstIdx] = r;
        data[dstIdx + 1] = g;
        data[dstIdx + 2] = b;
        data[dstIdx + 3] = 255;
      }
    }
  }

  ctx.putImageData(imageData, 0, 0);
}

/**
 * Draw a color scale legend on the canvas.
 */
export function drawColorScale(
  canvas: HTMLCanvasElement,
  minVal: number,
  maxVal: number,
  unit: string = ''
): void {
  const ctx = canvas.getContext('2d');
  if (!ctx) return;

  const width = 200;
  const height = 20;
  canvas.width = width + 60;
  canvas.height = height + 10;

  // Draw color scale
  const scaleData = createColorScale(width, height);
  ctx.putImageData(scaleData, 30, 5);

  // Draw labels
  ctx.fillStyle = '#333';
  ctx.font = '12px sans-serif';
  ctx.textAlign = 'right';
  ctx.fillText(minVal.toFixed(1), 28, height);
  ctx.textAlign = 'left';
  ctx.fillText(`${maxVal.toFixed(1)} ${unit}`, width + 32, height);
}

/**
 * Get the current canvas image as a data URL.
 */
export function canvasToDataURL(canvas: HTMLCanvasElement, format = 'image/png'): string {
  return canvas.toDataURL(format);
}

/**
 * Calculate statistics for grid values.
 */
export function calculateStats(values: Array<number | null>): {
  min: number;
  max: number;
  mean: number;
  validCount: number;
} {
  let min = Infinity;
  let max = -Infinity;
  let sum = 0;
  let count = 0;

  for (const v of values) {
    if (v !== null) {
      min = Math.min(min, v);
      max = Math.max(max, v);
      sum += v;
      count++;
    }
  }

  return {
    min: count > 0 ? min : 0,
    max: count > 0 ? max : 0,
    mean: count > 0 ? sum / count : 0,
    validCount: count
  };
}
