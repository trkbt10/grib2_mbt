///|
/// WMO Code Table 4.2 lookups for discipline 191 (Computational Parameters).
///|
fn decode_parameter_number_4_2_191_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SPPT")
    1 => NameKnown("SPP")
    2 => NameKnown("SKEB")
    3 => NameKnown("STC")
    4 => NameKnown("SHUM")
    5 => NameKnown("STTP")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=191,cat=0,param=" + parameter.to_string())
      }
  }
}

