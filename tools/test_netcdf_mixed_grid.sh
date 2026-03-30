#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

FIXTURE="fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
BUILD_EXE="_build/native/debug/build/cmd/main/main.exe"
COMPARE_EXE_DEFAULT="target/mbt_main_for_compare.exe"
MBT_CMD="${MBT_CMD:-$COMPARE_EXE_DEFAULT}"
TMP_MANIFEST="target/netcdf_jma_gsm_mixed_grid_cases.tsv"

if [[ "${SKIP_BUILD:-0}" == "1" ]]; then
  echo "[1/5] skip build cmd/main"
  if [[ ! -x "$MBT_CMD" ]]; then
    echo "error: compare executable not found: $MBT_CMD" >&2
    echo "hint: run without SKIP_BUILD once, or set MBT_CMD to an executable path" >&2
    exit 1
  fi
else
  echo "[1/5] build cmd/main"
  moon build cmd/main --target native >/dev/null
  if [[ "${MBT_CMD}" == "${COMPARE_EXE_DEFAULT}" ]]; then
    cp "$BUILD_EXE" "$COMPARE_EXE_DEFAULT"
    chmod +x "$COMPARE_EXE_DEFAULT"
  fi
fi

echo "[2/5] fresh mixed-grid fatal compare"
rm -f target/mixed_wgrib2.nc target/mixed_mbt.nc
set +e
wgrib2 "$FIXTURE" -for_n 1:79:1 -netcdf target/mixed_wgrib2.nc >/dev/null 2>&1
fresh_wgrib2_status=$?
"$MBT_CMD" "$FIXTURE" -for_n 1:79:1 -netcdf target/mixed_mbt.nc >/dev/null 2>&1
fresh_mbt_status=$?
cmp -s target/mixed_wgrib2.nc target/mixed_mbt.nc
fresh_cmp_status=$?
set -e
echo "  fresh_wgrib2=$fresh_wgrib2_status fresh_mbt=$fresh_mbt_status fresh_cmp=$fresh_cmp_status"

echo "[3/5] append mixed-grid fatal compare"
rm -f target/mixed_seed.nc target/mixed_append_wgrib2.nc target/mixed_append_mbt.nc
wgrib2 "$FIXTURE" -for_n 1:1:1 -netcdf target/mixed_seed.nc >/dev/null 2>&1
cp target/mixed_seed.nc target/mixed_append_wgrib2.nc
cp target/mixed_seed.nc target/mixed_append_mbt.nc
set +e
wgrib2 "$FIXTURE" -for_n 2:79:1 -append -netcdf target/mixed_append_wgrib2.nc >/dev/null 2>&1
append_wgrib2_status=$?
"$MBT_CMD" "$FIXTURE" -append -for_n 2:79:1 -netcdf target/mixed_append_mbt.nc >/dev/null 2>&1
append_mbt_status=$?
cmp -s target/mixed_append_wgrib2.nc target/mixed_append_mbt.nc
append_cmp_status=$?
set -e
echo "  append_wgrib2=$append_wgrib2_status append_mbt=$append_mbt_status append_cmp=$append_cmp_status"

echo "[4/5] subset manifest compare"
{
  printf 'case_id\tfixture_id\tfixture_path\tprepare_cmd\twgrib2_cmd\tmbt_cmd\tcompare_mode\tnote\n'
  rg 'jma_gsm_netcdf_mixed_grid_(fresh|append)_bin' fixtures/wgrib2_snapshots/netcdf/manifest_v2.tsv
} > "$TMP_MANIFEST"
MANIFEST="$TMP_MANIFEST" MBT_CMD="$MBT_CMD" bash tools/compare_wgrib2_manifest_v2.sh

echo "[5/5] done"
