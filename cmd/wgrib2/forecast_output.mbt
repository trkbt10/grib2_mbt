///|
fn parse_time_step_spec(spec : String) -> (Int, Int)? {
  if spec.has_suffix("mn") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((0, v))
      _ => None
    }
  }
  if spec.has_suffix("hr") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((1, v))
      _ => None
    }
  }
  if spec.has_suffix("dy") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((2, v))
      _ => None
    }
  }
  if spec.has_suffix("mo") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((3, v))
      _ => None
    }
  }
  if spec.has_suffix("yr") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((4, v))
      _ => None
    }
  }
  None
}

///|
fn parse_unmerge_fcst_time_spec(spec : String) -> (Int, Int)? {
  parse_time_step_spec(spec)
}

///|
fn parse_timestamp14_components(
  timestamp : String,
) -> (Int, Int, Int, Int, Int, Int)? {
  if timestamp.length() != 14 {
    return None
  }
  let year = parse_int_option(timestamp.substring(start=0, end=4))
  let month = parse_int_option(timestamp.substring(start=4, end=6))
  let day = parse_int_option(timestamp.substring(start=6, end=8))
  let hour = parse_int_option(timestamp.substring(start=8, end=10))
  let minute = parse_int_option(timestamp.substring(start=10, end=12))
  let second = parse_int_option(timestamp.substring(start=12, end=14))
  match (year, month, day, hour, minute, second) {
    (Some(y), Some(m), Some(d), Some(h), Some(mi), Some(s)) =>
      Some((y, m, d, h, mi, s))
    _ => None
  }
}

///|
fn build_time_processing_section4_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  statistical_process : Int,
  type_of_time_increment : Int,
  step_unit : Int,
  step_length : Int,
  zero_cutoff : Bool,
) -> Result[Bytes, String] {
  let section4 = match @decode.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        option_name +
        ": failed to decode Section 4 for record " +
        meta.record_index.to_string() +
        ": " +
        error.to_string(),
      )
  }
  let base = match section4.template {
    @section4.ProductTemplate40(base) => base
    _ =>
      return Err(
        option_name +
        " is only implemented for product template 4.0 (record " +
        meta.record_index.to_string() +
        ")",
      )
  }
  let timestamp = if meta.unix_vt >= 0 {
    format_timestamp14_from_unix(meta.unix_vt)
  } else {
    meta.reference_time_full
  }
  let (end_year, end_month, end_day, end_hour, end_minute, end_second) = match
    parse_timestamp14_components(timestamp) {
    Some(v) => v
    None =>
      return Err(
        option_name +
        ": failed to parse verification time for record " +
        meta.record_index.to_string(),
      )
  }
  let template48 : @section4.Grib2ProductTemplate48 = {
    base: {
      ..base,
      minutes_of_observational_data_cutoff: if zero_cutoff {
        base.minutes_of_observational_data_cutoff
      } else {
        255
      },
    },
    end_year,
    end_month,
    end_day,
    end_hour,
    end_minute,
    end_second,
    number_of_time_ranges: 1,
    number_of_missing_values: 0,
    time_range_specs: [
      (
        {
          statistical_process,
          type_of_time_increment,
          time_range_unit: step_unit,
          time_range_length: 0,
          time_increment_unit: step_unit,
          time_increment_length: step_length,
        } : @section4.Grib2TimeRangeSpec),
    ],
    reserved_tail: b"",
  }
  Ok(
    @decode.encode_section4_bytes({
      number_of_coordinate_values: section4.number_of_coordinate_values,
      template: @section4.ProductTemplate48(template48),
      coordinate_values_raw: section4.coordinate_values_raw,
    }),
  )
}

///|
fn build_simple_packed_submessage_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  section4 : Bytes,
  section6 : Bytes,
  defined_values : Array[Double],
) -> Result[Bytes, String] {
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      defined_values,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for " +
        option_name +
        " record " +
        meta.record_index.to_string(),
      )
  }
  Ok(
    build_submessage_grib_bytes_with_overrides(
      message,
      submessage,
      Some(section4),
      Some(sec5),
      Some(section6),
      Some(sec7),
    ),
  )
}

///|
fn try_build_simple_packed_sections_with_forecast_scaling(
  values : Array[Double],
  reference_value_ieee : Int,
  binary_scale_factor : Int,
  decimal_scale_factor : Int,
  original_field_value_type : Int,
) -> (Bytes, Bytes)? {
  let working_values : Array[Double] = []
  for value in values {
    if value != value {
      return None
    }
    working_values.push(Float::from_double(value).to_double())
  }
  let mut min_value = Float::reinterpret_from_int(reference_value_ieee).to_double()
  let mut max_value = min_value
  if working_values.length() > 0 {
    min_value = working_values[0]
    max_value = working_values[0]
    for value in working_values {
      if value < min_value {
        min_value = value
      }
      if value > max_value {
        max_value = value
      }
    }
  }
  let constant_field = working_values.length() == 0 || min_value == max_value
  let output_binary_scale_factor = if constant_field {
    0
  } else {
    binary_scale_factor
  }
  let output_decimal_scale_factor = if constant_field {
    0
  } else {
    decimal_scale_factor
  }
  let original_min_value = min_value
  let decimal_scale = pow10_int(output_decimal_scale_factor)
  if output_decimal_scale_factor != 0 {
    min_value = Float::from_double(min_value * decimal_scale).to_double()
    max_value = Float::from_double(max_value * decimal_scale).to_double()
    for index in 0..<working_values.length() {
      working_values[index] = Float::from_double(
        working_values[index] * decimal_scale,
      ).to_double()
    }
  }
  let reference_value = if constant_field {
    original_min_value
  } else {
    min_value
  }
  let output_reference_value_ieee = if working_values.length() == 0 {
    0
  } else {
    Float::from_double(reference_value).reinterpret_as_int()
  }
  let binary_scale = pow2_int(-output_binary_scale_factor)
  let packed_values : Array[Int] = []
  let mut max_packed = 0
  for value in working_values {
    let packed_float = if output_binary_scale_factor == 0 {
      Float::from_double(value - reference_value).to_double()
    } else {
      Float::from_double((value - reference_value) * binary_scale).to_double()
    }
    let packed = @math.floor(packed_float + 0.5).to_int()
    let nonnegative = if packed < 0 { 0 } else { packed }
    if nonnegative > max_packed {
      max_packed = nonnegative
    }
    packed_values.push(nonnegative)
  }
  let bits_per_value = if constant_field {
    0
  } else {
    required_bits_nonnegative(max_packed)
  }
  if bits_per_value > 31 {
    return None
  }
  let sec5 = @decode.encode_section5_bytes({
    number_of_data_points: working_values.length(),
    template: DataRepresentationTemplate50({
      reference_value_ieee: output_reference_value_ieee,
      binary_scale_factor: encode_i16_sign_magnitude(output_binary_scale_factor),
      decimal_scale_factor: encode_i16_sign_magnitude(
        output_decimal_scale_factor,
      ),
      bits_per_value,
      original_field_value_type,
      reserved_tail: b"",
    }),
  })
  let sec7 = @decode.encode_section7_bytes({
    template: DataTemplate70({
      data_values_raw: pack_unsigned_values_be(packed_values, bits_per_value),
    }),
  })
  Some((sec5, sec7))
}

///|
fn build_time_processing_submessage_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  statistical_process : Int,
  type_of_time_increment : Int,
  step_unit : Int,
  step_length : Int,
  zero_cutoff : Bool,
) -> Result[Bytes, String] {
  let section4 = match
    build_time_processing_section4_bytes(
      option_name, message, submessage, meta, statistical_process, type_of_time_increment,
      step_unit, step_length, zero_cutoff,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      option_name +
      " is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for " +
        option_name,
      )
  }
  let defined_values = match
    collect_defined_values_for_grib_out(message, submessage, unpacked) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect defined values for " +
        option_name +
        " record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let sec6 = match build_grib_out_section6_bytes(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to resolve Section 6 for " +
        option_name +
        " record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  build_simple_packed_submessage_bytes(
    option_name, message, submessage, meta, section4, sec6, defined_values,
  )
}

///|
fn build_all_undefined_bitmap_section6_bytes(npts : Int) -> Bytes {
  @decode.encode_section6_bytes({
    bitmap_indicator: 0,
    bitmap_raw: Bytes::from_array(Array::make((npts + 7) / 8, b'\x00')),
  })
}

///|
fn build_no_bitmap_section6_bytes() -> Bytes {
  @decode.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
}

///|
fn build_defined_zero_field_submessage_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  section4 : Bytes,
) -> Result[Bytes, String] {
  build_simple_packed_submessage_bytes(
    option_name,
    message,
    submessage,
    meta,
    section4,
    build_no_bitmap_section6_bytes(),
    Array::make(meta.section3_npts, 0.0),
  )
}

///|
fn build_all_undefined_submessage_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  section4 : Bytes,
) -> Result[Bytes, String] {
  build_simple_packed_submessage_bytes(
    option_name,
    message,
    submessage,
    meta,
    section4,
    build_all_undefined_bitmap_section6_bytes(meta.section3_npts),
    [],
  )
}

///|
fn build_time_processing_empty_stddev_submessage_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  step_unit : Int,
  step_length : Int,
) -> Result[Bytes, String] {
  let section4 = match
    build_time_processing_section4_bytes(
      option_name, message, submessage, meta, 6, 1, step_unit, step_length, true,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let sec6 = build_all_undefined_bitmap_section6_bytes(meta.section3_npts)
  build_simple_packed_submessage_bytes(
    option_name,
    message,
    submessage,
    meta,
    section4,
    sec6,
    [],
  )
}

///|
fn build_ens_processing_derived_section4_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  derived_forecast : Int,
) -> Result[Bytes, String] {
  let section4 = match @decode.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        option_name +
        ": failed to decode Section 4 for record " +
        meta.record_index.to_string() +
        ": " +
        error.to_string(),
      )
  }
  let base = match section4.template {
    @section4.ProductTemplate40(base) => base
    _ =>
      return Err(
        option_name +
        " is only implemented for product template 4.0 (record " +
        meta.record_index.to_string() +
        ")",
      )
  }
  let member_count = if meta.section4_ens_member_count > 0 {
    meta.section4_ens_member_count
  } else {
    1
  }
  Ok(
    @decode.encode_section4_bytes({
      number_of_coordinate_values: section4.number_of_coordinate_values,
      template: @section4.ProductTemplate42({
        base: ens_processing_base_template40(base),
        derived_forecast,
        number_of_forecasts_in_ensemble: member_count,
      }),
      coordinate_values_raw: section4.coordinate_values_raw,
    }),
  )
}

///|
fn ens_processing_percentile_process_code(source_process : Int) -> Int {
  if source_process == 1 {
    4
  } else {
    199
  }
}

///|
fn ens_processing_base_template40(
  base : @section4.Grib2ProductTemplate40,
) -> @section4.Grib2ProductTemplate40 {
  { ..base, minutes_of_observational_data_cutoff: 255 }
}

///|
fn build_ens_processing_percentile_section4_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  percentile_value : Int,
) -> Result[Bytes, String] {
  let section4 = match @decode.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        option_name +
        ": failed to decode Section 4 for record " +
        meta.record_index.to_string() +
        ": " +
        error.to_string(),
      )
  }
  let base = match section4.template {
    @section4.ProductTemplate40(base) => base
    _ =>
      return Err(
        option_name +
        " is only implemented for product template 4.0 (record " +
        meta.record_index.to_string() +
        ")",
      )
  }
  Ok(
    @decode.encode_section4_bytes({
      number_of_coordinate_values: section4.number_of_coordinate_values,
      template: @section4.ProductTemplate46({
        base: {
          ..ens_processing_base_template40(base),
          type_of_generating_process: ens_processing_percentile_process_code(
            base.type_of_generating_process,
          ),
        },
        percentile_value,
        reserved_tail: b"",
      }),
      coordinate_values_raw: section4.coordinate_values_raw,
    }),
  )
}

///|
fn build_ens_processing_submessage_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  section4 : Bytes,
  zero_field : Bool,
) -> Result[Bytes, String] {
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      option_name +
      " is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for " +
        option_name,
      )
  }
  let defined_values = match
    collect_defined_values_for_grib_out(message, submessage, unpacked) {
    Ok(v) => if zero_field { Array::make(v.length(), 0.0) } else { v }
    Err(e) =>
      return Err(
        "failed to collect defined values for " +
        option_name +
        " record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let sec6 = match build_grib_out_section6_bytes(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to resolve Section 6 for " +
        option_name +
        " record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  build_simple_packed_submessage_bytes(
    option_name, message, submessage, meta, section4, sec6, defined_values,
  )
}

///|
fn write_ens_processing_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  mode_arg : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  let mode = match parse_int_option(mode_arg) {
    Some(v) => v
    None => return Err("-ens_processing: mode must be 0 or 1")
  }
  if mode != 0 && mode != 1 {
    return Err("-ens_processing: mode must be 0 or 1")
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  let _ = mode
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta = match find_record_meta(context, record_ref.record_index) {
      Some(v) => v
      None =>
        return Err(
          "-ens_processing: record not found " +
          record_ref.record_index.to_string(),
        )
    }
    for derived_forecast in [8, 9, 0] {
      let section4 = match
        build_ens_processing_derived_section4_bytes(
          "-ens_processing", message, submessage, meta, derived_forecast,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let bytes = match
        build_ens_processing_submessage_bytes(
          "-ens_processing", message, submessage, meta, section4, false,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(out, bytes)
    }
    let spread_section4 = match
      build_ens_processing_derived_section4_bytes(
        "-ens_processing", message, submessage, meta, 4,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let spread = match
      build_ens_processing_submessage_bytes(
        "-ens_processing", message, submessage, meta, spread_section4, true,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    append_bytes(out, spread)
    for percentile_value in [10, 25, 50, 75, 90] {
      let section4 = match
        build_ens_processing_percentile_section4_bytes(
          "-ens_processing", message, submessage, meta, percentile_value,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let bytes = match
        build_ens_processing_submessage_bytes(
          "-ens_processing", message, submessage, meta, section4, false,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(out, bytes)
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn build_ens_qc_text_line(meta : @decode.Grib2RecordMeta) -> String {
  meta.parameter_name.display() +
  ":" +
  meta.level_name.display() +
  ":max scaled extreme=0.000000"
}

///|
fn write_ens_qc_output(
  stats_destination : String,
  extreme_destination : String,
  txt_destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  qc_version_arg : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  let qc_version = match parse_int_option(qc_version_arg) {
    Some(v) => v
    None => return Err("-ens_qc: qc_version must be 1")
  }
  if qc_version != 1 {
    return Err("-ens_qc: qc_version must be 1")
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    match write_empty_compat_output(stats_destination, append_mode) {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    match write_empty_compat_output(extreme_destination, append_mode) {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    if append_mode {
      return native_append_string(txt_destination, "")
    } else {
      return native_write_string(txt_destination, "")
    }
  }
  let stats_out : Array[Byte] = []
  let extreme_out : Array[Byte] = []
  let txt_lines : Array[String] = []
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta = match find_record_meta(context, record_ref.record_index) {
      Some(v) => v
      None =>
        return Err(
          "-ens_qc: record not found " + record_ref.record_index.to_string(),
        )
    }
    for derived_forecast in [8, 9, 0] {
      let section4 = match
        build_ens_processing_derived_section4_bytes(
          "-ens_qc", message, submessage, meta, derived_forecast,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let bytes = match
        build_ens_processing_submessage_bytes(
          "-ens_qc", message, submessage, meta, section4, false,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(stats_out, bytes)
    }
    let spread_section4 = match
      build_ens_processing_derived_section4_bytes(
        "-ens_qc", message, submessage, meta, 4,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let spread = match
      build_defined_zero_field_submessage_bytes(
        "-ens_qc", message, submessage, meta, spread_section4,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    append_bytes(stats_out, spread)
    if meta.section4_process_code != 1 {
      let extreme_section4 = match
        build_ens_processing_derived_section4_bytes(
          "-ens_qc", message, submessage, meta, 199,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let extreme = match
        build_all_undefined_submessage_bytes(
          "-ens_qc", message, submessage, meta, extreme_section4,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(extreme_out, extreme)
    }
    txt_lines.push(build_ens_qc_text_line(meta))
  }
  let txt_content = build_output_content(txt_lines, false)
  let write_stats_result = if append_mode {
    native_append_bytes(stats_destination, Bytes::from_array(stats_out))
  } else {
    native_write_bytes(stats_destination, Bytes::from_array(stats_out))
  }
  match write_stats_result {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  let write_extreme_result = if append_mode {
    native_append_bytes(extreme_destination, Bytes::from_array(extreme_out))
  } else {
    native_write_bytes(extreme_destination, Bytes::from_array(extreme_out))
  }
  match write_extreme_result {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if append_mode {
    native_append_string(txt_destination, txt_content)
  } else {
    native_write_string(txt_destination, txt_content)
  }
}

///|
fn write_time_processing_metadata_output(
  option_name : String,
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  statistical_process : Int,
  type_of_time_increment : Int,
  time_step_spec : String,
  zero_cutoff : Bool,
  append_mode : Bool,
) -> Result[Unit, String] {
  let (step_unit, step_length) = match parse_time_step_spec(time_step_spec) {
    Some(v) => v
    None =>
      return Err(
        option_name +
        ": bad time step " +
        time_step_spec +
        " (expected (int)(mn|hr|dy|mo|yr))",
      )
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta = match find_record_meta(context, record_ref.record_index) {
      Some(v) => v
      None =>
        return Err(
          option_name +
          ": record not found " +
          record_ref.record_index.to_string(),
        )
    }
    let bytes = match
      build_time_processing_submessage_bytes(
        option_name, message, submessage, meta, statistical_process, type_of_time_increment,
        step_unit, step_length, zero_cutoff,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    append_bytes(out, bytes)
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_ave_var_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  time_step_spec : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  let (step_unit, step_length) = match parse_time_step_spec(time_step_spec) {
    Some(v) => v
    None =>
      return Err(
        "-ave_var: bad time step " +
        time_step_spec +
        " (expected (int)(mn|hr|dy|mo|yr))",
      )
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta = match find_record_meta(context, record_ref.record_index) {
      Some(v) => v
      None =>
        return Err(
          "-ave_var: record not found " + record_ref.record_index.to_string(),
        )
    }
    let ave = match
      build_time_processing_submessage_bytes(
        "-ave_var", message, submessage, meta, 0, 1, step_unit, step_length, true,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let stddev = match
      build_time_processing_empty_stddev_submessage_bytes(
        "-ave_var", message, submessage, meta, step_unit, step_length,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let minimum = match
      build_time_processing_submessage_bytes(
        "-ave_var", message, submessage, meta, 3, 1, step_unit, step_length, true,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let maximum = match
      build_time_processing_submessage_bytes(
        "-ave_var", message, submessage, meta, 2, 1, step_unit, step_length, true,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    append_bytes(out, ave)
    append_bytes(out, stddev)
    append_bytes(out, minimum)
    append_bytes(out, maximum)
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_empty_compat_output(
  destination : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  if append_mode {
    native_append_bytes(destination, Bytes::new(0))
  } else {
    native_write_bytes(destination, Bytes::new(0))
  }
}

///|
priv enum ForecastProcessingKind {
  Ave
  Acc
  Max
  Min
}

///|
priv struct ForecastProcessingRecord {
  record_ref : SelectedRecordRef
  meta : @decode.Grib2RecordMeta
  section1_bytes : Bytes
  section3_bytes : Bytes
  section4_bytes : Bytes
  section4_key : Bytes
  coordinate_value_count : Int
  coordinate_values_raw : Bytes
  template48 : @section4.Grib2ProductTemplate48
  kind : ForecastProcessingKind
  start_time : Int
  duration : Int
  values : Array[Double]
}

///|
priv struct ForecastProcessingState {
  record : ForecastProcessingRecord
  count : Int
}

///|
fn to_wgrib2_float32(value : Double) -> Double {
  Float::from_double(value).to_double()
}

///|
fn bigint_abs(value : BigInt) -> BigInt {
  if value.compare_int(0) < 0 {
    -value
  } else {
    value
  }
}

///|
fn float32_rational_from_double(value : Double) -> (BigInt, Int) {
  let bits = Float::from_double(value).reinterpret_as_uint()
  let exp_raw = ((bits >> 23) & 0xffU).to_int()
  let frac = bits & 0x7fffffU
  let negative = bits >> 31 != 0U
  if exp_raw == 0 {
    if frac == 0U {
      (BigInt::from_int(0), 0)
    } else {
      let mantissa = BigInt::from_uint64(UInt64::extend_uint(frac))
      (if negative { -mantissa } else { mantissa }, -149)
    }
  } else {
    let mantissa = BigInt::from_uint64(UInt64::extend_uint(0x800000U | frac))
    (if negative { -mantissa } else { mantissa }, exp_raw - 127 - 23)
  }
}

///|
fn compare_float32_rational_to_power_of_two(
  abs_numerator : BigInt,
  denominator : BigInt,
  exp2 : Int,
  power : Int,
) -> Int {
  if power >= exp2 {
    abs_numerator.compare(denominator << (power - exp2))
  } else {
    (abs_numerator << (exp2 - power)).compare(denominator)
  }
}

///|
fn round_bigint_divide_even(numerator : BigInt, denominator : BigInt) -> BigInt {
  let quotient = numerator / denominator
  let remainder = numerator % denominator
  let doubled_remainder = remainder << 1
  if doubled_remainder > denominator ||
    (doubled_remainder == denominator && (quotient.to_int() & 1) == 1) {
    quotient + BigInt::from_int(1)
  } else {
    quotient
  }
}

///|
fn round_float32_rational_to_double(
  numerator : BigInt,
  exp2 : Int,
  denominator_int : Int,
) -> Double {
  if numerator.compare_int(0) == 0 {
    return 0.0
  }
  let negative = numerator.compare_int(0) < 0
  let abs_numerator = bigint_abs(numerator)
  let denominator = BigInt::from_int(denominator_int)
  let mut exponent = exp2 +
    abs_numerator.bit_length() -
    denominator.bit_length()
  if compare_float32_rational_to_power_of_two(
      abs_numerator, denominator, exp2, exponent,
    ) <
    0 {
    exponent -= 1
  }
  while compare_float32_rational_to_power_of_two(
          abs_numerator,
          denominator,
          exp2,
          exponent + 1,
        ) >=
        0 {
    exponent += 1
  }
  let sign_bits = if negative { 0x80000000U } else { 0U }
  if exponent < -126 {
    let shift = exp2 + 149
    let (scaled_numerator, scaled_denominator) = if shift >= 0 {
      (abs_numerator << shift, denominator)
    } else {
      (abs_numerator, denominator << -shift)
    }
    let rounded = round_bigint_divide_even(scaled_numerator, scaled_denominator)
    if rounded.compare_int(0) == 0 {
      return Float::reinterpret_from_uint(sign_bits).to_double()
    }
    let smallest_normal = BigInt::from_int(1 << 23)
    if rounded >= smallest_normal {
      return Float::reinterpret_from_uint(sign_bits | 0x00800000U).to_double()
    }
    return Float::reinterpret_from_uint(sign_bits | rounded.to_uint()).to_double()
  }
  let shift = exp2 - exponent + 23
  let (scaled_numerator, scaled_denominator) = if shift >= 0 {
    (abs_numerator << shift, denominator)
  } else {
    (abs_numerator, denominator << -shift)
  }
  let mut significand = round_bigint_divide_even(
    scaled_numerator, scaled_denominator,
  )
  let overflow_significand = BigInt::from_int(1 << 24)
  if significand == overflow_significand {
    significand = significand >> 1
    exponent += 1
  }
  if exponent >= 128 {
    return Float::reinterpret_from_uint(sign_bits | 0x7f800000U).to_double()
  }
  let exponent_bits = (exponent + 127).to_uint() << 23
  let fraction_bits = significand.to_uint() - 0x800000U
  Float::reinterpret_from_uint(sign_bits | exponent_bits | fraction_bits).to_double()
}

///|
fn float32_mul_int(value : Double, factor : Int) -> Double {
  let (numerator, exp2) = float32_rational_from_double(value)
  round_float32_rational_to_double(
    numerator * BigInt::from_int(factor),
    exp2,
    1,
  )
}

///|
fn float32_sub(lhs : Double, rhs : Double) -> Double {
  let (lhs_numerator, lhs_exp2) = float32_rational_from_double(lhs)
  let (rhs_numerator, rhs_exp2) = float32_rational_from_double(rhs)
  let exp2 = if lhs_exp2 < rhs_exp2 { lhs_exp2 } else { rhs_exp2 }
  let aligned_lhs = if lhs_exp2 > exp2 {
    lhs_numerator << (lhs_exp2 - exp2)
  } else {
    lhs_numerator
  }
  let aligned_rhs = if rhs_exp2 > exp2 {
    rhs_numerator << (rhs_exp2 - exp2)
  } else {
    rhs_numerator
  }
  round_float32_rational_to_double(aligned_lhs - aligned_rhs, exp2, 1)
}

///|
fn float32_mul_int_then_sub(
  value : Double,
  factor : Int,
  subtracted : Double,
) -> Double {
  let (value_numerator, value_exp2) = float32_rational_from_double(value)
  let (subtracted_numerator, subtracted_exp2) = float32_rational_from_double(
    subtracted,
  )
  let multiplied_numerator = value_numerator * BigInt::from_int(factor)
  let exp2 = if value_exp2 < subtracted_exp2 {
    value_exp2
  } else {
    subtracted_exp2
  }
  let aligned_multiplied = if value_exp2 > exp2 {
    multiplied_numerator << (value_exp2 - exp2)
  } else {
    multiplied_numerator
  }
  let aligned_subtracted = if subtracted_exp2 > exp2 {
    subtracted_numerator << (subtracted_exp2 - exp2)
  } else {
    subtracted_numerator
  }
  round_float32_rational_to_double(
    aligned_multiplied - aligned_subtracted,
    exp2,
    1,
  )
}

///|
fn float32_div_int(value : Double, divisor : Int) -> Double {
  let (numerator, exp2) = float32_rational_from_double(value)
  round_float32_rational_to_double(numerator, exp2, divisor)
}

///|
fn forecast_processing_kind(
  option_name : String,
  statistical_process : Int,
) -> ForecastProcessingKind? {
  if statistical_process == 0 {
    Some(Ave)
  } else if statistical_process == 1 {
    Some(Acc)
  } else if option_name == "-merge_fcst" && statistical_process == 2 {
    Some(Max)
  } else if option_name == "-merge_fcst" && statistical_process == 3 {
    Some(Min)
  } else {
    None
  }
}

///|
fn forecast_processing_kind_eq(
  lhs : ForecastProcessingKind,
  rhs : ForecastProcessingKind,
) -> Bool {
  match (lhs, rhs) {
    (Ave, Ave) => true
    (Acc, Acc) => true
    (Max, Max) => true
    (Min, Min) => true
    _ => false
  }
}

///|
fn forecast_processing_template48_key(
  section4 : @decode.Grib2Section4Decoded,
  template48 : @section4.Grib2ProductTemplate48,
) -> Bytes {
  let specs = template48.time_range_specs
  let normalized_specs = if specs.length() == 0 {
    specs
  } else {
    let head = specs[0]
    [{ ..head, time_range_length: 0 }, ..specs[1:]]
  }
  @decode.encode_section4_bytes({
    number_of_coordinate_values: section4.number_of_coordinate_values,
    template: @section4.ProductTemplate48({
      ..template48,
      base: { ..template48.base, forecast_time: 0 },
      end_year: 0,
      end_month: 0,
      end_day: 0,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      time_range_specs: normalized_specs,
    }),
    coordinate_values_raw: section4.coordinate_values_raw,
  })
}

///|
fn decode_forecast_processing_record(
  option_name : String,
  context : @context.Grib2FileContext,
  record_ref : SelectedRecordRef,
) -> Result[ForecastProcessingRecord?, String] {
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let meta = match find_record_meta(context, record_ref.record_index) {
    Some(v) => v
    None =>
      return Err(
        option_name +
        ": record not found " +
        record_ref.record_index.to_string(),
      )
  }
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Ok(None)
  }
  let section4 = match @decode.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        option_name +
        ": failed to decode Section 4 for record " +
        record_ref.record_index.to_string() +
        ": " +
        error.to_string(),
      )
  }
  let template48 = match section4.template {
    @section4.ProductTemplate48(v) => v
    _ => return Ok(None)
  }
  if template48.time_range_specs.length() != 1 {
    return Ok(None)
  }
  if template48.base.time_range_unit !=
    template48.time_range_specs[0].time_range_unit {
    return Ok(None)
  }
  let duration = template48.time_range_specs[0].time_range_length
  if duration <= 0 {
    return Ok(None)
  }
  let kind = match
    forecast_processing_kind(
      option_name,
      template48.time_range_specs[0].statistical_process,
    ) {
    Some(v) => v
    None => return Ok(None)
  }
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        option_name +
        ": failed to unpack record " +
        record_ref.record_index.to_string(),
      )
  }
  let normalized_values : Array[Double] = []
  for value in unpacked {
    normalized_values.push(to_wgrib2_float32(value))
  }
  Ok(
    Some({
      record_ref,
      meta,
      section1_bytes: section_frame_bytes(message, message.section1),
      section3_bytes: section_frame_bytes(message, submessage.section3),
      section4_bytes: section_frame_bytes(message, submessage.section4),
      section4_key: forecast_processing_template48_key(section4, template48),
      coordinate_value_count: section4.number_of_coordinate_values,
      coordinate_values_raw: section4.coordinate_values_raw,
      template48,
      kind,
      start_time: template48.base.forecast_time,
      duration,
      values: normalized_values,
    }),
  )
}

///|
fn forecast_processing_records_compatible(
  lhs : ForecastProcessingRecord,
  rhs : ForecastProcessingRecord,
) -> Bool {
  forecast_processing_kind_eq(lhs.kind, rhs.kind) &&
  lhs.section1_bytes == rhs.section1_bytes &&
  lhs.section3_bytes == rhs.section3_bytes &&
  lhs.section4_key == rhs.section4_key
}

///|
fn forecast_processing_output_section4_bytes(
  record : ForecastProcessingRecord,
  forecast_time : Int,
  duration : Int,
  end_template : @section4.Grib2ProductTemplate48,
) -> Bytes {
  let spec = record.template48.time_range_specs[0]
  @decode.encode_section4_bytes({
    number_of_coordinate_values: record.coordinate_value_count,
    template: @section4.ProductTemplate48({
      ..record.template48,
      base: { ..record.template48.base, forecast_time, },
      end_year: end_template.end_year,
      end_month: end_template.end_month,
      end_day: end_template.end_day,
      end_hour: end_template.end_hour,
      end_minute: end_template.end_minute,
      end_second: end_template.end_second,
      time_range_specs: [{ ..spec, time_range_length: duration }],
    }),
    coordinate_values_raw: record.coordinate_values_raw,
  })
}

///|
fn build_processed_forecast_submessage_bytes(
  option_name : String,
  context : @context.Grib2FileContext,
  record : ForecastProcessingRecord,
  section4_bytes : Bytes,
  values : Array[Double],
) -> Result[Bytes, String] {
  let message = context.messages[record.record_ref.message_index]
  let submessage = message.submessages[record.record_ref.submessage_index]
  let (sec6, defined_values) = build_wind_section6_bytes_and_defined_values(
    message, submessage, values,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_forecast_scaling(
      defined_values,
      record.meta.section5_reference_value_ieee,
      record.meta.section5_binary_scale_factor,
      record.meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for " +
        option_name +
        " record " +
        record.meta.record_index.to_string(),
      )
  }
  Ok(
    build_submessage_grib_bytes_with_overrides(
      message,
      submessage,
      Some(section4_bytes),
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn build_repacked_forecast_submessage_bytes(
  option_name : String,
  context : @context.Grib2FileContext,
  record : ForecastProcessingRecord,
) -> Result[Bytes, String] {
  build_processed_forecast_submessage_bytes(
    option_name,
    context,
    record,
    record.section4_bytes,
    record.values,
  )
}

///|
fn forecast_merge_values(
  kind : ForecastProcessingKind,
  lhs : Array[Double],
  rhs : Array[Double],
) -> Array[Double] {
  let out : Array[Double] = []
  for index in 0..<lhs.length() {
    let left = to_wgrib2_float32(lhs[index])
    let right = to_wgrib2_float32(rhs[index])
    let value = match kind {
      Ave | Acc =>
        if left == left && right == right {
          to_wgrib2_float32(left + right)
        } else {
          0.0 / 0.0
        }
      Max =>
        if left == left {
          if right == right && right > left {
            to_wgrib2_float32(right)
          } else {
            to_wgrib2_float32(left)
          }
        } else {
          to_wgrib2_float32(right)
        }
      Min =>
        if left == left {
          if right == right && right < left {
            to_wgrib2_float32(right)
          } else {
            to_wgrib2_float32(left)
          }
        } else {
          to_wgrib2_float32(right)
        }
    }
    out.push(value)
  }
  out
}

///|
fn forecast_scale_average_values(
  values : Array[Double],
  factor : Double,
) -> Array[Double] {
  let out : Array[Double] = []
  let factor_f32 = to_wgrib2_float32(factor)
  for value in values {
    if value == value {
      out.push(to_wgrib2_float32(to_wgrib2_float32(value) * factor_f32))
    } else {
      out.push(value)
    }
  }
  out
}

///|
fn forecast_residual_values(
  kind : ForecastProcessingKind,
  shorter : Array[Double],
  longer : Array[Double],
  shorter_duration : Int,
  longer_duration : Int,
) -> Array[Double] {
  let out : Array[Double] = []
  for index in 0..<shorter.length() {
    let left = to_wgrib2_float32(shorter[index])
    let right = to_wgrib2_float32(longer[index])
    if left != left || right != right {
      out.push(0.0 / 0.0)
    } else if forecast_processing_kind_eq(kind, Ave) {
      let left_term = float32_mul_int(left, shorter_duration)
      let numerator = float32_mul_int_then_sub(
        right, longer_duration, left_term,
      )
      out.push(float32_div_int(numerator, longer_duration - shorter_duration))
    } else {
      out.push(float32_sub(right, left))
    }
  }
  out
}

///|
fn write_ncep_norm_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  let mut saved : ForecastProcessingRecord? = None
  for record_ref in refs {
    let current = match
      decode_forecast_processing_record("-ncep_norm", context, record_ref) {
      Ok(Some(v)) => v
      Ok(None) => continue
      Err(error) => return Err(error)
    }
    match saved {
      None => {
        append_bytes(
          out,
          match
            build_repacked_forecast_submessage_bytes(
              "-ncep_norm", context, current,
            ) {
            Ok(v) => v
            Err(error) => return Err(error)
          },
        )
        saved = Some(current)
      }
      Some(previous) =>
        if !forecast_processing_records_compatible(previous, current) ||
          previous.start_time != current.start_time {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-ncep_norm", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
          saved = Some(current)
        } else if previous.duration == current.duration {
          continue
        } else if current.duration < previous.duration {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-ncep_norm", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
          saved = Some(current)
        } else {
          let normalized_values = forecast_residual_values(
            previous.kind,
            previous.values,
            current.values,
            previous.duration,
            current.duration,
          )
          let new_start = previous.start_time + previous.duration
          let new_duration = current.duration - previous.duration
          let section4_bytes = forecast_processing_output_section4_bytes(
            previous,
            new_start,
            new_duration,
            current.template48,
          )
          append_bytes(
            out,
            match
              build_processed_forecast_submessage_bytes(
                "-ncep_norm", context, previous, section4_bytes, normalized_values,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
          saved = Some({
            ..previous,
            section4_bytes,
            template48: {
              ..previous.template48,
              base: { ..previous.template48.base, forecast_time: new_start },
              end_year: current.template48.end_year,
              end_month: current.template48.end_month,
              end_day: current.template48.end_day,
              end_hour: current.template48.end_hour,
              end_minute: current.template48.end_minute,
              end_second: current.template48.end_second,
              time_range_specs: [
                {
                  ..previous.template48.time_range_specs[0],
                  time_range_length: new_duration,
                },
              ],
            },
            start_time: new_start,
            duration: new_duration,
            values: normalized_values,
          })
        }
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_merge_fcst_output(
  intervals : String,
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let n = match parse_int_option(intervals) {
    Some(v) => v
    None => return Err("merge_fcst: arg must be integer")
  }
  if n < 0 {
    return Err("merge_fcst: arg must be >= 0")
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  let mut saved : ForecastProcessingState? = None
  for record_ref in refs {
    let current = match
      decode_forecast_processing_record("-merge_fcst", context, record_ref) {
      Ok(Some(v)) => v
      Ok(None) => continue
      Err(error) => return Err(error)
    }
    match saved {
      None => {
        if n == 0 {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-merge_fcst", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
        }
        saved = Some({ record: current, count: 1 })
      }
      Some(state) => {
        let expected_start = state.record.start_time +
          state.record.duration * state.count
        if !forecast_processing_records_compatible(state.record, current) ||
          current.start_time != expected_start ||
          current.duration != state.record.duration {
          if n == 0 {
            append_bytes(
              out,
              match
                build_repacked_forecast_submessage_bytes(
                  "-merge_fcst", context, current,
                ) {
                Ok(v) => v
                Err(error) => return Err(error)
              },
            )
          }
          saved = Some({ record: current, count: 1 })
          continue
        }
        let merged_values = forecast_merge_values(
          state.record.kind,
          state.record.values,
          current.values,
        )
        let merged_count = state.count + 1
        let merged_duration = state.record.duration * merged_count
        let section4_bytes = forecast_processing_output_section4_bytes(
          state.record,
          state.record.start_time,
          merged_duration,
          current.template48,
        )
        let output_values = if forecast_processing_kind_eq(
            state.record.kind,
            Ave,
          ) {
          forecast_scale_average_values(
            merged_values,
            1.0 / merged_count.to_double(),
          )
        } else {
          merged_values
        }
        if merged_count == n || n == 0 {
          append_bytes(
            out,
            match
              build_processed_forecast_submessage_bytes(
                "-merge_fcst",
                context,
                state.record,
                section4_bytes,
                output_values,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
        }
        if n == 0 {
          saved = Some({
            record: {
              ..state.record,
              section4_bytes,
              template48: {
                ..state.record.template48,
                end_year: current.template48.end_year,
                end_month: current.template48.end_month,
                end_day: current.template48.end_day,
                end_hour: current.template48.end_hour,
                end_minute: current.template48.end_minute,
                end_second: current.template48.end_second,
                time_range_specs: [
                  {
                    ..state.record.template48.time_range_specs[0],
                    time_range_length: merged_duration,
                  },
                ],
              },
              duration: merged_duration,
              values: merged_values,
            },
            count: merged_count,
          })
        } else if merged_count == n {
          saved = None
        } else {
          saved = Some({
            record: { ..state.record, values: merged_values },
            count: merged_count,
          })
        }
      }
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_unmerge_fcst_output(
  destination : String,
  fcst_time_0 : String,
  z_arg : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let (base_unit, base_time) = match parse_unmerge_fcst_time_spec(fcst_time_0) {
    Some(v) => v
    None => return Err("unmerge_fcst: bad (int)(mn|hr|dy|mo|yr)")
  }
  let z = match parse_int_option(z_arg) {
    Some(v) => v
    None => return Err("unmerge_fcst: z must be 0..2")
  }
  if z < 0 || z > 2 {
    return Err("unmerge_fcst: z must be 0..2")
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  let mut saved : ForecastProcessingRecord? = None
  for record_ref in refs {
    let current = match
      decode_forecast_processing_record("-unmerge_fcst", context, record_ref) {
      Ok(Some(v)) => v
      Ok(None) => continue
      Err(error) => return Err(error)
    }
    if !forecast_processing_kind_eq(current.kind, Ave) &&
      !forecast_processing_kind_eq(current.kind, Acc) {
      continue
    }
    if current.start_time != base_time {
      continue
    }
    if base_time != 0 && current.template48.base.time_range_unit != base_unit {
      continue
    }
    match saved {
      None => {
        if z > 0 {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-unmerge_fcst", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
        }
        saved = Some(current)
      }
      Some(previous) => {
        if !forecast_processing_records_compatible(previous, current) {
          if z > 0 {
            append_bytes(
              out,
              match
                build_repacked_forecast_submessage_bytes(
                  "-unmerge_fcst", context, current,
                ) {
                Ok(v) => v
                Err(error) => return Err(error)
              },
            )
          }
          saved = Some(current)
          continue
        }
        if previous.section4_bytes == current.section4_bytes {
          continue
        }
        if current.duration <= previous.duration {
          if z > 0 {
            append_bytes(
              out,
              match
                build_repacked_forecast_submessage_bytes(
                  "-unmerge_fcst", context, current,
                ) {
                Ok(v) => v
                Err(error) => return Err(error)
              },
            )
          }
          saved = Some(current)
          continue
        }
        if z > 1 {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-unmerge_fcst", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
        }
        let section4_bytes = forecast_processing_output_section4_bytes(
          current,
          base_time + previous.duration,
          current.duration - previous.duration,
          current.template48,
        )
        let message = context.messages[current.record_ref.message_index]
        let submessage = message.submessages[current.record_ref.submessage_index]
        append_bytes(
          out,
          match
            build_defined_zero_field_submessage_bytes(
              "-unmerge_fcst",
              message,
              submessage,
              current.meta,
              section4_bytes,
            ) {
            Ok(v) => v
            Err(error) => return Err(error)
          },
        )
        saved = Some(current)
      }
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
struct WindCandidateRecord {
  record_index : Int
  message_index : Int
  submessage_index : Int
  pair_key : Bytes
}

///|
priv struct SelectedRecordRef {
  record_index : Int
  message_index : Int
  submessage_index : Int
}

///|
