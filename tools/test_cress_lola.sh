#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

BUILD_EXE="_build/native/debug/build/cmd/main/main.exe"
COMPARE_EXE_DEFAULT="target/mbt_main_for_compare.exe"
MBT_CMD="${MBT_CMD:-$COMPARE_EXE_DEFAULT}"
TMP_MANIFEST="target/cress_lola_cases.tsv"

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

echo "[2/3] collect cress_lola subset manifest"
{
  printf 'case_id\tfixture_id\tfixture_path\tprepare_cmd\twgrib2_cmd\tmbt_cmd\tcompare_mode\tnote\n'
  rg '_cress_lola_' fixtures/wgrib2_snapshots/grid/manifest_v2.tsv
} > "$TMP_MANIFEST"
printf '  cases=%s\n' "$(($(wc -l < "$TMP_MANIFEST") - 1))"

echo "[3/3] compare cress_lola subset"
MANIFEST="$TMP_MANIFEST" MBT_CMD="$MBT_CMD" bash tools/compare_wgrib2_manifest_v2.sh
