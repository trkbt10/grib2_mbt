///|
/// High-level data expansion functions.
/// Combines Section 5 (Data Representation) and Section 7 (Data)
/// to unpack grid data values.

///|
/// Re-export from @typed for local use
pub using @typed {
  get_section3_grid_info,
  parse_scanning_mode,
  type UnpackedGridData,
  type UnpackError,
  unpack_ieee,
  unpack_simple,
  unpack_jpeg2000,
  unpack_png,
  unpack_complex,
  unpack_complex_spatial,
}

///|
/// Unpack grid data from a submessage using Section 5 and Section 7.
///
/// This function decodes both sections and applies the appropriate
/// unpacking algorithm based on the Data Representation Template.
///
/// Supported templates:
/// - Template 5.0 (Simple Packing) - fully supported
/// - Template 5.4 (IEEE floating point) - delegated to section7 unpacker
/// - Template 5.40 (JPEG2000) - delegated to section7 unpacker
/// - Template 5.41 (PNG) - delegated to section7 unpacker
pub fn unpack_submessage_data(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[@typed.UnpackedGridData, @typed.UnpackError] {
  // Decode Section 5
  let section5 = match decode_submessage_section5(message, submessage) {
    Ok(s5) => s5
    Err(e) =>
      return Err(UnsupportedTemplate("Failed to decode Section 5: \{e}"))
  }
  let raw_data = match
    extract_submessage_section7_raw_data(message, submessage) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  // Dispatch based on Data Representation Template
  let unpacked_defined = match section5.template {
    DataRepresentationTemplate50(t50) =>
      unpack_simple(
        raw_data,
        t50.reference_value_ieee,
        t50.binary_scale_factor,
        t50.decimal_scale_factor,
        t50.bits_per_value,
        section5.number_of_data_points,
      )
    DataRepresentationTemplate54(t54) =>
      unpack_ieee(raw_data, t54, section5.number_of_data_points)
    DataRepresentationTemplate540(t540) =>
      unpack_jpeg2000(raw_data, t540, section5.number_of_data_points)
    DataRepresentationTemplate541(t541) =>
      unpack_png(raw_data, t541, section5.number_of_data_points)
    DataRepresentationTemplate52(t52) =>
      unpack_complex(raw_data, t52, section5.number_of_data_points)
    DataRepresentationTemplate53(t53) =>
      unpack_complex_spatial(raw_data, t53, section5.number_of_data_points)
    DataRepresentationTemplateUnknown(num, _) =>
      Err(UnsupportedTemplate("Unknown Data Representation Template: \{num}"))
    _ =>
      Err(
        UnsupportedTemplate(
          "Data Representation Template not yet supported for unpacking",
        ),
      )
  }
  let unpacked_defined = match unpacked_defined {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let with_bitmap = match
    apply_bitmap_to_unpacked(message, submessage, unpacked_defined) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  normalize_unpacked_to_wgrib2_scan_order(message, submessage, with_bitmap)
}

///|
fn nan_value() -> Double {
  0.0 / 0.0
}

///|
fn apply_bitmap_to_unpacked(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
  unpacked_defined : @typed.UnpackedGridData,
) -> Result[@typed.UnpackedGridData, @typed.UnpackError] {
  let section6 = match decode_submessage_section6(message, submessage) {
    Ok(s6) => s6
    Err(e) =>
      return Err(UnsupportedTemplate("Failed to decode Section 6: \{e}"))
  }
  if section6.bitmap_indicator == 255 {
    return Ok(unpacked_defined)
  }
  if section6.bitmap_indicator != 0 {
    return Err(
      UnsupportedTemplate(
        "Bitmap indicator not supported for unpacking: \{section6.bitmap_indicator}",
      ),
    )
  }
  let section3 = match decode_submessage_section3(message, submessage) {
    Ok(s3) => s3
    Err(e) =>
      return Err(UnsupportedTemplate("Failed to decode Section 3: \{e}"))
  }
  let total_points = section3.number_of_data_points
  if total_points < 0 {
    return Err(
      UnsupportedTemplate("Section 3 number_of_data_points must be >= 0"),
    )
  }
  let values : Array[Double] = Array::make(total_points, nan_value())
  let mut source_index = 0
  for bit_index = 0; bit_index < total_points; bit_index = bit_index + 1 {
    let byte_index = bit_index / 8
    if byte_index >= section6.bitmap_raw.length() {
      return Err(
        InsufficientData(
          "bitmap payload too short: need bit \{bit_index}, have \{section6.bitmap_raw.length() * 8} bits",
        ),
      )
    }
    let bit_offset = 7 - bit_index % 8
    let mask = 1 << bit_offset
    let byte_val = section6.bitmap_raw[byte_index]
      .to_uint()
      .reinterpret_as_int()
    let defined = (byte_val & mask) != 0
    if defined {
      if source_index >= unpacked_defined.values.length() {
        return Err(
          InsufficientData(
            "defined data values shorter than bitmap ones: index \{source_index}",
          ),
        )
      }
      values[bit_index] = unpacked_defined.values[source_index]
      source_index += 1
    }
  }
  if source_index != unpacked_defined.values.length() {
    return Err(
      InsufficientData(
        "bitmap consumed \{source_index} values but unpacker produced \{unpacked_defined.values.length()}",
      ),
    )
  }
  Ok({ values, num_points: total_points })
}

///|
/// Normalize unpacked data ordering to wgrib2's WE:SN output convention.
fn normalize_unpacked_to_wgrib2_scan_order(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
  unpacked : @typed.UnpackedGridData,
) -> Result[@typed.UnpackedGridData, @typed.UnpackError] {
  let section3 = match decode_submessage_section3(message, submessage) {
    Ok(s3) => s3
    Err(e) =>
      return Err(UnsupportedTemplate("Failed to decode Section 3: \{e}"))
  }
  let grid_info = @typed.get_section3_grid_info(section3.template)
  let template_id = grid_info.template_id
  let nj = grid_info.nj
  let scan_mode = grid_info.scan_mode
  if nj <= 0 || scan_mode < 0 {
    return Ok(unpacked)
  }
  let scan = @typed.parse_scanning_mode(scan_mode)
  // Current normalization target covers common row-major grids.
  // Fallback to original order for less common scan permutations.
  if scan.consecutive_j || scan.alternating_rows {
    return Ok(unpacked)
  }
  if is_reduced_gaussian_template(template_id) {
    return Ok(
      normalize_reduced_gaussian_to_wgrib2_scan_order(
        section3, nj, scan, unpacked,
      ),
    )
  }
  let ni = grid_info.ni
  if ni <= 0 || ni * nj != unpacked.values.length() {
    return Ok(unpacked)
  }
  Ok(normalize_regular_grid_to_wgrib2_scan_order(ni, nj, scan, unpacked))
}

///|
fn is_reduced_gaussian_template(template_id : Int) -> Bool {
  template_id == 40 ||
  template_id == 41 ||
  template_id == 42 ||
  template_id == 43
}

///|
fn normalize_regular_grid_to_wgrib2_scan_order(
  ni : Int,
  nj : Int,
  scan : @typed.ScanningMode,
  unpacked : @typed.UnpackedGridData,
) -> @typed.UnpackedGridData {
  let reordered : Array[Double] = Array::make(unpacked.values.length(), 0.0)
  for j_out in 0..<nj {
    let j_in = if scan.j_positive { j_out } else { nj - 1 - j_out }
    for i_out in 0..<ni {
      let i_in = if scan.i_negative { ni - 1 - i_out } else { i_out }
      let dst = j_out * ni + i_out
      let src = j_in * ni + i_in
      reordered[dst] = unpacked.values[src]
    }
  }
  { values: reordered, num_points: unpacked.num_points }
}

///|
fn normalize_reduced_gaussian_to_wgrib2_scan_order(
  section3 : @typed.Grib2Section3Decoded,
  nj : Int,
  scan : @typed.ScanningMode,
  unpacked : @typed.UnpackedGridData,
) -> @typed.UnpackedGridData {
  let row_counts = match decode_reduced_gaussian_row_counts(section3, nj) {
    Some(v) => v
    None => return unpacked
  }
  let input_offsets = build_row_offsets(row_counts)
  let output_offsets : Array[Int] = Array::make(nj, 0)
  let mut output_total = 0
  for j_out in 0..<nj {
    output_offsets[j_out] = output_total
    let j_in = if scan.j_positive { j_out } else { nj - 1 - j_out }
    output_total += row_counts[j_in]
  }
  if output_total != unpacked.values.length() {
    return unpacked
  }
  let reordered : Array[Double] = Array::make(unpacked.values.length(), 0.0)
  for j_out in 0..<nj {
    let j_in = if scan.j_positive { j_out } else { nj - 1 - j_out }
    let row_count = row_counts[j_in]
    let src_start = input_offsets[j_in]
    let dst_start = output_offsets[j_out]
    for i_out in 0..<row_count {
      let i_in = if scan.i_negative { row_count - 1 - i_out } else { i_out }
      reordered[dst_start + i_out] = unpacked.values[src_start + i_in]
    }
  }
  { values: reordered, num_points: unpacked.num_points }
}

///|
fn decode_reduced_gaussian_row_counts(
  section3 : @typed.Grib2Section3Decoded,
  expected_rows : Int,
) -> Array[Int]? {
  let octets = section3.optional_points_octet_count
  if expected_rows <= 0 || octets <= 0 || octets > 4 {
    return None
  }
  if section3.optional_points_interpretation != 1 {
    return None
  }
  let raw = section3.optional_points_raw
  if raw.length() != expected_rows * octets {
    return None
  }
  let row_counts : Array[Int] = []
  for row in 0..<expected_rows {
    let mut value = 0
    let offset = row * octets
    for byte_index in 0..<octets {
      value = (value << 8) |
        raw[offset + byte_index].to_uint().reinterpret_as_int()
    }
    row_counts.push(value)
  }
  Some(row_counts)
}

///|
fn build_row_offsets(row_counts : Array[Int]) -> Array[Int] {
  let offsets : Array[Int] = Array::make(row_counts.length(), 0)
  let mut offset = 0
  for index in 0..<row_counts.length() {
    offsets[index] = offset
    offset += row_counts[index]
  }
  offsets
}

///|
fn extract_submessage_section7_raw_data(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Bytes, @typed.UnpackError] {
  let frame = submessage.section7
  if frame.section_number != 7 {
    return Err(
      UnsupportedTemplate(
        "Expected Section 7 frame, got section \{frame.section_number}",
      ),
    )
  }
  if frame.length < 5 {
    return Err(InsufficientData("Section 7 too short: \{frame.length} bytes"))
  }
  let start = frame.start - message.offset + 5
  let end = frame.end_offset() - message.offset
  if start < 0 || end < start || end > message.raw.length() {
    return Err(
      InsufficientData(
        "Section 7 payload slice out of bounds: start=\{start}, end=\{end}, message_len=\{message.raw.length()}",
      ),
    )
  }
  Ok(message.raw.sub(start~, end~).to_bytes())
}

///|
/// Get raw packed data bytes for JS-side decoding.
/// Use this for JPEG2000/PNG data that requires external decoders.
pub fn get_submessage_raw_data(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Bytes, @typed.UnpackError] {
  extract_submessage_section7_raw_data(message, submessage)
}

///|
/// Get data representation parameters for JS-side decoding.
/// Returns the Section 5 template data needed for external decoders.
pub fn get_submessage_data_representation(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
) -> Result[Grib2Section5Decoded, @typed.UnpackError] {
  match decode_submessage_section5(message, submessage) {
    Ok(s5) => Ok(s5)
    Err(e) => Err(UnsupportedTemplate("Failed to decode Section 5: \{e}"))
  }
}
