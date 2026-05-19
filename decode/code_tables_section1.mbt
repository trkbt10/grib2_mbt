///|
/// Code-table lookups bound to GRIB2 Section 1 (Identification): discipline,
/// table-version codes, processed-data type, identification template, and
/// calendar type. Each helper returns a `Grib2NameLookup` so unknown codes
/// surface deterministically rather than collapsing to "?".
///|
pub fn decode_discipline_name(discipline : Int) -> Grib2NameLookup {
  match discipline {
    0 => NameKnown("Meteorological Products")
    1 => NameKnown("Hydrological Products")
    2 => NameKnown("Land Surface Products")
    3 => NameKnown("Satellite Remote Sensing Products")
    4 => NameKnown("Space Weather Products")
    10 => NameKnown("Oceanographic Products")
    20 => NameKnown("Health and Socioeconomic Impacts")
    191 => NameKnown("Computational Parameters")
    255 => NameKnown("Missing")
    _ => NameUnknown("discipline=" + discipline.to_string())
  }
}

///|
pub fn decode_master_table_version_name(version : Int) -> Grib2NameLookup {
  if version == 0 {
    return NameKnown("Experimental")
  }
  if version == 1 {
    return NameKnown("Operational")
  }
  if version == 255 {
    return NameKnown("Missing")
  }
  if version > 1 && version < 255 {
    return NameKnown("Version " + version.to_string())
  }
  NameUnknown("master_table_version=" + version.to_string())
}

///|
pub fn decode_local_table_version_name(version : Int) -> Grib2NameLookup {
  if version == 0 {
    return NameKnown("Not Used")
  }
  if version == 255 {
    return NameKnown("Missing")
  }
  if version > 0 && version < 255 {
    return NameKnown("Version " + version.to_string())
  }
  NameUnknown("local_table_version=" + version.to_string())
}

///|
pub fn decode_significance_of_reference_time_name(
  significance : Int,
) -> Grib2NameLookup {
  match significance {
    0 => NameKnown("Analysis")
    1 => NameKnown("Start of Forecast")
    2 => NameKnown("Verifying Time of Forecast")
    3 => NameKnown("Observation Time")
    4 => NameKnown("Local Time")
    5 => NameKnown("Simulation Start")
    6 => NameKnown("Start of Data Assimilation")
    255 => NameKnown("Missing")
    _ =>
      if significance >= 7 && significance <= 191 {
        NameKnown("Reserved")
      } else if significance >= 192 && significance <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("reference_time_significance=" + significance.to_string())
      }
  }
}

///|
pub fn decode_production_status_name(status : Int) -> Grib2NameLookup {
  match status {
    0 => NameKnown("Operational Products")
    1 => NameKnown("Operational Test Products")
    2 => NameKnown("Research Products")
    3 => NameKnown("Re-Analysis Products")
    4 => NameKnown("TIGGE")
    5 => NameKnown("TIGGE Test")
    6 => NameKnown("S2S Operational Products")
    7 => NameKnown("S2S Test Products")
    8 => NameKnown("UERRA")
    9 => NameKnown("UERRA Test")
    10 => NameKnown("Copernicus Regional Reanalysis")
    11 => NameKnown("Copernicus Regional Reanalysis Test")
    12 => NameKnown("Destination Earth")
    13 => NameKnown("Destination Earth Test")
    14 => NameKnown("LC-GCR")
    15 => NameKnown("LC-GCR Test")
    16 => NameKnown("MLMIP")
    17 => NameKnown("MLMIP Test")
    255 => NameKnown("Missing")
    _ =>
      if status >= 18 && status <= 191 {
        NameKnown("Reserved")
      } else if status >= 192 && status <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("production_status=" + status.to_string())
      }
  }
}

///|
pub fn decode_processed_data_type_name(data_type : Int) -> Grib2NameLookup {
  match data_type {
    0 => NameKnown("Analysis Products")
    1 => NameKnown("Forecast Products")
    2 => NameKnown("Analysis and Forecast Products")
    3 => NameKnown("Control Forecast Products")
    4 => NameKnown("Perturbed Forecast Products")
    5 => NameKnown("Control and Perturbed Forecast Products")
    6 => NameKnown("Processed Satellite Observations")
    7 => NameKnown("Processed Radar Observations")
    8 => NameKnown("Event Probability")
    9 => NameKnown("Experimental Data")
    10 => NameKnown("ML Based Forecast")
    192 => NameKnown("Experimental Products")
    255 => NameKnown("Missing")
    _ =>
      if data_type >= 11 && data_type <= 191 {
        NameKnown("Reserved")
      } else if data_type >= 193 && data_type <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("processed_data_type=" + data_type.to_string())
      }
  }
}

///|
pub fn decode_identification_template_number_name(
  template_number : Int,
) -> Grib2NameLookup {
  match template_number {
    0 => NameKnown("Calendar Definition")
    1 => NameKnown("Paleontological Offset")
    2 => NameKnown("Calendar Definition and Paleontological Offset")
    65535 => NameKnown("Missing")
    _ =>
      if template_number >= 3 && template_number <= 32767 {
        NameKnown("Reserved")
      } else if template_number >= 32768 && template_number <= 65534 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("id_template_number=" + template_number.to_string())
      }
  }
}

///|
pub fn decode_calendar_type_name(calendar_type : Int) -> Grib2NameLookup {
  match calendar_type {
    0 => NameKnown("Gregorian")
    1 => NameKnown("360-day")
    2 => NameKnown("365-day")
    3 => NameKnown("Proleptic Gregorian")
    255 => NameKnown("Missing")
    _ =>
      if calendar_type >= 4 && calendar_type <= 191 {
        NameKnown("Reserved")
      } else if calendar_type >= 192 && calendar_type <= 254 {
        NameKnown("Reserved for Local Use")
      } else {
        NameUnknown("calendar_type=" + calendar_type.to_string())
      }
  }
}

///|
