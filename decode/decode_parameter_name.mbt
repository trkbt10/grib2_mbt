///|
/// Look up the WMO short name for a parameter (discipline / category /
/// parameter triple). This is the umbrella dispatcher that fans out to the
/// per-(discipline, category) tables defined in `decode/code_tables.mbt` and
/// `decode/code_tables_parameters.mbt`. Unrecognised triples come back as
/// `NameUnknown` carrying a `disc=...,cat=...,param=...` description so that
/// callers can still log them deterministically.
pub fn decode_parameter_name(
  discipline : Int,
  category : Int,
  parameter : Int,
) -> Grib2NameLookup {
  if discipline == 0 && category == 0 {
    return decode_parameter_number_4_2_0_0_name(parameter)
  }
  if discipline == 0 && category == 1 {
    return decode_parameter_number_4_2_0_1_name(parameter)
  }
  if discipline == 0 && category == 2 {
    return decode_parameter_number_4_2_0_2_name(parameter)
  }
  if discipline == 0 && category == 3 {
    return decode_parameter_number_4_2_0_3_name(parameter)
  }
  if discipline == 0 && category == 4 {
    return decode_parameter_number_4_2_0_4_name(parameter)
  }
  if discipline == 0 && category == 5 {
    return decode_parameter_number_4_2_0_5_name(parameter)
  }
  if discipline == 0 && category == 6 {
    return decode_parameter_number_4_2_0_6_name(parameter)
  }
  if discipline == 0 && category == 7 {
    return decode_parameter_number_4_2_0_7_name(parameter)
  }
  if discipline == 0 && category == 13 {
    return decode_parameter_number_4_2_0_13_name(parameter)
  }
  if discipline == 0 && category == 14 {
    return decode_parameter_number_4_2_0_14_name(parameter)
  }
  if discipline == 0 && category == 15 {
    return decode_parameter_number_4_2_0_15_name(parameter)
  }
  if discipline == 0 && category == 16 {
    return decode_parameter_number_4_2_0_16_name(parameter)
  }
  if discipline == 0 && category == 17 {
    return decode_parameter_number_4_2_0_17_name(parameter)
  }
  if discipline == 0 && category == 18 {
    return decode_parameter_number_4_2_0_18_name(parameter)
  }
  if discipline == 0 && category == 19 {
    return decode_parameter_number_4_2_0_19_name(parameter)
  }
  if discipline == 0 && category == 190 {
    return decode_parameter_number_4_2_0_190_name(parameter)
  }
  if discipline == 0 && category == 191 {
    return decode_parameter_number_4_2_0_191_name(parameter)
  }
  if discipline == 0 && category == 192 {
    return decode_parameter_number_4_2_0_192_name(parameter)
  }
  if discipline == 1 && category == 0 {
    return decode_parameter_number_4_2_1_0_name(parameter)
  }
  if discipline == 1 && category == 1 {
    return decode_parameter_number_4_2_1_1_name(parameter)
  }
  if discipline == 1 && category == 2 {
    return decode_parameter_number_4_2_1_2_name(parameter)
  }
  if discipline == 2 && category == 0 {
    return decode_parameter_number_4_2_2_0_name(parameter)
  }
  if discipline == 2 && category == 1 {
    return decode_parameter_number_4_2_2_1_name(parameter)
  }
  if discipline == 2 && category == 3 {
    return decode_parameter_number_4_2_2_3_name(parameter)
  }
  if discipline == 2 && category == 4 {
    return decode_parameter_number_4_2_2_4_name(parameter)
  }
  if discipline == 2 && category == 5 {
    return decode_parameter_number_4_2_2_5_name(parameter)
  }
  if discipline == 2 && category == 6 {
    return decode_parameter_number_4_2_2_6_name(parameter)
  }
  if discipline == 2 && category == 7 {
    return decode_parameter_number_4_2_2_7_name(parameter)
  }
  if discipline == 3 && category == 0 {
    return decode_parameter_number_4_2_3_0_name(parameter)
  }
  if discipline == 3 && category == 1 {
    return decode_parameter_number_4_2_3_1_name(parameter)
  }
  if discipline == 3 && category == 2 {
    return decode_parameter_number_4_2_3_2_name(parameter)
  }
  if discipline == 3 && category == 3 {
    return decode_parameter_number_4_2_3_3_name(parameter)
  }
  if discipline == 3 && category == 4 {
    return decode_parameter_number_4_2_3_4_name(parameter)
  }
  if discipline == 3 && category == 5 {
    return decode_parameter_number_4_2_3_5_name(parameter)
  }
  if discipline == 3 && category == 6 {
    return decode_parameter_number_4_2_3_6_name(parameter)
  }
  if discipline == 3 && category == 192 {
    return decode_parameter_number_4_2_3_192_name(parameter)
  }
  if discipline == 4 && category == 0 {
    return decode_parameter_number_4_2_4_0_name(parameter)
  }
  if discipline == 4 && category == 1 {
    return decode_parameter_number_4_2_4_1_name(parameter)
  }
  if discipline == 4 && category == 2 {
    return decode_parameter_number_4_2_4_2_name(parameter)
  }
  if discipline == 4 && category == 3 {
    return decode_parameter_number_4_2_4_3_name(parameter)
  }
  if discipline == 4 && category == 4 {
    return decode_parameter_number_4_2_4_4_name(parameter)
  }
  if discipline == 4 && category == 5 {
    return decode_parameter_number_4_2_4_5_name(parameter)
  }
  if discipline == 4 && category == 6 {
    return decode_parameter_number_4_2_4_6_name(parameter)
  }
  if discipline == 4 && category == 7 {
    return decode_parameter_number_4_2_4_7_name(parameter)
  }
  if discipline == 4 && category == 8 {
    return decode_parameter_number_4_2_4_8_name(parameter)
  }
  if discipline == 4 && category == 9 {
    return decode_parameter_number_4_2_4_9_name(parameter)
  }
  if discipline == 4 && category == 10 {
    return decode_parameter_number_4_2_4_10_name(parameter)
  }
  if discipline == 10 && category == 0 {
    return decode_parameter_number_4_2_10_0_name(parameter)
  }
  if discipline == 10 && category == 1 {
    return decode_parameter_number_4_2_10_1_name(parameter)
  }
  if discipline == 10 && category == 2 {
    return decode_parameter_number_4_2_10_2_name(parameter)
  }
  if discipline == 10 && category == 3 {
    return decode_parameter_number_4_2_10_3_name(parameter)
  }
  if discipline == 10 && category == 4 {
    return decode_parameter_number_4_2_10_4_name(parameter)
  }
  if discipline == 10 && category == 191 {
    return decode_parameter_number_4_2_10_191_name(parameter)
  }
  if discipline == 20 && category == 0 {
    return decode_parameter_number_4_2_20_0_name(parameter)
  }
  if discipline == 20 && category == 1 {
    return decode_parameter_number_4_2_20_1_name(parameter)
  }
  if discipline == 20 && category == 2 {
    return decode_parameter_number_4_2_20_2_name(parameter)
  }
  if discipline == 20 && category == 3 {
    return decode_parameter_number_4_2_20_3_name(parameter)
  }
  if discipline == 20 && category == 4 {
    return decode_parameter_number_4_2_20_4_name(parameter)
  }
  if discipline == 20 && category == 5 {
    return decode_parameter_number_4_2_20_5_name(parameter)
  }
  if discipline == 191 && category == 0 {
    return decode_parameter_number_4_2_191_0_name(parameter)
  }
  match (discipline, category, parameter) {
    (2, 0, 196) => NameKnown("CNWAT")
    (2, 3, 192) => NameKnown("SOILL")
    _ =>
      NameUnknown(
        "disc=" +
        discipline.to_string() +
        ",cat=" +
        category.to_string() +
        ",param=" +
        parameter.to_string(),
      )
  }
}
