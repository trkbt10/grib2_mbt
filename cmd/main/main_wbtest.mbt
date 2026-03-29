///|
fn count_crlf_pairs(bytes : Bytes) -> Int {
  let mut n = 0
  if bytes.length() < 2 {
    return 0
  }
  for i in 0..<(bytes.length() - 1) {
    if bytes[i] == b'\r' && bytes[i + 1] == b'\n' {
      n += 1
    }
  }
  n
}

///|
fn line_count(path : String) -> Int {
  let body = @fs.read_file_to_string(path) catch { _ => "" }
  let mut n = 0
  for line in body.split("\n") {
    if line.to_string().length() > 0 {
      n += 1
    }
  }
  n
}

///|
fn count_grib_magic(bytes : Bytes) -> Int {
  if bytes.length() < 4 {
    return 0
  }
  let mut n = 0
  for i in 0..<(bytes.length() - 3) {
    if bytes[i] == b'G' &&
      bytes[i + 1] == b'R' &&
      bytes[i + 2] == b'I' &&
      bytes[i + 3] == b'B' {
      n += 1
    }
  }
  n
}

///|
fn bytes_be_u32(bytes : Bytes, offset : Int) -> Int {
  (bytes[offset].to_int() << 24) |
  (bytes[offset + 1].to_int() << 16) |
  (bytes[offset + 2].to_int() << 8) |
  bytes[offset + 3].to_int()
}

///|
fn decode_single_template48_output(
  path : String,
) -> Result[(@lib.Grib2RecordMeta, @section4.Grib2ProductTemplate48), String] {
  let context = match @lib.parse_with_io(native_read_bytes, path) {
    Ok(v) => v
    Err(e) => return Err("failed to parse output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  if metas.length() != 1 {
    return Err("expected single-record output")
  }
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let section4 = match @lib.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode output section4: " + e.to_string())
  }
  match section4.template {
    @section4.ProductTemplate48(template48) => Ok((metas[0], template48))
    _ => Err("expected template4.8 output")
  }
}

///|
fn decode_template48_outputs(
  path : String,
) -> Result[
  (Array[@lib.Grib2RecordMeta], Array[@section4.Grib2ProductTemplate48]),
  String,
] {
  let context = match @lib.parse_with_io(native_read_bytes, path) {
    Ok(v) => v
    Err(e) => return Err("failed to parse output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  let templates : Array[@section4.Grib2ProductTemplate48] = []
  for index in 0..<metas.length() {
    let message = context.messages[index]
    let submessage = message.submessages[0]
    let section4 = match @lib.decode_submessage_section4(message, submessage) {
      Ok(v) => v
      Err(e) => return Err("failed to decode output section4: " + e.to_string())
    }
    match section4.template {
      @section4.ProductTemplate48(template48) => templates.push(template48)
      _ => return Err("expected template4.8 output")
    }
  }
  Ok((metas, templates))
}

///|
fn decode_template48_outputs_with_values(
  path : String,
) -> Result[
  (
    Array[@lib.Grib2RecordMeta],
    Array[@section4.Grib2ProductTemplate48],
    Array[Array[Double]],
  ),
  String,
] {
  let context = match @lib.parse_with_io(native_read_bytes, path) {
    Ok(v) => v
    Err(e) => return Err("failed to parse output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  let templates : Array[@section4.Grib2ProductTemplate48] = []
  let values : Array[Array[Double]] = []
  for index in 0..<metas.length() {
    let message = context.messages[index]
    let submessage = message.submessages[0]
    let section4 = match @lib.decode_submessage_section4(message, submessage) {
      Ok(v) => v
      Err(e) => return Err("failed to decode output section4: " + e.to_string())
    }
    match section4.template {
      @section4.ProductTemplate48(template48) => templates.push(template48)
      _ => return Err("expected template4.8 output")
    }
    let unpacked = match @lib.unpack_submessage_data(message, submessage) {
      Ok(v) => v.values
      Err(e) =>
        return Err("failed to unpack output data: " + unpack_error_string(e))
    }
    values.push(unpacked)
  }
  Ok((metas, templates, values))
}

///|
struct SyntheticForecastInputSpec {
  start_time : Int
  duration : Int
  time_increment_length : Int
  scale : Double
}

///|
struct ForecastTestSource {
  context : @lib.Grib2FileContext
  record_ref : SelectedRecordRef
  meta : @lib.Grib2RecordMeta
  base : @section4.Grib2ProductTemplate40
  section1_bytes : Bytes
  section3_bytes : Bytes
  coordinate_value_count : Int
  coordinate_values_raw : Bytes
  source_values : Array[Double]
}

///|
fn normalize_forecast_test_values(values : Array[Double]) -> Array[Double] {
  let out : Array[Double] = []
  for value in values {
    out.push(to_wgrib2_float32(value))
  }
  out
}

///|
fn load_forecast_test_source_record(
  fixture : String,
  record_index : Int,
) -> Result[ForecastTestSource, String] {
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to parse forecast-processing fixture: " + e.to_string(),
      )
  }
  let refs = collect_selected_record_refs(context, Some([record_index]))
  if refs.length() != 1 {
    return Err(
      "expected exactly one forecast-processing source record for index " +
      record_index.to_string(),
    )
  }
  let record_ref = refs[0]
  let meta = match find_record_meta(context, record_index) {
    Some(v) => v
    None =>
      return Err(
        "failed to locate forecast-processing source record " +
        record_index.to_string(),
      )
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let section4 = match @lib.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to decode forecast-processing source section4: " + e.to_string(),
      )
  }
  let base = match section4.template {
    @section4.ProductTemplate40(v) => v
    _ => return Err("expected template4.0 forecast-processing source")
  }
  let source_values = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => normalize_forecast_test_values(v.values)
    Err(e) =>
      return Err(
        "failed to unpack forecast-processing source: " + unpack_error_string(e),
      )
  }
  Ok({
    context,
    record_ref,
    meta,
    base,
    section1_bytes: section_frame_bytes(message, message.section1),
    section3_bytes: section_frame_bytes(message, submessage.section3),
    coordinate_value_count: section4.number_of_coordinate_values,
    coordinate_values_raw: section4.coordinate_values_raw,
    source_values,
  })
}

///|
fn load_forecast_test_source() -> Result[ForecastTestSource, String] {
  load_forecast_test_source_record(
    "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2", 1,
  )
}

///|
fn load_real_forecast_test_values(
  fixture : String,
  record_indices : Array[Int],
) -> Result[(ForecastTestSource, Array[Array[Double]]), String] {
  if record_indices.length() == 0 {
    return Err("expected at least one real forecast-processing source record")
  }
  let source = match
    load_forecast_test_source_record(fixture, record_indices[0]) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let values : Array[Array[Double]] = [source.source_values]
  for index in 1..<record_indices.length() {
    let current = match
      load_forecast_test_source_record(fixture, record_indices[index]) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    if current.section1_bytes != source.section1_bytes ||
      current.section3_bytes != source.section3_bytes ||
      current.base.parameter_category != source.base.parameter_category ||
      current.base.parameter_number != source.base.parameter_number ||
      current.meta.level_name.display() != source.meta.level_name.display() {
      return Err(
        "real forecast-processing source records are not compatible: " +
        record_indices[0].to_string() +
        " vs " +
        record_indices[index].to_string(),
      )
    }
    values.push(current.source_values)
  }
  Ok((source, values))
}

///|
fn forecast_test_statistical_process(kind : ForecastProcessingKind) -> Int {
  match kind {
    Ave => 0
    Acc => 1
    Max => 2
    Min => 3
  }
}

///|
fn synthetic_forecast_template48_end_components(
  source : ForecastTestSource,
  start_time : Int,
  duration : Int,
) -> Result[(Int, Int, Int, Int, Int, Int), String] {
  if source.meta.unix_rt < 0L {
    return Err("expected synthetic forecast source to have unix_rt")
  }
  let timestamp = format_timestamp14_from_unix(
    source.meta.unix_rt + (start_time + duration).to_int64() * 3600L,
  )
  match parse_timestamp14_components(timestamp) {
    Some(v) => Ok(v)
    None => Err("failed to compute synthetic forecast end time")
  }
}

///|
fn build_synthetic_forecast_record(
  source : ForecastTestSource,
  kind : ForecastProcessingKind,
  spec : SyntheticForecastInputSpec,
  values : Array[Double],
) -> Result[ForecastProcessingRecord, String] {
  let (end_year, end_month, end_day, end_hour, end_minute, end_second) = match
    synthetic_forecast_template48_end_components(
      source,
      spec.start_time,
      spec.duration,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let template48 : @section4.Grib2ProductTemplate48 = {
    base: { ..source.base, time_range_unit: 1, forecast_time: spec.start_time },
    end_year,
    end_month,
    end_day,
    end_hour,
    end_minute,
    end_second,
    number_of_time_ranges: 1,
    number_of_missing_values: 0,
    time_range_specs: [
      {
        statistical_process: forecast_test_statistical_process(kind),
        type_of_time_increment: 2,
        time_range_unit: 1,
        time_range_length: spec.duration,
        time_increment_unit: 1,
        time_increment_length: spec.time_increment_length,
      },
    ],
    reserved_tail: b"",
  }
  let decoded_section4 : @lib.Grib2Section4Decoded = {
    number_of_coordinate_values: source.coordinate_value_count,
    template: @section4.ProductTemplate48(template48),
    coordinate_values_raw: source.coordinate_values_raw,
  }
  let section4_bytes = @lib.encode_section4_bytes(decoded_section4)
  Ok({
    record_ref: source.record_ref,
    meta: source.meta,
    section1_bytes: source.section1_bytes,
    section3_bytes: source.section3_bytes,
    section4_bytes,
    section4_key: forecast_processing_template48_key(
      decoded_section4, template48,
    ),
    coordinate_value_count: source.coordinate_value_count,
    coordinate_values_raw: source.coordinate_values_raw,
    template48,
    kind,
    start_time: spec.start_time,
    duration: spec.duration,
    values,
  })
}

///|
fn write_synthetic_forecast_input(
  path : String,
  kind : ForecastProcessingKind,
  specs : Array[SyntheticForecastInputSpec],
) -> Result[Unit, String] {
  let source = match load_forecast_test_source() {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let values_by_record : Array[Array[Double]] = []
  for spec in specs {
    values_by_record.push(
      forecast_scale_average_values(source.source_values, spec.scale),
    )
  }
  write_forecast_input_with_values(path, source, kind, specs, values_by_record)
}

///|
fn write_forecast_input_with_values(
  path : String,
  source : ForecastTestSource,
  kind : ForecastProcessingKind,
  specs : Array[SyntheticForecastInputSpec],
  values_by_record : Array[Array[Double]],
) -> Result[Unit, String] {
  if specs.length() != values_by_record.length() {
    return Err("forecast-processing spec/value length mismatch")
  }
  let out : Array[Byte] = []
  for index in 0..<specs.length() {
    let spec = specs[index]
    let record = match
      build_synthetic_forecast_record(
        source,
        kind,
        spec,
        values_by_record[index],
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let bytes = match
      build_processed_forecast_submessage_bytes(
        "synthetic-forecast-input",
        source.context,
        record,
        record.section4_bytes,
        record.values,
      ) {
      Ok(v) => v
      Err(e) => return Err("failed to build synthetic forecast input: " + e)
    }
    append_bytes(out, bytes)
  }
  match native_write_bytes(path, Bytes::from_array(out)) {
    Ok(_) => ()
    Err(e) => return Err(e)
  }
  Ok(())
}

///|
fn build_submessage_grib_bytes_with_section1_override_for_test(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  section1_override : Bytes?,
) -> Bytes {
  let sec1 = match section1_override {
    Some(v) => v
    None => section_frame_bytes(message, message.section1)
  }
  let sec2 = match submessage.section2 {
    Some(s) => section_frame_bytes(message, s)
    None => Bytes::new(0)
  }
  let sec3 = section_frame_bytes(message, submessage.section3)
  let sec4 = section_frame_bytes(message, submessage.section4)
  let sec5 = section_frame_bytes(message, submessage.section5)
  let sec6 = section_frame_bytes(message, submessage.section6)
  let sec7 = section_frame_bytes(message, submessage.section7)
  let body_len = sec1.length() +
    sec2.length() +
    sec3.length() +
    sec4.length() +
    sec5.length() +
    sec6.length() +
    sec7.length()
  let total_len = 16 + body_len + 4
  let sec0 = build_sec0_with_length(message, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, sec1)
  append_bytes(out, sec2)
  append_bytes(out, sec3)
  append_bytes(out, sec4)
  append_bytes(out, sec5)
  append_bytes(out, sec6)
  append_bytes(out, sec7)
  append_ascii_string_bytes(out, "7777")
  Bytes::from_array(out)
}

///|
fn build_submessage_grib_bytes_with_section1_and_section3_override_for_test(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  section1_override : Bytes?,
  section3_override : Bytes?,
) -> Bytes {
  let sec1 = match section1_override {
    Some(v) => v
    None => section_frame_bytes(message, message.section1)
  }
  let sec2 = match submessage.section2 {
    Some(s) => section_frame_bytes(message, s)
    None => Bytes::new(0)
  }
  let sec3 = match section3_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section3)
  }
  let sec4 = section_frame_bytes(message, submessage.section4)
  let sec5 = section_frame_bytes(message, submessage.section5)
  let sec6 = section_frame_bytes(message, submessage.section6)
  let sec7 = section_frame_bytes(message, submessage.section7)
  let body_len = sec1.length() +
    sec2.length() +
    sec3.length() +
    sec4.length() +
    sec5.length() +
    sec6.length() +
    sec7.length()
  let total_len = 16 + body_len + 4
  let sec0 = build_sec0_with_length(message, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, sec1)
  append_bytes(out, sec2)
  append_bytes(out, sec3)
  append_bytes(out, sec4)
  append_bytes(out, sec5)
  append_bytes(out, sec6)
  append_bytes(out, sec7)
  append_ascii_string_bytes(out, "7777")
  Bytes::from_array(out)
}

///|
fn shift_section1_reference_time_for_test(
  section1_bytes : Bytes,
  unix_rt : Int64,
  hour_offset : Int,
) -> Result[Bytes, String] {
  if section1_bytes.length() < 19 {
    return Err("section1 bytes too short for mixed-reference rewrite")
  }
  let timestamp = format_timestamp14_from_unix(
    unix_rt + hour_offset.to_int64() * 3600L,
  )
  let (
    reference_year,
    reference_month,
    reference_day,
    reference_hour,
    reference_minute,
    reference_second,
  ) = match parse_timestamp14_components(timestamp) {
    Some(v) => v
    None => return Err("failed to shift mixed-reference section1 timestamp")
  }
  let out = section1_bytes.to_array()
  out[12] = ((reference_year >> 8) & 0xff).to_byte()
  out[13] = (reference_year & 0xff).to_byte()
  out[14] = reference_month.to_byte()
  out[15] = reference_day.to_byte()
  out[16] = reference_hour.to_byte()
  out[17] = reference_minute.to_byte()
  out[18] = reference_second.to_byte()
  Ok(Bytes::from_array(out))
}

///|
fn write_mixed_reference_netcdf_input(path : String) -> Result[Unit, String] {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      return Err("failed to parse mixed-reference source: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  if metas.length() == 0 {
    return Err("mixed-reference netcdf source fixture is empty")
  }
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err("failed to select mixed-reference netcdf source record")
  }
  let record_ref = refs[0]
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let original_bytes = build_submessage_grib_bytes_with_overrides(
    message,
    submessage,
    None,
    None,
    None,
    None,
  )
  let shifted_section1 = match
    shift_section1_reference_time_for_test(
      section_frame_bytes(message, message.section1),
      metas[record_ref.record_index - 1].unix_rt,
      6,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let shifted_bytes = build_submessage_grib_bytes_with_section1_override_for_test(
    message,
    submessage,
    Some(shifted_section1),
  )
  let out : Array[Byte] = []
  append_bytes(out, original_bytes)
  append_bytes(out, shifted_bytes)
  match native_write_bytes(path, Bytes::from_array(out)) {
    Ok(_) => Ok(())
    Err(e) => Err(e)
  }
}

///|
fn write_synthetic_mercator_netcdf_input(path : String) -> Result[Unit, String] {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      return Err("failed to parse synthetic Mercator source: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err("failed to select synthetic Mercator source record")
  }
  let record_ref = refs[0]
  let meta = metas[record_ref.record_index - 1]
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("synthetic Mercator source must be template 3.0")
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let lat1 = meta.section3_lat1_microdeg.to_double() * 0.000001
  let lat2 = meta.section3_lat2_microdeg.to_double() * 0.000001
  let lon1 = meta.section3_lon1_microdeg.to_double() * 0.000001
  let lon2 = meta.section3_lon2_microdeg.to_double() * 0.000001
  let south_lat = if (meta.section3_scanning_mode & 0x40) != 0 {
    lat1
  } else {
    lat2
  }
  let north_lat = if (meta.section3_scanning_mode & 0x40) != 0 {
    lat2
  } else {
    lat1
  }
  let west_lon = if (meta.section3_scanning_mode & 0x80) == 0 {
    lon1
  } else {
    lon2
  }
  let mut east_lon = if (meta.section3_scanning_mode & 0x80) == 0 {
    lon2
  } else {
    lon1
  }
  if east_lon <= west_lon {
    east_lon += 360.0
  }
  let latd = ((south_lat + north_lat) / 2.0).abs()
  let earth_radius_m = cress_lola_earth_radius_from_meta(meta)
  let scale = @math.cos(latd * @math.PI / 180.0)
  let dx_m = if meta.section3_ni > 1 {
    2.0 *
    @math.PI *
    earth_radius_m *
    scale *
    ((east_lon - west_lon) / (meta.section3_ni - 1).to_double()) /
    360.0
  } else {
    0.0
  }
  let dy_m = if meta.section3_nj > 1 {
    earth_radius_m *
    scale *
    (netcdf_mercator_projected_y(north_lat) -
    netcdf_mercator_projected_y(south_lat)).abs() /
    (meta.section3_nj - 1).to_double()
  } else {
    0.0
  }
  let section3 : @section3.Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: meta.section3_npts,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: @section3.GridTemplate310({
      shape_of_earth: meta.section3_shape_of_earth,
      scale_factor_radius: meta.section3_scale_factor_radius,
      scaled_value_radius: meta.section3_scaled_value_radius,
      scale_factor_major_axis: meta.section3_scale_factor_major,
      scaled_value_major_axis: meta.section3_scaled_value_major,
      scale_factor_minor_axis: meta.section3_scale_factor_minor,
      scaled_value_minor_axis: meta.section3_scaled_value_minor,
      ni: meta.section3_ni,
      nj: meta.section3_nj,
      la1: meta.section3_lat1_microdeg,
      lo1: if meta.section3_lon1_microdeg < 0 {
        meta.section3_lon1_microdeg + 360000000
      } else {
        meta.section3_lon1_microdeg
      },
      resolution_and_component_flags: meta.section3_resolution_flags,
      lad: (latd * 1000000.0 + 0.5).to_int(),
      la2: meta.section3_lat2_microdeg,
      lo2: if meta.section3_lon2_microdeg < 0 {
        meta.section3_lon2_microdeg + 360000000
      } else {
        meta.section3_lon2_microdeg
      },
      scanning_mode: meta.section3_scanning_mode,
      orientation_of_the_grid: 0,
      di: (dx_m * 1000.0 + 0.5).to_int(),
      dj: (dy_m * 1000.0 + 0.5).to_int(),
    }),
    optional_points_raw: b"",
  }
  let bytes = build_submessage_grib_bytes_with_section1_and_section3_override_for_test(
    message,
    submessage,
    None,
    Some(@lib.encode_section3_bytes(section3)),
  )
  native_write_bytes(path, bytes)
}

///|
fn write_synthetic_mercator_mixed_reference_netcdf_input(
  path : String,
) -> Result[Unit, String] {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to parse synthetic Mercator mixed-reference source: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err("failed to select synthetic Mercator mixed-reference source")
  }
  let record_ref = refs[0]
  let meta = metas[record_ref.record_index - 1]
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("synthetic Mercator mixed-reference source must be template 3.0")
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let lat1 = meta.section3_lat1_microdeg.to_double() * 0.000001
  let lat2 = meta.section3_lat2_microdeg.to_double() * 0.000001
  let lon1 = meta.section3_lon1_microdeg.to_double() * 0.000001
  let lon2 = meta.section3_lon2_microdeg.to_double() * 0.000001
  let south_lat = if (meta.section3_scanning_mode & 0x40) != 0 {
    lat1
  } else {
    lat2
  }
  let north_lat = if (meta.section3_scanning_mode & 0x40) != 0 {
    lat2
  } else {
    lat1
  }
  let west_lon = if (meta.section3_scanning_mode & 0x80) == 0 {
    lon1
  } else {
    lon2
  }
  let mut east_lon = if (meta.section3_scanning_mode & 0x80) == 0 {
    lon2
  } else {
    lon1
  }
  if east_lon <= west_lon {
    east_lon += 360.0
  }
  let latd = ((south_lat + north_lat) / 2.0).abs()
  let earth_radius_m = cress_lola_earth_radius_from_meta(meta)
  let scale = @math.cos(latd * @math.PI / 180.0)
  let dx_m = if meta.section3_ni > 1 {
    2.0 *
    @math.PI *
    earth_radius_m *
    scale *
    ((east_lon - west_lon) / (meta.section3_ni - 1).to_double()) /
    360.0
  } else {
    0.0
  }
  let dy_m = if meta.section3_nj > 1 {
    earth_radius_m *
    scale *
    (netcdf_mercator_projected_y(north_lat) -
    netcdf_mercator_projected_y(south_lat)).abs() /
    (meta.section3_nj - 1).to_double()
  } else {
    0.0
  }
  let section3 : @section3.Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: meta.section3_npts,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: @section3.GridTemplate310({
      shape_of_earth: meta.section3_shape_of_earth,
      scale_factor_radius: meta.section3_scale_factor_radius,
      scaled_value_radius: meta.section3_scaled_value_radius,
      scale_factor_major_axis: meta.section3_scale_factor_major,
      scaled_value_major_axis: meta.section3_scaled_value_major,
      scale_factor_minor_axis: meta.section3_scale_factor_minor,
      scaled_value_minor_axis: meta.section3_scaled_value_minor,
      ni: meta.section3_ni,
      nj: meta.section3_nj,
      la1: meta.section3_lat1_microdeg,
      lo1: if meta.section3_lon1_microdeg < 0 {
        meta.section3_lon1_microdeg + 360000000
      } else {
        meta.section3_lon1_microdeg
      },
      resolution_and_component_flags: meta.section3_resolution_flags,
      lad: (latd * 1000000.0 + 0.5).to_int(),
      la2: meta.section3_lat2_microdeg,
      lo2: if meta.section3_lon2_microdeg < 0 {
        meta.section3_lon2_microdeg + 360000000
      } else {
        meta.section3_lon2_microdeg
      },
      scanning_mode: meta.section3_scanning_mode,
      orientation_of_the_grid: 0,
      di: (dx_m * 1000.0 + 0.5).to_int(),
      dj: (dy_m * 1000.0 + 0.5).to_int(),
    }),
    optional_points_raw: b"",
  }
  let section3_bytes = @lib.encode_section3_bytes(section3)
  let original_bytes = build_submessage_grib_bytes_with_section1_and_section3_override_for_test(
    message,
    submessage,
    None,
    Some(section3_bytes),
  )
  let shifted_section1 = match
    shift_section1_reference_time_for_test(
      section_frame_bytes(message, message.section1),
      metas[record_ref.record_index - 1].unix_rt,
      6,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let shifted_bytes = build_submessage_grib_bytes_with_section1_and_section3_override_for_test(
    message,
    submessage,
    Some(shifted_section1),
    Some(section3_bytes),
  )
  let out : Array[Byte] = []
  append_bytes(out, original_bytes)
  append_bytes(out, shifted_bytes)
  native_write_bytes(path, Bytes::from_array(out))
}

///|
fn patch_grib_signed_u32_be(bytes : Bytes, offset : Int, value : Int) -> Bytes {
  if offset < 0 || offset + 4 > bytes.length() {
    return bytes
  }
  let magnitude = if value < 0 { -value } else { value }
  let sign_bit = if value < 0 { 0x80 } else { 0x00 }
  let out = bytes.to_array()
  out[offset] = ((((magnitude >> 24) & 0x7f) | sign_bit) & 0xff).to_byte()
  out[offset + 1] = ((magnitude >> 16) & 0xff).to_byte()
  out[offset + 2] = ((magnitude >> 8) & 0xff).to_byte()
  out[offset + 3] = (magnitude & 0xff).to_byte()
  Bytes::from_array(out)
}

///|
fn write_synthetic_rotated_latlon_netcdf_input(
  path : String,
) -> Result[Unit, String] {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to parse synthetic rotated lat-lon source: " + e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err("failed to select synthetic rotated lat-lon source record")
  }
  let record_ref = refs[0]
  let meta = metas[record_ref.record_index - 1]
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("synthetic rotated lat-lon source must be template 3.0")
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let section3 : @section3.Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: meta.section3_npts,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: @section3.GridTemplate31({
      base: {
        shape_of_earth: meta.section3_shape_of_earth,
        scale_factor_radius: meta.section3_scale_factor_radius,
        scaled_value_radius: meta.section3_scaled_value_radius,
        scale_factor_major_axis: meta.section3_scale_factor_major,
        scaled_value_major_axis: meta.section3_scaled_value_major,
        scale_factor_minor_axis: meta.section3_scale_factor_minor,
        scaled_value_minor_axis: meta.section3_scaled_value_minor,
        ni: meta.section3_ni,
        nj: meta.section3_nj,
        basic_angle: 0,
        subdivisions_of_basic_angle: 0,
        la1: meta.section3_lat1_microdeg,
        lo1: if meta.section3_lon1_microdeg < 0 {
          meta.section3_lon1_microdeg + 360000000
        } else {
          meta.section3_lon1_microdeg
        },
        resolution_and_component_flags: meta.section3_resolution_flags,
        la2: meta.section3_lat2_microdeg,
        lo2: if meta.section3_lon2_microdeg < 0 {
          meta.section3_lon2_microdeg + 360000000
        } else {
          meta.section3_lon2_microdeg
        },
        di: meta.section3_di_microdeg,
        dj: meta.section3_dj_microdeg,
        scanning_mode: meta.section3_scanning_mode,
      },
      latitude_of_southern_pole: -36088520,
      longitude_of_southern_pole: 245305142,
      angle_of_rotation: 0,
    }),
    optional_points_raw: b"",
  }
  let mut section3_bytes = @lib.encode_section3_bytes(section3)
  section3_bytes = patch_grib_signed_u32_be(
    section3_bytes,
    14 + 32,
    meta.section3_lat1_microdeg,
  )
  section3_bytes = patch_grib_signed_u32_be(
    section3_bytes,
    14 + 41,
    meta.section3_lat2_microdeg,
  )
  section3_bytes = patch_grib_signed_u32_be(section3_bytes, 14 + 58, -36088520)
  section3_bytes = patch_grib_signed_u32_be(section3_bytes, 14 + 66, 0)
  let bytes = build_submessage_grib_bytes_with_section1_and_section3_override_for_test(
    message,
    submessage,
    None,
    Some(section3_bytes),
  )
  native_write_bytes(path, bytes)
}

///|
fn write_synthetic_rotated_latlon_mixed_reference_netcdf_input(
  path : String,
) -> Result[Unit, String] {
  let single_path = "target/cmd_main_netcdf_rotated_single_base_input.grib2"
  match write_synthetic_rotated_latlon_netcdf_input(single_path) {
    Ok(_) => ()
    Err(e) =>
      return Err(
        "failed to write synthetic rotated lat-lon mixed-reference base: " + e,
      )
  }
  let context = match @lib.parse_with_io(native_read_bytes, single_path) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to parse synthetic rotated lat-lon mixed-reference base: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err(
      "failed to select synthetic rotated lat-lon mixed-reference source",
    )
  }
  let record_ref = refs[0]
  let meta = metas[record_ref.record_index - 1]
  if meta.section3_template.id() != 1 {
    return Err(
      "synthetic rotated lat-lon mixed-reference source must be template 3.1",
    )
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let original_bytes = build_submessage_grib_bytes_with_overrides(
    message,
    submessage,
    None,
    None,
    None,
    None,
  )
  let shifted_section1 = match
    shift_section1_reference_time_for_test(
      section_frame_bytes(message, message.section1),
      meta.unix_rt,
      6,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let shifted_bytes = build_submessage_grib_bytes_with_section1_override_for_test(
    message,
    submessage,
    Some(shifted_section1),
  )
  let out : Array[Byte] = []
  append_bytes(out, original_bytes)
  append_bytes(out, shifted_bytes)
  native_write_bytes(path, Bytes::from_array(out))
}

///|
fn write_synthetic_polar_stereographic_netcdf_input(
  path : String,
) -> Result[Unit, String] {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to parse synthetic polar stereographic source: " + e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err("failed to select synthetic polar stereographic source record")
  }
  let record_ref = refs[0]
  let meta = metas[record_ref.record_index - 1]
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("synthetic polar stereographic source must be template 3.0")
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let lon1 = if meta.section3_lon1_microdeg < 0 {
    meta.section3_lon1_microdeg + 360000000
  } else {
    meta.section3_lon1_microdeg
  }
  let section3 : @section3.Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: meta.section3_npts,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: @section3.GridTemplate320({
      shape_of_earth: meta.section3_shape_of_earth,
      scale_factor_radius: meta.section3_scale_factor_radius,
      scaled_value_radius: meta.section3_scaled_value_radius,
      scale_factor_major_axis: meta.section3_scale_factor_major,
      scaled_value_major_axis: meta.section3_scaled_value_major,
      scale_factor_minor_axis: meta.section3_scale_factor_minor,
      scaled_value_minor_axis: meta.section3_scaled_value_minor,
      nx: meta.section3_ni,
      ny: meta.section3_nj,
      la1: meta.section3_lat1_microdeg,
      lo1: lon1,
      resolution_and_component_flags: meta.section3_resolution_flags,
      lad: 60000000,
      lov: lon1,
      dx: 10000,
      dy: 10000,
      projection_center_flag: 0,
      scanning_mode: meta.section3_scanning_mode,
    }),
    optional_points_raw: b"",
  }
  let bytes = build_submessage_grib_bytes_with_section1_and_section3_override_for_test(
    message,
    submessage,
    None,
    Some(@lib.encode_section3_bytes(section3)),
  )
  native_write_bytes(path, bytes)
}

///|
fn write_synthetic_lambert_conformal_netcdf_input(
  path : String,
) -> Result[Unit, String] {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to parse synthetic Lambert conformal source: " + e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err("failed to select synthetic Lambert conformal source record")
  }
  let record_ref = refs[0]
  let meta = metas[record_ref.record_index - 1]
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("synthetic Lambert conformal source must be template 3.0")
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let lon1 = if meta.section3_lon1_microdeg < 0 {
    meta.section3_lon1_microdeg + 360000000
  } else {
    meta.section3_lon1_microdeg
  }
  let section3 : @section3.Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: meta.section3_npts,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: @section3.GridTemplate330({
      base: {
        shape_of_earth: meta.section3_shape_of_earth,
        scale_factor_radius: meta.section3_scale_factor_radius,
        scaled_value_radius: meta.section3_scaled_value_radius,
        scale_factor_major_axis: meta.section3_scale_factor_major,
        scaled_value_major_axis: meta.section3_scaled_value_major,
        scale_factor_minor_axis: meta.section3_scale_factor_minor,
        scaled_value_minor_axis: meta.section3_scaled_value_minor,
        nx: meta.section3_ni,
        ny: meta.section3_nj,
        la1: meta.section3_lat1_microdeg,
        lo1: lon1,
        resolution_and_component_flags: meta.section3_resolution_flags,
        lad: 60000000,
        lov: lon1,
        dx: 10000,
        dy: 10000,
        projection_center_flag: 0,
        scanning_mode: meta.section3_scanning_mode,
      },
      latin1: 30000000,
      latin2: 60000000,
      latitude_of_southern_pole: -90000000,
      longitude_of_southern_pole: 0,
    }),
    optional_points_raw: b"",
  }
  let bytes = build_submessage_grib_bytes_with_section1_and_section3_override_for_test(
    message,
    submessage,
    None,
    Some(@lib.encode_section3_bytes(section3)),
  )
  native_write_bytes(path, bytes)
}

///|
fn write_synthetic_polar_stereographic_mixed_reference_netcdf_input(
  path : String,
) -> Result[Unit, String] {
  let single_path = "target/cmd_main_netcdf_polar_single_base_input.grib2"
  match write_synthetic_polar_stereographic_netcdf_input(single_path) {
    Ok(_) => ()
    Err(e) =>
      return Err(
        "failed to write synthetic polar stereographic mixed-reference base: " +
        e,
      )
  }
  let context = match @lib.parse_with_io(native_read_bytes, single_path) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to parse synthetic polar stereographic mixed-reference base: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err(
      "failed to select synthetic polar stereographic mixed-reference source",
    )
  }
  let record_ref = refs[0]
  let meta = metas[record_ref.record_index - 1]
  if meta.section3_template.id() != 20 {
    return Err(
      "synthetic polar stereographic mixed-reference source must be template 3.20",
    )
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let original_bytes = build_submessage_grib_bytes_with_overrides(
    message,
    submessage,
    None,
    None,
    None,
    None,
  )
  let shifted_section1 = match
    shift_section1_reference_time_for_test(
      section_frame_bytes(message, message.section1),
      meta.unix_rt,
      6,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let shifted_bytes = build_submessage_grib_bytes_with_section1_override_for_test(
    message,
    submessage,
    Some(shifted_section1),
  )
  let out : Array[Byte] = []
  append_bytes(out, original_bytes)
  append_bytes(out, shifted_bytes)
  native_write_bytes(path, Bytes::from_array(out))
}

///|
fn write_synthetic_lambert_conformal_mixed_reference_netcdf_input(
  path : String,
) -> Result[Unit, String] {
  let single_path = "target/cmd_main_netcdf_lambert_single_base_input.grib2"
  match write_synthetic_lambert_conformal_netcdf_input(single_path) {
    Ok(_) => ()
    Err(e) =>
      return Err(
        "failed to write synthetic Lambert conformal mixed-reference base: " + e,
      )
  }
  let context = match @lib.parse_with_io(native_read_bytes, single_path) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to parse synthetic Lambert conformal mixed-reference base: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, Some([1]))
  if refs.length() != 1 {
    return Err(
      "failed to select synthetic Lambert conformal mixed-reference source",
    )
  }
  let record_ref = refs[0]
  let meta = metas[record_ref.record_index - 1]
  if meta.section3_template.id() != 30 {
    return Err(
      "synthetic Lambert conformal mixed-reference source must be template 3.30",
    )
  }
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let original_bytes = build_submessage_grib_bytes_with_overrides(
    message,
    submessage,
    None,
    None,
    None,
    None,
  )
  let shifted_section1 = match
    shift_section1_reference_time_for_test(
      section_frame_bytes(message, message.section1),
      meta.unix_rt,
      6,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let shifted_bytes = build_submessage_grib_bytes_with_section1_override_for_test(
    message,
    submessage,
    Some(shifted_section1),
  )
  let out : Array[Byte] = []
  append_bytes(out, original_bytes)
  append_bytes(out, shifted_bytes)
  native_write_bytes(path, Bytes::from_array(out))
}

///|
fn build_running_accumulated_forecast_values(
  fields : Array[Array[Double]],
) -> Array[Array[Double]] {
  let out : Array[Array[Double]] = []
  let mut running : Array[Double]? = None
  for field in fields {
    match running {
      None => {
        out.push(field)
        running = Some(field)
      }
      Some(previous) => {
        let merged = forecast_merge_values(Acc, previous, field)
        out.push(merged)
        running = Some(merged)
      }
    }
  }
  out
}

///|
fn expect_forecast_values_close(
  label : String,
  actual : Array[Double],
  expected : Array[Double],
) -> Result[Unit, String] {
  expect_forecast_values_close_with_min_tolerance(
    label, actual, expected, 0.006,
  )
}

///|
fn expect_forecast_values_close_with_min_tolerance(
  label : String,
  actual : Array[Double],
  expected : Array[Double],
  min_tolerance : Double,
) -> Result[Unit, String] {
  if actual.length() != expected.length() {
    return Err(
      label +
      ": length mismatch " +
      actual.length().to_string() +
      " != " +
      expected.length().to_string(),
    )
  }
  for index in 0..<actual.length() {
    let got = actual[index]
    let want = expected[index]
    if got != got || want != want {
      if got == got || want == want {
        return Err(label + ": NaN mismatch at index " + index.to_string())
      }
      continue
    }
    let scale = if want.abs() > 1.0 { want.abs() } else { 1.0 }
    let tolerance = if 0.0006 * scale > min_tolerance {
      0.0006 * scale
    } else {
      min_tolerance
    }
    if (got - want).abs() > tolerance {
      return Err(
        label +
        ": value mismatch at index " +
        index.to_string() +
        " got=" +
        got.to_string() +
        " want=" +
        want.to_string(),
      )
    }
  }
  Ok(())
}

///|
test "try_build_simple_packed_sections_with_scaling uses wgrib2 half-up quantization" {
  let built = try_build_simple_packed_sections_with_scaling(
    [0.0, 2.5],
    0,
    0,
    0,
    0,
  )
  let (sec5, sec7) = match built {
    Some(v) => v
    None => fail("expected simple packed sections")
  }
  let decoded5 = match @lib.decode_section5_bytes(sec5) {
    Ok(v) => v
    Err(e) => fail("failed to decode section5: " + e.to_string())
  }
  inspect(decoded5.number_of_data_points, content="2")
  match decoded5.template {
    DataRepresentationTemplate50(t50) => {
      inspect(t50.bits_per_value, content="2")
      let unpacked = match
        @lib.unpack_simple(
          sec7.sub(start=5).to_bytes(),
          t50.reference_value_ieee,
          t50.binary_scale_factor,
          t50.decimal_scale_factor,
          t50.bits_per_value,
          decoded5.number_of_data_points,
        ) {
        Ok(v) => v
        Err(e) => fail("failed to unpack section7: " + unpack_error_string(e))
      }
      inspect(unpacked.values[0], content="0")
      inspect(unpacked.values[1], content="3")
    }
    _ => fail("expected template 5.0")
  }
}

///|
fn fake_section_frame(
  section_number : Int,
  start : Int,
  length : Int,
) -> @lib.Grib2SectionFrame {
  { section_number, start, length }
}

///|
fn sample_grib_out_test_section3_bytes(
  ni : Int,
  nj : Int,
  scanning_mode : Int,
) -> Bytes {
  @lib.encode_section3_bytes({
    source_of_grid_definition: 0,
    number_of_data_points: ni * nj,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate30({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      ni,
      nj,
      basic_angle: 0,
      subdivisions_of_basic_angle: 0,
      la1: 1000000,
      lo1: 0,
      resolution_and_component_flags: 48,
      la2: 0,
      lo2: 2000000,
      di: 1000000,
      dj: 1000000,
      scanning_mode,
    }),
    optional_points_raw: b"",
  })
}

///|
test "parse_cli_invocation accepts init chain + action" {
  let tokens = [
    "-crlf", "-for_n", "1:5:2", "-match", "UGRD", "-not", "TMP", "-s",
  ]
  let parsed = match parse_cli_invocation(tokens) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.crlf, content="true")
  inspect(init.one_line, content="false")
  inspect(init.append_mode, content="false")
  inspect(init.output_big_endian, content="None")
  inspect(init.no_header, content="false")
  inspect(init.text_col, content="None")
  inspect(init.text_fmt, content="None")
  inspect(init.colon_delimiter, content="None")
  inspect(init.select_last, content="false")
  inspect(init.select_last0, content="false")
  inspect(init.inv_f77_mode, content="None")
  inspect(init.inv_f77_width, content="None")
  inspect(init.nl_out_path, content="None")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  inspect(init.for_n, content="Some(\"1:5:2\")")
  inspect(init.match_patterns.length(), content="1")
  inspect(init.not_patterns.length(), content="1")
  inspect(init.match_patterns[0], content="UGRD")
  inspect(init.not_patterns[0], content="TMP")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_for_n_spec accepts start:end (default step=1)" {
  match parse_for_n_spec("11:11") {
    Some((start, end, step)) => {
      inspect(start, content="11")
      inspect(end, content="11")
      inspect(step, content="1")
    }
    None => fail("expected valid start:end form")
  }
}

///|
test "parse_cli_invocation accepts -for_n start:end form" {
  let parsed = match parse_cli_invocation(["-for_n", "11:11", "-stats"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.for_n, content="Some(\"11:11\")")
  let is_stats = match action {
    Inventory(InventoryStats) => true
    _ => false
  }
  inspect(is_stats, content="true")
}

///|
test "parse_cli_invocation accepts append/no_header/text_fmt + endian + bin" {
  let parsed = match
    parse_cli_invocation([
      "-append", "-no_header", "-text_fmt", "%.2f", "-big_endian", "-for_n", "1:1:1",
      "-bin", "target/out.bin",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.append_mode, content="true")
  inspect(init.one_line, content="false")
  inspect(init.no_header, content="true")
  inspect(init.text_col, content="None")
  inspect(init.output_big_endian, content="Some(true)")
  inspect(init.text_fmt, content="Some(\"%.2f\")")
  inspect(init.colon_delimiter, content="None")
  inspect(init.select_last, content="false")
  inspect(init.select_last0, content="false")
  inspect(init.inv_f77_mode, content="None")
  inspect(init.inv_f77_width, content="None")
  inspect(init.nl_out_path, content="None")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  let is_bin = match action {
    WriteBin("target/out.bin") => true
    _ => false
  }
  inspect(is_bin, content="true")
}

///|
test "parse_cli_invocation accepts write_sec action" {
  let parsed = match
    parse_cli_invocation([
      "-for_n", "1:1:1", "-write_sec", "0", "target/out.sec0",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.for_n, content="Some(\"1:1:1\")")
  let is_write_sec = match action {
    WriteSection(0, "target/out.sec0") => true
    _ => false
  }
  inspect(is_write_sec, content="true")
}

///|
test "parse_cli_invocation supports grib_out alias and csv_long action" {
  let p1 = match parse_cli_invocation(["-grib_out", "target/o.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteGribOut("target/o.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-csv_long", "target/o.csv"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteCsv("target/o.csv", true) => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match parse_cli_invocation(["-tosubmsg", "target/o_sub.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteToSubmsg("target/o_sub.grb2") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports AAIG aliases" {
  let p1 = match parse_cli_invocation(["-AAIG", "target/o.asc"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteAaig("target/o.asc", false) => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-AAIGlong", "target/o_long"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteAaig("target/o_long", true) => true
    _ => false
  }
  inspect(ok2, content="true")
}

///|
test "format_data_value normalizes JMA text output through float32" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse JMA fixture: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(_) => fail("failed to unpack JMA record")
  }
  let idx = match value_index_for_ij(meta, 1, 2) {
    Some(v) => v
    None => fail("failed to resolve ij index for JMA record")
  }
  inspect(format_data_value(unpacked.values[idx]), content="102634")
}

///|
test "format_data_value rounds exact .5 values to even" {
  inspect(format_data_value(102634.5), content="102634")
  inspect(format_data_value(102659.5), content="102660")
  inspect(format_data_value(102609.5), content="102610")
  inspect(format_data_value(102559.5), content="102560")
}

///|
test "format_data_value matches JMA tie points on second row" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse JMA fixture: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(_) => fail("failed to unpack JMA record")
  }
  let idx16 = match value_index_for_ij(meta, 16, 2) {
    Some(v) => v
    None => fail("failed to resolve ij index for JMA tie point 16,2")
  }
  let idx139 = match value_index_for_ij(meta, 139, 2) {
    Some(v) => v
    None => fail("failed to resolve ij index for JMA tie point 139,2")
  }
  let idx201 = match value_index_for_ij(meta, 201, 2) {
    Some(v) => v
    None => fail("failed to resolve ij index for JMA tie point 201,2")
  }
  let v16 = unpacked.values[idx16]
  let v139 = unpacked.values[idx139]
  let v201 = unpacked.values[idx201]
  inspect(format_data_value(v16), content="102660")
  inspect(format_data_value(v139), content="102610")
  inspect(format_data_value(v201), content="102560")
}

///|
test "parse_cli_invocation supports grib_ieee output" {
  let p = match parse_cli_invocation(["-grib_ieee", "target/grib_ieee_base"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteGribIeee("target/grib_ieee_base") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports ijbox output" {
  let p = match
    parse_cli_invocation(["-ijbox", "1:2:1", "1:3:1", "target/ij.txt", "text"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteIjbox("1:2:1", "1:3:1", "target/ij.txt", "text") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports ijsmall_grib output" {
  let p = match
    parse_cli_invocation([
      "-ijsmall_grib", "1:360:1", "1:181:1", "target/s.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteIjsmallGrib("1:360:1", "1:181:1", "target/s.grb2") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports small_grib output" {
  let p = match
    parse_cli_invocation(["-small_grib", "0:359", "-90:90", "target/small.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteSmallGrib("0:359", "-90:90", "target/small.grb2") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports lola output" {
  let p = match
    parse_cli_invocation([
      "-lola", "0:360:1", "-90:181:1", "target/lola.bin", "bin",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteLola("0:360:1", "-90:181:1", "target/lola.bin", "bin") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports cress_lola output" {
  let p = match
    parse_cli_invocation([
      "-cress_lola", "0:360:1", "-90:181:1", "target/cress_lola.grb2", "0:-1:2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteCressLola("0:360:1", "-90:181:1", "target/cress_lola.grb2", "0:-1:2") =>
      true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports cubeface/irr_grid/grib_out_irr/grib_out_irr2/new_grid/new_grid_order" {
  let pc = match
    parse_cli_invocation(["-cubeface2global", "0", "target/cubeface.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, ac) = pc
  let okc = match ac {
    WriteCubeface2Global => true
    _ => false
  }
  inspect(okc, content="true")

  let p0 = match
    parse_cli_invocation([
      "-irr_grid", "0:90:1:89", "100", "target/irr_grid.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a0) = p0
  let ok0 = match a0 {
    WriteIrrGrid("0:90:1:89", "100", "target/irr_grid.grb2") => true
    _ => false
  }
  inspect(ok0, content="true")

  let p1 = match
    parse_cli_invocation(["-grib_out_irr", "all", "target/irr.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteGribOutIrr("all", "target/irr.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match
    parse_cli_invocation([
      "-grib_out_irr2", "10", "1", "0", "00000000-0000-0000-0000-000000000000", "target/irr2.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteGribOutIrr2(
      "10",
      "1",
      "0",
      "00000000-0000-0000-0000-000000000000",
      "target/irr2.grb2"
    ) => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match
    parse_cli_invocation([
      "-new_grid", "latlon", "0:360:1", "-90:181:1", "target/new_grid.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteNewGrid("latlon", "0:360:1", "-90:181:1", "target/new_grid.grb2") =>
      true
    _ => false
  }
  inspect(ok3, content="true")

  let p4 = match
    parse_cli_invocation([
      "-new_grid_order", "target/order_out.grb2", "target/order_out2.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a4) = p4
  let ok4 = match a4 {
    WriteNewGridOrder("target/order_out.grb2", "target/order_out2.grb2") => true
    _ => false
  }
  inspect(ok4, content="true")

  let p5 = match parse_cli_invocation(["-netcdf", "target/out.nc"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a5) = p5
  let ok5 = match a5 {
    WriteNetcdf("target/out.nc") => true
    _ => false
  }
  inspect(ok5, content="true")
}

///|
test "parse_cli_invocation supports mysql unavailable actions" {
  let p1 = match
    parse_cli_invocation([
      "-mysql", "H=localhost", "U=user", "P=pass", "D=db", "T=table",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteMysql => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match
    parse_cli_invocation([
      "-mysql_dump", "H=localhost", "U=user", "P=pass", "D=db", "T=table", "W=0",
      "PV=0",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteMysqlDump => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match
    parse_cli_invocation([
      "-mysql_speed", "H=localhost", "U=user", "P=pass", "D=db", "T=table", "W=0",
      "PV=0",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteMysqlSpeed => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports submsg_uv and ncep_uv" {
  let p1 = match parse_cli_invocation(["-submsg_uv", "target/submsg.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteSubmsgUv("target/submsg.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-ncep_uv", "target/ncep.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteNcepUv("target/ncep.grb2") => true
    _ => false
  }
  inspect(ok2, content="true")
}

///|
test "parse_cli_invocation supports reduced_gaussian_grid" {
  let p = match
    parse_cli_invocation([
      "-reduced_gaussian_grid", "target/rg.grb2", "-1", "neighbor",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteReducedGaussianGrid("target/rg.grb2", "-1", "neighbor") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports ncep_norm/merge_fcst/unmerge_fcst" {
  let p1 = match parse_cli_invocation(["-ncep_norm", "target/norm.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteNcepNorm("target/norm.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match
    parse_cli_invocation(["-merge_fcst", "0", "target/merge.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteMergeFcst("0", "target/merge.grb2") => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match
    parse_cli_invocation(["-unmerge_fcst", "target/unmerge.grb2", "0hr", "0"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteUnmergeFcst("target/unmerge.grb2", "0hr", "0") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports ave/fcst_ave/time_processing out options" {
  let p1 = match parse_cli_invocation(["-ave", "6hr", "target/ave.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteAve("6hr", "target/ave.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-ave0", "6hr", "target/ave0.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteAve0("6hr", "target/ave0.grb2") => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match
    parse_cli_invocation(["-ave_var", "6hr", "target/ave_var.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteAveVar("6hr", "target/ave_var.grb2") => true
    _ => false
  }
  inspect(ok3, content="true")

  let p3 = match
    parse_cli_invocation(["-fcst_ave", "6hr", "target/fcst_ave.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a4) = p3
  let ok4 = match a4 {
    WriteFcstAve("6hr", "target/fcst_ave.grb2") => true
    _ => false
  }
  inspect(ok4, content="true")

  let p4 = match
    parse_cli_invocation(["-fcst_ave0", "6hr", "target/fcst_ave0.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a5) = p4
  let ok5 = match a5 {
    WriteFcstAve0("6hr", "target/fcst_ave0.grb2") => true
    _ => false
  }
  inspect(ok5, content="true")

  let p5 = match
    parse_cli_invocation([
      "-time_processing", "0", "1", "6hr", "target/timep.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a6) = p5
  let ok6 = match a6 {
    WriteTimeProcessing("0", "1", "6hr", "target/timep.grb2") => true
    _ => false
  }
  inspect(ok6, content="true")

  let p6 = match
    parse_cli_invocation(["-ens_processing", "target/ens.grb2", "0"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a7) = p6
  let ok7 = match a7 {
    WriteEnsProcessing("target/ens.grb2", "0") => true
    _ => false
  }
  inspect(ok7, content="true")

  let p7 = match
    parse_cli_invocation([
      "-ens_qc", "target/stats.grb2", "target/extreme.grb2", "target/extreme.txt",
      "1",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a8) = p7
  let ok8 = match a8 {
    WriteEnsQc(
      "target/stats.grb2",
      "target/extreme.grb2",
      "target/extreme.txt",
      "1"
    ) => true
    _ => false
  }
  inspect(ok8, content="true")
}

///|
test "parse_cli_invocation supports wind derived out options" {
  let p1 = match parse_cli_invocation(["-wind_speed", "target/ws.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteWindSpeed("target/ws.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-wind_dir", "target/wd.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteWindDir("target/wd.grb2") => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match parse_cli_invocation(["-wind_uv", "target/wuv.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteWindUv("target/wuv.grb2") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "unavailable_out_action_lines matches wgrib2 messages" {
  inspect(
    unavailable_out_action_lines(WriteCubeface2Global),
    content="Some([\"\", \"*** FATAL ERROR: cubeface2global: not installed ***\", \"\"])",
  )
  inspect(
    unavailable_out_action_lines(WriteMysql),
    content="Some([\"mysql package not installed\"])",
  )
  inspect(
    unavailable_out_action_lines(WriteText("target/out.txt")),
    content="None",
  )
}

///|
test "netcdf_wgrib2_fatal_lines matches reduced Gaussian wgrib2 message" {
  let fixture = "fixtures/grib2_jpeg2000/eccodes_reduced_gaussian_surface_jpeg.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse reduced Gaussian fixture: " + e.to_string())
  }
  inspect(
    netcdf_wgrib2_fatal_lines(context, Some([1])),
    content="Some([\"1:0\", \"*** FATAL ERROR: netcdf: only works in we:sn order ***\", \"\"])",
  )
}

///|
test "netcdf_wgrib2_fatal_lines_for_reason matches mixed-grid fresh fatal lines" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse mixed-grid fixture: " + e.to_string())
  }
  let lines = netcdf_wgrib2_fatal_lines_for_reason(
    context,
    None,
    NetcdfMixedGridType(78, 79),
  )
  inspect(lines[0], content="1.1:0:d=2024120600:PRMSL:mean sea level:anl:")
  inspect(lines[77], content="1.78:0:d=2024120600:VVEL:100 mb:anl:")
  inspect(lines[78], content="")
  inspect(
    lines[79],
    content="*** FATAL ERROR: netcdf: only one grid type at a time ***",
  )
  inspect(lines[80], content="")
  inspect(lines[81], content="1.79:0")
}

///|
test "netcdf_wgrib2_fatal_lines_for_reason matches mixed-grid append fatal lines" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse mixed-grid fixture: " + e.to_string())
  }
  let selected : Array[Int] = []
  for i in 2..<=79 {
    selected.push(i)
  }
  let lines = netcdf_wgrib2_fatal_lines_for_reason(
    context,
    Some(selected),
    NetcdfMixedGridType(77, 79),
  )
  inspect(lines[0], content="1.2:0:d=2024120600:PRES:surface:anl:")
  inspect(lines[76], content="1.78:0:d=2024120600:VVEL:100 mb:anl:")
  inspect(lines[77], content="")
  inspect(
    lines[78],
    content="*** FATAL ERROR: netcdf: only one grid type at a time ***",
  )
  inspect(lines[79], content="")
  inspect(lines[80], content="1.79:0")
}

///|
test "netcdf_wgrib2_notice_lines matches rotated lat-lon wgrib2 message" {
  let fixture = "target/cmd_main_netcdf_rotated_input.grib2"
  match write_synthetic_rotated_latlon_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic rotated lat-lon fixture: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic rotated lat-lon fixture: " + e.to_string(),
      )
  }
  inspect(
    netcdf_wgrib2_notice_lines(context, Some([1])),
    content="Some([\"netcdf: doesn't support yet grid_template 1\", \"1:0:d=2026022100:PRMSL:mean sea level:anl:\"])",
  )
}

///|
test "netcdf_wgrib2_notice_lines ignores polar stereographic like current wgrib2" {
  let fixture = "target/cmd_main_netcdf_polar_input.grib2"
  match write_synthetic_polar_stereographic_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) =>
      fail("failed to write synthetic polar stereographic fixture: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic polar stereographic fixture: " +
        e.to_string(),
      )
  }
  inspect(netcdf_wgrib2_notice_lines(context, Some([1])), content="None")
}

///|
test "netcdf_wgrib2_notice_lines ignores Lambert conformal like current wgrib2" {
  let fixture = "target/cmd_main_netcdf_lambert_input.grib2"
  match write_synthetic_lambert_conformal_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic Lambert conformal fixture: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic Lambert conformal fixture: " + e.to_string(),
      )
  }
  inspect(netcdf_wgrib2_notice_lines(context, Some([1])), content="None")
}

///|
test "parse_cli_invocation supports gridout/gribtable_used" {
  let p1 = match parse_cli_invocation(["-gridout", "target/grid.txt"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteGridout("target/grid.txt") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-gribtable_used", "target/table.txt"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteGribtableUsed("target/table.txt") => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match parse_cli_invocation(["-export_lonlat", "target/lonlat.bin"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteExportLonlat("target/lonlat.bin") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports count/config and end flag" {
  let p1 = match parse_cli_invocation(["-count"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i1, a1) = p1
  inspect(i1.stop_after_first, content="false")
  inspect(i1.one_line, content="false")
  let ok1 = match a1 {
    CountOnly => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-config"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    ConfigOnly => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match parse_cli_invocation(["-end", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i3, a3) = p3
  inspect(i3.stop_after_first, content="true")
  let ok3 = match a3 {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(ok3, content="true")

  let p4 = match parse_cli_invocation(["-quit", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i4, a4) = p4
  inspect(i4.stop_after_first, content="true")
  let ok4 = match a4 {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(ok4, content="true")
}

///|
test "parse_cli_invocation supports one_line and timer no-op options" {
  let parsed = match
    parse_cli_invocation(["-start_timer", "-timer", "-fi", "-one_line", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.one_line, content="true")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation supports text_col and colon" {
  let parsed = match
    parse_cli_invocation(["-text_col", "12", "-colon", "|", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.text_col, content="Some(12)")
  inspect(init.colon_delimiter, content="Some(\"|\")")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation supports for alias" {
  let parsed = match parse_cli_invocation(["-for", "2:4:1", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.for_n, content="Some(\"2:4:1\")")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation supports error_final count condition" {
  let parsed = match
    parse_cli_invocation([
      "-for_n", "1:1:1", "-error_final", "count", "eq", "1", "-s",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.for_n, content="Some(\"1:1:1\")")
  let ok_cond = match init.error_final_count {
    Some({ op: ErrorFinalEq, expected: 1 }) => true
    _ => false
  }
  inspect(ok_cond, content="true")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation accepts print_out and last options" {
  let parsed = match
    parse_cli_invocation([
      "-for_n", "1:9:2", "-last0", "-print_out", "target/out.txt", "-print",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.select_last, content="false")
  inspect(init.select_last0, content="true")
  inspect(init.inv_f77_mode, content="None")
  inspect(init.inv_f77_width, content="None")
  inspect(init.inventory_path, content="Some(\"target/out.txt\")")
  inspect(init.nl_out_path, content="None")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation accepts inv_f77 output arguments" {
  let parsed = match
    parse_cli_invocation([
      "-for_n", "1:1:1", "-inv_f77", "bin", "80", "target/inv_f77.txt", "-s",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.inv_f77_mode, content="Some(\"bin\")")
  inspect(init.inv_f77_width, content="Some(80)")
  inspect(init.inventory_path, content="Some(\"target/inv_f77.txt\")")
  inspect(init.nl_out_path, content="None")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_mode supports added compatibility aliases" {
  let m1 = parse_mode(["-gdt"])
  let m2 = parse_mode(["-timer"])
  let m3 = parse_mode(["-ctl_inv"])
  let m4 = parse_mode(["-pyinv"])
  let m5 = parse_mode(["-spectral_bands_extname"])
  let m6 = parse_mode(["-proj4_ij2ll", "10", "20"])
  let m7 = parse_mode(["-proj4_ll2ij", "139.5", "35.6"])
  let m8 = parse_mode(["-proj4_ll2i", "139.5", "35.6"])
  inspect(m1, content="Some(InventoryGdt)")
  inspect(m2, content="Some(InventoryTimer)")
  inspect(m3, content="Some(InventoryCtlInv)")
  inspect(m4, content="Some(InventoryPyinv)")
  inspect(m5, content="Some(InventorySpectralBandsExtname)")
  inspect(m6, content="Some(InventoryIJLat(10, 20))")
  inspect(m7, content="Some(InventoryLL2IJ(139.5, 35.6))")
  inspect(m8, content="Some(InventoryLL2I(139.5, 35.6))")
}

///|
test "apply_init_filters applies for_n + match + not" {
  let lines = [
    "1:0:d=2026022100:UGRD:surface:anl:", "2:10:d=2026022100:TMP:surface:anl:", "3:20:d=2026022100:UGRD:surface:anl:",
    "4:30:d=2026022100:VGRD:surface:anl:", "5:40:d=2026022100:UGRD:surface:anl:",
  ]
  let init : CliInitOptions = {
    crlf: false,
    one_line: false,
    append_mode: false,
    output_big_endian: None,
    no_header: false,
    text_col: None,
    text_fmt: None,
    colon_delimiter: None,
    select_last: false,
    select_last0: false,
    inv_f77_mode: None,
    inv_f77_width: None,
    nl_out_path: None,
    print_out_text: None,
    print_out_path: None,
    new_grid_interpolation: None,
    for_n: Some("1:5:2"),
    match_patterns: ["UGRD"],
    not_patterns: ["TMP"],
    inventory_path: None,
    stop_after_first: false,
    error_final_count: None,
  }
  let filtered = match apply_init_filters(lines, init) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(filtered.length(), content="3")
  inspect(filtered[0], content="1:0:d=2026022100:UGRD:surface:anl:")
  inspect(filtered[1], content="3:20:d=2026022100:UGRD:surface:anl:")
  inspect(filtered[2], content="5:40:d=2026022100:UGRD:surface:anl:")
}

///|
test "apply_init_filters applies end shortcut" {
  let lines = [
    "1:0:d=2026022100:UGRD:surface:anl:", "2:10:d=2026022100:TMP:surface:anl:", "3:20:d=2026022100:UGRD:surface:anl:",
  ]
  let init : CliInitOptions = {
    ..default_init_options(),
    stop_after_first: true,
  }
  let filtered = match apply_init_filters(lines, init) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(filtered.length(), content="1")
  inspect(filtered[0], content="1:0:d=2026022100:UGRD:surface:anl:")
}

///|
test "apply_init_filters supports for_n on n.m inventory numbering" {
  let lines = [
    "1.1:0:d=2024120600:PRMSL:mean sea level:anl:", "1.2:0:d=2024120600:PRES:surface:anl:",
    "2.1:100:d=2024120600:UGRD:10 m above ground:anl:", "2.2:100:d=2024120600:VGRD:10 m above ground:anl:",
  ]
  let init : CliInitOptions = { ..default_init_options(), for_n: Some("2:2") }
  let filtered = match apply_init_filters(lines, init) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(filtered.length(), content="1")
  inspect(filtered[0], content="1.2:0:d=2024120600:PRES:surface:anl:")
}

///|
test "run_cli supports -crlf -inv with filtered inventory output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_inv_test.txt"
  let args = [
    "grib2_mbt", fixture, "-crlf", "-for_n", "1:3:1", "-inv", out, "-s",
  ]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(count_crlf_pairs(bytes), content="3")
}

///|
test "run_cli supports -count output to file with filters" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_count_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:3:1", "-inv", out, "-count",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read count output: " + e.to_string())
  }
  inspect(body, content="3\n")
}

///|
test "run_cli applies -for_n on n.m style inventories" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let out = "target/cmd_main_for_n_dot_style_inv.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1", "-inv", out, "-s"])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body.length() > 0, content="true")
  inspect(body.contains("1.1:"), content="true")
}

///|
test "run_cli supports -error_final for count in inventory mode" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:3:1", "-error_final", "count", "eq", "3",
    "-s",
  ])
  inspect(exit, content="8")
}

///|
test "run_cli supports -error_final for count in output mode" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_error_final_bin_test.bin"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-error_final", "count", "eq", "1",
    "-bin", out,
  ])
  inspect(exit, content="8")
}

///|
test "run_cli supports -config output to file" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_config_test.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-inv", out, "-config"])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read config output: " + e.to_string())
  }
  inspect(body.contains("grib2_mbt config"), content="true")
  inspect(body.contains("engine=moonbit"), content="true")
}

///|
test "run_cli supports -AAIG output with wgrib2 layout" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_aaig_test.asc"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-AAIG", out])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read aaig output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let text = line.to_string()
    if text.length() > 0 {
      lines.push(text)
    }
  }
  inspect(line_count(out), content="65166")
  inspect(lines[0], content="ncols 360")
  inspect(lines[1], content="nrows 181")
  inspect(lines[2], content="xllcenter 0.000000")
  inspect(lines[3], content="yllcenter -90.000000")
  inspect(lines[4], content="cellsize 1.000000")
  inspect(lines[5], content="NODATA_VALUE 9.999e20")
  inspect(lines[6], content="102271.843750")
}

///|
test "run_cli supports -AAIGlong output with .asc suffix" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let base = "target/cmd_main_aaiglong_test"
  let out = base + ".asc"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-AAIGlong", base,
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read aaiglong output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let text = line.to_string()
    if text.length() > 0 {
      lines.push(text)
    }
  }
  inspect(lines[0], content="ncols 360")
  inspect(lines[5], content="NODATA_VALUE 9.999e20")
}

///|
test "run_cli supports -AAIG output with wrapped lon and nodata rendering" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_aaig_gfswave_test.asc"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-AAIG", out])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read gfswave aaig output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let text = line.to_string()
    if text.length() > 0 {
      lines.push(text)
    }
  }
  inspect(line_count(out), content="99637")
  inspect(lines[2], content="xllcenter -100.000000")
  inspect(lines[3], content="yllcenter 0.000000")
  inspect(lines[6], content="999900026055400882176.000000")
}

///|
test "run_cli supports -grib_ieee split outputs" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let base = "target/cmd_main_grib_ieee_test"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_ieee", base,
  ])
  inspect(exit, content="0")
  let grb = @fs.read_file_to_bytes(base + ".grb") catch {
    e => fail("failed to read .grb: " + e.to_string())
  }
  let head = @fs.read_file_to_bytes(base + ".head") catch {
    e => fail("failed to read .head: " + e.to_string())
  }
  let tail = @fs.read_file_to_bytes(base + ".tail") catch {
    e => fail("failed to read .tail: " + e.to_string())
  }
  let h = @fs.read_file_to_string(base + ".h") catch {
    e => fail("failed to read .h: " + e.to_string())
  }
  inspect(grb.length(), content="260810")
  inspect(head.length(), content="166")
  inspect(tail.length(), content="4")
  inspect(grb.length() > head.length() + tail.length(), content="true")
  inspect(head[head.length() - 1].to_int(), content="7")
  inspect(h.contains("unsigned char head[] = {"), content="true")
  inspect(h.contains("#define NDATA 65160"), content="true")
  inspect(h.contains("#define SEC7 161"), content="true")
  inspect(
    h.contains("unsigned char sec7[4] = {55, 55, 55, 55};"),
    content="true",
  )
  inspect(grb[0].to_int(), content="71")
  inspect(grb[1].to_int(), content="82")
  inspect(grb[2].to_int(), content="73")
  inspect(grb[3].to_int(), content="66")
}

///|
test "run_cli grib_ieee uses first selected record" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let base_first = "target/cmd_main_grib_ieee_first_only"
  let base_range = "target/cmd_main_grib_ieee_range"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_ieee", base_first]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-grib_ieee", base_range]),
    content="0",
  )
  let first_grb = @fs.read_file_to_bytes(base_first + ".grb") catch {
    e => fail("failed to read first .grb: " + e.to_string())
  }
  let range_grb = @fs.read_file_to_bytes(base_range + ".grb") catch {
    e => fail("failed to read range .grb: " + e.to_string())
  }
  let first_head = @fs.read_file_to_bytes(base_first + ".head") catch {
    e => fail("failed to read first .head: " + e.to_string())
  }
  let range_head = @fs.read_file_to_bytes(base_range + ".head") catch {
    e => fail("failed to read range .head: " + e.to_string())
  }
  let first_h = @fs.read_file_to_string(base_first + ".h") catch {
    e => fail("failed to read first .h: " + e.to_string())
  }
  let range_h = @fs.read_file_to_string(base_range + ".h") catch {
    e => fail("failed to read range .h: " + e.to_string())
  }
  inspect(first_grb == range_grb, content="true")
  inspect(first_head == range_head, content="true")
  inspect(first_h == range_h, content="true")
}

///|
test "run_cli supports -ijbox text mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_ijbox_text_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-ijbox", "1:2:1", "1:2:1", out, "text",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read ijbox text output: " + e.to_string())
  }
  inspect(body, content="2 2\n102136\n102136\n102011\n102011\n")
}

///|
test "run_cli supports -ijbox spread mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_ijbox_spread_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-ijbox", "1:3:1", "1:2:1", out, "spread",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read ijbox spread output: " + e.to_string())
  }
  inspect(
    body,
    content=" i-index, j-index, value,\n" +
      "1, 1, 102136,\n" +
      "2, 1, 102136,\n" +
      "3, 1, 102136,\n" +
      "1, 2, 102011,\n" +
      "2, 2, 102011,\n" +
      "3, 2, 102008,\n",
  )
}

///|
test "run_cli supports -ijbox bin mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_ijbox_bin_test.bin"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-ijbox", "1:2:1", "1:2:1", out, "bin",
  ])
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read ijbox bin output: " + e.to_string())
  }
  inspect(bytes.length(), content="24")
  inspect(bytes[0].to_int(), content="16")
  inspect(bytes[1].to_int(), content="0")
  inspect(bytes[2].to_int(), content="0")
  inspect(bytes[3].to_int(), content="0")
  inspect(bytes[20].to_int(), content="16")
  inspect(bytes[21].to_int(), content="0")
  inspect(bytes[22].to_int(), content="0")
  inspect(bytes[23].to_int(), content="0")
}

///|
test "run_cli supports -version without input file" {
  let exit = run_cli(["grib2_mbt", "-version"])
  inspect(exit, content="0")
}

///|
test "run_cli supports -colon replacement in inventory output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_colon_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-colon", "|", "-inv", out, "-s",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read colon output: " + e.to_string())
  }
  inspect(body.contains("|"), content="true")
  inspect(body.contains(":"), content="false")
}

///|
test "split_line_by_columns splits by requested width" {
  let chunks = split_line_by_columns("abcdefghij", 4)
  inspect(chunks.length(), content="3")
  inspect(chunks[0], content="abcd")
  inspect(chunks[1], content="efgh")
  inspect(chunks[2], content="ij")
}

///|
test "run_cli supports -one_line inventory output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_one_line_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:2:1", "-one_line", "-inv", out, "-s",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read one_line output: " + e.to_string())
  }
  inspect(line_count(out), content="1")
  inspect(body.contains("1:"), content="true")
  inspect(body.contains("2:"), content="true")
}

///|
test "run_cli supports -print_out and -last filter" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_print_out_last_test.txt"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:3:1", "-last", "-print_out", out, "-print",
  ]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines.length(), content="1")
  inspect(lines[0].has_prefix("3:"), content="true")
}

///|
test "run_cli supports -s_out alias" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_s_out_test.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-s_out", out])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body.contains("1:"), content="true")
}

///|
test "parse_cli_invocation accepts nl_out option" {
  let parsed = match parse_cli_invocation(["-nl_out", "target/nl.txt", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.nl_out_path, content="Some(\"target/nl.txt\")")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "run_cli supports -nl_out side effect file" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_nl_out_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-nl_out", out, "-s",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body, content="\n")
}

///|
test "parse_cli_invocation accepts last/last0 with output path" {
  let p1 = match
    parse_cli_invocation(["-for_n", "1:5:1", "-last", "target/a.txt", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i1, _) = p1
  inspect(i1.select_last, content="true")
  inspect(i1.select_last0, content="false")
  inspect(i1.inventory_path, content="Some(\"target/a.txt\")")
  let p2 = match parse_cli_invocation(["-last0", "target/b.txt", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i2, _) = p2
  inspect(i2.select_last, content="false")
  inspect(i2.select_last0, content="true")
  inspect(i2.inventory_path, content="Some(\"target/b.txt\")")
}

///|
test "parse_cli_invocation accepts print_out string + path form" {
  let parsed = match
    parse_cli_invocation(["-print_out", "hello", "target/p.txt", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, _) = parsed
  inspect(init.print_out_text, content="Some(\"hello\")")
  inspect(init.print_out_path, content="Some(\"target/p.txt\")")
}

///|
test "run_cli supports -print_out string + path side effect" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_print_out_xy_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-print_out", "hello", out, "-s",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body, content="hello\n")
}

///|
test "run_cli supports -inv_f77 path output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_inv_f77_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-inv_f77", "bin", "80", out, "-s",
  ])
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output bytes: " + e.to_string())
  }
  inspect(bytes.length(), content="88")
  inspect(bytes[0].to_int(), content="80")
  inspect(bytes[1].to_int(), content="0")
  inspect(bytes[2].to_int(), content="0")
  inspect(bytes[3].to_int(), content="0")
  inspect(bytes[84].to_int(), content="80")
  inspect(bytes[85].to_int(), content="0")
  inspect(bytes[86].to_int(), content="0")
  inspect(bytes[87].to_int(), content="0")
}

///|
test "run_cli supports -inv_f77 ieee marker endianness" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_inv_f77_ieee_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-inv_f77", "ieee", "80", out, "-s",
  ])
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output bytes: " + e.to_string())
  }
  inspect(bytes.length(), content="88")
  inspect(bytes[0].to_int(), content="0")
  inspect(bytes[1].to_int(), content="0")
  inspect(bytes[2].to_int(), content="0")
  inspect(bytes[3].to_int(), content="80")
  inspect(bytes[84].to_int(), content="0")
  inspect(bytes[85].to_int(), content="0")
  inspect(bytes[86].to_int(), content="0")
  inspect(bytes[87].to_int(), content="80")
}

///|
test "parse_cli_invocation validates inv_f77 arguments" {
  let bad_mode = parse_cli_invocation(["-inv_f77", "txt", "80", "x", "-s"])
  let bad_width = parse_cli_invocation(["-inv_f77", "bin", "x", "y", "-s"])
  let bad_width2 = parse_cli_invocation(["-inv_f77", "ieee", "0", "y", "-s"])
  let ok_mode = match bad_mode {
    Err("-(dummy)") => false
    Err(msg) => msg.contains("mode")
    Ok(_) => false
  }
  let ok_width = match bad_width {
    Err(msg) => msg.contains("width")
    Ok(_) => false
  }
  let ok_width2 = match bad_width2 {
    Err(msg) => msg.contains("width")
    Ok(_) => false
  }
  inspect(ok_mode, content="true")
  inspect(ok_width, content="true")
  inspect(ok_width2, content="true")
}

///|
test "run_cli supports -grib output with byte-identical copy" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_test.grib2"
  let args = ["grib2_mbt", fixture, "-grib", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let src = @fs.read_file_to_bytes(fixture) catch {
    e => fail("failed to read source: " + e.to_string())
  }
  let dst = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(dst == src, content="true")
}

///|
test "run_cli applies -for_n filter to -grib output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_grib_for_n_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-grib", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let src = @fs.read_file_to_bytes(fixture) catch {
    e => fail("failed to read source: " + e.to_string())
  }
  let dst = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(dst.length() > 0, content="true")
  inspect(dst.length() < src.length(), content="true")
  let magic = dst.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli repacks jpeg2000 -grib_out record to simple packing" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_out_jpeg_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out", out]
  inspect(run_cli(args), content="0")
  let src_context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse source fixture: " + e.to_string())
  }
  let out_context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse -grib_out output: " + e.to_string())
  }
  let src_meta = @lib.decode_records(src_context)[0]
  let out_meta = @lib.decode_records(out_context)[0]
  inspect(src_meta.section5_template.id(), content="40")
  inspect(out_meta.section5_template.id(), content="0")
  inspect(
    out_meta.section5_reference_value_ieee ==
    src_meta.section5_reference_value_ieee,
    content="true",
  )
  inspect(
    out_meta.section5_binary_scale_factor ==
    src_meta.section5_binary_scale_factor,
    content="true",
  )
  inspect(
    out_meta.section5_decimal_scale_factor ==
    src_meta.section5_decimal_scale_factor,
    content="true",
  )
  inspect(out_meta.section5_bits_per_value, content="11")
}

///|
test "run_cli repacks complex -grib_out record to simple packing" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_grib_out_complex_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out", out]
  inspect(run_cli(args), content="0")
  let src_context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse source fixture: " + e.to_string())
  }
  let out_context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse -grib_out output: " + e.to_string())
  }
  let src_meta = @lib.decode_records(src_context)[0]
  let out_meta = @lib.decode_records(out_context)[0]
  inspect(src_meta.section5_template.id(), content="3")
  inspect(out_meta.section5_template.id(), content="0")
  inspect(
    out_meta.section5_reference_value_ieee ==
    src_meta.section5_reference_value_ieee,
    content="true",
  )
  inspect(
    out_meta.section5_binary_scale_factor ==
    src_meta.section5_binary_scale_factor,
    content="true",
  )
  inspect(
    out_meta.section5_decimal_scale_factor ==
    src_meta.section5_decimal_scale_factor,
    content="true",
  )
  inspect(out_meta.section5_bits_per_value, content="16")
}

///|
test "build_grib_out_section6_bytes materializes reused bitmap" {
  let raw = b"\x00\x00\x00\x07\x06\x00\xa0\x00\x00\x00\x06\x06\xfe"
  let dummy3 = fake_section_frame(3, 0, 0)
  let dummy4 = fake_section_frame(4, 0, 0)
  let dummy5 = fake_section_frame(5, 0, 0)
  let dummy7 = fake_section_frame(7, 0, 0)
  let message : @lib.Grib2MessageContext = {
    offset: 0,
    total_length: raw.length(),
    discipline: 0,
    edition: 2,
    section1: fake_section_frame(1, 0, 0),
    section8_offset: raw.length(),
    sections: [],
    submessages: [
      {
        section2: None,
        section3: dummy3,
        section4: dummy4,
        section5: dummy5,
        section6: fake_section_frame(6, 0, 7),
        section7: dummy7,
      },
      {
        section2: None,
        section3: dummy3,
        section4: dummy4,
        section5: dummy5,
        section6: fake_section_frame(6, 7, 6),
        section7: dummy7,
      },
    ],
    raw,
  }
  let sec6 = match
    build_grib_out_section6_bytes(message, message.submessages[1]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(sec6 == b"\x00\x00\x00\x07\x06\x00\xa0", content="true")
}

///|
test "restore_input_scan_order_for_grib_out inverts WE:SN normalization" {
  let section3 = sample_grib_out_test_section3_bytes(3, 2, 0)
  let dummy4 = fake_section_frame(4, 0, 0)
  let dummy5 = fake_section_frame(5, 0, 0)
  let dummy6 = fake_section_frame(6, 0, 0)
  let dummy7 = fake_section_frame(7, 0, 0)
  let message : @lib.Grib2MessageContext = {
    offset: 0,
    total_length: section3.length(),
    discipline: 0,
    edition: 2,
    section1: fake_section_frame(1, 0, 0),
    section8_offset: section3.length(),
    sections: [],
    submessages: [
      {
        section2: None,
        section3: fake_section_frame(3, 0, section3.length()),
        section4: dummy4,
        section5: dummy5,
        section6: dummy6,
        section7: dummy7,
      },
    ],
    raw: section3,
  }
  let restored = restore_input_scan_order_for_grib_out(
    message,
    message.submessages[0],
    [20.0, 21.0, 22.0, 10.0, 11.0, 12.0],
  )
  inspect(restored.length(), content="6")
  inspect(restored[0] == 10.0, content="true")
  inspect(restored[1] == 11.0, content="true")
  inspect(restored[2] == 12.0, content="true")
  inspect(restored[3] == 20.0, content="true")
  inspect(restored[4] == 21.0, content="true")
  inspect(restored[5] == 22.0, content="true")
}

///|
test "run_cli repacks bitmaped simple-packed -grib_out record" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_grib_out_bitmap_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "266:266:1", "-grib_out", out]
  inspect(run_cli(args), content="0")
  let out_context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse bitmap -grib_out output: " + e.to_string())
  }
  let out_meta = @lib.decode_records(out_context)[0]
  inspect(out_meta.section5_template.id(), content="0")
  inspect(out_meta.section6_bitmap_indicator, content="0")
  inspect(out_meta.section5_bits_per_value, content="10")
}

///|
test "run_cli supports -tosubmsg alias output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_tosubmsg_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-tosubmsg", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read tosubmsg output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -ijsmall_grib full-domain limited mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_ijsmall_grib_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-ijsmall_grib", "1:360:1", "1:181:1",
    out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse ijsmall_grib output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section5_template.id(), content="0")
  inspect(meta.section3_scanning_mode, content="64")
}

///|
test "run_cli supports -small_grib full-domain limited mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_small_grib_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-small_grib", "0:359", "-90:90", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse small_grib output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section5_template.id(), content="0")
  inspect(meta.section3_scanning_mode, content="64")
}

///|
test "run_cli supports -lola identity remap mode=grib" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_lola_grib_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-lola", "0:360:1", "-90:181:1", out,
    "grib",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse lola output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section5_template.id(), content="0")
  inspect(meta.section3_scanning_mode, content="64")
}

///|
test "run_cli supports -cress_lola regular lat/lon output" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let out = "target/cmd_main_cress_lola_jma_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "0:720:0.5", "-90:361:0.5",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse cress_lola output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section5_template.id(), content="0")
  inspect(meta.section3_scanning_mode, content="64")
}

///|
test "run_cli supports -cress_lola off-grid output on pgrb2" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_cress_lola_pgrb2_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse off-grid cress_lola output: " + e.to_string())
  }
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v.values
    Err(e) =>
      fail(
        "failed to unpack off-grid cress_lola output: " + unpack_error_string(e),
      )
  }
  inspect(unpacked.length(), content="30")
  inspect((unpacked[0] - 101919.0).abs() < 1.0, content="true")
  inspect((unpacked[1] - 102011.0).abs() < 1.0, content="true")
  inspect((unpacked[2] - 102011.0).abs() < 1.0, content="true")
}

///|
test "run_cli supports -cress_lola off-grid UGRD/VGRD output on pgrb2" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_cress_lola_pgrb2_uv_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "11:12:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read pgrb2 uv cress_lola output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse pgrb2 uv cress_lola output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="6")
  inspect(metas[0].section3_nj, content="5")
}

///|
test "run_cli supports -cress_lola off-grid negative and mixed-sign output on pgrb2" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"

  let neg_out = "target/cmd_main_cress_lola_pgrb2_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
      neg_out, "-50",
    ]),
    content="0",
  )
  let neg_context = match @lib.parse_with_io(native_read_bytes, neg_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse negative off-grid pgrb2 cress_lola output: " +
        e.to_string(),
      )
  }
  let neg_meta = @lib.decode_records(neg_context)[0]
  inspect(neg_meta.section3_ni, content="6")
  inspect(neg_meta.section3_nj, content="5")

  let negpos_out = "target/cmd_main_cress_lola_pgrb2_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
      negpos_out, "-1:2",
    ]),
    content="0",
  )
  let negpos_context = match @lib.parse_with_io(native_read_bytes, negpos_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse mixed-sign off-grid pgrb2 cress_lola output: " +
        e.to_string(),
      )
  }
  let negpos_meta = @lib.decode_records(negpos_context)[0]
  inspect(negpos_meta.section3_ni, content="6")
  inspect(negpos_meta.section3_nj, content="5")
}

///|
test "run_cli supports -cress_lola off-grid negative and mixed-sign UGRD/VGRD output on pgrb2" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"

  let neg_out = "target/cmd_main_cress_lola_pgrb2_uv_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "11:12:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
      neg_out, "-50",
    ]),
    content="0",
  )
  let neg_bytes = @fs.read_file_to_bytes(neg_out) catch {
    e =>
      fail(
        "failed to read negative off-grid pgrb2 uv cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(count_grib_magic(neg_bytes), content="2")
  let neg_context = match @lib.parse_with_io(native_read_bytes, neg_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse negative off-grid pgrb2 uv cress_lola output: " +
        e.to_string(),
      )
  }
  let neg_metas = @lib.decode_records(neg_context)
  inspect(neg_metas.length(), content="2")

  let negpos_out = "target/cmd_main_cress_lola_pgrb2_uv_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "11:12:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
      negpos_out, "-1:2",
    ]),
    content="0",
  )
  let negpos_bytes = @fs.read_file_to_bytes(negpos_out) catch {
    e =>
      fail(
        "failed to read mixed-sign off-grid pgrb2 uv cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(count_grib_magic(negpos_bytes), content="2")
  let negpos_context = match @lib.parse_with_io(native_read_bytes, negpos_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse mixed-sign off-grid pgrb2 uv cress_lola output: " +
        e.to_string(),
      )
  }
  let negpos_metas = @lib.decode_records(negpos_context)
  inspect(negpos_metas.length(), content="2")
}

///|
test "run_cli supports -cress_lola off-grid UGRD/VGRD output on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_uv_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "3:4:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read gfswave uv cress_lola output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse gfswave uv cress_lola output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="8")
  inspect(metas[0].section3_nj, content="8")
}

///|
test "run_cli supports -cress_lola off-grid negative-radius UGRD/VGRD output on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_uv_offgrid_neg_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "3:4:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
    out, "-20",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read gfswave uv negative cress_lola output: " + e.to_string(),
      )
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse gfswave uv negative cress_lola output: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="8")
  inspect(metas[0].section3_nj, content="8")
}

///|
test "run_cli keeps off-grid negative-pass mask for UGRD/VGRD output on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_uv_offgrid_neg_pos_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "3:4:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
    out, "-1:2",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read gfswave uv mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse gfswave uv mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="8")
  inspect(metas[0].section3_nj, content="8")
}

///|
test "run_cli supports -cress_lola off-grid bitmap output on pgrb2b" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_cress_lola_pgrb2b_bitmap_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "266:266:1", "-cress_lola", "130.25:6:0.5", "30.5:5:0.5",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse pgrb2b bitmap cress_lola output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_ni, content="6")
  inspect(meta.section3_nj, content="5")
  inspect(meta.section6_bitmap_indicator, content="255")
}

///|
test "run_cli supports -cress_lola off-grid negative-radius bitmap output on pgrb2b" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_cress_lola_pgrb2b_bitmap_offgrid_neg_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "266:266:1", "-cress_lola", "130.25:6:0.5", "30.5:5:0.5",
    out, "-50",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse pgrb2b bitmap negative cress_lola output: " +
        e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_ni, content="6")
  inspect(meta.section3_nj, content="5")
  inspect(meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli keeps off-grid negative-pass bitmap mask on pgrb2b" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_cress_lola_pgrb2b_bitmap_offgrid_neg_pos_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "266:266:1", "-cress_lola", "130.25:6:0.5", "30.5:5:0.5",
    out, "-1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse pgrb2b bitmap mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_ni, content="6")
  inspect(meta.section3_nj, content="5")
  inspect(meta.section6_bitmap_indicator, content="255")
}

///|
test "run_cli supports -cress_lola off-grid bitmap output on scan32/scan48 bitmap fixtures" {
  let scan32_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2"
  let scan32_out = "target/cmd_main_cress_lola_scan32_bitmap_offgrid_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan32_fixture, "-for_n", "1:1:1", "-cress_lola", "130.25:6:0.5",
      "30.5:5:0.5", scan32_out, "1:2",
    ]),
    content="0",
  )
  let scan32_context = match @lib.parse_with_io(native_read_bytes, scan32_out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse scan32 bitmap cress_lola output: " + e.to_string())
  }
  let scan32_meta = @lib.decode_records(scan32_context)[0]
  inspect(scan32_meta.section3_ni, content="6")
  inspect(scan32_meta.section3_nj, content="5")
  inspect(scan32_meta.section6_bitmap_indicator, content="0")

  let scan48_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2"
  let scan48_out = "target/cmd_main_cress_lola_scan48_bitmap_offgrid_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan48_fixture, "-for_n", "1:1:1", "-cress_lola", "130.25:6:0.5",
      "30.5:5:0.5", scan48_out, "1:2",
    ]),
    content="0",
  )
  let scan48_context = match @lib.parse_with_io(native_read_bytes, scan48_out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse scan48 bitmap cress_lola output: " + e.to_string())
  }
  let scan48_meta = @lib.decode_records(scan48_context)[0]
  inspect(scan48_meta.section3_ni, content="6")
  inspect(scan48_meta.section3_nj, content="5")
  inspect(scan48_meta.section6_bitmap_indicator, content="255")
}

///|
test "run_cli keeps off-grid bitmap mask on scan32/scan48 bitmap fixtures" {
  let scan32_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2"
  let scan32_neg_out = "target/cmd_main_cress_lola_scan32_bitmap_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan32_fixture, "-for_n", "1:1:1", "-cress_lola", "130.25:6:0.5",
      "30.5:5:0.5", scan32_neg_out, "-50",
    ]),
    content="0",
  )
  let scan32_neg_context = match
    @lib.parse_with_io(native_read_bytes, scan32_neg_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 bitmap negative cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(
    @lib.decode_records(scan32_neg_context)[0].section6_bitmap_indicator,
    content="0",
  )
  let scan32_negpos_out = "target/cmd_main_cress_lola_scan32_bitmap_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan32_fixture, "-for_n", "1:1:1", "-cress_lola", "130.25:6:0.5",
      "30.5:5:0.5", scan32_negpos_out, "-1:2",
    ]),
    content="0",
  )
  let scan32_negpos_context = match
    @lib.parse_with_io(native_read_bytes, scan32_negpos_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 bitmap mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(
    @lib.decode_records(scan32_negpos_context)[0].section6_bitmap_indicator,
    content="0",
  )

  let scan48_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2"
  let scan48_neg_out = "target/cmd_main_cress_lola_scan48_bitmap_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan48_fixture, "-for_n", "1:1:1", "-cress_lola", "130.25:6:0.5",
      "30.5:5:0.5", scan48_neg_out, "-50",
    ]),
    content="0",
  )
  let scan48_neg_context = match
    @lib.parse_with_io(native_read_bytes, scan48_neg_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan48 bitmap negative cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(
    @lib.decode_records(scan48_neg_context)[0].section6_bitmap_indicator,
    content="0",
  )
  let scan48_negpos_out = "target/cmd_main_cress_lola_scan48_bitmap_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan48_fixture, "-for_n", "1:1:1", "-cress_lola", "130.25:6:0.5",
      "30.5:5:0.5", scan48_negpos_out, "-1:2",
    ]),
    content="0",
  )
  let scan48_negpos_context = match
    @lib.parse_with_io(native_read_bytes, scan48_negpos_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan48 bitmap mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(
    @lib.decode_records(scan48_negpos_context)[0].section6_bitmap_indicator,
    content="0",
  )
}

///|
test "run_cli supports -cress_lola off-grid output on scan32 fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2"
  let out = "target/cmd_main_cress_lola_scan32_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse scan32 cress_lola output: " + e.to_string())
  }
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v.values
    Err(e) =>
      fail(
        "failed to unpack scan32 cress_lola output: " + unpack_error_string(e),
      )
  }
  inspect(unpacked.length(), content="30")
  inspect((unpacked[0] - 102196.0).abs() < 1.0, content="true")
  inspect((unpacked[1] - 102012.0).abs() < 1.0, content="true")
  inspect((unpacked[2] - 102012.0).abs() < 1.0, content="true")
}

///|
test "run_cli supports -cress_lola off-grid output on scan48 fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2"
  let out = "target/cmd_main_cress_lola_scan48_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse scan48 cress_lola output: " + e.to_string())
  }
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v.values
    Err(e) =>
      fail(
        "failed to unpack scan48 cress_lola output: " + unpack_error_string(e),
      )
  }
  inspect(unpacked.length(), content="30")
  inspect((unpacked[0] - 102216.0).abs() < 1.0, content="true")
  inspect((unpacked[1] - 102272.0).abs() < 1.0, content="true")
  inspect((unpacked[2] - 102272.0).abs() < 1.0, content="true")
}

///|
test "run_cli supports -cress_lola off-grid UGRD/VGRD output on scan32 fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2"
  let out = "target/cmd_main_cress_lola_scan32_uv_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:2:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read scan32 uv cress_lola output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse scan32 uv cress_lola output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="6")
  inspect(metas[0].section3_nj, content="5")
}

///|
test "run_cli supports -cress_lola off-grid UGRD/VGRD output on scan48 fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2"
  let out = "target/cmd_main_cress_lola_scan48_uv_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:2:1", "-cress_lola", "0.25:6:0.5", "-89:5:0.5",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read scan48 uv cress_lola output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse scan48 uv cress_lola output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="6")
  inspect(metas[0].section3_nj, content="5")
}

///|
test "run_cli supports -cress_lola negative-radius mask on scan32/scan48 fixtures" {
  let scan32_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2"
  let scan32_out = "target/cmd_main_cress_lola_scan32_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan32_fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5",
      "-89:5:0.5", scan32_out, "-50",
    ]),
    content="0",
  )
  let scan32_context = match @lib.parse_with_io(native_read_bytes, scan32_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 negative cress_lola output: " + e.to_string(),
      )
  }
  let scan32_meta = @lib.decode_records(scan32_context)[0]
  inspect(scan32_meta.section3_ni, content="6")
  inspect(scan32_meta.section3_nj, content="5")

  let scan48_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2"
  let scan48_out = "target/cmd_main_cress_lola_scan48_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan48_fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5",
      "-89:5:0.5", scan48_out, "-50",
    ]),
    content="0",
  )
  let scan48_context = match @lib.parse_with_io(native_read_bytes, scan48_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan48 negative cress_lola output: " + e.to_string(),
      )
  }
  let scan48_meta = @lib.decode_records(scan48_context)[0]
  inspect(scan48_meta.section3_ni, content="6")
  inspect(scan48_meta.section3_nj, content="5")
}

///|
test "run_cli keeps negative-pass mask on scan32/scan48 fixtures" {
  let scan32_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2"
  let scan32_out = "target/cmd_main_cress_lola_scan32_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan32_fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5",
      "-89:5:0.5", scan32_out, "-1:2",
    ]),
    content="0",
  )
  let scan32_context = match @lib.parse_with_io(native_read_bytes, scan32_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 mixed-sign cress_lola output: " + e.to_string(),
      )
  }
  let scan32_meta = @lib.decode_records(scan32_context)[0]
  inspect(scan32_meta.section3_ni, content="6")
  inspect(scan32_meta.section3_nj, content="5")

  let scan48_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2"
  let scan48_out = "target/cmd_main_cress_lola_scan48_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan48_fixture, "-for_n", "1:1:1", "-cress_lola", "0.25:6:0.5",
      "-89:5:0.5", scan48_out, "-1:2",
    ]),
    content="0",
  )
  let scan48_context = match @lib.parse_with_io(native_read_bytes, scan48_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan48 mixed-sign cress_lola output: " + e.to_string(),
      )
  }
  let scan48_meta = @lib.decode_records(scan48_context)[0]
  inspect(scan48_meta.section3_ni, content="6")
  inspect(scan48_meta.section3_nj, content="5")
}

///|
test "run_cli supports -cress_lola negative-radius mask on scan32/scan48 UGRD/VGRD fixtures" {
  let scan32_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2"
  let scan32_out = "target/cmd_main_cress_lola_scan32_uv_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan32_fixture, "-for_n", "1:2:1", "-cress_lola", "0.25:6:0.5",
      "-89:5:0.5", scan32_out, "-50",
    ]),
    content="0",
  )
  let scan32_bytes = @fs.read_file_to_bytes(scan32_out) catch {
    e =>
      fail(
        "failed to read scan32 uv negative cress_lola output: " + e.to_string(),
      )
  }
  inspect(count_grib_magic(scan32_bytes), content="2")
  let scan32_context = match @lib.parse_with_io(native_read_bytes, scan32_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 uv negative cress_lola output: " + e.to_string(),
      )
  }
  let scan32_metas = @lib.decode_records(scan32_context)
  inspect(scan32_metas.length(), content="2")

  let scan48_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2"
  let scan48_out = "target/cmd_main_cress_lola_scan48_uv_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan48_fixture, "-for_n", "1:2:1", "-cress_lola", "0.25:6:0.5",
      "-89:5:0.5", scan48_out, "-50",
    ]),
    content="0",
  )
  let scan48_bytes = @fs.read_file_to_bytes(scan48_out) catch {
    e =>
      fail(
        "failed to read scan48 uv negative cress_lola output: " + e.to_string(),
      )
  }
  inspect(count_grib_magic(scan48_bytes), content="2")
  let scan48_context = match @lib.parse_with_io(native_read_bytes, scan48_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan48 uv negative cress_lola output: " + e.to_string(),
      )
  }
  let scan48_metas = @lib.decode_records(scan48_context)
  inspect(scan48_metas.length(), content="2")
}

///|
test "run_cli keeps negative-pass mask on scan32/scan48 UGRD/VGRD fixtures" {
  let scan32_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2"
  let scan32_out = "target/cmd_main_cress_lola_scan32_uv_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan32_fixture, "-for_n", "1:2:1", "-cress_lola", "0.25:6:0.5",
      "-89:5:0.5", scan32_out, "-1:2",
    ]),
    content="0",
  )
  let scan32_bytes = @fs.read_file_to_bytes(scan32_out) catch {
    e =>
      fail(
        "failed to read scan32 uv mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(count_grib_magic(scan32_bytes), content="2")
  let scan32_context = match @lib.parse_with_io(native_read_bytes, scan32_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 uv mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  let scan32_metas = @lib.decode_records(scan32_context)
  inspect(scan32_metas.length(), content="2")

  let scan48_fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2"
  let scan48_out = "target/cmd_main_cress_lola_scan48_uv_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", scan48_fixture, "-for_n", "1:2:1", "-cress_lola", "0.25:6:0.5",
      "-89:5:0.5", scan48_out, "-1:2",
    ]),
    content="0",
  )
  let scan48_bytes = @fs.read_file_to_bytes(scan48_out) catch {
    e =>
      fail(
        "failed to read scan48 uv mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  inspect(count_grib_magic(scan48_bytes), content="2")
  let scan48_context = match @lib.parse_with_io(native_read_bytes, scan48_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan48 uv mixed-sign cress_lola output: " +
        e.to_string(),
      )
  }
  let scan48_metas = @lib.decode_records(scan48_context)
  inspect(scan48_metas.length(), content="2")
}

///|
test "run_cli -cress_lola fills bitmap gaps for gfswave same-grid output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "5:5:1", "-cress_lola", "260:301:0.166667", "0:331:0.166667",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse cress_lola gfswave output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section5_template.id(), content="0")
  inspect(meta.section3_scanning_mode, content="64")
  inspect(meta.section6_bitmap_indicator, content="255")
  inspect(meta.section6_undef_points, content="0")
}

///|
test "run_cli supports -cress_lola off-grid output on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_offgrid_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "5:5:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
    out, "1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid cress_lola gfswave output: " + e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_ni, content="8")
  inspect(meta.section3_nj, content="8")
  inspect(meta.section3_scanning_mode, content="64")
  inspect(meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli supports -cress_lola off-grid negative-radius mask on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_offgrid_neg_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "5:5:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
    out, "-20",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid negative cress_lola gfswave output: " +
        e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_ni, content="8")
  inspect(meta.section3_nj, content="8")
  inspect(meta.section3_scanning_mode, content="64")
  inspect(meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli keeps off-grid negative-pass mask after later positive passes on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_offgrid_neg_pos_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "5:5:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
    out, "-1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid mixed-sign cress_lola gfswave output: " +
        e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_ni, content="8")
  inspect(meta.section3_nj, content="8")
  inspect(meta.section3_scanning_mode, content="64")
  inspect(meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli supports -cress_lola off-grid WIND/WDIR output on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let wind_out = "target/cmd_main_cress_lola_gfswave_wind_offgrid_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
      wind_out, "1:2",
    ]),
    content="0",
  )
  let wind_context = match @lib.parse_with_io(native_read_bytes, wind_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid cress_lola gfswave WIND output: " +
        e.to_string(),
      )
  }
  let wind_meta = @lib.decode_records(wind_context)[0]
  inspect(name_lookup_text(wind_meta.parameter_name), content="WIND")
  inspect(wind_meta.section3_ni, content="8")
  inspect(wind_meta.section3_nj, content="8")
  inspect(wind_meta.section3_scanning_mode, content="64")
  inspect(wind_meta.section6_bitmap_indicator, content="0")

  let wdir_out = "target/cmd_main_cress_lola_gfswave_wdir_offgrid_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "2:2:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
      wdir_out, "1:2",
    ]),
    content="0",
  )
  let wdir_context = match @lib.parse_with_io(native_read_bytes, wdir_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid cress_lola gfswave WDIR output: " +
        e.to_string(),
      )
  }
  let wdir_meta = @lib.decode_records(wdir_context)[0]
  inspect(name_lookup_text(wdir_meta.parameter_name), content="WDIR")
  inspect(wdir_meta.section3_ni, content="8")
  inspect(wdir_meta.section3_nj, content="8")
  inspect(wdir_meta.section3_scanning_mode, content="64")
  inspect(wdir_meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli supports -cress_lola off-grid negative-radius mask on gfswave WIND/WDIR" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let wind_out = "target/cmd_main_cress_lola_gfswave_wind_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
      wind_out, "-20",
    ]),
    content="0",
  )
  let wind_context = match @lib.parse_with_io(native_read_bytes, wind_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid negative cress_lola gfswave WIND output: " +
        e.to_string(),
      )
  }
  let wind_meta = @lib.decode_records(wind_context)[0]
  inspect(name_lookup_text(wind_meta.parameter_name), content="WIND")
  inspect(wind_meta.section3_ni, content="8")
  inspect(wind_meta.section3_nj, content="8")
  inspect(wind_meta.section3_scanning_mode, content="64")
  inspect(wind_meta.section6_bitmap_indicator, content="0")

  let wdir_out = "target/cmd_main_cress_lola_gfswave_wdir_offgrid_neg_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "2:2:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
      wdir_out, "-20",
    ]),
    content="0",
  )
  let wdir_context = match @lib.parse_with_io(native_read_bytes, wdir_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid negative cress_lola gfswave WDIR output: " +
        e.to_string(),
      )
  }
  let wdir_meta = @lib.decode_records(wdir_context)[0]
  inspect(name_lookup_text(wdir_meta.parameter_name), content="WDIR")
  inspect(wdir_meta.section3_ni, content="8")
  inspect(wdir_meta.section3_nj, content="8")
  inspect(wdir_meta.section3_scanning_mode, content="64")
  inspect(wdir_meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli keeps off-grid negative-pass mask on gfswave WIND/WDIR" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let wind_out = "target/cmd_main_cress_lola_gfswave_wind_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
      wind_out, "-1:2",
    ]),
    content="0",
  )
  let wind_context = match @lib.parse_with_io(native_read_bytes, wind_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid mixed-sign cress_lola gfswave WIND output: " +
        e.to_string(),
      )
  }
  let wind_meta = @lib.decode_records(wind_context)[0]
  inspect(name_lookup_text(wind_meta.parameter_name), content="WIND")
  inspect(wind_meta.section3_ni, content="8")
  inspect(wind_meta.section3_nj, content="8")
  inspect(wind_meta.section3_scanning_mode, content="64")
  inspect(wind_meta.section6_bitmap_indicator, content="0")

  let wdir_out = "target/cmd_main_cress_lola_gfswave_wdir_offgrid_neg_pos_test.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "2:2:1", "-cress_lola", "260.5:8:1", "0.5:8:1",
      wdir_out, "-1:2",
    ]),
    content="0",
  )
  let wdir_context = match @lib.parse_with_io(native_read_bytes, wdir_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse off-grid mixed-sign cress_lola gfswave WDIR output: " +
        e.to_string(),
      )
  }
  let wdir_meta = @lib.decode_records(wdir_context)[0]
  inspect(name_lookup_text(wdir_meta.parameter_name), content="WDIR")
  inspect(wdir_meta.section3_ni, content="8")
  inspect(wdir_meta.section3_nj, content="8")
  inspect(wdir_meta.section3_scanning_mode, content="64")
  inspect(wdir_meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli -cress_lola supports negative-radius mask on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_neg_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "5:5:1", "-cress_lola", "260:301:0.166667", "0:331:0.166667",
    out, "-20",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse negative cress_lola output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section5_template.id(), content="0")
  inspect(meta.section3_scanning_mode, content="64")
  inspect(meta.section6_bitmap_indicator, content="0")
  inspect(meta.section6_undef_points, content="68778")
}

///|
test "run_cli -cress_lola keeps negative-pass mask after later positive passes" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cress_lola_gfswave_neg_pos_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "5:5:1", "-cress_lola", "260:301:0.166667", "0:331:0.166667",
    out, "-1:2",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse mixed-sign cress_lola output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section5_template.id(), content="0")
  inspect(meta.section3_scanning_mode, content="64")
  inspect(meta.section6_bitmap_indicator, content="0")
  inspect(meta.section6_undef_points, content="70212")
}

///|
test "run_cli rejects invalid -cress_lola radius list" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_cress_lola_bad.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-cress_lola", "0:360:1", "-90:181:1",
    out, "bad:2",
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -irr_grid nearest-neighbor template 130 output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_irr_grid_pgrb2_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-irr_grid", "0:90:1:89", "100", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse irr_grid output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="130")
  inspect(meta.section3_length, content="46")
  inspect(meta.section3_npts, content="2")
  inspect(meta.section5_num_defined_points, content="2")
  inspect(meta.section6_bitmap_indicator, content="255")
  let section6 = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v.values
    Err(_) => fail("failed to unpack irr_grid output")
  }
  inspect(section6.length(), content="2")
  let sec3 = section_frame_bytes(
    context.messages[0],
    context.messages[0].submessages[0].section3,
  )
  inspect(sec3[30], content="b'\\x05'")
  inspect(sec3[31], content="b'\\x5D'")
  inspect(sec3[32], content="b'\\x4A'")
  inspect(sec3[33], content="b'\\x80'")
  inspect(sec3[34], content="b'\\x00'")
  inspect(sec3[35], content="b'\\x00'")
  inspect(sec3[36], content="b'\\x00'")
  inspect(sec3[37], content="b'\\x00'")
  inspect(sec3[38], content="b'\\x05'")
  inspect(sec3[39], content="b'\\x4E'")
  inspect(sec3[40], content="b'\\x08'")
  inspect(sec3[41], content="b'\\x40'")
  inspect(sec3[42], content="b'\\x00'")
  inspect(sec3[43], content="b'\\x0F'")
  inspect(sec3[44], content="b'\\x42'")
  inspect(sec3[45], content="b'\\x40'")
}

///|
test "run_cli validates -irr_grid point list" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_irr_grid_bad.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-irr_grid", "0:90:1", "100", out,
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli writes -grib_out_irr template 130 output for regular latlon input" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_grib_out_irr_pgrb2_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr", "all", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse grib_out_irr output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="130")
  inspect(meta.section3_length, content="521310")
  inspect(meta.section3_npts, content="65160")
  inspect(meta.section5_num_defined_points, content="65160")
  inspect(meta.section6_bitmap_indicator, content="255")
  let sec3 = section_frame_bytes(
    context.messages[0],
    context.messages[0].submessages[0].section3,
  )
  inspect(sec3[30], content="b'\\x85'")
  inspect(sec3[31], content="b'\\x5D'")
  inspect(sec3[32], content="b'\\x4A'")
  inspect(sec3[33], content="b'\\x80'")
  inspect(sec3[34], content="b'\\x00'")
  inspect(sec3[35], content="b'\\x00'")
  inspect(sec3[36], content="b'\\x00'")
  inspect(sec3[37], content="b'\\x00'")
}

///|
test "run_cli writes -grib_out_irr bitmap output for undefined irregular points" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_out_irr_gfswave_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr", "all", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse grib_out_irr bitmap output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="130")
  inspect(meta.section3_length, content="797078")
  inspect(meta.section3_npts, content="99631")
  inspect(meta.section5_num_defined_points, content="29419")
  inspect(meta.section6_bitmap_indicator, content="0")
  inspect(meta.section6_length, content="12460")
  inspect(meta.section6_undef_points, content="70212")
  let section6 = match
    @lib.decode_submessage_section6(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) => fail("failed to decode grib_out_irr section6: " + e.to_string())
  }
  inspect(section6.bitmap_raw.length(), content="12454")
  let sec3 = section_frame_bytes(
    context.messages[0],
    context.messages[0].submessages[0].section3,
  )
  inspect(sec3[2438], content="b'\\x00'")
  inspect(sec3[2439], content="b'\\x02'")
  inspect(sec3[2440], content="b'\\x8B'")
  inspect(sec3[2441], content="b'\\x0A'")
}

///|
test "run_cli writes -grib_out_irr defined-point output without bitmap" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_grib_out_irr_pgrb2b_defined_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "266:266:1", "-grib_out_irr", "defined", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse grib_out_irr defined output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="130")
  inspect(meta.section3_length, content="176598")
  inspect(meta.section3_npts, content="22071")
  inspect(meta.section5_num_defined_points, content="22071")
  inspect(meta.section6_bitmap_indicator, content="255")
}

///|
test "run_cli writes -grib_out_irr2 template 101 output for defined points" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_grib_out_irr2_defined_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr2", "10", "1", "0", "00000000-0000-0000-0000-000000000000",
    out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse grib_out_irr2 output: " + e.to_string())
  }
  let records = @lib.decode_records(context)
  inspect(records.length(), content="1")
  let meta = records[0]
  inspect(meta.section3_template.id(), content="101")
  inspect(meta.section3_npts, content="10")
  inspect(meta.section5_template.id(), content="0")
  inspect(meta.section5_num_defined_points, content="10")
  inspect(meta.section5_bits_per_value, content="0")
  inspect(meta.section6_bitmap_indicator, content="255")
  let section3 = match
    @lib.decode_submessage_section3(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) => fail("failed to decode irr2 section3: " + e.to_string())
  }
  match section3.template {
    @section3.GridTemplate3101(template) => {
      inspect(template.shape_of_earth, content="6")
      inspect(template.number_of_grid_used, content="1")
      inspect(template.number_of_grid_in_reference, content="0")
      inspect(template.uuid_of_horizontal_grid.length(), content="16")
    }
    _ => fail("expected template 3.101")
  }
}

///|
test "run_cli writes -grib_out_irr2 bitmap for undefined points" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_out_irr2_bitmap_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr2", "10", "1", "0", "00000000-0000-0000-0000-000000000000",
    out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse grib_out_irr2 bitmap output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="101")
  inspect(meta.section3_npts, content="10")
  inspect(meta.section5_num_defined_points, content="0")
  inspect(meta.section5_reference_value_ieee, content="0")
  inspect(meta.section5_bits_per_value, content="0")
  inspect(meta.section6_bitmap_indicator, content="0")
  inspect(meta.section6_length, content="8")
  inspect(meta.section6_undef_points, content="10")
  let section6 = match
    @lib.decode_submessage_section6(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) => fail("failed to decode irr2 section6: " + e.to_string())
  }
  inspect(section6.bitmap_raw.length(), content="2")
  inspect(section6.bitmap_raw[0], content="b'\\x00'")
  inspect(section6.bitmap_raw[1], content="b'\\x00'")
}

///|
test "run_cli pads -grib_out_irr2 beyond source size with undefined points" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_grib_out_irr2_padded_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr2", "70000", "1", "0",
    "00000000-0000-0000-0000-000000000000", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse padded grib_out_irr2 output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="101")
  inspect(meta.section3_npts, content="70000")
  inspect(meta.section5_num_defined_points, content="65160")
  inspect(meta.section6_bitmap_indicator, content="0")
  inspect(meta.section6_undef_points, content="4840")
  inspect(meta.section6_length, content="8756")
}

///|
test "run_cli supports -new_grid_order limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out1 = "target/cmd_main_new_grid_order_out1.grib2"
  let out2 = "target/cmd_main_new_grid_order_out2.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid_order", out1, out2,
  ]
  inspect(run_cli(args), content="0")
  let bytes1 = @fs.read_file_to_bytes(out1) catch {
    e => fail("failed to read new_grid_order out1: " + e.to_string())
  }
  let bytes2 = @fs.read_file_to_bytes(out2) catch {
    e => fail("failed to read new_grid_order out2: " + e.to_string())
  }
  inspect(bytes1.length() > 16, content="true")
  inspect(bytes2.length(), content="0")
  let magic = bytes1.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -new_grid latlon identity output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_new_grid_identity_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid", "latlon", "0:360:1", "-90:181:1",
    out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read new_grid output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="1")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse new_grid output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="0")
  inspect(meta.section3_ni, content="360")
  inspect(meta.section3_nj, content="181")
}

///|
test "run_cli supports -new_grid latlon identity output with bitmap field" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_new_grid_bitmap_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "5:5:1", "-new_grid", "latlon", "260:301:0.166667",
    "0:331:0.166667", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse bitmap new_grid output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section6_bitmap_indicator, content="0")
  inspect(meta.section5_num_defined_points, content="29419")
  inspect(meta.section6_undef_points, content="70212")
}

///|
test "new_grid bilinear interpolation averages a 2x2 scalar cell" {
  let source : NewGridRegularLatLonGrid = {
    lon_start: 0.0,
    lat_start: 0.0,
    nx: 2,
    ny: 2,
    dlon: 1.0,
    dlat: 1.0,
    wraps_lon: false,
  }
  let value = match
    new_grid_bilinear_interpolate_regular_latlon_value(
      source,
      [0.0, 2.0, 4.0, 6.0],
      0.5,
      0.5,
    ) {
    Some(v) => v
    None => fail("expected bilinear interpolation result")
  }
  inspect(value, content="3")
}

///|
test "new_grid bilinear interpolation renormalizes bitmap weights" {
  let source : NewGridRegularLatLonGrid = {
    lon_start: 130.0,
    lat_start: 32.0,
    nx: 2,
    ny: 2,
    dlon: 1.0,
    dlat: 1.0,
    wraps_lon: false,
  }
  let value = match
    new_grid_bilinear_interpolate_regular_latlon_value(
      source,
      [0.0 / 0.0, 0.208, 0.298, 0.318],
      130.75,
      32.25,
    ) {
    Some(v) => v
    None => fail("expected bitmap-aware bilinear interpolation result")
  }
  inspect((value - 0.2403077).abs() < 0.00001, content="true")
  let missing = new_grid_bilinear_interpolate_regular_latlon_value(
    source,
    [0.0 / 0.0, 0.208, 0.298, 0.318],
    130.25,
    32.25,
  )
  inspect(missing == None, content="true")
}

///|
test "new_grid raw bilinear interpolation supports consecutive_j scan order" {
  let source : NewGridRawSourceGrid = {
    ni: 2,
    nj: 2,
    scan_mode: 32,
    lon1: 0.0,
    lat1: 1.0,
    dlon: 1.0,
    dlat: -1.0,
    hi: 1.0,
    x_max: 3.0,
    y_max: 3.0,
    iwrap: 0,
  }
  let value = match
    new_grid_bilinear_interpolate_raw_regular_latlon_value(
      source,
      [10.0, 30.0, 20.0, 40.0],
      0.5,
      0.5,
    ) {
    Some(v) => v
    None => fail("expected raw bilinear interpolation result for scan32")
  }
  inspect(value, content="25")
}

///|
test "new_grid raw bilinear interpolation supports alternating consecutive_j scan order" {
  let source : NewGridRawSourceGrid = {
    ni: 2,
    nj: 2,
    scan_mode: 48,
    lon1: 0.0,
    lat1: 1.0,
    dlon: 1.0,
    dlat: -1.0,
    hi: 1.0,
    x_max: 3.0,
    y_max: 3.0,
    iwrap: 0,
  }
  let value = match
    new_grid_bilinear_interpolate_raw_regular_latlon_value(
      source,
      [10.0, 30.0, 40.0, 20.0],
      0.5,
      0.5,
    ) {
    Some(v) => v
    None => fail("expected raw bilinear interpolation result for scan48")
  }
  inspect(value, content="25")
}

///|
test "run_cli supports -new_grid latlon bilinear scalar output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_new_grid_bilinear_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid", "latlon", "0.5:8:1", "-89.5:8:1",
    out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse bilinear new_grid output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="0")
  inspect(meta.section3_ni, content="8")
  inspect(meta.section3_nj, content="8")
  inspect(meta.section6_bitmap_indicator, content="255")
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v.values
    Err(e) =>
      fail(
        "failed to unpack bilinear new_grid output: " + unpack_error_string(e),
      )
  }
  inspect(unpacked.length(), content="64")
}

///|
test "run_cli supports -new_grid latlon bilinear scalar output on scan32 fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2"
  let out = "target/cmd_main_new_grid_bilinear_scan32_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid", "latlon", "0.25:6:0.5",
    "-89:5:0.5", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse scan32 bilinear new_grid output: " + e.to_string())
  }
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v.values
    Err(e) =>
      fail(
        "failed to unpack scan32 bilinear new_grid output: " +
        unpack_error_string(e),
      )
  }
  inspect(unpacked.length(), content="30")
  inspect((unpacked[0] - 102106.0).abs() < 1.0, content="true")
  inspect((unpacked[1] - 102042.0).abs() < 1.0, content="true")
  inspect((unpacked[2] - 102082.0).abs() < 1.0, content="true")
}

///|
test "run_cli matches wgrib2 empty output for -new_grid on alternating scan rows" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2"
  let out = "target/cmd_main_new_grid_bilinear_scan48_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid", "latlon", "0.25:6:0.5",
    "-89:5:0.5", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to read scan48 bilinear new_grid output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli matches wgrib2 empty output for -new_grid_interpolation neighbor on alternating scan rows" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_record1.grib2"
  let out = "target/cmd_main_new_grid_neighbor_scan48_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "0.25:6:0.5", "-89:5:0.5", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to read scan48 neighbor new_grid output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "new_grid alternating-row wind pair notice lines match wgrib2 order" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse scan48 uv fixture: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  let lines = new_grid_wgrib2_alternating_rows_pair_notice_lines(
    metas[0],
    metas[1],
  )
  inspect(lines.length(), content="5")
  inspect(lines[0], content="Warning: -new_grid_winds set to earth")
  inspect(lines[1], content="new_grid: rows must scan in same direction")
  inspect(
    lines[2],
    content="1:0:d=2026022100:UGRD:planetary boundary layer:anl:",
  )
  inspect(
    lines[3],
    content="2:97919:d=2026022100:VGRD:planetary boundary layer:anl:",
  )
  inspect(lines[4], content="new_grid: rows must scan in same direction")
}

///|
test "parse_cli_invocation accepts -new_grid_interpolation neighbor" {
  let args = [
    "-new_grid_interpolation", "neighbor", "-new_grid", "latlon", "0.25:6:0.5", "-89:5:0.5",
    "out.grb2",
  ]
  match parse_cli_invocation(args) {
    Ok((init, WriteNewGrid("latlon", "0.25:6:0.5", "-89:5:0.5", "out.grb2"))) =>
      inspect(init.new_grid_interpolation, content="Some(\"neighbor\")")
    Ok(_) => fail("unexpected action for -new_grid_interpolation neighbor")
    Err(e) => fail("failed to parse -new_grid_interpolation neighbor: " + e)
  }
}

///|
test "run_cli supports -new_grid_interpolation neighbor on scan32 fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_record1.grib2"
  let out = "target/cmd_main_new_grid_neighbor_scan32_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "0.25:6:0.5", "-89:5:0.5", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse scan32 neighbor new_grid output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="1")
  inspect(metas[0].section3_ni, content="6")
  inspect(metas[0].section3_nj, content="5")
}

///|
test "run_cli supports -new_grid_interpolation neighbor on scan32 UGRD/VGRD fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2"
  let out = "target/cmd_main_new_grid_neighbor_uv_scan32_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:2:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "0.25:6:0.5", "-89:5:0.5", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read scan32 uv neighbor new_grid output: " + e.to_string(),
      )
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 uv neighbor new_grid output: " + e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
}

///|
test "run_cli supports -new_grid_interpolation neighbor scalar output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_new_grid_neighbor_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "0.5:8:1", "-89.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse neighbor new_grid output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="0")
  inspect(meta.section3_ni, content="8")
  inspect(meta.section3_nj, content="8")
  inspect(meta.section6_bitmap_indicator, content="255")
}

///|
test "run_cli supports -new_grid_interpolation neighbor UGRD/VGRD output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_new_grid_neighbor_uv_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "11:12:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "0.5:8:1", "-89.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read neighbor uv new_grid output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse neighbor uv new_grid output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
}

///|
test "run_cli supports -new_grid_interpolation neighbor bitmap output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_new_grid_neighbor_bitmap_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "266:266:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "130.5:8:1", "30.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse neighbor bitmap new_grid output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="0")
  inspect(meta.section3_ni, content="8")
  inspect(meta.section3_nj, content="8")
  inspect(meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli supports -new_grid_interpolation neighbor WIND output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_new_grid_neighbor_wind_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "260.5:8:1", "0.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to read neighbor new_grid WIND output: " + e.to_string())
  }
  inspect(bytes.sub(start=0, end=4).to_bytes().to_string(), content="b\"GRIB\"")
}

///|
test "run_cli supports -new_grid latlon bilinear UGRD/VGRD output on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_new_grid_bilinear_uv_gfswave_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "3:4:1", "-new_grid", "latlon", "260.5:8:1",
    "0.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read gfswave uv new_grid output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse gfswave uv new_grid output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="8")
  inspect(metas[0].section3_nj, content="8")
}

///|
test "run_cli supports -new_grid_interpolation neighbor scalar gfswave output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_new_grid_neighbor_scalar_gfswave_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "5:5:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "260:301:0.166667", "0:331:0.166667", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse neighbor scalar gfswave new_grid output: " +
        e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="0")
  inspect(meta.section3_ni, content="301")
  inspect(meta.section3_nj, content="331")
  inspect(meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli supports -new_grid_interpolation neighbor UGRD/VGRD output on gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_new_grid_neighbor_uv_gfswave_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "3:4:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "260.5:8:1", "0.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read gfswave uv neighbor new_grid output: " + e.to_string(),
      )
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse gfswave uv neighbor new_grid output: " + e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="8")
  inspect(metas[0].section3_nj, content="8")
}

///|
test "run_cli supports -new_grid_interpolation neighbor WDIR output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_new_grid_neighbor_wdir_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "2:2:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "260.5:8:1", "0.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to read neighbor new_grid WDIR output: " + e.to_string())
  }
  inspect(bytes.sub(start=0, end=4).to_bytes().to_string(), content="b\"GRIB\"")
}

///|
test "run_cli supports -new_grid latlon bilinear UGRD/VGRD output on scan32 fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan32_uv_records11_12.grib2"
  let out = "target/cmd_main_new_grid_bilinear_uv_scan32_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:2:1", "-new_grid", "latlon", "0.25:6:0.5",
    "-89:5:0.5", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read scan32 uv new_grid output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse scan32 uv new_grid output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="6")
  inspect(metas[0].section3_nj, content="5")
}

///|
test "run_cli matches wgrib2 empty output for -new_grid UV on alternating scan rows" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2"
  let out = "target/cmd_main_new_grid_bilinear_uv_scan48_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:2:1", "-new_grid", "latlon", "0.25:6:0.5",
    "-89:5:0.5", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) => fail("failed to read scan48 uv new_grid output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli matches wgrib2 empty output for -new_grid_interpolation neighbor UV on alternating scan rows" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2_scan48_uv_records11_12.grib2"
  let out = "target/cmd_main_new_grid_neighbor_uv_scan48_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:2:1", "-new_grid_interpolation", "neighbor",
    "-new_grid", "latlon", "0.25:6:0.5", "-89:5:0.5", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to read scan48 uv neighbor new_grid output: " + e.to_string(),
      )
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -new_grid latlon bilinear UGRD/VGRD output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_new_grid_bilinear_uv_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "11:12:1", "-new_grid", "latlon", "0.5:8:1",
    "-89.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read bilinear uv new_grid output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse bilinear uv new_grid output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(name_lookup_text(metas[0].parameter_name), content="UGRD")
  inspect(name_lookup_text(metas[1].parameter_name), content="VGRD")
  inspect(metas[0].section3_ni, content="8")
  inspect(metas[0].section3_nj, content="8")
  inspect(metas[1].section3_ni, content="8")
  inspect(metas[1].section3_nj, content="8")
}

///|
test "run_cli supports -new_grid latlon bilinear bitmap output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_new_grid_bilinear_bitmap_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "266:266:1", "-new_grid", "latlon", "130.5:8:1",
    "30.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse bilinear bitmap new_grid output: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(meta.section3_template.id(), content="0")
  inspect(meta.section3_ni, content="8")
  inspect(meta.section3_nj, content="8")
  inspect(meta.section6_bitmap_indicator, content="0")
  inspect(meta.section5_num_defined_points, content="21")
  inspect(meta.section6_undef_points, content="43")
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v.values
    Err(e) =>
      fail(
        "failed to unpack bilinear bitmap new_grid output: " +
        unpack_error_string(e),
      )
  }
  let mut nan_count = 0
  for value in unpacked {
    if value != value {
      nan_count += 1
    }
  }
  inspect(nan_count, content="43")
  inspect((unpacked[16] - 0.275).abs() < 0.00001, content="true")
}

///|
test "run_cli supports -new_grid bitmap output on scan32 bitmap fixture" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2b_scan32_bitmap_record266.grib2"
  let bilinear_out = "target/cmd_main_new_grid_bilinear_scan32_bitmap_out.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid", "latlon", "130.25:6:0.5",
      "30.5:5:0.5", bilinear_out,
    ]),
    content="0",
  )
  let bilinear_context = match
    @lib.parse_with_io(native_read_bytes, bilinear_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 bitmap bilinear new_grid output: " +
        e.to_string(),
      )
  }
  let bilinear_meta = @lib.decode_records(bilinear_context)[0]
  inspect(bilinear_meta.section3_ni, content="6")
  inspect(bilinear_meta.section3_nj, content="5")
  inspect(bilinear_meta.section6_bitmap_indicator, content="0")

  let neighbor_out = "target/cmd_main_new_grid_neighbor_scan32_bitmap_out.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid_interpolation", "neighbor",
      "-new_grid", "latlon", "130.25:6:0.5", "30.5:5:0.5", neighbor_out,
    ]),
    content="0",
  )
  let neighbor_context = match
    @lib.parse_with_io(native_read_bytes, neighbor_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse scan32 bitmap neighbor new_grid output: " +
        e.to_string(),
      )
  }
  let neighbor_meta = @lib.decode_records(neighbor_context)[0]
  inspect(neighbor_meta.section3_ni, content="6")
  inspect(neighbor_meta.section3_nj, content="5")
  inspect(neighbor_meta.section6_bitmap_indicator, content="0")
}

///|
test "run_cli matches wgrib2 empty output for -new_grid bitmap on alternating scan rows" {
  let fixture = "fixtures/grib2_derived/noaa_gfs_pgrb2b_scan48_bitmap_record266.grib2"
  let bilinear_out = "target/cmd_main_new_grid_bilinear_scan48_bitmap_out.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid", "latlon", "130.25:6:0.5",
      "30.5:5:0.5", bilinear_out,
    ]),
    content="0",
  )
  let bilinear_bytes = match native_read_bytes(bilinear_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to read scan48 bitmap bilinear new_grid output: " +
        e.to_string(),
      )
  }
  inspect(bilinear_bytes.length(), content="0")

  let neighbor_out = "target/cmd_main_new_grid_neighbor_scan48_bitmap_out.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid_interpolation", "neighbor",
      "-new_grid", "latlon", "130.25:6:0.5", "30.5:5:0.5", neighbor_out,
    ]),
    content="0",
  )
  let neighbor_bytes = match native_read_bytes(neighbor_out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to read scan48 bitmap neighbor new_grid output: " +
        e.to_string(),
      )
  }
  inspect(neighbor_bytes.length(), content="0")
}

///|
test "run_cli rejects -new_grid non-latlon projection" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_new_grid_bad_projection.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid", "mercator", "0:360:1",
    "-90:181:1", out,
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -new_grid latlon bilinear WIND output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_new_grid_wind_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid", "latlon", "260.5:8:1",
    "0.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) => fail("failed to read new_grid WIND output: " + e.to_string())
  }
  inspect(bytes.sub(start=0, end=4).to_bytes().to_string(), content="b\"GRIB\"")
}

///|
test "run_cli supports -new_grid latlon bilinear WDIR output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_new_grid_wdir_out.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "2:2:1", "-new_grid", "latlon", "260.5:8:1",
    "0.5:8:1", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) => fail("failed to read new_grid WDIR output: " + e.to_string())
  }
  inspect(bytes.sub(start=0, end=4).to_bytes().to_string(), content="b\"GRIB\"")
}

///|
test "build_netcdf axis values match wgrib2 rounding for gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse gfswave fixture: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  let latitudes = match build_netcdf_latitude_values(meta) {
    Ok(v) => v
    Err(e) => fail("failed to build netcdf latitude values: " + e)
  }
  let longitudes = match build_netcdf_longitude_values(meta) {
    Ok(v) => v
    Err(e) => fail("failed to build netcdf longitude values: " + e)
  }
  inspect(
    latitudes[0].reinterpret_as_uint64().to_string(),
    content="4389742999291035648",
  )
  inspect(
    latitudes[1].reinterpret_as_uint64().to_string(),
    content="4595172819793696195",
  )
  inspect(
    latitudes[205].reinterpret_as_uint64().to_string(),
    content="4630005348161639765",
  )
  inspect(
    longitudes[0].reinterpret_as_uint64().to_string(),
    content="13860109328209412096",
  )
  inspect(
    longitudes[1].reinterpret_as_uint64().to_string(),
    content="13860097600085382484",
  )
  inspect(
    longitudes[2].reinterpret_as_uint64().to_string(),
    content="13860085871961352872",
  )
}

///|
test "build_netcdf Mercator axis values follow COARDS orientation" {
  let grid : @section3.Grib2GridTemplate310 = {
    shape_of_earth: 6,
    scale_factor_radius: 0,
    scaled_value_radius: 0,
    scale_factor_major_axis: 0,
    scaled_value_major_axis: 0,
    scale_factor_minor_axis: 0,
    scaled_value_minor_axis: 0,
    ni: 3,
    nj: 331,
    la1: 55000000,
    lo1: 260000000,
    resolution_and_component_flags: 48,
    lad: 27500000,
    la2: 0,
    lo2: 310000000,
    scanning_mode: 0,
    orientation_of_the_grid: 0,
    di: 16439108,
    dj: 19766614,
  }
  let latitudes = match build_netcdf_mercator_latitude_values(grid) {
    Ok(v) => v
    Err(e) => fail("failed to build Mercator latitude values: " + e)
  }
  let longitudes = match build_netcdf_mercator_longitude_values(grid) {
    Ok(v) => v
    Err(e) => fail("failed to build Mercator longitude values: " + e)
  }
  inspect((latitudes[0] + 1.66149141038266e-06).abs() < 1.0e-12, content="true")
  inspect(latitudes[0] < latitudes[1], content="true")
  inspect((latitudes[1] - 0.200400263699615).abs() < 1.0e-12, content="true")
  inspect((latitudes[330] - 55.0).abs() < 1.0e-12, content="true")
  inspect((longitudes[0] + 100.0).abs() < 1.0e-12, content="true")
  inspect((longitudes[1] + 99.8333333362677).abs() < 1.0e-12, content="true")
  inspect((longitudes[2] + 99.6666666725355).abs() < 1.0e-12, content="true")
}

///|
test "netcdf forecast helpers preserve verification metadata and unit mapping" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse forecast fixture: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  inspect(netcdf_record_reference_time_type(meta), content="3")
  inspect(
    netcdf_record_reference_time_description(meta),
    content="forecast or accumulated, reference date is fixed",
  )
  inspect(netcdf_variable_name(meta), content="HGT_1000mb")
  let (long_name, units) = netcdf_long_name_units(meta)
  inspect(long_name, content="Geopotential Height")
  inspect(units, content="m")
  inspect(netcdf_verification_time_unix(meta).to_string(), content="1733508000")
}

///|
test "netcdf unit mapping follows wgrib2 conventions" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse pgrb2b fixture: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[2]
  let (long_name, units) = netcdf_long_name_units(meta)
  inspect(long_name, content="Relative Humidity")
  inspect(units, content="percent")
  inspect(
    netcdf_variable_name(@lib.decode_records(context)[265]),
    content="SOILL_0M0D1mbelowground",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(context)[266]),
    content="SOILL_0D1M0D4mbelowground",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(context)[286]),
    content="TMP_60M30mbaboveground",
  )

  let pgrb2_fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let pgrb2_context = match
    @lib.parse_with_io(native_read_bytes, pgrb2_fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse pgrb2 fixture: " + e.to_string())
  }
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[14]),
    content="HGT_0D01mb",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[15]),
    content="TMP_0D01mb",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[603]),
    content="PWAT_entireatmosphere_consideredasasinglelayer_",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[607]),
    content="LCDC_lowcloudlayer",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[611]),
    content="HGT_cloudceiling",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[612]),
    content="HLCY_3000M0maboveground",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[655]),
    content="HGT_highesttroposphericfreezinglevel",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[666]),
    content="RH_0D33M1sigmalayer",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[670]),
    content="TMP_0D995sigmalevel",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[662]),
    content="N4LFTX_surface",
  )
  inspect(
    netcdf_variable_name(@lib.decode_records(pgrb2_context)[684]),
    content="UGRD_PV_EQ_2eM06_Km_2_kg_s_surface",
  )
}

///|
test "netcdf reference attrs follow wgrib2 mixed-reference transitions" {
  let attrs = match
    build_netcdf_reference_attrs([
      { reference_time: 1000L, is_analysis: true },
      { reference_time: 1000L, is_analysis: false },
    ]) {
    Ok(v) => v
    Err(e) => fail("failed to build mixed-reference attrs: " + e)
  }
  inspect(attrs.reference_time_type.to_string(), content="3")
  inspect(
    attrs.reference_time_description,
    content="forecasts or accumulated (including analyses), reference date is fixed",
  )
  let reverse_attrs = match
    build_netcdf_reference_attrs([
      { reference_time: 1000L, is_analysis: false },
      { reference_time: 1000L, is_analysis: true },
    ]) {
    Ok(v) => v
    Err(e) => fail("failed to build reverse mixed-reference attrs: " + e)
  }
  inspect(reverse_attrs.reference_time_type.to_string(), content="3")
  inspect(
    reverse_attrs.reference_time_description,
    content="forecast or accumulated, reference date is fixed",
  )
  let variable_analysis_attrs = match
    build_netcdf_reference_attrs([
      { reference_time: 2000L, is_analysis: true },
      { reference_time: 1000L, is_analysis: true },
    ]) {
    Ok(v) => v
    Err(e) => fail("failed to build variable-analysis attrs: " + e)
  }
  inspect(variable_analysis_attrs.reference_time_type.to_string(), content="2")
  inspect(variable_analysis_attrs.reference_time.to_string(), content="1000")
  inspect(
    variable_analysis_attrs.reference_time_description,
    content="analyses, reference date is variable, min found reference date is given",
  )
}

///|
test "writes mixed-reference analysis netcdf fixture" {
  let out = "target/cmd_main_netcdf_mixed_reference_input.grib2"
  match write_mixed_reference_netcdf_input(out) {
    Ok(_) => ()
    Err(e) => fail("failed to write mixed-reference netcdf fixture: " + e)
  }
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read mixed-reference netcdf fixture: " + e.to_string())
  }
  inspect(count_grib_magic(bytes).to_string(), content="2")
}

///|
test "writes synthetic Mercator netcdf fixture" {
  let out = "target/cmd_main_netcdf_mercator_input.grib2"
  match write_synthetic_mercator_netcdf_input(out) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic Mercator netcdf fixture: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse synthetic Mercator fixture: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="1")
  inspect(metas[0].section3_template.id(), content="10")
}

///|
test "writes synthetic Mercator mixed-reference netcdf fixture" {
  let out = "target/cmd_main_netcdf_mercator_mixed_reference_input.grib2"
  match write_synthetic_mercator_mixed_reference_netcdf_input(out) {
    Ok(_) => ()
    Err(e) =>
      fail("failed to write synthetic Mercator mixed-reference fixture: " + e)
  }
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read synthetic Mercator mixed-reference fixture: " +
        e.to_string(),
      )
  }
  inspect(count_grib_magic(bytes).to_string(), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic Mercator mixed-reference fixture: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(metas[0].section3_template.id(), content="10")
  inspect(metas[1].section3_template.id(), content="10")
}

///|
test "writes synthetic rotated lat-lon netcdf fixture" {
  let out = "target/cmd_main_netcdf_rotated_input.grib2"
  match write_synthetic_rotated_latlon_netcdf_input(out) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic rotated lat-lon fixture: " + e)
  }
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) => fail("failed to read synthetic rotated lat-lon fixture: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic rotated lat-lon fixture: " + e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(bytes.length() > 0, content="true")
  inspect(metas.length(), content="1")
  inspect(metas[0].section3_template.id(), content="1")
}

///|
test "writes synthetic rotated lat-lon mixed-reference netcdf fixture" {
  let out = "target/cmd_main_netcdf_rotated_mixed_reference_input.grib2"
  match write_synthetic_rotated_latlon_mixed_reference_netcdf_input(out) {
    Ok(_) => ()
    Err(e) =>
      fail(
        "failed to write synthetic rotated lat-lon mixed-reference fixture: " +
        e,
      )
  }
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to read synthetic rotated lat-lon mixed-reference fixture: " + e,
      )
  }
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic rotated lat-lon mixed-reference fixture: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(count_grib_magic(bytes).to_string(), content="2")
  inspect(metas.length(), content="2")
  inspect(metas[0].section3_template.id(), content="1")
  inspect(metas[1].section3_template.id(), content="1")
}

///|
test "writes synthetic polar stereographic netcdf fixture" {
  let out = "target/cmd_main_netcdf_polar_input.grib2"
  match write_synthetic_polar_stereographic_netcdf_input(out) {
    Ok(_) => ()
    Err(e) =>
      fail("failed to write synthetic polar stereographic netcdf fixture: " + e)
  }
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) => fail("failed to read synthetic polar stereographic fixture: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic polar stereographic fixture: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(bytes.length() > 0, content="true")
  inspect(metas.length(), content="1")
  inspect(metas[0].section3_template.id(), content="20")
}

///|
test "writes synthetic polar stereographic mixed-reference netcdf fixture" {
  let out = "target/cmd_main_netcdf_polar_mixed_reference_input.grib2"
  match write_synthetic_polar_stereographic_mixed_reference_netcdf_input(out) {
    Ok(_) => ()
    Err(e) =>
      fail(
        "failed to write synthetic polar stereographic mixed-reference fixture: " +
        e,
      )
  }
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to read synthetic polar stereographic mixed-reference fixture: " +
        e,
      )
  }
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic polar stereographic mixed-reference fixture: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(count_grib_magic(bytes).to_string(), content="2")
  inspect(metas.length(), content="2")
  inspect(metas[0].section3_template.id(), content="20")
  inspect(metas[1].section3_template.id(), content="20")
}

///|
test "writes synthetic Lambert conformal netcdf fixture" {
  let out = "target/cmd_main_netcdf_lambert_input.grib2"
  match write_synthetic_lambert_conformal_netcdf_input(out) {
    Ok(_) => ()
    Err(e) =>
      fail("failed to write synthetic Lambert conformal netcdf fixture: " + e)
  }
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) => fail("failed to read synthetic Lambert conformal fixture: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic Lambert conformal fixture: " + e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(bytes.length() > 0, content="true")
  inspect(metas.length(), content="1")
  inspect(metas[0].section3_template.id(), content="30")
}

///|
test "writes synthetic Lambert conformal mixed-reference netcdf fixture" {
  let out = "target/cmd_main_netcdf_lambert_mixed_reference_input.grib2"
  match write_synthetic_lambert_conformal_mixed_reference_netcdf_input(out) {
    Ok(_) => ()
    Err(e) =>
      fail(
        "failed to write synthetic Lambert conformal mixed-reference fixture: " +
        e,
      )
  }
  let bytes = match native_read_bytes(out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to read synthetic Lambert conformal mixed-reference fixture: " +
        e,
      )
  }
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic Lambert conformal mixed-reference fixture: " +
        e.to_string(),
      )
  }
  let metas = @lib.decode_records(context)
  inspect(count_grib_magic(bytes).to_string(), content="2")
  inspect(metas.length(), content="2")
  inspect(metas[0].section3_template.id(), content="30")
  inspect(metas[1].section3_template.id(), content="30")
}

///|
test "run_cli supports single and multi-record -netcdf output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_netcdf_test.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read netcdf output: " + e.to_string())
  }
  inspect(
    bytes.sub(start=0, end=4).to_bytes().to_string(),
    content="b\"CDF\\x01\"",
  )
  inspect(bytes_be_u32(bytes, 4).to_string(), content="1")
  inspect(bytes.length() > 1000, content="true")
  let multi_out = "target/cmd_main_netcdf_multi.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", multi_out]),
    content="0",
  )
  let multi_bytes = @fs.read_file_to_bytes(multi_out) catch {
    e => fail("failed to read multi netcdf output: " + e.to_string())
  }
  inspect(bytes_be_u32(multi_bytes, 4).to_string(), content="1")
  inspect(multi_bytes.to_string().contains("CLMR_1hybridlevel"), content="true")
  let forecast_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let time_out = "target/cmd_main_netcdf_multi_time.nc"
  inspect(
    run_cli([
      "grib2_mbt", forecast_fixture, "-for_n", "1:185:92", "-netcdf", time_out,
    ]),
    content="0",
  )
  let time_bytes = @fs.read_file_to_bytes(time_out) catch {
    e => fail("failed to read multi-time netcdf output: " + e.to_string())
  }
  inspect(bytes_be_u32(time_bytes, 4).to_string(), content="3")
  inspect(time_bytes.to_string().contains("HGT_1000mb"), content="true")

  let bitmap_fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let bitmap_out = "target/cmd_main_netcdf_bitmap.nc"
  inspect(
    run_cli([
      "grib2_mbt", bitmap_fixture, "-for_n", "266:266:1", "-netcdf", bitmap_out,
    ]),
    content="0",
  )
  let bitmap_bytes = @fs.read_file_to_bytes(bitmap_out) catch {
    e => fail("failed to read bitmap netcdf output: " + e.to_string())
  }
  inspect(
    bitmap_bytes.to_string().contains("SOILL_0M0D1mbelowground"),
    content="true",
  )
  let bitmap_multi_out = "target/cmd_main_netcdf_bitmap_multi.nc"
  inspect(
    run_cli([
      "grib2_mbt", bitmap_fixture, "-for_n", "266:269:1", "-netcdf", bitmap_multi_out,
    ]),
    content="0",
  )
  let bitmap_multi_bytes = @fs.read_file_to_bytes(bitmap_multi_out) catch {
    e => fail("failed to read bitmap multi netcdf output: " + e.to_string())
  }
  inspect(
    bitmap_multi_bytes.to_string().contains("SOILL_0D1M0D4mbelowground"),
    content="true",
  )
  inspect(
    bitmap_multi_bytes.to_string().contains("SOILL_0D4M1mbelowground"),
    content="true",
  )
}

///|
test "run_cli supports synthetic Mercator -netcdf output" {
  let fixture = "target/cmd_main_netcdf_mercator_input.grib2"
  match write_synthetic_mercator_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic Mercator netcdf input: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse synthetic Mercator netcdf input: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) => fail("failed to build synthetic Mercator grid info: " + e)
  }
  let out = "target/cmd_main_netcdf_mercator.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail("failed to read synthetic Mercator netcdf output: " + e.to_string())
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) => fail("failed to parse synthetic Mercator netcdf output: " + e)
  }
  inspect(parsed.latitude_bytes == grid_info.latitude_bytes, content="true")
  inspect(parsed.longitude_bytes == grid_info.longitude_bytes, content="true")
  inspect(parsed.fields.length(), content="1")
  inspect(parsed.time_values.length(), content="1")
}

///|
test "run_cli supports synthetic Mercator mixed-reference -netcdf and append" {
  let fixture = "target/cmd_main_netcdf_mercator_mixed_reference_input.grib2"
  match write_synthetic_mercator_mixed_reference_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) =>
      fail(
        "failed to write synthetic Mercator mixed-reference netcdf input: " + e,
      )
  }
  let out = "target/cmd_main_netcdf_mercator_mixed_reference.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read synthetic Mercator mixed-reference output: " +
        e.to_string(),
      )
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse synthetic Mercator mixed-reference output: " + e)
  }
  inspect(parsed.time_values.length().to_string(), content="2")
  inspect(parsed.reference_time_type.to_string(), content="2")

  let append_out = "target/cmd_main_netcdf_mercator_mixed_reference_append.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", append_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-netcdf", append_out,
    ]),
    content="0",
  )
  let append_bytes = @fs.read_file_to_bytes(append_out) catch {
    e =>
      fail(
        "failed to read synthetic Mercator mixed-reference append output: " +
        e.to_string(),
      )
  }
  inspect(append_bytes == bytes, content="true")
}

///|
test "run_cli supports JPEG2000 regular lat/lon -netcdf output" {
  let fixture = "fixtures/grib2_jpeg2000/eccodes_jpeg.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse JPEG2000 netcdf input: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) => fail("failed to build JPEG2000 netcdf grid info: " + e)
  }
  let out = "target/cmd_main_netcdf_eccodes_jpeg.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read JPEG2000 netcdf output: " + e.to_string())
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) => fail("failed to parse JPEG2000 netcdf output: " + e)
  }
  inspect(parsed.latitude_bytes == grid_info.latitude_bytes, content="true")
  inspect(parsed.longitude_bytes == grid_info.longitude_bytes, content="true")
  inspect(parsed.fields.length(), content="1")
  inspect(parsed.time_values.length(), content="1")
}

///|
test "run_cli supports bitmap254 regular lat/lon -netcdf output" {
  let fixture = "fixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse bitmap254 netcdf input: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) => fail("failed to build bitmap254 netcdf grid info: " + e)
  }
  let out = "target/cmd_main_netcdf_bitmap254.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read bitmap254 netcdf output: " + e.to_string())
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) => fail("failed to parse bitmap254 netcdf output: " + e)
  }
  inspect(parsed.fields.length(), content="1")
  inspect(parsed.time_values.length(), content="1")
  inspect(parsed.latitude_bytes == grid_info.latitude_bytes, content="true")
  inspect(parsed.longitude_bytes == grid_info.longitude_bytes, content="true")
}

///|
test "run_cli supports bitmap254 regular lat/lon multi-record and append -netcdf output" {
  let fixture = "fixtures/grib2_derived/noaa_gfswave_global_bitmap254_records5_6.grib2"
  let multi_out = "target/cmd_main_netcdf_bitmap254_multi.nc"
  let append_out = "target/cmd_main_netcdf_bitmap254_append.nc"
  let append_ref = "target/cmd_main_netcdf_bitmap254_append_ref.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", multi_out]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", append_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-netcdf", append_out,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", append_ref]),
    content="0",
  )
  let append_bytes = @fs.read_file_to_bytes(append_out) catch {
    e => fail("failed to read bitmap254 append output: " + e.to_string())
  }
  let ref_bytes = @fs.read_file_to_bytes(append_ref) catch {
    e => fail("failed to read bitmap254 append reference: " + e.to_string())
  }
  let multi_bytes = @fs.read_file_to_bytes(multi_out) catch {
    e => fail("failed to read bitmap254 multi output: " + e.to_string())
  }
  inspect(append_bytes == ref_bytes, content="true")
  inspect(multi_bytes == ref_bytes, content="true")
}

///|
test "run_cli reports reduced Gaussian netcdf unavailable like wgrib2" {
  let fixture = "fixtures/grib2_jpeg2000/eccodes_reduced_gaussian_surface_jpeg.grib2"
  let out = "target/cmd_main_reduced_gaussian_netcdf.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1", "-netcdf", out]),
    content="8",
  )
}

///|
test "run_cli supports rotated lat-lon -netcdf output with wgrib2 notice lines" {
  let fixture = "target/cmd_main_netcdf_rotated_input.grib2"
  match write_synthetic_rotated_latlon_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic rotated lat-lon input: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse synthetic rotated lat-lon input: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) => fail("failed to build synthetic rotated lat-lon grid info: " + e)
  }
  let out = "target/cmd_main_rotated_latlon_netcdf.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read synthetic rotated lat-lon netcdf output: " +
        e.to_string(),
      )
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse synthetic rotated lat-lon netcdf output: " + e)
  }
  inspect(parsed.latitude_bytes == grid_info.latitude_bytes, content="true")
  inspect(parsed.longitude_bytes == grid_info.longitude_bytes, content="true")
  inspect(
    netcdf_read_double_be(parsed.latitude_bytes, 0) < -36.08851 &&
    netcdf_read_double_be(parsed.latitude_bytes, 0) > -36.08853,
    content="true",
  )
  inspect(
    netcdf_read_double_be(parsed.latitude_bytes, 8) ==
    netcdf_read_double_be(parsed.latitude_bytes, 0),
    content="true",
  )
  inspect(bytes.to_string().contains("projection_x_coordinate"), content="true")
  inspect(bytes.to_string().contains("longitude latitude"), content="true")
  inspect(parsed.fields.length(), content="1")
  inspect(parsed.time_values.length(), content="1")
}

///|
test "run_cli supports rotated lat-lon mixed-reference -netcdf and append" {
  let fixture = "target/cmd_main_netcdf_rotated_mixed_reference_input.grib2"
  match write_synthetic_rotated_latlon_mixed_reference_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) =>
      fail(
        "failed to write synthetic rotated lat-lon mixed-reference input: " + e,
      )
  }
  let out = "target/cmd_main_rotated_latlon_mixed_reference_netcdf.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read synthetic rotated lat-lon mixed-reference output: " +
        e.to_string(),
      )
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic rotated lat-lon mixed-reference output: " + e,
      )
  }
  inspect(parsed.time_values.length().to_string(), content="2")
  inspect(parsed.reference_time_type.to_string(), content="2")

  let append_out = "target/cmd_main_rotated_latlon_mixed_reference_append.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", append_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-netcdf", append_out,
    ]),
    content="0",
  )
  let append_bytes = @fs.read_file_to_bytes(append_out) catch {
    e =>
      fail(
        "failed to read synthetic rotated lat-lon mixed-reference append output: " +
        e.to_string(),
      )
  }
  inspect(append_bytes == bytes, content="true")
}

///|
test "build_netcdf rotated lat-lon axis values match wgrib2 at corrected points" {
  let fixture = "target/cmd_main_netcdf_rotated_input.grib2"
  match write_synthetic_rotated_latlon_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic rotated lat-lon input: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse synthetic rotated lat-lon input: " + e.to_string())
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) => fail("failed to build synthetic rotated lat-lon grid info: " + e)
  }
  inspect(
    netcdf_read_double_be(grid_info.latitude_bytes, 0)
    .reinterpret_as_uint64()
    .to_string(),
    content="13853647861827536221",
  )
  inspect(
    netcdf_read_double_be(grid_info.latitude_bytes, 363 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="13853507314812790732",
  )
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 0)
    .reinterpret_as_uint64()
    .to_string(),
    content="4642834923955672154",
  )
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 752 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4642880104229469422",
  )
}

///|
test "rotated lat-lon netcdf longitude keeps singular meridian on positive pi branch" {
  let (_lat, lon) = netcdf_rotate_rotated_latlon_to_geographic(
    20.0, 180.0, -36.08852, 245.305142, 0.0,
  )
  inspect(lon > 425.305141 && lon < 425.305143, content="true")
}

///|
test "rotated lat-lon netcdf longitude wraps west-column singularity like wgrib2" {
  let (_lat, lon) = netcdf_rotate_rotated_latlon_to_geographic(
    37.0, 0.0, -36.08852, 245.305142, 0.0,
  )
  inspect(lon > 65.305141 && lon < 65.305143, content="true")
}

///|
test "run_cli supports synthetic polar stereographic -netcdf output" {
  let fixture = "target/cmd_main_netcdf_polar_input.grib2"
  match write_synthetic_polar_stereographic_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic polar stereographic input: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic polar stereographic input: " + e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) =>
      fail("failed to build synthetic polar stereographic grid info: " + e)
  }
  let out = "target/cmd_main_polar_netcdf.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read synthetic polar stereographic netcdf output: " +
        e.to_string(),
      )
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse synthetic polar stereographic netcdf output: " + e)
  }
  inspect(parsed.latitude_bytes == grid_info.latitude_bytes, content="true")
  inspect(parsed.longitude_bytes == grid_info.longitude_bytes, content="true")
  inspect(bytes.to_string().contains("projection_x_coordinate"), content="true")
  inspect(bytes.to_string().contains("longitude latitude"), content="true")
  inspect(parsed.fields.length(), content="1")
  inspect(parsed.time_values.length(), content="1")
}

///|
test "run_cli supports synthetic polar stereographic mixed-reference -netcdf and append" {
  let fixture = "target/cmd_main_netcdf_polar_mixed_reference_input.grib2"
  match
    write_synthetic_polar_stereographic_mixed_reference_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) =>
      fail(
        "failed to write synthetic polar stereographic mixed-reference input: " +
        e,
      )
  }
  let out = "target/cmd_main_polar_mixed_reference_netcdf.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read synthetic polar stereographic mixed-reference output: " +
        e.to_string(),
      )
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic polar stereographic mixed-reference output: " +
        e,
      )
  }
  inspect(parsed.time_values.length().to_string(), content="2")
  inspect(parsed.reference_time_type.to_string(), content="2")

  let append_out = "target/cmd_main_polar_mixed_reference_append.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", append_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-netcdf", append_out,
    ]),
    content="0",
  )
  let append_bytes = @fs.read_file_to_bytes(append_out) catch {
    e =>
      fail(
        "failed to read synthetic polar stereographic mixed-reference append output: " +
        e.to_string(),
      )
  }
  inspect(append_bytes == bytes, content="true")
}

///|
test "build_netcdf polar stereographic longitude values match wgrib2 at corrected points" {
  let fixture = "target/cmd_main_netcdf_polar_input.grib2"
  match write_synthetic_polar_stereographic_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic polar stereographic input: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic polar stereographic input: " + e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) =>
      fail("failed to build synthetic polar stereographic grid info: " + e)
  }
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 8 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4612912808828345939",
  )
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 46 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4624259750756451479",
  )
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 5000 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4633984616628478541",
  )
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 65000 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4636033603912859648",
  )
}

///|
test "run_cli supports synthetic Lambert conformal -netcdf output" {
  let fixture = "target/cmd_main_netcdf_lambert_input.grib2"
  match write_synthetic_lambert_conformal_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic Lambert conformal input: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic Lambert conformal input: " + e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) =>
      fail("failed to build synthetic Lambert conformal grid info: " + e)
  }
  let out = "target/cmd_main_lambert_netcdf.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read synthetic Lambert conformal netcdf output: " +
        e.to_string(),
      )
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse synthetic Lambert conformal netcdf output: " + e)
  }
  inspect(parsed.latitude_bytes == grid_info.latitude_bytes, content="true")
  inspect(parsed.longitude_bytes == grid_info.longitude_bytes, content="true")
  inspect(bytes.to_string().contains("projection_y_coordinate"), content="true")
  inspect(bytes.to_string().contains("longitude latitude"), content="true")
  inspect(parsed.fields.length(), content="1")
  inspect(parsed.time_values.length(), content="1")
}

///|
test "run_cli supports synthetic Lambert conformal mixed-reference -netcdf and append" {
  let fixture = "target/cmd_main_netcdf_lambert_mixed_reference_input.grib2"
  match
    write_synthetic_lambert_conformal_mixed_reference_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) =>
      fail(
        "failed to write synthetic Lambert conformal mixed-reference input: " +
        e,
      )
  }
  let out = "target/cmd_main_lambert_mixed_reference_netcdf.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e =>
      fail(
        "failed to read synthetic Lambert conformal mixed-reference output: " +
        e.to_string(),
      )
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic Lambert conformal mixed-reference output: " +
        e,
      )
  }
  inspect(parsed.time_values.length().to_string(), content="2")
  inspect(parsed.reference_time_type.to_string(), content="2")

  let append_out = "target/cmd_main_lambert_mixed_reference_append.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", append_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-netcdf", append_out,
    ]),
    content="0",
  )
  let append_bytes = @fs.read_file_to_bytes(append_out) catch {
    e =>
      fail(
        "failed to read synthetic Lambert conformal mixed-reference append output: " +
        e.to_string(),
      )
  }
  inspect(append_bytes == bytes, content="true")
}

///|
test "build_netcdf Lambert conformal longitude values match wgrib2 at corrected points" {
  let fixture = "target/cmd_main_netcdf_lambert_input.grib2"
  match write_synthetic_lambert_conformal_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write synthetic Lambert conformal input: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse synthetic Lambert conformal input: " + e.to_string(),
      )
  }
  let meta = @lib.decode_records(context)[0]
  let message = context.messages[0]
  let submessage = message.submessages[0]
  let grid_info = match
    build_netcdf_grid_info(
      meta,
      section_frame_bytes(message, submessage.section3),
    ) {
    Ok(v) => v
    Err(e) =>
      fail("failed to build synthetic Lambert conformal grid info: " + e)
  }
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 8 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4615190601474922736",
  )
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 46 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4626332196579411408",
  )
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 5000 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4635840863041663281",
  )
  inspect(
    netcdf_read_double_be(grid_info.longitude_bytes, 65000 * 8)
    .reinterpret_as_uint64()
    .to_string(),
    content="4638551004412998584",
  )
}

///|
test "run_cli supports mixed-reference analysis -netcdf output" {
  let fixture = "target/cmd_main_netcdf_mixed_reference_input.grib2"
  match write_mixed_reference_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write mixed-reference netcdf input: " + e)
  }
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) =>
      fail("failed to parse mixed-reference netcdf input: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  let out = "target/cmd_main_netcdf_mixed_reference.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read mixed-reference netcdf output: " + e.to_string())
  }
  let parsed = match parse_existing_netcdf_file(bytes) {
    Ok(v) => v
    Err(e) => fail("failed to parse mixed-reference netcdf output: " + e)
  }
  inspect(bytes_be_u32(bytes, 4).to_string(), content="2")
  inspect(parsed.reference_time_type.to_string(), content="2")
  inspect(
    parsed.reference_time_description,
    content="analyses, reference date is variable, min found reference date is given",
  )
  inspect(
    parsed.reference_time.to_string(),
    content=metas[0].unix_rt.to_string(),
  )
  inspect(parsed.time_values.length().to_string(), content="2")
}

///|
test "run_cli supports -append for netcdf variable and time growth" {
  let gsm_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let gsm_append = "target/cmd_main_netcdf_append_gsm_var.nc"
  let gsm_ref = "target/cmd_main_netcdf_append_gsm_var_ref.nc"
  inspect(
    run_cli(["grib2_mbt", gsm_fixture, "-for_n", "1:1:1", "-netcdf", gsm_append]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-append", "-for_n", "2:2:1", "-netcdf", gsm_append,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", gsm_fixture, "-for_n", "1:2:1", "-netcdf", gsm_ref]),
    content="0",
  )
  let gsm_append_bytes = @fs.read_file_to_bytes(gsm_append) catch {
    e => fail("failed to read appended gsm variable netcdf: " + e.to_string())
  }
  let gsm_ref_bytes = @fs.read_file_to_bytes(gsm_ref) catch {
    e => fail("failed to read gsm variable reference netcdf: " + e.to_string())
  }
  inspect(gsm_append_bytes == gsm_ref_bytes, content="true")

  let gsm_multi_4 = "target/cmd_main_netcdf_gsm_multi_4.nc"
  let gsm_multi_4_ref = "target/cmd_main_netcdf_gsm_multi_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:4:1", "-netcdf", gsm_multi_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:4:1", "-netcdf", gsm_multi_4_ref,
    ]),
    content="0",
  )
  let gsm_multi_4_bytes = @fs.read_file_to_bytes(gsm_multi_4) catch {
    e => fail("failed to read gsm multi-4 netcdf: " + e.to_string())
  }
  let gsm_multi_4_ref_bytes = @fs.read_file_to_bytes(gsm_multi_4_ref) catch {
    e => fail("failed to read gsm multi-4 reference netcdf: " + e.to_string())
  }
  inspect(gsm_multi_4_bytes == gsm_multi_4_ref_bytes, content="true")

  let gsm_append_4 = "target/cmd_main_netcdf_append_gsm_var4.nc"
  let gsm_append_4_ref = "target/cmd_main_netcdf_append_gsm_var4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:1:1", "-netcdf", gsm_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-append", "-for_n", "2:4:1", "-netcdf", gsm_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:4:1", "-netcdf", gsm_append_4_ref,
    ]),
    content="0",
  )
  let gsm_append_4_bytes = @fs.read_file_to_bytes(gsm_append_4) catch {
    e => fail("failed to read appended gsm variable-4 netcdf: " + e.to_string())
  }
  let gsm_append_4_ref_bytes = @fs.read_file_to_bytes(gsm_append_4_ref) catch {
    e =>
      fail("failed to read gsm variable-4 reference netcdf: " + e.to_string())
  }
  inspect(gsm_append_4_bytes == gsm_append_4_ref_bytes, content="true")

  let gsm_multi_8 = "target/cmd_main_netcdf_gsm_multi_8.nc"
  let gsm_multi_8_ref = "target/cmd_main_netcdf_gsm_multi_8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:8:1", "-netcdf", gsm_multi_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:8:1", "-netcdf", gsm_multi_8_ref,
    ]),
    content="0",
  )
  let gsm_multi_8_bytes = @fs.read_file_to_bytes(gsm_multi_8) catch {
    e => fail("failed to read gsm multi-8 netcdf: " + e.to_string())
  }
  let gsm_multi_8_ref_bytes = @fs.read_file_to_bytes(gsm_multi_8_ref) catch {
    e => fail("failed to read gsm multi-8 reference netcdf: " + e.to_string())
  }
  inspect(gsm_multi_8_bytes == gsm_multi_8_ref_bytes, content="true")

  let gsm_append_8 = "target/cmd_main_netcdf_append_gsm_var8.nc"
  let gsm_append_8_ref = "target/cmd_main_netcdf_append_gsm_var8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:1:1", "-netcdf", gsm_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-append", "-for_n", "2:8:1", "-netcdf", gsm_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:8:1", "-netcdf", gsm_append_8_ref,
    ]),
    content="0",
  )
  let gsm_append_8_bytes = @fs.read_file_to_bytes(gsm_append_8) catch {
    e => fail("failed to read appended gsm variable-8 netcdf: " + e.to_string())
  }
  let gsm_append_8_ref_bytes = @fs.read_file_to_bytes(gsm_append_8_ref) catch {
    e =>
      fail("failed to read gsm variable-8 reference netcdf: " + e.to_string())
  }
  inspect(gsm_append_8_bytes == gsm_append_8_ref_bytes, content="true")

  let gsm_multi_16 = "target/cmd_main_netcdf_gsm_multi_16.nc"
  let gsm_multi_16_ref = "target/cmd_main_netcdf_gsm_multi_16_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:16:1", "-netcdf", gsm_multi_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:16:1", "-netcdf", gsm_multi_16_ref,
    ]),
    content="0",
  )
  let gsm_multi_16_bytes = @fs.read_file_to_bytes(gsm_multi_16) catch {
    e => fail("failed to read gsm multi-16 netcdf: " + e.to_string())
  }
  let gsm_multi_16_ref_bytes = @fs.read_file_to_bytes(gsm_multi_16_ref) catch {
    e => fail("failed to read gsm multi-16 reference netcdf: " + e.to_string())
  }
  inspect(gsm_multi_16_bytes == gsm_multi_16_ref_bytes, content="true")

  let gsm_append_16 = "target/cmd_main_netcdf_append_gsm_var16.nc"
  let gsm_append_16_ref = "target/cmd_main_netcdf_append_gsm_var16_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:1:1", "-netcdf", gsm_append_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-append", "-for_n", "2:16:1", "-netcdf", gsm_append_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:16:1", "-netcdf", gsm_append_16_ref,
    ]),
    content="0",
  )
  let gsm_append_16_bytes = @fs.read_file_to_bytes(gsm_append_16) catch {
    e =>
      fail("failed to read appended gsm variable-16 netcdf: " + e.to_string())
  }
  let gsm_append_16_ref_bytes = @fs.read_file_to_bytes(gsm_append_16_ref) catch {
    e =>
      fail("failed to read gsm variable-16 reference netcdf: " + e.to_string())
  }
  inspect(gsm_append_16_bytes == gsm_append_16_ref_bytes, content="true")

  let gsm_multi_32 = "target/cmd_main_netcdf_gsm_multi_32.nc"
  let gsm_multi_32_ref = "target/cmd_main_netcdf_gsm_multi_32_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:32:1", "-netcdf", gsm_multi_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:32:1", "-netcdf", gsm_multi_32_ref,
    ]),
    content="0",
  )
  let gsm_multi_32_bytes = @fs.read_file_to_bytes(gsm_multi_32) catch {
    e => fail("failed to read gsm multi-32 netcdf: " + e.to_string())
  }
  let gsm_multi_32_ref_bytes = @fs.read_file_to_bytes(gsm_multi_32_ref) catch {
    e => fail("failed to read gsm multi-32 reference netcdf: " + e.to_string())
  }
  inspect(gsm_multi_32_bytes == gsm_multi_32_ref_bytes, content="true")

  let gsm_append_32 = "target/cmd_main_netcdf_append_gsm_var32.nc"
  let gsm_append_32_ref = "target/cmd_main_netcdf_append_gsm_var32_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:1:1", "-netcdf", gsm_append_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-append", "-for_n", "2:32:1", "-netcdf", gsm_append_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:32:1", "-netcdf", gsm_append_32_ref,
    ]),
    content="0",
  )
  let gsm_append_32_bytes = @fs.read_file_to_bytes(gsm_append_32) catch {
    e =>
      fail("failed to read appended gsm variable-32 netcdf: " + e.to_string())
  }
  let gsm_append_32_ref_bytes = @fs.read_file_to_bytes(gsm_append_32_ref) catch {
    e =>
      fail("failed to read gsm variable-32 reference netcdf: " + e.to_string())
  }
  inspect(gsm_append_32_bytes == gsm_append_32_ref_bytes, content="true")

  let gsm_multi_64 = "target/cmd_main_netcdf_gsm_multi_64.nc"
  let gsm_multi_64_ref = "target/cmd_main_netcdf_gsm_multi_64_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:64:1", "-netcdf", gsm_multi_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:64:1", "-netcdf", gsm_multi_64_ref,
    ]),
    content="0",
  )
  let gsm_multi_64_bytes = @fs.read_file_to_bytes(gsm_multi_64) catch {
    e => fail("failed to read gsm multi-64 netcdf: " + e.to_string())
  }
  let gsm_multi_64_ref_bytes = @fs.read_file_to_bytes(gsm_multi_64_ref) catch {
    e => fail("failed to read gsm multi-64 reference netcdf: " + e.to_string())
  }
  inspect(gsm_multi_64_bytes == gsm_multi_64_ref_bytes, content="true")

  let gsm_append_64 = "target/cmd_main_netcdf_append_gsm_var64.nc"
  let gsm_append_64_ref = "target/cmd_main_netcdf_append_gsm_var64_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:1:1", "-netcdf", gsm_append_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-append", "-for_n", "2:64:1", "-netcdf", gsm_append_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", gsm_fixture, "-for_n", "1:64:1", "-netcdf", gsm_append_64_ref,
    ]),
    content="0",
  )
  let gsm_append_64_bytes = @fs.read_file_to_bytes(gsm_append_64) catch {
    e =>
      fail("failed to read appended gsm variable-64 netcdf: " + e.to_string())
  }
  let gsm_append_64_ref_bytes = @fs.read_file_to_bytes(gsm_append_64_ref) catch {
    e =>
      fail("failed to read gsm variable-64 reference netcdf: " + e.to_string())
  }
  inspect(gsm_append_64_bytes == gsm_append_64_ref_bytes, content="true")

  let var_fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let var_append = "target/cmd_main_netcdf_append_var.nc"
  let var_ref = "target/cmd_main_netcdf_append_var_ref.nc"
  inspect(
    run_cli(["grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:2:1", "-netcdf", var_append,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", var_fixture, "-for_n", "1:2:1", "-netcdf", var_ref]),
    content="0",
  )
  let var_append_bytes = @fs.read_file_to_bytes(var_append) catch {
    e => fail("failed to read appended variable netcdf: " + e.to_string())
  }
  let var_ref_bytes = @fs.read_file_to_bytes(var_ref) catch {
    e => fail("failed to read variable reference netcdf: " + e.to_string())
  }
  inspect(var_append_bytes == var_ref_bytes, content="true")

  let var_multi_4 = "target/cmd_main_netcdf_var_multi_4.nc"
  let var_multi_4_ref = "target/cmd_main_netcdf_var_multi_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:4:1", "-netcdf", var_multi_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:4:1", "-netcdf", var_multi_4_ref,
    ]),
    content="0",
  )
  let var_multi_4_bytes = @fs.read_file_to_bytes(var_multi_4) catch {
    e => fail("failed to read variable multi-4 netcdf: " + e.to_string())
  }
  let var_multi_4_ref_bytes = @fs.read_file_to_bytes(var_multi_4_ref) catch {
    e =>
      fail("failed to read variable multi-4 reference netcdf: " + e.to_string())
  }
  inspect(var_multi_4_bytes == var_multi_4_ref_bytes, content="true")

  let var_multi_8 = "target/cmd_main_netcdf_var_multi_8.nc"
  let var_multi_8_ref = "target/cmd_main_netcdf_var_multi_8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:8:1", "-netcdf", var_multi_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:8:1", "-netcdf", var_multi_8_ref,
    ]),
    content="0",
  )
  let var_multi_8_bytes = @fs.read_file_to_bytes(var_multi_8) catch {
    e => fail("failed to read variable multi-8 netcdf: " + e.to_string())
  }
  let var_multi_8_ref_bytes = @fs.read_file_to_bytes(var_multi_8_ref) catch {
    e =>
      fail("failed to read variable multi-8 reference netcdf: " + e.to_string())
  }
  inspect(var_multi_8_bytes == var_multi_8_ref_bytes, content="true")

  let var_multi_12 = "target/cmd_main_netcdf_var_multi_12.nc"
  let var_multi_12_ref = "target/cmd_main_netcdf_var_multi_12_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:12:1", "-netcdf", var_multi_12,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:12:1", "-netcdf", var_multi_12_ref,
    ]),
    content="0",
  )
  let var_multi_12_bytes = @fs.read_file_to_bytes(var_multi_12) catch {
    e => fail("failed to read variable multi-12 netcdf: " + e.to_string())
  }
  let var_multi_12_ref_bytes = @fs.read_file_to_bytes(var_multi_12_ref) catch {
    e =>
      fail(
        "failed to read variable multi-12 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_12_bytes == var_multi_12_ref_bytes, content="true")

  let var_multi_16 = "target/cmd_main_netcdf_var_multi_16.nc"
  let var_multi_16_ref = "target/cmd_main_netcdf_var_multi_16_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:16:1", "-netcdf", var_multi_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:16:1", "-netcdf", var_multi_16_ref,
    ]),
    content="0",
  )
  let var_multi_16_bytes = @fs.read_file_to_bytes(var_multi_16) catch {
    e => fail("failed to read variable multi-16 netcdf: " + e.to_string())
  }
  let var_multi_16_ref_bytes = @fs.read_file_to_bytes(var_multi_16_ref) catch {
    e =>
      fail(
        "failed to read variable multi-16 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_16_bytes == var_multi_16_ref_bytes, content="true")

  let var_multi_19 = "target/cmd_main_netcdf_var_multi_19.nc"
  let var_multi_19_ref = "target/cmd_main_netcdf_var_multi_19_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:19:1", "-netcdf", var_multi_19,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:19:1", "-netcdf", var_multi_19_ref,
    ]),
    content="0",
  )
  let var_multi_19_bytes = @fs.read_file_to_bytes(var_multi_19) catch {
    e => fail("failed to read variable multi-19 netcdf: " + e.to_string())
  }
  let var_multi_19_ref_bytes = @fs.read_file_to_bytes(var_multi_19_ref) catch {
    e =>
      fail(
        "failed to read variable multi-19 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_19_bytes == var_multi_19_ref_bytes, content="true")

  let var_multi_24 = "target/cmd_main_netcdf_var_multi_24.nc"
  let var_multi_24_ref = "target/cmd_main_netcdf_var_multi_24_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:24:1", "-netcdf", var_multi_24,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:24:1", "-netcdf", var_multi_24_ref,
    ]),
    content="0",
  )
  let var_multi_24_bytes = @fs.read_file_to_bytes(var_multi_24) catch {
    e => fail("failed to read variable multi-24 netcdf: " + e.to_string())
  }
  let var_multi_24_ref_bytes = @fs.read_file_to_bytes(var_multi_24_ref) catch {
    e =>
      fail(
        "failed to read variable multi-24 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_24_bytes == var_multi_24_ref_bytes, content="true")

  let var_multi_32 = "target/cmd_main_netcdf_var_multi_32.nc"
  let var_multi_32_ref = "target/cmd_main_netcdf_var_multi_32_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:32:1", "-netcdf", var_multi_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:32:1", "-netcdf", var_multi_32_ref,
    ]),
    content="0",
  )
  let var_multi_32_bytes = @fs.read_file_to_bytes(var_multi_32) catch {
    e => fail("failed to read variable multi-32 netcdf: " + e.to_string())
  }
  let var_multi_32_ref_bytes = @fs.read_file_to_bytes(var_multi_32_ref) catch {
    e =>
      fail(
        "failed to read variable multi-32 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_32_bytes == var_multi_32_ref_bytes, content="true")

  let var_multi_40 = "target/cmd_main_netcdf_var_multi_40.nc"
  let var_multi_40_ref = "target/cmd_main_netcdf_var_multi_40_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:40:1", "-netcdf", var_multi_40,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:40:1", "-netcdf", var_multi_40_ref,
    ]),
    content="0",
  )
  let var_multi_40_bytes = @fs.read_file_to_bytes(var_multi_40) catch {
    e => fail("failed to read variable multi-40 netcdf: " + e.to_string())
  }
  let var_multi_40_ref_bytes = @fs.read_file_to_bytes(var_multi_40_ref) catch {
    e =>
      fail(
        "failed to read variable multi-40 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_40_bytes == var_multi_40_ref_bytes, content="true")

  let var_multi_48 = "target/cmd_main_netcdf_var_multi_48.nc"
  let var_multi_48_ref = "target/cmd_main_netcdf_var_multi_48_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:48:1", "-netcdf", var_multi_48,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:48:1", "-netcdf", var_multi_48_ref,
    ]),
    content="0",
  )
  let var_multi_48_bytes = @fs.read_file_to_bytes(var_multi_48) catch {
    e => fail("failed to read variable multi-48 netcdf: " + e.to_string())
  }
  let var_multi_48_ref_bytes = @fs.read_file_to_bytes(var_multi_48_ref) catch {
    e =>
      fail(
        "failed to read variable multi-48 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_48_bytes == var_multi_48_ref_bytes, content="true")

  let var_multi_56 = "target/cmd_main_netcdf_var_multi_56.nc"
  let var_multi_56_ref = "target/cmd_main_netcdf_var_multi_56_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:56:1", "-netcdf", var_multi_56,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:56:1", "-netcdf", var_multi_56_ref,
    ]),
    content="0",
  )
  let var_multi_56_bytes = @fs.read_file_to_bytes(var_multi_56) catch {
    e => fail("failed to read variable multi-56 netcdf: " + e.to_string())
  }
  let var_multi_56_ref_bytes = @fs.read_file_to_bytes(var_multi_56_ref) catch {
    e =>
      fail(
        "failed to read variable multi-56 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_56_bytes == var_multi_56_ref_bytes, content="true")

  let var_multi_64 = "target/cmd_main_netcdf_var_multi_64.nc"
  let var_multi_64_ref = "target/cmd_main_netcdf_var_multi_64_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:64:1", "-netcdf", var_multi_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:64:1", "-netcdf", var_multi_64_ref,
    ]),
    content="0",
  )
  let var_multi_64_bytes = @fs.read_file_to_bytes(var_multi_64) catch {
    e => fail("failed to read variable multi-64 netcdf: " + e.to_string())
  }
  let var_multi_64_ref_bytes = @fs.read_file_to_bytes(var_multi_64_ref) catch {
    e =>
      fail(
        "failed to read variable multi-64 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_64_bytes == var_multi_64_ref_bytes, content="true")

  let var_multi_72 = "target/cmd_main_netcdf_var_multi_72.nc"
  let var_multi_72_ref = "target/cmd_main_netcdf_var_multi_72_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:72:1", "-netcdf", var_multi_72,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:72:1", "-netcdf", var_multi_72_ref,
    ]),
    content="0",
  )
  let var_multi_72_bytes = @fs.read_file_to_bytes(var_multi_72) catch {
    e => fail("failed to read variable multi-72 netcdf: " + e.to_string())
  }
  let var_multi_72_ref_bytes = @fs.read_file_to_bytes(var_multi_72_ref) catch {
    e =>
      fail(
        "failed to read variable multi-72 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_72_bytes == var_multi_72_ref_bytes, content="true")

  let var_multi_80 = "target/cmd_main_netcdf_var_multi_80.nc"
  let var_multi_80_ref = "target/cmd_main_netcdf_var_multi_80_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:80:1", "-netcdf", var_multi_80,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:80:1", "-netcdf", var_multi_80_ref,
    ]),
    content="0",
  )
  let var_multi_80_bytes = @fs.read_file_to_bytes(var_multi_80) catch {
    e => fail("failed to read variable multi-80 netcdf: " + e.to_string())
  }
  let var_multi_80_ref_bytes = @fs.read_file_to_bytes(var_multi_80_ref) catch {
    e =>
      fail(
        "failed to read variable multi-80 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_80_bytes == var_multi_80_ref_bytes, content="true")

  let var_multi_88 = "target/cmd_main_netcdf_var_multi_88.nc"
  let var_multi_88_ref = "target/cmd_main_netcdf_var_multi_88_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:88:1", "-netcdf", var_multi_88,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:88:1", "-netcdf", var_multi_88_ref,
    ]),
    content="0",
  )
  let var_multi_88_bytes = @fs.read_file_to_bytes(var_multi_88) catch {
    e => fail("failed to read variable multi-88 netcdf: " + e.to_string())
  }
  let var_multi_88_ref_bytes = @fs.read_file_to_bytes(var_multi_88_ref) catch {
    e =>
      fail(
        "failed to read variable multi-88 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_88_bytes == var_multi_88_ref_bytes, content="true")

  let var_multi_96 = "target/cmd_main_netcdf_var_multi_96.nc"
  let var_multi_96_ref = "target/cmd_main_netcdf_var_multi_96_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:96:1", "-netcdf", var_multi_96,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:96:1", "-netcdf", var_multi_96_ref,
    ]),
    content="0",
  )
  let var_multi_96_bytes = @fs.read_file_to_bytes(var_multi_96) catch {
    e => fail("failed to read variable multi-96 netcdf: " + e.to_string())
  }
  let var_multi_96_ref_bytes = @fs.read_file_to_bytes(var_multi_96_ref) catch {
    e =>
      fail(
        "failed to read variable multi-96 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_96_bytes == var_multi_96_ref_bytes, content="true")

  let var_multi_104 = "target/cmd_main_netcdf_var_multi_104.nc"
  let var_multi_104_ref = "target/cmd_main_netcdf_var_multi_104_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:104:1", "-netcdf", var_multi_104,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:104:1", "-netcdf", var_multi_104_ref,
    ]),
    content="0",
  )
  let var_multi_104_bytes = @fs.read_file_to_bytes(var_multi_104) catch {
    e => fail("failed to read variable multi-104 netcdf: " + e.to_string())
  }
  let var_multi_104_ref_bytes = @fs.read_file_to_bytes(var_multi_104_ref) catch {
    e =>
      fail(
        "failed to read variable multi-104 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_104_bytes == var_multi_104_ref_bytes, content="true")

  let var_multi_112 = "target/cmd_main_netcdf_var_multi_112.nc"
  let var_multi_112_ref = "target/cmd_main_netcdf_var_multi_112_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:112:1", "-netcdf", var_multi_112,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:112:1", "-netcdf", var_multi_112_ref,
    ]),
    content="0",
  )
  let var_multi_112_bytes = @fs.read_file_to_bytes(var_multi_112) catch {
    e => fail("failed to read variable multi-112 netcdf: " + e.to_string())
  }
  let var_multi_112_ref_bytes = @fs.read_file_to_bytes(var_multi_112_ref) catch {
    e =>
      fail(
        "failed to read variable multi-112 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_112_bytes == var_multi_112_ref_bytes, content="true")

  let var_multi_120 = "target/cmd_main_netcdf_var_multi_120.nc"
  let var_multi_120_ref = "target/cmd_main_netcdf_var_multi_120_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:120:1", "-netcdf", var_multi_120,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:120:1", "-netcdf", var_multi_120_ref,
    ]),
    content="0",
  )
  let var_multi_120_bytes = @fs.read_file_to_bytes(var_multi_120) catch {
    e => fail("failed to read variable multi-120 netcdf: " + e.to_string())
  }
  let var_multi_120_ref_bytes = @fs.read_file_to_bytes(var_multi_120_ref) catch {
    e =>
      fail(
        "failed to read variable multi-120 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_120_bytes == var_multi_120_ref_bytes, content="true")

  let var_multi_128 = "target/cmd_main_netcdf_var_multi_128.nc"
  let var_multi_128_ref = "target/cmd_main_netcdf_var_multi_128_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:128:1", "-netcdf", var_multi_128,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:128:1", "-netcdf", var_multi_128_ref,
    ]),
    content="0",
  )
  let var_multi_128_bytes = @fs.read_file_to_bytes(var_multi_128) catch {
    e => fail("failed to read variable multi-128 netcdf: " + e.to_string())
  }
  let var_multi_128_ref_bytes = @fs.read_file_to_bytes(var_multi_128_ref) catch {
    e =>
      fail(
        "failed to read variable multi-128 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_128_bytes == var_multi_128_ref_bytes, content="true")

  let var_multi_256 = "target/cmd_main_netcdf_var_multi_256.nc"
  let var_multi_256_ref = "target/cmd_main_netcdf_var_multi_256_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:256:1", "-netcdf", var_multi_256,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:256:1", "-netcdf", var_multi_256_ref,
    ]),
    content="0",
  )
  let var_multi_256_bytes = @fs.read_file_to_bytes(var_multi_256) catch {
    e => fail("failed to read variable multi-256 netcdf: " + e.to_string())
  }
  let var_multi_256_ref_bytes = @fs.read_file_to_bytes(var_multi_256_ref) catch {
    e =>
      fail(
        "failed to read variable multi-256 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_256_bytes == var_multi_256_ref_bytes, content="true")

  let var_multi_347 = "target/cmd_main_netcdf_var_multi_347.nc"
  let var_multi_347_ref = "target/cmd_main_netcdf_var_multi_347_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:347:1", "-netcdf", var_multi_347,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:347:1", "-netcdf", var_multi_347_ref,
    ]),
    content="0",
  )
  let var_multi_347_bytes = @fs.read_file_to_bytes(var_multi_347) catch {
    e => fail("failed to read variable multi-347 netcdf: " + e.to_string())
  }
  let var_multi_347_ref_bytes = @fs.read_file_to_bytes(var_multi_347_ref) catch {
    e =>
      fail(
        "failed to read variable multi-347 reference netcdf: " + e.to_string(),
      )
  }
  inspect(var_multi_347_bytes == var_multi_347_ref_bytes, content="true")

  let var_append_4 = "target/cmd_main_netcdf_append_var4_same_time.nc"
  let var_append_4_ref = "target/cmd_main_netcdf_append_var4_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:4:1", "-netcdf", var_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:4:1", "-netcdf", var_append_4_ref,
    ]),
    content="0",
  )
  let var_append_4_bytes = @fs.read_file_to_bytes(var_append_4) catch {
    e => fail("failed to read appended variable-4 netcdf: " + e.to_string())
  }
  let var_append_4_ref_bytes = @fs.read_file_to_bytes(var_append_4_ref) catch {
    e => fail("failed to read variable-4 reference netcdf: " + e.to_string())
  }
  inspect(var_append_4_bytes == var_append_4_ref_bytes, content="true")

  let var_append_8 = "target/cmd_main_netcdf_append_var8_same_time.nc"
  let var_append_8_ref = "target/cmd_main_netcdf_append_var8_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:8:1", "-netcdf", var_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:8:1", "-netcdf", var_append_8_ref,
    ]),
    content="0",
  )
  let var_append_8_bytes = @fs.read_file_to_bytes(var_append_8) catch {
    e => fail("failed to read appended variable-8 netcdf: " + e.to_string())
  }
  let var_append_8_ref_bytes = @fs.read_file_to_bytes(var_append_8_ref) catch {
    e => fail("failed to read variable-8 reference netcdf: " + e.to_string())
  }
  inspect(var_append_8_bytes == var_append_8_ref_bytes, content="true")

  let var_append_12 = "target/cmd_main_netcdf_append_var12_same_time.nc"
  let var_append_12_ref = "target/cmd_main_netcdf_append_var12_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_12,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:12:1", "-netcdf", var_append_12,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:12:1", "-netcdf", var_append_12_ref,
    ]),
    content="0",
  )
  let var_append_12_bytes = @fs.read_file_to_bytes(var_append_12) catch {
    e => fail("failed to read appended variable-12 netcdf: " + e.to_string())
  }
  let var_append_12_ref_bytes = @fs.read_file_to_bytes(var_append_12_ref) catch {
    e => fail("failed to read variable-12 reference netcdf: " + e.to_string())
  }
  inspect(var_append_12_bytes == var_append_12_ref_bytes, content="true")

  let var_append_16 = "target/cmd_main_netcdf_append_var16_same_time.nc"
  let var_append_16_ref = "target/cmd_main_netcdf_append_var16_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:16:1", "-netcdf", var_append_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:16:1", "-netcdf", var_append_16_ref,
    ]),
    content="0",
  )
  let var_append_16_bytes = @fs.read_file_to_bytes(var_append_16) catch {
    e => fail("failed to read appended variable-16 netcdf: " + e.to_string())
  }
  let var_append_16_ref_bytes = @fs.read_file_to_bytes(var_append_16_ref) catch {
    e => fail("failed to read variable-16 reference netcdf: " + e.to_string())
  }
  inspect(var_append_16_bytes == var_append_16_ref_bytes, content="true")

  let var_append_19 = "target/cmd_main_netcdf_append_var19_same_time.nc"
  let var_append_19_ref = "target/cmd_main_netcdf_append_var19_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_19,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:19:1", "-netcdf", var_append_19,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:19:1", "-netcdf", var_append_19_ref,
    ]),
    content="0",
  )
  let var_append_19_bytes = @fs.read_file_to_bytes(var_append_19) catch {
    e => fail("failed to read appended variable-19 netcdf: " + e.to_string())
  }
  let var_append_19_ref_bytes = @fs.read_file_to_bytes(var_append_19_ref) catch {
    e => fail("failed to read variable-19 reference netcdf: " + e.to_string())
  }
  inspect(var_append_19_bytes == var_append_19_ref_bytes, content="true")

  let var_append_24 = "target/cmd_main_netcdf_append_var24_same_time.nc"
  let var_append_24_ref = "target/cmd_main_netcdf_append_var24_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_24,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:24:1", "-netcdf", var_append_24,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:24:1", "-netcdf", var_append_24_ref,
    ]),
    content="0",
  )
  let var_append_24_bytes = @fs.read_file_to_bytes(var_append_24) catch {
    e => fail("failed to read appended variable-24 netcdf: " + e.to_string())
  }
  let var_append_24_ref_bytes = @fs.read_file_to_bytes(var_append_24_ref) catch {
    e => fail("failed to read variable-24 reference netcdf: " + e.to_string())
  }
  inspect(var_append_24_bytes == var_append_24_ref_bytes, content="true")

  let var_append_32 = "target/cmd_main_netcdf_append_var32_same_time.nc"
  let var_append_32_ref = "target/cmd_main_netcdf_append_var32_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:32:1", "-netcdf", var_append_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:32:1", "-netcdf", var_append_32_ref,
    ]),
    content="0",
  )
  let var_append_32_bytes = @fs.read_file_to_bytes(var_append_32) catch {
    e => fail("failed to read appended variable-32 netcdf: " + e.to_string())
  }
  let var_append_32_ref_bytes = @fs.read_file_to_bytes(var_append_32_ref) catch {
    e => fail("failed to read variable-32 reference netcdf: " + e.to_string())
  }
  inspect(var_append_32_bytes == var_append_32_ref_bytes, content="true")

  let var_append_40 = "target/cmd_main_netcdf_append_var40_same_time.nc"
  let var_append_40_ref = "target/cmd_main_netcdf_append_var40_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_40,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:40:1", "-netcdf", var_append_40,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:40:1", "-netcdf", var_append_40_ref,
    ]),
    content="0",
  )
  let var_append_40_bytes = @fs.read_file_to_bytes(var_append_40) catch {
    e => fail("failed to read appended variable-40 netcdf: " + e.to_string())
  }
  let var_append_40_ref_bytes = @fs.read_file_to_bytes(var_append_40_ref) catch {
    e => fail("failed to read variable-40 reference netcdf: " + e.to_string())
  }
  inspect(var_append_40_bytes == var_append_40_ref_bytes, content="true")

  let var_append_48 = "target/cmd_main_netcdf_append_var48_same_time.nc"
  let var_append_48_ref = "target/cmd_main_netcdf_append_var48_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_48,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:48:1", "-netcdf", var_append_48,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:48:1", "-netcdf", var_append_48_ref,
    ]),
    content="0",
  )
  let var_append_48_bytes = @fs.read_file_to_bytes(var_append_48) catch {
    e => fail("failed to read appended variable-48 netcdf: " + e.to_string())
  }
  let var_append_48_ref_bytes = @fs.read_file_to_bytes(var_append_48_ref) catch {
    e => fail("failed to read variable-48 reference netcdf: " + e.to_string())
  }
  inspect(var_append_48_bytes == var_append_48_ref_bytes, content="true")

  let var_append_56 = "target/cmd_main_netcdf_append_var56_same_time.nc"
  let var_append_56_ref = "target/cmd_main_netcdf_append_var56_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_56,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:56:1", "-netcdf", var_append_56,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:56:1", "-netcdf", var_append_56_ref,
    ]),
    content="0",
  )
  let var_append_56_bytes = @fs.read_file_to_bytes(var_append_56) catch {
    e => fail("failed to read appended variable-56 netcdf: " + e.to_string())
  }
  let var_append_56_ref_bytes = @fs.read_file_to_bytes(var_append_56_ref) catch {
    e => fail("failed to read variable-56 reference netcdf: " + e.to_string())
  }
  inspect(var_append_56_bytes == var_append_56_ref_bytes, content="true")

  let var_append_64 = "target/cmd_main_netcdf_append_var64_same_time.nc"
  let var_append_64_ref = "target/cmd_main_netcdf_append_var64_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:64:1", "-netcdf", var_append_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:64:1", "-netcdf", var_append_64_ref,
    ]),
    content="0",
  )
  let var_append_64_bytes = @fs.read_file_to_bytes(var_append_64) catch {
    e => fail("failed to read appended variable-64 netcdf: " + e.to_string())
  }
  let var_append_64_ref_bytes = @fs.read_file_to_bytes(var_append_64_ref) catch {
    e => fail("failed to read variable-64 reference netcdf: " + e.to_string())
  }
  inspect(var_append_64_bytes == var_append_64_ref_bytes, content="true")

  let var_append_72 = "target/cmd_main_netcdf_append_var72_same_time.nc"
  let var_append_72_ref = "target/cmd_main_netcdf_append_var72_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_72,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:72:1", "-netcdf", var_append_72,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:72:1", "-netcdf", var_append_72_ref,
    ]),
    content="0",
  )
  let var_append_72_bytes = @fs.read_file_to_bytes(var_append_72) catch {
    e => fail("failed to read appended variable-72 netcdf: " + e.to_string())
  }
  let var_append_72_ref_bytes = @fs.read_file_to_bytes(var_append_72_ref) catch {
    e => fail("failed to read variable-72 reference netcdf: " + e.to_string())
  }
  inspect(var_append_72_bytes == var_append_72_ref_bytes, content="true")

  let var_append_80 = "target/cmd_main_netcdf_append_var80_same_time.nc"
  let var_append_80_ref = "target/cmd_main_netcdf_append_var80_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_80,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:80:1", "-netcdf", var_append_80,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:80:1", "-netcdf", var_append_80_ref,
    ]),
    content="0",
  )
  let var_append_80_bytes = @fs.read_file_to_bytes(var_append_80) catch {
    e => fail("failed to read appended variable-80 netcdf: " + e.to_string())
  }
  let var_append_80_ref_bytes = @fs.read_file_to_bytes(var_append_80_ref) catch {
    e => fail("failed to read variable-80 reference netcdf: " + e.to_string())
  }
  inspect(var_append_80_bytes == var_append_80_ref_bytes, content="true")

  let var_append_88 = "target/cmd_main_netcdf_append_var88_same_time.nc"
  let var_append_88_ref = "target/cmd_main_netcdf_append_var88_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_88,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:88:1", "-netcdf", var_append_88,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:88:1", "-netcdf", var_append_88_ref,
    ]),
    content="0",
  )
  let var_append_88_bytes = @fs.read_file_to_bytes(var_append_88) catch {
    e => fail("failed to read appended variable-88 netcdf: " + e.to_string())
  }
  let var_append_88_ref_bytes = @fs.read_file_to_bytes(var_append_88_ref) catch {
    e => fail("failed to read variable-88 reference netcdf: " + e.to_string())
  }
  inspect(var_append_88_bytes == var_append_88_ref_bytes, content="true")

  let var_append_96 = "target/cmd_main_netcdf_append_var96_same_time.nc"
  let var_append_96_ref = "target/cmd_main_netcdf_append_var96_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_96,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:96:1", "-netcdf", var_append_96,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:96:1", "-netcdf", var_append_96_ref,
    ]),
    content="0",
  )
  let var_append_96_bytes = @fs.read_file_to_bytes(var_append_96) catch {
    e => fail("failed to read appended variable-96 netcdf: " + e.to_string())
  }
  let var_append_96_ref_bytes = @fs.read_file_to_bytes(var_append_96_ref) catch {
    e => fail("failed to read variable-96 reference netcdf: " + e.to_string())
  }
  inspect(var_append_96_bytes == var_append_96_ref_bytes, content="true")

  let var_append_104 = "target/cmd_main_netcdf_append_var104_same_time.nc"
  let var_append_104_ref = "target/cmd_main_netcdf_append_var104_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_104,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:104:1", "-netcdf", var_append_104,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:104:1", "-netcdf", var_append_104_ref,
    ]),
    content="0",
  )
  let var_append_104_bytes = @fs.read_file_to_bytes(var_append_104) catch {
    e => fail("failed to read appended variable-104 netcdf: " + e.to_string())
  }
  let var_append_104_ref_bytes = @fs.read_file_to_bytes(var_append_104_ref) catch {
    e => fail("failed to read variable-104 reference netcdf: " + e.to_string())
  }
  inspect(var_append_104_bytes == var_append_104_ref_bytes, content="true")

  let var_append_112 = "target/cmd_main_netcdf_append_var112_same_time.nc"
  let var_append_112_ref = "target/cmd_main_netcdf_append_var112_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_112,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:112:1", "-netcdf", var_append_112,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:112:1", "-netcdf", var_append_112_ref,
    ]),
    content="0",
  )
  let var_append_112_bytes = @fs.read_file_to_bytes(var_append_112) catch {
    e => fail("failed to read appended variable-112 netcdf: " + e.to_string())
  }
  let var_append_112_ref_bytes = @fs.read_file_to_bytes(var_append_112_ref) catch {
    e => fail("failed to read variable-112 reference netcdf: " + e.to_string())
  }
  inspect(var_append_112_bytes == var_append_112_ref_bytes, content="true")

  let var_append_120 = "target/cmd_main_netcdf_append_var120_same_time.nc"
  let var_append_120_ref = "target/cmd_main_netcdf_append_var120_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_120,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:120:1", "-netcdf", var_append_120,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:120:1", "-netcdf", var_append_120_ref,
    ]),
    content="0",
  )
  let var_append_120_bytes = @fs.read_file_to_bytes(var_append_120) catch {
    e => fail("failed to read appended variable-120 netcdf: " + e.to_string())
  }
  let var_append_120_ref_bytes = @fs.read_file_to_bytes(var_append_120_ref) catch {
    e => fail("failed to read variable-120 reference netcdf: " + e.to_string())
  }
  inspect(var_append_120_bytes == var_append_120_ref_bytes, content="true")

  let var_append_128 = "target/cmd_main_netcdf_append_var128_same_time.nc"
  let var_append_128_ref = "target/cmd_main_netcdf_append_var128_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_128,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:128:1", "-netcdf", var_append_128,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:128:1", "-netcdf", var_append_128_ref,
    ]),
    content="0",
  )
  let var_append_128_bytes = @fs.read_file_to_bytes(var_append_128) catch {
    e => fail("failed to read appended variable-128 netcdf: " + e.to_string())
  }
  let var_append_128_ref_bytes = @fs.read_file_to_bytes(var_append_128_ref) catch {
    e => fail("failed to read variable-128 reference netcdf: " + e.to_string())
  }
  inspect(var_append_128_bytes == var_append_128_ref_bytes, content="true")

  let var_append_256 = "target/cmd_main_netcdf_append_var256_same_time.nc"
  let var_append_256_ref = "target/cmd_main_netcdf_append_var256_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_256,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:256:1", "-netcdf", var_append_256,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:256:1", "-netcdf", var_append_256_ref,
    ]),
    content="0",
  )
  let var_append_256_bytes = @fs.read_file_to_bytes(var_append_256) catch {
    e => fail("failed to read appended variable-256 netcdf: " + e.to_string())
  }
  let var_append_256_ref_bytes = @fs.read_file_to_bytes(var_append_256_ref) catch {
    e => fail("failed to read variable-256 reference netcdf: " + e.to_string())
  }
  inspect(var_append_256_bytes == var_append_256_ref_bytes, content="true")

  let var_append_347 = "target/cmd_main_netcdf_append_var347_same_time.nc"
  let var_append_347_ref = "target/cmd_main_netcdf_append_var347_same_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:1:1", "-netcdf", var_append_347,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "2:347:1", "-netcdf", var_append_347,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "1:347:1", "-netcdf", var_append_347_ref,
    ]),
    content="0",
  )
  let var_append_347_bytes = @fs.read_file_to_bytes(var_append_347) catch {
    e => fail("failed to read appended variable-347 netcdf: " + e.to_string())
  }
  let var_append_347_ref_bytes = @fs.read_file_to_bytes(var_append_347_ref) catch {
    e => fail("failed to read variable-347 reference netcdf: " + e.to_string())
  }
  inspect(var_append_347_bytes == var_append_347_ref_bytes, content="true")

  let bitmap_append = "target/cmd_main_netcdf_append_bitmap_layers.nc"
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-for_n", "266:266:1", "-netcdf", bitmap_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "267:267:1", "-netcdf", bitmap_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "268:268:1", "-netcdf", bitmap_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", var_fixture, "-append", "-for_n", "269:269:1", "-netcdf", bitmap_append,
    ]),
    content="0",
  )
  let bitmap_append_bytes = @fs.read_file_to_bytes(bitmap_append) catch {
    e => fail("failed to read appended bitmap-layer netcdf: " + e.to_string())
  }
  let bitmap_parsed = match parse_existing_netcdf_file(bitmap_append_bytes) {
    Ok(v) => v
    Err(e) => fail("failed to parse appended bitmap-layer netcdf: " + e)
  }
  inspect(bitmap_parsed.fields.length(), content="4")
  inspect(bitmap_parsed.time_values.length(), content="1")
  inspect(bitmap_parsed.fields[0].name, content="SOILL_0M0D1mbelowground")
  inspect(bitmap_parsed.fields[1].name, content="SOILL_0D1M0D4mbelowground")
  inspect(bitmap_parsed.fields[2].name, content="SOILL_0D4M1mbelowground")
  inspect(bitmap_parsed.fields[3].name, content="SOILL_1M2mbelowground")

  let pgrb2_fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let pgrb2_append = "target/cmd_main_netcdf_append_pgrb2_var.nc"
  let pgrb2_ref = "target/cmd_main_netcdf_append_pgrb2_var_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:2:1", "-netcdf", pgrb2_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:2:1", "-netcdf", pgrb2_ref,
    ]),
    content="0",
  )
  let pgrb2_append_bytes = @fs.read_file_to_bytes(pgrb2_append) catch {
    e => fail("failed to read appended pgrb2 variable netcdf: " + e.to_string())
  }
  let pgrb2_ref_bytes = @fs.read_file_to_bytes(pgrb2_ref) catch {
    e =>
      fail("failed to read pgrb2 variable reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_append_bytes == pgrb2_ref_bytes, content="true")

  let pgrb2_multi_4 = "target/cmd_main_netcdf_pgrb2_multi_4.nc"
  let pgrb2_multi_4_ref = "target/cmd_main_netcdf_pgrb2_multi_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:4:1", "-netcdf", pgrb2_multi_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:4:1", "-netcdf", pgrb2_multi_4_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_4_bytes = @fs.read_file_to_bytes(pgrb2_multi_4) catch {
    e => fail("failed to read pgrb2 multi-4 netcdf: " + e.to_string())
  }
  let pgrb2_multi_4_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_4_ref) catch {
    e => fail("failed to read pgrb2 multi-4 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_4_bytes == pgrb2_multi_4_ref_bytes, content="true")

  let pgrb2_multi_8 = "target/cmd_main_netcdf_pgrb2_multi_8.nc"
  let pgrb2_multi_8_ref = "target/cmd_main_netcdf_pgrb2_multi_8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:8:1", "-netcdf", pgrb2_multi_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:8:1", "-netcdf", pgrb2_multi_8_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_8_bytes = @fs.read_file_to_bytes(pgrb2_multi_8) catch {
    e => fail("failed to read pgrb2 multi-8 netcdf: " + e.to_string())
  }
  let pgrb2_multi_8_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_8_ref) catch {
    e => fail("failed to read pgrb2 multi-8 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_8_bytes == pgrb2_multi_8_ref_bytes, content="true")

  let pgrb2_multi_16 = "target/cmd_main_netcdf_pgrb2_multi_16.nc"
  let pgrb2_multi_16_ref = "target/cmd_main_netcdf_pgrb2_multi_16_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:16:1", "-netcdf", pgrb2_multi_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:16:1", "-netcdf", pgrb2_multi_16_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_16_bytes = @fs.read_file_to_bytes(pgrb2_multi_16) catch {
    e => fail("failed to read pgrb2 multi-16 netcdf: " + e.to_string())
  }
  let pgrb2_multi_16_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_16_ref) catch {
    e =>
      fail("failed to read pgrb2 multi-16 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_16_bytes == pgrb2_multi_16_ref_bytes, content="true")

  let pgrb2_multi_32 = "target/cmd_main_netcdf_pgrb2_multi_32.nc"
  let pgrb2_multi_32_ref = "target/cmd_main_netcdf_pgrb2_multi_32_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:32:1", "-netcdf", pgrb2_multi_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:32:1", "-netcdf", pgrb2_multi_32_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_32_bytes = @fs.read_file_to_bytes(pgrb2_multi_32) catch {
    e => fail("failed to read pgrb2 multi-32 netcdf: " + e.to_string())
  }
  let pgrb2_multi_32_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_32_ref) catch {
    e =>
      fail("failed to read pgrb2 multi-32 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_32_bytes == pgrb2_multi_32_ref_bytes, content="true")

  let pgrb2_multi_64 = "target/cmd_main_netcdf_pgrb2_multi_64.nc"
  let pgrb2_multi_64_ref = "target/cmd_main_netcdf_pgrb2_multi_64_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:64:1", "-netcdf", pgrb2_multi_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:64:1", "-netcdf", pgrb2_multi_64_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_64_bytes = @fs.read_file_to_bytes(pgrb2_multi_64) catch {
    e => fail("failed to read pgrb2 multi-64 netcdf: " + e.to_string())
  }
  let pgrb2_multi_64_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_64_ref) catch {
    e =>
      fail("failed to read pgrb2 multi-64 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_64_bytes == pgrb2_multi_64_ref_bytes, content="true")

  let pgrb2_multi_96 = "target/cmd_main_netcdf_pgrb2_multi_96.nc"
  let pgrb2_multi_96_ref = "target/cmd_main_netcdf_pgrb2_multi_96_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:96:1", "-netcdf", pgrb2_multi_96,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:96:1", "-netcdf", pgrb2_multi_96_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_96_bytes = @fs.read_file_to_bytes(pgrb2_multi_96) catch {
    e => fail("failed to read pgrb2 multi-96 netcdf: " + e.to_string())
  }
  let pgrb2_multi_96_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_96_ref) catch {
    e =>
      fail("failed to read pgrb2 multi-96 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_96_bytes == pgrb2_multi_96_ref_bytes, content="true")

  let pgrb2_multi_192 = "target/cmd_main_netcdf_pgrb2_multi_192.nc"
  let pgrb2_multi_192_ref = "target/cmd_main_netcdf_pgrb2_multi_192_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:192:1", "-netcdf", pgrb2_multi_192,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:192:1", "-netcdf", pgrb2_multi_192_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_192_bytes = @fs.read_file_to_bytes(pgrb2_multi_192) catch {
    e => fail("failed to read pgrb2 multi-192 netcdf: " + e.to_string())
  }
  let pgrb2_multi_192_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_192_ref) catch {
    e =>
      fail("failed to read pgrb2 multi-192 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_192_bytes == pgrb2_multi_192_ref_bytes, content="true")

  let pgrb2_multi_256 = "target/cmd_main_netcdf_pgrb2_multi_256.nc"
  let pgrb2_multi_256_ref = "target/cmd_main_netcdf_pgrb2_multi_256_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:256:1", "-netcdf", pgrb2_multi_256,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:256:1", "-netcdf", pgrb2_multi_256_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_256_bytes = @fs.read_file_to_bytes(pgrb2_multi_256) catch {
    e => fail("failed to read pgrb2 multi-256 netcdf: " + e.to_string())
  }
  let pgrb2_multi_256_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_256_ref) catch {
    e =>
      fail("failed to read pgrb2 multi-256 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_256_bytes == pgrb2_multi_256_ref_bytes, content="true")

  let pgrb2_multi_512 = "target/cmd_main_netcdf_pgrb2_multi_512.nc"
  let pgrb2_multi_512_ref = "target/cmd_main_netcdf_pgrb2_multi_512_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:512:1", "-netcdf", pgrb2_multi_512,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:512:1", "-netcdf", pgrb2_multi_512_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_512_bytes = @fs.read_file_to_bytes(pgrb2_multi_512) catch {
    e => fail("failed to read pgrb2 multi-512 netcdf: " + e.to_string())
  }
  let pgrb2_multi_512_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_512_ref) catch {
    e =>
      fail("failed to read pgrb2 multi-512 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_512_bytes == pgrb2_multi_512_ref_bytes, content="true")

  let pgrb2_multi_696 = "target/cmd_main_netcdf_pgrb2_multi_696.nc"
  let pgrb2_multi_696_ref = "target/cmd_main_netcdf_pgrb2_multi_696_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:696:1", "-netcdf", pgrb2_multi_696,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:696:1", "-netcdf", pgrb2_multi_696_ref,
    ]),
    content="0",
  )
  let pgrb2_multi_696_bytes = @fs.read_file_to_bytes(pgrb2_multi_696) catch {
    e => fail("failed to read pgrb2 multi-696 netcdf: " + e.to_string())
  }
  let pgrb2_multi_696_ref_bytes = @fs.read_file_to_bytes(pgrb2_multi_696_ref) catch {
    e =>
      fail("failed to read pgrb2 multi-696 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_multi_696_bytes == pgrb2_multi_696_ref_bytes, content="true")

  let pgrb2_append_4 = "target/cmd_main_netcdf_append_pgrb2_var4.nc"
  let pgrb2_append_4_ref = "target/cmd_main_netcdf_append_pgrb2_var4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:4:1", "-netcdf", pgrb2_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:4:1", "-netcdf", pgrb2_append_4_ref,
    ]),
    content="0",
  )
  let pgrb2_append_4_bytes = @fs.read_file_to_bytes(pgrb2_append_4) catch {
    e =>
      fail("failed to read appended pgrb2 variable-4 netcdf: " + e.to_string())
  }
  let pgrb2_append_4_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_4_ref) catch {
    e =>
      fail("failed to read pgrb2 variable-4 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_append_4_bytes == pgrb2_append_4_ref_bytes, content="true")

  let pgrb2_append_8 = "target/cmd_main_netcdf_append_pgrb2_var8.nc"
  let pgrb2_append_8_ref = "target/cmd_main_netcdf_append_pgrb2_var8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:8:1", "-netcdf", pgrb2_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:8:1", "-netcdf", pgrb2_append_8_ref,
    ]),
    content="0",
  )
  let pgrb2_append_8_bytes = @fs.read_file_to_bytes(pgrb2_append_8) catch {
    e =>
      fail("failed to read appended pgrb2 variable-8 netcdf: " + e.to_string())
  }
  let pgrb2_append_8_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_8_ref) catch {
    e =>
      fail("failed to read pgrb2 variable-8 reference netcdf: " + e.to_string())
  }
  inspect(pgrb2_append_8_bytes == pgrb2_append_8_ref_bytes, content="true")

  let pgrb2_append_16 = "target/cmd_main_netcdf_append_pgrb2_var16.nc"
  let pgrb2_append_16_ref = "target/cmd_main_netcdf_append_pgrb2_var16_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:16:1", "-netcdf", pgrb2_append_16,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:16:1", "-netcdf", pgrb2_append_16_ref,
    ]),
    content="0",
  )
  let pgrb2_append_16_bytes = @fs.read_file_to_bytes(pgrb2_append_16) catch {
    e =>
      fail("failed to read appended pgrb2 variable-16 netcdf: " + e.to_string())
  }
  let pgrb2_append_16_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_16_ref) catch {
    e =>
      fail(
        "failed to read pgrb2 variable-16 reference netcdf: " + e.to_string(),
      )
  }
  inspect(pgrb2_append_16_bytes == pgrb2_append_16_ref_bytes, content="true")

  let pgrb2_append_32 = "target/cmd_main_netcdf_append_pgrb2_var32.nc"
  let pgrb2_append_32_ref = "target/cmd_main_netcdf_append_pgrb2_var32_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:32:1", "-netcdf", pgrb2_append_32,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:32:1", "-netcdf", pgrb2_append_32_ref,
    ]),
    content="0",
  )
  let pgrb2_append_32_bytes = @fs.read_file_to_bytes(pgrb2_append_32) catch {
    e =>
      fail("failed to read appended pgrb2 variable-32 netcdf: " + e.to_string())
  }
  let pgrb2_append_32_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_32_ref) catch {
    e =>
      fail(
        "failed to read pgrb2 variable-32 reference netcdf: " + e.to_string(),
      )
  }
  inspect(pgrb2_append_32_bytes == pgrb2_append_32_ref_bytes, content="true")

  let pgrb2_append_64 = "target/cmd_main_netcdf_append_pgrb2_var64.nc"
  let pgrb2_append_64_ref = "target/cmd_main_netcdf_append_pgrb2_var64_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:64:1", "-netcdf", pgrb2_append_64,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:64:1", "-netcdf", pgrb2_append_64_ref,
    ]),
    content="0",
  )
  let pgrb2_append_64_bytes = @fs.read_file_to_bytes(pgrb2_append_64) catch {
    e =>
      fail("failed to read appended pgrb2 variable-64 netcdf: " + e.to_string())
  }
  let pgrb2_append_64_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_64_ref) catch {
    e =>
      fail(
        "failed to read pgrb2 variable-64 reference netcdf: " + e.to_string(),
      )
  }
  inspect(pgrb2_append_64_bytes == pgrb2_append_64_ref_bytes, content="true")

  let pgrb2_append_96 = "target/cmd_main_netcdf_append_pgrb2_var96.nc"
  let pgrb2_append_96_ref = "target/cmd_main_netcdf_append_pgrb2_var96_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_96,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:96:1", "-netcdf", pgrb2_append_96,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:96:1", "-netcdf", pgrb2_append_96_ref,
    ]),
    content="0",
  )
  let pgrb2_append_96_bytes = @fs.read_file_to_bytes(pgrb2_append_96) catch {
    e =>
      fail("failed to read appended pgrb2 variable-96 netcdf: " + e.to_string())
  }
  let pgrb2_append_96_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_96_ref) catch {
    e =>
      fail(
        "failed to read pgrb2 variable-96 reference netcdf: " + e.to_string(),
      )
  }
  inspect(pgrb2_append_96_bytes == pgrb2_append_96_ref_bytes, content="true")

  let pgrb2_append_192 = "target/cmd_main_netcdf_append_pgrb2_var192.nc"
  let pgrb2_append_192_ref = "target/cmd_main_netcdf_append_pgrb2_var192_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_192,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:192:1", "-netcdf", pgrb2_append_192,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:192:1", "-netcdf", pgrb2_append_192_ref,
    ]),
    content="0",
  )
  let pgrb2_append_192_bytes = @fs.read_file_to_bytes(pgrb2_append_192) catch {
    e =>
      fail(
        "failed to read appended pgrb2 variable-192 netcdf: " + e.to_string(),
      )
  }
  let pgrb2_append_192_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_192_ref) catch {
    e =>
      fail(
        "failed to read pgrb2 variable-192 reference netcdf: " + e.to_string(),
      )
  }
  inspect(pgrb2_append_192_bytes == pgrb2_append_192_ref_bytes, content="true")

  let pgrb2_append_256 = "target/cmd_main_netcdf_append_pgrb2_var256.nc"
  let pgrb2_append_256_ref = "target/cmd_main_netcdf_append_pgrb2_var256_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_256,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:256:1", "-netcdf", pgrb2_append_256,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:256:1", "-netcdf", pgrb2_append_256_ref,
    ]),
    content="0",
  )
  let pgrb2_append_256_bytes = @fs.read_file_to_bytes(pgrb2_append_256) catch {
    e =>
      fail(
        "failed to read appended pgrb2 variable-256 netcdf: " + e.to_string(),
      )
  }
  let pgrb2_append_256_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_256_ref) catch {
    e =>
      fail(
        "failed to read pgrb2 variable-256 reference netcdf: " + e.to_string(),
      )
  }
  inspect(pgrb2_append_256_bytes == pgrb2_append_256_ref_bytes, content="true")

  let pgrb2_append_512 = "target/cmd_main_netcdf_append_pgrb2_var512.nc"
  let pgrb2_append_512_ref = "target/cmd_main_netcdf_append_pgrb2_var512_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_512,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:512:1", "-netcdf", pgrb2_append_512,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:512:1", "-netcdf", pgrb2_append_512_ref,
    ]),
    content="0",
  )
  let pgrb2_append_512_bytes = @fs.read_file_to_bytes(pgrb2_append_512) catch {
    e =>
      fail(
        "failed to read appended pgrb2 variable-512 netcdf: " + e.to_string(),
      )
  }
  let pgrb2_append_512_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_512_ref) catch {
    e =>
      fail(
        "failed to read pgrb2 variable-512 reference netcdf: " + e.to_string(),
      )
  }
  inspect(pgrb2_append_512_bytes == pgrb2_append_512_ref_bytes, content="true")

  let pgrb2_append_696 = "target/cmd_main_netcdf_append_pgrb2_var696.nc"
  let pgrb2_append_696_ref = "target/cmd_main_netcdf_append_pgrb2_var696_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:1:1", "-netcdf", pgrb2_append_696,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-append", "-for_n", "2:696:1", "-netcdf", pgrb2_append_696,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", pgrb2_fixture, "-for_n", "1:696:1", "-netcdf", pgrb2_append_696_ref,
    ]),
    content="0",
  )
  let pgrb2_append_696_bytes = @fs.read_file_to_bytes(pgrb2_append_696) catch {
    e =>
      fail(
        "failed to read appended pgrb2 variable-696 netcdf: " + e.to_string(),
      )
  }
  let pgrb2_append_696_ref_bytes = @fs.read_file_to_bytes(pgrb2_append_696_ref) catch {
    e =>
      fail(
        "failed to read pgrb2 variable-696 reference netcdf: " + e.to_string(),
      )
  }
  inspect(pgrb2_append_696_bytes == pgrb2_append_696_ref_bytes, content="true")

  let wave_fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let wave_append = "target/cmd_main_netcdf_append_wave_var.nc"
  let wave_ref = "target/cmd_main_netcdf_append_wave_var_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:1:1", "-netcdf", wave_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-append", "-for_n", "2:2:1", "-netcdf", wave_append,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", wave_fixture, "-for_n", "1:2:1", "-netcdf", wave_ref]),
    content="0",
  )
  let wave_append_bytes = @fs.read_file_to_bytes(wave_append) catch {
    e => fail("failed to read appended wave variable netcdf: " + e.to_string())
  }
  let wave_ref_bytes = @fs.read_file_to_bytes(wave_ref) catch {
    e => fail("failed to read wave variable reference netcdf: " + e.to_string())
  }
  inspect(wave_append_bytes == wave_ref_bytes, content="true")

  let wave_multi_8 = "target/cmd_main_netcdf_wave_multi_8.nc"
  let wave_multi_8_ref = "target/cmd_main_netcdf_wave_multi_8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:8:1", "-netcdf", wave_multi_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:8:1", "-netcdf", wave_multi_8_ref,
    ]),
    content="0",
  )
  let wave_multi_8_bytes = @fs.read_file_to_bytes(wave_multi_8) catch {
    e => fail("failed to read wave multi-8 netcdf: " + e.to_string())
  }
  let wave_multi_8_ref_bytes = @fs.read_file_to_bytes(wave_multi_8_ref) catch {
    e => fail("failed to read wave multi-8 reference netcdf: " + e.to_string())
  }
  inspect(wave_multi_8_bytes == wave_multi_8_ref_bytes, content="true")

  let wave_multi_12 = "target/cmd_main_netcdf_wave_multi_12.nc"
  let wave_multi_12_ref = "target/cmd_main_netcdf_wave_multi_12_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:12:1", "-netcdf", wave_multi_12,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:12:1", "-netcdf", wave_multi_12_ref,
    ]),
    content="0",
  )
  let wave_multi_12_bytes = @fs.read_file_to_bytes(wave_multi_12) catch {
    e => fail("failed to read wave multi-12 netcdf: " + e.to_string())
  }
  let wave_multi_12_ref_bytes = @fs.read_file_to_bytes(wave_multi_12_ref) catch {
    e => fail("failed to read wave multi-12 reference netcdf: " + e.to_string())
  }
  inspect(wave_multi_12_bytes == wave_multi_12_ref_bytes, content="true")

  let wave_multi_19 = "target/cmd_main_netcdf_wave_multi_19.nc"
  let wave_multi_19_ref = "target/cmd_main_netcdf_wave_multi_19_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:19:1", "-netcdf", wave_multi_19,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:19:1", "-netcdf", wave_multi_19_ref,
    ]),
    content="0",
  )
  let wave_multi_19_bytes = @fs.read_file_to_bytes(wave_multi_19) catch {
    e => fail("failed to read wave multi-19 netcdf: " + e.to_string())
  }
  let wave_multi_19_ref_bytes = @fs.read_file_to_bytes(wave_multi_19_ref) catch {
    e => fail("failed to read wave multi-19 reference netcdf: " + e.to_string())
  }
  inspect(wave_multi_19_bytes == wave_multi_19_ref_bytes, content="true")

  let wave_append_4 = "target/cmd_main_netcdf_append_wave_var4.nc"
  let wave_append_4_ref = "target/cmd_main_netcdf_append_wave_var4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:1:1", "-netcdf", wave_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-append", "-for_n", "2:4:1", "-netcdf", wave_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:4:1", "-netcdf", wave_append_4_ref,
    ]),
    content="0",
  )
  let wave_append_4_bytes = @fs.read_file_to_bytes(wave_append_4) catch {
    e =>
      fail("failed to read appended wave variable-4 netcdf: " + e.to_string())
  }
  let wave_append_4_ref_bytes = @fs.read_file_to_bytes(wave_append_4_ref) catch {
    e =>
      fail("failed to read wave variable-4 reference netcdf: " + e.to_string())
  }
  inspect(wave_append_4_bytes == wave_append_4_ref_bytes, content="true")

  let wave_append_8 = "target/cmd_main_netcdf_append_wave_var8.nc"
  let wave_append_8_ref = "target/cmd_main_netcdf_append_wave_var8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:1:1", "-netcdf", wave_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-append", "-for_n", "2:8:1", "-netcdf", wave_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:8:1", "-netcdf", wave_append_8_ref,
    ]),
    content="0",
  )
  let wave_append_8_bytes = @fs.read_file_to_bytes(wave_append_8) catch {
    e =>
      fail("failed to read appended wave variable-8 netcdf: " + e.to_string())
  }
  let wave_append_8_ref_bytes = @fs.read_file_to_bytes(wave_append_8_ref) catch {
    e =>
      fail("failed to read wave variable-8 reference netcdf: " + e.to_string())
  }
  inspect(wave_append_8_bytes == wave_append_8_ref_bytes, content="true")

  let wave_append_19 = "target/cmd_main_netcdf_append_wave_var19.nc"
  let wave_append_19_ref = "target/cmd_main_netcdf_append_wave_var19_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:1:1", "-netcdf", wave_append_19,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-append", "-for_n", "2:19:1", "-netcdf", wave_append_19,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_fixture, "-for_n", "1:19:1", "-netcdf", wave_append_19_ref,
    ]),
    content="0",
  )
  let wave_append_19_bytes = @fs.read_file_to_bytes(wave_append_19) catch {
    e =>
      fail("failed to read appended wave variable-19 netcdf: " + e.to_string())
  }
  let wave_append_19_ref_bytes = @fs.read_file_to_bytes(wave_append_19_ref) catch {
    e =>
      fail("failed to read wave variable-19 reference netcdf: " + e.to_string())
  }
  inspect(wave_append_19_bytes == wave_append_19_ref_bytes, content="true")

  let wave_global_fixture = "fixtures/grib2_noaa/gfswave.t00z.global.0p25.f000.grib2"
  let wave_global_append = "target/cmd_main_netcdf_append_wave_global_var.nc"
  let wave_global_ref = "target/cmd_main_netcdf_append_wave_global_var_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:1:1", "-netcdf", wave_global_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-append", "-for_n", "2:2:1", "-netcdf",
      wave_global_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:2:1", "-netcdf", wave_global_ref,
    ]),
    content="0",
  )
  let wave_global_append_bytes = @fs.read_file_to_bytes(wave_global_append) catch {
    e =>
      fail(
        "failed to read appended global wave variable netcdf: " + e.to_string(),
      )
  }
  let wave_global_ref_bytes = @fs.read_file_to_bytes(wave_global_ref) catch {
    e =>
      fail(
        "failed to read global wave variable reference netcdf: " + e.to_string(),
      )
  }
  inspect(wave_global_append_bytes == wave_global_ref_bytes, content="true")

  let wave_global_multi_4 = "target/cmd_main_netcdf_wave_global_multi_4.nc"
  let wave_global_multi_4_ref = "target/cmd_main_netcdf_wave_global_multi_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:4:1", "-netcdf", wave_global_multi_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:4:1", "-netcdf", wave_global_multi_4_ref,
    ]),
    content="0",
  )
  let wave_global_multi_4_bytes = @fs.read_file_to_bytes(wave_global_multi_4) catch {
    e => fail("failed to read global wave multi-4 netcdf: " + e.to_string())
  }
  let wave_global_multi_4_ref_bytes = @fs.read_file_to_bytes(
    wave_global_multi_4_ref,
  ) catch {
    e =>
      fail(
        "failed to read global wave multi-4 reference netcdf: " + e.to_string(),
      )
  }
  inspect(
    wave_global_multi_4_bytes == wave_global_multi_4_ref_bytes,
    content="true",
  )

  let wave_global_multi_8 = "target/cmd_main_netcdf_wave_global_multi_8.nc"
  let wave_global_multi_8_ref = "target/cmd_main_netcdf_wave_global_multi_8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:8:1", "-netcdf", wave_global_multi_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:8:1", "-netcdf", wave_global_multi_8_ref,
    ]),
    content="0",
  )
  let wave_global_multi_8_bytes = @fs.read_file_to_bytes(wave_global_multi_8) catch {
    e => fail("failed to read global wave multi-8 netcdf: " + e.to_string())
  }
  let wave_global_multi_8_ref_bytes = @fs.read_file_to_bytes(
    wave_global_multi_8_ref,
  ) catch {
    e =>
      fail(
        "failed to read global wave multi-8 reference netcdf: " + e.to_string(),
      )
  }
  inspect(
    wave_global_multi_8_bytes == wave_global_multi_8_ref_bytes,
    content="true",
  )

  let wave_global_multi_12 = "target/cmd_main_netcdf_wave_global_multi_12.nc"
  let wave_global_multi_12_ref = "target/cmd_main_netcdf_wave_global_multi_12_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:12:1", "-netcdf", wave_global_multi_12,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:12:1", "-netcdf", wave_global_multi_12_ref,
    ]),
    content="0",
  )
  let wave_global_multi_12_bytes = @fs.read_file_to_bytes(wave_global_multi_12) catch {
    e => fail("failed to read global wave multi-12 netcdf: " + e.to_string())
  }
  let wave_global_multi_12_ref_bytes = @fs.read_file_to_bytes(
    wave_global_multi_12_ref,
  ) catch {
    e =>
      fail(
        "failed to read global wave multi-12 reference netcdf: " + e.to_string(),
      )
  }
  inspect(
    wave_global_multi_12_bytes == wave_global_multi_12_ref_bytes,
    content="true",
  )

  let wave_global_append_4 = "target/cmd_main_netcdf_append_wave_global_var4.nc"
  let wave_global_append_4_ref = "target/cmd_main_netcdf_append_wave_global_var4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:1:1", "-netcdf", wave_global_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-append", "-for_n", "2:4:1", "-netcdf",
      wave_global_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:4:1", "-netcdf", wave_global_append_4_ref,
    ]),
    content="0",
  )
  let wave_global_append_4_bytes = @fs.read_file_to_bytes(wave_global_append_4) catch {
    e =>
      fail(
        "failed to read appended global wave variable-4 netcdf: " +
        e.to_string(),
      )
  }
  let wave_global_append_4_ref_bytes = @fs.read_file_to_bytes(
    wave_global_append_4_ref,
  ) catch {
    e =>
      fail(
        "failed to read global wave variable-4 reference netcdf: " +
        e.to_string(),
      )
  }
  inspect(
    wave_global_append_4_bytes == wave_global_append_4_ref_bytes,
    content="true",
  )

  let wave_global_append_8 = "target/cmd_main_netcdf_append_wave_global_var8.nc"
  let wave_global_append_8_ref = "target/cmd_main_netcdf_append_wave_global_var8_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:1:1", "-netcdf", wave_global_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-append", "-for_n", "2:8:1", "-netcdf",
      wave_global_append_8,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", wave_global_fixture, "-for_n", "1:8:1", "-netcdf", wave_global_append_8_ref,
    ]),
    content="0",
  )
  let wave_global_append_8_bytes = @fs.read_file_to_bytes(wave_global_append_8) catch {
    e =>
      fail(
        "failed to read appended global wave variable-8 netcdf: " +
        e.to_string(),
      )
  }
  let wave_global_append_8_ref_bytes = @fs.read_file_to_bytes(
    wave_global_append_8_ref,
  ) catch {
    e =>
      fail(
        "failed to read global wave variable-8 reference netcdf: " +
        e.to_string(),
      )
  }
  inspect(
    wave_global_append_8_bytes == wave_global_append_8_ref_bytes,
    content="true",
  )

  let time_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let time_append = "target/cmd_main_netcdf_append_time.nc"
  let time_ref = "target/cmd_main_netcdf_append_time_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fixture, "-for_n", "1:1:1", "-netcdf", time_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fixture, "-append", "-for_n", "93:93:1", "-netcdf", time_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fixture, "-for_n", "1:93:92", "-netcdf", time_ref,
    ]),
    content="0",
  )
  let time_append_bytes = @fs.read_file_to_bytes(time_append) catch {
    e => fail("failed to read appended time netcdf: " + e.to_string())
  }
  let time_ref_bytes = @fs.read_file_to_bytes(time_ref) catch {
    e => fail("failed to read time reference netcdf: " + e.to_string())
  }
  inspect(time_append_bytes == time_ref_bytes, content="true")

  let time_multi_4 = "target/cmd_main_netcdf_time_multi_4.nc"
  let time_multi_4_ref = "target/cmd_main_netcdf_time_multi_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fixture, "-for_n", "1:4:1", "-netcdf", time_multi_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fixture, "-for_n", "1:4:1", "-netcdf", time_multi_4_ref,
    ]),
    content="0",
  )
  let time_multi_4_bytes = @fs.read_file_to_bytes(time_multi_4) catch {
    e => fail("failed to read multi-time netcdf: " + e.to_string())
  }
  let time_multi_4_ref_bytes = @fs.read_file_to_bytes(time_multi_4_ref) catch {
    e => fail("failed to read multi-time reference netcdf: " + e.to_string())
  }
  inspect(time_multi_4_bytes == time_multi_4_ref_bytes, content="true")

  let time_append_4 = "target/cmd_main_netcdf_append_time_4.nc"
  let time_append_4_ref = "target/cmd_main_netcdf_append_time_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fixture, "-for_n", "1:1:1", "-netcdf", time_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fixture, "-append", "-for_n", "2:4:1", "-netcdf", time_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fixture, "-for_n", "1:4:1", "-netcdf", time_append_4_ref,
    ]),
    content="0",
  )
  let time_append_4_bytes = @fs.read_file_to_bytes(time_append_4) catch {
    e => fail("failed to read appended time-4 netcdf: " + e.to_string())
  }
  let time_append_4_ref_bytes = @fs.read_file_to_bytes(time_append_4_ref) catch {
    e => fail("failed to read time-4 reference netcdf: " + e.to_string())
  }
  inspect(time_append_4_bytes == time_append_4_ref_bytes, content="true")

  let time_fh00_15_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let time_fh00_15_append = "target/cmd_main_netcdf_append_time_fh00_15.nc"
  let time_fh00_15_ref = "target/cmd_main_netcdf_append_time_fh00_15_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-for_n", "1:1:1", "-netcdf", time_fh00_15_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-append", "-for_n", "93:93:1", "-netcdf",
      time_fh00_15_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-append", "-for_n", "185:185:1", "-netcdf",
      time_fh00_15_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-for_n", "1:185:92", "-netcdf", time_fh00_15_ref,
    ]),
    content="0",
  )
  let time_fh00_15_append_bytes = @fs.read_file_to_bytes(time_fh00_15_append) catch {
    e => fail("failed to read appended FH00-15 time netcdf: " + e.to_string())
  }
  let time_fh00_15_ref_bytes = @fs.read_file_to_bytes(time_fh00_15_ref) catch {
    e => fail("failed to read FH00-15 time reference netcdf: " + e.to_string())
  }
  inspect(time_fh00_15_append_bytes == time_fh00_15_ref_bytes, content="true")

  let time_fh00_15_multi_4 = "target/cmd_main_netcdf_time_fh00_15_multi_4.nc"
  let time_fh00_15_multi_4_ref = "target/cmd_main_netcdf_time_fh00_15_multi_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-for_n", "1:4:1", "-netcdf", time_fh00_15_multi_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-for_n", "1:4:1", "-netcdf", time_fh00_15_multi_4_ref,
    ]),
    content="0",
  )
  let time_fh00_15_multi_4_bytes = @fs.read_file_to_bytes(time_fh00_15_multi_4) catch {
    e => fail("failed to read FH00-15 multi-4 netcdf: " + e.to_string())
  }
  let time_fh00_15_multi_4_ref_bytes = @fs.read_file_to_bytes(
    time_fh00_15_multi_4_ref,
  ) catch {
    e =>
      fail("failed to read FH00-15 multi-4 reference netcdf: " + e.to_string())
  }
  inspect(
    time_fh00_15_multi_4_bytes == time_fh00_15_multi_4_ref_bytes,
    content="true",
  )

  let time_fh00_15_append_4 = "target/cmd_main_netcdf_append_time_fh00_15_4.nc"
  let time_fh00_15_append_4_ref = "target/cmd_main_netcdf_append_time_fh00_15_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-for_n", "1:1:1", "-netcdf", time_fh00_15_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-append", "-for_n", "2:4:1", "-netcdf",
      time_fh00_15_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh00_15_fixture, "-for_n", "1:4:1", "-netcdf", time_fh00_15_append_4_ref,
    ]),
    content="0",
  )
  let time_fh00_15_append_4_bytes = @fs.read_file_to_bytes(
    time_fh00_15_append_4,
  ) catch {
    e => fail("failed to read appended FH00-15 time-4 netcdf: " + e.to_string())
  }
  let time_fh00_15_append_4_ref_bytes = @fs.read_file_to_bytes(
    time_fh00_15_append_4_ref,
  ) catch {
    e =>
      fail("failed to read FH00-15 time-4 reference netcdf: " + e.to_string())
  }
  inspect(
    time_fh00_15_append_4_bytes == time_fh00_15_append_4_ref_bytes,
    content="true",
  )

  let time_fh36_39_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let time_fh36_39_append = "target/cmd_main_netcdf_append_time_fh36_39.nc"
  let time_fh36_39_ref = "target/cmd_main_netcdf_append_time_fh36_39_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fh36_39_fixture, "-for_n", "1:1:1", "-netcdf", time_fh36_39_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh36_39_fixture, "-append", "-for_n", "93:93:1", "-netcdf",
      time_fh36_39_append,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh36_39_fixture, "-for_n", "1:93:92", "-netcdf", time_fh36_39_ref,
    ]),
    content="0",
  )
  let time_fh36_39_append_bytes = @fs.read_file_to_bytes(time_fh36_39_append) catch {
    e => fail("failed to read appended FH36-39 time netcdf: " + e.to_string())
  }
  let time_fh36_39_ref_bytes = @fs.read_file_to_bytes(time_fh36_39_ref) catch {
    e => fail("failed to read FH36-39 time reference netcdf: " + e.to_string())
  }
  inspect(time_fh36_39_append_bytes == time_fh36_39_ref_bytes, content="true")

  let time_fh36_39_multi_4 = "target/cmd_main_netcdf_time_fh36_39_multi_4.nc"
  let time_fh36_39_multi_4_ref = "target/cmd_main_netcdf_time_fh36_39_multi_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fh36_39_fixture, "-for_n", "1:4:1", "-netcdf", time_fh36_39_multi_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh36_39_fixture, "-for_n", "1:4:1", "-netcdf", time_fh36_39_multi_4_ref,
    ]),
    content="0",
  )
  let time_fh36_39_multi_4_bytes = @fs.read_file_to_bytes(time_fh36_39_multi_4) catch {
    e => fail("failed to read FH36-39 multi-4 netcdf: " + e.to_string())
  }
  let time_fh36_39_multi_4_ref_bytes = @fs.read_file_to_bytes(
    time_fh36_39_multi_4_ref,
  ) catch {
    e =>
      fail("failed to read FH36-39 multi-4 reference netcdf: " + e.to_string())
  }
  inspect(
    time_fh36_39_multi_4_bytes == time_fh36_39_multi_4_ref_bytes,
    content="true",
  )

  let time_fh36_39_append_4 = "target/cmd_main_netcdf_append_time_fh36_39_4.nc"
  let time_fh36_39_append_4_ref = "target/cmd_main_netcdf_append_time_fh36_39_4_ref.nc"
  inspect(
    run_cli([
      "grib2_mbt", time_fh36_39_fixture, "-for_n", "1:1:1", "-netcdf", time_fh36_39_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh36_39_fixture, "-append", "-for_n", "2:4:1", "-netcdf",
      time_fh36_39_append_4,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", time_fh36_39_fixture, "-for_n", "1:4:1", "-netcdf", time_fh36_39_append_4_ref,
    ]),
    content="0",
  )
  let time_fh36_39_append_4_bytes = @fs.read_file_to_bytes(
    time_fh36_39_append_4,
  ) catch {
    e => fail("failed to read appended FH36-39 time-4 netcdf: " + e.to_string())
  }
  let time_fh36_39_append_4_ref_bytes = @fs.read_file_to_bytes(
    time_fh36_39_append_4_ref,
  ) catch {
    e =>
      fail("failed to read FH36-39 time-4 reference netcdf: " + e.to_string())
  }
  inspect(
    time_fh36_39_append_4_bytes == time_fh36_39_append_4_ref_bytes,
    content="true",
  )
}

///|
test "run_cli supports -append for mixed-reference analysis netcdf" {
  let fixture = "target/cmd_main_netcdf_mixed_reference_input.grib2"
  match write_mixed_reference_netcdf_input(fixture) {
    Ok(_) => ()
    Err(e) => fail("failed to write mixed-reference append input: " + e)
  }
  let append_out = "target/cmd_main_netcdf_append_mixed_reference.nc"
  let ref_out = "target/cmd_main_netcdf_append_mixed_reference_ref.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", append_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-netcdf", append_out,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2:1", "-netcdf", ref_out]),
    content="0",
  )
  let append_bytes = @fs.read_file_to_bytes(append_out) catch {
    e => fail("failed to read mixed-reference append output: " + e.to_string())
  }
  let ref_bytes = @fs.read_file_to_bytes(ref_out) catch {
    e =>
      fail("failed to read mixed-reference reference output: " + e.to_string())
  }
  inspect(append_bytes == ref_bytes, content="true")
}

///|
test "run_cli preserves netcdf prefix before mixed-grid fatal" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let ref_out = "target/cmd_main_netcdf_jma_gsm_mixed_grid_prefix_ref.nc"
  let fatal_out = "target/cmd_main_netcdf_jma_gsm_mixed_grid_prefix.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:78:1", "-netcdf", ref_out]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:79:1", "-netcdf", fatal_out]),
    content="8",
  )
  let ref_bytes = @fs.read_file_to_bytes(ref_out) catch {
    e =>
      fail(
        "failed to read mixed-grid prefix reference netcdf: " + e.to_string(),
      )
  }
  let fatal_bytes = @fs.read_file_to_bytes(fatal_out) catch {
    e => fail("failed to read mixed-grid prefix fatal netcdf: " + e.to_string())
  }
  inspect(fatal_bytes == ref_bytes, content="true")
}

///|
test "run_cli preserves netcdf append prefix before mixed-grid fatal" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let ref_out = "target/cmd_main_netcdf_jma_gsm_mixed_grid_append_ref.nc"
  let fatal_out = "target/cmd_main_netcdf_jma_gsm_mixed_grid_append.nc"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", ref_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:78:1", "-netcdf", ref_out,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-netcdf", fatal_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:79:1", "-netcdf", fatal_out,
    ]),
    content="8",
  )
  let ref_bytes = @fs.read_file_to_bytes(ref_out) catch {
    e =>
      fail(
        "failed to read mixed-grid append reference netcdf: " + e.to_string(),
      )
  }
  let fatal_bytes = @fs.read_file_to_bytes(fatal_out) catch {
    e => fail("failed to read mixed-grid append fatal netcdf: " + e.to_string())
  }
  inspect(fatal_bytes == ref_bytes, content="true")
}

///|
test "write_netcdf_output fills missing variable-time slots" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse sparse netcdf fixture: " + e.to_string())
  }
  let out = "target/cmd_main_netcdf_sparse.nc"
  match write_netcdf_output(out, context, Some([1, 2, 93]), false) {
    Ok(_) => ()
    Err(e) => fail("failed to write sparse netcdf output: " + e)
  }
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read sparse netcdf output: " + e.to_string())
  }
  inspect(bytes_be_u32(bytes, 4).to_string(), content="2")
  inspect(bytes.to_string().contains("UGRD_1000mb"), content="true")
}

///|
test "write_netcdf_output append preserves sparse variable-time fill slots" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse sparse append fixture: " + e.to_string())
  }
  let append_out = "target/cmd_main_netcdf_sparse_append.nc"
  match write_netcdf_output(append_out, context, Some([1]), false) {
    Ok(_) => ()
    Err(e) => fail("failed to write sparse append seed: " + e)
  }
  match write_netcdf_output(append_out, context, Some([2]), true) {
    Ok(_) => ()
    Err(e) => fail("failed to append sparse variable: " + e)
  }
  match write_netcdf_output(append_out, context, Some([93]), true) {
    Ok(_) => ()
    Err(e) => fail("failed to append sparse time: " + e)
  }
  let ref_out = "target/cmd_main_netcdf_sparse_append_ref.nc"
  match write_netcdf_output(ref_out, context, Some([1, 2, 93]), false) {
    Ok(_) => ()
    Err(e) => fail("failed to write sparse append reference: " + e)
  }
  let append_bytes = @fs.read_file_to_bytes(append_out) catch {
    e => fail("failed to read sparse append output: " + e.to_string())
  }
  let ref_bytes = @fs.read_file_to_bytes(ref_out) catch {
    e => fail("failed to read sparse append reference: " + e.to_string())
  }
  inspect(append_bytes == ref_bytes, content="true")
}

///|
test "run_cli reports cubeface2global unavailable like wgrib2" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_cubeface_unavailable.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1", "-cubeface2global", "0", out,
  ]
  inspect(run_cli(args), content="8")
}

///|
test "run_cli reports mysql unavailable like wgrib2" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1", "-mysql", "H=localhost", "U=user", "P=pass",
    "D=db", "T=table",
  ]
  inspect(run_cli(args), content="8")
}

///|
test "run_cli validates -grib_out_irr selector" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_out_irr_bad.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr", "bad", out,
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -submsg_uv U/V pair combine" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_submsg_uv_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "3:4:1", "-submsg_uv", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read submsg_uv output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="1")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse submsg_uv output: " + e.to_string())
  }
  inspect(context.messages.length(), content="1")
  inspect(context.messages[0].submessages.length(), content="2")
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(metas[0].section4_parameter_number, content="2")
  inspect(metas[1].section4_parameter_number, content="3")
}

///|
test "run_cli supports -ncep_uv U/V pair combine" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let out = "target/cmd_main_ncep_uv_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "4:5:1", "-ncep_uv", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read ncep_uv output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="1")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse ncep_uv output: " + e.to_string())
  }
  inspect(context.messages.length(), content="1")
  inspect(context.messages[0].submessages.length(), content="2")
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="2")
  inspect(metas[0].section4_parameter_number, content="2")
  inspect(metas[1].section4_parameter_number, content="3")
}

///|
test "run_cli -submsg_uv leaves unpaired records raw and merges U/V pair" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_submsg_uv_mixed_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:4:1", "-submsg_uv", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read mixed submsg_uv output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="3")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse mixed submsg_uv output: " + e.to_string())
  }
  inspect(context.messages.length(), content="3")
  inspect(context.messages[0].submessages.length(), content="1")
  inspect(context.messages[1].submessages.length(), content="1")
  inspect(context.messages[2].submessages.length(), content="2")
}

///|
test "run_cli supports -reduced_gaussian_grid neighbor output" {
  let fixture = "fixtures/grib2_jpeg2000/eccodes_reduced_gaussian_surface_jpeg.grib2"
  let out = "target/cmd_main_reduced_gaussian_grid_neighbor.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1", "-reduced_gaussian_grid", out, "-1", "neighbor",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse reduced_gaussian_grid neighbor output: " +
        e.to_string(),
      )
  }
  inspect(context.messages.length(), content="1")
  inspect(context.messages[0].submessages.length(), content="1")
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="1")
  inspect(metas[0].section3_template.id(), content="40")
  inspect(metas[0].section5_template.id(), content="0")
  let section3 = match
    @lib.decode_submessage_section3(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to decode reduced_gaussian_grid neighbor Section 3: " +
        e.to_string(),
      )
  }
  match section3.template {
    GridTemplate340(grid) => {
      inspect(grid.ni, content="128")
      inspect(grid.nj, content="64")
    }
    _ =>
      fail("expected GridTemplate340 for reduced_gaussian_grid neighbor output")
  }
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to unpack reduced_gaussian_grid neighbor output: " +
        unpack_error_string(e),
      )
  }
  inspect(unpacked.num_points, content="8192")
  inspect(unpacked.values.length(), content="8192")
}

///|
test "run_cli supports -reduced_gaussian_grid linear output" {
  let fixture = "fixtures/grib2_jpeg2000/eccodes_reduced_gaussian_surface_jpeg.grib2"
  let out = "target/cmd_main_reduced_gaussian_grid_linear.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1", "-reduced_gaussian_grid", out, "-1", "linear",
  ]
  inspect(run_cli(args), content="0")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to parse reduced_gaussian_grid linear output: " + e.to_string(),
      )
  }
  inspect(context.messages.length(), content="1")
  inspect(context.messages[0].submessages.length(), content="1")
  let metas = @lib.decode_records(context)
  inspect(metas.length(), content="1")
  inspect(metas[0].section3_template.id(), content="40")
  inspect(metas[0].section5_template.id(), content="0")
  let section3 = match
    @lib.decode_submessage_section3(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to decode reduced_gaussian_grid linear Section 3: " +
        e.to_string(),
      )
  }
  match section3.template {
    GridTemplate340(grid) => {
      inspect(grid.ni, content="128")
      inspect(grid.nj, content="64")
    }
    _ =>
      fail("expected GridTemplate340 for reduced_gaussian_grid linear output")
  }
  let unpacked = match
    @lib.unpack_submessage_data(
      context.messages[0],
      context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) =>
      fail(
        "failed to unpack reduced_gaussian_grid linear output: " +
        unpack_error_string(e),
      )
  }
  inspect(unpacked.num_points, content="8192")
  inspect(unpacked.values.length(), content="8192")
}

///|
test "run_cli supports -reduced_gaussian_grid non-Gaussian empty output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_reduced_gaussian_grid_test.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-reduced_gaussian_grid", out, "-1",
    "neighbor",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read reduced_gaussian_grid output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli validates -reduced_gaussian_grid y argument" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_reduced_gaussian_grid_bad_y.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-reduced_gaussian_grid", out, "0",
    "neighbor",
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -ncep_norm on synthetic PDT4.8 ave series" {
  let input = "target/cmd_main_ncep_norm_input.grb2"
  let out = "target/cmd_main_ncep_norm_test.grb2"
  match
    write_synthetic_forecast_input(input, Ave, [
      { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
      { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.5 },
      { start_time: 6, duration: 3, time_increment_length: 3, scale: 3.0 },
      { start_time: 6, duration: 6, time_increment_length: 3, scale: 3.5 },
    ]) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, input_templates, input_values) = match
    decode_template48_outputs_with_values(input) {
    Ok(v) => v
    Err(e) => fail("failed to decode synthetic ncep_norm input: " + e)
  }
  let (out_metas, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode ncep_norm output: " + e)
  }
  inspect(out_metas.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  inspect(
    out_templates
    .map(fn(template) { template.time_range_specs[0].statistical_process })
    .to_string(),
    content="[0, 0, 0, 0]",
  )
  match
    expect_forecast_values_close(
      "ncep_norm record 1",
      out_values[0],
      input_values[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "ncep_norm record 2",
      out_values[1],
      forecast_residual_values(
        Ave,
        input_values[0],
        input_values[1],
        input_templates[0].time_range_specs[0].time_range_length,
        input_templates[1].time_range_specs[0].time_range_length,
      ),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "ncep_norm record 3",
      out_values[2],
      input_values[2],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "ncep_norm record 4",
      out_values[3],
      forecast_residual_values(
        Ave,
        input_values[2],
        input_values[3],
        input_templates[2].time_range_specs[0].time_range_length,
        input_templates[3].time_range_specs[0].time_range_length,
      ),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [96, 188, 280, 372]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (out_metas, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  assert_eq(out_metas[3].section5_reference_value_ieee, 0x43790817)
  match
    expect_forecast_values_close(
      "realworld ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld ncep_norm record 3",
      out_values[2],
      source_fields[2],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld ncep_norm record 4",
      out_values[3],
      forecast_residual_values(Ave, source_fields[2], source_fields[3], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_ugrd_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [94, 186, 278, 370]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld UGRD ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "realworld ugrd ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld ugrd ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld ugrd ncep_norm record 3",
      out_values[2],
      source_fields[2],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld ugrd ncep_norm record 4",
      out_values[3],
      forecast_residual_values(Ave, source_fields[2], source_fields[3], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh18_33_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh18_33_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96, 188, 280]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 ncep_norm record 3",
      out_values[2],
      source_fields[2],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 ncep_norm record 4",
      out_values[3],
      forecast_residual_values(Ave, source_fields[2], source_fields[3], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh18_33_ugrd_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh18_33_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94, 186, 278]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 UGRD ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 ugrd ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 ugrd ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 ugrd ncep_norm record 3",
      out_values[2],
      source_fields[2],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 ugrd ncep_norm record 4",
      out_values[3],
      forecast_residual_values(Ave, source_fields[2], source_fields[3], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh36_39_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh36_39_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh36-39 ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh36-39 ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh36_39_ugrd_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh36_39_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 UGRD ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh36-39 ugrd ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh36-39 ugrd ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh18_33_long_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh18_33_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96, 188, 280, 372, 464]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 long ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="6")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\", \"12/3\", \"15/3\"]",
  )
  for pair in [0, 2, 4] {
    match
      expect_forecast_values_close(
        "fh18-33 long ncep_norm source record " + (pair + 1).to_string(),
        out_values[pair],
        source_fields[pair],
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
    match
      expect_forecast_values_close(
        "fh18-33 long ncep_norm residual record " + (pair + 2).to_string(),
        out_values[pair + 1],
        forecast_residual_values(
          Ave,
          source_fields[pair],
          source_fields[pair + 1],
          3,
          6,
        ),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (UGRD FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh18_33_ugrd_long_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh18_33_ugrd_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94, 186, 278, 370, 462]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 long UGRD ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="6")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\", \"12/3\", \"15/3\"]",
  )
  for pair in [0, 2, 4] {
    match
      expect_forecast_values_close(
        "fh18-33 long ugrd ncep_norm source record " + (pair + 1).to_string(),
        out_values[pair],
        source_fields[pair],
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
    match
      expect_forecast_values_close(
        "fh18-33 long ugrd ncep_norm residual record " + (pair + 2).to_string(),
        out_values[pair + 1],
        forecast_residual_values(
          Ave,
          source_fields[pair],
          source_fields[pair + 1],
          3,
          6,
        ),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_vgrd_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [95, 187, 279, 371]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld VGRD ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "realworld vgrd ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld vgrd ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld vgrd ncep_norm record 3",
      out_values[2],
      source_fields[2],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld vgrd ncep_norm record 4",
      out_values[3],
      forecast_residual_values(Ave, source_fields[2], source_fields[3], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh18_33_vgrd_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh18_33_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95, 187, 279]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 VGRD ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 vgrd ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 vgrd ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 vgrd ncep_norm record 3",
      out_values[2],
      source_fields[2],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 vgrd ncep_norm record 4",
      out_values[3],
      forecast_residual_values(Ave, source_fields[2], source_fields[3], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh36_39_vgrd_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh36_39_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 VGRD ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh36-39 vgrd ncep_norm record 1",
      out_values[0],
      source_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh36-39 vgrd ncep_norm record 2",
      out_values[1],
      forecast_residual_values(Ave, source_fields[0], source_fields[1], 3, 6),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -ncep_norm on real-world-derived PDT4.8 ave series (VGRD FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_ncep_norm_realworld_fh18_33_vgrd_long_input.grb2"
  let out = "target/cmd_main_ncep_norm_realworld_fh18_33_vgrd_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95, 187, 279, 371, 463]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 long VGRD ncep_norm output: " + e)
  }
  inspect(out_values.length(), content="6")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\", \"12/3\", \"15/3\"]",
  )
  for pair in [0, 2, 4] {
    match
      expect_forecast_values_close(
        "fh18-33 long vgrd ncep_norm source record " + (pair + 1).to_string(),
        out_values[pair],
        source_fields[pair],
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
    match
      expect_forecast_values_close(
        "fh18-33 long vgrd ncep_norm residual record " + (pair + 2).to_string(),
        out_values[pair + 1],
        forecast_residual_values(
          Ave,
          source_fields[pair],
          source_fields[pair + 1],
          3,
          6,
        ),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli keeps varying-dt ncep_norm series as pass-through" {
  let input = "target/cmd_main_ncep_norm_passthrough_input.grb2"
  let out = "target/cmd_main_ncep_norm_passthrough_test.grb2"
  match
    write_synthetic_forecast_input(input, Ave, [
      { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
      { start_time: 0, duration: 6, time_increment_length: 6, scale: 1.5 },
      { start_time: 6, duration: 3, time_increment_length: 3, scale: 3.0 },
      { start_time: 6, duration: 6, time_increment_length: 6, scale: 3.5 },
    ]) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-ncep_norm", out]), content="0")
  let (out_metas, out_templates, _) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode ncep_norm passthrough output: " + e)
  }
  inspect(out_metas.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string() +
      "/dt=" +
      template.time_range_specs[0].time_increment_length.to_string()
    })
    .to_string(),
    content="[\"0/3/dt=3\", \"0/6/dt=6\", \"6/3/dt=3\", \"6/6/dt=6\"]",
  )
}

///|
test "run_cli supports -ave/-ave0/time_processing single-record transform" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let ave_out = "target/cmd_main_ave_test.grb2"
  let ave0_out = "target/cmd_main_ave0_test.grb2"
  let timep_out = "target/cmd_main_time_processing_test.grb2"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-ave", "6hr", ave_out]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-ave0", "6hr", ave0_out]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-time_processing", "0", "1", "6hr",
      timep_out,
    ]),
    content="0",
  )
  let (ave_meta, ave_template) = match
    decode_single_template48_output(ave_out) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(ave_meta.section4_template.id(), content="8")
  inspect(ave_meta.section5_template.id(), content="0")
  inspect(ave_template.base.minutes_of_observational_data_cutoff, content="255")
  inspect(ave_template.time_range_specs.length(), content="1")
  inspect(ave_template.time_range_specs[0].statistical_process, content="0")
  inspect(ave_template.time_range_specs[0].type_of_time_increment, content="1")
  inspect(ave_template.time_range_specs[0].time_increment_length, content="6")
  let (_, ave0_template) = match decode_single_template48_output(ave0_out) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(ave0_template.base.minutes_of_observational_data_cutoff, content="0")
  let ave_bytes = @fs.read_file_to_bytes(ave_out) catch {
    e => fail("failed to read ave output: " + e.to_string())
  }
  let timep_bytes = @fs.read_file_to_bytes(timep_out) catch {
    e => fail("failed to read time_processing output: " + e.to_string())
  }
  inspect(ave_bytes == timep_bytes, content="true")
}

///|
test "run_cli supports -fcst_ave/-fcst_ave0 single-record transform" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let fcst_ave_out = "target/cmd_main_fcst_ave_test.grb2"
  let fcst_ave0_out = "target/cmd_main_fcst_ave0_test.grb2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-fcst_ave", "6hr", fcst_ave_out,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-fcst_ave0", "6hr", fcst_ave0_out,
    ]),
    content="0",
  )
  let (fcst_meta, fcst_template) = match
    decode_single_template48_output(fcst_ave_out) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(fcst_meta.section4_template.id(), content="8")
  inspect(fcst_meta.section5_template.id(), content="0")
  inspect(
    fcst_template.base.minutes_of_observational_data_cutoff,
    content="255",
  )
  inspect(fcst_template.time_range_specs.length(), content="1")
  inspect(fcst_template.time_range_specs[0].statistical_process, content="0")
  inspect(fcst_template.time_range_specs[0].type_of_time_increment, content="2")
  inspect(fcst_template.time_range_specs[0].time_increment_length, content="6")
  let (_, fcst0_template) = match
    decode_single_template48_output(fcst_ave0_out) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(fcst0_template.base.minutes_of_observational_data_cutoff, content="0")
}

///|
test "run_cli validates -ave time step" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_ave_bad_step.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-ave", "bad", out]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -ave_var multi-record transform" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let out = "target/cmd_main_ave_var_test.grb2"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-ave_var", "6hr", out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read ave_var output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="4")
  let (metas, templates) = match decode_template48_outputs(out) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let source_context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse source: " + e.to_string())
  }
  let source_section4 = match
    @lib.decode_submessage_section4(
      source_context.messages[0],
      source_context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) => fail("failed to decode source section4: " + e.to_string())
  }
  let source_cutoff = match source_section4.template {
    @section4.ProductTemplate40(template40) =>
      template40.minutes_of_observational_data_cutoff
    _ => fail("expected template4.0 source")
  }
  inspect(metas.length(), content="4")
  inspect(metas[0].section5_template.id(), content="0")
  inspect(metas[1].section5_template.id(), content="0")
  inspect(metas[2].section5_template.id(), content="0")
  inspect(metas[3].section5_template.id(), content="0")
  inspect(templates[0].time_range_specs[0].statistical_process, content="0")
  inspect(templates[1].time_range_specs[0].statistical_process, content="6")
  inspect(templates[2].time_range_specs[0].statistical_process, content="3")
  inspect(templates[3].time_range_specs[0].statistical_process, content="2")
  inspect(
    templates[0].base.minutes_of_observational_data_cutoff,
    content=source_cutoff.to_string(),
  )
  inspect(
    templates[1].base.minutes_of_observational_data_cutoff,
    content=source_cutoff.to_string(),
  )
  inspect(metas[1].section5_num_defined_points, content="0")
  inspect(metas[1].section6_bitmap_indicator, content="0")
  inspect(
    metas[1].section6_undef_points == metas[1].section3_npts,
    content="true",
  )
}

///|
test "run_cli supports -ens_processing multi-message transform" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_ens_processing_test.grb2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-ens_processing", out, "0",
    ]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read ens_processing output: " + e.to_string())
  }
  inspect(count_grib_magic(bytes), content="9")
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse ens_processing output: " + e.to_string())
  }
  let metas = @lib.decode_records(context)
  let source_context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse source: " + e.to_string())
  }
  let source_metas = @lib.decode_records(source_context)
  let derived_codes : Array[Int] = []
  let member_counts : Array[Int] = []
  let percentile_values : Array[Int] = []
  let process_codes : Array[Int] = []
  for index in 0..<metas.length() {
    let section4 = match
      @lib.decode_submessage_section4(
        context.messages[index],
        context.messages[index].submessages[0],
      ) {
      Ok(v) => v
      Err(e) => fail("failed to decode output section4: " + e.to_string())
    }
    match section4.template {
      @section4.ProductTemplate42(template42) => {
        derived_codes.push(template42.derived_forecast)
        member_counts.push(template42.number_of_forecasts_in_ensemble)
        process_codes.push(template42.base.type_of_generating_process)
      }
      @section4.ProductTemplate46(template46) => {
        percentile_values.push(template46.percentile_value)
        process_codes.push(template46.base.type_of_generating_process)
      }
      _ => fail("expected template4.2 or 4.6")
    }
  }
  inspect(metas.length(), content="9")
  inspect(derived_codes.to_string(), content="[8, 9, 0, 4]")
  inspect(member_counts.to_string(), content="[1, 1, 1, 1]")
  inspect(percentile_values.to_string(), content="[10, 25, 50, 75, 90]")
  inspect(
    process_codes.to_string(),
    content="[2, 2, 2, 2, 199, 199, 199, 199, 199]",
  )
  inspect(metas[0].section5_template.id(), content="0")
  inspect(metas[3].section5_template.id(), content="0")
  inspect(
    metas[3].section5_num_defined_points.to_string(),
    content=source_metas[0].section5_num_defined_points.to_string(),
  )
  inspect(
    metas[3].section6_bitmap_indicator.to_string(),
    content=source_metas[0].section6_bitmap_indicator.to_string(),
  )
  inspect(
    metas[3].section6_undef_points.to_string(),
    content=source_metas[0].section6_undef_points.to_string(),
  )
  inspect(metas[3].section5_bits_per_value, content="0")
}

///|
test "run_cli validates -ens_processing mode" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_ens_processing_bad.grb2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-ens_processing", out, "bad",
    ]),
    content="2",
  )
}

///|
test "run_cli supports -ens_qc outputs for gfswave" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let stats_out = "target/cmd_main_ens_qc_gfswave_stats.grb2"
  let extreme_out = "target/cmd_main_ens_qc_gfswave_extreme.grb2"
  let txt_out = "target/cmd_main_ens_qc_gfswave_extreme.txt"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-ens_qc", stats_out, extreme_out,
      txt_out, "1",
    ]),
    content="0",
  )
  let stats_bytes = @fs.read_file_to_bytes(stats_out) catch {
    e => fail("failed to read ens_qc stats output: " + e.to_string())
  }
  let extreme_bytes = @fs.read_file_to_bytes(extreme_out) catch {
    e => fail("failed to read ens_qc extreme output: " + e.to_string())
  }
  let txt_body = @fs.read_file_to_string(txt_out) catch {
    e => fail("failed to read ens_qc txt output: " + e.to_string())
  }
  inspect(count_grib_magic(stats_bytes), content="4")
  inspect(count_grib_magic(extreme_bytes), content="1")
  inspect(txt_body, content="WIND:surface:max scaled extreme=0.000000\n")
  let stats_context = match @lib.parse_with_io(native_read_bytes, stats_out) {
    Ok(v) => v
    Err(e) => fail("failed to parse ens_qc stats output: " + e.to_string())
  }
  let extreme_context = match
    @lib.parse_with_io(native_read_bytes, extreme_out) {
    Ok(v) => v
    Err(e) => fail("failed to parse ens_qc extreme output: " + e.to_string())
  }
  let source_context = match @lib.parse_with_io(native_read_bytes, fixture) {
    Ok(v) => v
    Err(e) => fail("failed to parse ens_qc source fixture: " + e.to_string())
  }
  let stats_metas = @lib.decode_records(stats_context)
  let extreme_metas = @lib.decode_records(extreme_context)
  let source_metas = @lib.decode_records(source_context)
  let stats_derived_codes : Array[Int] = []
  for index in 0..<stats_metas.length() {
    let section4 = match
      @lib.decode_submessage_section4(
        stats_context.messages[index],
        stats_context.messages[index].submessages[0],
      ) {
      Ok(v) => v
      Err(e) => fail("failed to decode ens_qc stats section4: " + e.to_string())
    }
    match section4.template {
      @section4.ProductTemplate42(template42) =>
        stats_derived_codes.push(template42.derived_forecast)
      _ => fail("expected template 4.2 for ens_qc stats")
    }
  }
  let extreme_section4 = match
    @lib.decode_submessage_section4(
      extreme_context.messages[0],
      extreme_context.messages[0].submessages[0],
    ) {
    Ok(v) => v
    Err(e) => fail("failed to decode ens_qc extreme section4: " + e.to_string())
  }
  let extreme_derived_code = match extreme_section4.template {
    @section4.ProductTemplate42(template42) => template42.derived_forecast
    _ => fail("expected template 4.2 for ens_qc extreme")
  }
  inspect(stats_metas.length(), content="4")
  inspect(extreme_metas.length(), content="1")
  inspect(stats_derived_codes.to_string(), content="[8, 9, 0, 4]")
  inspect(extreme_derived_code, content="199")
  inspect(
    stats_metas[0].section6_bitmap_indicator.to_string(),
    content=source_metas[0].section6_bitmap_indicator.to_string(),
  )
  inspect(
    stats_metas[0].section6_undef_points.to_string(),
    content=source_metas[0].section6_undef_points.to_string(),
  )
  inspect(stats_metas[3].section6_bitmap_indicator, content="255")
  inspect(stats_metas[3].section5_bits_per_value, content="0")
  inspect(
    stats_metas[3].section5_num_defined_points.to_string(),
    content=stats_metas[3].section3_npts.to_string(),
  )
  inspect(stats_metas[3].section6_undef_points, content="0")
  inspect(extreme_metas[0].section6_bitmap_indicator, content="0")
  inspect(extreme_metas[0].section5_bits_per_value, content="0")
  inspect(extreme_metas[0].section5_num_defined_points, content="0")
  inspect(
    extreme_metas[0].section6_undef_points.to_string(),
    content=extreme_metas[0].section3_npts.to_string(),
  )
}

///|
test "run_cli supports -ens_qc empty extreme output for jma" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let stats_out = "target/cmd_main_ens_qc_jma_stats.grb2"
  let extreme_out = "target/cmd_main_ens_qc_jma_extreme.grb2"
  let txt_out = "target/cmd_main_ens_qc_jma_extreme.txt"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-ens_qc", stats_out, extreme_out,
      txt_out, "1",
    ]),
    content="0",
  )
  let stats_bytes = @fs.read_file_to_bytes(stats_out) catch {
    e => fail("failed to read ens_qc jma stats output: " + e.to_string())
  }
  let extreme_bytes = @fs.read_file_to_bytes(extreme_out) catch {
    e => fail("failed to read ens_qc jma extreme output: " + e.to_string())
  }
  let txt_body = @fs.read_file_to_string(txt_out) catch {
    e => fail("failed to read ens_qc jma txt output: " + e.to_string())
  }
  inspect(count_grib_magic(stats_bytes), content="4")
  inspect(extreme_bytes.length(), content="0")
  inspect(
    txt_body,
    content="PRMSL:mean sea level:max scaled extreme=0.000000\n",
  )
}

///|
test "run_cli validates -ens_qc version" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-ens_qc", "target/cmd_main_ens_qc_bad_stats.grb2",
      "target/cmd_main_ens_qc_bad_extreme.grb2", "target/cmd_main_ens_qc_bad_extreme.txt",
      "0",
    ]),
    content="2",
  )
}

///|
test "run_cli supports -merge_fcst on synthetic PDT4.8 ave series" {
  let input = "target/cmd_main_merge_fcst_input.grb2"
  let out = "target/cmd_main_merge_fcst_test.grb2"
  match
    write_synthetic_forecast_input(input, Ave, [
      { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
      { start_time: 3, duration: 3, time_increment_length: 3, scale: 2.0 },
      { start_time: 6, duration: 3, time_increment_length: 3, scale: 3.0 },
      { start_time: 9, duration: 3, time_increment_length: 3, scale: 4.0 },
    ]) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, input_templates, input_values) = match
    decode_template48_outputs_with_values(input) {
    Ok(v) => v
    Err(e) => fail("failed to decode synthetic merge_fcst input: " + e)
  }
  let (out_metas, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode merge_fcst output: " + e)
  }
  inspect(out_metas.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\"]",
  )
  inspect(
    out_templates
    .map(fn(template) { template.time_range_specs[0].statistical_process })
    .to_string(),
    content="[0, 0]",
  )
  let merged_01 = forecast_scale_average_values(
    forecast_merge_values(Ave, input_values[0], input_values[1]),
    0.5,
  )
  let merged_23 = forecast_scale_average_values(
    forecast_merge_values(Ave, input_values[2], input_values[3]),
    0.5,
  )
  match
    expect_forecast_values_close(
      "merge_fcst record 1",
      out_values[0],
      merged_01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "merge_fcst record 2",
      out_values[1],
      merged_23,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(input_templates[0].time_range_specs[0].time_range_length, content="3")
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [96, 188, 280, 372]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\"]",
  )
  let merged_01 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  let merged_23 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[2], source_fields[3]),
    0.5,
  )
  match
    expect_forecast_values_close(
      "realworld merge_fcst record 1",
      out_values[0],
      merged_01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "realworld merge_fcst record 2",
      out_values[1],
      merged_23,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_ugrd_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [94, 186, 278, 370]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld UGRD merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\"]",
  )
  let merged_01 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  let merged_23 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[2], source_fields[3]),
    0.5,
  )
  match
    expect_forecast_values_close_with_min_tolerance(
      "realworld ugrd merge_fcst record 1",
      out_values[0],
      merged_01,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close_with_min_tolerance(
      "realworld ugrd merge_fcst record 2",
      out_values[1],
      merged_23,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh18_33_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh18_33_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96, 188, 280]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\"]",
  )
  let merged_01 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  let merged_23 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[2], source_fields[3]),
    0.5,
  )
  match
    expect_forecast_values_close(
      "fh18-33 merge_fcst record 1",
      out_values[0],
      merged_01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh18-33 merge_fcst record 2",
      out_values[1],
      merged_23,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh18_33_ugrd_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh18_33_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94, 186, 278]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 UGRD merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\"]",
  )
  let merged_01 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  let merged_23 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[2], source_fields[3]),
    0.5,
  )
  match
    expect_forecast_values_close_with_min_tolerance(
      "fh18-33 ugrd merge_fcst record 1",
      out_values[0],
      merged_01,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close_with_min_tolerance(
      "fh18-33 ugrd merge_fcst record 2",
      out_values[1],
      merged_23,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh36_39_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh36_39_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="1")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\"]",
  )
  let merged = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  match
    expect_forecast_values_close(
      "fh36-39 merge_fcst record 1",
      out_values[0],
      merged,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh36_39_ugrd_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh36_39_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 UGRD merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="1")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\"]",
  )
  let merged = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  match
    expect_forecast_values_close_with_min_tolerance(
      "fh36-39 ugrd merge_fcst record 1",
      out_values[0],
      merged,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh18_33_long_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh18_33_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 15, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96, 188, 280, 372, 464]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 long merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="3")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\", \"12/6\"]",
  )
  for pair in [0, 2, 4] {
    let merged = forecast_scale_average_values(
      forecast_merge_values(Ave, source_fields[pair], source_fields[pair + 1]),
      0.5,
    )
    match
      expect_forecast_values_close(
        "fh18-33 long merge_fcst record " + (pair / 2 + 1).to_string(),
        out_values[pair / 2],
        merged,
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (UGRD FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh18_33_ugrd_long_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh18_33_ugrd_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 15, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94, 186, 278, 370, 462]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 long UGRD merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="3")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\", \"12/6\"]",
  )
  for pair in [0, 2, 4] {
    let merged = forecast_scale_average_values(
      forecast_merge_values(Ave, source_fields[pair], source_fields[pair + 1]),
      0.5,
    )
    match
      expect_forecast_values_close_with_min_tolerance(
        "fh18-33 long ugrd merge_fcst record " + (pair / 2 + 1).to_string(),
        out_values[pair / 2],
        merged,
        0.01,
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_vgrd_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [95, 187, 279, 371]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld VGRD merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\"]",
  )
  let merged_01 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  let merged_23 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[2], source_fields[3]),
    0.5,
  )
  match
    expect_forecast_values_close_with_min_tolerance(
      "realworld vgrd merge_fcst record 1",
      out_values[0],
      merged_01,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close_with_min_tolerance(
      "realworld vgrd merge_fcst record 2",
      out_values[1],
      merged_23,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh18_33_vgrd_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh18_33_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95, 187, 279]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 VGRD merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\"]",
  )
  let merged_01 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  let merged_23 = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[2], source_fields[3]),
    0.5,
  )
  match
    expect_forecast_values_close_with_min_tolerance(
      "fh18-33 vgrd merge_fcst record 1",
      out_values[0],
      merged_01,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close_with_min_tolerance(
      "fh18-33 vgrd merge_fcst record 2",
      out_values[1],
      merged_23,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh36_39_vgrd_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh36_39_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 VGRD merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="1")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\"]",
  )
  let merged = forecast_scale_average_values(
    forecast_merge_values(Ave, source_fields[0], source_fields[1]),
    0.5,
  )
  match
    expect_forecast_values_close_with_min_tolerance(
      "fh36-39 vgrd merge_fcst record 1",
      out_values[0],
      merged,
      0.01,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -merge_fcst on real-world-derived PDT4.8 ave series (VGRD FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_merge_fcst_realworld_fh18_33_vgrd_long_input.grb2"
  let out = "target/cmd_main_merge_fcst_realworld_fh18_33_vgrd_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 3, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 6, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 9, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 12, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 15, duration: 3, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95, 187, 279, 371, 463]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  match
    write_forecast_input_with_values(input, source, Ave, specs, source_fields) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(run_cli(["grib2_mbt", input, "-merge_fcst", "2", out]), content="0")
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 long VGRD merge_fcst output: " + e)
  }
  inspect(out_values.length(), content="3")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/6\", \"6/6\", \"12/6\"]",
  )
  for pair in [0, 2, 4] {
    let merged = forecast_scale_average_values(
      forecast_merge_values(Ave, source_fields[pair], source_fields[pair + 1]),
      0.5,
    )
    match
      expect_forecast_values_close_with_min_tolerance(
        "fh18-33 long vgrd merge_fcst record " + (pair / 2 + 1).to_string(),
        out_values[pair / 2],
        merged,
        0.01,
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on synthetic PDT4.8 acc series" {
  let input = "target/cmd_main_unmerge_fcst_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_test.grb2"
  match
    write_synthetic_forecast_input(input, Acc, [
      { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
      { start_time: 0, duration: 6, time_increment_length: 3, scale: 3.0 },
      { start_time: 0, duration: 9, time_increment_length: 3, scale: 6.0 },
      { start_time: 0, duration: 12, time_increment_length: 3, scale: 10.0 },
    ]) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, input_templates, input_values) = match
    decode_template48_outputs_with_values(input) {
    Ok(v) => v
    Err(e) => fail("failed to decode synthetic unmerge_fcst input: " + e)
  }
  let (out_metas, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode unmerge_fcst output: " + e)
  }
  inspect(out_metas.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  inspect(
    out_templates
    .map(fn(template) { template.time_range_specs[0].statistical_process })
    .to_string(),
    content="[1, 1, 1, 1]",
  )
  match
    expect_forecast_values_close(
      "unmerge_fcst record 1",
      out_values[0],
      input_values[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "unmerge_fcst record 2",
      out_values[1],
      Array::make(input_values[1].length(), 0.0),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "unmerge_fcst record 3",
      out_values[2],
      Array::make(input_values[2].length(), 0.0),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "unmerge_fcst record 4",
      out_values[3],
      Array::make(input_values[3].length(), 0.0),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [96, 188, 280, 372]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "realworld unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "realworld unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_ugrd_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [94, 186, 278, 370]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld UGRD unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "realworld ugrd unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "realworld ugrd unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh18_33_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh18_33_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96, 188, 280]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "fh18-33 unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh18_33_ugrd_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh18_33_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94, 186, 278]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 UGRD unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 ugrd unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "fh18-33 ugrd unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh36_39_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh36_39_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh36-39 unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh36-39 unmerge_fcst zero record 2",
      out_values[1],
      Array::make(out_values[1].length(), 0.0),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh36_39_ugrd_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh36_39_ugrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 UGRD unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh36-39 ugrd unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh36-39 ugrd unmerge_fcst zero record 2",
      out_values[1],
      Array::make(out_values[1].length(), 0.0),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh18_33_long_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh18_33_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 15, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 18, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [4, 96, 188, 280, 372, 464]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 long unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="6")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\", \"12/3\", \"15/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 long unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "fh18-33 long unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (UGRD FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh18_33_ugrd_long_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh18_33_ugrd_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 15, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 18, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [2, 94, 186, 278, 370, 462]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to decode FH18-33 long UGRD unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="6")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\", \"12/3\", \"15/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 long ugrd unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "fh18-33 long ugrd unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_vgrd_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [95, 187, 279, 371]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode realworld VGRD unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "realworld vgrd unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "realworld vgrd unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH18-33)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh18_33_vgrd_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh18_33_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95, 187, 279]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH18-33 VGRD unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="4")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 vgrd unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "fh18-33 vgrd unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH36-39)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH36-39_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh36_39_vgrd_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh36_39_vgrd_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) => fail("failed to decode FH36-39 VGRD unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="2")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh36-39 vgrd unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match
    expect_forecast_values_close(
      "fh36-39 vgrd unmerge_fcst zero record 2",
      out_values[1],
      Array::make(out_values[1].length(), 0.0),
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
}

///|
test "run_cli supports -unmerge_fcst on real-world-derived PDT4.8 acc series (VGRD FH18-33 long)" {
  let source_fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let input = "target/cmd_main_unmerge_fcst_realworld_fh18_33_vgrd_long_input.grb2"
  let out = "target/cmd_main_unmerge_fcst_realworld_fh18_33_vgrd_long_test.grb2"
  let specs = [
    { start_time: 0, duration: 3, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 6, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 9, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 12, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 15, time_increment_length: 3, scale: 1.0 },
    { start_time: 0, duration: 18, time_increment_length: 3, scale: 1.0 },
  ]
  let (source, source_fields) = match
    load_real_forecast_test_values(source_fixture, [3, 95, 187, 279, 371, 463]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let accumulated_fields = build_running_accumulated_forecast_values(
    source_fields,
  )
  match
    write_forecast_input_with_values(
      input,
      source,
      Acc,
      specs,
      accumulated_fields,
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  inspect(
    run_cli(["grib2_mbt", input, "-unmerge_fcst", out, "0hr", "1"]),
    content="0",
  )
  let (_, out_templates, out_values) = match
    decode_template48_outputs_with_values(out) {
    Ok(v) => v
    Err(e) =>
      fail("failed to decode FH18-33 long VGRD unmerge_fcst output: " + e)
  }
  inspect(out_values.length(), content="6")
  inspect(
    out_templates
    .map(fn(template) {
      template.base.forecast_time.to_string() +
      "/" +
      template.time_range_specs[0].time_range_length.to_string()
    })
    .to_string(),
    content="[\"0/3\", \"3/3\", \"6/3\", \"9/3\", \"12/3\", \"15/3\"]",
  )
  match
    expect_forecast_values_close(
      "fh18-33 long vgrd unmerge_fcst record 1",
      out_values[0],
      accumulated_fields[0],
    ) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for index in 1..<out_values.length() {
    match
      expect_forecast_values_close(
        "fh18-33 long vgrd unmerge_fcst zero record " + (index + 1).to_string(),
        out_values[index],
        Array::make(out_values[index].length(), 0.0),
      ) {
      Ok(_) => ()
      Err(e) => fail(e)
    }
  }
}

///|
test "run_cli validates -unmerge_fcst time argument" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_unmerge_fcst_bad_time_test.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-unmerge_fcst", out, "0", "0",
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -wind_speed limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_speed_test.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-wind_speed", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_speed output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -wind_dir limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_dir_test.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-wind_dir", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_dir output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -wind_uv limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_uv_test.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-wind_uv", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_uv output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -wind_uv derived output from speed/dir input" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let speed_dir = "target/cmd_main_wind_spddir_test.grb2"
  let uv_out = "target/cmd_main_wind_uv_from_spddir_test.grb2"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "11:12", "-wind_speed", speed_dir]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "11:12", "-wind_dir", speed_dir,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", speed_dir, "-for_n", "1:2", "-wind_uv", uv_out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(uv_out) catch {
    e => fail("failed to read wind_uv output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  inspect(count_grib_magic(bytes), content="2")
  let context = match @lib.parse_with_io(native_read_bytes, uv_out) {
    Ok(v) => v
    Err(e) => fail("failed to parse wind_uv output: " + e.to_string())
  }
  let records = @lib.decode_records(context)
  inspect(records.length(), content="2")
  inspect(records[0].section5_template.id(), content="0")
  inspect(records[0].section6_bitmap_indicator, content="255")
  inspect(records[1].section5_template.id(), content="0")
  inspect(records[1].section6_bitmap_indicator, content="255")
}

///|
test "run_cli supports -wind_speed on jpeg2000 U/V input" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_speed_jpeg_test.grb2"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "3:4", "-wind_speed", out]),
    content="0",
  )
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse wind_speed jpeg output: " + e.to_string())
  }
  let records = @lib.decode_records(context)
  inspect(records.length(), content="1")
  inspect(records[0].section4_parameter_category, content="2")
  inspect(records[0].section4_parameter_number, content="1")
  inspect(records[0].section5_template.id(), content="0")
  inspect(records[0].section6_bitmap_indicator, content="0")
}

///|
test "run_cli supports -wind_dir on jpeg2000 U/V input" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_dir_jpeg_test.grb2"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "3:4", "-wind_dir", out]),
    content="0",
  )
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse wind_dir jpeg output: " + e.to_string())
  }
  let records = @lib.decode_records(context)
  inspect(records.length(), content="1")
  inspect(records[0].section4_parameter_category, content="2")
  inspect(records[0].section4_parameter_number, content="0")
  inspect(records[0].section5_template.id(), content="0")
  inspect(records[0].section6_bitmap_indicator, content="0")
}

///|
test "run_cli supports -wind_uv on jpeg2000 speed dir input" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_uv_jpeg_test.grb2"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:2", "-wind_uv", out]),
    content="0",
  )
  let context = match @lib.parse_with_io(native_read_bytes, out) {
    Ok(v) => v
    Err(e) => fail("failed to parse wind_uv jpeg output: " + e.to_string())
  }
  let records = @lib.decode_records(context)
  inspect(records.length(), content="2")
  inspect(records[0].section4_parameter_category, content="2")
  inspect(records[0].section4_parameter_number, content="2")
  inspect(records[0].section5_template.id(), content="0")
  inspect(records[0].section6_bitmap_indicator, content="0")
  inspect(records[1].section4_parameter_category, content="2")
  inspect(records[1].section4_parameter_number, content="3")
  inspect(records[1].section5_template.id(), content="0")
  inspect(records[1].section6_bitmap_indicator, content="0")
}

///|
test "run_cli supports -wind_speed on complex packing output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_wind_speed_complex_test.grb2"
  let args = ["grib2_mbt", fixture, "-wind_speed", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_speed output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -wind_dir on complex packing output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_wind_dir_complex_test.grb2"
  let args = ["grib2_mbt", fixture, "-wind_dir", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_dir output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -write_sec 0 output begins with GRIB magic" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_sec0_test.bin"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-write_sec", "0", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(bytes.length(), content="24")
  inspect(bytes[0].to_uint().reinterpret_as_int().to_string(), content="16")
  let magic = bytes.sub(start=4, end=8).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -write_sec 8 output with 7777 marker" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_sec8_test.bin"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-write_sec", "8", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(bytes.length(), content="12")
  inspect(bytes[0].to_uint().reinterpret_as_int().to_string(), content="4")
  let marker = bytes.sub(start=4, end=8).to_bytes().to_string()
  inspect(marker, content="b\"7777\"")
}

///|
test "run_cli supports -gribtable_used output" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let out = "target/cmd_main_gribtable_used_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-gribtable_used", out,
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body, content="0:1:0:255:34:1:3:1:PRMSL:Pressure Reduced to MSL:Pa\n")
}

///|
test "run_cli applies -for_n to -gribtable_used output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out_all = "target/cmd_main_gribtable_used_all.txt"
  let out_one = "target/cmd_main_gribtable_used_one.txt"
  inspect(
    run_cli(["grib2_mbt", fixture, "-gribtable_used", out_all]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "7:7:1", "-gribtable_used", out_one,
    ]),
    content="0",
  )
  let all_body = @fs.read_file_to_string(out_all) catch {
    e => fail("failed to read all output: " + e.to_string())
  }
  let one_body = @fs.read_file_to_string(out_one) catch {
    e => fail("failed to read one output: " + e.to_string())
  }
  inspect(one_body, content="0:0:0:255:7:1:16:195:REFD:Reflectivity:dB\n")
  inspect(
    all_body.contains("0:0:0:255:7:1:16:195:REFD:Reflectivity:dB"),
    content="true",
  )
}

///|
test "run_cli gribtable_used append preserves record lines" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_gribtable_used_append.txt"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-gribtable_used", out]),
    content="0",
  )
  let first = @fs.read_file_to_string(out) catch {
    e => fail("failed to read first output: " + e.to_string())
  }
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-gribtable_used", out,
    ]),
    content="0",
  )
  let second = @fs.read_file_to_string(out) catch {
    e => fail("failed to read second output: " + e.to_string())
  }
  inspect(first, content="0:1:0:255:7:1:3:1:PRMSL:Pressure Reduced to MSL:Pa\n")
  inspect(
    second,
    content="0:1:0:255:7:1:3:1:PRMSL:Pressure Reduced to MSL:Pa\n0:1:0:255:7:1:1:22:CLMR:Cloud Mixing Ratio:kg/kg\n",
  )
}

///|
test "run_cli supports -gridout output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_gridout_test.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-gridout", out])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines.length() > 0, content="true")
  inspect(lines[0], content="         1,         1, 0.000, 260.000")
}

///|
test "run_cli supports -export_lonlat output with expected pair count" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out_bin = "target/cmd_main_export_lonlat_test.bin"
  let out_txt = "target/cmd_main_export_lonlat_gridout.txt"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-export_lonlat", out_bin]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-gridout", out_txt]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out_bin) catch {
    e => fail("failed to read lonlat output: " + e.to_string())
  }
  let points = line_count(out_txt)
  inspect(points > 0, content="true")
  inspect(bytes.length(), content=(points * 8).to_string())
}

///|
test "run_cli supports -text output with wgrib2 layout" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_text_test.txt"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-text", out]),
    content="0",
  )
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read text output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines[0], content="360 181")
  inspect(lines[1], content="102136")
  inspect(lines[2], content="102136")
}

///|
test "run_cli supports -text -no_header -text_col" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_text_no_header_test.txt"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-no_header", "-text_col", "4", "-text",
      out,
    ]),
    content="0",
  )
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read text_col output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines[0], content="102136 102136 102136 102136")
}

///|
test "run_cli supports -csv output with init record filtering" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_csv_test.csv"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-csv", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines.length() > 0, content="true")
  inspect(
    lines[0],
    content="\"2026-02-21 00:00:00\",\"2026-02-21 00:00:00\",\"PRMSL\",\"mean sea level\",0,-90,102136",
  )
}

///|
test "run_cli supports -csv_long output with wgrib2 layout" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_csv_long_test.csv"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-csv_long", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines.length() > 0, content="true")
  inspect(
    lines[0],
    content="\"2026-02-21 00:00:00\",\"2026-02-21 00:00:00\",\"2026-02-21 00:00:00\",\"PRMSL\",\"anl\",\"mean sea level\",0,-90,102136",
  )
}

///|
test "run_cli supports -csv_long verification columns for forecast data" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_MSM_GPV_Rjp_L-pall_FH18-33_grib2.bin"
  let out = "target/cmd_main_csv_long_forecast_test.csv"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-csv_long", out]),
    content="0",
  )
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  if lines.length() == 0 {
    fail("missing csv_long output")
  }
  let first_line = lines[0]
  let parts : Array[String] = []
  for part in first_line.split(",") {
    parts.push(part.to_string())
  }
  inspect(parts[0], content="\"2024-12-06 00:00:00\"")
  inspect(parts[1], content="\"2024-12-06 18:00:00\"")
  inspect(parts[2], content="\"2024-12-06 18:00:00\"")
  inspect(parts[3], content="\"HGT\"")
  inspect(parts[4], content="\"18 hour fcst\"")
  inspect(parts[5], content="\"1000 mb\"")
}

///|
test "run_cli supports -spread output with wgrib2 header" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_spread_test.txt"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-spread", out]),
    content="0",
  )
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read spread output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines[0], content="lon,lat,WIND surface d=2026022100 anl")
  inspect(lines[1], content="303.000000,6.000000,6.28")
}

///|
test "run_cli supports -bin and -ieee outputs with expected size" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out_bin = "target/cmd_main_bin_test.bin"
  let out_ieee = "target/cmd_main_ieee_test.bin"
  let args_bin = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-bin", out_bin]
  let args_ieee = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-ieee", out_ieee]
  inspect(run_cli(args_bin), content="0")
  inspect(run_cli(args_ieee), content="0")
  let bin_bytes = @fs.read_file_to_bytes(out_bin) catch {
    e => fail("failed to read bin output: " + e.to_string())
  }
  let ieee_bytes = @fs.read_file_to_bytes(out_ieee) catch {
    e => fail("failed to read ieee output: " + e.to_string())
  }
  inspect(bin_bytes.length(), content="260648")
  inspect(ieee_bytes.length(), content="260648")
}

///|
test "run_cli supports append mode for csv output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_csv_append_test.csv"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-csv", out]),
    content="0",
  )
  let first_lines = line_count(out)
  inspect(
    run_cli(["grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-csv", out]),
    content="0",
  )
  let second_lines = line_count(out)
  inspect(second_lines > first_lines, content="true")
}

///|
test "run_cli supports text_fmt scientific styles" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out_e = "target/cmd_main_text_scientific_e.txt"
  let out_g = "target/cmd_main_text_scientific_g.txt"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "11:11:1", "-no_header", "-text_fmt", "%.3e",
      "-text", out_e,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "11:11:1", "-no_header", "-text_fmt", "%.4G",
      "-text", out_g,
    ]),
    content="0",
  )
  let body_e = @fs.read_file_to_string(out_e) catch {
    e => fail("failed to read e output: " + e.to_string())
  }
  let body_g = @fs.read_file_to_string(out_g) catch {
    e => fail("failed to read g output: " + e.to_string())
  }
  let mut first_e = ""
  for line in body_e.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      first_e = s
      break
    }
  }
  let mut first_g = ""
  for line in body_g.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      first_g = s
      break
    }
  }
  inspect(first_e.contains("e"), content="true")
  inspect(first_g.contains("E") || first_g.contains("."), content="true")
}

///|
test "run_cli supports endian switches for bin/ieee" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let bin_l = "target/cmd_main_bin_l.bin"
  let bin_b = "target/cmd_main_bin_b.bin"
  let ieee_d = "target/cmd_main_ieee_d.bin"
  let ieee_l = "target/cmd_main_ieee_l.bin"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-bin", bin_l]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-big_endian", "-bin", bin_b,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-ieee", ieee_d]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-little_endian", "-ieee", ieee_l,
    ]),
    content="0",
  )
  let a = @fs.read_file_to_bytes(bin_l) catch {
    e => fail("failed to read bin_l: " + e.to_string())
  }
  let b = @fs.read_file_to_bytes(bin_b) catch {
    e => fail("failed to read bin_b: " + e.to_string())
  }
  let c = @fs.read_file_to_bytes(ieee_d) catch {
    e => fail("failed to read ieee_d: " + e.to_string())
  }
  let d = @fs.read_file_to_bytes(ieee_l) catch {
    e => fail("failed to read ieee_l: " + e.to_string())
  }
  inspect(a.length() >= 4, content="true")
  inspect(b.length() >= 4, content="true")
  inspect(c.length() >= 4, content="true")
  inspect(d.length() >= 4, content="true")
  let a0 = [a[0], a[1], a[2], a[3]]
  let b0 = [b[0], b[1], b[2], b[3]]
  let c0 = [c[0], c[1], c[2], c[3]]
  let d0 = [d[0], d[1], d[2], d[3]]
  inspect(a0 == b0, content="false")
  inspect(b0 == c0, content="true")
  inspect(a0 == d0, content="true")
}
