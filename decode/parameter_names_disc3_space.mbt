///|
/// WMO Code Table 4.2 lookups for discipline 3 (Satellite Remote Sensing Products).
///|
fn decode_parameter_number_4_2_3_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SRAD")
    1 => NameKnown("SALBEDO")
    2 => NameKnown("SBTMP")
    3 => NameKnown("SPWAT")
    4 => NameKnown("SLFTI")
    5 => NameKnown("SCTPRES")
    6 => NameKnown("SSTMP")
    7 => NameKnown("CLOUDM")
    8 => NameKnown("PIXST")
    9 => NameKnown("FIREDI")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 10 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ESTP")
    1 => NameKnown("IRRATE")
    2 => NameKnown("CTOPH")
    3 => NameKnown("CTOPHQI")
    4 => NameKnown("ESTUGRD")
    5 => NameKnown("ESTVGRD")
    6 => NameKnown("NPIXU")
    7 => NameKnown("SOLZA")
    8 => NameKnown("RAZA")
    9 => NameKnown("RFL06")
    10 => NameKnown("RFL08")
    11 => NameKnown("RFL16")
    12 => NameKnown("RFL39")
    13 => NameKnown("ATMDIV")
    14 => NameKnown("CBTMP")
    15 => NameKnown("CSBTMP")
    16 => NameKnown("CLDRAD")
    17 => NameKnown("CSKYRAD")
    19 => NameKnown("WINDS")
    20 => NameKnown("AOT06")
    21 => NameKnown("AOT08")
    22 => NameKnown("AOT16")
    23 => NameKnown("ANGCOE")
    24 => NameKnown("COSOLZA")
    27 => NameKnown("BRFLF")
    28 => NameKnown("SPBRT")
    29 => NameKnown("SCRAD")
    30 => NameKnown("RFL04")
    31 => NameKnown("CLDREF")
    32 => NameKnown("CLRREF")
    98 => NameKnown("CCMPEMRR")
    99 => NameKnown("SDMPEMRR")
    192 => NameKnown("USCT")
    193 => NameKnown("VSCT")
    194 => NameKnown("SWQI")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 18 ||
        (parameter >= 25 && parameter <= 26) ||
        (parameter >= 33 && parameter <= 97) ||
        (parameter >= 100 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("CSKPROB")
    1 => NameKnown("CTOPTMP")
    2 => NameKnown("CTOPRES")
    3 => NameKnown("CLDTYPE")
    4 => NameKnown("CLDPHAS")
    5 => NameKnown("CLDODEP")
    6 => NameKnown("CLDPER")
    7 => NameKnown("CLDLWP")
    8 => NameKnown("CLDIWP")
    9 => NameKnown("CLDALB")
    10 => NameKnown("CLDEMISS")
    11 => NameKnown("EAODR")
    30 => NameKnown("MEACST")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 12 && parameter <= 29) ||
        (parameter >= 41 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("PBMVFRC")
    1 => NameKnown("PBLIFRC")
    2 => NameKnown("PBINFRC")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("VOLAPROB")
    1 => NameKnown("VOLACDTT")
    2 => NameKnown("VOLACDTP")
    3 => NameKnown("VOLACDTH")
    4 => NameKnown("VOLACDEM")
    5 => NameKnown("VOLAEADR")
    6 => NameKnown("VOLACDOD")
    7 => NameKnown("VOLACDEN")
    8 => NameKnown("VOLAPER")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 9 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ISSTMP")
    1 => NameKnown("SKSSTMP")
    2 => NameKnown("SSKSSTMP")
    3 => NameKnown("FDNSSTMP")
    4 => NameKnown("EBSSTSTD")
    5 => NameKnown("EBSDSSTS")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_6_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("GSOLIRR")
    1 => NameKnown("GSOLEXP")
    2 => NameKnown("DIRSOLIR")
    3 => NameKnown("DIRSOLEX")
    4 => NameKnown("DIFSOLIR")
    5 => NameKnown("DIFSOLEX")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=6,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_3_192_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SBT122")
    1 => NameKnown("SBT123")
    2 => NameKnown("SBT124")
    3 => NameKnown("SBT126")
    4 => NameKnown("SBC123")
    5 => NameKnown("SBC124")
    6 => NameKnown("SBT112")
    7 => NameKnown("SBT113")
    8 => NameKnown("SBT114")
    9 => NameKnown("SBT115")
    10 => NameKnown("AMSRE9")
    11 => NameKnown("AMSRE10")
    12 => NameKnown("AMSRE11")
    13 => NameKnown("AMSRE12")
    14 => NameKnown("SRFA161")
    15 => NameKnown("SRFA162")
    16 => NameKnown("SRFA163")
    17 => NameKnown("SRFA164")
    18 => NameKnown("SRFA165")
    19 => NameKnown("SRFA166")
    20 => NameKnown("SBTA167")
    21 => NameKnown("SBTA168")
    22 => NameKnown("SBTA169")
    23 => NameKnown("SBTA1610")
    24 => NameKnown("SBTA1611")
    25 => NameKnown("SBTA1612")
    26 => NameKnown("SBTA1613")
    27 => NameKnown("SBTA1614")
    28 => NameKnown("SBTA1615")
    29 => NameKnown("SBTA1616")
    30 => NameKnown("SRFA171")
    31 => NameKnown("SRFA172")
    32 => NameKnown("SRFA173")
    33 => NameKnown("SRFA174")
    34 => NameKnown("SRFA175")
    35 => NameKnown("SRFA176")
    36 => NameKnown("SBTA177")
    37 => NameKnown("SBTA178")
    38 => NameKnown("SBTA179")
    39 => NameKnown("SBTA1710")
    40 => NameKnown("SBTA1711")
    41 => NameKnown("SBTA1712")
    42 => NameKnown("SBTA1713")
    43 => NameKnown("SBTA1714")
    44 => NameKnown("SBTA1715")
    45 => NameKnown("SBTA1716")
    46 => NameKnown("SRFAGR1")
    47 => NameKnown("SRFAGR2")
    48 => NameKnown("SRFAGR3")
    49 => NameKnown("SRFAGR4")
    50 => NameKnown("SRFAGR5")
    51 => NameKnown("SRFAGR6")
    52 => NameKnown("SBTAGR7")
    53 => NameKnown("SBTAGR8")
    54 => NameKnown("SBTAGR9")
    55 => NameKnown("SBTAGR10")
    56 => NameKnown("SBTAGR11")
    57 => NameKnown("SBTAGR12")
    58 => NameKnown("SBTAGR13")
    59 => NameKnown("SBTAGR14")
    60 => NameKnown("SBTAGR15")
    61 => NameKnown("SBTAGR16")
    62 => NameKnown("SSMS1715")
    63 => NameKnown("SSMS1716")
    64 => NameKnown("SSMS1717")
    65 => NameKnown("SSMS1718")
    66 => NameKnown("SBTAHI7")
    67 => NameKnown("SBTAHI8")
    68 => NameKnown("SBTAHI9")
    69 => NameKnown("SBTAHI10")
    70 => NameKnown("SBTAHI11")
    71 => NameKnown("SBTAHI12")
    72 => NameKnown("SBTAHI13")
    73 => NameKnown("SBTAHI14")
    74 => NameKnown("SBTAHI15")
    75 => NameKnown("SBTAHI16")
    76 => NameKnown("SBTA187")
    77 => NameKnown("SBTA188")
    78 => NameKnown("SBTA189")
    79 => NameKnown("SBTA1810")
    80 => NameKnown("SBTA1811")
    81 => NameKnown("SBTA1812")
    82 => NameKnown("SBTA1813")
    83 => NameKnown("SBTA1814")
    84 => NameKnown("SBTA1815")
    85 => NameKnown("SBTA1816")
    86 => NameKnown("SSMS1712")
    87 => NameKnown("SSMS1713")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 88 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=3,cat=192,param=" + parameter.to_string())
      }
  }
}

