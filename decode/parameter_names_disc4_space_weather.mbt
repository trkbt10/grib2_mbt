///|
/// WMO Code Table 4.2 lookups for discipline 4 (Space Weather Products).
///|
fn decode_parameter_number_4_2_4_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TMPSWP")
    1 => NameKnown("ELECTMP")
    2 => NameKnown("PROTTMP")
    3 => NameKnown("IONTMP")
    4 => NameKnown("PRATMP")
    5 => NameKnown("PRPTMP")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SPEED")
    1 => NameKnown("VEL1")
    2 => NameKnown("VEL2")
    3 => NameKnown("VEL3")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 4 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("PLSMDEN")
    1 => NameKnown("ELCDEN")
    2 => NameKnown("PROTDEN")
    3 => NameKnown("IONDEN")
    4 => NameKnown("VTEC")
    5 => NameKnown("ABSFRQ")
    6 => NameKnown("ABSRB")
    7 => NameKnown("SPRDF")
    8 => NameKnown("HPRIMF")
    9 => NameKnown("CRTFRQ")
    10 => NameKnown("MAXUFZ")
    11 => NameKnown("PEAKH")
    12 => NameKnown("PEAKDEN")
    13 => NameKnown("EQSLABT")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 14 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("BTOT")
    1 => NameKnown("BVEC1")
    2 => NameKnown("BVEC2")
    3 => NameKnown("BVEC3")
    4 => NameKnown("ETOT")
    5 => NameKnown("EVEC1")
    6 => NameKnown("EVEC2")
    7 => NameKnown("EVEC3")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 8 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("DIFPFLUX")
    1 => NameKnown("INTPFLUX")
    2 => NameKnown("DIFEFLUX")
    3 => NameKnown("INTEFLUX")
    4 => NameKnown("DIFIFLUX")
    5 => NameKnown("INTIFLUX")
    6 => NameKnown("NTRNFLUX")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 7 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("AMPL")
    1 => NameKnown("PHASE")
    2 => NameKnown("FREQ")
    3 => NameKnown("WAVELGTH")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 4 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_6_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TSI")
    1 => NameKnown("XLONG")
    2 => NameKnown("XSHRT")
    3 => NameKnown("EUVIRR")
    4 => NameKnown("SPECIRR")
    5 => NameKnown("F107")
    6 => NameKnown("SOLRF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 7 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=6,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_7_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("LMBINT")
    1 => NameKnown("DSKINT")
    2 => NameKnown("DSKDAY")
    3 => NameKnown("DSKNGT")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 4 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=7,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_8_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("XRAYRAD")
    1 => NameKnown("EUVRAD")
    2 => NameKnown("HARAD")
    3 => NameKnown("WHTRAD")
    4 => NameKnown("CAIIRAD")
    5 => NameKnown("WHTCOR")
    6 => NameKnown("HELCOR")
    7 => NameKnown("MASK")
    8 => NameKnown("SICFL")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 9 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=8,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_9_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SIGPED")
    1 => NameKnown("SIGHAL")
    2 => NameKnown("SIGPAR")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=9,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_4_10_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SCINIDX")
    1 => NameKnown("SCIDEXS4")
    2 => NameKnown("ROTIDX")
    3 => NameKnown("DIDXSG")
    4 => NameKnown("AATRATE")
    5 => NameKnown("KP")
    6 => NameKnown("EDISSTIX")
    7 => NameKnown("AURELEC")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 8 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=4,cat=10,param=" + parameter.to_string())
      }
  }
}

