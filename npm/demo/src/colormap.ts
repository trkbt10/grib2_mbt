/**
 * Temperature colormap: Blue (cold) → White (mid) → Red (warm)
 */

export type RGB = [number, number, number];

/**
 * Convert normalized temperature (0-1) to RGB color.
 * 0.0 = cold (blue), 0.5 = mid (white), 1.0 = warm (red)
 */
export function temperatureColormap(t: number): RGB {
  t = Math.max(0, Math.min(1, t));

  if (t < 0.5) {
    // Blue to White (0.0 → 0.5)
    const ratio = t * 2;
    return [
      Math.round(ratio * 255),
      Math.round(ratio * 255),
      255
    ];
  } else {
    // White to Red (0.5 → 1.0)
    const ratio = (t - 0.5) * 2;
    return [
      255,
      Math.round((1 - ratio) * 255),
      Math.round((1 - ratio) * 255)
    ];
  }
}

/**
 * Convert temperature in Kelvin to a color.
 * Uses typical atmospheric temperature range for normalization.
 */
export function temperatureKelvinToColor(tempK: number, minK = 220, maxK = 320): RGB {
  const normalized = (tempK - minK) / (maxK - minK);
  return temperatureColormap(normalized);
}

/**
 * Create a color scale for display.
 */
export function createColorScale(width: number, height: number): ImageData {
  const imageData = new ImageData(width, height);
  const data = imageData.data;

  for (let x = 0; x < width; x++) {
    const t = x / (width - 1);
    const [r, g, b] = temperatureColormap(t);

    for (let y = 0; y < height; y++) {
      const idx = (y * width + x) * 4;
      data[idx] = r;
      data[idx + 1] = g;
      data[idx + 2] = b;
      data[idx + 3] = 255;
    }
  }

  return imageData;
}
