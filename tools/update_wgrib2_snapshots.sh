#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WGRIB2_BIN="${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2}"
MBT_CMD="${MBT_CMD:-moon run cmd/main --target native --}"
OUT_DIR="fixtures/wgrib2_snapshots"
LEGACY_SNAPSHOT_MANIFEST="${OUT_DIR}/manifest.tsv"
COMPARE_MANIFEST_V2="${OUT_DIR}/manifest_v2.tsv"

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

#
# Legacy snapshot mapping used by the original text_diff-only workflow.
# compare_wgrib2_manifest_v2.sh does not read this file.
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
} > "${LEGACY_SNAPSHOT_MANIFEST}"

#
# Canonical compare manifest for tools/compare_wgrib2_manifest_v2.sh.
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
    echo -e "${id}_grib_ieee_multi\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1 -grib_ieee {out}\t{MBT} {fixture} -for_n 1:1 -grib_ieee {out}\tmulti_file\tgrb,head,tail,h"
    echo -e "${id}_bin_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -bin {out}\t{MBT} {fixture} -bin {out}\tbinary_cmp\t"
    echo -e "${id}_ieee_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -ieee {out}\t{MBT} {fixture} -ieee {out}\tbinary_cmp\t"
    echo -e "${id}_tosubmsg_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -tosubmsg {out}\t{MBT} {fixture} -tosubmsg {out}\tbinary_cmp\t"
    if [[ "${id}" == "jma_gsm" ]]; then
      echo -e "${id}_submsg_uv_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 3:4 -submsg_uv {out}\t{MBT} {fixture} -for_n 3:4 -submsg_uv {out}\tbinary_cmp\t"
      echo -e "${id}_ncep_uv_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 3:4 -ncep_uv {out}\t{MBT} {fixture} -for_n 3:4 -ncep_uv {out}\tbinary_cmp\t"
    fi
    if [[ "${id}" == "noaa_gfs_pgrb2b_1p00_f000" ]]; then
      echo -e "${id}_submsg_uv_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 4:5 -submsg_uv {out}\t{MBT} {fixture} -for_n 4:5 -submsg_uv {out}\tbinary_cmp\t"
      echo -e "${id}_ncep_uv_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 4:5 -ncep_uv {out}\t{MBT} {fixture} -for_n 4:5 -ncep_uv {out}\tbinary_cmp\t"
    fi
    if [[ "${id}" == "noaa_gfswave_atlocn_0p16_f000" ]]; then
      echo -e "${id}_submsg_uv_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 3:4 -submsg_uv {out}\t{MBT} {fixture} -for_n 3:4 -submsg_uv {out}\tbinary_cmp\t"
      echo -e "${id}_ncep_uv_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 3:4 -ncep_uv {out}\t{MBT} {fixture} -for_n 3:4 -ncep_uv {out}\tbinary_cmp\t"
    fi
    echo -e "${id}_write_sec0_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -write_sec 0 {out}\t{MBT} {fixture} -write_sec 0 {out}\tbinary_cmp\t"
    echo -e "${id}_write_sec8_bin\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -write_sec 8 {out}\t{MBT} {fixture} -write_sec 8 {out}\tbinary_cmp\t"
    echo -e "${id}_aaig_out\t${id}\t${fixture}\t\tfixture_path=\"\$(pwd)/{fixture}\" && cd {tmp} && {WGRIB2} \"\${fixture_path}\" -for_n 1:1:1 -AAIG >/dev/null && mv *.asc {out}\t{MBT} {fixture} -for_n 1:1:1 -AAIG {out}\tbinary_cmp\t"
    echo -e "${id}_aaiglong_out\t${id}\t${fixture}\t\tfixture_path=\"\$(pwd)/{fixture}\" && cd {tmp} && {WGRIB2} \"\${fixture_path}\" -for_n 1:1:1 -AAIGlong >/dev/null && mv *.asc {out}\t{MBT} {fixture} -for_n 1:1:1 -AAIGlong {out} && mv {out}.asc {out}\tbinary_cmp\t"
    if [[ "${id}" == "jma_gsm" ]]; then
      echo -e "${id}_text_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -text {out}\t{MBT} {fixture} -for_n 1:1:1 -text {out}\tbinary_cmp\t"
      echo -e "${id}_csv_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -csv {out}\t{MBT} {fixture} -for_n 1:1:1 -csv {out}\tbinary_cmp\t"
      echo -e "${id}_csv_long_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -csv_long {out}\t{MBT} {fixture} -for_n 1:1:1 -csv_long {out}\tbinary_cmp\t"
      echo -e "${id}_spread_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -spread {out}\t{MBT} {fixture} -for_n 1:1:1 -spread {out}\tbinary_cmp\t"
      echo -e "${id}_gridout_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -gridout {out}\t{MBT} {fixture} -for_n 1:1:1 -gridout {out}\tbinary_cmp\t"
    fi
    if [[ "${id}" == "noaa_gfs_pgrb2b_1p00_f000" || "${id}" == "noaa_gfswave_atlocn_0p16_f000" ]]; then
      echo -e "${id}_text_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -text {out}\t{MBT} {fixture} -for_n 1:1:1 -text {out}\tbinary_cmp\t"
      echo -e "${id}_csv_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -csv {out}\t{MBT} {fixture} -for_n 1:1:1 -csv {out}\tbinary_cmp\t"
      echo -e "${id}_csv_long_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -csv_long {out}\t{MBT} {fixture} -for_n 1:1:1 -csv_long {out}\tbinary_cmp\t"
      echo -e "${id}_spread_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -spread {out}\t{MBT} {fixture} -for_n 1:1:1 -spread {out}\tbinary_cmp\t"
      echo -e "${id}_gridout_out\t${id}\t${fixture}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -gridout {out}\t{MBT} {fixture} -for_n 1:1:1 -gridout {out}\tbinary_cmp\t"
    fi
  done

  uuid="00000000-0000-0000-0000-000000000000"
  echo -e "jma_gsm_grib_out_irr_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr all {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr all {out}\tbinary_cmp\t"
  echo -e "pgrb2b_grib_out_irr_defined_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -grib_out_irr defined {out}\t{MBT} {fixture} -for_n 266:266:1 -grib_out_irr defined {out}\tbinary_cmp\t"
  echo -e "gfswave_grib_out_irr_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr all {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr all {out}\tbinary_cmp\t"
  echo -e "jma_gsm_lola_grib_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -lola 0:720:0.5 -90:361:0.5 {out} grib\t{MBT} {fixture} -for_n 1:1:1 -lola 0:720:0.5 -90:361:0.5 {out} grib\tbinary_cmp\t"
  echo -e "jma_gsm_new_grid_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 0:720:0.5 -90:361:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 0:720:0.5 -90:361:0.5 {out}\tbinary_cmp\t"
  echo -e "jma_gsm_cress_lola_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:720:0.5 -90:361:0.5 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:720:0.5 -90:361:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "jma_gsm_ijsmall_grib_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -ijsmall_grib 1:720:1 1:361:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -ijsmall_grib 1:720:1 1:361:1 {out}\tbinary_cmp\t"
  echo -e "jma_gsm_small_grib_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -small_grib 0:359.5 -90:90 {out}\t{MBT} {fixture} -for_n 1:1:1 -small_grib 0:359.5 -90:90 {out}\tbinary_cmp\t"
  echo -e "jma_gsm_irr_grid_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -irr_grid 0:90:0.5:89.5 100 {out}\t{MBT} {fixture} -for_n 1:1:1 -irr_grid 0:90:0.5:89.5 100 {out}\tbinary_cmp\t"
  echo -e "jma_gsm_grib_out_irr2_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "jma_gsm_gribtable_used_out\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -gribtable_used {out}\t{MBT} {fixture} -gribtable_used {out}\tbinary_cmp\t"
  echo -e "jma_gsm_netcdf_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_gsm_netcdf_multi_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_netcdf_time_bin\tjma_msm_fh18_33\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:185:92 -netcdf {out}\t{MBT} {fixture} -for_n 1:185:92 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_netcdf_append_time_bin\tjma_msm_fh18_33\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 93:93:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 93:93:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_grib_out_irr2_bitmap_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -grib_out_irr2 10 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 266:266:1 -grib_out_irr2 10 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_multi_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:3:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:3:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_append_var_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_grib_out_irr2_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "gfswave_gribtable_used_out\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -gribtable_used {out}\t{MBT} {fixture} -gribtable_used {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_multi_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_new_grid_order_multi\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid_order {out}.grb2 {out}.out2\t{MBT} {fixture} -for_n 1:1:1 -new_grid_order {out}.grb2 {out}.out2\tmulti_file\tgrb2,out2"

  # Value-validation focused derived-wind cases on known U/V source fixture.
  src="fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  echo -e "pgrb2_ijbox_text_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -ijbox 1:2:1 1:2:1 {out} text\t{MBT} {fixture} -for_n 1:1:1 -ijbox 1:2:1 1:2:1 {out} text\tbinary_cmp\t"
  echo -e "pgrb2_ijbox_spread_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -ijbox 1:3:1 1:2:1 {out} spread\t{MBT} {fixture} -for_n 1:1:1 -ijbox 1:3:1 1:2:1 {out} spread\tbinary_cmp\t"
  echo -e "pgrb2_ijbox_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -ijbox 1:2:1 1:2:1 {out} bin\t{MBT} {fixture} -for_n 1:1:1 -ijbox 1:2:1 1:2:1 {out} bin\tbinary_cmp\t"
  echo -e "pgrb2_ijsmall_grib_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -ijsmall_grib 1:360:1 1:181:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -ijsmall_grib 1:360:1 1:181:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2_small_grib_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -small_grib 0:359 -90:90 {out}\t{MBT} {fixture} -for_n 1:1:1 -small_grib 0:359 -90:90 {out}\tbinary_cmp\t"
  echo -e "pgrb2_grib_out_irr_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr all {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr all {out}\tbinary_cmp\t"
  echo -e "pgrb2_lola_grib_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -lola 0:360:1 -90:181:1 {out} grib\t{MBT} {fixture} -for_n 1:1:1 -lola 0:360:1 -90:181:1 {out} grib\tbinary_cmp\t"
  echo -e "pgrb2_new_grid_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 0:360:1 -90:181:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 0:360:1 -90:181:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} 1:2\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_neg_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} -50\tbinary_cmp\t"
  echo -e "pgrb2_irr_grid_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -irr_grid 0:90:1:89 100 {out}\t{MBT} {fixture} -for_n 1:1:1 -irr_grid 0:90:1:89 100 {out}\tbinary_cmp\t"
  echo -e "pgrb2_grib_out_irr2_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "pgrb2_grib_out_irr2_pad_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr2 70000 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr2 70000 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "pgrb2_gribtable_used_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -gribtable_used {out}\t{MBT} {fixture} -gribtable_used {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_multi_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_netcdf_append_sparse_bin\tjma_msm_fh18_33\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out} && {WGRIB2} {fixture} -for_n 93:93:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out} && {MBT} {fixture} -append -for_n 93:93:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2_text_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -text {out}\t{MBT} {fixture} -for_n 1:1:1 -text {out}\tbinary_cmp\t"
  echo -e "pgrb2_csv_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -csv {out}\t{MBT} {fixture} -for_n 1:1:1 -csv {out}\tbinary_cmp\t"
  echo -e "pgrb2_csv_long_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -csv_long {out}\t{MBT} {fixture} -for_n 1:1:1 -csv_long {out}\tbinary_cmp\t"
  echo -e "pgrb2_spread_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -spread {out}\t{MBT} {fixture} -for_n 1:1:1 -spread {out}\tbinary_cmp\t"
  echo -e "pgrb2_gridout_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -gridout {out}\t{MBT} {fixture} -for_n 1:1:1 -gridout {out}\tbinary_cmp\t"
  echo -e "pgrb2_aaig_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\tfixture_path=\"\$(pwd)/{fixture}\" && cd {tmp} && {WGRIB2} \"\${fixture_path}\" -for_n 1:1:1 -AAIG >/dev/null && mv *.asc {out}\t{MBT} {fixture} -for_n 1:1:1 -AAIG {out}\tbinary_cmp\t"
  echo -e "pgrb2_aaiglong_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\tfixture_path=\"\$(pwd)/{fixture}\" && cd {tmp} && {WGRIB2} \"\${fixture_path}\" -for_n 1:1:1 -AAIGlong >/dev/null && mv *.asc {out}\t{MBT} {fixture} -for_n 1:1:1 -AAIGlong {out} && mv {out}.asc {out}\tbinary_cmp\t"
  echo -e "wind_speed_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12 -wind_speed {out}\t{MBT} {fixture} -for_n 11:12 -wind_speed {out}\tbinary_cmp\t"
  echo -e "wind_dir_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12 -wind_dir {out}\t{MBT} {fixture} -for_n 11:12 -wind_dir {out}\tbinary_cmp\t"
  echo -e "wind_uv_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t{WGRIB2} {fixture} -for_n 11:12 -wind_speed {tmp}/spd_dir.grb2 && {WGRIB2} {fixture} -for_n 11:12 -append -wind_dir {tmp}/spd_dir.grb2\t{WGRIB2} {tmp}/spd_dir.grb2 -for_n 1:2 -wind_uv {out}\t{MBT} {tmp}/spd_dir.grb2 -for_n 1:2 -wind_uv {out}\tbinary_cmp\t"
  echo -e "wind_speed_jma_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 3:4 -wind_speed {out}\t{MBT} {fixture} -for_n 3:4 -wind_speed {out}\tbinary_cmp\t"
  echo -e "wind_dir_jma_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 3:4 -wind_dir {out}\t{MBT} {fixture} -for_n 3:4 -wind_dir {out}\tbinary_cmp\t"
  echo -e "wind_speed_pgrb2b_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 4:5 -wind_speed {out}\t{MBT} {fixture} -for_n 4:5 -wind_speed {out}\tbinary_cmp\t"
  echo -e "wind_dir_pgrb2b_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 4:5 -wind_dir {out}\t{MBT} {fixture} -for_n 4:5 -wind_dir {out}\tbinary_cmp\t"
  echo -e "wind_speed_gfswave_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 3:4 -wind_speed {out}\t{MBT} {fixture} -for_n 3:4 -wind_speed {out}\tbinary_cmp\t"
  echo -e "wind_dir_gfswave_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 3:4 -wind_dir {out}\t{MBT} {fixture} -for_n 3:4 -wind_dir {out}\tbinary_cmp\t"
  echo -e "wind_uv_gfswave_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:2 -wind_uv {out}\t{MBT} {fixture} -for_n 1:2 -wind_uv {out}\tbinary_cmp\t"
  echo -e "gfswave_irr_grid_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -irr_grid 260:55:260.166667:54.833333 100 {out}\t{MBT} {fixture} -for_n 1:1:1 -irr_grid 260:55:260.166667:54.833333 100 {out}\tbinary_cmp\t"
  echo -e "gfswave_new_grid_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -new_grid latlon 260:301:0.166667 0:331:0.166667 {out}\t{MBT} {fixture} -for_n 5:5:1 -new_grid latlon 260:301:0.166667 0:331:0.166667 {out}\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -cress_lola 260:301:0.166667 0:331:0.166667 {out} 1:2\t{MBT} {fixture} -for_n 5:5:1 -cress_lola 260:301:0.166667 0:331:0.166667 {out} 1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_neg_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -cress_lola 260:301:0.166667 0:331:0.166667 {out} -20\t{MBT} {fixture} -for_n 5:5:1 -cress_lola 260:301:0.166667 0:331:0.166667 {out} -20\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_negpos_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -cress_lola 260:301:0.166667 0:331:0.166667 {out} -1:2\t{MBT} {fixture} -for_n 5:5:1 -cress_lola 260:301:0.166667 0:331:0.166667 {out} -1:2\tbinary_cmp\t"
  echo -e "gfswave_cubeface2global_unavailable\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -cubeface2global 0 {out}\t{MBT} {fixture} -for_n 1:1 -cubeface2global 0 {out}\tcombined_diff\t"
  echo -e "gfswave_mysql_unavailable\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -mysql H=localhost U=user P=pass D=db T=table\t{MBT} {fixture} -for_n 1:1 -mysql H=localhost U=user P=pass D=db T=table\tcombined_diff\t"
  echo -e "gfswave_mysql_dump_unavailable\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -mysql_dump H=localhost U=user P=pass D=db T=table W=0 PV=0\t{MBT} {fixture} -for_n 1:1 -mysql_dump H=localhost U=user P=pass D=db T=table W=0 PV=0\tcombined_diff\t"
  echo -e "gfswave_mysql_speed_unavailable\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -mysql_speed H=localhost U=user P=pass D=db T=table W=0 PV=0\t{MBT} {fixture} -for_n 1:1 -mysql_speed H=localhost U=user P=pass D=db T=table W=0 PV=0\tcombined_diff\t"

  reduced_gaussian_fixture="fixtures/grib2_jpeg2000/eccodes_reduced_gaussian_surface_jpeg.grib2"
  echo -e "reduced_gaussian_neighbor_bin\teccodes_reduced_gaussian_surface_jpeg\t${reduced_gaussian_fixture}\t\t{WGRIB2} {fixture} -for_n 1:1 -reduced_gaussian_grid {out} -1 neighbor\t{MBT} {fixture} -for_n 1:1 -reduced_gaussian_grid {out} -1 neighbor\tbinary_cmp\t"
  echo -e "reduced_gaussian_neighbor_extrap_bin\teccodes_reduced_gaussian_surface_jpeg\t${reduced_gaussian_fixture}\t\t{WGRIB2} {fixture} -for_n 1:1 -reduced_gaussian_grid {out} -1 neighbor-extrapolate\t{MBT} {fixture} -for_n 1:1 -reduced_gaussian_grid {out} -1 neighbor-extrapolate\tbinary_cmp\t"
  echo -e "reduced_gaussian_linear_bin\teccodes_reduced_gaussian_surface_jpeg\t${reduced_gaussian_fixture}\t\t{WGRIB2} {fixture} -for_n 1:1 -reduced_gaussian_grid {out} -1 linear\t{MBT} {fixture} -for_n 1:1 -reduced_gaussian_grid {out} -1 linear\tbinary_cmp\t"
  echo -e "reduced_gaussian_linear_extrap_bin\teccodes_reduced_gaussian_surface_jpeg\t${reduced_gaussian_fixture}\t\t{WGRIB2} {fixture} -for_n 1:1 -reduced_gaussian_grid {out} -1 linear-extrapolate\t{MBT} {fixture} -for_n 1:1 -reduced_gaussian_grid {out} -1 linear-extrapolate\tbinary_cmp\t"
  echo -e "jma_gsm_ave_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -ave 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave 6hr {out}\tbinary_cmp\t"
  echo -e "jma_gsm_ave0_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -ave0 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave0 6hr {out}\tbinary_cmp\t"
  echo -e "jma_gsm_ave_var_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -ave_var 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave_var 6hr {out}\tbinary_cmp\t"
  echo -e "jma_gsm_fcst_ave_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -fcst_ave 6hr {out}\t{MBT} {fixture} -for_n 1:1 -fcst_ave 6hr {out}\tbinary_cmp\t"
  echo -e "jma_gsm_fcst_ave0_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -fcst_ave0 6hr {out}\t{MBT} {fixture} -for_n 1:1 -fcst_ave0 6hr {out}\tbinary_cmp\t"
  echo -e "jma_gsm_time_processing_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -time_processing 0 1 6hr {out}\t{MBT} {fixture} -for_n 1:1 -time_processing 0 1 6hr {out}\tbinary_cmp\t"
  echo -e "jma_gsm_ens_processing_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_processing {out} 0\t{MBT} {fixture} -for_n 1:1 -ens_processing {out} 0\tbinary_cmp\t"
  echo -e "jma_gsm_ens_qc_stats_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {out} {tmp}/extreme.grb2 {tmp}/extreme.txt 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {out} {tmp}/extreme.grb2 {tmp}/extreme.txt 1\tbinary_cmp\t"
  echo -e "jma_gsm_ens_qc_extreme_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {out} {tmp}/extreme.txt 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {out} {tmp}/extreme.txt 1\tbinary_cmp\t"
  echo -e "jma_gsm_ens_qc_txt_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {tmp}/extreme.grb2 {out} 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {tmp}/extreme.grb2 {out} 1\tbinary_cmp\t"
  echo -e "pgrb2_ave_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ave 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2_ave0_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ave0 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave0 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2_ave_var_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ave_var 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave_var 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2_fcst_ave_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -fcst_ave 6hr {out}\t{MBT} {fixture} -for_n 1:1 -fcst_ave 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2_fcst_ave0_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -fcst_ave0 6hr {out}\t{MBT} {fixture} -for_n 1:1 -fcst_ave0 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2_time_processing_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -time_processing 0 1 6hr {out}\t{MBT} {fixture} -for_n 1:1 -time_processing 0 1 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2_ens_processing_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_processing {out} 0\t{MBT} {fixture} -for_n 1:1 -ens_processing {out} 0\tbinary_cmp\t"
  echo -e "pgrb2_ens_qc_stats_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {out} {tmp}/extreme.grb2 {tmp}/extreme.txt 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {out} {tmp}/extreme.grb2 {tmp}/extreme.txt 1\tbinary_cmp\t"
  echo -e "pgrb2_ens_qc_extreme_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {out} {tmp}/extreme.txt 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {out} {tmp}/extreme.txt 1\tbinary_cmp\t"
  echo -e "pgrb2_ens_qc_txt_bin\tnoaa_gfs_pgrb2_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {tmp}/extreme.grb2 {out} 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {tmp}/extreme.grb2 {out} 1\tbinary_cmp\t"
  echo -e "pgrb2b_ave_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -ave 6hr {out}\t{MBT} {fixture} -for_n 266:266:1 -ave 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2b_ave0_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -ave0 6hr {out}\t{MBT} {fixture} -for_n 266:266:1 -ave0 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2b_ave_var_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -ave_var 6hr {out}\t{MBT} {fixture} -for_n 266:266:1 -ave_var 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2b_fcst_ave_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -fcst_ave 6hr {out}\t{MBT} {fixture} -for_n 266:266:1 -fcst_ave 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2b_fcst_ave0_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -fcst_ave0 6hr {out}\t{MBT} {fixture} -for_n 266:266:1 -fcst_ave0 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2b_time_processing_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -time_processing 0 1 6hr {out}\t{MBT} {fixture} -for_n 266:266:1 -time_processing 0 1 6hr {out}\tbinary_cmp\t"
  echo -e "pgrb2b_ens_processing_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -ens_processing {out} 0\t{MBT} {fixture} -for_n 266:266:1 -ens_processing {out} 0\tbinary_cmp\t"
  echo -e "pgrb2b_ens_qc_stats_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -ens_qc {out} {tmp}/extreme.grb2 {tmp}/extreme.txt 1\t{MBT} {fixture} -for_n 266:266:1 -ens_qc {out} {tmp}/extreme.grb2 {tmp}/extreme.txt 1\tbinary_cmp\t"
  echo -e "pgrb2b_ens_qc_extreme_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -ens_qc {tmp}/stats.grb2 {out} {tmp}/extreme.txt 1\t{MBT} {fixture} -for_n 266:266:1 -ens_qc {tmp}/stats.grb2 {out} {tmp}/extreme.txt 1\tbinary_cmp\t"
  echo -e "pgrb2b_ens_qc_txt_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -ens_qc {tmp}/stats.grb2 {tmp}/extreme.grb2 {out} 1\t{MBT} {fixture} -for_n 266:266:1 -ens_qc {tmp}/stats.grb2 {tmp}/extreme.grb2 {out} 1\tbinary_cmp\t"
  echo -e "pgrb2b_lola_grib_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -lola 0:360:1 -90:181:1 {out} grib\t{MBT} {fixture} -for_n 1:1:1 -lola 0:360:1 -90:181:1 {out} grib\tbinary_cmp\t"
  echo -e "pgrb2b_new_grid_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 0:360:1 -90:181:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 0:360:1 -90:181:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2b_cress_lola_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} 1:2\tbinary_cmp\t"
  echo -e "pgrb2b_cress_lola_neg_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} -50\tbinary_cmp\t"
  echo -e "pgrb2b_ijsmall_grib_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -ijsmall_grib 1:360:1 1:181:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -ijsmall_grib 1:360:1 1:181:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2b_small_grib_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -small_grib 0:359 -90:90 {out}\t{MBT} {fixture} -for_n 1:1:1 -small_grib 0:359 -90:90 {out}\tbinary_cmp\t"
  echo -e "gfswave_ave_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ave 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave 6hr {out}\tbinary_cmp\t"
  echo -e "gfswave_ave0_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ave0 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave0 6hr {out}\tbinary_cmp\t"
  echo -e "gfswave_ave_var_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ave_var 6hr {out}\t{MBT} {fixture} -for_n 1:1 -ave_var 6hr {out}\tbinary_cmp\t"
  echo -e "gfswave_fcst_ave_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -fcst_ave 6hr {out}\t{MBT} {fixture} -for_n 1:1 -fcst_ave 6hr {out}\tbinary_cmp\t"
  echo -e "gfswave_fcst_ave0_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -fcst_ave0 6hr {out}\t{MBT} {fixture} -for_n 1:1 -fcst_ave0 6hr {out}\tbinary_cmp\t"
  echo -e "gfswave_time_processing_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -time_processing 0 1 6hr {out}\t{MBT} {fixture} -for_n 1:1 -time_processing 0 1 6hr {out}\tbinary_cmp\t"
  echo -e "gfswave_ens_processing_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_processing {out} 0\t{MBT} {fixture} -for_n 1:1 -ens_processing {out} 0\tbinary_cmp\t"
  echo -e "gfswave_ens_qc_stats_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {out} {tmp}/extreme.grb2 {tmp}/extreme.txt 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {out} {tmp}/extreme.grb2 {tmp}/extreme.txt 1\tbinary_cmp\t"
  echo -e "gfswave_ens_qc_extreme_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {out} {tmp}/extreme.txt 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {out} {tmp}/extreme.txt 1\tbinary_cmp\t"
  echo -e "gfswave_ens_qc_txt_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {tmp}/extreme.grb2 {out} 1\t{MBT} {fixture} -for_n 1:1 -ens_qc {tmp}/stats.grb2 {tmp}/extreme.grb2 {out} 1\tbinary_cmp\t"
  echo -e "derived_gfswave_ncep_norm_bin\tderived_gfswave_ncep_norm\tfixtures/grib2_derived/noaa_gfswave_atlocn_0p16_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_merge_fcst_bin\tderived_gfswave_merge_fcst\tfixtures/grib2_derived/noaa_gfswave_atlocn_0p16_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_unmerge_fcst_bin\tderived_gfswave_unmerge_fcst\tfixtures/grib2_derived/noaa_gfswave_atlocn_0p16_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_ncep_norm_bin\tderived_jma_msm_ncep_norm\tfixtures/grib2_derived/jma_msm_fh00_15_tmp1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_merge_fcst_bin\tderived_jma_msm_merge_fcst\tfixtures/grib2_derived/jma_msm_fh00_15_tmp1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_unmerge_fcst_bin\tderived_jma_msm_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh00_15_tmp1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_ncep_norm_bin\tderived_jma_msm_fh18_33_ncep_norm\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_merge_fcst_bin\tderived_jma_msm_fh18_33_merge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_unmerge_fcst_bin\tderived_jma_msm_fh18_33_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"

  echo -e "derived_gfs_scan32_default\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfs_scan32/default.txt"
  echo -e "derived_gfs_scan32_grid\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -grid\t{MBT} {fixture} -grid\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfs_scan32/grid.txt"
  echo -e "derived_gfs_scan32_stats\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfs_scan32_grib_out_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_bin_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -bin {out}\t{MBT} {fixture} -bin {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_ieee_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -ieee {out}\t{MBT} {fixture} -ieee {out}\tbinary_cmp\t"

  echo -e "derived_gfs_scan48_default\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfs_scan48/default.txt"
  echo -e "derived_gfs_scan48_grid\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -grid\t{MBT} {fixture} -grid\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfs_scan48/grid.txt"
  echo -e "derived_gfs_scan48_stats\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfs_scan48_grib_out_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_bin_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -bin {out}\t{MBT} {fixture} -bin {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_ieee_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -ieee {out}\t{MBT} {fixture} -ieee {out}\tbinary_cmp\t"

  echo -e "derived_gfswave_bitmap254_default\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/default.txt"
  echo -e "derived_gfswave_bitmap254_sec6\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -Sec6\t{MBT} {fixture} -Sec6\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/Sec6.txt"
  echo -e "derived_gfswave_bitmap254_bitmap\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -bitmap\t{MBT} {fixture} -bitmap\ttext_diff\tfixtures/wgrib2_snapshots/derived_gfswave_bitmap254/bitmap.txt"
  echo -e "derived_gfswave_bitmap254_stats\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfswave_bitmap254_grib_out_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_bitmap254_bin_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -bin {out}\t{MBT} {fixture} -bin {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_bitmap254_ieee_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -ieee {out}\t{MBT} {fixture} -ieee {out}\tbinary_cmp\t"
} > "${COMPARE_MANIFEST_V2}"

echo "done: ${OUT_DIR}"
echo "  legacy snapshot manifest : ${LEGACY_SNAPSHOT_MANIFEST}"
echo "  compare manifest v2     : ${COMPARE_MANIFEST_V2}"
