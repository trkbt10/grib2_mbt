///|
/// Code-table lookups for Section 4 weather phenomena: precipitation type,
/// precipitable-water category, cloud type, thunderstorm coverage, aerosol
/// presence, volcanic ash, icing, turbulence, planetary boundary layer
/// regime, contrails, land use, soil type, snow coverage, cloud mask, pixel
/// scene type, cloud-top quality, horizontal-dimension processed,
/// missing-data treatment, categorical result/outlook, and fire detection.
pub fn decode_precipitation_type_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Rain")
    2 => NameKnown("Thunderstorm")
    3 => NameKnown("Freezing Rain")
    4 => NameKnown("Mixed/Ice")
    5 => NameKnown("Snow")
    6 => NameKnown("Wet Snow")
    7 => NameKnown("Mixture of Rain and Snow")
    8 => NameKnown("Ice Pellets")
    9 => NameKnown("Graupel")
    10 => NameKnown("Hail")
    11 => NameKnown("Drizzle")
    12 => NameKnown("Freezing Drizzle")
    13 => NameKnown("Hail (< 5 mm)")
    14 => NameKnown("Hail (≥ 5 mm)")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 15 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("precipitation_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_precipitable_water_category_name(value : Int) -> Grib2NameLookup {
  match value {
    255 => NameKnown("Missing")
    _ =>
      if value >= 0 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("precipitable_water_category=" + value.to_string())
      }
  }
}

///|
pub fn decode_cloud_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Clear")
    1 => NameKnown("Cumulonimbus")
    2 => NameKnown("Stratus")
    3 => NameKnown("Stratocumulus")
    4 => NameKnown("Cumulus")
    5 => NameKnown("Altostratus")
    6 => NameKnown("Nimbostratus")
    7 => NameKnown("Altocumulus")
    8 => NameKnown("Cirrostratus")
    9 => NameKnown("Cirrorcumulus")
    10 => NameKnown("Cirrus")
    11 => NameKnown("Cumulonimbus - ground-based fog beneath the lowest layer")
    12 => NameKnown("Stratus - ground-based fog beneath the lowest layer")
    13 => NameKnown("Stratocumulus - ground-based fog beneath the lowest layer")
    14 => NameKnown("Cumulus - ground-based fog beneath the lowest layer")
    15 => NameKnown("Altostratus - ground-based fog beneath the lowest layer")
    16 => NameKnown("Nimbostratus - ground-based fog beneath the lowest layer")
    17 => NameKnown("Altocumulus - ground-based fog beneath the lowest layer")
    18 => NameKnown("Cirrostratus - ground-based fog beneath the lowest layer")
    19 => NameKnown("Cirrorcumulus - ground-based fog beneath the lowest layer")
    20 => NameKnown("Cirrus - ground-based fog beneath the lowest layer")
    191 => NameKnown("Unknown")
    255 => NameKnown("Missing")
    _ =>
      if value >= 21 && value <= 190 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("cloud_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_thunderstorm_coverage_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Isolated (1-2%)")
    2 => NameKnown("Few (3-5%)")
    3 => NameKnown("Scattered (16-45%)")
    4 => NameKnown("Numerous (>45%)")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("thunderstorm_coverage=" + value.to_string())
      }
  }
}

///|
pub fn decode_presence_of_aerosol_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Aerosol not present")
    1 => NameKnown("Aerosol present")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("presence_of_aerosol=" + value.to_string())
      }
  }
}

///|
pub fn decode_volcanic_ash_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Not Present")
    1 => NameKnown("Present")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("volcanic_ash=" + value.to_string())
      }
  }
}

///|
pub fn decode_icing_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Light")
    2 => NameKnown("Moderate")
    3 => NameKnown("Severe")
    4 => NameKnown("Trace")
    5 => NameKnown("Heavy")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("icing=" + value.to_string())
      }
  }
}

///|
pub fn decode_turbulence_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Light")
    2 => NameKnown("Moderate")
    3 => NameKnown("Severe")
    4 => NameKnown("Extreme")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("turbulence=" + value.to_string())
      }
  }
}

///|
pub fn decode_planetary_boundary_layer_regime_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Stable")
    2 => NameKnown("Mechanically-Driven Turbulence")
    3 => NameKnown("Forced Convection")
    4 => NameKnown("Free Convection")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 5 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("planetary_boundary_layer_regime=" + value.to_string())
      }
  }
}

///|
pub fn decode_contrail_intensity_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Contrail Not Present")
    1 => NameKnown("Contrail Present")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("contrail_intensity=" + value.to_string())
      }
  }
}

///|
pub fn decode_contrail_engine_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Low Bypass")
    1 => NameKnown("High Bypass")
    2 => NameKnown("Non-Bypass")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("contrail_engine_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_land_use_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Urban Land")
    2 => NameKnown("Agricultural")
    3 => NameKnown("Range Land")
    4 => NameKnown("Deciduous Forest")
    5 => NameKnown("Coniferous Forest")
    6 => NameKnown("Forest/Wetland")
    7 => NameKnown("Water")
    8 => NameKnown("Wetlands")
    9 => NameKnown("Desert")
    10 => NameKnown("Tundra")
    11 => NameKnown("Ice")
    12 => NameKnown("Tropical Forest")
    13 => NameKnown("Savannah")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 14 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("land_use=" + value.to_string())
      }
  }
}

///|
pub fn decode_soil_type_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Sand")
    2 => NameKnown("Loamy Sand")
    3 => NameKnown("Sandy Loam")
    4 => NameKnown("Silt Loam")
    5 => NameKnown("Organic (redefined)")
    6 => NameKnown("Sandy Clay Loam")
    7 => NameKnown("Silt Clay Loam")
    8 => NameKnown("Clay Loam")
    9 => NameKnown("Sandy Clay")
    10 => NameKnown("Silty Clay")
    11 => NameKnown("Clay")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 12 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("soil_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_environmental_factor_qualifier_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Worst")
    1 => NameKnown("Very Poor")
    2 => NameKnown("Poor")
    3 => NameKnown("Average")
    4 => NameKnown("Good")
    5 => NameKnown("Excellent")
    191 => NameKnown("Unknown")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 190 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("environmental_factor_qualifier=" + value.to_string())
      }
  }
}

///|
pub fn decode_remotely_sensed_snow_coverage_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    50 => NameKnown("No-Snow/No-Cloud")
    100 => NameKnown("Clouds")
    250 => NameKnown("Snow")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 0 && value <= 49) ||
        (value >= 51 && value <= 99) ||
        (value >= 101 && value <= 249) {
        NameKnown("Reserved")
      } else if value >= 251 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("remotely_sensed_snow_coverage=" + value.to_string())
      }
  }
}

///|
pub fn decode_elevation_of_snow_covered_terrain_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    254 => NameKnown("Clouds")
    255 => NameKnown("Missing")
    _ =>
      if value >= 0 && value <= 90 {
        NameKnown("Elevation in increments of 100 m")
      } else if value >= 91 && value <= 253 {
        NameKnown("Reserved")
      } else {
        NameUnknown("elevation_of_snow_covered_terrain=" + value.to_string())
      }
  }
}

///|
pub fn decode_cloud_mask_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Clear over water")
    1 => NameKnown("Clear over land")
    2 => NameKnown("Cloud")
    3 => NameKnown("No data")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("cloud_mask_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_pixel_scene_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Scene Identified")
    1 => NameKnown("Green Needle-Leafed Forest")
    2 => NameKnown("Green Broad-Leafed Forest")
    3 => NameKnown("Deciduous Needle-Leafed Forest")
    4 => NameKnown("Deciduous Broad-Leafed Forest")
    5 => NameKnown("Deciduous Mixed Forest")
    6 => NameKnown("Closed Shrub-Land")
    7 => NameKnown("Open Shrub-Land")
    8 => NameKnown("Woody Savannah")
    9 => NameKnown("Savannah")
    10 => NameKnown("Grassland")
    11 => NameKnown("Permanent Wetland")
    12 => NameKnown("Cropland")
    13 => NameKnown("Urban")
    14 => NameKnown("Vegetation / Crops")
    15 => NameKnown("Permanent Snow / Ice")
    16 => NameKnown("Barren Desert")
    17 => NameKnown("Water Bodies")
    18 => NameKnown("Tundra")
    19 => NameKnown("Warm Liquid Water Cloud")
    20 => NameKnown("Supercooled Liquid Water Cloud")
    21 => NameKnown("Mixed Phase Cloud")
    22 => NameKnown("Optically Thin Ice Cloud")
    23 => NameKnown("Optically Thick Ice Cloud")
    24 => NameKnown("Multilayered Cloud")
    97 => NameKnown("Snow / Ice on Land")
    98 => NameKnown("Snow / Ice on Water")
    99 => NameKnown("Sun-Glint")
    100 => NameKnown("General Cloud")
    101 => NameKnown("Low Cloud / Fog / Stratus")
    102 => NameKnown("Low Cloud / Stratocumulus")
    103 => NameKnown("Low Cloud / Unknown Type")
    104 => NameKnown("Medium Cloud / Nimbostratus")
    105 => NameKnown("Medium Cloud / Altostratus")
    106 => NameKnown("Medium Cloud / Unknown Type")
    107 => NameKnown("High Cloud / Cumulus")
    108 => NameKnown("High Cloud / Cirrus")
    109 => NameKnown("High Cloud / Unknown Type")
    110 => NameKnown("Unknown Cloud Type")
    111 => NameKnown("Single Layer Water Cloud")
    112 => NameKnown("Single Layer Ice Cloud")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 25 && value <= 96) || (value >= 113 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("pixel_scene_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_cloud_top_height_quality_indicator_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Nominal Cloud Top Height Quality")
    1 => NameKnown("Fog In Segment")
    2 => NameKnown("Poor Quality Height Estimation")
    3 => NameKnown("Fog In Segment and Poor Quality Height Estimation")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("cloud_top_height_quality_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_horizontal_dimension_processed_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Latitude")
    1 => NameKnown("Longitude")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("horizontal_dimension_processed=" + value.to_string())
      }
  }
}

///|
pub fn decode_treatment_of_missing_data_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Not Included")
    1 => NameKnown("Extrapolated")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("treatment_of_missing_data=" + value.to_string())
      }
  }
}

///|
pub fn decode_categorical_result_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No")
    1 => NameKnown("Yes")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("categorical_result=" + value.to_string())
      }
  }
}

///|
pub fn decode_fire_detection_indicator_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Fire Detected")
    1 => NameKnown("Possible Fire Detected")
    2 => NameKnown("Probable Fire Detected")
    3 => NameKnown("Missing")
    255 => NameKnown("Missing")
    _ =>
      if value >= 4 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("fire_detection_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_categorical_outlook_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Risk Area")
    2 => NameKnown("General Thunderstorm Risk Area")
    4 => NameKnown("Slight Risk Area")
    6 => NameKnown("Moderate Risk Area")
    8 => NameKnown("High Risk Area")
    11 => NameKnown("Dry Thunderstorm (Dry Lightning) Risk Area")
    14 => NameKnown("Critical Risk Area")
    18 => NameKnown("Extreamly Critical Risk Area")
    255 => NameKnown("Missing")
    _ =>
      if value == 1 ||
        value == 3 ||
        value == 5 ||
        value == 7 ||
        (value >= 9 && value <= 10) ||
        (value >= 12 && value <= 13) ||
        (value >= 15 && value <= 17) ||
        (value >= 19 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("categorical_outlook=" + value.to_string())
      }
  }
}

///|
pub fn decode_weather_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Cloud development not observed or not observable")
    1 => NameKnown("Clouds generally dissolving or becoming less developed")
    2 => NameKnown("State of sky on the whole unchanged")
    3 => NameKnown("Clouds generally forming or developing")
    4 =>
      NameKnown(
        "Visibility reduced by smoke, e.g. veldt or forest fires, industrial smoke or volcanic ashes",
      )
    5 => NameKnown("Haze")
    6 =>
      NameKnown(
        "Widespread dust in suspension in the air, not raised by wind at or near the station at the time of observation",
      )
    7 =>
      NameKnown(
        "Dust or sand raised by wind at or near the station at the time of observation, but no well-developed dust whirl(s) or sand whirl(s), and no duststorm or sandstorm seen; or, in the case of sea stations and coastal stations, blowing spray at the station",
      )
    8 =>
      NameKnown(
        "Well-developed dust whirl(s) or sand whirl(s) seen at or near the station during the preceding hour or at the same time of observation, but no duststorm or sandstorm",
      )
    9 =>
      NameKnown(
        "Duststorm or sandstorm within sight at the time of observation, or at the station during the preceding hour",
      )
    10 => NameKnown("Mist")
    11 => NameKnown("Patches")
    12 => NameKnown("More or less continuous")
    13 => NameKnown("Lightning visible, no thunder heard")
    14 =>
      NameKnown(
        "Precipitation within sight, not reaching the ground or the surface of the sea",
      )
    15 =>
      NameKnown(
        "Precipitation within sight, reaching the ground or the surface of the sea, but distant, i.e. estimated to be more than 5 km from the station",
      )
    16 =>
      NameKnown(
        "Precipitation within sight, reaching the ground or the surface of the sea, near to, but not at the station",
      )
    17 =>
      NameKnown("Thunderstorm, but no precipitation at the time of observation")
    18 => NameKnown("Squalls")
    19 => NameKnown("Funnel cloud(s)")
    20 => NameKnown("Drizzle (not freezing) or snow grains")
    21 => NameKnown("Rain (not freezing)")
    22 => NameKnown("Snow")
    23 => NameKnown("Rain and snow or ice pellets")
    24 => NameKnown("Freezing drizzle or freezing rain")
    25 => NameKnown("Shower(s) of rain")
    26 => NameKnown("Shower(s) of snow, or of rain and snow")
    27 => NameKnown("Shower(s) of hail*, or of rain and hail*")
    28 => NameKnown("Fog or ice fog")
    29 => NameKnown("Thunderstorm (with or without precipitation)")
    30 => NameKnown("Slight or moderate duststorm or sandstorm")
    31 => NameKnown("Slight or moderate duststorm or sandstorm")
    32 => NameKnown("Slight or moderate duststorm or sandstorm")
    33 => NameKnown("Severe duststorm or sandstorm")
    34 => NameKnown("Severe duststorm or sandstorm")
    35 => NameKnown("Severe duststorm or sandstorm")
    36 => NameKnown("Slight or moderate drifting snow")
    37 => NameKnown("Heavy drifting snow")
    38 => NameKnown("Slight or moderate blowing snow")
    39 => NameKnown("Heavy blowing snow")
    40 =>
      NameKnown(
        "Fog or ice fog at a distance at the time of observation, but not at the station during the preceding hour, the fog or ice fog extending to a level above that of the observer",
      )
    41 => NameKnown("Fog or ice fog in patches")
    42 => NameKnown("Fog or ice fog, sky visible")
    43 => NameKnown("Fog or ice fog, sky invisible")
    44 => NameKnown("Fog or ice fog, sky visible")
    45 => NameKnown("Fog or ice fog, sky invisible")
    46 => NameKnown("Fog or ice fog, sky visible")
    47 => NameKnown("Fog or ice fog, sky invisible")
    48 => NameKnown("Fog, depositing rime, sky visible")
    49 => NameKnown("Fog, depositing rime, sky invisible")
    50 => NameKnown("Drizzle, not freezing, intermittent")
    51 => NameKnown("Drizzle, not freezing, continuous")
    52 => NameKnown("Drizzle, not freezing, intermittent")
    53 => NameKnown("Drizzle, not freezing, continuous")
    54 => NameKnown("Drizzle, not freezing, intermittent")
    55 => NameKnown("Drizzle, not freezing, continuous")
    56 => NameKnown("Drizzle, freezing, slight")
    57 => NameKnown("Drizzle, freezing, moderate or heavy (dense)")
    58 => NameKnown("Drizzle and rain, slight")
    59 => NameKnown("Drizzle and rain, moderate or heavy")
    60 => NameKnown("Rain, not freezing, intermittent")
    61 => NameKnown("Rain, not freezing, continuous")
    62 => NameKnown("Rain, not freezing, intermittent")
    63 => NameKnown("Rain, not freezing, continuous")
    64 => NameKnown("Rain, not freezing, intermittent")
    65 => NameKnown("Rain, not freezing, continuous")
    66 => NameKnown("Rain, freezing, slight")
    67 => NameKnown("Rain, freezing, moderate or heavy")
    68 => NameKnown("Rain or drizzle and snow, slight")
    69 => NameKnown("Rain or drizzle and snow, moderate or heavy")
    70 => NameKnown("Intermittent fall of snowflakes")
    71 => NameKnown("Continuous fall of snowflakes")
    72 => NameKnown("Intermittent fall of snowflakes")
    73 => NameKnown("Continuous fall of snowflakes")
    74 => NameKnown("Intermittent fall of snowflakes")
    75 => NameKnown("Continuous fall of snowflakes")
    76 => NameKnown("Diamond dust (with or without fog)")
    77 => NameKnown("Snow grains (with or without fog)")
    78 => NameKnown("Isolated star-like snow crystals (with or without fog)")
    79 => NameKnown("Ice pellets")
    80 => NameKnown("Rain shower(s), slight")
    81 => NameKnown("Rain shower(s), moderate or heavy")
    82 => NameKnown("Rain shower(s), violent")
    83 => NameKnown("Shower(s) of rain and snow mixed, slight")
    84 => NameKnown("Shower(s) of rain and snow mixed, moderate or heavy")
    85 => NameKnown("Snow shower(s), slight")
    86 => NameKnown("Snow shower(s), moderate or heavy")
    87 =>
      NameKnown(
        "Shower(s) of snow pellets or small hail, with or without rain or rain and snow mixed",
      )
    88 =>
      NameKnown(
        "Shower(s) of snow pellets or small hail, with or without rain or rain and snow mixed",
      )
    89 =>
      NameKnown(
        "Shower(s) of hail, with or without rain or rain and snow mixed, not associated with thunder",
      )
    90 =>
      NameKnown(
        "Shower(s) of hail, with or without rain or rain and snow mixed, not associated with thunder",
      )
    91 => NameKnown("Slight rain at time of observation")
    92 => NameKnown("Moderate or heavy rain at time of observation")
    93 =>
      NameKnown(
        "Slight snow, or rain and snow mixed or hail* at time of observation",
      )
    94 =>
      NameKnown(
        "Moderate or heavy snow, or rain and snow mixed or hail* at time of observation",
      )
    95 =>
      NameKnown(
        "Thunderstorm, slight or moderate, without hail*, but with rain and/or snow at time of observation",
      )
    96 =>
      NameKnown(
        "Thunderstorm, slight or moderate, with hail* at time of observation",
      )
    97 =>
      NameKnown(
        "Thunderstorm, heavy, without hail*, but with rain and/or snow at time of observation",
      )
    98 =>
      NameKnown(
        "Thunderstorm combined with duststorm or sandstorm at time of observation",
      )
    99 => NameKnown("Thunderstorm, heavy, with hail* at time of observation")
    100 => NameKnown("No significant weather observed")
    101 =>
      NameKnown(
        "Clouds generally dissolving or becoming less developed during the past hour",
      )
    102 => NameKnown("State of sky on the whole unchanged during the past hour")
    103 =>
      NameKnown("Clouds generally forming or developing during the past hour")
    104 =>
      NameKnown(
        "Haze or smoke, or dust in suspension in the air, visibility equal to, or greater than, 1 km",
      )
    105 =>
      NameKnown(
        "Haze or smoke, or dust in suspension in the air, visibility less than 1 km",
      )
    110 => NameKnown("Mist")
    111 => NameKnown("Diamond dust")
    112 => NameKnown("Distant lightning")
    118 => NameKnown("Squalls")
    120 => NameKnown("Fog")
    121 => NameKnown("PRECIPITATION")
    122 => NameKnown("Drizzle (not freezing) or snow grains")
    123 => NameKnown("Rain (not freezing)")
    124 => NameKnown("Snow")
    125 => NameKnown("Freezing drizzle or freezing rain")
    126 => NameKnown("Thunderstorm (with or without precipitation)")
    127 => NameKnown("BLOWING OR DRIFTING SNOW OR SAND")
    128 =>
      NameKnown(
        "Blowing or drifting snow or sand, visibility equal to, or greater than, 1 km",
      )
    129 =>
      NameKnown("Blowing or drifting snow or sand, visibility less than 1 km")
    130 => NameKnown("FOG")
    131 => NameKnown("Fog or ice fog in patches")
    132 => NameKnown("Fog or ice fog, has become thinner during the past hour")
    133 =>
      NameKnown("Fog or ice fog, no appreciable change during the past hour")
    134 =>
      NameKnown(
        "Fog or ice fog, has begun or become thicker during the past hour",
      )
    135 => NameKnown("Fog, depositing rime")
    140 => NameKnown("PRECIPITATION")
    141 => NameKnown("Precipitation, slight or moderate")
    142 => NameKnown("Precipitation, heavy")
    143 => NameKnown("Liquid precipitation, slight or moderate")
    144 => NameKnown("Liquid precipitation, heavy")
    145 => NameKnown("Solid precipitation, slight or moderate")
    146 => NameKnown("Solid precipitation, heavy")
    147 => NameKnown("Freezing precipitation, slight or moderate")
    148 => NameKnown("Freezing precipitation, heavy")
    150 => NameKnown("DRIZZLE")
    151 => NameKnown("Drizzle, not freezing, slight")
    152 => NameKnown("Drizzle, not freezing, moderate")
    153 => NameKnown("Drizzle, not freezing, heavy")
    154 => NameKnown("Drizzle, freezing, slight")
    155 => NameKnown("Drizzle, freezing, moderate")
    156 => NameKnown("Drizzle, freezing, heavy")
    157 => NameKnown("Drizzle and rain, slight")
    158 => NameKnown("Drizzle and rain, moderate or heavy")
    160 => NameKnown("RAIN")
    161 => NameKnown("Rain, not freezing, slight")
    162 => NameKnown("Rain, not freezing, moderate")
    163 => NameKnown("Rain, not freezing, heavy")
    164 => NameKnown("Rain, freezing, slight")
    165 => NameKnown("Rain, freezing, moderate")
    166 => NameKnown("Rain, freezing, heavy")
    167 => NameKnown("Rain (or drizzle) and snow, slight")
    168 => NameKnown("Rain (or drizzle) and snow, moderate or heavy")
    170 => NameKnown("SNOW")
    171 => NameKnown("Snow, slight")
    172 => NameKnown("Snow, moderate")
    173 => NameKnown("Snow, heavy")
    174 => NameKnown("Ice pellets, slight")
    175 => NameKnown("Ice pellets, moderate")
    176 => NameKnown("Ice pellets, heavy")
    177 => NameKnown("Snow grains")
    178 => NameKnown("Ice crystals")
    180 => NameKnown("SHOWER(S) OR INTERMITTENT PRECIPITATION")
    181 => NameKnown("Rain shower(s) or intermittent rain, slight")
    182 => NameKnown("Rain shower(s) or intermittent rain, moderate")
    183 => NameKnown("Rain shower(s) or intermittent rain, heavy")
    184 => NameKnown("Rain shower(s) or intermittent rain, violent")
    185 => NameKnown("Snow shower(s) or intermittent snow, slight")
    186 => NameKnown("Snow shower(s) or intermittent snow, moderate")
    187 => NameKnown("Snow shower(s) or intermittent snow, heavy")
    189 => NameKnown("Hail")
    190 => NameKnown("THUNDERSTORM")
    191 => NameKnown("Thunderstorm, slight or moderate, with no precipitation")
    192 =>
      NameKnown(
        "Thunderstorm, slight or moderate, with rain showers and/or snow showers",
      )
    193 => NameKnown("Thunderstorm, slight or moderate, with hail")
    194 => NameKnown("Thunderstorm, heavy, with no precipitation")
    195 =>
      NameKnown("Thunderstorm, heavy, with rain showers and/or snow showers")
    196 => NameKnown("Thunderstorm, heavy, with hail")
    199 => NameKnown("Tornado")
    204 => NameKnown("Volcanic ash suspended in the air aloft")
    205 => NameKnown("Not used")
    206 => NameKnown("Thick dust haze, visibility less than 1 km")
    207 => NameKnown("Blowing spray at the station")
    208 => NameKnown("Drifting dust (sand)")
    209 => NameKnown("Wall of dust or sand in distance (like haboob)")
    210 => NameKnown("Snow haze")
    211 => NameKnown("Whiteout")
    212 => NameKnown("Not used")
    213 => NameKnown("Lightning, cloud to surface")
    217 => NameKnown("Dry thunderstorm")
    218 => NameKnown("Not used")
    219 =>
      NameKnown(
        "Tornado cloud (destructive) at or within sight of the station during preceding hour or at the time of observation",
      )
    220 => NameKnown("Deposition of volcanic ash")
    221 => NameKnown("Deposition of dust or sand")
    222 => NameKnown("Deposition of dew")
    223 => NameKnown("Deposition of wet snow")
    224 => NameKnown("Deposition of soft rime")
    225 => NameKnown("Deposition of hard rime")
    226 => NameKnown("Deposition of hoar frost")
    227 => NameKnown("Deposition of glaze")
    228 => NameKnown("Deposition of ice crust (ice slick)")
    229 => NameKnown("Not used")
    230 => NameKnown("Duststorm or sandstorm with temperature below 0 °C")
    239 =>
      NameKnown(
        "Blowing snow, impossible to determine whether snow is falling or not",
      )
    240 => NameKnown("Not used")
    241 => NameKnown("Fog on sea")
    242 => NameKnown("Fog in valleys")
    243 => NameKnown("Arctic or Antarctic sea smoke")
    244 => NameKnown("Steam fog (sea, lake or river)")
    245 => NameKnown("Steam log (land)")
    246 => NameKnown("Fog over ice or snow cover")
    247 => NameKnown("Dense fog, visibility 60-90 m")
    248 => NameKnown("Dense fog, visibility 30-60 m")
    249 => NameKnown("Dense fog, visibility less than 30 m")
    250 => NameKnown("Drizzle, rate of fall - less than 0.10 mm h-1")
    251 => NameKnown("Drizzle, rate of fall - 0.10-0.19 mm h-1")
    252 => NameKnown("Drizzle, rate of fall - 0.20-0.39 mm h-1")
    253 => NameKnown("Drizzle, rate of fall - 0.40-0.79 mm h-1")
    254 => NameKnown("Drizzle, rate of fall - 0.80-1.59 mm h-1")
    255 => NameKnown("Drizzle, rate of fall - 1.60-3.19 mm h-1")
    256 => NameKnown("Drizzle, rate of fall - 3.20-6.39 mm h-1")
    257 => NameKnown("Drizzle, rate of fall - 6.4 mm h-1 or more")
    258 => NameKnown("Not used")
    259 => NameKnown("Drizzle and snow")
    260 => NameKnown("Rain, rate of fall - less than 1.0 mm h-1")
    261 => NameKnown("Rain, rate of fall - 1.0-1.9 mm h-1")
    262 => NameKnown("Rain, rate of fall - 2.0-3.9 mm h-1")
    263 => NameKnown("Rain, rate of fall - 4.0-7.9 mm h-1")
    264 => NameKnown("Rain, rate of fall - 8.0-15.9 mm h-1")
    265 => NameKnown("Rain, rate of fall - 16.0-31.9 mm h-1")
    266 => NameKnown("Rain, rate of fall - 32.0-63.9 mm h-1")
    267 => NameKnown("Rain, rate of fall - 64.0 mm h-1 or more")
    270 => NameKnown("Snow, rate of fall - less than 1.0 cm h-1")
    271 => NameKnown("Snow, rate of fall - 1.0-1.9 cm h-1")
    272 => NameKnown("Snow, rate of fall - 2.0-3.9 cm h-1")
    273 => NameKnown("Snow, rate of fall - 4.0-7.9 cm h-1")
    274 => NameKnown("Snow, rate of fall - 8.0-15.9 cm h-1")
    275 => NameKnown("Snow, rate of fall - 16.0-31.9 cm h-1")
    276 => NameKnown("Snow, rate of fall - 32.0-63.9 cm h-1")
    277 => NameKnown("Snow, rate of fall - 64.0 cm h-1 or more")
    278 => NameKnown("Snow or ice crystal precipitation from a clear sky")
    279 => NameKnown("Wet snow, freezing on contact")
    280 => NameKnown("Precipitation of rain")
    281 => NameKnown("Precipitation of rain, freezing")
    282 => NameKnown("Precipitation of rain and snow mixed")
    283 => NameKnown("Precipitation of snow")
    284 => NameKnown("Precipitation of snow pellets or small hall")
    285 => NameKnown("Precipitation of snow pellets or small hail, with rain")
    286 =>
      NameKnown(
        "Precipitation of snow pellets or small hail, with rain and snow mixed",
      )
    287 => NameKnown("Precipitation of snow pellets or small hail, with snow")
    288 => NameKnown("Precipitation of hail")
    289 => NameKnown("Precipitation of hail, with rain")
    290 => NameKnown("Precipitation of hall, with rain and snow mixed")
    291 => NameKnown("Precipitation of hail, with snow")
    292 => NameKnown("Shower(s) or thunderstorm over sea")
    293 => NameKnown("Shower(s) or thunderstorm over mountains")
    508 =>
      NameKnown(
        "No significant phenomenon to report, present and past weather omitted",
      )
    509 =>
      NameKnown(
        "No observation, data not available, present and past weather omitted",
      )
    510 => NameKnown("Present and past weather missing, but expected")
    511 => NameKnown("Missing value")
    _ =>
      if value >= 0 && value <= 511 {
        NameKnown("Reserved")
      } else {
        NameUnknown("weather=" + value.to_string())
      }
  }
}

///|
pub fn decode_icing_scenario_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("General")
    2 => NameKnown("Convective")
    3 => NameKnown("Stratiform")
    4 => NameKnown("Freezing")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("icing_scenario=" + value.to_string())
      }
  }
}

///|
pub fn decode_icing_severity_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("None")
    1 => NameKnown("Trace")
    2 => NameKnown("Light")
    3 => NameKnown("Moderate")
    4 => NameKnown("Severe")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("icing_severity=" + value.to_string())
      }
  }
}

///|
