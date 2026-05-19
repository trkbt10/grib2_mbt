///|
/// Code-table lookups bound to Section 4 (Product Definition) PDT shape and
/// forecast/ensemble metadata: PDT recognition, generating-process type,
/// time-range unit, fixed-surface type (Code Table 4.5), ensemble forecast,
/// derived forecast, clustering method, probability type.
pub fn decode_product_definition_template_number_name(
  template_number : Int,
) -> Grib2NameLookup {
  if template_number == 65535 {
    return NameKnown("Missing")
  }
  if template_number >= 32768 && template_number <= 65534 {
    return NameKnown("Reserved for Local Use")
  }
  if template_number >= 0 && template_number <= 32767 {
    match decode_section4_template(template_number) {
      Section4TemplateKnown(id) => NameKnown("Template 4." + id.to_string())
      Section4TemplateUnknown(_) => NameKnown("Reserved")
    }
  } else {
    NameUnknown("product_definition_template=" + template_number.to_string())
  }
}

///|
pub fn decode_type_of_generating_process_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Analysis")
    1 => NameKnown("Initialization")
    2 => NameKnown("Forecast")
    3 => NameKnown("Bias Corrected Forecast")
    4 => NameKnown("Ensemble Forecast")
    5 => NameKnown("Probability Forecast")
    6 => NameKnown("Forecast Error")
    7 => NameKnown("Analysis Error")
    8 => NameKnown("Observation")
    9 => NameKnown("Climatological")
    10 => NameKnown("Probability-Weighted Forecast")
    11 => NameKnown("Bias-Corrected Ensemble Forecast")
    12 => NameKnown("Post-Processed Analysis")
    13 => NameKnown("Post-Processed Forecast")
    14 => NameKnown("Nowcast")
    15 => NameKnown("Hindcast")
    16 => NameKnown("Physical Retrieval")
    17 => NameKnown("Regression Analysis")
    18 => NameKnown("Difference Between Two Forecasts")
    19 => NameKnown("First Guess")
    20 => NameKnown("Analysis Increment")
    21 => NameKnown("Initialization Increment for Analysis")
    22 => NameKnown("Blended Forecast")
    23 => NameKnown("Anomaly")
    192 => NameKnown("Forecast Confidence Indicator")
    193 => NameKnown("Probability-Matched Mean")
    194 => NameKnown("Neighborhood Probability")
    195 => NameKnown("Bias-Corrected and Downscaled Ensemble Forecast")
    196 => NameKnown("Perturbed Analysis for Ensemble Initialization")
    197 => NameKnown("Ensemble Agreement Scale Probability")
    198 => NameKnown("Post-Processed Deterministic-Expert-Weighted Forecast")
    199 => NameKnown("Ensemble Forecast Based on Counting")
    200 => NameKnown("Local Probability-Matched Mean")
    255 => NameKnown("Missing")
    _ =>
      if value >= 24 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 201 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_generating_process=" + value.to_string())
      }
  }
}

///|
pub fn decode_indicator_of_unit_of_time_range_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Minute")
    1 => NameKnown("Hour")
    2 => NameKnown("Day")
    3 => NameKnown("Month")
    4 => NameKnown("Year")
    5 => NameKnown("Decade (10 Years)")
    6 => NameKnown("Normal (30 Years)")
    7 => NameKnown("Century (100 Years)")
    10 => NameKnown("3 Hours")
    11 => NameKnown("6 Hours")
    12 => NameKnown("12 Hours")
    13 => NameKnown("Second")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 8 && value <= 9) || (value >= 14 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("indicator_of_unit_of_time_range=" + value.to_string())
      }
  }
}

///|
pub fn decode_fixed_surface_type_name(value : Int) -> Grib2NameLookup {
  match value {
    1 => NameKnown("Ground or Water Surface")
    2 => NameKnown("Cloud Base Level")
    3 => NameKnown("Level of Cloud Tops")
    4 => NameKnown("Level of 0 C Isotherm")
    5 => NameKnown("Level of Adiabatic Condensation Lifted from the Surface")
    6 => NameKnown("Maximum Wind Level")
    7 => NameKnown("Tropopause")
    8 => NameKnown("Nominal Top of the Atmosphere")
    9 => NameKnown("Sea Bottom")
    10 => NameKnown("Entire Atmosphere")
    11 => NameKnown("Cumulonimbus Base (CB)")
    12 => NameKnown("Cumulonimbus Top (CT)")
    13 =>
      NameKnown(
        "Lowest level where vertically integrated cloud cover exceeds the specified percentage",
      )
    14 => NameKnown("Level of free convection (LFC)")
    15 => NameKnown("Convection condensation level (CCL)")
    16 => NameKnown("Level of neutral buoyancy or equilibrium (LNB)")
    17 => NameKnown("Departure level of the most unstable parcel of air (MUDL)")
    18 =>
      NameKnown(
        "Departure level of a mixed layer parcel of air with specified layer depth",
      )
    19 =>
      NameKnown(
        "Lowest level where cloud cover exceeds the specified percentage",
      )
    20 => NameKnown("Isothermal Level")
    21 =>
      NameKnown("Lowest level where mass density exceeds the specified value")
    22 =>
      NameKnown("Highest level where mass density exceeds the specified value")
    23 =>
      NameKnown(
        "Lowest level where air concentration exceeds the specified value",
      )
    24 =>
      NameKnown(
        "Highest level where air concentration exceeds the specified value",
      )
    25 =>
      NameKnown(
        "Highest level where radar reflectivity exceeds the specified value",
      )
    26 => NameKnown("Convective cloud layer base")
    27 => NameKnown("Convective cloud layer top")
    30 => NameKnown("Specified radius from the centre of the Sun")
    31 => NameKnown("Solar photosphere")
    32 => NameKnown("Ionospheric D-region level")
    33 => NameKnown("Ionospheric E-region level")
    34 => NameKnown("Ionospheric F1-region level")
    35 => NameKnown("Ionospheric F2-region level")
    36 => NameKnown("Stratopause")
    100 => NameKnown("Isobaric Surface")
    101 => NameKnown("Mean Sea Level")
    102 => NameKnown("Specific Altitude Above Mean Sea Level")
    103 => NameKnown("Specified Height Level Above Ground")
    104 => NameKnown("Sigma Level")
    105 => NameKnown("Hybrid Level")
    106 => NameKnown("Depth Below Land Surface")
    107 => NameKnown("Isentropic (theta) Level")
    108 =>
      NameKnown("Level at Specified Pressure Difference from Ground to Level")
    109 => NameKnown("Potential Vorticity Surface")
    111 => NameKnown("Eta Level")
    113 => NameKnown("Logarithmic Hybrid Level")
    114 => NameKnown("Snow Level")
    115 => NameKnown("Sigma height level")
    117 => NameKnown("Mixed Layer Depth")
    118 => NameKnown("Hybrid Height Level")
    119 => NameKnown("Hybrid Pressure Level")
    150 => NameKnown("Generalized Vertical Height Coordinate")
    151 => NameKnown("Soil level")
    152 => NameKnown("Sea-ice level")
    160 => NameKnown("Depth Below Sea Level")
    161 => NameKnown("Depth Below Water Surface")
    162 => NameKnown("Lake or River Bottom")
    163 => NameKnown("Bottom Of Sediment Layer")
    164 => NameKnown("Bottom Of Thermally Active Sediment Layer")
    165 => NameKnown("Bottom Of Sediment Layer Penetrated By Thermal Wave")
    166 => NameKnown("Mixing Layer")
    167 => NameKnown("Bottom of Root Zone")
    168 => NameKnown("Ocean Model Level")
    169 =>
      NameKnown("Ocean level defined by water density (sigma-theta) difference")
    170 =>
      NameKnown("Ocean level defined by water potential temperature difference")
    171 =>
      NameKnown("Ocean level defined by vertical eddy diffusivity difference")
    172 => NameKnown("Ocean level defined by water density (rho) difference")
    173 => NameKnown("Top of Snow Over Sea Ice on Sea, Lake or River")
    174 => NameKnown("Top Surface of Ice on Sea, Lake or River")
    175 => NameKnown("Top Surface of Ice, under Snow, on Sea, Lake or River")
    176 => NameKnown("Bottom Surface (underside) Ice on Sea, Lake or River")
    177 => NameKnown("Deep Soil (of indefinite depth)")
    179 => NameKnown("Top Surface of Glacier Ice and Inland Ice")
    180 => NameKnown("Deep Inland or Glacier Ice (of indefinite depth)")
    181 => NameKnown("Grid Tile Land Fraction as a Model Surface")
    182 => NameKnown("Grid Tile Water Fraction as a Model Surface")
    183 =>
      NameKnown(
        "Grid Tile Ice Fraction on Sea, Lake or River as a Model Surface",
      )
    184 =>
      NameKnown(
        "Grid Tile Glacier Ice and Inland Ice Fraction as a Model Surface",
      )
    185 => NameKnown("Roof Level")
    186 => NameKnown("Wall level")
    187 => NameKnown("Road Level")
    188 => NameKnown("Melt pond Top Surface")
    189 => NameKnown("Melt Pond Bottom Surface")
    191 => NameKnown("Abstract Level with no Vertical Localization")
    200 => NameKnown("Entire atmosphere (considered as a single layer)")
    201 => NameKnown("Entire ocean (considered as a single layer)")
    204 => NameKnown("Highest tropospheric freezing level")
    206 => NameKnown("Grid scale cloud bottom level")
    207 => NameKnown("Grid scale cloud top level")
    209 => NameKnown("Boundary layer cloud bottom level")
    210 => NameKnown("Boundary layer cloud top level")
    211 => NameKnown("Boundary layer cloud layer")
    212 => NameKnown("Low cloud bottom level")
    213 => NameKnown("Low cloud top level")
    214 => NameKnown("Low cloud layer")
    215 => NameKnown("Cloud ceiling")
    216 => NameKnown("Effective Layer Top Level")
    217 => NameKnown("Effective Layer Bottom Level")
    218 => NameKnown("Effective Layer")
    220 => NameKnown("Planetary Boundary Layer")
    221 => NameKnown("Layer Between Two Hybrid Levels")
    222 => NameKnown("Middle cloud bottom level")
    223 => NameKnown("Middle cloud top level")
    224 => NameKnown("Middle cloud layer")
    232 => NameKnown("High cloud bottom level")
    233 => NameKnown("High cloud top level")
    234 => NameKnown("High cloud layer")
    235 => NameKnown("Ocean Isotherm Level (1/10 C)")
    236 => NameKnown("Layer between two depths below ocean surface")
    237 => NameKnown("Bottom of Ocean Mixed Layer")
    238 => NameKnown("Bottom of Ocean Isothermal Layer")
    239 => NameKnown("Layer Ocean Surface and 26C Ocean Isothermal Level")
    240 => NameKnown("Ocean Mixed Layer")
    241 => NameKnown("Ordered Sequence of Data")
    242 => NameKnown("Convective cloud bottom level")
    243 => NameKnown("Convective cloud top level")
    244 => NameKnown("Convective cloud layer")
    245 => NameKnown("Lowest level of the wet bulb zero")
    246 => NameKnown("Maximum equivalent potential temperature level")
    247 => NameKnown("Equilibrium level")
    248 => NameKnown("Shallow convective cloud bottom level")
    249 => NameKnown("Shallow convective cloud top level")
    251 => NameKnown("Deep convective cloud bottom level")
    252 => NameKnown("Deep convective cloud top level")
    253 => NameKnown("Lowest bottom level of supercooled liquid water layer")
    254 => NameKnown("Highest top level of supercooled liquid water layer")
    255 => NameKnown("Missing")
    _ =>
      if value == 0 ||
        (value >= 28 && value <= 29) ||
        (value >= 37 && value <= 99) ||
        value == 110 ||
        value == 112 ||
        value == 116 ||
        (value >= 120 && value <= 149) ||
        (value >= 153 && value <= 159) ||
        value == 178 ||
        value == 190 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("fixed_surface_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_ensemble_forecast_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Unperturbed High-Resolution Control Forecast")
    1 => NameKnown("Unperturbed Low-Resolution Control Forecast")
    2 => NameKnown("Negatively Perturbed Forecast")
    3 => NameKnown("Positively Perturbed Forecast")
    4 => NameKnown("Multi-Model Forecast")
    5 => NameKnown("Unperturbed Forecast")
    6 => NameKnown("Perturbed Forecast")
    7 => NameKnown("Initial Conditions Perturbations")
    8 => NameKnown("Model Physics Perturbations")
    9 => NameKnown("Initial Conditions and Model Physics Perturbations")
    192 => NameKnown("Perturbed Ensemble Member")
    255 => NameKnown("Missing")
    _ =>
      if value >= 10 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 193 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_ensemble_forecast=" + value.to_string())
      }
  }
}

///|
pub fn decode_derived_forecast_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Unweighted Mean of All Members")
    1 => NameKnown("Weighted Mean of All Members")
    2 => NameKnown("Standard Deviation with respect to Cluster Mean")
    3 =>
      NameKnown("Standard Deviation with respect to Cluster Mean, Normalized")
    4 => NameKnown("Spread of All Members")
    5 => NameKnown("Large Anomaly Index of All Members")
    6 => NameKnown("Unweighted Mean of the Cluster Members")
    7 =>
      NameKnown(
        "Interquartile Range (Range between the 25th and 75th quantile)",
      )
    8 => NameKnown("Minimum Of All Ensemble Members")
    9 => NameKnown("Maximum Of All Ensemble Members")
    10 => NameKnown("Variance of all ensemble members")
    192 => NameKnown("Unweighted Mode of All Members")
    193 => NameKnown("Percentile value (10%) of All Members")
    194 => NameKnown("Percentile value (50%) of All Members")
    195 => NameKnown("Percentile value (90%) of All Members")
    196 => NameKnown("Statistically decided weights for each ensemble member")
    197 =>
      NameKnown(
        "Climate Percentile (percentile values from climate distribution)",
      )
    198 => NameKnown("Deviation of Ensemble Mean from Daily Climatology")
    199 => NameKnown("Extreme Forecast Index")
    200 => NameKnown("Equally Weighted Mean")
    201 => NameKnown("Percentile value (5%) of All Members")
    202 => NameKnown("Percentile value (25%) of All Members")
    203 => NameKnown("Percentile value (75%) of All Members")
    204 => NameKnown("Percentile value (95%) of All Members")
    255 => NameKnown("Missing")
    _ =>
      if value >= 11 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 205 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("derived_forecast=" + value.to_string())
      }
  }
}

///|
pub fn decode_clustering_method_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Anomoly Correlation")
    1 => NameKnown("Root Mean Square")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("clustering_method=" + value.to_string())
      }
  }
}

///|
pub fn decode_probability_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Probability of event below lower limit")
    1 => NameKnown("Probability of event above upper limit")
    2 =>
      NameKnown(
        "Probability of event between upper and lower limits (the range includes lower limit but not the upper limit)",
      )
    3 => NameKnown("Probability of event above lower limit")
    4 => NameKnown("Probability of event below upper limit")
    5 => NameKnown("Probability of event equal to lower limit")
    6 => NameKnown("Probability of event in above normal category")
    7 => NameKnown("Probability of event in near normal category")
    8 => NameKnown("Probability of event in below normal category")
    9 => NameKnown("Probability based on counts of categorical boolean")
    10 =>
      NameKnown(
        "Probability of event within the quantile of the probability distribution function",
      )
    255 => NameKnown("Missing")
    _ =>
      if value >= 11 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("probability_type=" + value.to_string())
      }
  }
}

