///|
/// Code-table lookups for Section 4 statistical/probability/verification
/// extensions: statistical processing, time-interval type, operating mode,
/// quality-control & clutter-filter flags, spatial processing, intervals,
/// reference dataset, spatial-and-temporal vicinity, radar data quality, and
/// verification scores.
pub fn decode_type_of_statistical_processing_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Average")
    1 => NameKnown("Accumulation")
    2 => NameKnown("Maximum")
    3 => NameKnown("Minimum")
    4 =>
      NameKnown(
        "Difference (value at the end of the time range minus value at the beginning)",
      )
    5 => NameKnown("Root Mean Square")
    6 => NameKnown("Standard Deviation")
    7 => NameKnown("Covariance (temporal variance)")
    8 =>
      NameKnown(
        "Difference (value at the beginning of the time range minus value at the end)",
      )
    9 => NameKnown("Ratio")
    10 => NameKnown("Standardized Anomaly")
    11 => NameKnown("Summation")
    12 => NameKnown("Return period")
    13 => NameKnown("Median")
    100 => NameKnown("Severity")
    101 => NameKnown("Mode")
    102 => NameKnown("Index processing")
    192 => NameKnown("Climatological Mean Value")
    193 => NameKnown("Average of N forecasts (or initialized analyses)")
    194 => NameKnown("Average of N uninitialized analyses")
    195 => NameKnown("Average of forecast accumulations (24-hour intervals)")
    196 => NameKnown("Average of successive forecast accumulations")
    197 => NameKnown("Average of forecast averages (24-hour intervals)")
    198 => NameKnown("Average of successive forecast averages")
    199 => NameKnown("Climatological Average of N analyses")
    200 => NameKnown("Climatological Average of N forecasts")
    201 => NameKnown("Climatological Root Mean Square difference")
    202 => NameKnown("Climatological Standard Deviation of N forecasts")
    203 => NameKnown("Climatological Standard Deviation of N analyses")
    204 => NameKnown("Average of forecast accumulations (6-hour intervals)")
    205 => NameKnown("Average of forecast averages (6-hour intervals)")
    206 => NameKnown("Average of forecast accumulations (12-hour intervals)")
    207 => NameKnown("Average of forecast averages (12-hour intervals)")
    208 => NameKnown("Variance")
    209 => NameKnown("Coefficient")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 14 && value <= 99) || (value >= 103 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 210 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_statistical_processing=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_time_intervals_name(value : Int) -> Grib2NameLookup {
  match value {
    1 =>
      NameKnown(
        "Successive times processed have same forecast time, start time of forecast is incremented",
      )
    2 =>
      NameKnown(
        "Successive times processed have same start time of forecast, forecast time is incremented",
      )
    3 =>
      NameKnown(
        "Successive times processed have start time of forecast incremented and forecast time decremented so that valid time remains constant",
      )
    4 =>
      NameKnown(
        "Successive times processed have start time of forecast decremented and forecast time incremented so that valid time remains constant",
      )
    5 =>
      NameKnown(
        "Floating subinterval of time between forecast time and end of overall time interval",
      )
    255 => NameKnown("Missing")
    _ =>
      if value == 0 || (value >= 6 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_time_intervals=" + value.to_string())
      }
  }
}

///|
pub fn decode_operating_mode_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Maintenance Mode")
    1 => NameKnown("Clear Air")
    2 => NameKnown("Precipitation")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("operating_mode=" + value.to_string())
      }
  }
}

///|
pub fn decode_quality_control_indicator_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Quality Control Applied")
    1 => NameKnown("Quality Control Applied")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("quality_control_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_clutter_filter_indicator_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("No Clutter Filter Used")
    1 => NameKnown("Clutter Filter Used")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("clutter_filter_indicator=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_spatial_processing_name(value : Int) -> Grib2NameLookup {
  match value {
    0 =>
      NameKnown(
        "Data is calculated directly from the source grid with no interpolation",
      )
    1 =>
      NameKnown(
        "Bilinear interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    2 =>
      NameKnown(
        "Bicubic interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    3 =>
      NameKnown(
        "Using the value from the source grid-point which is nearest to the nominal grid-point",
      )
    4 =>
      NameKnown(
        "Budget interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    5 =>
      NameKnown(
        "Spectral interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    6 =>
      NameKnown(
        "Neighbor-budget interpolation using the 4 source grid-point values surrounding the nominal grid-point",
      )
    255 => NameKnown("Missing")
    _ =>
      if value >= 7 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_spatial_processing=" + value.to_string())
      }
  }
}

///|
pub fn decode_quality_value_associated_with_parameter_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Confidence index")
    1 => NameKnown("Quality indicator")
    2 => NameKnown("Correlation of Product with used Calibration Product")
    3 => NameKnown("Standard deviation")
    4 => NameKnown("Random error")
    5 => NameKnown("Probability")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "quality_value_associated_with_parameter=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_type_of_interval_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Smaller than first limit")
    1 => NameKnown("Greater than second limit")
    2 =>
      NameKnown(
        "Between first and second limit. The range includes the first limit but not the second limit.",
      )
    3 => NameKnown("Greater than first limit")
    4 => NameKnown("Smaller than second limit")
    5 => NameKnown("Smaller or equal first limit")
    6 => NameKnown("Greater or equal second limit")
    7 =>
      NameKnown(
        "Between first and second limit. The range includes the first limit and the second limit.",
      )
    8 => NameKnown("Greater or equal first limit")
    9 => NameKnown("Smaller or equal second limit")
    10 =>
      NameKnown(
        "Between first and second limit. The range includes the second limit but not the first limit.",
      )
    11 => NameKnown("Equal to first limit")
    255 => NameKnown("Missing")
    _ =>
      if value >= 12 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_interval=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_reference_dataset_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Analysis")
    1 => NameKnown("Forecast")
    2 => NameKnown("Reforecast (Hindcast)")
    3 => NameKnown("Reanalysis")
    4 => NameKnown("Climate Projection")
    5 => NameKnown("Gridded observations")
    255 => NameKnown("Missing")
    _ =>
      if value >= 6 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("type_of_reference_dataset=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_relationship_to_reference_dataset_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Anomaly")
    1 => NameKnown("Standardized Anomaly")
    2 => NameKnown("Significance (Wilcoxon-Mann-Whitney)")
    3 => NameKnown("Climatology")
    20 => NameKnown("Extreme Forecast Index (EFI)")
    21 => NameKnown("Shift of Tails (SOT)")
    22 => NameKnown("Anomaly of Probabilities")
    23 => NameKnown("Standardized Drought Index")
    24 => NameKnown("Crossing Point Forecast (CPF)")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 4 && value <= 19) || (value >= 25 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "type_of_relationship_to_reference_dataset=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_statistical_processing_of_reference_period_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Average")
    1 => NameKnown("Accumulation")
    2 => NameKnown("Maximum")
    3 => NameKnown("Minimum")
    4 => NameKnown("Median")
    20 => NameKnown("Model Climate")
    21 => NameKnown("Index based on normal distribution")
    22 => NameKnown("Index based on log-normal distribution")
    23 => NameKnown("Index based on generalized log-normal distribution")
    24 => NameKnown("Index based on gamma distribution")
    25 => NameKnown("Index based on logistic distribution")
    26 => NameKnown("Index based on log-logistic distribution")
    27 => NameKnown("Index based on generalized logistic distribution")
    28 => NameKnown("Index based on Weibull distribution")
    29 => NameKnown("Index based on generalized extreme value distribution")
    30 => NameKnown("Index based on Pearson III distribution")
    31 => NameKnown("Index based on empirical distribution")
    255 => NameKnown("Missing")
    _ =>
      if (value >= 5 && value <= 19) || (value >= 32 && value <= 191) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "statistical_processing_of_reference_period=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_spatial_vicinity_type_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Circle [m]")
    1 => NameKnown("Rectangle [m,m]")
    2 => NameKnown("Square [m]")
    3 => NameKnown("Wedge [m, degree, degree]")
    4 => NameKnown("Span of grid boxes centered around grid box i,j [x,y]")
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("spatial_vicinity_type=" + value.to_string())
      }
  }
}

///|
pub fn decode_spatial_and_temporal_vicinity_processing_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Average")
    2 => NameKnown("Maximum")
    3 => NameKnown("Minimum")
    4 => NameKnown("Range")
    6 => NameKnown("Standard deviation")
    11 => NameKnown("Sum")
    190 => NameKnown("Quantile")
    191 => NameKnown("Categorical (boolean)")
    255 => NameKnown("Missing")
    _ =>
      if value == 1 ||
        value == 5 ||
        (value >= 7 && value <= 10) ||
        (value >= 12 && value <= 189) {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "spatial_and_temporal_vicinity_processing=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_spatial_and_temporal_vicinity_missing_data_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Ignore missing data")
    1 => NameKnown("No data")
    255 => NameKnown("Missing")
    _ =>
      if value >= 2 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "spatial_and_temporal_vicinity_missing_data=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_radar_data_quality_flags_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Normal operating data")
    1 => NameKnown("No data")
    2 => NameKnown("Undetected")
    3 => NameKnown("Implausible data/outliers")
    4 => NameKnown("Beam overshooting")
    5 => NameKnown("Beam blocking")
    6 => NameKnown("Ground clutter")
    7 => NameKnown("Sea clutter")
    8 => NameKnown("Beam attenuation")
    9 => NameKnown("Wet radome attenuation")
    10 => NameKnown("Wind turbines")
    11 => NameKnown("Insects/birds")
    12 => NameKnown("Ships/aircrafts")
    255 => NameKnown("Missing")
    _ =>
      if value >= 13 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("radar_data_quality_flags=" + value.to_string())
      }
  }
}

///|
pub fn decode_verification_scores_name(value : Int) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Mean Error")
    1 => NameKnown("Root Mean Squared Error")
    2 => NameKnown("Continuous Ranked Probability Score (CRPS)")
    3 => NameKnown("Fair Continuous Ranked Probability Score")
    4 => NameKnown("Continuous Logarithmic Ignorance Score")
    5 => NameKnown("Fair Continuous Logarithmic Ignorance Score")
    6 => NameKnown("Ranked Probability Score")
    100 => NameKnown("Contingency Table (Deterministic) - Hits")
    101 => NameKnown("Contingency Table (Deterministic) - False Alarms")
    102 => NameKnown("Contingency Table (Deterministic) - Misses")
    103 => NameKnown("Contingency Table (Deterministic) - Correct Negatives")
    104 =>
      NameKnown(
        "Contingency Table (Probabilistic) - Forecast-by-n-members and observed",
      )
    105 =>
      NameKnown(
        "Contingency Table (Probabilistic) - Forecast-by-n-members and not observed",
      )
    65535 => NameKnown("Missing")
    _ =>
      if value >= 7 && value <= 99 {
        NameKnown("Reserved for Future Use")
      } else if value >= 106 && value <= 62999 {
        NameKnown("Reserved")
      } else if value >= 63000 && value <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("verification_scores=" + value.to_string())
      }
  }
}

///|
pub fn decode_type_of_reference_dataset_for_verification_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Analysis Interpolated on Forecast Grid")
    1 => NameKnown("Analysis with Forecast Interpolated on Analysis Grid")
    2 =>
      NameKnown(
        "Analysis Interpolated on a Common Grid with the Forecast but Different to Original Grid",
      )
    3 => NameKnown("Gridded Observation on Forecast Grid")
    4 =>
      NameKnown(
        "Gridded Observation wih Forecast Interpolated on Observation Grid",
      )
    255 => NameKnown("Missing")
    _ =>
      if value >= 5 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "type_of_reference_dataset_for_verification=" + value.to_string(),
        )
      }
  }
}

///|
pub fn decode_type_of_additional_arguments_for_verification_score_name(
  value : Int,
) -> Grib2NameLookup {
  match value {
    0 => NameKnown("Fixed Threshold Value")
    1 => NameKnown("Threshold Specified as a Quantile of the Climatology")
    2 =>
      NameKnown("Threshold Specified as a Multiple of the Standard Deviation")
    255 => NameKnown("Missing")
    _ =>
      if value >= 3 && value <= 191 {
        NameKnown("Reserved")
      } else if value >= 192 && value <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown(
          "type_of_additional_arguments_for_verification_score=" +
          value.to_string(),
        )
      }
  }
}

///|
