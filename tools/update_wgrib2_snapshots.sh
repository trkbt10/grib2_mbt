#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WGRIB2_BIN="${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2}"
DEFAULT_MBT_CMD="moon run cmd/main --target native --"
if [[ -x "_build/native/debug/build/cmd/main/main.exe" ]]; then
  DEFAULT_MBT_CMD="_build/native/debug/build/cmd/main/main.exe"
fi
MBT_CMD="${MBT_CMD:-${DEFAULT_MBT_CMD}}"
OUT_DIR="fixtures/wgrib2_snapshots"
LEGACY_SNAPSHOT_MANIFEST="${OUT_DIR}/manifest.tsv"
COMPARE_MANIFEST_V2="${OUT_DIR}/manifest_v2.tsv"
ALL_CATEGORIES=(inventory encode format grid process netcdf compat)
TMP_LEGACY_MANIFEST="$(mktemp)"
TMP_COMPARE_MANIFEST="$(mktemp)"
INVENTORY_CATEGORY_DIR="${OUT_DIR}/inventory"
INVENTORY_SNAPSHOT_REF_ROOT="fixtures/wgrib2_snapshots/inventory"
CATEGORY="${CATEGORY:-}"
CATEGORIES="${CATEGORIES:-}"
SELECTED_CATEGORIES=()

cleanup_tmp_files() {
  rm -f "${TMP_LEGACY_MANIFEST}" "${TMP_COMPARE_MANIFEST}"
}

trap cleanup_tmp_files EXIT

mark_category() {
  local category="$1"
  if ! category_enabled "${category}"; then
    SELECTED_CATEGORIES+=("${category}")
  fi
}

category_enabled() {
  local category="$1"
  local selected

  for selected in "${SELECTED_CATEGORIES[@]:-}"; do
    if [[ "${selected}" == "${category}" ]]; then
      return 0
    fi
  done
  return 1
}

parse_requested_categories() {
  local raw
  local category
  local item
  local found

  if [[ -z "${CATEGORY}" && -z "${CATEGORIES}" ]]; then
    for category in "${ALL_CATEGORIES[@]}"; do
      mark_category "${category}"
    done
    return
  fi

  raw="${CATEGORY}"
  if [[ -n "${CATEGORIES}" ]]; then
    if [[ -n "${raw}" ]]; then
      raw="${raw},${CATEGORIES}"
    else
      raw="${CATEGORIES}"
    fi
  fi

  IFS=',' read -r -a requested <<< "${raw}"
  for item in "${requested[@]}"; do
    item="${item//[[:space:]]/}"
    [[ -z "${item}" ]] && continue
    if [[ "${item}" == "all" ]]; then
      for category in "${ALL_CATEGORIES[@]}"; do
        mark_category "${category}"
      done
      return
    fi
    found=0
    for category in "${ALL_CATEGORIES[@]}"; do
      if [[ "${category}" == "${item}" ]]; then
        mark_category "${category}"
        found=1
        break
      fi
    done
    if [[ "${found}" == "0" ]]; then
      echo "error: unknown snapshot category: ${item}" >&2
      echo "known categories: ${ALL_CATEGORIES[*]}" >&2
      exit 1
    fi
  done
}

selected_categories_csv() {
  local out=()
  local category

  for category in "${ALL_CATEGORIES[@]}"; do
    if category_enabled "${category}"; then
      out+=("${category}")
    fi
  done

  (
    IFS=','
    printf '%s' "${out[*]}"
  )
}

requires_derived_fixture_refresh() {
  category_enabled inventory || category_enabled encode || category_enabled grid || category_enabled process || category_enabled netcdf
}

selected_derived_groups_csv() {
  local groups=()

  if category_enabled inventory || category_enabled encode || category_enabled grid; then
    groups+=("inventory")
  fi
  if category_enabled process; then
    groups+=("process")
  fi
  if category_enabled netcdf; then
    groups+=("netcdf")
  fi

  (
    IFS=','
    printf '%s' "${groups[*]}"
  )
}

parse_requested_categories

if [[ ! -x "${WGRIB2_BIN}" ]]; then
  echo "error: wgrib2 not found or not executable: ${WGRIB2_BIN}" >&2
  exit 1
fi

if requires_derived_fixture_refresh; then
  DERIVED_GROUPS="$(selected_derived_groups_csv)" bash tools/update_derived_grib2_fixtures.sh
fi

mkdir -p "${OUT_DIR}"
rm -rf \
  "${OUT_DIR}/jma_gsm" \
  "${OUT_DIR}/noaa_gfs_pgrb2b_1p00_f000" \
  "${OUT_DIR}/noaa_gfswave_atlocn_0p16_f000" \
  "${OUT_DIR}/derived_gfs_scan32" \
  "${OUT_DIR}/derived_gfs_scan48" \
  "${OUT_DIR}/derived_gfswave_bitmap254"
for category in "${ALL_CATEGORIES[@]}"; do
  if category_enabled "${category}"; then
    rm -rf "${OUT_DIR}/${category}"
    mkdir -p "${OUT_DIR}/${category}"
  fi
done

generate_one() {
  local fixture_id="$1"
  local file_path="$2"
  local dest="${INVENTORY_CATEGORY_DIR}/${fixture_id}"

  echo "generating snapshots: ${fixture_id}"
  mkdir -p "${dest}"

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

if category_enabled inventory; then
  generate_one \
    "jma_gsm" \
    "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"

  generate_one \
    "noaa_gfs_pgrb2b_1p00_f000" \
    "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"

  generate_one \
    "noaa_gfswave_atlocn_0p16_f000" \
    "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
fi

generate_targeted() {
  local fixture_id="$1"
  local file_path="$2"
  shift 2
  local dest="${INVENTORY_CATEGORY_DIR}/${fixture_id}"

  echo "generating snapshots: ${fixture_id}"
  mkdir -p "${dest}"

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

if category_enabled inventory; then
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
fi

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
      echo -e "${id}\t${fixture}\t${cmd}\t${INVENTORY_SNAPSHOT_REF_ROOT}/${id}/${cmd}.txt"
    done
  done

  echo -e "derived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\tdefault\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfs_scan32/default.txt"
  echo -e "derived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\tgrid\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfs_scan32/grid.txt"
  echo -e "derived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\tdefault\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfs_scan48/default.txt"
  echo -e "derived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\tgrid\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfs_scan48/grid.txt"
  echo -e "derived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\tdefault\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfswave_bitmap254/default.txt"
  echo -e "derived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\tSec6\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfswave_bitmap254/Sec6.txt"
  echo -e "derived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\tbitmap\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfswave_bitmap254/bitmap.txt"
} > "${TMP_LEGACY_MANIFEST}"

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
      echo -e "${case_id}\t${id}\t${fixture}\t\t${wcmd}\t${mcmd}\ttext_diff\t${INVENTORY_SNAPSHOT_REF_ROOT}/${id}/${cmd}.txt"
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
  echo -e "jma_gsm_netcdf_append_var_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_gsm_netcdf_append_var4_bin\tjma_gsm\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:4:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_netcdf_time_bin\tjma_msm_fh18_33\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:185:92 -netcdf {out}\t{MBT} {fixture} -for_n 1:185:92 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_netcdf_append_time_bin\tjma_msm_fh18_33\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 93:93:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 93:93:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_netcdf_multi4_bin\tjma_msm_fh18_33\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_netcdf_append_var4_bin\tjma_msm_fh18_33\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:4:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_fh00_15_netcdf_time_bin\tjma_msm_fh00_15\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:185:92 -netcdf {out}\t{MBT} {fixture} -for_n 1:185:92 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_fh00_15_netcdf_append_time_bin\tjma_msm_fh00_15\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 93:93:1 -append -netcdf {out} && {WGRIB2} {fixture} -for_n 185:185:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 93:93:1 -netcdf {out} && {MBT} {fixture} -append -for_n 185:185:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_fh00_15_netcdf_multi4_bin\tjma_msm_fh00_15\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_fh00_15_netcdf_append_var4_bin\tjma_msm_fh00_15\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:4:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_fh36_39_netcdf_time_bin\tjma_msm_fh36_39\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:93:92 -netcdf {out}\t{MBT} {fixture} -for_n 1:93:92 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_fh36_39_netcdf_append_time_bin\tjma_msm_fh36_39\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 93:93:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 93:93:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_fh36_39_netcdf_multi4_bin\tjma_msm_fh36_39\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "jma_msm_fh36_39_netcdf_append_var4_bin\tjma_msm_fh36_39\tfixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:4:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_grib_out_irr2_bitmap_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -grib_out_irr2 10 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 266:266:1 -grib_out_irr2 10 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_multi_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:3:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:3:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_multi4_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_multi8_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:8:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:8:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_multi12_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:12:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:12:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_multi16_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:16:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:16:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_append_var_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_append_var4_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:4:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_append_var8_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:8:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:8:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_append_var12_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:12:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:12:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_append_var16_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:16:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:16:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_bitmap266_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -netcdf {out}\t{MBT} {fixture} -for_n 266:266:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_bitmap266_269_multi_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:269:1 -netcdf {out}\t{MBT} {fixture} -for_n 266:269:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_bitmap266_267_append_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t{WGRIB2} {fixture} -for_n 266:266:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 267:267:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 267:267:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2b_netcdf_bitmap266_269_append_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t{WGRIB2} {fixture} -for_n 266:266:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 267:267:1 -append -netcdf {out} && {WGRIB2} {fixture} -for_n 268:268:1 -append -netcdf {out} && {WGRIB2} {fixture} -for_n 269:269:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 267:267:1 -netcdf {out} && {MBT} {fixture} -append -for_n 268:268:1 -netcdf {out} && {MBT} {fixture} -append -for_n 269:269:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_grib_out_irr2_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "gfswave_gribtable_used_out\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -gribtable_used {out}\t{MBT} {fixture} -gribtable_used {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_multi_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_multi8_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:8:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:8:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_multi12_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:12:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:12:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_multi19_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:19:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:19:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_append_var_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_append_var4_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:4:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_append_var8_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:8:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:8:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_netcdf_append_var19_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:19:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:19:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_global_netcdf_bin\tnoaa_gfswave_global_0p25_f000\tfixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_global_netcdf_multi_bin\tnoaa_gfswave_global_0p25_f000\tfixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_global_netcdf_multi4_bin\tnoaa_gfswave_global_0p25_f000\tfixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_global_netcdf_multi8_bin\tnoaa_gfswave_global_0p25_f000\tfixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:8:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:8:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_global_netcdf_multi12_bin\tnoaa_gfswave_global_0p25_f000\tfixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:12:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:12:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_global_netcdf_append_var_bin\tnoaa_gfswave_global_0p25_f000\tfixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_global_netcdf_append_var4_bin\tnoaa_gfswave_global_0p25_f000\tfixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:4:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "gfswave_global_netcdf_append_var8_bin\tnoaa_gfswave_global_0p25_f000\tfixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:8:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:8:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_bitmap254_netcdf_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_bitmap254_netcdf_multi_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_bitmap254_netcdf_append_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
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
  echo -e "pgrb2_new_grid_bilinear_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 0.5:8:1 -89.5:8:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 0.5:8:1 -89.5:8:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2_new_grid_neighbor_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 0.5:8:1 -89.5:8:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 0.5:8:1 -89.5:8:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2_new_grid_bilinear_uv_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12:1 -new_grid latlon 0.5:8:1 -89.5:8:1 {out}\t{MBT} {fixture} -for_n 11:12:1 -new_grid latlon 0.5:8:1 -89.5:8:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2_new_grid_neighbor_uv_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12:1 -new_grid_interpolation neighbor -new_grid latlon 0.5:8:1 -89.5:8:1 {out}\t{MBT} {fixture} -for_n 11:12:1 -new_grid_interpolation neighbor -new_grid latlon 0.5:8:1 -89.5:8:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2_new_grid_bilinear_uv_eq_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12:1 -new_grid latlon 100.5:8:1 0.5:8:1 {out}\t{MBT} {fixture} -for_n 11:12:1 -new_grid latlon 100.5:8:1 0.5:8:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} 1:2\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_neg_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} -50\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_offgrid_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_offgrid_neg_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_offgrid_negpos_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_offgrid_uv_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 11:12:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_offgrid_uv_neg_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\t{MBT} {fixture} -for_n 11:12:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "pgrb2_cress_lola_offgrid_uv_negpos_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 11:12:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 11:12:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\tbinary_cmp\t"
  echo -e "pgrb2_irr_grid_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -irr_grid 0:90:1:89 100 {out}\t{MBT} {fixture} -for_n 1:1:1 -irr_grid 0:90:1:89 100 {out}\tbinary_cmp\t"
  echo -e "pgrb2_grib_out_irr2_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr2 10 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "pgrb2_grib_out_irr2_pad_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -grib_out_irr2 70000 1 0 ${uuid} {out}\t{MBT} {fixture} -for_n 1:1:1 -grib_out_irr2 70000 1 0 ${uuid} {out}\tbinary_cmp\t"
  echo -e "pgrb2_gribtable_used_out\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -gribtable_used {out}\t{MBT} {fixture} -gribtable_used {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_multi_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_multi4_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:4:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_multi8_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t\t{WGRIB2} {fixture} -for_n 1:8:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:8:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_append_var_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_append_var4_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:4:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:4:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "pgrb2_netcdf_append_var8_bin\tnoaa_gfs_pgrb2_1p00_f000\t${src}\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:8:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:8:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_mixed_reference_netcdf_bin\tderived_pgrb2_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_mixed_reference_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_mixed_reference_netcdf_append_bin\tderived_pgrb2_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_mixed_reference_netcdf_input.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_mercator_netcdf_bin\tderived_pgrb2_mercator_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_mercator_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_mercator_mixed_reference_netcdf_bin\tderived_pgrb2_mercator_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_mercator_mixed_reference_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_mercator_mixed_reference_netcdf_append_bin\tderived_pgrb2_mercator_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_mercator_mixed_reference_netcdf_input.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_rotated_netcdf_bin\tderived_pgrb2_rotated_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_rotated_latlon_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_rotated_mixed_reference_netcdf_bin\tderived_pgrb2_rotated_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_rotated_latlon_mixed_reference_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_rotated_mixed_reference_netcdf_append_bin\tderived_pgrb2_rotated_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_rotated_latlon_mixed_reference_netcdf_input.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_polar_netcdf_bin\tderived_pgrb2_polar_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_polar_stereographic_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_polar_mixed_reference_netcdf_bin\tderived_pgrb2_polar_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_polar_stereographic_mixed_reference_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_polar_mixed_reference_netcdf_append_bin\tderived_pgrb2_polar_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_polar_stereographic_mixed_reference_netcdf_input.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_lambert_netcdf_bin\tderived_pgrb2_lambert_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_lambert_conformal_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_lambert_mixed_reference_netcdf_bin\tderived_pgrb2_lambert_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_lambert_conformal_mixed_reference_netcdf_input.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2_lambert_mixed_reference_netcdf_append_bin\tderived_pgrb2_lambert_mixed_reference_netcdf\tfixtures/grib2_derived/noaa_gfs_pgrb2_synthetic_lambert_conformal_mixed_reference_netcdf_input.grib2\t{WGRIB2} {fixture} -for_n 1:1:1 -netcdf {tmp}/seed.nc\tcp {tmp}/seed.nc {out} && {WGRIB2} {fixture} -for_n 2:2:1 -append -netcdf {out}\tcp {tmp}/seed.nc {out} && {MBT} {fixture} -append -for_n 2:2:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "eccodes_jpeg_netcdf_bin\teccodes_jpeg\tfixtures/grib2_jpeg2000/eccodes_jpeg.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1:1 -netcdf {out}\tbinary_cmp\t"
  echo -e "reduced_gaussian_netcdf_unavailable\teccodes_reduced_gaussian_surface_jpeg\tfixtures/grib2_jpeg2000/eccodes_reduced_gaussian_surface_jpeg.grib2\t\t{WGRIB2} {fixture} -for_n 1:1 -netcdf {out}\t{MBT} {fixture} -for_n 1:1 -netcdf {out}\tcombined_diff\t"
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
  echo -e "gfswave_new_grid_neighbor_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -new_grid_interpolation neighbor -new_grid latlon 260:301:0.166667 0:331:0.166667 {out}\t{MBT} {fixture} -for_n 5:5:1 -new_grid_interpolation neighbor -new_grid latlon 260:301:0.166667 0:331:0.166667 {out}\tbinary_cmp\t"
  echo -e "gfswave_new_grid_wind_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 260.5:8:1 0.5:8:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 260.5:8:1 0.5:8:1 {out}\tbinary_cmp\t"
  echo -e "gfswave_new_grid_wdir_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 2:2:1 -new_grid latlon 260.5:8:1 0.5:8:1 {out}\t{MBT} {fixture} -for_n 2:2:1 -new_grid latlon 260.5:8:1 0.5:8:1 {out}\tbinary_cmp\t"
  echo -e "gfswave_new_grid_uv_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 3:4:1 -new_grid latlon 260.5:8:1 0.5:8:1 {out}\t{MBT} {fixture} -for_n 3:4:1 -new_grid latlon 260.5:8:1 0.5:8:1 {out}\tbinary_cmp\t"
  echo -e "gfswave_new_grid_neighbor_wind_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 260.5:8:1 0.5:8:1 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 260.5:8:1 0.5:8:1 {out}\tbinary_cmp\t"
  echo -e "gfswave_new_grid_neighbor_wdir_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 2:2:1 -new_grid_interpolation neighbor -new_grid latlon 260.5:8:1 0.5:8:1 {out}\t{MBT} {fixture} -for_n 2:2:1 -new_grid_interpolation neighbor -new_grid latlon 260.5:8:1 0.5:8:1 {out}\tbinary_cmp\t"
  echo -e "gfswave_new_grid_neighbor_uv_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 3:4:1 -new_grid_interpolation neighbor -new_grid latlon 260.5:8:1 0.5:8:1 {out}\t{MBT} {fixture} -for_n 3:4:1 -new_grid_interpolation neighbor -new_grid latlon 260.5:8:1 0.5:8:1 {out}\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -cress_lola 260:301:0.166667 0:331:0.166667 {out} 1:2\t{MBT} {fixture} -for_n 5:5:1 -cress_lola 260:301:0.166667 0:331:0.166667 {out} 1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_offgrid_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -cress_lola 260.5:8:1 0.5:8:1 {out} 1:2\t{MBT} {fixture} -for_n 5:5:1 -cress_lola 260.5:8:1 0.5:8:1 {out} 1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_uv_offgrid_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 3:4:1 -cress_lola 260.5:8:1 0.5:8:1 {out} 1:2\t{MBT} {fixture} -for_n 3:4:1 -cress_lola 260.5:8:1 0.5:8:1 {out} 1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_uv_offgrid_neg_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 3:4:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -20\t{MBT} {fixture} -for_n 3:4:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -20\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_uv_offgrid_negpos_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 3:4:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -1:2\t{MBT} {fixture} -for_n 3:4:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_offgrid_neg_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -20\t{MBT} {fixture} -for_n 5:5:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -20\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_offgrid_negpos_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 5:5:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -1:2\t{MBT} {fixture} -for_n 5:5:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_wind_offgrid_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 260.5:8:1 0.5:8:1 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 260.5:8:1 0.5:8:1 {out} 1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_wdir_offgrid_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 2:2:1 -cress_lola 260.5:8:1 0.5:8:1 {out} 1:2\t{MBT} {fixture} -for_n 2:2:1 -cress_lola 260.5:8:1 0.5:8:1 {out} 1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_wind_offgrid_neg_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -20\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -20\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_wdir_offgrid_neg_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 2:2:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -20\t{MBT} {fixture} -for_n 2:2:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -20\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_wind_offgrid_negpos_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -1:2\tbinary_cmp\t"
  echo -e "gfswave_cress_lola_wdir_offgrid_negpos_bin\tnoaa_gfswave_atlocn_0p16_f000\tfixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2\t\t{WGRIB2} {fixture} -for_n 2:2:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -1:2\t{MBT} {fixture} -for_n 2:2:1 -cress_lola 260.5:8:1 0.5:8:1 {out} -1:2\tbinary_cmp\t"
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
  echo -e "pgrb2b_new_grid_bilinear_bitmap_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -new_grid latlon 130.5:8:1 30.5:8:1 {out}\t{MBT} {fixture} -for_n 266:266:1 -new_grid latlon 130.5:8:1 30.5:8:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2b_new_grid_neighbor_bitmap_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -new_grid_interpolation neighbor -new_grid latlon 130.5:8:1 30.5:8:1 {out}\t{MBT} {fixture} -for_n 266:266:1 -new_grid_interpolation neighbor -new_grid latlon 130.5:8:1 30.5:8:1 {out}\tbinary_cmp\t"
  echo -e "pgrb2b_cress_lola_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} 1:2\tbinary_cmp\t"
  echo -e "pgrb2b_cress_lola_neg_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0:360:1 -90:181:1 {out} -50\tbinary_cmp\t"
  echo -e "pgrb2b_cress_lola_offgrid_bitmap_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 266:266:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "pgrb2b_cress_lola_offgrid_bitmap_neg_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -50\t{MBT} {fixture} -for_n 266:266:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "pgrb2b_cress_lola_offgrid_bitmap_negpos_bin\tnoaa_gfs_pgrb2b_1p00_f000\tfixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2\t\t{WGRIB2} {fixture} -for_n 266:266:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 266:266:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -1:2\tbinary_cmp\t"
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
  echo -e "derived_jma_msm_ugrd1000_ncep_norm_bin\tderived_jma_msm_ugrd1000_ncep_norm\tfixtures/grib2_derived/jma_msm_fh00_15_ugrd1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_ugrd1000_merge_fcst_bin\tderived_jma_msm_ugrd1000_merge_fcst\tfixtures/grib2_derived/jma_msm_fh00_15_ugrd1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_ugrd1000_unmerge_fcst_bin\tderived_jma_msm_ugrd1000_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh00_15_ugrd1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_vgrd1000_ncep_norm_bin\tderived_jma_msm_vgrd1000_ncep_norm\tfixtures/grib2_derived/jma_msm_fh00_15_vgrd1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_vgrd1000_merge_fcst_bin\tderived_jma_msm_vgrd1000_merge_fcst\tfixtures/grib2_derived/jma_msm_fh00_15_vgrd1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_vgrd1000_unmerge_fcst_bin\tderived_jma_msm_vgrd1000_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh00_15_vgrd1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_ncep_norm_bin\tderived_jma_msm_fh18_33_ncep_norm\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_merge_fcst_bin\tderived_jma_msm_fh18_33_merge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_unmerge_fcst_bin\tderived_jma_msm_fh18_33_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_ugrd1000_ncep_norm_bin\tderived_jma_msm_fh18_33_ugrd1000_ncep_norm\tfixtures/grib2_derived/jma_msm_fh18_33_ugrd1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_ugrd1000_merge_fcst_bin\tderived_jma_msm_fh18_33_ugrd1000_merge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_ugrd1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_ugrd1000_unmerge_fcst_bin\tderived_jma_msm_fh18_33_ugrd1000_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_ugrd1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_vgrd1000_ncep_norm_bin\tderived_jma_msm_fh18_33_vgrd1000_ncep_norm\tfixtures/grib2_derived/jma_msm_fh18_33_vgrd1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_vgrd1000_merge_fcst_bin\tderived_jma_msm_fh18_33_vgrd1000_merge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_vgrd1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_vgrd1000_unmerge_fcst_bin\tderived_jma_msm_fh18_33_vgrd1000_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_vgrd1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_ncep_norm_bin\tderived_jma_msm_fh36_39_ncep_norm\tfixtures/grib2_derived/jma_msm_fh36_39_tmp1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_merge_fcst_bin\tderived_jma_msm_fh36_39_merge_fcst\tfixtures/grib2_derived/jma_msm_fh36_39_tmp1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_unmerge_fcst_bin\tderived_jma_msm_fh36_39_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh36_39_tmp1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_ugrd1000_ncep_norm_bin\tderived_jma_msm_fh36_39_ugrd1000_ncep_norm\tfixtures/grib2_derived/jma_msm_fh36_39_ugrd1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_ugrd1000_merge_fcst_bin\tderived_jma_msm_fh36_39_ugrd1000_merge_fcst\tfixtures/grib2_derived/jma_msm_fh36_39_ugrd1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_ugrd1000_unmerge_fcst_bin\tderived_jma_msm_fh36_39_ugrd1000_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh36_39_ugrd1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_vgrd1000_ncep_norm_bin\tderived_jma_msm_fh36_39_vgrd1000_ncep_norm\tfixtures/grib2_derived/jma_msm_fh36_39_vgrd1000_ncep_norm_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_vgrd1000_merge_fcst_bin\tderived_jma_msm_fh36_39_vgrd1000_merge_fcst\tfixtures/grib2_derived/jma_msm_fh36_39_vgrd1000_merge_fcst_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh36_39_vgrd1000_unmerge_fcst_bin\tderived_jma_msm_fh36_39_vgrd1000_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh36_39_vgrd1000_unmerge_fcst_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_long_ncep_norm_bin\tderived_jma_msm_fh18_33_long_ncep_norm\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_ncep_norm_long_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_long_merge_fcst_bin\tderived_jma_msm_fh18_33_long_merge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_merge_fcst_long_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_long_unmerge_fcst_bin\tderived_jma_msm_fh18_33_long_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_tmp1000_unmerge_fcst_long_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_ugrd1000_long_ncep_norm_bin\tderived_jma_msm_fh18_33_ugrd1000_long_ncep_norm\tfixtures/grib2_derived/jma_msm_fh18_33_ugrd1000_ncep_norm_long_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_ugrd1000_long_merge_fcst_bin\tderived_jma_msm_fh18_33_ugrd1000_long_merge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_ugrd1000_merge_fcst_long_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_ugrd1000_long_unmerge_fcst_bin\tderived_jma_msm_fh18_33_ugrd1000_long_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_ugrd1000_unmerge_fcst_long_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_vgrd1000_long_ncep_norm_bin\tderived_jma_msm_fh18_33_vgrd1000_long_ncep_norm\tfixtures/grib2_derived/jma_msm_fh18_33_vgrd1000_ncep_norm_long_input.grib2\t\t{WGRIB2} {fixture} -ncep_norm {out}\t{MBT} {fixture} -ncep_norm {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_vgrd1000_long_merge_fcst_bin\tderived_jma_msm_fh18_33_vgrd1000_long_merge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_vgrd1000_merge_fcst_long_input.grib2\t\t{WGRIB2} {fixture} -merge_fcst 2 {out}\t{MBT} {fixture} -merge_fcst 2 {out}\tbinary_cmp\t"
  echo -e "derived_jma_msm_fh18_33_vgrd1000_long_unmerge_fcst_bin\tderived_jma_msm_fh18_33_vgrd1000_long_unmerge_fcst\tfixtures/grib2_derived/jma_msm_fh18_33_vgrd1000_unmerge_fcst_long_input.grib2\t\t{WGRIB2} {fixture} -unmerge_fcst {out} 0hr 1\t{MBT} {fixture} -unmerge_fcst {out} 0hr 1\tbinary_cmp\t"

  echo -e "derived_gfs_scan32_default\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfs_scan32/default.txt"
  echo -e "derived_gfs_scan32_grid\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -grid\t{MBT} {fixture} -grid\ttext_diff\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfs_scan32/grid.txt"
  echo -e "derived_gfs_scan32_stats\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfs_scan32_grib_out_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_bin_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -bin {out}\t{MBT} {fixture} -bin {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_ieee_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -ieee {out}\t{MBT} {fixture} -ieee {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_new_grid_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_new_grid_neighbor_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_cress_lola_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_cress_lola_neg_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_cress_lola_negpos_bin\tderived_gfs_scan32\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\tbinary_cmp\t"
  echo -e "derived_pgrb2b_scan32_bitmap_new_grid_bin\tderived_pgrb2b_scan32_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 130.25:6:0.5 30.5:5:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 130.25:6:0.5 30.5:5:0.5 {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2b_scan32_bitmap_new_grid_neighbor_bin\tderived_pgrb2b_scan32_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 130.25:6:0.5 30.5:5:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 130.25:6:0.5 30.5:5:0.5 {out}\tbinary_cmp\t"
  echo -e "derived_pgrb2b_scan32_bitmap_cress_lola_bin\tderived_pgrb2b_scan32_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "derived_pgrb2b_scan32_bitmap_cress_lola_neg_bin\tderived_pgrb2b_scan32_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "derived_pgrb2b_scan32_bitmap_cress_lola_negpos_bin\tderived_pgrb2b_scan32_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -1:2\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_uv_new_grid_bin\tderived_gfs_scan32_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\t{MBT} {fixture} -for_n 1:2:1 -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_uv_new_grid_neighbor_bin\tderived_gfs_scan32_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -new_grid_interpolation neighbor -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\t{MBT} {fixture} -for_n 1:2:1 -new_grid_interpolation neighbor -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_uv_cress_lola_bin\tderived_gfs_scan32_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_uv_cress_lola_neg_bin\tderived_gfs_scan32_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\t{MBT} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "derived_gfs_scan32_uv_cress_lola_negpos_bin\tderived_gfs_scan32_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\tbinary_cmp\t"

  echo -e "derived_gfs_scan48_default\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfs_scan48/default.txt"
  echo -e "derived_gfs_scan48_grid\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -grid\t{MBT} {fixture} -grid\ttext_diff\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfs_scan48/grid.txt"
  echo -e "derived_gfs_scan48_stats\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfs_scan48_grib_out_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_bin_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -bin {out}\t{MBT} {fixture} -bin {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_ieee_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -ieee {out}\t{MBT} {fixture} -ieee {out}\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_new_grid_combined\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\tcombined_diff\t"
  echo -e "derived_gfs_scan48_new_grid_neighbor_combined\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\tcombined_diff\t"
  echo -e "derived_gfs_scan48_cress_lola_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_cress_lola_neg_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_cress_lola_negpos_bin\tderived_gfs_scan48\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\tbinary_cmp\t"
  echo -e "derived_pgrb2b_scan48_bitmap_new_grid_combined\tderived_pgrb2b_scan48_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid latlon 130.25:6:0.5 30.5:5:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid latlon 130.25:6:0.5 30.5:5:0.5 {out}\tcombined_diff\t"
  echo -e "derived_pgrb2b_scan48_bitmap_new_grid_neighbor_combined\tderived_pgrb2b_scan48_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 130.25:6:0.5 30.5:5:0.5 {out}\t{MBT} {fixture} -for_n 1:1:1 -new_grid_interpolation neighbor -new_grid latlon 130.25:6:0.5 30.5:5:0.5 {out}\tcombined_diff\t"
  echo -e "derived_pgrb2b_scan48_bitmap_cress_lola_bin\tderived_pgrb2b_scan48_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "derived_pgrb2b_scan48_bitmap_cress_lola_neg_bin\tderived_pgrb2b_scan48_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -50\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "derived_pgrb2b_scan48_bitmap_cress_lola_negpos_bin\tderived_pgrb2b_scan48_bitmap\tfixtures/grib2_derived/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2\t\t{WGRIB2} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 1:1:1 -cress_lola 130.25:6:0.5 30.5:5:0.5 {out} -1:2\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_uv_new_grid_combined\tderived_gfs_scan48_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\t{MBT} {fixture} -for_n 1:2:1 -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\tcombined_diff\t"
  echo -e "derived_gfs_scan48_uv_new_grid_neighbor_combined\tderived_gfs_scan48_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -new_grid_interpolation neighbor -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\t{MBT} {fixture} -for_n 1:2:1 -new_grid_interpolation neighbor -new_grid latlon 0.25:6:0.5 -89:5:0.5 {out}\tcombined_diff\t"
  echo -e "derived_gfs_scan48_uv_cress_lola_bin\tderived_gfs_scan48_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\t{MBT} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} 1:2\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_uv_cress_lola_neg_bin\tderived_gfs_scan48_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\t{MBT} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -50\tbinary_cmp\t"
  echo -e "derived_gfs_scan48_uv_cress_lola_negpos_bin\tderived_gfs_scan48_uv\tfixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2\t\t{WGRIB2} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\t{MBT} {fixture} -for_n 1:2:1 -cress_lola 0.25:6:0.5 -89:5:0.5 {out} -1:2\tbinary_cmp\t"

  echo -e "derived_gfswave_bitmap254_default\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture}\t{MBT} {fixture}\ttext_diff\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfswave_bitmap254/default.txt"
  echo -e "derived_gfswave_bitmap254_sec6\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -Sec6\t{MBT} {fixture} -Sec6\ttext_diff\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfswave_bitmap254/Sec6.txt"
  echo -e "derived_gfswave_bitmap254_bitmap\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -bitmap\t{MBT} {fixture} -bitmap\ttext_diff\t${INVENTORY_SNAPSHOT_REF_ROOT}/derived_gfswave_bitmap254/bitmap.txt"
  echo -e "derived_gfswave_bitmap254_stats\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -stats\t{MBT} {fixture} -stats\tstats_diff\t"
  echo -e "derived_gfswave_bitmap254_grib_out_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -grib_out {out}\t{MBT} {fixture} -grib_out {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_bitmap254_bin_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -bin {out}\t{MBT} {fixture} -bin {out}\tbinary_cmp\t"
  echo -e "derived_gfswave_bitmap254_ieee_bin\tderived_gfswave_bitmap254\tfixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2\t\t{WGRIB2} {fixture} -ieee {out}\t{MBT} {fixture} -ieee {out}\tbinary_cmp\t"
} > "${TMP_COMPARE_MANIFEST}"

classify_compare_case() {
  local case_id="$1"
  local mode="$2"

  case "${case_id}" in
    *netcdf*)
      printf 'netcdf\n'
      ;;
    *cubeface2global*|*mysql*)
      printf 'compat\n'
      ;;
    *_gribtable_used_*|*_text_out|*_csv_out|*_csv_long_out|*_spread_out|*_gridout_out)
      printf 'format\n'
      ;;
    *_aaig_out|*_aaiglong_out|*_grib_bin|*_grib_out_bin|*_grib_ieee_multi|*_bin_bin|*_ieee_bin|*_tosubmsg_bin|*_write_sec0_bin|*_write_sec8_bin)
      printf 'encode\n'
      ;;
    *grib_out_irr*|*lola*|*new_grid*|*cress_lola*|*ijbox*|*ijsmall_grib*|*small_grib*|*irr_grid*|*reduced_gaussian_grid*)
      printf 'grid\n'
      ;;
    *_submsg_uv_bin|*_ncep_uv_bin|*wind_*|*_ave_bin|*_ave0_bin|*_ave_var_bin|*_fcst_ave_bin|*_fcst_ave0_bin|*_time_processing_bin|*_ens_processing_bin|*_ens_qc_*|*ncep_norm_bin|*merge_fcst_bin|*unmerge_fcst_bin)
      printf 'process\n'
      ;;
    *)
      case "${mode}" in
        text_diff|stats_diff)
          printf 'inventory\n'
          ;;
        *)
          printf 'encode\n'
          ;;
      esac
      ;;
  esac
}

write_selected_compare_manifests() {
  local category
  local case_id
  local compare_mode
  local line

  for category in "${ALL_CATEGORIES[@]}"; do
    if category_enabled "${category}"; then
      mkdir -p "${OUT_DIR}/${category}"
      printf 'case_id\tfixture_id\tfixture_path\tprep\twgrib2_cmd\tmbt_cmd\tcompare_mode\texpected_ref\n' > "${OUT_DIR}/${category}/manifest_v2.tsv"
    fi
  done

  while IFS= read -r line; do
    case_id="$(printf '%s' "${line}" | cut -f1)"
    compare_mode="$(printf '%s' "${line}" | cut -f7)"
    category="$(classify_compare_case "${case_id}" "${compare_mode}")"
    if category_enabled "${category}"; then
      printf '%s\n' "${line}" >> "${OUT_DIR}/${category}/manifest_v2.tsv"
    fi
  done < <(tail -n +2 "${TMP_COMPARE_MANIFEST}")
}

aggregate_legacy_manifest() {
  if [[ -f "${INVENTORY_CATEGORY_DIR}/manifest.tsv" ]]; then
    cp "${INVENTORY_CATEGORY_DIR}/manifest.tsv" "${LEGACY_SNAPSHOT_MANIFEST}"
  else
    printf 'fixture_id\tfixture_path\tcommand\tsnapshot_path\n' > "${LEGACY_SNAPSHOT_MANIFEST}"
  fi
}

aggregate_compare_manifest() {
  local category
  local category_manifest

  printf 'case_id\tfixture_id\tfixture_path\tprep\twgrib2_cmd\tmbt_cmd\tcompare_mode\texpected_ref\n' > "${COMPARE_MANIFEST_V2}"
  for category in "${ALL_CATEGORIES[@]}"; do
    category_manifest="${OUT_DIR}/${category}/manifest_v2.tsv"
    if [[ -f "${category_manifest}" ]]; then
      tail -n +2 "${category_manifest}" >> "${COMPARE_MANIFEST_V2}"
    fi
  done
}

if category_enabled inventory; then
  cp "${TMP_LEGACY_MANIFEST}" "${INVENTORY_CATEGORY_DIR}/manifest.tsv"
fi

write_selected_compare_manifests
aggregate_legacy_manifest
aggregate_compare_manifest

echo "done: ${OUT_DIR}"
echo "  legacy snapshot manifest : ${LEGACY_SNAPSHOT_MANIFEST}"
echo "  compare manifest v2     : ${COMPARE_MANIFEST_V2}"
echo "  selected categories     : $(selected_categories_csv)"
