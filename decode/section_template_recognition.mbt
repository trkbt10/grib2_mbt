///|
/// Classify a Section 3 (Grid Definition) template ID. The set of recognised
/// IDs tracks WMO publications and NCEP local extensions (32768/32769).
fn decode_section3_template(id : Int) -> Grib2Section3Template {
  if in_range(id, 0, 5) ||
    id == 10 ||
    in_range(id, 12, 13) ||
    id == 20 ||
    id == 23 ||
    in_range(id, 30, 31) ||
    id == 33 ||
    in_range(id, 40, 43) ||
    in_range(id, 50, 53) ||
    in_range(id, 60, 63) ||
    id == 90 ||
    in_range(id, 100, 101) ||
    id == 110 ||
    id == 120 ||
    id == 140 ||
    id == 150 ||
    id == 204 ||
    id == 1000 ||
    id == 1100 ||
    id == 1200 ||
    in_range(id, 32768, 32769) {
    Section3TemplateKnown(id)
  } else {
    Section3TemplateUnknown(id)
  }
}

///|
/// Classify a Section 4 (Product Definition) template ID.
fn decode_section4_template(id : Int) -> Grib2Section4Template {
  if in_range(id, 0, 15) ||
    id == 20 ||
    in_range(id, 30, 35) ||
    in_range(id, 40, 51) ||
    in_range(id, 53, 63) ||
    in_range(id, 67, 68) ||
    in_range(id, 70, 73) ||
    in_range(id, 76, 155) ||
    id == 254 ||
    in_range(id, 1000, 1002) ||
    in_range(id, 1100, 1101) {
    Section4TemplateKnown(id)
  } else {
    Section4TemplateUnknown(id)
  }
}

///|
/// Classify a Section 5 (Data Representation) template ID.
fn decode_section5_template(id : Int) -> Grib2Section5Template {
  if in_range(id, 0, 4) ||
    in_range(id, 40, 42) ||
    in_range(id, 50, 51) ||
    id == 53 ||
    id == 61 ||
    id == 200 {
    Section5TemplateKnown(id)
  } else {
    Section5TemplateUnknown(id)
  }
}
