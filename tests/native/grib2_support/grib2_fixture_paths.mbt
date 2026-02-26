///|

///|
let grib2_fixture_dir_jma = "fixtures/grib2_jma/"

///|
let grib2_fixture_dir_noaa = "fixtures/grib2_noaa/"

///|
let grib2_fixture_dir_jpeg2000 = "fixtures/grib2_jpeg2000/"

///|
let grib2_fixture_dir_wgrib2_snapshots = "fixtures/wgrib2_snapshots/"

///|
fn grib2_fixture_path_in_jma_dir(file_name : String) -> String {
  grib2_fixture_dir_jma + file_name
}

///|
fn grib2_fixture_path_in_noaa_dir(file_name : String) -> String {
  grib2_fixture_dir_noaa + file_name
}

///|
fn grib2_fixture_path_in_jpeg2000_dir(file_name : String) -> String {
  grib2_fixture_dir_jpeg2000 + file_name
}

///|
fn grib2_snapshot_path_dir(name : String) -> String {
  grib2_fixture_dir_wgrib2_snapshots + name
}

///|
pub fn grib2_fixture_path_jma_gsm() -> String {
  grib2_fixture_path_in_jma_dir(
    "Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin",
  )
}

///|
fn grib2_fixture_path_jma_msm_fh00_15() -> String {
  grib2_fixture_path_in_jma_dir(
    "Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin",
  )
}

///|
fn grib2_fixture_path_jma_msm_fh18_33() -> String {
  grib2_fixture_path_in_jma_dir(
    "Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin",
  )
}

///|
fn grib2_fixture_path_jma_msm_fh36_39() -> String {
  grib2_fixture_path_in_jma_dir(
    "Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin",
  )
}

///|
pub fn grib2_fixture_path_noaa_gfs_pgrb2_1p00_f000() -> String {
  grib2_fixture_path_in_noaa_dir("gfs.t00z.pgrb2.1p00.f000.grib2")
}

///|
pub fn grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000() -> String {
  grib2_fixture_path_in_noaa_dir("gfs.t00z.pgrb2b.1p00.f000.grib2")
}

///|
pub fn grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000() -> String {
  grib2_fixture_path_in_noaa_dir("gfswave.t00z.atlocn.0p16.f000.grib2")
}

///|
pub fn grib2_fixture_path_noaa_gfswave_global_0p25_f000() -> String {
  grib2_fixture_path_in_noaa_dir("gfswave.t00z.global.0p25.f000.grib2")
}

///|
pub fn grib2_fixture_path_noaa_not_found() -> String {
  grib2_fixture_path_in_noaa_dir("not_found.grib2")
}

///|
pub fn grib2_fixture_path_eccodes_jpeg() -> String {
  grib2_fixture_path_in_jpeg2000_dir("eccodes_jpeg.grib2")
}

///|
pub fn grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg() -> String {
  grib2_fixture_path_in_jpeg2000_dir(
    "eccodes_reduced_gaussian_surface_jpeg.grib2",
  )
}

///|
pub fn grib2_snapshot_dir_jma_gsm() -> String {
  grib2_snapshot_path_dir("jma_gsm")
}

///|
pub fn grib2_snapshot_dir_noaa_gfs_pgrb2b_1p00_f000() -> String {
  grib2_snapshot_path_dir("noaa_gfs_pgrb2b_1p00_f000")
}

///|
pub fn grib2_snapshot_dir_noaa_gfswave_atlocn_0p16_f000() -> String {
  grib2_snapshot_path_dir("noaa_gfswave_atlocn_0p16_f000")
}

///|
pub fn grib2_fixture_paths_for_roundtrip() -> Array[String] {
  [
    grib2_fixture_path_jma_gsm(),
    grib2_fixture_path_jma_msm_fh00_15(),
    grib2_fixture_path_jma_msm_fh18_33(),
    grib2_fixture_path_jma_msm_fh36_39(),
    grib2_fixture_path_noaa_gfs_pgrb2_1p00_f000(),
    grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
    grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000(),
    grib2_fixture_path_noaa_gfswave_global_0p25_f000(),
  ]
}
