/**
 * E2E tests for GRIB2 WASM module in browser environment.
 *
 * These tests verify that WASM-GC with js-string builtins works correctly
 * in Chrome 119+ browser environment.
 */

import { test, expect } from '@playwright/test';

test.describe('GRIB2 WASM Demo', () => {
  test('page loads and WASM initializes', async ({ page }) => {
    await page.goto('/');

    // Check page title
    await expect(page).toHaveTitle('GRIB2 WASM Demo');

    // Wait for WASM to initialize (status changes from "Initializing...")
    await expect(page.locator('#status')).not.toContainText('Initializing', {
      timeout: 10000,
    });

    // Should show success status
    await expect(page.locator('#status')).toHaveClass(/success/);
    // Case-insensitive check for "Ready"
    await expect(page.locator('#status')).toContainText(/Ready/i);
  });

  test('fixture buttons are enabled after WASM init', async ({ page }) => {
    await page.goto('/');

    // Wait for WASM to initialize
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 10000,
    });

    // Fixture buttons should be enabled
    await expect(page.locator('#loadMsm')).toBeEnabled();
    await expect(page.locator('#loadGsm')).toBeEnabled();
    await expect(page.locator('#fileInput')).toBeEnabled();
  });

  test('can parse GRIB2 file from fixture', async ({ page }) => {
    await page.goto('/');

    // Wait for WASM to initialize
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 10000,
    });

    // Click GSM fixture button (single file, faster)
    await page.locator('#loadGsm').click();

    // Wait for loading to complete - check for success class
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 30000,
    });

    // Should show loaded message
    await expect(page.locator('#status')).toContainText(/Loaded.*file/i, {
      timeout: 10000,
    });

    // Parameter select should be populated
    const paramSelect = page.locator('#paramSelect');
    await expect(paramSelect).toBeEnabled();

    // Should have options (more than just "No parameters found")
    const optionCount = await paramSelect.locator('option').count();
    expect(optionCount).toBeGreaterThan(1);
  });

  test('can render grid data on canvas', async ({ page }) => {
    await page.goto('/');

    // Wait for WASM to initialize
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 10000,
    });

    // Load GSM fixture
    await page.locator('#loadGsm').click();

    // Wait for loading to complete
    await expect(page.locator('#status')).toHaveClass(/success/, { timeout: 30000 });
    await expect(page.locator('#paramSelect')).toBeEnabled({ timeout: 30000 });

    // Wait for auto-selection to complete
    await page.waitForTimeout(1000);

    // If no param selected, select first available
    const selectedParam = await page.locator('#paramSelect').inputValue();
    if (!selectedParam) {
      await page.locator('#paramSelect').selectOption({ index: 0 });
      await page.waitForTimeout(500);
    }

    // If level selector is enabled, select an option
    const levelSelect = page.locator('#levelSelect');
    const levelEnabled = await levelSelect.isEnabled();
    if (levelEnabled) {
      const levelOptions = await levelSelect.locator('option').allTextContents();
      const has500 = levelOptions.some(opt => opt.includes('500'));
      if (has500) {
        await levelSelect.selectOption({ label: '500 mb' });
      } else if (levelOptions.length > 0) {
        await levelSelect.selectOption({ index: 0 });
      }
      await page.waitForTimeout(500);
    }

    // Wait for canvas to be rendered (check stats are visible)
    await expect(page.locator('#stats')).toBeVisible({ timeout: 15000 });

    // Stats should contain min/max values
    await expect(page.locator('#stats')).toContainText('Min:');
    await expect(page.locator('#stats')).toContainText('Max:');

    // Canvas should have been drawn (non-empty ImageData)
    const canvas = page.locator('#gridCanvas');
    const hasContent = await canvas.evaluate((el: HTMLCanvasElement) => {
      const ctx = el.getContext('2d');
      if (!ctx) return false;
      const imageData = ctx.getImageData(0, 0, el.width, el.height);
      // Check if there's any non-black pixel
      for (let i = 0; i < imageData.data.length; i += 4) {
        if (imageData.data[i] > 0 || imageData.data[i + 1] > 0 || imageData.data[i + 2] > 0) {
          return true;
        }
      }
      return false;
    });
    expect(hasContent).toBe(true);
  });

  test('stats display shows grid information', async ({ page }) => {
    await page.goto('/');

    // Wait for WASM to initialize
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 10000,
    });

    // Load GSM fixture
    await page.locator('#loadGsm').click();

    // Wait for loading to complete
    await expect(page.locator('#status')).toHaveClass(/success/, { timeout: 30000 });
    await expect(page.locator('#paramSelect')).toBeEnabled({ timeout: 30000 });

    // Wait for auto-selection to trigger render
    await page.waitForTimeout(500);

    // If level needs to be selected
    const levelSelect = page.locator('#levelSelect');
    if (await levelSelect.isEnabled()) {
      await levelSelect.selectOption({ index: 0 });
    }

    // Wait for stats to appear
    await expect(page.locator('#stats')).toBeVisible({ timeout: 15000 });

    // Verify stats content
    const statsText = await page.locator('#stats').textContent();
    expect(statsText).toContain('Grid:');
    expect(statsText).toContain('Min:');
    expect(statsText).toContain('Max:');
    expect(statsText).toContain('Mean:');
    expect(statsText).toContain('Valid:');
  });
});

test.describe('GRIB2 WASM Time Series', () => {
  test('can load MSM time series fixtures', async ({ page }) => {
    test.slow(); // MSM fixtures are large, may take time

    await page.goto('/');

    // Wait for WASM to initialize
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 10000,
    });

    // Click MSM fixture button
    await page.locator('#loadMsm').click();

    // Wait for all files to load
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 90000,
    });
    await expect(page.locator('#status')).toContainText(/Loaded.*file/i, {
      timeout: 10000,
    });

    // Wait for parameter/level selectors to be populated
    await expect(page.locator('#paramSelect')).toBeEnabled({ timeout: 10000 });
    await page.waitForTimeout(500);

    // Select a level to enable time controls
    const levelSelect = page.locator('#levelSelect');
    if (await levelSelect.isEnabled()) {
      await levelSelect.selectOption({ index: 0 });
    }

    // Time slider should be enabled with multiple steps
    const timeSlider = page.locator('#timeSlider');
    await expect(timeSlider).toBeEnabled({ timeout: 5000 });

    const maxValue = await timeSlider.getAttribute('max');
    expect(Number(maxValue)).toBeGreaterThan(0);

    // Play button should be enabled
    await expect(page.locator('#playBtn')).toBeEnabled();
  });

  test('time slider changes displayed data', async ({ page }) => {
    test.slow();

    await page.goto('/');

    // Wait for WASM to initialize and load MSM
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 10000,
    });
    await page.locator('#loadMsm').click();
    await expect(page.locator('#status')).toHaveClass(/success/, {
      timeout: 90000,
    });

    // Wait for selectors
    await expect(page.locator('#paramSelect')).toBeEnabled({ timeout: 10000 });
    await page.waitForTimeout(500);

    // Select a level to enable time controls
    const levelSelect = page.locator('#levelSelect');
    if (await levelSelect.isEnabled()) {
      await levelSelect.selectOption({ index: 0 });
    }

    // Wait for time slider to be enabled
    const timeSlider = page.locator('#timeSlider');
    await expect(timeSlider).toBeEnabled({ timeout: 5000 });

    // Get initial time value
    const initialTimeValue = await page.locator('#timeValue').textContent();

    // Move slider to a different position
    const maxValue = await timeSlider.getAttribute('max');
    if (Number(maxValue) >= 5) {
      await timeSlider.fill('5');
    } else if (Number(maxValue) >= 1) {
      await timeSlider.fill('1');
    }

    // Time value should update when slider changes
    await page.waitForTimeout(200);
    const newTimeValue = await page.locator('#timeValue').textContent();

    // Verify time display changed
    if (Number(maxValue) > 0) {
      const sliderValue = await timeSlider.inputValue();
      expect(Number(sliderValue)).toBeGreaterThan(0);

      // The time value should have changed (different forecast hour)
      // MSM has 0h, 1h, 2h... so moving slider should change the display
      expect(newTimeValue).not.toEqual(initialTimeValue);
    }
  });

  test('forecast time display shows different hours when slider moves', async ({ page }) => {
    test.slow();

    await page.goto('/');
    await expect(page.locator('#status')).toHaveClass(/success/, { timeout: 10000 });

    // Load MSM
    await page.locator('#loadMsm').click();
    await expect(page.locator('#status')).toHaveClass(/success/, { timeout: 90000 });

    // Wait for level select
    await expect(page.locator('#levelSelect')).toBeEnabled({ timeout: 10000 });
    await page.waitForTimeout(500);

    const timeSlider = page.locator('#timeSlider');
    await expect(timeSlider).toBeEnabled({ timeout: 5000 });

    // Collect time values at different slider positions
    const timeValues: string[] = [];
    const maxValue = Number(await timeSlider.getAttribute('max'));

    for (let i = 0; i <= Math.min(maxValue, 5); i++) {
      await timeSlider.fill(String(i));
      await page.waitForTimeout(100);
      const value = await page.locator('#timeValue').textContent();
      timeValues.push(value || '');
    }

    // Should have different forecast hours in MSM data
    const uniqueValues = new Set(timeValues);
    expect(uniqueValues.size).toBeGreaterThan(1);

    // Log for debugging
    console.log('Forecast times collected:', timeValues);
  });
});
