///|
pub fn decode_parameter_category_name(
  discipline : Int,
  category : Int,
) -> Grib2NameLookup {
  if category < 0 || category > 255 {
    return NameUnknown(
      "parameter_category=disc=" +
      discipline.to_string() +
      ",cat=" +
      category.to_string(),
    )
  }
  match discipline {
    0 =>
      match category {
        0 => NameKnown("Temperature")
        1 => NameKnown("Moisture")
        2 => NameKnown("Momentum")
        3 => NameKnown("Mass")
        4 => NameKnown("Shortwave Radiation")
        5 => NameKnown("Longwave Radiation")
        6 => NameKnown("Cloud")
        7 => NameKnown("Thermodynamic Stability Indices")
        8 => NameKnown("Kinematic Stability Indices")
        9 => NameKnown("Temperature Probabilities")
        10 => NameKnown("Moisture Probabilities")
        11 => NameKnown("Momentum Probabilities")
        12 => NameKnown("Mass Probabilities")
        13 => NameKnown("Aerosols")
        14 => NameKnown("Trace Gases")
        15 => NameKnown("Radar")
        16 => NameKnown("Forecast Radar Imagery")
        17 => NameKnown("Electrodynamics")
        18 => NameKnown("Nuclear/Radiology")
        19 => NameKnown("Physical Atmospheric Properties")
        20 => NameKnown("Atmospheric Chemical Constituents")
        21 => NameKnown("Thermodynamic Properties")
        22 => NameKnown("Drought Indices")
        190 => NameKnown("CCITT IA5 String")
        191 => NameKnown("Miscellaneous")
        192 => NameKnown("Covariance")
        255 => NameKnown("Missing")
        _ =>
          if category >= 23 && category <= 189 {
            NameKnown("Reserved")
          } else if category >= 193 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    1 =>
      match category {
        0 => NameKnown("Hydrology Basic Products")
        1 => NameKnown("Hydrology Probabilities")
        2 => NameKnown("Inland Water and Sediment Properties")
        255 => NameKnown("Missing")
        _ =>
          if category >= 3 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    2 =>
      match category {
        0 => NameKnown("Vegetation/Biomass")
        1 => NameKnown("Agricultural/Aquacultural Special Products")
        3 => NameKnown("Soil Products")
        4 => NameKnown("Fire Weather Products")
        5 => NameKnown("Land Surface Products")
        6 => NameKnown("Urban Areas")
        7 => NameKnown("Thermodynamic Properties")
        255 => NameKnown("Missing")
        _ =>
          if category >= 8 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    3 =>
      match category {
        0 => NameKnown("Image Format Products")
        1 => NameKnown("Quantitative Products")
        2 => NameKnown("Cloud Properties")
        3 => NameKnown("Flight Rules Conditions")
        4 => NameKnown("Volcanic Ash")
        5 => NameKnown("Sea Surface Temperature")
        6 => NameKnown("Solar Radiation")
        192 => NameKnown("Forecast Satellite Imagery")
        255 => NameKnown("Missing")
        _ =>
          if category >= 7 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 193 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    4 =>
      match category {
        0 => NameKnown("Temperature")
        1 => NameKnown("Momentum")
        2 => NameKnown("Charged Particle Mass and Number")
        3 => NameKnown("Electric and Magnetic Fields")
        4 => NameKnown("Energetic Particles")
        5 => NameKnown("Waves")
        6 => NameKnown("Solar Electromagnetic Emissions")
        7 => NameKnown("Terrestrial Electromagnetic Emissions")
        8 => NameKnown("Imagery")
        9 => NameKnown("Ion-Neutral Coupling")
        10 => NameKnown("Space Weather Indices")
        255 => NameKnown("Missing")
        _ =>
          if category >= 11 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    10 =>
      match category {
        0 => NameKnown("Waves")
        1 => NameKnown("Currents")
        2 => NameKnown("Ice")
        3 => NameKnown("Surface Properties")
        4 => NameKnown("Subsurface Properties")
        191 => NameKnown("Miscellaneous")
        255 => NameKnown("Missing")
        _ =>
          if category >= 5 && category <= 190 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    20 =>
      match category {
        0 => NameKnown("Health Indicators")
        1 => NameKnown("Epidemiology")
        2 => NameKnown("Socioeconomic Indicators")
        3 => NameKnown("Renewable Energy Sector")
        4 => NameKnown("Meteorological and Hydrological Hazard Indices")
        5 => NameKnown("Environmental Hazard Indices")
        255 => NameKnown("Missing")
        _ =>
          if category >= 6 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    191 =>
      match category {
        0 => NameKnown("Stochastic Parameterizations")
        255 => NameKnown("Missing")
        _ =>
          if category >= 1 && category <= 191 {
            NameKnown("Reserved")
          } else if category >= 192 && category <= 254 {
            NameKnown("Reserved for Local Use")
          } else {
            NameUnknown(
              "parameter_category=disc=" +
              discipline.to_string() +
              ",cat=" +
              category.to_string(),
            )
          }
      }
    _ =>
      NameUnknown(
        "parameter_category=disc=" +
        discipline.to_string() +
        ",cat=" +
        category.to_string(),
      )
  }
}

///|
pub fn decode_parameter_number_name(
  discipline : Int,
  category : Int,
  parameter : Int,
) -> Grib2NameLookup {
  let mapped = decode_parameter_name(discipline, category, parameter)
  match mapped {
    NameKnown(_) => mapped
    NameUnknown(_) =>
      if parameter < 0 || parameter > 255 {
        NameUnknown(
          "parameter_number=disc=" +
          discipline.to_string() +
          ",cat=" +
          category.to_string() +
          ",param=" +
          parameter.to_string(),
        )
      } else if parameter == 255 {
        NameKnown("Missing")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameKnown("Reserved")
      }
  }
}

///|
fn decode_parameter_number_4_2_0_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TMP")
    1 => NameKnown("VTMP")
    2 => NameKnown("POT")
    3 => NameKnown("EPOT")
    4 => NameKnown("TMAX")
    5 => NameKnown("TMIN")
    6 => NameKnown("DPT")
    7 => NameKnown("DEPR")
    8 => NameKnown("LAPR")
    9 => NameKnown("TMPA")
    10 => NameKnown("LHTFL")
    11 => NameKnown("SHTFL")
    12 => NameKnown("HEATX")
    13 => NameKnown("WCF")
    14 => NameKnown("MINDPD")
    15 => NameKnown("VPTMP")
    16 => NameKnown("SNOHF")
    17 => NameKnown("SKINT")
    18 => NameKnown("SNOT")
    19 => NameKnown("TTCHT")
    20 => NameKnown("TDCHT")
    21 => NameKnown("APTMP")
    22 => NameKnown("TTSWR")
    23 => NameKnown("TTLWR")
    24 => NameKnown("TTSWRCS")
    25 => NameKnown("TTLWRCS")
    26 => NameKnown("TTPARM")
    27 => NameKnown("WETBT")
    28 => NameKnown("UCTMP")
    29 => NameKnown("TMPADV")
    30 => NameKnown("LHFLXE")
    31 => NameKnown("LHFLXS")
    32 => NameKnown("WETBPT")
    192 => NameKnown("SNOHF")
    193 => NameKnown("TTRAD")
    194 => NameKnown("REV")
    195 => NameKnown("LRGHR")
    196 => NameKnown("CNVHR")
    197 => NameKnown("THFLX")
    198 => NameKnown("TTDIA")
    199 => NameKnown("TTPHY")
    200 => NameKnown("TSD1D")
    201 => NameKnown("SHAHR")
    202 => NameKnown("VDFHR")
    203 => NameKnown("THZ0")
    204 => NameKnown("TCHP")
    205 => NameKnown("ELMELT")
    206 => NameKnown("WETGLBT")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 33 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 207 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("SPFH")
    1 => NameKnown("RH")
    2 => NameKnown("MIXR")
    3 => NameKnown("PWAT")
    4 => NameKnown("VAPP")
    5 => NameKnown("SATD")
    6 => NameKnown("EVP")
    7 => NameKnown("PRATE")
    8 => NameKnown("APCP")
    9 => NameKnown("NCPCP")
    10 => NameKnown("ACPCP")
    11 => NameKnown("SNOD")
    12 => NameKnown("SRWEQ")
    13 => NameKnown("WEASD")
    14 => NameKnown("SNOC")
    15 => NameKnown("SNOL")
    16 => NameKnown("SNOM")
    17 => NameKnown("SNOAG")
    18 => NameKnown("ABSH")
    19 => NameKnown("PTYPE")
    20 => NameKnown("ILIQW")
    21 => NameKnown("TCOND")
    22 => NameKnown("CLMR")
    23 => NameKnown("ICMR")
    24 => NameKnown("RWMR")
    25 => NameKnown("SNMR")
    26 => NameKnown("MCONV")
    27 => NameKnown("MAXRH")
    28 => NameKnown("MAXAH")
    29 => NameKnown("ASNOW")
    30 => NameKnown("PWCAT")
    31 => NameKnown("HAIL")
    32 => NameKnown("GRLE")
    33 => NameKnown("CRAIN")
    34 => NameKnown("CFRZR")
    35 => NameKnown("CICEP")
    36 => NameKnown("CSNOW")
    37 => NameKnown("CPRAT")
    38 => NameKnown("MDIVER")
    39 => NameKnown("CPOFP")
    40 => NameKnown("PEVAP")
    41 => NameKnown("PEVPR")
    42 => NameKnown("SNOWC")
    43 => NameKnown("FRAIN")
    44 => NameKnown("RIME")
    45 => NameKnown("TCOLR")
    46 => NameKnown("TCOLS")
    47 => NameKnown("LSWP")
    48 => NameKnown("CWP")
    49 => NameKnown("TWATP")
    50 => NameKnown("TSNOWP")
    51 => NameKnown("TCWAT")
    52 => NameKnown("TPRATE")
    53 => NameKnown("TSRWE")
    54 => NameKnown("LSPRATE")
    55 => NameKnown("CSRWE")
    56 => NameKnown("LSSRWE")
    57 => NameKnown("TSRATE")
    58 => NameKnown("CSRATE")
    59 => NameKnown("LSSRATE")
    60 => NameKnown("SDWE")
    61 => NameKnown("SDEN")
    62 => NameKnown("SEVAP")
    64 => NameKnown("TCIWV")
    65 => NameKnown("RPRATE")
    66 => NameKnown("SPRATE")
    67 => NameKnown("FPRATE")
    68 => NameKnown("IPRATE")
    69 => NameKnown("TCOLW")
    70 => NameKnown("TCOLI")
    71 => NameKnown("HAILMXR")
    72 => NameKnown("TCOLH")
    73 => NameKnown("HAILPR")
    74 => NameKnown("TCOLG")
    75 => NameKnown("GPRATE")
    76 => NameKnown("CRRATE")
    77 => NameKnown("LSRRATE")
    78 => NameKnown("TCOLWA")
    79 => NameKnown("EVARATE")
    80 => NameKnown("TOTCON")
    81 => NameKnown("TCICON")
    82 => NameKnown("CIMIXR")
    83 => NameKnown("SCLLWC")
    84 => NameKnown("SCLIWC")
    85 => NameKnown("SRAINW")
    86 => NameKnown("SSNOWW")
    87 => NameKnown("STRPRATE")
    88 => NameKnown("CATCP")
    90 => NameKnown("TKMFLX")
    91 => NameKnown("UKMFLX")
    92 => NameKnown("VKMFLX")
    93 => NameKnown("RHWATER")
    94 => NameKnown("RHICE")
    95 => NameKnown("FZPRATE")
    96 => NameKnown("MASSDR")
    97 => NameKnown("MASSDS")
    98 => NameKnown("MASSDG")
    99 => NameKnown("MASSDH")
    100 => NameKnown("SPNCR")
    101 => NameKnown("SPNCS")
    102 => NameKnown("SPNCG")
    103 => NameKnown("SPNCH")
    104 => NameKnown("NUMDR")
    105 => NameKnown("NUMDS")
    106 => NameKnown("NUMDG")
    107 => NameKnown("NUMDH")
    108 => NameKnown("SHTPRM")
    109 => NameKnown("MDLWHVA")
    110 => NameKnown("SMLWHMA")
    111 => NameKnown("MMLWHDA")
    112 => NameKnown("MDLWGVA")
    113 => NameKnown("SMLWGMA")
    114 => NameKnown("MMLWGDA")
    115 => NameKnown("MDLWSVA")
    116 => NameKnown("SMLWSMA")
    117 => NameKnown("MMLWSDA")
    118 => NameKnown("UNCSH")
    119 => NameKnown("UCSCLW")
    120 => NameKnown("UCSCIW")
    121 => NameKnown("FSNOWC")
    122 => NameKnown("PIIDX")
    123 => NameKnown("DPTYPE")
    124 => NameKnown("PSHOW")
    125 => NameKnown("PBSNOW")
    126 => NameKnown("PBLIZZ")
    127 => NameKnown("ICEP")
    128 => NameKnown("TSPRATE")
    129 => NameKnown("EFRCWAT")
    130 => NameKnown("EFRRAIN")
    131 => NameKnown("EFRCICE")
    132 => NameKnown("EFRSNOW")
    133 => NameKnown("EFRGRL")
    134 => NameKnown("EFRHAIL")
    135 => NameKnown("EFRSLC")
    136 => NameKnown("EFRSICEC")
    137 => NameKnown("EFARRAIN")
    138 => NameKnown("EFARCICE")
    139 => NameKnown("EFARSNOW")
    140 => NameKnown("EFARGRL")
    141 => NameKnown("EFARHAIL")
    142 => NameKnown("EFARSIC")
    143 => NameKnown("PERATE")
    144 => NameKnown("SRWATERC")
    145 => NameKnown("SSNOWWC")
    146 => NameKnown("CICEPR")
    147 => NameKnown("CHPRECIP")
    148 => NameKnown("SNOWERAT")
    149 => NameKnown("CWATERMR")
    150 => NameKnown("CEWVMF")
    151 => NameKnown("CNWVMF")
    152 => NameKnown("CECLWMF")
    153 => NameKnown("CNCLWMF")
    154 => NameKnown("CECIMF")
    155 => NameKnown("CNCIMF")
    156 => NameKnown("CERMF")
    157 => NameKnown("CNRMF")
    158 => NameKnown("CEFMF")
    159 => NameKnown("CNSMF")
    160 => NameKnown("CDWFMF")
    161 => NameKnown("CDCLWMF")
    162 => NameKnown("CDCIMF")
    163 => NameKnown("CDRMF")
    164 => NameKnown("CDSMF")
    165 => NameKnown("CDTWMF")
    166 => NameKnown("CWVF")
    167 => NameKnown("TCSLW")
    168 => NameKnown("SSPFHW")
    169 => NameKnown("TCISSPFHW")
    170 => NameKnown("MEANHAIL")
    171 => NameKnown("MAXHAIL")
    192 => NameKnown("CRAIN")
    193 => NameKnown("CFRZR")
    194 => NameKnown("CICEP")
    195 => NameKnown("CSNOW")
    196 => NameKnown("CPRAT")
    197 => NameKnown("MDIV")
    198 => NameKnown("MINRH")
    199 => NameKnown("PEVAP")
    200 => NameKnown("PEVPR")
    201 => NameKnown("SNOWC")
    202 => NameKnown("FRAIN")
    203 => NameKnown("RIME")
    204 => NameKnown("TCOLR")
    205 => NameKnown("TCOLS")
    206 => NameKnown("TIPD")
    207 => NameKnown("NCIP")
    208 => NameKnown("SNOT")
    209 => NameKnown("TCLSW")
    210 => NameKnown("TCOLM")
    211 => NameKnown("EMNP")
    212 => NameKnown("SBSNO")
    213 => NameKnown("CNVMR")
    214 => NameKnown("SHAMR")
    215 => NameKnown("VDFMR")
    216 => NameKnown("CONDP")
    217 => NameKnown("LRGMR")
    218 => NameKnown("QZ0")
    219 => NameKnown("QMAX")
    220 => NameKnown("QMIN")
    221 => NameKnown("ARAIN")
    222 => NameKnown("SNOWT")
    223 => NameKnown("APCPN")
    224 => NameKnown("ACPCPN")
    225 => NameKnown("FRZR")
    226 => NameKnown("PWTHER")
    227 => NameKnown("FROZR")
    228 => NameKnown("FICEAC")
    229 => NameKnown("LICEAC")
    230 => NameKnown("SLACC")
    231 => NameKnown("PPINDX")
    232 => NameKnown("PROBCIP")
    233 => NameKnown("SNOWLR")
    234 => NameKnown("PCPDUR")
    235 => NameKnown("CLLMR")
    236 => NameKnown("HAILAC")
    237 => NameKnown("TCOLP")
    238 => NameKnown("PRATE1MIN")
    239 => NameKnown("PRATE5MIN")
    240 => NameKnown("PRATE10MIN")
    241 => NameKnown("TSNOW")
    242 => NameKnown("RHPW")
    245 => NameKnown("MAXVIG")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 63 ||
        parameter == 89 ||
        (parameter >= 172 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("WDIR")
    1 => NameKnown("WIND")
    2 => NameKnown("UGRD")
    3 => NameKnown("VGRD")
    4 => NameKnown("STRM")
    5 => NameKnown("VPOT")
    6 => NameKnown("MNTSF")
    7 => NameKnown("SGCVV")
    8 => NameKnown("VVEL")
    9 => NameKnown("DZDT")
    10 => NameKnown("ABSV")
    11 => NameKnown("ABSD")
    12 => NameKnown("RELV")
    13 => NameKnown("RELD")
    14 => NameKnown("PVORT")
    15 => NameKnown("VUCSH")
    16 => NameKnown("VVCSH")
    17 => NameKnown("UFLX")
    18 => NameKnown("VFLX")
    19 => NameKnown("WMIXE")
    20 => NameKnown("BLYDP")
    21 => NameKnown("MAXGUST")
    22 => NameKnown("GUST")
    23 => NameKnown("UGUST")
    24 => NameKnown("VGUST")
    25 => NameKnown("VWSH")
    26 => NameKnown("MFLX")
    27 => NameKnown("USTM")
    28 => NameKnown("VSTM")
    29 => NameKnown("CD")
    30 => NameKnown("FRICV")
    31 => NameKnown("TDCMOM")
    32 => NameKnown("ETACVV")
    33 => NameKnown("WINDF")
    34 => NameKnown("NWIND")
    35 => NameKnown("TWIND")
    36 => NameKnown("AFRWE")
    37 => NameKnown("NTSS")
    38 => NameKnown("ETSS")
    39 => NameKnown("EWTPARM")
    40 => NameKnown("NWTPARM")
    41 => NameKnown("UGWIND")
    42 => NameKnown("VGWIND")
    43 => NameKnown("GEOWD")
    44 => NameKnown("GEOWS")
    45 => NameKnown("UNDIV")
    46 => NameKnown("VORTADV")
    47 => NameKnown("SFRHEAT")
    48 => NameKnown("SFRMOIST")
    49 => NameKnown("WINDSTR")
    50 => NameKnown("EWINDSTR")
    51 => NameKnown("NWINDSTR")
    52 => NameKnown("UWINDSTR")
    53 => NameKnown("VWINDSTR")
    54 => NameKnown("NLSRLH")
    55 => NameKnown("NLSRLM")
    56 => NameKnown("UNWIND")
    57 => NameKnown("VNWIND")
    58 => NameKnown("TSFCSTR")
    59 => NameKnown("VDIV")
    60 => NameKnown("DTC")
    61 => NameKnown("DEC")
    62 => NameKnown("EASTTSS")
    63 => NameKnown("NRTHTSS")
    64 => NameKnown("EASTTSSOD")
    65 => NameKnown("NRTHTSSOD")
    66 => NameKnown("EASTTSSSR")
    67 => NameKnown("NRTHTSSSR")
    68 => NameKnown("CNVGUST")
    69 => NameKnown("TURBGUST")
    192 => NameKnown("VWSH")
    193 => NameKnown("MFLX")
    194 => NameKnown("USTM")
    195 => NameKnown("VSTM")
    196 => NameKnown("CD")
    197 => NameKnown("FRICV")
    198 => NameKnown("LAUV")
    199 => NameKnown("LOUV")
    200 => NameKnown("LAVV")
    201 => NameKnown("LOVV")
    202 => NameKnown("LAPP")
    203 => NameKnown("LOPP")
    204 => NameKnown("VEDH")
    205 => NameKnown("COVMZ")
    206 => NameKnown("COVTZ")
    207 => NameKnown("COVTM")
    208 => NameKnown("VDFUA")
    209 => NameKnown("VDFVA")
    210 => NameKnown("GWDU")
    211 => NameKnown("GWDV")
    212 => NameKnown("CNVU")
    213 => NameKnown("CNVV")
    214 => NameKnown("WTEND")
    215 => NameKnown("OMGALF")
    216 => NameKnown("CNGWDU")
    217 => NameKnown("CNGWDV")
    218 => NameKnown("LMV")
    219 => NameKnown("PVMWW")
    220 => NameKnown("MAXUVV")
    221 => NameKnown("MAXDVV")
    222 => NameKnown("MAXUW")
    223 => NameKnown("MAXVW")
    224 => NameKnown("VRATE")
    225 => NameKnown("TRWSPD")
    226 => NameKnown("TRWDIR")
    227 => NameKnown("TOA10")
    228 => NameKnown("TOA50")
    229 => NameKnown("TOD50")
    230 => NameKnown("TOD90")
    231 => NameKnown("TPWDIR")
    232 => NameKnown("TPWSPD")
    233 => NameKnown("ESHR")
    234 => NameKnown("UESH")
    235 => NameKnown("VESH")
    236 => NameKnown("UEID")
    237 => NameKnown("VEID")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 70 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("PRES")
    1 => NameKnown("PRMSL")
    2 => NameKnown("PTEND")
    3 => NameKnown("ICAHT")
    4 => NameKnown("GP")
    5 => NameKnown("HGT")
    6 => NameKnown("DIST")
    7 => NameKnown("HSTDV")
    8 => NameKnown("PRESA")
    9 => NameKnown("GPA")
    10 => NameKnown("DEN")
    11 => NameKnown("ALTS")
    12 => NameKnown("THICK")
    13 => NameKnown("PRESALT")
    14 => NameKnown("DENALT")
    15 => NameKnown("5WAVH")
    16 => NameKnown("U-GWD")
    17 => NameKnown("V-GWD")
    18 => NameKnown("HPBL")
    19 => NameKnown("5WAVA")
    20 => NameKnown("SDSGSO")
    21 => NameKnown("AOSGSO")
    22 => NameKnown("SSGSO")
    23 => NameKnown("GWD")
    24 => NameKnown("ASGSO")
    25 => NameKnown("NLPRES")
    26 => NameKnown("EXPRES")
    27 => NameKnown("UMFLX")
    28 => NameKnown("DMFLX")
    29 => NameKnown("UDRATE")
    30 => NameKnown("DDRATE")
    31 => NameKnown("UCLSPRS")
    32 => NameKnown("SWATERVP")
    33 => NameKnown("GAMSL")
    34 => NameKnown("GHAGRD")
    35 => NameKnown("CDTMF")
    36 => NameKnown("CETMF")
    37 => NameKnown("CNTMF")
    38 => NameKnown("SDFSO")
    39 => NameKnown("CMATMOS")
    40 => NameKnown("CEGFLUX")
    41 => NameKnown("CNGFLUX")
    42 => NameKnown("CDWGFLUX")
    43 => NameKnown("CDGFLUX")
    44 => NameKnown("HWBT")
    45 => NameKnown("WOBT")
    46 => NameKnown("PRESDHS")
    192 => NameKnown("MSLET")
    193 => NameKnown("5WAVH")
    194 => NameKnown("U-GWD")
    195 => NameKnown("V-GWD")
    196 => NameKnown("HPBL")
    197 => NameKnown("5WAVA")
    198 => NameKnown("MSLMA")
    199 => NameKnown("TSLSA")
    200 => NameKnown("PLPL")
    201 => NameKnown("LPSX")
    202 => NameKnown("LPSY")
    203 => NameKnown("HGTX")
    204 => NameKnown("HGTY")
    205 => NameKnown("LAYTH")
    206 => NameKnown("NLGSP")
    207 => NameKnown("CNVUMF")
    208 => NameKnown("CNVDMF")
    209 => NameKnown("CNVDEMF")
    210 => NameKnown("LMH")
    211 => NameKnown("HGTN")
    212 => NameKnown("PRESN")
    213 => NameKnown("ORCONV")
    214 => NameKnown("ORASW")
    215 => NameKnown("ORASS")
    216 => NameKnown("ORASSW")
    217 => NameKnown("ORASNW")
    218 => NameKnown("ORLSW")
    219 => NameKnown("ORLSS")
    220 => NameKnown("ORLSSW")
    221 => NameKnown("ORLSNW")
    222 => NameKnown("EFSH")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 47 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("NSWRS")
    1 => NameKnown("NSWRT")
    2 => NameKnown("SWAVR")
    3 => NameKnown("GRAD")
    4 => NameKnown("BRTMP")
    5 => NameKnown("LWRAD")
    6 => NameKnown("SWRAD")
    7 => NameKnown("DSWRF")
    8 => NameKnown("USWRF")
    9 => NameKnown("NSWRF")
    10 => NameKnown("PHOTAR")
    11 => NameKnown("NSWRFCS")
    12 => NameKnown("DWUVR")
    13 => NameKnown("DSWRFLX")
    14 => NameKnown("DIFSWRF")
    15 => NameKnown("UVVEARTH")
    50 => NameKnown("UVIUCS")
    51 => NameKnown("UVI")
    52 => NameKnown("DSWRFCS")
    53 => NameKnown("USWRFCS")
    54 => NameKnown("DNSWRFLX")
    55 => NameKnown("UVALBDIF")
    56 => NameKnown("UVALBDIR")
    57 => NameKnown("UBALBDIRG")
    58 => NameKnown("UVALBDIRI")
    59 => NameKnown("UVBDIRV")
    60 => NameKnown("PHOARFCS")
    61 => NameKnown("DSWRFLXCS")
    62 => NameKnown("DNSWRFLXCS")
    63 => NameKnown("DFSWRFLXCS")
    192 => NameKnown("DSWRF")
    193 => NameKnown("USWRF")
    194 => NameKnown("DUVB")
    195 => NameKnown("CDUVB")
    196 => NameKnown("CSDSF")
    197 => NameKnown("SWHR")
    198 => NameKnown("CSUSF")
    199 => NameKnown("CFNSF")
    200 => NameKnown("VBDSF")
    201 => NameKnown("VDDSF")
    202 => NameKnown("NBDSF")
    203 => NameKnown("NDDSF")
    204 => NameKnown("DTRF")
    205 => NameKnown("UTRF")
    206 => NameKnown("DFSWRFLXCS")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 16 && parameter <= 49) ||
        (parameter >= 64 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_5_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("NLWRS")
    1 => NameKnown("NLWRT")
    2 => NameKnown("LWAVR")
    3 => NameKnown("DLWRF")
    4 => NameKnown("ULWRF")
    5 => NameKnown("NLWRF")
    6 => NameKnown("NLWRCS")
    7 => NameKnown("BRTEMP")
    8 => NameKnown("DLWRFCS")
    9 => NameKnown("NIRALBDIF")
    10 => NameKnown("NIRALBDIR")
    11 => NameKnown("NIRALBDIRG")
    12 => NameKnown("NIRALBDIRI")
    13 => NameKnown("NIRALBDIRV")
    192 => NameKnown("DLWRF")
    193 => NameKnown("ULWRF")
    194 => NameKnown("LWHR")
    195 => NameKnown("CSULF")
    196 => NameKnown("CSDLF")
    197 => NameKnown("CFNLF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 14 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=5,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_6_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("CICE")
    1 => NameKnown("TCDC")
    2 => NameKnown("CDCON")
    3 => NameKnown("LCDC")
    4 => NameKnown("MCDC")
    5 => NameKnown("HCDC")
    6 => NameKnown("CWAT")
    7 => NameKnown("CDCA")
    8 => NameKnown("CDCT")
    9 => NameKnown("TMAXT")
    10 => NameKnown("THUNC")
    11 => NameKnown("CDCB")
    12 => NameKnown("CDCTOP")
    13 => NameKnown("CEIL")
    14 => NameKnown("CDLYR")
    15 => NameKnown("CWORK")
    16 => NameKnown("CUEFI")
    17 => NameKnown("TCONDO")
    18 => NameKnown("TCOLWO")
    19 => NameKnown("TCOLIO")
    20 => NameKnown("TCOLC")
    21 => NameKnown("FICE")
    22 => NameKnown("CDCC")
    23 => NameKnown("CDCIMR")
    24 => NameKnown("SUNS")
    25 => NameKnown("CBHE")
    26 => NameKnown("HCONCB")
    27 => NameKnown("HCONCT")
    28 => NameKnown("NCONCD")
    29 => NameKnown("NCCICE")
    30 => NameKnown("NDENCD")
    31 => NameKnown("NDCICE")
    32 => NameKnown("FRACCC")
    33 => NameKnown("SUNSD")
    34 => NameKnown("SLWTC")
    35 => NameKnown("SSWTC")
    36 => NameKnown("FSTRPC")
    37 => NameKnown("FCONPC")
    38 => NameKnown("MASSDCD")
    39 => NameKnown("MASSDCI")
    40 => NameKnown("MDCCWD")
    47 => NameKnown("VFRCWD")
    48 => NameKnown("VFRCICE")
    49 => NameKnown("VFRCIW")
    50 => NameKnown("FOG")
    51 => NameKnown("SUNFRAC")
    192 => NameKnown("CDLYR")
    193 => NameKnown("CWORK")
    194 => NameKnown("CUEFI")
    195 => NameKnown("TCOND")
    196 => NameKnown("TCOLW")
    197 => NameKnown("TCOLI")
    198 => NameKnown("TCOLC")
    199 => NameKnown("FICE")
    200 => NameKnown("MFLUX")
    201 => NameKnown("SUNSD")
    202 => NameKnown("FOGLWC")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 41 && parameter <= 46) ||
        (parameter >= 52 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=6,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_7_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("PLI")
    1 => NameKnown("BLI")
    2 => NameKnown("KX")
    3 => NameKnown("KOX")
    4 => NameKnown("TOTALX")
    5 => NameKnown("SX")
    6 => NameKnown("CAPE")
    7 => NameKnown("CIN")
    8 => NameKnown("HLCY")
    9 => NameKnown("EHLX")
    10 => NameKnown("LFTX")
    11 => NameKnown("4LFTX")
    12 => NameKnown("RI")
    13 => NameKnown("SHWINX")
    15 => NameKnown("UPHL")
    16 => NameKnown("BLKRN")
    17 => NameKnown("GRDRN")
    18 => NameKnown("FLXRN")
    19 => NameKnown("CONAPES")
    20 => NameKnown("TIIDEX")
    21 => NameKnown("SSI")
    22 => NameKnown("RMOL")
    192 => NameKnown("LFTX")
    193 => NameKnown("4LFTX")
    194 => NameKnown("RI")
    195 => NameKnown("CWDI")
    196 => NameKnown("UVI")
    197 => NameKnown("UPHL")
    198 => NameKnown("LAI")
    199 => NameKnown("MXUPHL")
    200 => NameKnown("MNUPHL")
    201 => NameKnown("BNEGELAY")
    202 => NameKnown("BPOSELAY")
    203 => NameKnown("DCAPE")
    204 => NameKnown("EFHL")
    205 => NameKnown("ESP")
    206 => NameKnown("CANGLE")
    207 => NameKnown("E3KH")
    208 => NameKnown("STPC")
    209 => NameKnown("SIGH")
    210 => NameKnown("SCCP")
    211 => NameKnown("SIGT")
    212 => NameKnown("MLFC")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 14 || (parameter >= 23 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=7,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_13_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("AEROT")
    192 => NameKnown("PMTC")
    193 => NameKnown("PMTF")
    194 => NameKnown("LPMTF")
    195 => NameKnown("LIPMF")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 1 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=13,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_14_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TOZNE")
    1 => NameKnown("O3MR")
    2 => NameKnown("TCIOZ")
    192 => NameKnown("O3MR")
    193 => NameKnown("OZCON")
    194 => NameKnown("OZCAT")
    195 => NameKnown("VDFOZ")
    196 => NameKnown("POZ")
    197 => NameKnown("TOZ")
    198 => NameKnown("POZT")
    199 => NameKnown("POZO")
    200 => NameKnown("OZMAX1")
    201 => NameKnown("OZMAX8")
    202 => NameKnown("PDMAX1")
    203 => NameKnown("PDMAX24")
    204 => NameKnown("ALD2")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 3 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=14,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_15_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("BSWID")
    1 => NameKnown("BREF")
    2 => NameKnown("BRVEL")
    3 => NameKnown("VIL")
    4 => NameKnown("LMAXBR")
    5 => NameKnown("PREC")
    6 => NameKnown("RDSP1")
    7 => NameKnown("RDSP2")
    8 => NameKnown("RDSP3")
    9 => NameKnown("RFCD")
    10 => NameKnown("RFCI")
    11 => NameKnown("RFSNOW")
    12 => NameKnown("RFRAIN")
    13 => NameKnown("RFGRPL")
    14 => NameKnown("RFHAIL")
    15 => NameKnown("HSR")
    16 => NameKnown("HSRHT")
    17 => NameKnown("PRATERAD")
    18 => NameKnown("RQI")
    19 => NameKnown("RDQF")
    20 => NameKnown("LMAXPRATE")
    192 => NameKnown("RADARVIL")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 21 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=15,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_16_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("REFZR")
    1 => NameKnown("REFZI")
    2 => NameKnown("REFZC")
    3 => NameKnown("RETOP")
    4 => NameKnown("REFD")
    5 => NameKnown("REFC")
    6 => NameKnown("PRATEFRAD")
    7 => NameKnown("LMAXPRATEF")
    8 => NameKnown("LMAXREF")
    192 => NameKnown("REFZR")
    193 => NameKnown("REFZI")
    194 => NameKnown("REFZC")
    195 => NameKnown("REFD")
    196 => NameKnown("REFC")
    197 => NameKnown("RETOP")
    198 => NameKnown("MAXREF")
    199 => NameKnown("MAXREFC")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 9 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=16,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_17_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("LTNGSD")
    1 => NameKnown("LTPINX")
    2 => NameKnown("CDGDLTFD")
    3 => NameKnown("CDCDLTFD")
    4 => NameKnown("TLGTFD")
    5 => NameKnown("SLNGPIDX")
    192 => NameKnown("LTNG")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 6 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=17,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_18_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ACCES")
    1 => NameKnown("ACIOD")
    2 => NameKnown("ACRADP")
    3 => NameKnown("GDCES")
    4 => NameKnown("GDIOD")
    5 => NameKnown("GDRADP")
    6 => NameKnown("TIACCP")
    7 => NameKnown("TIACIP")
    8 => NameKnown("TIACRP")
    10 => NameKnown("AIRCON")
    11 => NameKnown("WETDEP")
    12 => NameKnown("DRYDEP")
    13 => NameKnown("TOTLWD")
    14 => NameKnown("SACON")
    15 => NameKnown("MAXACON")
    16 => NameKnown("HMXACON")
    17 => NameKnown("CIAIRC")
    18 => NameKnown("CAACL")
    19 => NameKnown("DEPACTA")
    20 => NameKnown("DEPACTE")
    21 => NameKnown("CLDACTA")
    22 => NameKnown("CLDACTE")
    23 => NameKnown("EFFDOSER")
    24 => NameKnown("THYDOSER")
    25 => NameKnown("GAMDOSER")
    26 => NameKnown("ACTEMM")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 9 || (parameter >= 27 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=18,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_19_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("VIS")
    1 => NameKnown("ALBDO")
    2 => NameKnown("TSTM")
    3 => NameKnown("MIXHT")
    4 => NameKnown("VOLASH")
    5 => NameKnown("ICIT")
    6 => NameKnown("ICIB")
    7 => NameKnown("ICI")
    8 => NameKnown("TURBT")
    9 => NameKnown("TURBB")
    10 => NameKnown("TURB")
    11 => NameKnown("TKE")
    12 => NameKnown("PBLREG")
    13 => NameKnown("CONTI")
    14 => NameKnown("CONTET")
    15 => NameKnown("CONTT")
    16 => NameKnown("CONTB")
    17 => NameKnown("MXSALB")
    18 => NameKnown("SNFALB")
    19 => NameKnown("SALBD")
    20 => NameKnown("ICIP")
    21 => NameKnown("CTP")
    22 => NameKnown("CAT")
    23 => NameKnown("SLDP")
    24 => NameKnown("CONTKE")
    25 => NameKnown("WIWW")
    26 => NameKnown("CONVO")
    27 => NameKnown("ICESC")
    28 => NameKnown("MWTURB")
    29 => NameKnown("CATEDR")
    30 => NameKnown("EDPARM")
    31 => NameKnown("MXEDPRM")
    32 => NameKnown("HIFREL")
    33 => NameKnown("VISLFOG")
    34 => NameKnown("VISIFOG")
    35 => NameKnown("VISBSN")
    36 => NameKnown("PSNOWS")
    37 => NameKnown("ICESEV")
    38 => NameKnown("SKYIDX")
    39 => NameKnown("SEEINDEX")
    40 => NameKnown("SNOWLVL")
    41 => NameKnown("DBHEIGHT")
    42 => NameKnown("TLBHEIGHT")
    43 => NameKnown("TLTHEIGHT")
    44 => NameKnown("MEANVGRTL")
    45 => NameKnown("MINVGRTL")
    46 => NameKnown("NETRADFLUX")
    47 => NameKnown("GLIRRTS")
    48 => NameKnown("PCONTT")
    49 => NameKnown("PCONTB")
    50 => NameKnown("CITEDR")
    51 => NameKnown("VISPCP")
    52 => NameKnown("HAILKEF")
    192 => NameKnown("MXSALB")
    193 => NameKnown("SNFALB")
    194 => NameKnown("SRCONO")
    195 => NameKnown("MRCONO")
    196 => NameKnown("HRCONO")
    197 => NameKnown("TORPROB")
    198 => NameKnown("HAILPROB")
    199 => NameKnown("WINDPROB")
    200 => NameKnown("STORPROB")
    201 => NameKnown("SHAILPRO")
    202 => NameKnown("SWINDPRO")
    203 => NameKnown("TSTMC")
    204 => NameKnown("MIXLY")
    205 => NameKnown("FLGHT")
    206 => NameKnown("CICEL")
    207 => NameKnown("CIVIS")
    208 => NameKnown("CIFLT")
    209 => NameKnown("LAVNI")
    210 => NameKnown("HAVNI")
    211 => NameKnown("SBSALB")
    212 => NameKnown("SWSALB")
    213 => NameKnown("NBSALB")
    214 => NameKnown("NWSALB")
    215 => NameKnown("PRSVR")
    216 => NameKnown("PRSIGSVR")
    217 => NameKnown("SIPD")
    218 => NameKnown("EPSR")
    219 => NameKnown("TPFI")
    220 => NameKnown("SVRTS")
    221 => NameKnown("PROCON")
    222 => NameKnown("CONVP")
    223 => NameKnown("CIGTOR")
    224 => NameKnown("CIGHAIL")
    225 => NameKnown("CIGWIND")
    226 => NameKnown("CIGSVR")
    232 => NameKnown("VAFTD")
    233 => NameKnown("ICPRB")
    234 => NameKnown("ICSEV")
    235 => NameKnown("JFWPRB")
    236 => NameKnown("SNOWLVL")
    237 => NameKnown("DRYTPROB")
    238 => NameKnown("ELLINX")
    239 => NameKnown("CWASP")
    240 => NameKnown("ICESEVCON")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 53 && parameter <= 191) ||
        (parameter >= 227 && parameter <= 231) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=19,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_190_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ATEXT")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 1 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=190,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_191_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("TSEC")
    1 => NameKnown("GEOLAT")
    2 => NameKnown("GEOLON")
    3 => NameKnown("DSLOBS")
    4 => NameKnown("TCDTRACK")
    5 => NameKnown("HURTSV")
    6 => NameKnown("TSTSV")
    7 => NameKnown("TDTSV")
    192 => NameKnown("NLAT")
    193 => NameKnown("ELON")
    194 => NameKnown("RTSEC")
    195 => NameKnown("MLYNO")
    196 => NameKnown("NLATN")
    197 => NameKnown("ELONN")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 8 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=191,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_0_192_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    1 => NameKnown("COVMZ")
    2 => NameKnown("COVTZ")
    3 => NameKnown("COVTM")
    4 => NameKnown("COVTW")
    5 => NameKnown("COVZZ")
    6 => NameKnown("COVMM")
    7 => NameKnown("COVQZ")
    8 => NameKnown("COVQM")
    9 => NameKnown("COVTVV")
    10 => NameKnown("COVQVV")
    11 => NameKnown("COVPSPS")
    12 => NameKnown("COVQQ")
    13 => NameKnown("COVVVVV")
    14 => NameKnown("COVTT")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 0 || (parameter >= 15 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=0,cat=192,param=" + parameter.to_string())
      }
  }
}

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

///|
fn decode_parameter_number_4_2_10_0_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("WVSP1")
    1 => NameKnown("WVSP2")
    2 => NameKnown("WVSP3")
    3 => NameKnown("HTSGW")
    4 => NameKnown("WVDIR")
    5 => NameKnown("WVHGT")
    6 => NameKnown("WVPER")
    7 => NameKnown("SWDIR")
    8 => NameKnown("SWELL")
    9 => NameKnown("SWPER")
    10 => NameKnown("DIRPW")
    11 => NameKnown("PERPW")
    12 => NameKnown("DIRSW")
    13 => NameKnown("PERSW")
    14 => NameKnown("WWSDIR")
    15 => NameKnown("MWSPER")
    16 => NameKnown("CDWW")
    17 => NameKnown("FRICVW")
    18 => NameKnown("WSTR")
    19 => NameKnown("NWSTR")
    20 => NameKnown("MSSW")
    21 => NameKnown("USSD")
    22 => NameKnown("VSSD")
    23 => NameKnown("PMAXWH")
    24 => NameKnown("MAXWH")
    25 => NameKnown("IMWF")
    26 => NameKnown("IMFWW")
    27 => NameKnown("IMFTSW")
    28 => NameKnown("MZWPER")
    29 => NameKnown("MZPWW")
    30 => NameKnown("MZPTSW")
    31 => NameKnown("WDIRW")
    32 => NameKnown("DIRWWW")
    33 => NameKnown("DIRWTS")
    34 => NameKnown("PWPER")
    35 => NameKnown("PPERWW")
    36 => NameKnown("PPERTS")
    37 => NameKnown("ALTWH")
    38 => NameKnown("ALCWH")
    39 => NameKnown("ALRRC")
    40 => NameKnown("MNWSOW")
    41 => NameKnown("MWDIRW")
    42 => NameKnown("WESP")
    43 => NameKnown("KSSEW")
    44 => NameKnown("BENINX")
    45 => NameKnown("SPFTR")
    46 => NameKnown("PWAVEDIR")
    47 => NameKnown("SWHFSWEL")
    48 => NameKnown("SWHSSWEL")
    49 => NameKnown("SWHTSWEL")
    50 => NameKnown("MWPFSWEL")
    51 => NameKnown("MWPSSWEL")
    52 => NameKnown("MWPTSWEL")
    53 => NameKnown("MWDFSWEL")
    54 => NameKnown("MWDSSWEL")
    55 => NameKnown("MWDTSWEL")
    56 => NameKnown("WDWFSWEL")
    57 => NameKnown("WDWSSWEL")
    58 => NameKnown("WDWTSWEL")
    59 => NameKnown("WFWFSWEL")
    60 => NameKnown("WFWSSWEL")
    61 => NameKnown("WFWTSWEL")
    62 => NameKnown("WAVEFREW")
    63 => NameKnown("FREWWW")
    64 => NameKnown("FREWTSW")
    65 => NameKnown("PWPFSPAR")
    66 => NameKnown("PWPSSPAR")
    67 => NameKnown("PWPTSPAR")
    68 => NameKnown("PWDFSPAR")
    69 => NameKnown("PWDSSPAR")
    70 => NameKnown("PWDTSPAR")
    71 => NameKnown("PDWWAVE")
    72 => NameKnown("PDTSWELL")
    73 => NameKnown("WCAPFRAC")
    74 => NameKnown("MDTSWEL")
    75 => NameKnown("MDWWAVE")
    76 => NameKnown("CHNCK")
    77 => NameKnown("WAVESPSK")
    78 => NameKnown("WAVEFMAG")
    79 => NameKnown("WAVEFDIR")
    80 => NameKnown("RWAVEAFW")
    81 => NameKnown("FCVOCEAN")
    82 => NameKnown("AIRDENOC")
    83 => NameKnown("NEFW")
    84 => NameKnown("NSOCEAN")
    85 => NameKnown("NEFOCEAN")
    86 => NameKnown("SEVWAVE")
    87 => NameKnown("WAVEMSLC")
    88 => NameKnown("SPECWI")
    89 => NameKnown("EFWS")
    90 => NameKnown("USMFO")
    91 => NameKnown("VSMFO")
    92 => NameKnown("WAVETEFO")
    93 => NameKnown("EMIWAVE")
    94 => NameKnown("TDMCREST")
    95 => NameKnown("TDMWAVE")
    96 => NameKnown("STMCREST")
    97 => NameKnown("STMWAVE")
    98 => NameKnown("GODAPEAK")
    99 => NameKnown("BFI2D")
    100 => NameKnown("CTCORR")
    101 => NameKnown("WSTRICEX")
    102 => NameKnown("WSTRICEY")
    103 => NameKnown("UASMF")
    104 => NameKnown("VASMF")
    192 => NameKnown("WSTP")
    193 => NameKnown("WLENG")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 105 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 194 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=0,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_1_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("DIRC")
    1 => NameKnown("SPC")
    2 => NameKnown("UOGRD")
    3 => NameKnown("VOGRD")
    4 => NameKnown("RIPCOP")
    5 => NameKnown("EASTCUR")
    6 => NameKnown("NRTHCUR")
    192 => NameKnown("OMLU")
    193 => NameKnown("OMLV")
    194 => NameKnown("UBARO")
    195 => NameKnown("VBARO")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 7 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 196 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=1,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_2_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("ICEC")
    1 => NameKnown("ICETK")
    2 => NameKnown("DICED")
    3 => NameKnown("SICED")
    4 => NameKnown("UICE")
    5 => NameKnown("VICE")
    6 => NameKnown("ICEG")
    7 => NameKnown("ICED")
    8 => NameKnown("ICETMP")
    9 => NameKnown("ICEPRS")
    10 => NameKnown("ZVCICEP")
    11 => NameKnown("MVCICEP")
    12 => NameKnown("CICES")
    13 => NameKnown("SNOWTSI")
    14 => NameKnown("ALBDOICE")
    15 => NameKnown("SICEVOL")
    16 => NameKnown("SNVOLSI")
    17 => NameKnown("SICEHC")
    18 => NameKnown("SNCEHC")
    19 => NameKnown("ICEFTHCK")
    20 => NameKnown("ICEMPF")
    21 => NameKnown("ICEMPD")
    22 => NameKnown("ICEMPV")
    23 => NameKnown("SIFTP")
    24 => NameKnown("XICE")
    25 => NameKnown("YICE")
    26 => NameKnown("SICESAL")
    27 => NameKnown("FRZMLTPOT")
    28 => NameKnown("MLTDATE")
    29 => NameKnown("FRZDATE")
    30 => NameKnown("SICEBM")
    31 => NameKnown("DSWRFICE")
    255 => NameKnown("Missing")
    _ =>
      if parameter >= 32 && parameter <= 191 {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=2,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_3_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("WTMP")
    1 => NameKnown("DSLM")
    2 => NameKnown("CH")
    3 => NameKnown("PRACTSAL")
    4 => NameKnown("DWHFLUX")
    5 => NameKnown("EASTWSS")
    6 => NameKnown("NORTHWSS")
    7 => NameKnown("XCOMPSS")
    8 => NameKnown("YCOMPSS")
    9 => NameKnown("THERCSSH")
    10 => NameKnown("HALOCSSH")
    11 => NameKnown("STERCSSH")
    12 => NameKnown("SEASFLUX")
    13 => NameKnown("NETUPWFLUX")
    14 => NameKnown("ESURFWVEL")
    15 => NameKnown("NSURFWVEL")
    16 => NameKnown("XSURFWVEL")
    17 => NameKnown("YSURFWVEL")
    18 => NameKnown("HFLUXCOR")
    19 => NameKnown("SSHGTPARM")
    20 => NameKnown("DSLIBARCOR")
    21 => NameKnown("SALINITY")
    22 => NameKnown("DSWRFSS")
    192 => NameKnown("SURGE")
    193 => NameKnown("ETSRG")
    194 => NameKnown("ELEV")
    195 => NameKnown("SSHG")
    196 => NameKnown("P2OMLT")
    197 => NameKnown("AOHFLX")
    198 => NameKnown("ASHFL")
    199 => NameKnown("SSTT")
    200 => NameKnown("SSST")
    201 => NameKnown("KENG")
    202 => NameKnown("SLTFL")
    203 => NameKnown("LCH")
    204 => NameKnown("FRZSPR")
    205 => NameKnown("TWLWAV")
    206 => NameKnown("RUNUP")
    207 => NameKnown("SETUP")
    208 => NameKnown("SWASH")
    209 => NameKnown("TWLDT")
    210 => NameKnown("TWLDC")
    242 => NameKnown("TCSRG20")
    243 => NameKnown("TCSRG30")
    244 => NameKnown("TCSRG40")
    245 => NameKnown("TCSRG50")
    246 => NameKnown("TCSRG60")
    247 => NameKnown("TCSRG70")
    248 => NameKnown("TCSRG80")
    249 => NameKnown("TCSRG90")
    250 => NameKnown("ETCWL")
    251 => NameKnown("TIDE")
    252 => NameKnown("EROSNP")
    253 => NameKnown("OWASHP")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 23 && parameter <= 191) ||
        (parameter >= 211 && parameter <= 241) ||
        parameter == 254 {
        NameKnown("Reserved")
      } else {
        NameUnknown("disc=10,cat=3,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_4_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("MTHD")
    1 => NameKnown("MTHA")
    2 => NameKnown("TTHDP")
    3 => NameKnown("SALTY")
    4 => NameKnown("OVHD")
    5 => NameKnown("OVSD")
    6 => NameKnown("OVMD")
    7 => NameKnown("BATHY")
    11 => NameKnown("SFSALP")
    12 => NameKnown("SFTMPP")
    13 => NameKnown("ACWSRD")
    14 => NameKnown("WDEPTH")
    15 => NameKnown("WTMPSS")
    16 => NameKnown("WATERDEN")
    17 => NameKnown("WATDENA")
    18 => NameKnown("WATPTEMP")
    19 => NameKnown("WATPDEN")
    20 => NameKnown("WATPDENA")
    21 => NameKnown("PRTSAL")
    22 => NameKnown("WCHEATC")
    23 => NameKnown("EASTWVEL")
    24 => NameKnown("NRTHWVEL")
    25 => NameKnown("XCOMPWV")
    26 => NameKnown("YCOMPWV")
    27 => NameKnown("UPWWVEL")
    28 => NameKnown("VEDDYDIF")
    29 => NameKnown("BPEH")
    30 => NameKnown("FWFSW")
    31 => NameKnown("FWFC")
    32 => NameKnown("VSFSW")
    33 => NameKnown("VSFC")
    34 => NameKnown("SWTTNR")
    35 => NameKnown("SWSTNR")
    36 => NameKnown("SWTTP")
    37 => NameKnown("SWSTP")
    38 => NameKnown("ESWVP")
    39 => NameKnown("NSWVP")
    40 => NameKnown("SWTTBC")
    41 => NameKnown("SWSTBC")
    42 => NameKnown("SEAMVT")
    43 => NameKnown("SEAZVT")
    44 => NameKnown("SEACMVT")
    45 => NameKnown("SEACZVT")
    46 => NameKnown("SEAMMT")
    47 => NameKnown("SEAZMT")
    48 => NameKnown("SEACMMT")
    49 => NameKnown("SEACZMT")
    50 => NameKnown("SEACPSALT")
    51 => NameKnown("SEACSALT")
    52 => NameKnown("MLD")
    53 => NameKnown("NCOMPWVEL")
    54 => NameKnown("TCOMPWVEL")
    55 => NameKnown("SEAUVT")
    56 => NameKnown("SEAUMT")
    57 => NameKnown("SEAAGE")
    58 => NameKnown("DSWRFSEA")
    192 => NameKnown("WTMPC")
    193 => NameKnown("SALIN")
    194 => NameKnown("BKENG")
    195 => NameKnown("DBSS")
    196 => NameKnown("INTFD")
    197 => NameKnown("OHC")
    255 => NameKnown("Missing")
    _ =>
      if (parameter >= 8 && parameter <= 10) ||
        (parameter >= 59 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 198 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=4,param=" + parameter.to_string())
      }
  }
}

///|
fn decode_parameter_number_4_2_10_191_name(parameter : Int) -> Grib2NameLookup {
  match parameter {
    0 => NameKnown("IRTSEC")
    1 => NameKnown("MOSF")
    3 => NameKnown("DSLOBSO")
    4 => NameKnown("BARDSF")
    255 => NameKnown("Missing")
    _ =>
      if parameter == 2 || (parameter >= 5 && parameter <= 191) {
        NameKnown("Reserved")
      } else if parameter >= 192 && parameter <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("disc=10,cat=191,param=" + parameter.to_string())
      }
  }
}

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

