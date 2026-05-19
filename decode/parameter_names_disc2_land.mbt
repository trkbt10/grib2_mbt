///|
/// WMO Code Table 4.2 lookups for discipline 2 (Land Surface Products).
///|
fn decode_parameter_number_4_2_2_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("LAND")
    1 => NameKnown("SFCR")
    2 => NameKnown("TSOIL")
    4 => NameKnown("VEG")
    5 => NameKnown("WATR")
    6 => NameKnown("EVAPT")
    7 => NameKnown("MTERH")
    8 => NameKnown("LANDU")
    9 => NameKnown("SOILW")
    10 => NameKnown("GFLUX")
    11 => NameKnown("MSTAV")
    12 => NameKnown("SFEXC")
    13 => NameKnown("CNWAT")
    14 => NameKnown("BMIXL")
    15 => NameKnown("CCOND")
    16 => NameKnown("RSMIN")
    17 => NameKnown("WILT")
    18 => NameKnown("RCS")
    19 => NameKnown("RCT")
    20 => NameKnown("RCQ")
    21 => NameKnown("RCSOL")
    23 => NameKnown("CISOILW")
    24 => NameKnown("HFLUX")
    25 => NameKnown("VSOILM")
    26 => NameKnown("WILT")
    27 => NameKnown("VWILTP")
    28 => NameKnown("LEAINX")
    29 => NameKnown("EVGFC")
    30 => NameKnown("DECFC")
    31 => NameKnown("NDVINX")
    32 => NameKnown("RDVEG")
    33 => NameKnown("WROD")
    34 => NameKnown("SFCWRO")
    35 => NameKnown("TCLASS")
    36 => NameKnown("TFRCT")
    37 => NameKnown("TPERCT")
    38 => NameKnown("SOILVIC")
    39 => NameKnown("EVAPTRAT")
    40 => NameKnown("PEVAPTRAT")
    41 => NameKnown("SMRATE")
    42 => NameKnown("WRDRATE")
    43 => NameKnown("DRAINDIR")
    44 => NameKnown("UPSAREA")
    45 => NameKnown("WETCOV")
    46 => NameKnown("WETTYPE")
    47 => NameKnown("IRRCOV")
    48 => NameKnown("CROPCOV")
    49 => NameKnown("GRASSCOV")
    50 => NameKnown("SKINRC")
    51 => NameKnown("SURFRATE")
    52 => NameKnown("SUBSRATE")
    53 => NameKnown("LOVEGCOV")
    54 => NameKnown("HIVEGCOV")
    55 => NameKnown("LAILO")
    56 => NameKnown("LAIHI")
    57 => NameKnown("TYPLOVEG")
    58 => NameKnown("TYPHIVEG")
    59 => NameKnown("NECOFLUX")
    60 => NameKnown("GROSSFLUX")
    61 => NameKnown("ECORFLUX")
    62 => NameKnown("EMISS")
    63 => NameKnown("CANTMP")
    192 => NameKnown("SOILW")
    193 => NameKnown("GFLUX")
    194 => NameKnown("MSTAV")
    195 => NameKnown("SFEXC")
    196 => NameKnown("CNWAT")
    197 => NameKnown("BMIXL")
    198 => NameKnown("VGTYP")
    199 => NameKnown("CCOND")
    200 => NameKnown("RSMIN")
    201 => NameKnown("WILT")
    202 => NameKnown("RCS")
    203 => NameKnown("RCT")
    204 => NameKnown("RCQ")
    205 => NameKnown("RCSOL")
    206 => NameKnown("RDRIP")
    207 => NameKnown("ICWAT")
    208 => NameKnown("AKHS")
    209 => NameKnown("AKMS")
    210 => NameKnown("VEGT")
    211 => NameKnown("SSTOR")
    212 => NameKnown("LSOIL")
    213 => NameKnown("EWATR")
    214 => NameKnown("GWREC")
    215 => NameKnown("QREC")
    216 => NameKnown("SFCRH")
    217 => NameKnown("NDVI")
    218 => NameKnown("LANDN")
    219 => NameKnown("AMIXL")
    220 => NameKnown("WVINC")
    221 => NameKnown("WCINC")
    222 => NameKnown("WVCONV")
    223 => NameKnown("WCCONV")
    224 => NameKnown("WVUFLX")
    225 => NameKnown("WVVFLX")
    226 => NameKnown("WCUFLX")
    227 => NameKnown("WCVFLX")
    228 => NameKnown("ACOND")
    229 => NameKnown("EVCW")
    230 => NameKnown("TRANS")
    231 => NameKnown("VEGMIN")
    232 => NameKnown("VEGMAX")
    233 => NameKnown("LANDFRC")
    234 => NameKnown("LAKEFRC")
    235 => NameKnown("PAHFLX")
    236 => NameKnown("WATERSA")
    237 => NameKnown("EIWATER")
    238 => NameKnown("PLANTTR")
    239 => NameKnown("SOILSE")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 64 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    192 => NameKnown("CANL")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 0 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SOTYP")
    1 => NameKnown("UPLST")
    2 => NameKnown("UPLSM")
    3 => NameKnown("LOWLSM")
    4 => NameKnown("BOTLST")
    5 => NameKnown("SOILL")
    6 => NameKnown("RLYRS")
    7 => NameKnown("SMREF")
    8 => NameKnown("SMDRY")
    9 => NameKnown("POROS")
    10 => NameKnown("LIQVSM")
    11 => NameKnown("VOLTSO")
    12 => NameKnown("TRANSO")
    13 => NameKnown("VOLDEC")
    14 => NameKnown("DIREC")
    15 => NameKnown("SOILP")
    16 => NameKnown("VSOSM")
    17 => NameKnown("SATOSM")
    18 => NameKnown("SOILTMP")
    19 => NameKnown("SOILMOI")
    20 => NameKnown("CISOILM")
    21 => NameKnown("SOILICE")
    22 => NameKnown("CISICE")
    23 => NameKnown("LWSNWP")
    24 => NameKnown("FRSTINX")
    25 => NameKnown("SNWDEB")
    26 => NameKnown("SHFLX")
    27 => NameKnown("SOILDEP")
    28 => NameKnown("SNOWTMP")
    29 => NameKnown("ICETEMP")
    30 => NameKnown("SWET")
    192 => NameKnown("SOILL")
    193 => NameKnown("RLYRS")
    194 => NameKnown("SLTYP")
    195 => NameKnown("SMREF")
    196 => NameKnown("SMDRY")
    197 => NameKnown("POROS")
    198 => NameKnown("EVBS")
    199 => NameKnown("LSPA")
    200 => NameKnown("BARET")
    201 => NameKnown("AVSFT")
    202 => NameKnown("RADT")
    203 => NameKnown("FLDCP")
    204 => NameKnown("MSTAVTOP")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 31 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("FIREOLK")
    1 => NameKnown("FIREODT")
    2 => NameKnown("HINDEX")
    3 => NameKnown("FBAREA")
    4 => NameKnown("FOSINDX")
    5 => NameKnown("FWINX")
    6 => NameKnown("FFMCODE")
    7 => NameKnown("DUFMCODE")
    8 => NameKnown("DRTCODE")
    9 => NameKnown("INFSINX")
    10 => NameKnown("FBUPINX")
    11 => NameKnown("FDSRTE")
    12 => NameKnown("KRIDX")
    13 => NameKnown("DRFACT")
    14 => NameKnown("RATESPRD")
    15 => NameKnown("FIREDIDX")
    16 => NameKnown("SPRDCOMP")
    17 => NameKnown("BURNIDX")
    18 => NameKnown("IGNCOMP")
    19 => NameKnown("ENRELCOM")
    20 => NameKnown("BURNAREA")
    21 => NameKnown("BURNABAREA")
    22 => NameKnown("UNBURNAREA")
    23 => NameKnown("FUELLOAD")
    24 => NameKnown("COMBCO")
    25 => NameKnown("FUELMC")
    26 => NameKnown("WFIREPOT")
    27 => NameKnown("LLFL")
    28 => NameKnown("LWFL")
    29 => NameKnown("DLFL")
    30 => NameKnown("DWFL")
    31 => NameKnown("LFMC")
    32 => NameKnown("FDLMC")
    33 => NameKnown("DDLMC")
    34 => NameKnown("FDWMC")
    35 => NameKnown("DDWMC")
    36 => NameKnown("FRADPOW")
    37 => NameKnown("LFMCLV")
    38 => NameKnown("LFMCHV")
    39 => NameKnown("MEANHGTINJ")
    40 => NameKnown("HGTINJ")
    41 => NameKnown("HGTPLUMEB")
    42 => NameKnown("HGTPLUMET")
    43 => NameKnown("FDPROB")
    44 => NameKnown("IGNLTNG")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 45 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("GLACCOV")
    1 => NameKnown("GLACTMP")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 2 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_6_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("URBCOVER")
    1 => NameKnown("ROADCOVER")
    2 => NameKnown("BUILDCOVER")
    3 => NameKnown("BUILDHGT")
    4 => NameKnown("VZAFRAC")
    5 => NameKnown("SDBUILDHGT")
    6 => NameKnown("DDROOF")
    7 => NameKnown("DIOWALL")
    8 => NameKnown("DDROAD")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 9 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=6,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_2_7_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("HNETFLUX")
    1 => NameKnown("LHTFLUX")
    2 => NameKnown("SHTFLUX")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=2,cat=7,param=" + parameter.to_string())
      }
  }
}

