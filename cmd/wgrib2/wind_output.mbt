///|
fn wind_input_packing_supported(template_id : Int) -> Bool {
  template_id == 0 ||
  template_id == 2 ||
  template_id == 3 ||
  template_id == 4 ||
  template_id == 40 ||
  template_id == 41
}

///|
fn is_wind_u_component(meta : @decode.Grib2RecordMeta) -> Bool {
  @common.is_wind_u_component(meta)
}

///|
fn is_wind_v_component(meta : @decode.Grib2RecordMeta) -> Bool {
  @common.is_wind_v_component(meta)
}

///|
fn is_wind_speed_component(meta : @decode.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 1
}

///|
fn is_wind_direction_component(meta : @decode.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 0
}

///|
fn build_wind_pair_key(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
) -> Bytes {
  let sec3 = section_frame_bytes(message, submessage.section3)
  let sec4 = section_frame_bytes(message, submessage.section4)
  let sec6 = section_frame_bytes(message, submessage.section6)
  if sec4.length() < 11 {
    return Bytes::new(0)
  }
  let sec4_masked : Array[Byte] = []
  for b in sec4 {
    sec4_masked.push(b)
  }
  sec4_masked[9] = b'\x00'
  sec4_masked[10] = b'\x00'
  let key : Array[Byte] = []
  append_bytes(key, sec3)
  key.push(b'|')
  append_bytes(key, Bytes::from_array(sec4_masked))
  key.push(b'|')
  append_bytes(key, sec6)
  Bytes::from_array(key)
}

///|
fn patch_section4_parameter_ids(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  parameter_category : Int,
  parameter_number : Int,
) -> Result[Bytes, String] {
  let sec4 = section_frame_bytes(message, submessage.section4)
  if sec4.length() < 11 {
    return Err("section4 too short to patch parameter ids")
  }
  let out : Array[Byte] = []
  for b in sec4 {
    out.push(b)
  }
  out[9] = parameter_category.to_byte()
  out[10] = parameter_number.to_byte()
  Ok(Bytes::from_array(out))
}

///|
fn wind_dir_from_uv(u : Double, v : Double) -> Double {
  if u != u || v != v {
    return 0.0 / 0.0
  }
  let u_f = Float::from_double(u).to_double()
  let v_f = Float::from_double(v).to_double()
  let mut deg = @math.atan2(-u_f, -v_f) * 180.0 / @math.PI
  if deg <= 0.0 {
    deg += 360.0
  }
  Float::from_double(deg).to_double()
}

///|
fn wind_derived_value(u : Double, v : Double, mode : WindDerivedMode) -> Double {
  match mode {
    WindDerivedSpeed =>
      if u != u || v != v {
        0.0 / 0.0
      } else {
        let u_f = Float::from_double(u).to_double()
        let v_f = Float::from_double(v).to_double()
        let sum_sq = Float::from_double(u_f * u_f + v_f * v_f).to_double()
        Float::from_double(sqrt_newton(sum_sq)).to_double()
      }
    WindDerivedDir => wind_dir_from_uv(u, v)
  }
}

///|
fn wind_uv_from_speed_dir(
  speed : Double,
  direction_deg : Double,
) -> (Double, Double) {
  if speed != speed || direction_deg != direction_deg {
    return (0.0 / 0.0, 0.0 / 0.0)
  }
  // Match wgrib2 Wind_uv.c numeric path:
  // float speed/dir inputs, double sin/cos, float outputs.
  let speed_f = Float::from_double(speed).to_double()
  if speed_f == 0.0 {
    return (0.0, 0.0)
  }
  let dir_f = Float::from_double(direction_deg).to_double()
  let rad = dir_f * 0.017453292519943295769
  let u = Float::from_double(-speed_f * @math.sin(rad)).to_double()
  let v = Float::from_double(-speed_f * @math.cos(rad)).to_double()
  (u, v)
}

///|
fn pow2_int(n : Int) -> Double {
  let mut out = 1.0
  if n >= 0 {
    for _ in 0..<n {
      out = out * 2.0
    }
  } else {
    for _ in 0..<-n {
      out = out / 2.0
    }
  }
  out
}

///|
fn pow10_int(n : Int) -> Double {
  let mut out = 1.0
  if n >= 0 {
    for _ in 0..<n {
      out = out * 10.0
    }
  } else {
    for _ in 0..<-n {
      out = out / 10.0
    }
  }
  out
}

///|
fn sqrt_newton(x : Double) -> Double {
  if x <= 0.0 {
    return 0.0
  }
  let mut guess = if x >= 1.0 { x } else { 1.0 }
  for _ in 0..<12 {
    guess = 0.5 * (guess + x / guess)
  }
  guess
}

///|
fn required_bits_nonnegative(max_value : Int) -> Int {
  if max_value <= 0 {
    return 0
  }
  let mut bits = 0
  let mut v = max_value
  while v > 0 {
    bits += 1
    v = v >> 1
  }
  bits
}

///|
fn pack_unsigned_values_be(values : Array[Int], bits_per_value : Int) -> Bytes {
  if bits_per_value <= 0 {
    return Bytes::new(0)
  }
  let out : Array[Byte] = []
  let mut current = 0
  let mut filled = 0
  for value in values {
    let v = if value < 0 { 0 } else { value }
    for i in 0..<bits_per_value {
      let shift = bits_per_value - 1 - i
      let bit = (v >> shift) & 1
      current = (current << 1) | bit
      filled += 1
      if filled == 8 {
        out.push((current & 0xFF).to_byte())
        current = 0
        filled = 0
      }
    }
  }
  if filled > 0 {
    current = current << (8 - filled)
    out.push((current & 0xFF).to_byte())
  }
  Bytes::from_array(out)
}

///|
fn encode_i16_sign_magnitude(value : Int) -> Int {
  let magnitude = if value < 0 { -value } else { value }
  let bounded = if magnitude > 0x7FFF { 0x7FFF } else { magnitude }
  if value < 0 {
    0x8000 | bounded
  } else {
    bounded
  }
}

///|
fn encode_i32_sign_magnitude(value : Int) -> Int {
  let magnitude = if value < 0 { -value } else { value }
  let bounded = if magnitude > 0x7FFF_FFFF { 0x7FFF_FFFF } else { magnitude }
  if value < 0 {
    0x8000_0000 | bounded
  } else {
    bounded
  }
}

///|
fn section5_original_field_value_type(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
) -> Int {
  let sec5 = section_frame_bytes(message, submessage.section5)
  if sec5.length() > 20 {
    sec5[20].to_uint().reinterpret_as_int()
  } else {
    0
  }
}

///|
fn regular_grid_source_index_for_scan(
  ni : Int,
  nj : Int,
  scan_mode : Int,
  i : Int,
  j : Int,
) -> Int {
  let scan = @typed.parse_scanning_mode(scan_mode)
  let j_scan = if scan.j_positive { j } else { nj - 1 - j }
  let i_scan = if scan.alternating_rows && (j_scan & 1) == 1 {
    ni - 1 - i
  } else {
    i
  }
  let i_scan = if scan.i_negative { ni - 1 - i_scan } else { i_scan }
  if scan.consecutive_j {
    j_scan + i_scan * nj
  } else {
    i_scan + j_scan * ni
  }
}

///|
fn same_section_frame_for_grib_out(
  lhs : @context.Grib2SectionFrame,
  rhs : @context.Grib2SectionFrame,
) -> Bool {
  lhs.section_number == rhs.section_number &&
  lhs.start == rhs.start &&
  lhs.length == rhs.length
}

///|
fn find_submessage_index_for_grib_out(
  message : @context.Grib2MessageContext,
  target : @context.Grib2SubmessageFrame,
) -> Int? {
  for index in 0..<message.submessages.length() {
    let candidate = message.submessages[index]
    if same_section_frame_for_grib_out(candidate.section3, target.section3) &&
      same_section_frame_for_grib_out(candidate.section4, target.section4) &&
      same_section_frame_for_grib_out(candidate.section5, target.section5) &&
      same_section_frame_for_grib_out(candidate.section6, target.section6) &&
      same_section_frame_for_grib_out(candidate.section7, target.section7) {
      return Some(index)
    }
  }
  None
}

///|
fn resolve_bitmap_raw_for_grib_out(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  section6 : @decode.Grib2Section6Decoded,
) -> Result[Bytes?, String] {
  if section6.bitmap_indicator == 255 {
    return Ok(None)
  }
  if section6.bitmap_indicator == 0 {
    return Ok(Some(section6.bitmap_raw))
  }
  if section6.bitmap_indicator != 254 {
    return Err(
      "bitmap indicator not supported for -grib_out: " +
      section6.bitmap_indicator.to_string(),
    )
  }
  let submessage_index = match
    find_submessage_index_for_grib_out(message, submessage) {
    Some(v) => v
    None => return Err("failed to locate submessage for bitmap reuse")
  }
  for previous in 0..<submessage_index {
    let prev_index = submessage_index - 1 - previous
    let prev_submessage = message.submessages[prev_index]
    let prev_section6 = match
      @decode.decode_submessage_section6(message, prev_submessage) {
      Ok(v) => v
      Err(_) => continue
    }
    if prev_section6.bitmap_indicator == 0 {
      return Ok(Some(prev_section6.bitmap_raw))
    }
  }
  Err("bitmap indicator 254 references a bitmap that is not available")
}

///|
fn restore_input_scan_order_for_grib_out(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  values : Array[Double],
) -> Array[Double] {
  let section3 = match @decode.decode_submessage_section3(message, submessage) {
    Ok(v) => v
    Err(_) => return values
  }
  let grid_info = @typed.get_section3_grid_info(section3.template)
  let ni = grid_info.ni
  let nj = grid_info.nj
  if ni <= 0 || nj <= 0 || ni * nj != values.length() {
    return values
  }
  let reordered : Array[Double] = Array::make(values.length(), 0.0 / 0.0)
  for j_out in 0..<nj {
    for i_out in 0..<ni {
      let normalized_index = j_out * ni + i_out
      let raw_index = regular_grid_source_index_for_scan(
        ni,
        nj,
        grid_info.scan_mode,
        i_out,
        j_out,
      )
      reordered[raw_index] = values[normalized_index]
    }
  }
  reordered
}

///|
fn collect_defined_values_for_grib_out(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  values : Array[Double],
) -> Result[Array[Double], String] {
  let input_order = restore_input_scan_order_for_grib_out(
    message, submessage, values,
  )
  let section6 = match @decode.decode_submessage_section6(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 6: \{e}")
  }
  let bitmap_raw = match
    resolve_bitmap_raw_for_grib_out(message, submessage, section6) {
    Ok(None) => return Ok(input_order)
    Ok(Some(v)) => v
    Err(e) => return Err(e)
  }
  if section6.bitmap_indicator == 255 {
    return Ok(input_order)
  }
  let defined_values : Array[Double] = []
  for bit_index in 0..<input_order.length() {
    let byte_index = bit_index / 8
    if byte_index >= bitmap_raw.length() {
      return Err(
        "bitmap payload too short for -grib_out at bit " + bit_index.to_string(),
      )
    }
    let bit_offset = 7 - bit_index % 8
    let mask = 1 << bit_offset
    let byte_val = bitmap_raw[byte_index].to_uint().reinterpret_as_int()
    if (byte_val & mask) != 0 {
      let value = input_order[bit_index]
      if value != value {
        return Err(
          "bitmap-defined point became NaN during -grib_out repack at index " +
          bit_index.to_string(),
        )
      }
      defined_values.push(value)
    }
  }
  Ok(defined_values)
}

///|
fn build_grib_out_section6_bytes(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
) -> Result[Bytes, String] {
  let section6 = match @decode.decode_submessage_section6(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 6: \{e}")
  }
  match resolve_bitmap_raw_for_grib_out(message, submessage, section6) {
    Ok(None) => Ok(section_frame_bytes(message, submessage.section6))
    Ok(Some(bitmap_raw)) =>
      if section6.bitmap_indicator == 0 {
        Ok(section_frame_bytes(message, submessage.section6))
      } else {
        Ok(@decode.encode_section6_bytes({ bitmap_indicator: 0, bitmap_raw }))
      }
    Err(e) => Err(e)
  }
}

///|
fn try_build_simple_packed_sections_with_scaling(
  values : Array[Double],
  reference_value_ieee : Int,
  binary_scale_factor : Int,
  decimal_scale_factor : Int,
  original_field_value_type : Int,
) -> (Bytes, Bytes)? {
  let to_wgrib2_float = fn(value : Double) -> Double {
    Float::from_double(value).to_double()
  }
  let normalized_values : Array[Double] = []
  for value in values {
    if value != value {
      return None
    }
    normalized_values.push(to_wgrib2_float(value))
  }
  let mut min_value = Float::reinterpret_from_int(reference_value_ieee).to_double()
  let mut max_value = min_value
  if normalized_values.length() > 0 {
    min_value = normalized_values[0]
    max_value = normalized_values[0]
    for value in normalized_values {
      if value < min_value {
        min_value = value
      }
      if value > max_value {
        max_value = value
      }
    }
  }
  let constant_field = normalized_values.length() == 0 || min_value == max_value
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
  let decimal_scale = pow10_int(output_decimal_scale_factor)
  let output_reference_value_ieee = if normalized_values.length() == 0 {
    0
  } else if constant_field {
    Float::from_double(to_wgrib2_float(min_value)).reinterpret_as_int()
  } else {
    Float::from_double(to_wgrib2_float(min_value * decimal_scale)).reinterpret_as_int()
  }
  let reference_value = Float::reinterpret_from_int(output_reference_value_ieee).to_double()
  let binary_scale = pow2_int(output_binary_scale_factor)
  let packed_values : Array[Int] = []
  let mut max_packed = 0
  for value in normalized_values {
    let decimal_scaled = if output_decimal_scale_factor == 0 {
      value
    } else {
      to_wgrib2_float(value * decimal_scale)
    }
    let packed_float = if output_binary_scale_factor == 0 {
      to_wgrib2_float(decimal_scaled - reference_value)
    } else {
      to_wgrib2_float((decimal_scaled - reference_value) / binary_scale)
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
    number_of_data_points: normalized_values.length(),
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
fn build_grib_out_submessage_bytes(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
) -> Result[Bytes, String] {
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      "-grib_out is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let unpacked = match @decode.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for -grib_out",
      )
  }
  let defined_values = match
    collect_defined_values_for_grib_out(message, submessage, unpacked) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect defined values for -grib_out record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
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
        "failed to rebuild simple-packed data for -grib_out record " +
        meta.record_index.to_string(),
      )
  }
  let sec6 = match build_grib_out_section6_bytes(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to resolve Section 6 for -grib_out record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  Ok(
    build_submessage_grib_bytes_with_overrides(
      message,
      submessage,
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn build_wind_section6_bytes_and_defined_values(
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  values : Array[Double],
) -> (Bytes, Array[Double]) {
  let input_order = restore_input_scan_order_for_grib_out(
    message, submessage, values,
  )
  let defined_values : Array[Double] = []
  let bitmap = Array::make((input_order.length() + 7) / 8, b'\x00')
  let mut has_undefined = false
  for index in 0..<input_order.length() {
    let value = input_order[index]
    if value != value {
      has_undefined = true
      continue
    }
    defined_values.push(value)
    let byte_index = index / 8
    let bit_offset = 7 - index % 8
    let current = bitmap[byte_index].to_uint().reinterpret_as_int()
    bitmap[byte_index] = (current | (1 << bit_offset)).to_byte()
  }
  let sec6 = if has_undefined {
    @decode.encode_section6_bytes({
      bitmap_indicator: 0,
      bitmap_raw: Bytes::from_array(bitmap),
    })
  } else {
    build_no_bitmap_section6_bytes()
  }
  (sec6, defined_values)
}

///|
fn build_wind_simple_packed_submessage_bytes(
  option_name : String,
  message : @context.Grib2MessageContext,
  submessage : @context.Grib2SubmessageFrame,
  meta : @decode.Grib2RecordMeta,
  section4 : Bytes,
  values : Array[Double],
  reference_value_ieee : Int,
  binary_scale_factor : Int,
  decimal_scale_factor : Int,
) -> Result[Bytes, String] {
  let (sec6, defined_values) = build_wind_section6_bytes_and_defined_values(
    message, submessage, values,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      defined_values, reference_value_ieee, binary_scale_factor, decimal_scale_factor,
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
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_wind_derived_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  mode : WindDerivedMode,
  append_mode : Bool,
) -> Result[Unit, String] {
  let metas = @decode.decode_records(context)
  for meta in metas {
    if record_is_selected(meta.record_index, selected) &&
      (is_wind_u_component(meta) || is_wind_v_component(meta)) {
      let packing = meta.section5_template.id()
      if !wind_input_packing_supported(packing) {
        return Err(
          "wind derived output is not implemented for packing template " +
          packing.to_string() +
          " (requires verified unpacking parity with wgrib2)",
        )
      }
    }
  }
  let u_candidates : Map[Bytes, WindCandidateRecord] = {}
  let v_candidates : Map[Bytes, WindCandidateRecord] = {}
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index < metas.length() {
          let meta = metas[meta_index]
          if is_wind_u_component(meta) || is_wind_v_component(meta) {
            let pair_key = build_wind_pair_key(
              message,
              message.submessages[submessage_index],
            )
            if pair_key.length() == 0 {
              record_index += 1
              continue
            }
            let candidate : WindCandidateRecord = {
              record_index,
              message_index,
              submessage_index,
              pair_key,
            }
            if is_wind_u_component(meta) {
              u_candidates.set(pair_key, candidate)
            } else if is_wind_v_component(meta) {
              v_candidates.set(pair_key, candidate)
            }
          }
        }
      }
      record_index += 1
    }
  }
  let out : Array[Byte] = []
  for _, u_candidate in u_candidates {
    match v_candidates.get(u_candidate.pair_key) {
      None => ()
      Some(v_candidate) => {
        let u_message = context.messages[u_candidate.message_index]
        let u_submessage = u_message.submessages[u_candidate.submessage_index]
        let v_message = context.messages[v_candidate.message_index]
        let v_submessage = v_message.submessages[v_candidate.submessage_index]
        let u_values = match
          @decode.unpack_submessage_data(u_message, u_submessage) {
          Ok(v) => v.values
          Err(_) =>
            return Err(
              "failed to unpack U record " +
              u_candidate.record_index.to_string() +
              " for wind-derived output",
            )
        }
        let v_values = match
          @decode.unpack_submessage_data(v_message, v_submessage) {
          Ok(v) => v.values
          Err(_) =>
            return Err(
              "failed to unpack V record " +
              v_candidate.record_index.to_string() +
              " for wind-derived output",
            )
        }
        if u_values.length() != v_values.length() {
          return Err(
            "wind pair value length mismatch: U=" +
            u_values.length().to_string() +
            ", V=" +
            v_values.length().to_string(),
          )
        }
        let derived_values : Array[Double] = []
        for i in 0..<u_values.length() {
          derived_values.push(
            wind_derived_value(u_values[i], v_values[i], mode),
          )
        }
        let u_meta = metas[u_candidate.record_index - 1]
        let sec4 = match mode {
          WindDerivedSpeed =>
            match patch_section4_parameter_ids(u_message, u_submessage, 2, 1) {
              Ok(v) => v
              Err(e) => return Err(e)
            }
          WindDerivedDir =>
            match patch_section4_parameter_ids(u_message, u_submessage, 2, 0) {
              Ok(v) => v
              Err(e) => return Err(e)
            }
        }
        let (
          option_name,
          reference_value_ieee,
          binary_scale_factor,
          decimal_scale_factor,
        ) = match mode {
          WindDerivedSpeed =>
            (
              "-wind_speed",
              u_meta.section5_reference_value_ieee,
              u_meta.section5_binary_scale_factor,
              u_meta.section5_decimal_scale_factor,
            )
          WindDerivedDir => ("-wind_dir", 0, 0, 0)
        }
        let built = match
          build_wind_simple_packed_submessage_bytes(
            option_name, u_message, u_submessage, u_meta, sec4, derived_values, reference_value_ieee,
            binary_scale_factor, decimal_scale_factor,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, built)
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
fn write_wind_uv_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let metas = @decode.decode_records(context)
  let speed_candidates : Map[Bytes, WindCandidateRecord] = {}
  let direction_candidates : Map[Bytes, WindCandidateRecord] = {}
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index < metas.length() {
          let meta = metas[meta_index]
          if is_wind_speed_component(meta) || is_wind_direction_component(meta) {
            let packing = meta.section5_template.id()
            if !wind_input_packing_supported(packing) {
              // Limited compatibility: ignore unsupported packing for -wind_uv.
              // If all selected records are skipped, we write empty output.
              record_index += 1
              continue
            }
            let pair_key = build_wind_pair_key(
              message,
              message.submessages[submessage_index],
            )
            if pair_key.length() == 0 {
              record_index += 1
              continue
            }
            let candidate : WindCandidateRecord = {
              record_index,
              message_index,
              submessage_index,
              pair_key,
            }
            if is_wind_speed_component(meta) {
              speed_candidates.set(pair_key, candidate)
            } else if is_wind_direction_component(meta) {
              direction_candidates.set(pair_key, candidate)
            }
          }
        }
      }
      record_index += 1
    }
  }
  let out : Array[Byte] = []
  for _, speed_candidate in speed_candidates {
    match direction_candidates.get(speed_candidate.pair_key) {
      None => ()
      Some(direction_candidate) => {
        let speed_message = context.messages[speed_candidate.message_index]
        let speed_submessage = speed_message.submessages[speed_candidate.submessage_index]
        let dir_message = context.messages[direction_candidate.message_index]
        let dir_submessage = dir_message.submessages[direction_candidate.submessage_index]
        let speed_values = match
          @decode.unpack_submessage_data(speed_message, speed_submessage) {
          Ok(v) => v.values
          Err(_) =>
            return Err(
              "failed to unpack speed record " +
              speed_candidate.record_index.to_string() +
              " for wind_uv output",
            )
        }
        let dir_values = match
          @decode.unpack_submessage_data(dir_message, dir_submessage) {
          Ok(v) => v.values
          Err(_) =>
            return Err(
              "failed to unpack direction record " +
              direction_candidate.record_index.to_string() +
              " for wind_uv output",
            )
        }
        if speed_values.length() != dir_values.length() {
          return Err(
            "wind speed/dir length mismatch: speed=" +
            speed_values.length().to_string() +
            ", dir=" +
            dir_values.length().to_string(),
          )
        }
        let u_values : Array[Double] = []
        let v_values : Array[Double] = []
        for i in 0..<speed_values.length() {
          let (u, v) = wind_uv_from_speed_dir(speed_values[i], dir_values[i])
          u_values.push(u)
          v_values.push(v)
        }
        let speed_meta = metas[speed_candidate.record_index - 1]
        // Match wgrib2 ordering: UGRD first, then VGRD.
        let u_sec4 = match
          patch_section4_parameter_ids(speed_message, speed_submessage, 2, 2) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        let u_built = match
          build_wind_simple_packed_submessage_bytes(
            "-wind_uv",
            speed_message,
            speed_submessage,
            speed_meta,
            u_sec4,
            u_values,
            speed_meta.section5_reference_value_ieee,
            speed_meta.section5_binary_scale_factor,
            speed_meta.section5_decimal_scale_factor,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, u_built)
        let v_sec4 = match
          patch_section4_parameter_ids(speed_message, speed_submessage, 2, 3) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        let v_built = match
          build_wind_simple_packed_submessage_bytes(
            "-wind_uv",
            speed_message,
            speed_submessage,
            speed_meta,
            v_sec4,
            v_values,
            speed_meta.section5_reference_value_ieee,
            speed_meta.section5_binary_scale_factor,
            speed_meta.section5_decimal_scale_factor,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, v_built)
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
fn write_gridout_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let target_record = first_selected_record(selected)
  let records = @decode.decode_records(context)
  let mut found : @decode.Grib2RecordMeta? = None
  for meta in records {
    if meta.record_index == target_record {
      found = Some(meta)
      break
    }
  }
  let meta = match found {
    Some(v) => v
    None =>
      return Err("record not found for -gridout: " + target_record.to_string())
  }
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err(
      "-gridout currently supports regular lat/lon grid (template 3.0)",
    )
  }
  let lines : Array[String] = []
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      match grid_ij_to_latlon_from_meta(meta, i, j) {
        Some((lon, lat)) =>
          lines.push(
            pad_left(i.to_string(), 10) +
            "," +
            pad_left(j.to_string(), 10) +
            ", " +
            format_fixed(lat, 3) +
            ", " +
            format_fixed(lon, 3),
          )
        None => ()
      }
    }
  }
  let content = lines.join("\n") + "\n"
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn name_lookup_text(name : @decode.Grib2NameLookup) -> String {
  match name {
    NameKnown(v) => v
    NameUnknown(v) => v
  }
}

///|
fn gribtable_used_master_table_set(
  discipline : Int,
  category : Int,
  parameter : Int,
) -> Int {
  if discipline >= 192 || category >= 192 || parameter >= 192 {
    0
  } else {
    1
  }
}

///|
fn gribtable_used_desc_units(
  discipline : Int,
  category : Int,
  parameter : Int,
  name : String,
) -> (String, String) {
  let fallback = (name, "?")
  if discipline == 0 && category == 0 {
    match parameter {
      0 => return ("Temperature", "K")
      2 => return ("Potential Temperature", "K")
      6 => return ("Dew Point Temperature", "K")
      21 => return ("Apparent Temperature", "K")
      _ => ()
    }
  }
  if discipline == 0 && category == 1 {
    match parameter {
      0 => return ("Specific Humidity", "kg/kg")
      1 => return ("Relative Humidity", "%")
      3 => return ("Precipitable Water", "kg/m^2")
      7 => return ("Precipitation Rate", "kg/m^2/s")
      11 => return ("Snow Depth", "m")
      13 => return ("Water Equivalent of Accumulated Snow Depth", "kg/m^2")
      22 => return ("Cloud Mixing Ratio", "kg/kg")
      23 => return ("Ice Water Mixing Ratio", "kg/kg")
      24 => return ("Rain Mixing Ratio", "kg/kg")
      25 => return ("Snow Mixing Ratio", "kg/kg")
      32 => return ("Graupel", "kg/kg")
      39 => return ("Percent frozen precipitation", "%")
      192 => return ("Categorical Rain", "-")
      193 => return ("Categorical Freezing Rain", "-")
      194 => return ("Categorical Ice Pellets", "-")
      195 => return ("Categorical Snow", "-")
      _ => ()
    }
  }
  if discipline == 0 && category == 2 {
    match parameter {
      0 => return ("Wind Direction (from which blowing)", "deg")
      1 => return ("Wind Speed", "m/s")
      2 => return ("U-Component of Wind", "m/s")
      3 => return ("V-Component of Wind", "m/s")
      8 => return ("Vertical Velocity (Pressure)", "Pa/s")
      9 => return ("Vertical Velocity (Geometric)", "m/s")
      10 => return ("Absolute Vorticity", "1/s")
      22 => return ("Wind Speed (Gust)", "m/s")
      192 => return ("Vertical Speed Shear", "1/s")
      194 => return ("U-Component Storm Motion", "m/s")
      195 => return ("V-Component Storm Motion", "m/s")
      197 => return ("Frictional Velocity", "m/s")
      224 => return ("Ventilation Rate", "m^2/s")
      _ => ()
    }
  }
  if discipline == 0 && category == 3 {
    match parameter {
      0 => return ("Pressure", "Pa")
      1 => return ("Pressure Reduced to MSL", "Pa")
      3 => return ("ICAO Standard Atmosphere Reference Height", "m")
      5 => return ("Geopotential Height", "gpm")
      192 => return ("MSLP (Eta model reduction)", "Pa")
      196 => return ("Planetary Boundary Layer Height", "m")
      200 => return ("Pressure of level from which parcel was lifted", "Pa")
      _ => ()
    }
  }
  if discipline == 0 && category == 6 {
    match parameter {
      1 => return ("Total Cloud Cover", "%")
      3 => return ("Low Cloud Cover", "%")
      4 => return ("Medium Cloud Cover", "%")
      5 => return ("High Cloud Cover", "%")
      6 => return ("Cloud Water", "kg/m^2")
      201 => return ("Sunshine Duration", "s")
      _ => ()
    }
  }
  if discipline == 0 && category == 7 {
    match parameter {
      6 => return ("Convective Available Potential Energy", "J/kg")
      7 => return ("Convective Inhibition", "J/kg")
      8 => return ("Storm Relative Helicity", "m^2/s^2")
      192 => return ("Surface Lifted Index", "K")
      193 => return ("Best (4 layer) Lifted Index", "K")
      _ => ()
    }
  }
  if discipline == 0 && category == 14 {
    match parameter {
      0 => return ("Total Ozone", "DU")
      192 => return ("Ozone Mixing Ratio", "kg/kg")
      _ => ()
    }
  }
  if discipline == 0 && category == 16 {
    match parameter {
      195 => return ("Reflectivity", "dB")
      196 => return ("Composite reflectivity", "dB")
      _ => ()
    }
  }
  if discipline == 0 && category == 19 {
    match parameter {
      0 => return ("Visibility", "m")
      _ => ()
    }
  }
  if discipline == 2 && category == 0 {
    match parameter {
      0 => return ("Land Cover (0=sea, 1=land)", "Proportion")
      1 => return ("Surface Roughness", "m")
      2 => return ("Soil Temperature", "K")
      4 => return ("Vegetation", "%")
      192 => return ("Volumetric Soil Moisture Content", "Fraction")
      196 => return ("Plant Canopy Surface Water", "kg/m^2")
      201 => return ("Wilting Point", "Fraction")
      _ => ()
    }
  }
  if discipline == 2 && category == 3 {
    match parameter {
      0 => return ("Soil Type", "-")
      192 =>
        return ("Liquid Volumetric Soil Moisture (non Frozen)", "Proportion")
      203 => return ("Field Capacity", "Fraction")
      _ => ()
    }
  }
  if discipline == 2 && category == 4 {
    match parameter {
      2 => return ("Haines Index", "Numeric")
      _ => ()
    }
  }
  if discipline == 10 && category == 0 {
    match parameter {
      3 => return ("Significant Height of Combined Wind Waves and Swell", "m")
      4 => return ("Direction of Wind Waves", "deg")
      5 => return ("Significant Height of Wind Waves", "m")
      6 => return ("Mean Period of Wind Waves", "s")
      7 => return ("Direction of Swell Waves", "deg")
      8 => return ("Significant Height of Swell Waves", "m")
      9 => return ("Mean Period of Swell Waves", "s")
      10 => return ("Primary Wave Direction", "deg")
      11 => return ("Primary Wave Mean Period", "s")
      _ => ()
    }
  }
  if discipline == 10 && category == 2 {
    match parameter {
      0 => return ("Ice Cover", "Proportion")
      1 => return ("Ice Thickness", "m")
      6 => return ("Ice Growth Rate", "m/s")
      8 => return ("Ice Temperature", "K")
      _ => ()
    }
  }
  fallback
}

///|
fn write_gribtable_used_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let records = @decode.decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    if !record_is_selected(meta.record_index, selected) {
      continue
    }
    let name = name_lookup_text(meta.parameter_name)
    let (desc, units) = gribtable_used_desc_units(
      meta.discipline,
      meta.section4_parameter_category,
      meta.section4_parameter_number,
      name,
    )
    lines.push(
      meta.discipline.to_string() +
      ":" +
      gribtable_used_master_table_set(
        meta.discipline,
        meta.section4_parameter_category,
        meta.section4_parameter_number,
      ).to_string() +
      ":" +
      "0:255:" +
      meta.section1_center.to_string() +
      ":" +
      meta.section1_local_tables_version.to_string() +
      ":" +
      meta.section4_parameter_category.to_string() +
      ":" +
      meta.section4_parameter_number.to_string() +
      ":" +
      name +
      ":" +
      desc +
      ":" +
      units,
    )
  }
  let content = lines.join("\n") + "\n"
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
