#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WGRIB2_BIN="${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2}"
OUT_DIR="fixtures/grib2_derived"

if [[ ! -x "${WGRIB2_BIN}" ]]; then
  echo "error: wgrib2 not found or not executable: ${WGRIB2_BIN}" >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"

scan_source="fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
bitmap_source="fixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2"

scan32_out="${OUT_DIR}/noaa_gfs_pgrb2_scan32_record1.grib2"
scan48_out="${OUT_DIR}/noaa_gfs_pgrb2_scan48_record1.grib2"
bitmap254_out="${OUT_DIR}/noaa_gfswave_global_bitmap254_records5_6.grib2"

echo "generating derived fixture: ${scan32_out}"
"${WGRIB2_BIN}" "${scan_source}" \
  -for_n 1:1 \
  -set_grib_type simple \
  -set_flag_table_3.4 32 \
  -rpn 2raw \
  -grib_out "${scan32_out}" \
  >/dev/null

echo "generating derived fixture: ${scan48_out}"
"${WGRIB2_BIN}" "${scan_source}" \
  -for_n 1:1 \
  -set_grib_type simple \
  -set_flag_table_3.4 48 \
  -rpn 2raw \
  -grib_out "${scan48_out}" \
  >/dev/null

echo "generating derived fixture: ${bitmap254_out}"
"${WGRIB2_BIN}" "${bitmap_source}" \
  -for_n 5:6 \
  -tosubmsg "${bitmap254_out}" \
  >/dev/null

bitmap254_sec6="$("${WGRIB2_BIN}" "${bitmap254_out}" -Sec6)"
if ! printf '%s\n' "${bitmap254_sec6}" | rg -q '^1\.2:0:Sec6 length 129786 bitmap indicator 0$'; then
  echo "error: wgrib2 did not accept derived bitmap reuse fixture: ${bitmap254_out}" >&2
  printf '%s\n' "${bitmap254_sec6}" >&2
  exit 1
fi

bitmap254_marker_count="$(xxd -p "${bitmap254_out}" | tr -d '\n' | rg -o '0000000606fe' -c)"
bitmap254_size="$(wc -c < "${bitmap254_out}" | tr -d ' ')"
if [[ "${bitmap254_marker_count}" -lt 1 ]]; then
  echo "error: failed to locate raw Sec6 repeat marker in ${bitmap254_out}" >&2
  exit 1
fi

scan32_sha="$(shasum -a 256 "${scan32_out}" | awk '{print $1}')"
scan48_sha="$(shasum -a 256 "${scan48_out}" | awk '{print $1}')"
bitmap254_sha="$(shasum -a 256 "${bitmap254_out}" | awk '{print $1}')"

scan32_size="$(wc -c < "${scan32_out}" | tr -d ' ')"
scan48_size="$(wc -c < "${scan48_out}" | tr -d ' ')"

cat > "${OUT_DIR}/manifest.tsv" <<EOF
file	size_bytes	sha256	source_fixture	source_command	notes
noaa_gfs_pgrb2_scan32_record1.grib2	${scan32_size}	${scan32_sha}	${scan_source}	${WGRIB2_BIN} ${scan_source} -for_n 1:1 -set_grib_type simple -set_flag_table_3.4 32 -rpn 2raw -grib_out ${scan32_out}	record 1 re-encoded with flag_table_3.4=32 (NS:WE, consecutive_j)
noaa_gfs_pgrb2_scan48_record1.grib2	${scan48_size}	${scan48_sha}	${scan_source}	${WGRIB2_BIN} ${scan_source} -for_n 1:1 -set_grib_type simple -set_flag_table_3.4 48 -rpn 2raw -grib_out ${scan48_out}	record 1 re-encoded with flag_table_3.4=48 (NS(W|E), consecutive_j + alternating_rows)
noaa_gfswave_global_bitmap254_records5_6.grib2	${bitmap254_size}	${bitmap254_sha}	${bitmap_source}	${WGRIB2_BIN} ${bitmap_source} -for_n 5:6 -tosubmsg ${bitmap254_out}	records 5:6 merged into one message; raw file contains Sec6 repeat marker 0000000606fe and wgrib2 resolves it to the previous bitmap in inventory output
EOF

echo "done: ${OUT_DIR}"
