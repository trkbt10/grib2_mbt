///|
/// Code-table lookups for Section 4 surface/tile/model metadata: canopy cover,
/// soil texture, source/sink, wetland type, distribution function, coverage
/// attributes, tile classification, tile class, quality indicators, hazard
/// index, transport-dispersion model, emission scenario origin, and NWP
/// model identification.
pub fn decode_canopy_cover_fraction_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Crops, mixed farming")
    2 => NameKnown("Short grass")
    3 => NameKnown("Evergreen needleleaf trees")
    4 => NameKnown("Deciduous needleleaf trees")
    5 => NameKnown("Deciduous broadleaf trees")
    6 => NameKnown("Evergreen broadleaf trees")
    7 => NameKnown("Tall grass")
    8 => NameKnown("Desert")
    9 => NameKnown("Tundra")
    10 => NameKnown("Irrigated corps")
    11 => NameKnown("Semidesert")
    12 => NameKnown("Ice caps and glaciers")
    13 => NameKnown("Bogs and marshes")
    14 => NameKnown("Inland water")
    15 => NameKnown("Ocean")
    16 => NameKnown("Evergreen shrubs")
    17 => NameKnown("Deciduous shrubs")
    18 => NameKnown("Mixed forest")
    19 => NameKnown("Interrupted forest")
    20 => NameKnown("Water and land mixtures")
    255 => NameKnown("Missing")
    _ =>
      if value >= 21 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("canopy_cover_fraction=" + value.to_string())
      }
  }
}

///|
pub fn decode_soil_texture_fraction_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Coarse")
    2 => NameKnown("Medium")
    3 => NameKnown("Medium-fine")
    4 => NameKnown("Fine")
    5 => NameKnown("Very-fine")
    6 => NameKnown("Organic")
    7 => NameKnown("Tropical-organic")
    255 => NameKnown("Missing")
    _ =>
      if value >= 8 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("soil_texture_fraction=" + value.to_string())
      }
  }
}

///|
pub fn decode_source_or_sink_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Aviation")
    2 => NameKnown("Lightning")
    3 => NameKnown("Biogenic Sources")
    4 => NameKnown("Anthropogenic sources")
    5 => NameKnown("Wild fires")
    6 => NameKnown("Natural sources")
    7 => NameKnown("Bio-fuel")
    8 => NameKnown("Volcanoes")
    9 => NameKnown("Fossil-fuel")
    10 => NameKnown("Wetlands")
    11 => NameKnown("Oceans")
    12 => NameKnown("Elevated anthropogenic sources")
    13 => NameKnown("Surface anthropogenic sources")
    14 => NameKnown("Agriculture livestock")
    15 => NameKnown("Agriculture soils")
    16 => NameKnown("Agriculture waste burning")
    17 => NameKnown("Agriculture (all)")
    18 => NameKnown("Residential, commercial and other combustion")
    19 => NameKnown("Power generation")
    20 => NameKnown("Super power stations")
    21 => NameKnown("Fugitives")
    22 => NameKnown("Industrial process")
    23 => NameKnown("Solvents")
    24 => NameKnown("Ships")
    25 => NameKnown("Wastes")
    26 => NameKnown("Road transportation")
    27 => NameKnown("Off-road transportation")
    28 => NameKnown("Nuclear power plant")
    29 => NameKnown("Nuclear weapon")
    30 => NameKnown("Commercial Building Heating")
    31 => NameKnown("Residential Heating")
    32 => NameKnown("Oil Refineries and Transformation Industry")
    33 => NameKnown("Gas Production")
    34 => NameKnown("Vegetation")
    35 => NameKnown("Biomass Burning")
    36 => NameKnown("Settlements")
    37 => NameKnown("Soil")
    38 => NameKnown("Wild Animals")
    39 => NameKnown("Savannah")
    40 => NameKnown("Tropical Forest")
    41 => NameKnown("Boreal Forest")
    42 => NameKnown("Peatland")
    43 => NameKnown("Deforestation")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 44 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("source_or_sink=" + value.to_string())
      }
  }
}

///|
pub fn decode_wetland_type_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Bog")
    2 => NameKnown("Drained")
    3 => NameKnown("Fen")
    4 => NameKnown("Floodplain")
    5 => NameKnown("Mangrove")
    6 => NameKnown("Marsh")
    7 => NameKnown("Rice")
    8 => NameKnown("Riverine")
    9 => NameKnown("Salt Marsh")
    10 => NameKnown("Swamp")
    11 => NameKnown("Upland")
    12 => NameKnown("Wet Tundra")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 13 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("wetland_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_distribution_function_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No specific distribution function given")
    1 =>
      NameKnown(
        "Delta functions with spatially variable concentration and fixed diameters",
      )
    2 =>
      NameKnown(
        "Delta functions with spatially variable concentration and fixed masses",
      )
    3 =>
      NameKnown(
        "Gaussian (Normal) distribution with spatially variable concentration and fixed mean diameter and variance",
      )
    4 =>
      NameKnown(
        "Gaussian (Normal) distribution with spatially variable concentration, mean diameter and variance",
      )
    5 =>
      NameKnown(
        "Log-normal distribution with spatially variable number density, mean diameter and variance",
      )
    6 =>
      NameKnown(
        "Log-normal distribution with spatially variable number density, mean diameter and fixed variance",
      )
    7 =>
      NameKnown(
        "Log-normal distribution with spatially variable number density and mass density and fixed variance and fixed particle density",
      )
    8 =>
      NameKnown(
        "No distribution function. The encoded variable is derived from variables characterized by type of distribution function No. 7",
      )
    65535 => NameKnown("Missing")
    _ =>
      if value >= 9 && value <= 49151 {
        NameKnown("Reserved")
      } else if value >= 49152 && value <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_distribution_function=" + value.to_string())
      }
  }
}

///|
pub fn decode_coverage_attributes_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Undefined")
    1 => NameKnown("Unmodified")
    2 => NameKnown("Snow Covered")
    3 => NameKnown("Flooded")
    4 => NameKnown("Ice Covered")
    5 => NameKnown("With Intercepted Water")
    6 => NameKnown("With Intercepted Snow")
    7 => NameKnown("Aggregated")
    255 => NameKnown("Missing")
    _ =>
      if value >= 8 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("coverage_attributes=" + value.to_string())
      }
  }
}

///|
pub fn decode_tile_classification_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Land use classes according to ESA-GLOBCOVER GCV2009")
    2 =>
      NameKnown(
        "Land use classes according to European Commission-Global Land Cover Project GLC2000",
      )
    3 => NameKnown("Land use classes according to ECOCLIMAP")
    4 => NameKnown("Land use classes according to ECOCLIMAP-SG")
    5 =>
      NameKnown(
        "Land use classes according to USGS EROS Global Land Cover Characterization (GLCC) v2.0 BATS Classification",
      )
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 6 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("tile_classification=" + value.to_string())
      }
  }
}

///|
pub fn decode_tile_class_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Evergreen broadleaved forest")
    2 => NameKnown("Deciduous broadleaved closed forest")
    3 => NameKnown("Deciduous broadleaved open forest")
    4 => NameKnown("Evergreen needle-leaf forest")
    5 => NameKnown("Deciduous needle-leaf forest")
    6 => NameKnown("Mixed leaf trees")
    7 => NameKnown("Fresh water flooded trees")
    8 => NameKnown("Saline water flooded trees")
    9 => NameKnown("Mosaic tree/natural vegetation")
    10 => NameKnown("Burnt tree cover")
    11 => NameKnown("Evergreen shrubs closed-open")
    12 => NameKnown("Deciduous shrubs closed-open")
    13 => NameKnown("Herbaceous vegetation closed-open")
    14 => NameKnown("Sparse herbaceous or grass")
    15 => NameKnown("Flooded shrubs or herbaceous")
    16 => NameKnown("Cultivated and managed areas")
    17 => NameKnown("Mosaic crop/tree/natural vegetation")
    18 => NameKnown("Mosaic crop/shrub/grass")
    19 => NameKnown("Bare areas")
    20 => NameKnown("Water")
    21 => NameKnown("Snow and ice")
    22 => NameKnown("Artificial surface")
    23 => NameKnown("Ocean")
    24 => NameKnown("Irrigated croplands")
    25 => NameKnown("Rainfed croplands")
    26 => NameKnown("Mosaic cropland (50-70%) - vegetation (20-50%)")
    27 => NameKnown("Mosaic vegetation (50-70%) - cropland (20-50%)")
    28 => NameKnown("Closed broadleaved evergreen forest")
    29 => NameKnown("Closed needle-leaved evergreen forest")
    30 => NameKnown("Open needle-leaved deciduous forest")
    31 => NameKnown("Mixed broadleaved and needle-leave forest")
    32 => NameKnown("Mosaic shrubland (50-70%) - grassland (20-50%)")
    33 => NameKnown("Mosaic grassland (50-70%) - shrubland (20-50%)")
    34 => NameKnown("Closed to open shrubland")
    35 => NameKnown("Sparse vegetation")
    36 => NameKnown("Closed to open forest regularly flooded")
    37 => NameKnown("Closed forest or shrubland permanently flooded")
    38 => NameKnown("Closed to open grassland regularly flooded")
    39 => NameKnown("Undefined")
    _ =>
      if value == 0 || (value >= 40 && value <= 32767) {
        NameKnown("Reserved")
      } else if value >= 32768 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("tile_class=" + value.to_string())
      }
  }
}

///|
pub fn decode_quality_indicator_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Quality Information Available")
    1 => NameKnown("Failed")
    2 => NameKnown("Passed")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("quality_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_thunderstorm_intensity_index_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No thunderstorm occurrence")
    1 => NameKnown("Weak thunderstorm")
    2 => NameKnown("Moderate thunderstorm")
    3 => NameKnown("Severe thunderstorm")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("thunderstorm_intensity_index=" + value.to_string())
      }
  }
}

///|
pub fn decode_precipitation_intensity_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No precipitation occurrence")
    1 => NameKnown("Light precipitation")
    2 => NameKnown("Moderate precipitation")
    3 => NameKnown("Heavy precipitation")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("precipitation_intensity=" + value.to_string())
      }
  }
}

///|
pub fn decode_method_used_to_derive_data_value_for_local_time_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Nearest forecast or analysis time to specified local time")
    1 => NameKnown("Interpolated to be valid at the specified local time")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "method_used_to_derive_data_value_for_local_time=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_character_of_precipitation_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Showers")
    2 => NameKnown("Intermittent")
    3 => NameKnown("Continuous")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("character_of_precipitation=" + value.to_string())
      }
  }
}

///|
pub fn decode_drainage_direction_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Southwest")
    2 => NameKnown("South")
    3 => NameKnown("Southeast")
    4 => NameKnown("West")
    5 => NameKnown("No Direction")
    6 => NameKnown("East")
    7 => NameKnown("Northwest")
    8 => NameKnown("North")
    9 => NameKnown("Northeast")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 10 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("drainage_direction=" + value.to_string())
      }
  }
}

///|
pub fn decode_wave_direction_and_frequency_formulae_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Undefined Sequence")
    1 => NameKnown("Geometric Sequence")
    2 => NameKnown("Arithmetic Sequence")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "wave_direction_and_frequency_formulae=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_tile_classes_and_groupings_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Reserved")
    1 => NameKnown("Seas and Oceans")
    2 => NameKnown("Inland Water Bodies")
    3 => NameKnown("Bare Areas")
    4 => NameKnown("High Vegetation")
    5 => NameKnown("Low Vegetation")
    6 => NameKnown("Urban")
    1001 => NameKnown("Sea and Oceans")
    1002 => NameKnown("Lakes")
    1003 => NameKnown("Rivers")
    1004 => NameKnown("Bare Land")
    1005 => NameKnown("Bare Rock")
    1006 => NameKnown("Permanent Snow")
    1007 => NameKnown("Boreal Broadleaf Deciduous")
    1008 => NameKnown("Temperate Broadleaf Deciduous")
    1009 => NameKnown("Tropical Broadleaf Deciduous")
    1010 => NameKnown("Temperate Broadleaf Evergreen")
    1011 => NameKnown("Tropical Broadleaf Evergreen")
    1012 => NameKnown("Boreal Needleleaf Evergreen")
    1013 => NameKnown("Temperate Needleleaf Evergreen")
    1014 => NameKnown("Boreal Needleleaf Deciduous")
    1015 => NameKnown("Shrubs")
    1016 => NameKnown("Boreal Grassland")
    1017 => NameKnown("Temperate Grassland")
    1018 => NameKnown("Tropical Grassland")
    1019 => NameKnown("Winter C3 Crops")
    1020 => NameKnown("Summer C3 Crops")
    1021 => NameKnown("C4 Crops")
    1022 => NameKnown("Flooded Trees")
    1023 => NameKnown("Flooded Grassland")
    1024 => NameKnown("LCZ1")
    1025 => NameKnown("LCZ2")
    1026 => NameKnown("LCZ3")
    1027 => NameKnown("LCZ4")
    1028 => NameKnown("LCZ5")
    1029 => NameKnown("LCZ6")
    1030 => NameKnown("LCZ7")
    1031 => NameKnown("LCZ8")
    1032 => NameKnown("LCZ9")
    1033 => NameKnown("LCZ10")
    1034 => NameKnown("Urban Temperate Broadleaf Deciduous")
    1035 => NameKnown("Urban Tropical Broadleaf Deciduous")
    1036 => NameKnown("Urban Temperate Broadleaf Evergreen")
    1037 => NameKnown("Urban Tropical Broadleaf Evergreen")
    1038 => NameKnown("Urban Boreal Needleleaf Evergreen")
    1039 => NameKnown("Urban Temperate Needleleaf Evergreen")
    1040 => NameKnown("Urban Boreal Needleleaf Deciduous")
    1501 => NameKnown("Nature Grouping")
    1502 => NameKnown("Non-Forest Grouping")
    1503 => NameKnown("Forest Grouping")
    1504 => NameKnown("Non-Vegetated Grouping")
    1505 => NameKnown("Trees Grouping")
    1506 => NameKnown("Low Vegetation Grouping")
    1507 => NameKnown("Non-Flooded Low Vegetation Grouping")
    1508 => NameKnown("Crops Grouping")
    1509 => NameKnown("Grassland Grouping")
    1510 => NameKnown("Bare and Rock Grouping")
    1511 => NameKnown("C3 Crops Grouping")
    1512 => NameKnown("Broadleaf Forest Grouping")
    1513 => NameKnown("Needleleaf Forest Grouping")
    1514 => NameKnown("Deciduous Broadleaf Forest Grouping")
    1515 => NameKnown("Temperate Grassland Grouping")
    1516 => NameKnown("Non-Forest (no FLTR) Grouping")
    1517 => NameKnown("Broadleaf Forest (with FLTR) Grouping")
    1518 => NameKnown("Broadleaf Trees Grouping")
    1519 => NameKnown("C3/C4 Grasslands Grouping")
    1520 => NameKnown("Broadleaf Deciduous Trees Grouping")
    1521 => NameKnown("Broadleaf Evergreen Trees Grouping")
    1522 => NameKnown("Needleleaf Evergreen Trees Grouping")
    1523 => NameKnown("LCZ or urban grouping")
    1524 => NameKnown("Inland Water Grouping")
    1525 => NameKnown("Urban Parks and Gardens TEBD Grouping")
    1526 => NameKnown("Urban Parks and Gardens TRBD Grouping")
    1527 => NameKnown("Urban Parks and Gardens TEBE Grouping")
    1528 => NameKnown("Urban Parks and Gardens TRBE Grouping")
    1529 => NameKnown("Urban Parks and Gardens BONE Grouping")
    1530 => NameKnown("Urban Parks and Gardens TENE Grouping")
    1531 => NameKnown("Urban Parks and Gardens BOND Grouping")
    2001 => NameKnown("CRMF")
    2002 => NameKnown("SHGR")
    2003 => NameKnown("EVNE")
    2004 => NameKnown("DENE")
    2005 => NameKnown("DEBR")
    2006 => NameKnown("EVBR")
    2007 => NameKnown("TAGR")
    2008 => NameKnown("DESE")
    2009 => NameKnown("TUND")
    2010 => NameKnown("IRCR")
    2011 => NameKnown("SEDE")
    2012 => NameKnown("ICGL")
    2013 => NameKnown("BOMA")
    2014 => NameKnown("INWA")
    2015 => NameKnown("OCEA")
    2016 => NameKnown("EVSH")
    2017 => NameKnown("DESH")
    2018 => NameKnown("MFWO")
    2019 => NameKnown("INFO")
    2020 => NameKnown("WLMI")
    2021 => NameKnown("BASO")
    2022 => NameKnown("URBA")
    2023 => NameKnown("LORI")
    2024 => NameKnown("HIRI")
    3001 => NameKnown("PFIC")
    3002 => NameKnown("RACR")
    3003 => NameKnown("MCVE")
    3004 => NameKnown("MVCR")
    3005 => NameKnown("COBS")
    3006 => NameKnown("CLBD")
    3007 => NameKnown("OPBD")
    3008 => NameKnown("CLNE")
    3009 => NameKnown("ONDE")
    3010 => NameKnown("COBN")
    3011 => NameKnown("MFSG")
    3012 => NameKnown("MGFS")
    3013 => NameKnown("COSH")
    3014 => NameKnown("COHV")
    3015 => NameKnown("SPVE")
    3016 => NameKnown("COBFF")
    3017 => NameKnown("CLBFF")
    3018 => NameKnown("COVEF")
    3019 => NameKnown("ASAA")
    3020 => NameKnown("BAAR")
    3021 => NameKnown("WABO")
    3022 => NameKnown("PESI")
    3501 =>
      NameKnown(
        "Grouping Using the Dominant Tiles Approach (Dominant Tile Varies per Gridbox)",
      )
    4001 => NameKnown("TBECO")
    4002 => NameKnown("TBDC")
    4003 => NameKnown("TBDO")
    4004 => NameKnown("TNECO")
    4005 => NameKnown("TNDCO")
    4006 => NameKnown("TMLCO")
    4007 => NameKnown("TCOFF")
    4008 => NameKnown("TCOFS")
    4009 => NameKnown("MTVG")
    4010 => NameKnown("TBURN")
    4011 => NameKnown("SCOE")
    4012 => NameKnown("SCOD")
    4013 => NameKnown("HCCO")
    4014 => NameKnown("SHSC")
    4015 => NameKnown("FSHCO")
    4016 => NameKnown("CROP")
    4017 => NameKnown("MCTNV")
    4018 => NameKnown("MCSH")
    4019 => NameKnown("BAARE")
    4020 => NameKnown("WBNA")
    4021 => NameKnown("SINA")
    4022 => NameKnown("URAR")
    65535 => NameKnown("Missing")
    _ =>
      if (value >= 7 && value <= 1000) ||
        (value >= 1041 && value <= 1500) ||
        (value >= 1532 && value <= 2000) ||
        (value >= 2025 && value <= 2500) ||
        (value >= 2503 && value <= 3000) ||
        (value >= 3023 && value <= 3500) ||
        (value >= 3502 && value <= 4000) ||
        (value >= 4023 && value <= 4500) ||
        (value >= 4501 && value <= 5000) ||
        (value >= 5001 && value <= 32767) {
        NameKnown("Reserved")
      } else if value >= 32768 && value <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("tile_classes_and_groupings=" + value.to_string())
      }
  }
}

///|
pub fn decode_hazard_index_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Undefined")
    65535 => NameKnown("Missing")
    _ =>
      if value >= 1 && value <= 65534 {
        NameKnown("Reserved")
      } else {
        NameUnknown("hazard_index=" + value.to_string())
      }
  }
}

///|
pub fn decode_transport_dispersion_model_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("DERMA (Danish Emergency Response Model of the Atmosphere)")
    2 => NameKnown("E-EMEP (Emergency EMEP model)")
    3 => NameKnown("FLEXPART (Particle dispersion model)")
    4 => NameKnown("MLDP (Modele lagrangien de dispersion de particules)")
    5 => NameKnown("MATCH (Multi-scale Atmospheric Transport Model")
    6 =>
      NameKnown(
        "SILAM (System for Integrated modeLling of Atmospheric composition)",
      )
    7 => NameKnown("SNAP (Severe Nuclear Accident Program)")
    8 => NameKnown("WRF-Chem (Weather Research and Forecasting Chemical model)")
    9 => NameKnown("Trajectoire (Trajectory model)")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 10 && value <= 254) {
        NameKnown("Reserved")
      } else {
        NameUnknown("transport_dispersion_model=" + value.to_string())
      }
  }
}

///|
pub fn decode_emission_scenario_origin_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("ARGOS (Accident Reporting and Guiding Operational System)")
    2 =>
      NameKnown(
        "JRODOS (Java version of Real time Online Decision SuppOrt System)",
      )
    3 => NameKnown("Assimilated (scenario retrieved from measurements)")
    4 => NameKnown("Center (scenario by originating center)")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 5 && value <= 254) {
        NameKnown("Reserved")
      } else {
        NameUnknown("emission_scenario_origin=" + value.to_string())
      }
  }
}

///|
pub fn decode_nwp_model_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("AROME (Meso scale NWP, Meteo-France)")
    2 => NameKnown("ARPEGE (Global scale NWP, Meteo-France)")
    3 => NameKnown("GFS (Global forecast system, NCEP)")
    4 =>
      NameKnown(
        "HARMONIE (HIRLAM-ALADIN Research on Mesoscale Operational NWP)",
      )
    5 => NameKnown("HIRLAM (HIgh resolution Limited Area Model)")
    6 => NameKnown("IFS (Integrated Forecast System)")
    7 => NameKnown("GEM GDPS (Canadian Global Deterministic Prediction System)")
    8 =>
      NameKnown("GEM RDPS (Canadian Regional Deterministic Prediction System)")
    9 =>
      NameKnown(
        "GEM HRDPS (Canadian High Resolution Deterministic Prediction System)",
      )
    10 => NameKnown("WRF (Weather Research and Forecasting)")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 11 && value <= 254) {
        NameKnown("Reserved")
      } else {
        NameUnknown("nwp_model=" + value.to_string())
      }
  }
}

