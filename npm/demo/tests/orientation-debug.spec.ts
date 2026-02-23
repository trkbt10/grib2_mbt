/**
 * Debug test to verify map orientation
 */
import { test, expect } from '@playwright/test';

test('check MSM orientation', async ({ page }) => {
  test.setTimeout(120000);

  await page.goto('/');
  await expect(page.locator('#status')).toHaveClass(/success/, { timeout: 15000 });

  // Load MSM
  await page.locator('#loadMsm').click();
  await expect(page.locator('#status')).toHaveClass(/success/, { timeout: 120000 });

  await page.waitForFunction(() => {
    const select = document.querySelector('#paramSelect') as HTMLSelectElement;
    return select && !select.disabled && select.options.length > 1;
  }, { timeout: 30000 });

  await page.waitForTimeout(1000);

  // Get orientation info
  const info = await page.evaluate(async () => {
    const grib2 = await import('/src/grib2-browser.ts');

    const resp = await fetch('/fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin');
    const data = new Uint8Array(await resp.arrayBuffer());
    const handle = grib2.parseGrib2(data);
    const records = grib2.decodeRecords(handle);

    const tmpRecord = records.find((r: { parameterName: string; levelName: string }) =>
      r.parameterName.includes('TMP') && r.levelName.includes('500'));

    if (!tmpRecord) return { error: 'No TMP record found' };

    const grid = grib2.decodeRecordGrid(handle, tmpRecord.recordIndex);
    const values = grid.values;
    const ni = tmpRecord.section3Ni;
    const nj = tmpRecord.section3Nj;

    // Get corner values
    const topLeft = values[0];                    // GRIB2 index (0,0)
    const topRight = values[ni - 1];              // GRIB2 index (ni-1, 0)
    const bottomLeft = values[(nj - 1) * ni];     // GRIB2 index (0, nj-1)
    const bottomRight = values[nj * ni - 1];      // GRIB2 index (ni-1, nj-1)

    // Sample from different regions
    // If data is stored north-to-south, west-to-east:
    // - First row (j=0) should be northernmost
    // - Last row (j=nj-1) should be southernmost
    const firstRowAvg = values.slice(0, ni).reduce((a: number, b: number | null) => a + (b || 0), 0) / ni;
    const lastRowAvg = values.slice((nj - 1) * ni).reduce((a: number, b: number | null) => a + (b || 0), 0) / ni;

    return {
      ni,
      nj,
      lat1: tmpRecord.section3Lat1Microdeg / 1000000,
      lon1: tmpRecord.section3Lon1Microdeg / 1000000,
      lat2: tmpRecord.section3Lat2Microdeg / 1000000,
      lon2: tmpRecord.section3Lon2Microdeg / 1000000,
      corners: {
        grib2_0_0: topLeft,           // First point in GRIB2
        grib2_ni_0: topRight,         // End of first row
        grib2_0_nj: bottomLeft,       // Start of last row
        grib2_ni_nj: bottomRight      // Last point in GRIB2
      },
      rowAverages: {
        firstRow: firstRowAvg,        // j=0
        lastRow: lastRowAvg           // j=nj-1
      },
      // Expected: if north is colder at 500hPa, first row should be colder
      // (higher altitude = colder)
      interpretation: {
        firstRowColder: firstRowAvg < lastRowAvg,
        description: firstRowAvg < lastRowAvg
          ? 'First row is colder -> j=0 is NORTH (higher latitude = colder at 500hPa)'
          : 'Last row is colder -> j=nj-1 is NORTH'
      }
    };
  });

  console.log('=== MSM Orientation Debug ===');
  console.log(JSON.stringify(info, null, 2));

  // Take screenshot
  await page.screenshot({ path: 'test-results/msm-orientation.png', fullPage: true });
});
