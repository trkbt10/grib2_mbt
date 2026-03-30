#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

BUILD_EXE="_build/native/debug/build/cmd/main/main.exe"
COMPARE_EXE_DEFAULT="target/mbt_main_for_compare.exe"
MBT_CMD="${MBT_CMD:-$COMPARE_EXE_DEFAULT}"
TMP_MANIFEST="target/process_ncep_norm_cases.tsv"
SOURCE_MANIFEST="fixtures/wgrib2_snapshots/process/manifest_v2.tsv"
PATTERN='_ncep_norm_bin'

if [[ "${SKIP_BUILD:-0}" == "1" ]]; then
  echo "[1/3] skip build cmd/main"
  if [[ ! -x "$MBT_CMD" ]]; then
    echo "error: compare executable not found: $MBT_CMD" >&2
    echo "hint: run without SKIP_BUILD once, or set MBT_CMD to an executable path" >&2
    exit 1
  fi
else
  echo "[1/3] build cmd/main"
  moon build cmd/main --target native >/dev/null
  if [[ "${MBT_CMD}" == "${COMPARE_EXE_DEFAULT}" ]]; then
    cp "$BUILD_EXE" "$COMPARE_EXE_DEFAULT"
    chmod +x "$COMPARE_EXE_DEFAULT"
  fi
fi

echo "[2/3] write ncep_norm subset manifest"
{
  printf 'case_id\tfixture_id\tfixture_path\tprepare_cmd\twgrib2_cmd\tmbt_cmd\tcompare_mode\tnote\n'
  rg "$PATTERN" "$SOURCE_MANIFEST"
} > "$TMP_MANIFEST"
CASE_COUNT="$(($(wc -l < "$TMP_MANIFEST") - 1))"
echo "  cases=$CASE_COUNT manifest=$TMP_MANIFEST"

echo "[3/3] compare ncep_norm subset"
MANIFEST="$TMP_MANIFEST" MBT_CMD="$MBT_CMD" bash tools/compare_wgrib2_manifest_v2.sh
