///|
/// WMO Code Table 4.2 lookups for discipline 1 (Hydrological Products).
///|
fn decode_parameter_number_4_2_1_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("FFLDG")
    1 => NameKnown("FFLDRO")
    2 => NameKnown("RSSC")
    3 => NameKnown("ESCT")
    4 => NameKnown("SWEPON")
    5 => NameKnown("BGRUN")
    6 => NameKnown("SSRUN")
    7 => NameKnown("DISRS")
    8 => NameKnown("GWUPS")
    9 => NameKnown("GWLOWS")
    10 => NameKnown("SFLORC")
    11 => NameKnown("RVERSW")
    12 => NameKnown("FLDPSW")
    13 => NameKnown("DEPWSS")
    14 => NameKnown("UPAPCP")
    15 => NameKnown("UPASM")
    16 => NameKnown("PERRATE")
    17 => NameKnown("RVEROW")
    18 => NameKnown("FLDPOW")
    19 => NameKnown("FLDPATHOW")
    20 => NameKnown("WATSURF")
    21 => NameKnown("WSE")
    22 => NameKnown("GRFR")
    23 => NameKnown("RVERFLDPS")
    24 => NameKnown("DARVERVEL")
    192 => NameKnown("BGRUN")
    193 => NameKnown("SSRUN")
    194 => NameKnown("FHO")
    196 => NameKnown("AHD")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 25 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=1,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_1_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("CPPOP")
    1 => NameKnown("PPOSP")
    2 => NameKnown("POP")
    192 => NameKnown("CPOZP")
    193 => NameKnown("CPOFP")
    194 => NameKnown("PPFFG")
    195 => NameKnown("CWR")
    196 => NameKnown("QPFARI")
    197 => NameKnown("QPFFFG")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=1,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_1_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("WDPTHIL")
    1 => NameKnown("WTMPIL")
    2 => NameKnown("WFRACT")
    3 => NameKnown("SEDTK")
    4 => NameKnown("SEDTMP")
    5 => NameKnown("ICTKIL")
    6 => NameKnown("ICETIL")
    7 => NameKnown("ICECIL")
    8 => NameKnown("LANDIL")
    9 => NameKnown("SFSAL")
    10 => NameKnown("SFTMP")
    11 => NameKnown("ACWSR")
    12 => NameKnown("SALTIL")
    13 => NameKnown("CSAFC")
    14 => NameKnown("LNDSNOWT")
    15 => NameKnown("LDEPTH")
    16 => NameKnown("RDEPTH")
    17 => NameKnown("FLDPDEPTH")
    18 => NameKnown("FLDPFLFR")
    19 => NameKnown("FLDPFLAR")
    20 => NameKnown("RVERFR")
    21 => NameKnown("RVERAR")
    22 => NameKnown("FRCRF")
    23 => NameKnown("ARCRF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 24 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=1,cat=2,param=" + parameter.to_string())
      }
  }
}

