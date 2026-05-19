///|
/// Dispatchers that translate the (discipline, category) and
/// (discipline, category, parameter) tuples into short names. Each helper
/// fans out to a discipline-specific lookup file (see
/// `parameter_names_disc*.mbt`).
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

