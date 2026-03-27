#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WGRIB2_BIN="${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2}"
MOON_BIN="${MOON_BIN:-moon}"
OUT_DIR="fixtures/grib2_derived"
DERIVED_GROUPS="${DERIVED_GROUPS:-all}"
ALL_DERIVED_GROUPS=(inventory process netcdf)
SELECTED_DERIVED_GROUPS=()

mark_derived_group() {
  local group="$1"
  if ! derived_group_enabled "${group}"; then
    SELECTED_DERIVED_GROUPS+=("${group}")
  fi
}

derived_group_enabled() {
  local group="$1"
  local selected

  for selected in "${SELECTED_DERIVED_GROUPS[@]:-}"; do
    if [[ "${selected}" == "${group}" ]]; then
      return 0
    fi
  done
  return 1
}

selected_derived_groups_csv() {
  (
    IFS=','
    printf '%s' "${SELECTED_DERIVED_GROUPS[*]}"
  )
}

parse_derived_groups() {
  local group
  local found

  if [[ "${DERIVED_GROUPS}" == "all" ]]; then
    for group in "${ALL_DERIVED_GROUPS[@]}"; do
      mark_derived_group "${group}"
    done
    return
  fi

  IFS=',' read -r -a requested_groups <<< "${DERIVED_GROUPS}"
  for group in "${requested_groups[@]}"; do
    group="${group//[[:space:]]/}"
    [[ -z "${group}" ]] && continue
    found=0
    for known in "${ALL_DERIVED_GROUPS[@]}"; do
      if [[ "${known}" == "${group}" ]]; then
        mark_derived_group "${group}"
        found=1
        break
      fi
    done
    if [[ "${found}" == "0" ]]; then
      echo "error: unknown derived fixture group: ${group}" >&2
      echo "known groups: ${ALL_DERIVED_GROUPS[*]}" >&2
      exit 1
    fi
  done
}

parse_derived_groups

if [[ ! -x "${WGRIB2_BIN}" ]]; then
  echo "error: wgrib2 not found or not executable: ${WGRIB2_BIN}" >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"

scan_source="fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
bitmap_source="fixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2"
forecast_source="fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
forecast_realworld_source="fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
forecast_realworld_source_fh18_33="fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
forecast_realworld_source_fh36_39="fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"

scan32_out="${OUT_DIR}/noaa_gfs_pgrb2_scan32_record1.grib2"
scan48_out="${OUT_DIR}/noaa_gfs_pgrb2_scan48_record1.grib2"
scan32_uv_out="${OUT_DIR}/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2"
scan48_uv_out="${OUT_DIR}/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2"
scan32_bitmap_out="${OUT_DIR}/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2"
scan48_bitmap_out="${OUT_DIR}/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2"
bitmap254_out="${OUT_DIR}/noaa_gfswave_global_bitmap254_records5_6.grib2"
ncep_norm_out="${OUT_DIR}/noaa_gfswave_atlocn_0p16_ncep_norm_input.grib2"
merge_fcst_out="${OUT_DIR}/noaa_gfswave_atlocn_0p16_merge_fcst_input.grib2"
unmerge_fcst_out="${OUT_DIR}/noaa_gfswave_atlocn_0p16_unmerge_fcst_input.grib2"
netcdf_mixed_reference_out="${OUT_DIR}/noaa_gfs_pgrb2_mixed_reference_netcdf_input.grib2"
netcdf_mercator_out="${OUT_DIR}/noaa_gfs_pgrb2_synthetic_mercator_netcdf_input.grib2"
netcdf_mercator_mixed_reference_out="${OUT_DIR}/noaa_gfs_pgrb2_synthetic_mercator_mixed_reference_netcdf_input.grib2"
netcdf_rotated_out="${OUT_DIR}/noaa_gfs_pgrb2_synthetic_rotated_latlon_netcdf_input.grib2"
netcdf_rotated_mixed_reference_out="${OUT_DIR}/noaa_gfs_pgrb2_synthetic_rotated_latlon_mixed_reference_netcdf_input.grib2"
netcdf_polar_out="${OUT_DIR}/noaa_gfs_pgrb2_synthetic_polar_stereographic_netcdf_input.grib2"
netcdf_polar_mixed_reference_out="${OUT_DIR}/noaa_gfs_pgrb2_synthetic_polar_stereographic_mixed_reference_netcdf_input.grib2"
netcdf_lambert_out="${OUT_DIR}/noaa_gfs_pgrb2_synthetic_lambert_conformal_netcdf_input.grib2"
netcdf_lambert_mixed_reference_out="${OUT_DIR}/noaa_gfs_pgrb2_synthetic_lambert_conformal_mixed_reference_netcdf_input.grib2"
realworld_ncep_norm_out="${OUT_DIR}/jma_msm_fh00_15_tmp1000_ncep_norm_input.grib2"
realworld_merge_fcst_out="${OUT_DIR}/jma_msm_fh00_15_tmp1000_merge_fcst_input.grib2"
realworld_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh00_15_tmp1000_unmerge_fcst_input.grib2"
realworld_ugrd_ncep_norm_out="${OUT_DIR}/jma_msm_fh00_15_ugrd1000_ncep_norm_input.grib2"
realworld_ugrd_merge_fcst_out="${OUT_DIR}/jma_msm_fh00_15_ugrd1000_merge_fcst_input.grib2"
realworld_ugrd_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh00_15_ugrd1000_unmerge_fcst_input.grib2"
realworld_vgrd_ncep_norm_out="${OUT_DIR}/jma_msm_fh00_15_vgrd1000_ncep_norm_input.grib2"
realworld_vgrd_merge_fcst_out="${OUT_DIR}/jma_msm_fh00_15_vgrd1000_merge_fcst_input.grib2"
realworld_vgrd_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh00_15_vgrd1000_unmerge_fcst_input.grib2"
realworld_fh18_33_ncep_norm_out="${OUT_DIR}/jma_msm_fh18_33_tmp1000_ncep_norm_input.grib2"
realworld_fh18_33_merge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_tmp1000_merge_fcst_input.grib2"
realworld_fh18_33_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_tmp1000_unmerge_fcst_input.grib2"
realworld_fh18_33_ugrd_ncep_norm_out="${OUT_DIR}/jma_msm_fh18_33_ugrd1000_ncep_norm_input.grib2"
realworld_fh18_33_ugrd_merge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_ugrd1000_merge_fcst_input.grib2"
realworld_fh18_33_ugrd_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_ugrd1000_unmerge_fcst_input.grib2"
realworld_fh18_33_vgrd_ncep_norm_out="${OUT_DIR}/jma_msm_fh18_33_vgrd1000_ncep_norm_input.grib2"
realworld_fh18_33_vgrd_merge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_vgrd1000_merge_fcst_input.grib2"
realworld_fh18_33_vgrd_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_vgrd1000_unmerge_fcst_input.grib2"
realworld_fh36_39_ncep_norm_out="${OUT_DIR}/jma_msm_fh36_39_tmp1000_ncep_norm_input.grib2"
realworld_fh36_39_merge_fcst_out="${OUT_DIR}/jma_msm_fh36_39_tmp1000_merge_fcst_input.grib2"
realworld_fh36_39_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh36_39_tmp1000_unmerge_fcst_input.grib2"
realworld_fh36_39_ugrd_ncep_norm_out="${OUT_DIR}/jma_msm_fh36_39_ugrd1000_ncep_norm_input.grib2"
realworld_fh36_39_ugrd_merge_fcst_out="${OUT_DIR}/jma_msm_fh36_39_ugrd1000_merge_fcst_input.grib2"
realworld_fh36_39_ugrd_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh36_39_ugrd1000_unmerge_fcst_input.grib2"
realworld_fh36_39_vgrd_ncep_norm_out="${OUT_DIR}/jma_msm_fh36_39_vgrd1000_ncep_norm_input.grib2"
realworld_fh36_39_vgrd_merge_fcst_out="${OUT_DIR}/jma_msm_fh36_39_vgrd1000_merge_fcst_input.grib2"
realworld_fh36_39_vgrd_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh36_39_vgrd1000_unmerge_fcst_input.grib2"
realworld_fh18_33_long_ncep_norm_out="${OUT_DIR}/jma_msm_fh18_33_tmp1000_ncep_norm_long_input.grib2"
realworld_fh18_33_long_merge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_tmp1000_merge_fcst_long_input.grib2"
realworld_fh18_33_long_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_tmp1000_unmerge_fcst_long_input.grib2"
realworld_fh18_33_long_ugrd_ncep_norm_out="${OUT_DIR}/jma_msm_fh18_33_ugrd1000_ncep_norm_long_input.grib2"
realworld_fh18_33_long_ugrd_merge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_ugrd1000_merge_fcst_long_input.grib2"
realworld_fh18_33_long_ugrd_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_ugrd1000_unmerge_fcst_long_input.grib2"
realworld_fh18_33_long_vgrd_ncep_norm_out="${OUT_DIR}/jma_msm_fh18_33_vgrd1000_ncep_norm_long_input.grib2"
realworld_fh18_33_long_vgrd_merge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_vgrd1000_merge_fcst_long_input.grib2"
realworld_fh18_33_long_vgrd_unmerge_fcst_out="${OUT_DIR}/jma_msm_fh18_33_vgrd1000_unmerge_fcst_long_input.grib2"

if derived_group_enabled inventory; then
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

  echo "generating derived fixture: ${scan32_uv_out}"
  "${WGRIB2_BIN}" "${scan_source}" \
    -for_n 11:12 \
    -set_grib_type simple \
    -set_flag_table_3.4 32 \
    -rpn 2raw \
    -grib_out "${scan32_uv_out}" \
    >/dev/null

  echo "generating derived fixture: ${scan48_uv_out}"
  "${WGRIB2_BIN}" "${scan_source}" \
    -for_n 11:12 \
    -set_grib_type simple \
    -set_flag_table_3.4 48 \
    -rpn 2raw \
    -grib_out "${scan48_uv_out}" \
    >/dev/null

  echo "generating derived fixture: ${scan32_bitmap_out}"
  "${WGRIB2_BIN}" "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2" \
    -for_n 266:266 \
    -set_grib_type simple \
    -set_flag_table_3.4 32 \
    -rpn 2raw \
    -grib_out "${scan32_bitmap_out}" \
    >/dev/null

  echo "generating derived fixture: ${scan48_bitmap_out}"
  "${WGRIB2_BIN}" "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2" \
    -for_n 266:266 \
    -set_grib_type simple \
    -set_flag_table_3.4 48 \
    -rpn 2raw \
    -grib_out "${scan48_bitmap_out}" \
    >/dev/null

  echo "generating derived fixture: ${bitmap254_out}"
  "${WGRIB2_BIN}" "${bitmap_source}" \
    -for_n 5:6 \
    -tosubmsg "${bitmap254_out}" \
    >/dev/null
fi

generate_forecast_fixture_from_wbtest() {
  local test_filter="$1"
  local generated_path="$2"
  local destination_path="$3"

  echo "generating derived fixture: ${destination_path}"
  "${MOON_BIN}" test cmd/main/main_wbtest.mbt \
    --target native \
    --filter "${test_filter}" \
    >/dev/null
  if [[ ! -s "${generated_path}" ]]; then
    echo "error: expected generated fixture missing: ${generated_path}" >&2
    exit 1
  fi
  cp -f "${generated_path}" "${destination_path}"
}

if derived_group_enabled process; then
  generate_forecast_fixture_from_wbtest \
    "*supports -ncep_norm on synthetic PDT4.8 ave series*" \
    "target/cmd_main_ncep_norm_input.grb2" \
    "${ncep_norm_out}"

  generate_forecast_fixture_from_wbtest \
    "*supports -merge_fcst on synthetic PDT4.8 ave series*" \
    "target/cmd_main_merge_fcst_input.grb2" \
    "${merge_fcst_out}"

  generate_forecast_fixture_from_wbtest \
    "*supports -unmerge_fcst on synthetic PDT4.8 acc series*" \
    "target/cmd_main_unmerge_fcst_input.grb2" \
    "${unmerge_fcst_out}"
fi

if derived_group_enabled netcdf; then
  generate_forecast_fixture_from_wbtest \
    "*writes mixed-reference analysis netcdf fixture*" \
    "target/cmd_main_netcdf_mixed_reference_input.grib2" \
    "${netcdf_mixed_reference_out}"

  generate_forecast_fixture_from_wbtest \
    "*writes synthetic Mercator netcdf fixture*" \
    "target/cmd_main_netcdf_mercator_input.grib2" \
    "${netcdf_mercator_out}"

  generate_forecast_fixture_from_wbtest \
    "*writes synthetic Mercator mixed-reference netcdf fixture*" \
    "target/cmd_main_netcdf_mercator_mixed_reference_input.grib2" \
    "${netcdf_mercator_mixed_reference_out}"

  generate_forecast_fixture_from_wbtest \
    "*writes synthetic rotated lat-lon netcdf fixture*" \
    "target/cmd_main_netcdf_rotated_input.grib2" \
    "${netcdf_rotated_out}"

  generate_forecast_fixture_from_wbtest \
    "*writes synthetic rotated lat-lon mixed-reference netcdf fixture*" \
    "target/cmd_main_netcdf_rotated_mixed_reference_input.grib2" \
    "${netcdf_rotated_mixed_reference_out}"

  generate_forecast_fixture_from_wbtest \
    "*writes synthetic polar stereographic netcdf fixture*" \
    "target/cmd_main_netcdf_polar_input.grib2" \
    "${netcdf_polar_out}"

  generate_forecast_fixture_from_wbtest \
    "*writes synthetic polar stereographic mixed-reference netcdf fixture*" \
    "target/cmd_main_netcdf_polar_mixed_reference_input.grib2" \
    "${netcdf_polar_mixed_reference_out}"

  generate_forecast_fixture_from_wbtest \
    "*writes synthetic Lambert conformal netcdf fixture*" \
    "target/cmd_main_netcdf_lambert_input.grib2" \
    "${netcdf_lambert_out}"

  generate_forecast_fixture_from_wbtest \
    "*writes synthetic Lambert conformal mixed-reference netcdf fixture*" \
    "target/cmd_main_netcdf_lambert_mixed_reference_input.grib2" \
    "${netcdf_lambert_mixed_reference_out}"
fi

if derived_group_enabled process; then
  generate_forecast_fixture_from_wbtest \
    "*supports -ncep_norm on real-world-derived PDT4.8 ave series*" \
    "target/cmd_main_ncep_norm_realworld_input.grb2" \
    "${realworld_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series*" \
  "target/cmd_main_merge_fcst_realworld_input.grb2" \
  "${realworld_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series*" \
  "target/cmd_main_unmerge_fcst_realworld_input.grb2" \
  "${realworld_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD)*" \
  "target/cmd_main_ncep_norm_realworld_ugrd_input.grb2" \
  "${realworld_ugrd_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD)*" \
  "target/cmd_main_merge_fcst_realworld_ugrd_input.grb2" \
  "${realworld_ugrd_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD)*" \
  "target/cmd_main_unmerge_fcst_realworld_ugrd_input.grb2" \
  "${realworld_ugrd_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD)*" \
  "target/cmd_main_ncep_norm_realworld_vgrd_input.grb2" \
  "${realworld_vgrd_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD)*" \
  "target/cmd_main_merge_fcst_realworld_vgrd_input.grb2" \
  "${realworld_vgrd_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD)*" \
  "target/cmd_main_unmerge_fcst_realworld_vgrd_input.grb2" \
  "${realworld_vgrd_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (FH18-33)*" \
  "target/cmd_main_ncep_norm_realworld_fh18_33_input.grb2" \
  "${realworld_fh18_33_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (FH18-33)*" \
  "target/cmd_main_merge_fcst_realworld_fh18_33_input.grb2" \
  "${realworld_fh18_33_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH18-33)*" \
  "target/cmd_main_unmerge_fcst_realworld_fh18_33_input.grb2" \
  "${realworld_fh18_33_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH18-33)*" \
  "target/cmd_main_ncep_norm_realworld_fh18_33_ugrd_input.grb2" \
  "${realworld_fh18_33_ugrd_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH18-33)*" \
  "target/cmd_main_merge_fcst_realworld_fh18_33_ugrd_input.grb2" \
  "${realworld_fh18_33_ugrd_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH18-33)*" \
  "target/cmd_main_unmerge_fcst_realworld_fh18_33_ugrd_input.grb2" \
  "${realworld_fh18_33_ugrd_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH18-33)*" \
  "target/cmd_main_ncep_norm_realworld_fh18_33_vgrd_input.grb2" \
  "${realworld_fh18_33_vgrd_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH18-33)*" \
  "target/cmd_main_merge_fcst_realworld_fh18_33_vgrd_input.grb2" \
  "${realworld_fh18_33_vgrd_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH18-33)*" \
  "target/cmd_main_unmerge_fcst_realworld_fh18_33_vgrd_input.grb2" \
  "${realworld_fh18_33_vgrd_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (FH36-39)*" \
  "target/cmd_main_ncep_norm_realworld_fh36_39_input.grb2" \
  "${realworld_fh36_39_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (FH36-39)*" \
  "target/cmd_main_merge_fcst_realworld_fh36_39_input.grb2" \
  "${realworld_fh36_39_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH36-39)*" \
  "target/cmd_main_unmerge_fcst_realworld_fh36_39_input.grb2" \
  "${realworld_fh36_39_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH36-39)*" \
  "target/cmd_main_ncep_norm_realworld_fh36_39_ugrd_input.grb2" \
  "${realworld_fh36_39_ugrd_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH36-39)*" \
  "target/cmd_main_merge_fcst_realworld_fh36_39_ugrd_input.grb2" \
  "${realworld_fh36_39_ugrd_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH36-39)*" \
  "target/cmd_main_unmerge_fcst_realworld_fh36_39_ugrd_input.grb2" \
  "${realworld_fh36_39_ugrd_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH36-39)*" \
  "target/cmd_main_ncep_norm_realworld_fh36_39_vgrd_input.grb2" \
  "${realworld_fh36_39_vgrd_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH36-39)*" \
  "target/cmd_main_merge_fcst_realworld_fh36_39_vgrd_input.grb2" \
  "${realworld_fh36_39_vgrd_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH36-39)*" \
  "target/cmd_main_unmerge_fcst_realworld_fh36_39_vgrd_input.grb2" \
  "${realworld_fh36_39_vgrd_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (FH18-33 long)*" \
  "target/cmd_main_ncep_norm_realworld_fh18_33_long_input.grb2" \
  "${realworld_fh18_33_long_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (FH18-33 long)*" \
  "target/cmd_main_merge_fcst_realworld_fh18_33_long_input.grb2" \
  "${realworld_fh18_33_long_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH18-33 long)*" \
  "target/cmd_main_unmerge_fcst_realworld_fh18_33_long_input.grb2" \
  "${realworld_fh18_33_long_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH18-33 long)*" \
  "target/cmd_main_ncep_norm_realworld_fh18_33_ugrd_long_input.grb2" \
  "${realworld_fh18_33_long_ugrd_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH18-33 long)*" \
  "target/cmd_main_merge_fcst_realworld_fh18_33_ugrd_long_input.grb2" \
  "${realworld_fh18_33_long_ugrd_merge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH18-33 long)*" \
  "target/cmd_main_unmerge_fcst_realworld_fh18_33_ugrd_long_input.grb2" \
  "${realworld_fh18_33_long_ugrd_unmerge_fcst_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH18-33 long)*" \
  "target/cmd_main_ncep_norm_realworld_fh18_33_vgrd_long_input.grb2" \
  "${realworld_fh18_33_long_vgrd_ncep_norm_out}"

generate_forecast_fixture_from_wbtest \
  "*supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH18-33 long)*" \
  "target/cmd_main_merge_fcst_realworld_fh18_33_vgrd_long_input.grb2" \
  "${realworld_fh18_33_long_vgrd_merge_fcst_out}"

  generate_forecast_fixture_from_wbtest \
    "*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH18-33 long)*" \
    "target/cmd_main_unmerge_fcst_realworld_fh18_33_vgrd_long_input.grb2" \
    "${realworld_fh18_33_long_vgrd_unmerge_fcst_out}"
fi

if [[ "${DERIVED_GROUPS}" != "all" ]]; then
  echo "done: ${OUT_DIR}"
  echo "  selected derived groups : $(selected_derived_groups_csv)"
  exit 0
fi

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
scan32_uv_sha="$(shasum -a 256 "${scan32_uv_out}" | awk '{print $1}')"
scan48_uv_sha="$(shasum -a 256 "${scan48_uv_out}" | awk '{print $1}')"
scan32_bitmap_sha="$(shasum -a 256 "${scan32_bitmap_out}" | awk '{print $1}')"
scan48_bitmap_sha="$(shasum -a 256 "${scan48_bitmap_out}" | awk '{print $1}')"
bitmap254_sha="$(shasum -a 256 "${bitmap254_out}" | awk '{print $1}')"
ncep_norm_sha="$(shasum -a 256 "${ncep_norm_out}" | awk '{print $1}')"
merge_fcst_sha="$(shasum -a 256 "${merge_fcst_out}" | awk '{print $1}')"
unmerge_fcst_sha="$(shasum -a 256 "${unmerge_fcst_out}" | awk '{print $1}')"
netcdf_mixed_reference_sha="$(shasum -a 256 "${netcdf_mixed_reference_out}" | awk '{print $1}')"
netcdf_mercator_sha="$(shasum -a 256 "${netcdf_mercator_out}" | awk '{print $1}')"
netcdf_mercator_mixed_reference_sha="$(shasum -a 256 "${netcdf_mercator_mixed_reference_out}" | awk '{print $1}')"
netcdf_rotated_sha="$(shasum -a 256 "${netcdf_rotated_out}" | awk '{print $1}')"
netcdf_rotated_mixed_reference_sha="$(shasum -a 256 "${netcdf_rotated_mixed_reference_out}" | awk '{print $1}')"
netcdf_polar_sha="$(shasum -a 256 "${netcdf_polar_out}" | awk '{print $1}')"
netcdf_polar_mixed_reference_sha="$(shasum -a 256 "${netcdf_polar_mixed_reference_out}" | awk '{print $1}')"
netcdf_lambert_sha="$(shasum -a 256 "${netcdf_lambert_out}" | awk '{print $1}')"
netcdf_lambert_mixed_reference_sha="$(shasum -a 256 "${netcdf_lambert_mixed_reference_out}" | awk '{print $1}')"
realworld_ncep_norm_sha="$(shasum -a 256 "${realworld_ncep_norm_out}" | awk '{print $1}')"
realworld_merge_fcst_sha="$(shasum -a 256 "${realworld_merge_fcst_out}" | awk '{print $1}')"
realworld_unmerge_fcst_sha="$(shasum -a 256 "${realworld_unmerge_fcst_out}" | awk '{print $1}')"
realworld_ugrd_ncep_norm_sha="$(shasum -a 256 "${realworld_ugrd_ncep_norm_out}" | awk '{print $1}')"
realworld_ugrd_merge_fcst_sha="$(shasum -a 256 "${realworld_ugrd_merge_fcst_out}" | awk '{print $1}')"
realworld_ugrd_unmerge_fcst_sha="$(shasum -a 256 "${realworld_ugrd_unmerge_fcst_out}" | awk '{print $1}')"
realworld_vgrd_ncep_norm_sha="$(shasum -a 256 "${realworld_vgrd_ncep_norm_out}" | awk '{print $1}')"
realworld_vgrd_merge_fcst_sha="$(shasum -a 256 "${realworld_vgrd_merge_fcst_out}" | awk '{print $1}')"
realworld_vgrd_unmerge_fcst_sha="$(shasum -a 256 "${realworld_vgrd_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_ncep_norm_sha="$(shasum -a 256 "${realworld_fh18_33_ncep_norm_out}" | awk '{print $1}')"
realworld_fh18_33_merge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_merge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_ugrd_ncep_norm_sha="$(shasum -a 256 "${realworld_fh18_33_ugrd_ncep_norm_out}" | awk '{print $1}')"
realworld_fh18_33_ugrd_merge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_ugrd_merge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_ugrd_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_ugrd_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_vgrd_ncep_norm_sha="$(shasum -a 256 "${realworld_fh18_33_vgrd_ncep_norm_out}" | awk '{print $1}')"
realworld_fh18_33_vgrd_merge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_vgrd_merge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_vgrd_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_vgrd_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh36_39_ncep_norm_sha="$(shasum -a 256 "${realworld_fh36_39_ncep_norm_out}" | awk '{print $1}')"
realworld_fh36_39_merge_fcst_sha="$(shasum -a 256 "${realworld_fh36_39_merge_fcst_out}" | awk '{print $1}')"
realworld_fh36_39_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh36_39_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh36_39_ugrd_ncep_norm_sha="$(shasum -a 256 "${realworld_fh36_39_ugrd_ncep_norm_out}" | awk '{print $1}')"
realworld_fh36_39_ugrd_merge_fcst_sha="$(shasum -a 256 "${realworld_fh36_39_ugrd_merge_fcst_out}" | awk '{print $1}')"
realworld_fh36_39_ugrd_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh36_39_ugrd_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh36_39_vgrd_ncep_norm_sha="$(shasum -a 256 "${realworld_fh36_39_vgrd_ncep_norm_out}" | awk '{print $1}')"
realworld_fh36_39_vgrd_merge_fcst_sha="$(shasum -a 256 "${realworld_fh36_39_vgrd_merge_fcst_out}" | awk '{print $1}')"
realworld_fh36_39_vgrd_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh36_39_vgrd_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_long_ncep_norm_sha="$(shasum -a 256 "${realworld_fh18_33_long_ncep_norm_out}" | awk '{print $1}')"
realworld_fh18_33_long_merge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_long_merge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_long_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_long_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_long_ugrd_ncep_norm_sha="$(shasum -a 256 "${realworld_fh18_33_long_ugrd_ncep_norm_out}" | awk '{print $1}')"
realworld_fh18_33_long_ugrd_merge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_long_ugrd_merge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_long_ugrd_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_long_ugrd_unmerge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_long_vgrd_ncep_norm_sha="$(shasum -a 256 "${realworld_fh18_33_long_vgrd_ncep_norm_out}" | awk '{print $1}')"
realworld_fh18_33_long_vgrd_merge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_long_vgrd_merge_fcst_out}" | awk '{print $1}')"
realworld_fh18_33_long_vgrd_unmerge_fcst_sha="$(shasum -a 256 "${realworld_fh18_33_long_vgrd_unmerge_fcst_out}" | awk '{print $1}')"

scan32_size="$(wc -c < "${scan32_out}" | tr -d ' ')"
scan48_size="$(wc -c < "${scan48_out}" | tr -d ' ')"
scan32_uv_size="$(wc -c < "${scan32_uv_out}" | tr -d ' ')"
scan48_uv_size="$(wc -c < "${scan48_uv_out}" | tr -d ' ')"
scan32_bitmap_size="$(wc -c < "${scan32_bitmap_out}" | tr -d ' ')"
scan48_bitmap_size="$(wc -c < "${scan48_bitmap_out}" | tr -d ' ')"
ncep_norm_size="$(wc -c < "${ncep_norm_out}" | tr -d ' ')"
merge_fcst_size="$(wc -c < "${merge_fcst_out}" | tr -d ' ')"
unmerge_fcst_size="$(wc -c < "${unmerge_fcst_out}" | tr -d ' ')"
netcdf_mixed_reference_size="$(wc -c < "${netcdf_mixed_reference_out}" | tr -d ' ')"
netcdf_mercator_size="$(wc -c < "${netcdf_mercator_out}" | tr -d ' ')"
netcdf_mercator_mixed_reference_size="$(wc -c < "${netcdf_mercator_mixed_reference_out}" | tr -d ' ')"
netcdf_rotated_size="$(wc -c < "${netcdf_rotated_out}" | tr -d ' ')"
netcdf_rotated_mixed_reference_size="$(wc -c < "${netcdf_rotated_mixed_reference_out}" | tr -d ' ')"
netcdf_polar_size="$(wc -c < "${netcdf_polar_out}" | tr -d ' ')"
netcdf_polar_mixed_reference_size="$(wc -c < "${netcdf_polar_mixed_reference_out}" | tr -d ' ')"
netcdf_lambert_size="$(wc -c < "${netcdf_lambert_out}" | tr -d ' ')"
netcdf_lambert_mixed_reference_size="$(wc -c < "${netcdf_lambert_mixed_reference_out}" | tr -d ' ')"
realworld_ncep_norm_size="$(wc -c < "${realworld_ncep_norm_out}" | tr -d ' ')"
realworld_merge_fcst_size="$(wc -c < "${realworld_merge_fcst_out}" | tr -d ' ')"
realworld_unmerge_fcst_size="$(wc -c < "${realworld_unmerge_fcst_out}" | tr -d ' ')"
realworld_ugrd_ncep_norm_size="$(wc -c < "${realworld_ugrd_ncep_norm_out}" | tr -d ' ')"
realworld_ugrd_merge_fcst_size="$(wc -c < "${realworld_ugrd_merge_fcst_out}" | tr -d ' ')"
realworld_ugrd_unmerge_fcst_size="$(wc -c < "${realworld_ugrd_unmerge_fcst_out}" | tr -d ' ')"
realworld_vgrd_ncep_norm_size="$(wc -c < "${realworld_vgrd_ncep_norm_out}" | tr -d ' ')"
realworld_vgrd_merge_fcst_size="$(wc -c < "${realworld_vgrd_merge_fcst_out}" | tr -d ' ')"
realworld_vgrd_unmerge_fcst_size="$(wc -c < "${realworld_vgrd_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_ncep_norm_size="$(wc -c < "${realworld_fh18_33_ncep_norm_out}" | tr -d ' ')"
realworld_fh18_33_merge_fcst_size="$(wc -c < "${realworld_fh18_33_merge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_unmerge_fcst_size="$(wc -c < "${realworld_fh18_33_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_ugrd_ncep_norm_size="$(wc -c < "${realworld_fh18_33_ugrd_ncep_norm_out}" | tr -d ' ')"
realworld_fh18_33_ugrd_merge_fcst_size="$(wc -c < "${realworld_fh18_33_ugrd_merge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_ugrd_unmerge_fcst_size="$(wc -c < "${realworld_fh18_33_ugrd_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_vgrd_ncep_norm_size="$(wc -c < "${realworld_fh18_33_vgrd_ncep_norm_out}" | tr -d ' ')"
realworld_fh18_33_vgrd_merge_fcst_size="$(wc -c < "${realworld_fh18_33_vgrd_merge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_vgrd_unmerge_fcst_size="$(wc -c < "${realworld_fh18_33_vgrd_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh36_39_ncep_norm_size="$(wc -c < "${realworld_fh36_39_ncep_norm_out}" | tr -d ' ')"
realworld_fh36_39_merge_fcst_size="$(wc -c < "${realworld_fh36_39_merge_fcst_out}" | tr -d ' ')"
realworld_fh36_39_unmerge_fcst_size="$(wc -c < "${realworld_fh36_39_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh36_39_ugrd_ncep_norm_size="$(wc -c < "${realworld_fh36_39_ugrd_ncep_norm_out}" | tr -d ' ')"
realworld_fh36_39_ugrd_merge_fcst_size="$(wc -c < "${realworld_fh36_39_ugrd_merge_fcst_out}" | tr -d ' ')"
realworld_fh36_39_ugrd_unmerge_fcst_size="$(wc -c < "${realworld_fh36_39_ugrd_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh36_39_vgrd_ncep_norm_size="$(wc -c < "${realworld_fh36_39_vgrd_ncep_norm_out}" | tr -d ' ')"
realworld_fh36_39_vgrd_merge_fcst_size="$(wc -c < "${realworld_fh36_39_vgrd_merge_fcst_out}" | tr -d ' ')"
realworld_fh36_39_vgrd_unmerge_fcst_size="$(wc -c < "${realworld_fh36_39_vgrd_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_long_ncep_norm_size="$(wc -c < "${realworld_fh18_33_long_ncep_norm_out}" | tr -d ' ')"
realworld_fh18_33_long_merge_fcst_size="$(wc -c < "${realworld_fh18_33_long_merge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_long_unmerge_fcst_size="$(wc -c < "${realworld_fh18_33_long_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_long_ugrd_ncep_norm_size="$(wc -c < "${realworld_fh18_33_long_ugrd_ncep_norm_out}" | tr -d ' ')"
realworld_fh18_33_long_ugrd_merge_fcst_size="$(wc -c < "${realworld_fh18_33_long_ugrd_merge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_long_ugrd_unmerge_fcst_size="$(wc -c < "${realworld_fh18_33_long_ugrd_unmerge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_long_vgrd_ncep_norm_size="$(wc -c < "${realworld_fh18_33_long_vgrd_ncep_norm_out}" | tr -d ' ')"
realworld_fh18_33_long_vgrd_merge_fcst_size="$(wc -c < "${realworld_fh18_33_long_vgrd_merge_fcst_out}" | tr -d ' ')"
realworld_fh18_33_long_vgrd_unmerge_fcst_size="$(wc -c < "${realworld_fh18_33_long_vgrd_unmerge_fcst_out}" | tr -d ' ')"

cat > "${OUT_DIR}/manifest.tsv" <<EOF
file	size_bytes	sha256	source_fixture	source_command	notes
noaa_gfs_pgrb2_scan32_record1.grib2	${scan32_size}	${scan32_sha}	${scan_source}	${WGRIB2_BIN} ${scan_source} -for_n 1:1 -set_grib_type simple -set_flag_table_3.4 32 -rpn 2raw -grib_out ${scan32_out}	record 1 re-encoded with flag_table_3.4=32 (NS:WE, consecutive_j)
noaa_gfs_pgrb2_scan48_record1.grib2	${scan48_size}	${scan48_sha}	${scan_source}	${WGRIB2_BIN} ${scan_source} -for_n 1:1 -set_grib_type simple -set_flag_table_3.4 48 -rpn 2raw -grib_out ${scan48_out}	record 1 re-encoded with flag_table_3.4=48 (NS(W|E), consecutive_j + alternating_rows)
noaa_gfs_pgrb2_scan32_uv_records11_12.grib2	${scan32_uv_size}	${scan32_uv_sha}	${scan_source}	${WGRIB2_BIN} ${scan_source} -for_n 11:12 -set_grib_type simple -set_flag_table_3.4 32 -rpn 2raw -grib_out ${scan32_uv_out}	records 11:12 re-encoded with flag_table_3.4=32 (NS:WE, consecutive_j) for exact -new_grid U/V compare
noaa_gfs_pgrb2_scan48_uv_records11_12.grib2	${scan48_uv_size}	${scan48_uv_sha}	${scan_source}	${WGRIB2_BIN} ${scan_source} -for_n 11:12 -set_grib_type simple -set_flag_table_3.4 48 -rpn 2raw -grib_out ${scan48_uv_out}	records 11:12 re-encoded with flag_table_3.4=48 (NS(W|E), consecutive_j + alternating_rows) for exact -new_grid U/V notice compare
noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2	${scan32_bitmap_size}	${scan32_bitmap_sha}	fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2	${WGRIB2_BIN} fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2 -for_n 266:266 -set_grib_type simple -set_flag_table_3.4 32 -rpn 2raw -grib_out ${scan32_bitmap_out}	record 266 re-encoded with flag_table_3.4=32 (NS:WE, consecutive_j) for exact bitmap -new_grid/-cress_lola compare
noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2	${scan48_bitmap_size}	${scan48_bitmap_sha}	fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2	${WGRIB2_BIN} fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2 -for_n 266:266 -set_grib_type simple -set_flag_table_3.4 48 -rpn 2raw -grib_out ${scan48_bitmap_out}	record 266 re-encoded with flag_table_3.4=48 (NS(W|E), consecutive_j + alternating_rows) for bitmap -new_grid notice compare and exact -cress_lola compare
noaa_gfswave_global_bitmap254_records5_6.grib2	${bitmap254_size}	${bitmap254_sha}	${bitmap_source}	${WGRIB2_BIN} ${bitmap_source} -for_n 5:6 -tosubmsg ${bitmap254_out}	records 5:6 merged into one message; raw file contains Sec6 repeat marker 0000000606fe and wgrib2 resolves it to the previous bitmap in inventory output
noaa_gfswave_atlocn_0p16_ncep_norm_input.grib2	${ncep_norm_size}	${ncep_norm_sha}	${forecast_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on synthetic PDT4.8 ave series*'	synthetic PDT 4.8 ave series derived from gfswave record 1 by write_synthetic_forecast_input; used for exact -ncep_norm compare
noaa_gfswave_atlocn_0p16_merge_fcst_input.grib2	${merge_fcst_size}	${merge_fcst_sha}	${forecast_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on synthetic PDT4.8 ave series*'	synthetic PDT 4.8 ave series derived from gfswave record 1 by write_synthetic_forecast_input; used for exact -merge_fcst compare
noaa_gfswave_atlocn_0p16_unmerge_fcst_input.grib2	${unmerge_fcst_size}	${unmerge_fcst_sha}	${forecast_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on synthetic PDT4.8 acc series*'	synthetic PDT 4.8 acc series derived from gfswave record 1 by write_synthetic_forecast_input; used for exact -unmerge_fcst compare
noaa_gfs_pgrb2_mixed_reference_netcdf_input.grib2	${netcdf_mixed_reference_size}	${netcdf_mixed_reference_sha}	${scan_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes mixed-reference analysis netcdf fixture*'	two-record analysis GRIB2 built from NOAA GFS pgrb2 record 1 with second record reference time shifted by +6h; used for exact -netcdf mixed-reference compare
noaa_gfs_pgrb2_synthetic_mercator_netcdf_input.grib2	${netcdf_mercator_size}	${netcdf_mercator_sha}	${forecast_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes synthetic Mercator netcdf fixture*'	single-record spherical Mercator GRIB2 built from NOAA GFS waveatlocn record 1; used for exact -netcdf Mercator compare
noaa_gfs_pgrb2_synthetic_mercator_mixed_reference_netcdf_input.grib2	${netcdf_mercator_mixed_reference_size}	${netcdf_mercator_mixed_reference_sha}	${forecast_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes synthetic Mercator mixed-reference netcdf fixture*'	two-record spherical Mercator GRIB2 built from NOAA GFS waveatlocn record 1 with second record reference time shifted by +6h; used for exact -netcdf Mercator mixed-reference compare
noaa_gfs_pgrb2_synthetic_rotated_latlon_netcdf_input.grib2	${netcdf_rotated_size}	${netcdf_rotated_sha}	${scan_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes synthetic rotated lat-lon netcdf fixture*'	single-record rotated lat-lon GRIB2 built from NOAA GFS pgrb2 record 1; used for exact -netcdf combined compare of notice lines and output file
noaa_gfs_pgrb2_synthetic_rotated_latlon_mixed_reference_netcdf_input.grib2	${netcdf_rotated_mixed_reference_size}	${netcdf_rotated_mixed_reference_sha}	${scan_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes synthetic rotated lat-lon mixed-reference netcdf fixture*'	two-record rotated lat-lon GRIB2 built from NOAA GFS pgrb2 record 1 with second record reference time shifted by +6h; used for exact -netcdf rotated lat-lon mixed-reference compare
noaa_gfs_pgrb2_synthetic_polar_stereographic_netcdf_input.grib2	${netcdf_polar_size}	${netcdf_polar_sha}	${scan_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes synthetic polar stereographic netcdf fixture*'	single-record polar stereographic GRIB2 built from NOAA GFS pgrb2 record 1; used for exact -netcdf polar stereographic compare
noaa_gfs_pgrb2_synthetic_polar_stereographic_mixed_reference_netcdf_input.grib2	${netcdf_polar_mixed_reference_size}	${netcdf_polar_mixed_reference_sha}	${scan_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes synthetic polar stereographic mixed-reference netcdf fixture*'	two-record polar stereographic GRIB2 built from NOAA GFS pgrb2 record 1 with second record reference time shifted by +6h; used for exact -netcdf polar stereographic mixed-reference compare
noaa_gfs_pgrb2_synthetic_lambert_conformal_netcdf_input.grib2	${netcdf_lambert_size}	${netcdf_lambert_sha}	${scan_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes synthetic Lambert conformal netcdf fixture*'	single-record Lambert conformal GRIB2 built from NOAA GFS pgrb2 record 1; used for exact -netcdf Lambert conformal compare
noaa_gfs_pgrb2_synthetic_lambert_conformal_mixed_reference_netcdf_input.grib2	${netcdf_lambert_mixed_reference_size}	${netcdf_lambert_mixed_reference_sha}	${scan_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*writes synthetic Lambert conformal mixed-reference netcdf fixture*'	two-record Lambert conformal GRIB2 built from NOAA GFS pgrb2 record 1 with second record reference time shifted by +6h; used for exact -netcdf Lambert conformal mixed-reference compare
jma_msm_fh00_15_tmp1000_ncep_norm_input.grib2	${realworld_ncep_norm_size}	${realworld_ncep_norm_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series*'	real-value PDT 4.8 ave series built from JMA MSM FH00-15 TMP:1000 mb records 96/188/280/372; used for exact -ncep_norm compare
jma_msm_fh00_15_tmp1000_merge_fcst_input.grib2	${realworld_merge_fcst_size}	${realworld_merge_fcst_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series*'	real-value PDT 4.8 ave series built from JMA MSM FH00-15 TMP:1000 mb records 96/188/280/372; used for exact -merge_fcst compare
jma_msm_fh00_15_tmp1000_unmerge_fcst_input.grib2	${realworld_unmerge_fcst_size}	${realworld_unmerge_fcst_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH00-15 TMP:1000 mb records 96/188/280/372; used for exact -unmerge_fcst compare
jma_msm_fh00_15_ugrd1000_ncep_norm_input.grib2	${realworld_ugrd_ncep_norm_size}	${realworld_ugrd_ncep_norm_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD)*'	real-value PDT 4.8 ave series built from JMA MSM FH00-15 UGRD:1000 mb records 94/186/278/370; used for exact -ncep_norm compare
jma_msm_fh00_15_ugrd1000_merge_fcst_input.grib2	${realworld_ugrd_merge_fcst_size}	${realworld_ugrd_merge_fcst_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD)*'	real-value PDT 4.8 ave series built from JMA MSM FH00-15 UGRD:1000 mb records 94/186/278/370; used for exact -merge_fcst compare
jma_msm_fh00_15_ugrd1000_unmerge_fcst_input.grib2	${realworld_ugrd_unmerge_fcst_size}	${realworld_ugrd_unmerge_fcst_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH00-15 UGRD:1000 mb records 94/186/278/370; used for exact -unmerge_fcst compare
jma_msm_fh00_15_vgrd1000_ncep_norm_input.grib2	${realworld_vgrd_ncep_norm_size}	${realworld_vgrd_ncep_norm_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD)*'	real-value PDT 4.8 ave series built from JMA MSM FH00-15 VGRD:1000 mb records 95/187/279/371; used for exact -ncep_norm compare
jma_msm_fh00_15_vgrd1000_merge_fcst_input.grib2	${realworld_vgrd_merge_fcst_size}	${realworld_vgrd_merge_fcst_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD)*'	real-value PDT 4.8 ave series built from JMA MSM FH00-15 VGRD:1000 mb records 95/187/279/371; used for exact -merge_fcst compare
jma_msm_fh00_15_vgrd1000_unmerge_fcst_input.grib2	${realworld_vgrd_unmerge_fcst_size}	${realworld_vgrd_unmerge_fcst_sha}	${forecast_realworld_source}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH00-15 VGRD:1000 mb records 95/187/279/371; used for exact -unmerge_fcst compare
jma_msm_fh18_33_tmp1000_ncep_norm_input.grib2	${realworld_fh18_33_ncep_norm_size}	${realworld_fh18_33_ncep_norm_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (FH18-33)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 TMP:1000 mb records 4/96/188/280; used for exact -ncep_norm compare
jma_msm_fh18_33_tmp1000_merge_fcst_input.grib2	${realworld_fh18_33_merge_fcst_size}	${realworld_fh18_33_merge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (FH18-33)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 TMP:1000 mb records 4/96/188/280; used for exact -merge_fcst compare
jma_msm_fh18_33_tmp1000_unmerge_fcst_input.grib2	${realworld_fh18_33_unmerge_fcst_size}	${realworld_fh18_33_unmerge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH18-33)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH18-33 TMP:1000 mb records 4/96/188/280; used for exact -unmerge_fcst compare
jma_msm_fh18_33_ugrd1000_ncep_norm_input.grib2	${realworld_fh18_33_ugrd_ncep_norm_size}	${realworld_fh18_33_ugrd_ncep_norm_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH18-33)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 UGRD:1000 mb records 2/94/186/278; used for exact -ncep_norm compare
jma_msm_fh18_33_ugrd1000_merge_fcst_input.grib2	${realworld_fh18_33_ugrd_merge_fcst_size}	${realworld_fh18_33_ugrd_merge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH18-33)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 UGRD:1000 mb records 2/94/186/278; used for exact -merge_fcst compare
jma_msm_fh18_33_ugrd1000_unmerge_fcst_input.grib2	${realworld_fh18_33_ugrd_unmerge_fcst_size}	${realworld_fh18_33_ugrd_unmerge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH18-33)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH18-33 UGRD:1000 mb records 2/94/186/278; used for exact -unmerge_fcst compare
jma_msm_fh18_33_vgrd1000_ncep_norm_input.grib2	${realworld_fh18_33_vgrd_ncep_norm_size}	${realworld_fh18_33_vgrd_ncep_norm_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH18-33)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 VGRD:1000 mb records 3/95/187/279; used for exact -ncep_norm compare
jma_msm_fh18_33_vgrd1000_merge_fcst_input.grib2	${realworld_fh18_33_vgrd_merge_fcst_size}	${realworld_fh18_33_vgrd_merge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH18-33)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 VGRD:1000 mb records 3/95/187/279; used for exact -merge_fcst compare
jma_msm_fh18_33_vgrd1000_unmerge_fcst_input.grib2	${realworld_fh18_33_vgrd_unmerge_fcst_size}	${realworld_fh18_33_vgrd_unmerge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH18-33)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH18-33 VGRD:1000 mb records 3/95/187/279; used for exact -unmerge_fcst compare
jma_msm_fh36_39_tmp1000_ncep_norm_input.grib2	${realworld_fh36_39_ncep_norm_size}	${realworld_fh36_39_ncep_norm_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (FH36-39)*'	real-value PDT 4.8 ave series built from JMA MSM FH36-39 TMP:1000 mb records 4/96; used for exact -ncep_norm compare
jma_msm_fh36_39_tmp1000_merge_fcst_input.grib2	${realworld_fh36_39_merge_fcst_size}	${realworld_fh36_39_merge_fcst_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (FH36-39)*'	real-value PDT 4.8 ave series built from JMA MSM FH36-39 TMP:1000 mb records 4/96; used for exact -merge_fcst compare
jma_msm_fh36_39_tmp1000_unmerge_fcst_input.grib2	${realworld_fh36_39_unmerge_fcst_size}	${realworld_fh36_39_unmerge_fcst_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH36-39)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH36-39 TMP:1000 mb records 4/96; used for exact -unmerge_fcst compare
jma_msm_fh36_39_ugrd1000_ncep_norm_input.grib2	${realworld_fh36_39_ugrd_ncep_norm_size}	${realworld_fh36_39_ugrd_ncep_norm_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH36-39)*'	real-value PDT 4.8 ave series built from JMA MSM FH36-39 UGRD:1000 mb records 2/94; used for exact -ncep_norm compare
jma_msm_fh36_39_ugrd1000_merge_fcst_input.grib2	${realworld_fh36_39_ugrd_merge_fcst_size}	${realworld_fh36_39_ugrd_merge_fcst_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH36-39)*'	real-value PDT 4.8 ave series built from JMA MSM FH36-39 UGRD:1000 mb records 2/94; used for exact -merge_fcst compare
jma_msm_fh36_39_ugrd1000_unmerge_fcst_input.grib2	${realworld_fh36_39_ugrd_unmerge_fcst_size}	${realworld_fh36_39_ugrd_unmerge_fcst_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH36-39)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH36-39 UGRD:1000 mb records 2/94; used for exact -unmerge_fcst compare
jma_msm_fh36_39_vgrd1000_ncep_norm_input.grib2	${realworld_fh36_39_vgrd_ncep_norm_size}	${realworld_fh36_39_vgrd_ncep_norm_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH36-39)*'	real-value PDT 4.8 ave series built from JMA MSM FH36-39 VGRD:1000 mb records 3/95; used for exact -ncep_norm compare
jma_msm_fh36_39_vgrd1000_merge_fcst_input.grib2	${realworld_fh36_39_vgrd_merge_fcst_size}	${realworld_fh36_39_vgrd_merge_fcst_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH36-39)*'	real-value PDT 4.8 ave series built from JMA MSM FH36-39 VGRD:1000 mb records 3/95; used for exact -merge_fcst compare
jma_msm_fh36_39_vgrd1000_unmerge_fcst_input.grib2	${realworld_fh36_39_vgrd_unmerge_fcst_size}	${realworld_fh36_39_vgrd_unmerge_fcst_sha}	${forecast_realworld_source_fh36_39}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH36-39)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH36-39 VGRD:1000 mb records 3/95; used for exact -unmerge_fcst compare
jma_msm_fh18_33_tmp1000_ncep_norm_long_input.grib2	${realworld_fh18_33_long_ncep_norm_size}	${realworld_fh18_33_long_ncep_norm_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (FH18-33 long)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 TMP:1000 mb records 4/96/188/280/372/464; used for exact long-series -ncep_norm compare
jma_msm_fh18_33_tmp1000_merge_fcst_long_input.grib2	${realworld_fh18_33_long_merge_fcst_size}	${realworld_fh18_33_long_merge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (FH18-33 long)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 TMP:1000 mb records 4/96/188/280/372/464; used for exact long-series -merge_fcst compare
jma_msm_fh18_33_tmp1000_unmerge_fcst_long_input.grib2	${realworld_fh18_33_long_unmerge_fcst_size}	${realworld_fh18_33_long_unmerge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH18-33 long)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH18-33 TMP:1000 mb records 4/96/188/280/372/464; used for exact long-series -unmerge_fcst compare
jma_msm_fh18_33_ugrd1000_ncep_norm_long_input.grib2	${realworld_fh18_33_long_ugrd_ncep_norm_size}	${realworld_fh18_33_long_ugrd_ncep_norm_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH18-33 long)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 UGRD:1000 mb records 2/94/186/278/370/462; used for exact long-series -ncep_norm compare
jma_msm_fh18_33_ugrd1000_merge_fcst_long_input.grib2	${realworld_fh18_33_long_ugrd_merge_fcst_size}	${realworld_fh18_33_long_ugrd_merge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH18-33 long)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 UGRD:1000 mb records 2/94/186/278/370/462; used for exact long-series -merge_fcst compare
jma_msm_fh18_33_ugrd1000_unmerge_fcst_long_input.grib2	${realworld_fh18_33_long_ugrd_unmerge_fcst_size}	${realworld_fh18_33_long_ugrd_unmerge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH18-33 long)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH18-33 UGRD:1000 mb records 2/94/186/278/370/462; used for exact long-series -unmerge_fcst compare
jma_msm_fh18_33_vgrd1000_ncep_norm_long_input.grib2	${realworld_fh18_33_long_vgrd_ncep_norm_size}	${realworld_fh18_33_long_vgrd_ncep_norm_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH18-33 long)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 VGRD:1000 mb records 3/95/187/279/371/463; used for exact long-series -ncep_norm compare
jma_msm_fh18_33_vgrd1000_merge_fcst_long_input.grib2	${realworld_fh18_33_long_vgrd_merge_fcst_size}	${realworld_fh18_33_long_vgrd_merge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH18-33 long)*'	real-value PDT 4.8 ave series built from JMA MSM FH18-33 VGRD:1000 mb records 3/95/187/279/371/463; used for exact long-series -merge_fcst compare
jma_msm_fh18_33_vgrd1000_unmerge_fcst_long_input.grib2	${realworld_fh18_33_long_vgrd_unmerge_fcst_size}	${realworld_fh18_33_long_vgrd_unmerge_fcst_sha}	${forecast_realworld_source_fh18_33}	${MOON_BIN} test cmd/main/main_wbtest.mbt --target native --filter '*supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH18-33 long)*'	real-value PDT 4.8 acc series built from running accumulation of JMA MSM FH18-33 VGRD:1000 mb records 3/95/187/279/371/463; used for exact long-series -unmerge_fcst compare
EOF

echo "done: ${OUT_DIR}"
