#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WGRIB2_BIN="${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2}"
MBT_CMD="${MBT_CMD:-moon run cmd/main --target native --}"
OUT_DIR="fixtures/wgrib2_snapshots"

if [[ ! -x "${WGRIB2_BIN}" ]]; then
  echo "error: wgrib2 not found or not executable: ${WGRIB2_BIN}" >&2
  exit 1
fi

bash tools/update_derived_grib2_fixtures.sh

mkdir -p "${OUT_DIR}"
rm -rf \
  "${OUT_DIR}/jma_gsm" \
  "${OUT_DIR}/noaa_gfs_pgrb2b_1p00_f000" \
  "${OUT_DIR}/noaa_gfswave_atlocn_0p16_f000" \
  "${OUT_DIR}/derived_gfs_scan32" \
  "${OUT_DIR}/derived_gfs_scan48" \
  "${OUT_DIR}/derived_gfswave_bitmap254"
mkdir -p \
  "${OUT_DIR}/jma_gsm" \
  "${OUT_DIR}/noaa_gfs_pgrb2b_1p00_f000" \
  "${OUT_DIR}/noaa_gfswave_atlocn_0p16_f000" \
  "${OUT_DIR}/derived_gfs_scan32" \
  "${OUT_DIR}/derived_gfs_scan48" \
  "${OUT_DIR}/derived_gfswave_bitmap254"

generate_one() {
  local fixture_id="$1"
  local file_path="$2"
  local dest="${OUT_DIR}/${fixture_id}"

  echo "generating snapshots: ${fixture_id}"

  "${WGRIB2_BIN}" "${file_path}" > "${dest}/default.txt"
  "${WGRIB2_BIN}" "${file_path}" -s > "${dest}/s.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec0 > "${dest}/Sec0.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec3 > "${dest}/Sec3.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec4 > "${dest}/Sec4.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec5 > "${dest}/Sec5.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec6 > "${dest}/Sec6.txt"
  "${WGRIB2_BIN}" "${file_path}" -Sec_len > "${dest}/Sec_len.txt"
  "${WGRIB2_BIN}" "${file_path}" -n > "${dest}/n.txt"
  "${WGRIB2_BIN}" "${file_path}" -range > "${dest}/range.txt"
  "${WGRIB2_BIN}" "${file_path}" -var > "${dest}/var.txt"
  "${WGRIB2_BIN}" "${file_path}" -lev > "${dest}/lev.txt"
  "${WGRIB2_BIN}" "${file_path}" -ftime > "${dest}/ftime.txt"
  "${WGRIB2_BIN}" "${file_path}" -grid > "${dest}/grid.txt"
  "${WGRIB2_BIN}" "${file_path}" -pdt > "${dest}/pdt.txt"
  "${WGRIB2_BIN}" "${file_path}" -process > "${dest}/process.txt"
  "${WGRIB2_BIN}" "${file_path}" -ens > "${dest}/ens.txt"
  "${WGRIB2_BIN}" "${file_path}" -prob > "${dest}/prob.txt"
  "${WGRIB2_BIN}" "${file_path}" -disc > "${dest}/disc.txt"
  "${WGRIB2_BIN}" "${file_path}" -center > "${dest}/center.txt"
  "${WGRIB2_BIN}" "${file_path}" -subcenter > "${dest}/subcenter.txt"
  "${WGRIB2_BIN}" "${file_path}" -packing > "${dest}/packing.txt"
  "${WGRIB2_BIN}" "${file_path}" -bitmap > "${dest}/bitmap.txt"
  "${WGRIB2_BIN}" "${file_path}" -nxny > "${dest}/nxny.txt"
  "${WGRIB2_BIN}" "${file_path}" -npts > "${dest}/npts.txt"
  "${WGRIB2_BIN}" "${file_path}" -var -lev > "${dest}/var_lev.txt"
}

generate_one \
  "jma_gsm" \
  "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"

generate_one \
  "noaa_gfs_pgrb2b_1p00_f000" \
  "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"

generate_one \
  "noaa_gfswave_atlocn_0p16_f000" \
  "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"

generate_targeted() {
  local fixture_id="$1"
  local file_path="$2"
  shift 2
  local dest="${OUT_DIR}/${fixture_id}"

  echo "generating snapshots: ${fixture_id}"

  for cmd in "$@"; do
    case "${cmd}" in
      default)
        "${WGRIB2_BIN}" "${file_path}" > "${dest}/default.txt"
        ;;
      s)
        "${WGRIB2_BIN}" "${file_path}" -s > "${dest}/s.txt"
        ;;
      grid)
        "${WGRIB2_BIN}" "${file_path}" -grid > "${dest}/grid.txt"
        ;;
      bitmap)
        "${WGRIB2_BIN}" "${file_path}" -bitmap > "${dest}/bitmap.txt"
        ;;
      Sec6)
        "${WGRIB2_BIN}" "${file_path}" -Sec6 > "${dest}/Sec6.txt"
        ;;
      *)
        echo "error: unsupported targeted snapshot command ${cmd}" >&2
        exit 1
        ;;
    esac
  done
}

generate_targeted \
  "derived_gfs_scan32" \
  "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2" \
  default \
  grid

generate_targeted \
  "derived_gfs_scan48" \
  "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2" \
  default \
  grid

generate_targeted \
  "derived_gfswave_bitmap254" \
  "fixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2" \
  default \
  Sec6 \
  bitmap

{
  echo -e "fixture_id\tfixture_path\tcommand\tsnapshot_path"
  for id in jma_gsm noaa_gfs_pgrb2b_1p00_f000 noaa_gfswave_atlocn_0p16_f000; do
    case "${id}" in
      jma_gsm)
        fixture="fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
        ;;
      noaa_gfs_pgrb2b_1p00_f000)
        fixture="fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
        ;;
      noaa_gfswave_atlocn_0p16_f000)
        fixture="fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
        ;;
      *)
        echo "error: unknown fixture id ${id}" >&2
        exit 1
        ;;
    esac
    for cmd in default s Sec0 Sec3 Sec4 Sec5 Sec6 Sec_len n range var lev ftime grid pdt process ens prob disc center subcenter packing bitmap nxny npts var_lev; do
      echo -e "${id}\t${fixture}\t${cmd}\tfixtures/wgrib2_snapshots/${id}/${cmd}.txt"
    done
  done

  echo -e "derived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\tdefault\tfixtures/wgrib2_snapshots/derived_gfs_scan32/default.txt"
  echo -e "derived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\tgrid\tfixtures/wgrib2_snapshots/derived_gfs_scan32/grid.txt"
  echo -e "derived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\tdefault\tfixtures/wgrib2_snapshots/derived_gfs_scan48/default.txt"
  echo -e "derived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\tgrid\tfixtures/wgrib2_snapshots/derived_gfs_scan48/grid.txt"
  echo -e "derived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\tdefault\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/default.txt"
  echo -e "derived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\tSec6\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/Sec6.txt"
  echo -e "derived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\tbitmap\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/bitmap.txt"
} > "${OUT_DIR}/manifest.tsv"

{
  echo -e "case_id\tfixture_id\tfixture_path\tprep\twgrib2_cmd\tmbt_cmd\tcompare_mode\texpected_ref"

  for id in jma_gsm noaa_gfs_pgrb2b_1p00_f000 noaa_gfswave_atlocn_0p16_f000; do
    case "${id}" in
      jma_gsm)
        fixture="fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
        ;;
      noaa_gfs_pgrb2b_1p00_f000)
        fixture="fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
        ;;
      noaa_gfswave_atlocn_0p16_f000)
        fixture="fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
        ;;
      *)
        echo "error: unknown fixture id ${id}" >&2
        exit 1
        ;;
    esac

    for cmd in default s Sec0 Sec3 Sec4 Sec5 Sec6 Sec_len n range var lev ftime grid pdt process ens prob disc center subcenter packing bitmap nxny npts var_lev; do
      case_id="${id}_${cmd}"
      if [[ "${cmd}" == "default" ]]; then
        wcmd="{WGRIB2} {fixture}"
        mcmd="{MBT} {fixture}"
      elif [[ "${cmd}" == "var_lev" ]]; then
        wcmd="{WGRIB2} {fixture} -var -lev"
        mcmd="{MBT} {fixture} -var -lev"
      else
        wcmd="{WGRIB2} {fixture} -${cmd}"
        mcmd="{MBT} {fixture} -${cmd}"
      fi
      echo -e "${case_id}\t${id}\t${fixture}\t\t${wcmd}\t${mcmd}\ttext_diff\tfixtures/wgrib2_snapshots/${id}/${cmd}.txt"
    done

    if [[ "${id}" == "jma_gsm" ]]; then
      echo -e "${id}_stats\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
    fi

    echo -e "${id}_grib_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -grib {out}\t{MBT} {fixture} -grib {out}\tbinary_cmp\t"
    echo -e "${id}_grib_out_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"
    echo -e "${id}_tosubmsg_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -tosubmsg {out}\t{MBT} {fixture} -tosubmsg {out}\tbinary_cmp\t"
    echo -e "${id}_write_sec0_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -write_sec 0 {out}\t{MBT} {fixture} -write_sec 0 {out}\tbinary_cmp\t"
    echo -e "${id}_write_sec8_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -write_sec 8 {out}\t{MBT} {fixture} -write_sec 8 {out}\tbinary_cmp\t"
  done

  # Value-validation focused derived-wind cases on known U/V source fixture.
  src="fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  echo -e "wind_speed_stats\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12 -wind_speed {out} && {WGRIB2} {out} -stats\t{MBT} {fixture} -for_n 11:12 -wind_speed {out} >/dev/null && {WGRIB2} {out} -stats\tstats_diff\t"
  echo -e "wind_dir_stats\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12 -wind_dir {out} && {WGRIB2} {out} -stats\t{MBT} {fixture} -for_n 11:12 -wind_dir {out} >/dev/null && {WGRIB2} {out} -stats\tstats_diff\t"
  echo -e "wind_uv_stats\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t{WGRIB2} {fixture} -for_n 11:12 -wind_speed {tmp}/spd_dir.grb2 && {WGRIB2} {fixture} -for_n 11:12 -append -wind_dir {tmp}/spd_dir.grb2\t{WGRIB2} {tmp}/spd_dir.grb2 -for_n 1:2 -wind_uv {out} && {WGRIB2} {out} -stats\t{MBT} {tmp}/spd_dir.grb2 -for_n 1:2 -wind_uv {out} >/dev/null && {WGRIB2} {out} -stats\tstats_diff\t"

  echo -e "derived_gfs_scan32_default\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfs_scan32/default.txt"
  echo -e "derived_gfs_scan32_grid\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -grid\t{MBT} {fixture} -grid\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfs_scan32/grid.txt"
  echo -e "derived_gfs_scan32_stats\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfs_scan32_grib_out_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"

  echo -e "derived_gfs_scan48_default\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfs_scan48/default.txt"
  echo -e "derived_gfs_scan48_grid\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -grid\t{MBT} {fixture} -grid\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfs_scan48/grid.txt"
  echo -e "derived_gfs_scan48_stats\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfs_scan48_grib_out_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"

  echo -e "derived_gfswave_bitmap254_default\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/default.txt"
  echo -e "derived_gfswave_bitmap254_sec6\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -Sec6\t{MBT} {fixture} -Sec6\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/Sec6.txt"
  echo -e "derived_gfswave_bitmap254_bitmap\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -bitmap\t{MBT} {fixture} -bitmap\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/bitmap.txt"
  echo -e "derived_gfswave_bitmap254_stats\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfswave_bitmap254_grib_out_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"
} > "${OUT_DIR}/manifest_v2.tsv"

echo "done: ${OUT_DIR}"
