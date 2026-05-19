///|
/// WMO Code Table 4.2 lookups for discipline 20 (Health and Socioeconomic Impacts).
///|
fn decode_parameter_number_4_2_20_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("UTHCIDX")
    1 => NameKnown("MEANRTMP")
    2 => NameKnown("WETBGTMP")
    3 => NameKnown("GLOBETMP")
    4 => NameKnown("HUMIDX")
    5 => NameKnown("EFFTEMP")
    6 => NameKnown("NOREFTMP")
    7 => NameKnown("STDEFTMP")
    8 => NameKnown("PEQUTMP")
    9 => NameKnown("UVBED")
    10 => NameKnown("UVBEDCS")
    11 => NameKnown("EHF")
    12 => NameKnown("ECF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 13 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("MALACASE")
    1 => NameKnown("MACPRATE")
    2 => NameKnown("PFEIRATE")
    3 => NameKnown("HBRATEAV")
    4 => NameKnown("MALAIMM")
    5 => NameKnown("FALPRATE")
    6 => NameKnown("DFPRATIO")
    7 => NameKnown("AVHRATIO")
    8 => NameKnown("AVECTNUM")
    9 => NameKnown("FMALVRH")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 10 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("POPDEN")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 1 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("RENPCAP")
    1 => NameKnown("RENPPROD")
    2 => NameKnown("WINDPCAP")
    3 => NameKnown("WINDPPROD")
    4 => NameKnown("SPVPCAP")
    5 => NameKnown("SPVPPROD")
    6 => NameKnown("SNPVPCAP")
    7 => NameKnown("SNPVPPROD")
    8 => NameKnown("CSPPCAP")
    9 => NameKnown("CSPPROD")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 10 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    1 => NameKnown("DBURSTHI")
    2 => NameKnown("LTNGHI")
    3 => NameKnown("TSTMHI")
    4 => NameKnown("COASTFLDHI")
    5 => NameKnown("ESTFLDHI")
    6 => NameKnown("FFLDHI")
    7 => NameKnown("FLUVFLDHI")
    8 => NameKnown("GFLDHI")
    9 => NameKnown("IJFLDHI")
    10 => NameKnown("PFLDHI")
    11 => NameKnown("SMFLDHI")
    12 => NameKnown("SWFLDHI")
    13 => NameKnown("GLOFLDHI")
    14 => NameKnown("BCHI")
    15 => NameKnown("DSTMHI")
    16 => NameKnown("FOGHI")
    17 => NameKnown("HZHI")
    18 => NameKnown("POLAIRHI")
    19 => NameKnown("SAHZHI")
    20 => NameKnown("SMOKEHI")
    21 => NameKnown("OAHI")
    22 => NameKnown("RWAVEHI")
    23 => NameKnown("SWIHI")
    24 => NameKnown("SICEHI")
    25 => NameKnown("ICEFLOWHI")
    26 => NameKnown("SEICHEHI")
    27 => NameKnown("SURGEHI")
    28 => NameKnown("STMTIDEHI")
    29 => NameKnown("TSUNAMIHI")
    30 => NameKnown("DEPRESHI")
    31 => NameKnown("ECPRESHI")
    32 => NameKnown("SUBTCPRESHI")
    33 => NameKnown("ACIDRAINHI")
    34 => NameKnown("BLIZHI")
    35 => NameKnown("DRTHI")
    36 => NameKnown("HAILHI")
    37 => NameKnown("ICESTMHI")
    38 => NameKnown("SNOWHI")
    39 => NameKnown("SNOWSTMHI")
    40 => NameKnown("CWAVEHI")
    41 => NameKnown("DZUDHI")
    42 => NameKnown("FRZHI")
    43 => NameKnown("FROSTHI")
    44 => NameKnown("FRZRHI")
    45 => NameKnown("GLAZEHI")
    46 => NameKnown("GFROSTHI")
    47 => NameKnown("HWAVEHI")
    48 => NameKnown("ICINGHI")
    49 => NameKnown("THAWHI")
    50 => NameKnown("AVALHI")
    51 => NameKnown("MUDFLOWHI")
    52 => NameKnown("RSLIDEHI")
    53 => NameKnown("DERECHOHI")
    54 => NameKnown("GALEHI")
    55 => NameKnown("SQLNHI")
    56 => NameKnown("SSTMHI")
    57 => NameKnown("TCWINDHI")
    58 => NameKnown("TSWINDHI")
    59 => NameKnown("TORHI")
    60 => NameKnown("WINDHI")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 0 || (parameter >= 61 && parameter <= 190) {
        NameKnown("Reserved")
      } else if parameter >= 191 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_20_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    1 => NameKnown("HHAIRPOLHI")
    2 => NameKnown("AIRPOLHI")
    3 => NameKnown("AAIRPOLHI")
    4 => NameKnown("LANDDEGHI")
    5 => NameKnown("SOILDEGHI")
    6 => NameKnown("RUNOFFHI")
    7 => NameKnown("SALTHI")
    8 => NameKnown("BDLOSSHI")
    9 => NameKnown("DEFORESTHI")
    10 => NameKnown("FORESTDECHI")
    11 => NameKnown("FORESTDISHI")
    12 => NameKnown("FORESTINVHI")
    13 => NameKnown("WFIREHI")
    14 => NameKnown("DESERTHI")
    15 => NameKnown("MANLOSSHI")
    16 => NameKnown("WETLOSSHI")
    17 => NameKnown("CORALBHI")
    18 => NameKnown("COMPSOILHI")
    19 => NameKnown("SOILEROHI")
    20 => NameKnown("COASTEROHI")
    21 => NameKnown("PFLOSSHI")
    22 => NameKnown("SAMINHI")
    23 => NameKnown("SLRHI")
    24 => NameKnown("EUTROPHI")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 0 || (parameter >= 25 && parameter <= 190) {
        NameKnown("Reserved")
      } else if parameter >= 191 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=20,cat=5,param=" + parameter.to_string())
      }
  }
}

