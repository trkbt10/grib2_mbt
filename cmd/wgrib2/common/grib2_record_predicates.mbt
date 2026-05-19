///|
/// True when `meta` describes a `UGRD` (zonal wind component) record — GRIB2
/// discipline 0, category 2 (Momentum), parameter 2.
pub fn is_wind_u_component(meta : @decode.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 2
}

///|
/// True when `meta` describes a `VGRD` (meridional wind component) record —
/// GRIB2 discipline 0, category 2 (Momentum), parameter 3.
pub fn is_wind_v_component(meta : @decode.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 3
}

///|
/// True when `template_id` refers to a reduced-Gaussian grid family. These
/// share octet layout but specialize the parallel handling.
pub fn is_reduced_gaussian_template_id(template_id : Int) -> Bool {
  template_id == 40 ||
  template_id == 41 ||
  template_id == 42 ||
  template_id == 43
}
