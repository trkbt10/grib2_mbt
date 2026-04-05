///|
pub fn abs_double(v : Double) -> Double {
  if v < 0.0 {
    -v
  } else {
    v
  }
}

///|
pub fn pad_left(text : String, width : Int) -> String {
  if text.length() >= width {
    text
  } else {
    " ".repeat(width - text.length()) + text
  }
}

///|
pub fn is_wind_u_component(meta : @decode.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 2
}

///|
pub fn is_wind_v_component(meta : @decode.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 3
}

///|
pub fn is_reduced_gaussian_template_id(template_id : Int) -> Bool {
  template_id == 40 ||
  template_id == 41 ||
  template_id == 42 ||
  template_id == 43
}
