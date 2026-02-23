#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${1:-${ROOT_DIR}/fixtures/grib2_jpeg2000}"
TMP_DIR="${TMPDIR:-/tmp}/grib2_jpeg2000_fetch"

ECCODES_TEST_DATA_URL="${ECCODES_TEST_DATA_URL:-https://sites.ecmwf.int/repository/eccodes/test-data/eccodes_test_data.tar.gz}"
WGRIB2_BIN="${WGRIB2_BIN:-$(command -v wgrib2 || true)}"

mkdir -p "${OUT_DIR}" "${TMP_DIR}"

echo "[1/3] download ecCodes test data archive"
curl -fsSL "${ECCODES_TEST_DATA_URL}" -o "${TMP_DIR}/eccodes_test_data.tar.gz"

echo "[2/3] extract JPEG2000-focused fixtures from ecCodes archive"
tar -xzf "${TMP_DIR}/eccodes_test_data.tar.gz" -C "${TMP_DIR}" \
  data/jpeg.grib2 \
  data/reduced_gaussian_surface_jpeg.grib2
cp "${TMP_DIR}/data/jpeg.grib2" "${OUT_DIR}/eccodes_jpeg.grib2"
cp "${TMP_DIR}/data/reduced_gaussian_surface_jpeg.grib2" "${OUT_DIR}/eccodes_reduced_gaussian_surface_jpeg.grib2"

echo "[3/3] verify Section 5 template numbers (optional; requires wgrib2)"
if [[ -n "${WGRIB2_BIN}" ]]; then
  for f in \
  "${OUT_DIR}/eccodes_jpeg.grib2" \
  "${OUT_DIR}/eccodes_reduced_gaussian_surface_jpeg.grib2"; do
    echo "---- $(basename "${f}")"
    "${WGRIB2_BIN}" "${f}" -Sec5 | sed -n '1,5p'
  done
else
  echo "wgrib2 not found; skipped Section 5 verification"
fi

echo "done: fixtures are in ${OUT_DIR}"
