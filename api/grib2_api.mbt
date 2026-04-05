///|
/// Target-agnostic public API for GRIB2 data access.
/// This package provides high-level functions that work on any target
/// (native, WASM, JS). The WASM export layer in the root package
/// adds handle management and latin1 encoding on top of these.

///|
using @context {
  type Grib2FileContext,
  type Grib2MessageContext,
  type Grib2SubmessageFrame,
}

///|
using @core {
  parse_grib2_file,
}

///|
using @decode {
  type Grib2Section1Decoded,
  type Grib2Section3Decoded,
  type Grib2Section4Decoded,
  type Grib2Section5Decoded,
  type Grib2Section6Decoded,
  type Grib2SectionCodecError,
  decode_message_section1,
  decode_submessage_section3,
  decode_submessage_section4,
  decode_submessage_section5,
  decode_submessage_section6,
  unpack_submessage_data,
}

///|
/// Parse GRIB2 bytes and return a file context.
pub fn parse(bytes : Bytes) -> Result[Grib2FileContext, String] {
  match parse_grib2_file(bytes) {
    Ok(context) => Ok(context)
    Err(e) => Err(e.to_string())
  }
}

///|
/// Find a submessage by 1-based record index.
pub fn find_submessage(
  context : Grib2FileContext,
  record_index : Int,
) -> (Grib2MessageContext, Grib2SubmessageFrame)? {
  let mut current = 1
  for message in context.messages {
    for submessage in message.submessages {
      if current == record_index {
        return Some((message, submessage))
      }
      current += 1
    }
  }
  None
}

///|
fn json_int(value : Int) -> Json {
  Json::number(value.to_double())
}

///|
fn json_nullable_int(value : Int) -> Json {
  if value >= 0 {
    json_int(value)
  } else {
    Json::null()
  }
}

///|
pub fn error_to_json(error : String) -> String {
  Json::object({ "error": Json::string(error) }).to_string()
}

///|
pub fn section1_to_json(s1 : Grib2Section1Decoded) -> String {
  Json::object(
    {
      "center": json_int(s1.center),
      "subcenter": json_int(s1.subcenter),
      "masterTableVersion": json_int(s1.master_table_version),
      "localTableVersion": json_int(s1.local_table_version),
      "significanceOfRefTime": json_int(s1.significance_of_reference_time),
      "year": json_int(s1.reference_year),
      "month": json_int(s1.reference_month),
      "day": json_int(s1.reference_day),
      "hour": json_int(s1.reference_hour),
      "minute": json_int(s1.reference_minute),
      "second": json_int(s1.reference_second),
      "productionStatus": json_int(s1.production_status),
      "typeOfData": json_int(s1.processed_data_type),
    },
  )
  .to_string()
}

///|
pub fn section3_to_json(s3 : Grib2Section3Decoded) -> String {
  let info = @typed.get_section3_grid_info(s3.template)
  let map : Map[String, Json] = {
    "gridDefinitionSource": json_int(s3.source_of_grid_definition),
    "numberOfPoints": json_int(s3.number_of_data_points),
    "template": json_int(info.template_id),
  }
  if info.ni >= 0 {
    map["ni"] = json_int(info.ni)
    map["nj"] = json_int(info.nj)
    map["lat1Microdeg"] = json_int(info.la1)
    map["lon1Microdeg"] = json_int(info.lo1)
    map["lat2Microdeg"] = json_int(info.la2)
    map["lon2Microdeg"] = json_int(info.lo2)
    map["diMicrodeg"] = json_int(info.di)
    map["djMicrodeg"] = json_int(info.dj)
    map["scanMode"] = json_int(info.scan_mode)
    map["resolutionFlags"] = json_int(info.res_flags)
  }
  Json::object(map).to_string()
}

///|
pub fn section4_to_json(s4 : Grib2Section4Decoded) -> String {
  let info = @typed.get_section4_product_info(s4.template)
  let map : Map[String, Json] = { "template": json_int(info.template_id) }
  if info.param_cat >= 0 {
    map["parameterCategory"] = json_int(info.param_cat)
    map["parameterNumber"] = json_int(info.param_num)
    map["typeOfGeneratingProcess"] = json_int(info.gen_process)
    map["indicatorOfUnitOfTimeRange"] = json_int(info.time_unit)
    map["forecastTime"] = json_int(info.forecast_time)
    map["typeOfFirstFixedSurface"] = json_int(info.first_surface_type)
    map["scaleFactorOfFirstFixedSurface"] = json_int(info.first_surface_scale)
    map["scaledValueOfFirstFixedSurface"] = json_int(info.first_surface_value)
    map["typeOfSecondFixedSurface"] = if info.second_surface_type >= 0 &&
      info.second_surface_type != 255 {
      json_int(info.second_surface_type)
    } else {
      Json::null()
    }
    map["scaleFactorOfSecondFixedSurface"] = json_nullable_int(
      info.second_surface_scale,
    )
    map["scaledValueOfSecondFixedSurface"] = json_nullable_int(
      info.second_surface_value,
    )
    if info.ensemble_type >= 0 {
      map["ensembleType"] = json_int(info.ensemble_type)
    }
    if info.perturb_num >= 0 {
      map["perturbationNumber"] = json_int(info.perturb_num)
    }
    if info.ensemble_members >= 0 {
      map["numberOfEnsembleMembers"] = json_int(info.ensemble_members)
    }
    if info.prob_type >= 0 {
      map["probabilityType"] = json_int(info.prob_type)
    }
  }
  Json::object(map).to_string()
}

///|
pub fn section5_to_json(s5 : Grib2Section5Decoded) -> String {
  let info = @typed.get_section5_data_info(s5.template)
  let map : Map[String, Json] = {
    "numberOfPoints": json_int(s5.number_of_data_points),
    "template": json_int(info.template_id),
  }
  if info.reference_value_ieee >= 0 {
    let ieee = info.reference_value_ieee
    map["referenceValue"] = Json::number(
      ieee.reinterpret_as_uint().reinterpret_as_float().to_double(),
    )
    map["binaryScaleFactor"] = json_int(info.binary_scale)
    map["decimalScaleFactor"] = json_int(info.decimal_scale)
    map["bitsPerValue"] = json_int(info.bits_per_value)
  }
  Json::object(map).to_string()
}

///|
pub fn section6_to_json(s6 : Grib2Section6Decoded) -> String {
  Json::object({ "bitmapIndicator": json_int(s6.bitmap_indicator) }).to_string()
}

///|
/// Generate coordinates from Section 3 data.
pub fn generate_coordinates(
  s3 : Grib2Section3Decoded,
) -> @typed.CoordinateGrid? {
  @typed.generate_coordinates_from_section3(s3.template)
}

///|
/// Get Section 1 JSON for a message.
pub fn get_section1_json(
  message : Grib2MessageContext,
) -> Result[String, String] {
  match decode_message_section1(message) {
    Ok(s1) => Ok(section1_to_json(s1))
    Err(e) => Err(e.to_string())
  }
}

///|
/// Get Section 3 JSON for a submessage.
pub fn get_section3_json(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[String, String] {
  match decode_submessage_section3(message, submessage) {
    Ok(s3) => Ok(section3_to_json(s3))
    Err(e) => Err(e.to_string())
  }
}

///|
/// Get Section 4 JSON for a submessage.
pub fn get_section4_json(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[String, String] {
  match decode_submessage_section4(message, submessage) {
    Ok(s4) => Ok(section4_to_json(s4))
    Err(e) => Err(e.to_string())
  }
}

///|
/// Get Section 5 JSON for a submessage.
pub fn get_section5_json(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[String, String] {
  match decode_submessage_section5(message, submessage) {
    Ok(s5) => Ok(section5_to_json(s5))
    Err(e) => Err(e.to_string())
  }
}

///|
/// Get Section 6 JSON for a submessage.
pub fn get_section6_json(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[String, String] {
  match decode_submessage_section6(message, submessage) {
    Ok(s6) => Ok(section6_to_json(s6))
    Err(e) => Err(e.to_string())
  }
}

///|
/// Unpack grid data values for a submessage.
pub fn get_grid_data(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Array[Double], String] {
  match unpack_submessage_data(message, submessage) {
    Ok(unpacked) => Ok(unpacked.values)
    Err(@section7.InvalidBitsPerValue(s)) => Err(s)
    Err(@section7.InsufficientData(s)) => Err(s)
    Err(@section7.UnsupportedTemplate(s)) => Err(s)
  }
}

///|
/// Get latitude coordinates for a submessage.
pub fn get_latitudes(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Array[Double], String] {
  match decode_submessage_section3(message, submessage) {
    Ok(s3) =>
      match generate_coordinates(s3) {
        Some(coords) => Ok(coords.latitudes)
        None => Err("unsupported grid template for coordinate generation")
      }
    Err(e) => Err(e.to_string())
  }
}

///|
/// Get longitude coordinates for a submessage.
pub fn get_longitudes(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Array[Double], String] {
  match decode_submessage_section3(message, submessage) {
    Ok(s3) =>
      match generate_coordinates(s3) {
        Some(coords) => Ok(coords.longitudes)
        None => Err("unsupported grid template for coordinate generation")
      }
    Err(e) => Err(e.to_string())
  }
}
