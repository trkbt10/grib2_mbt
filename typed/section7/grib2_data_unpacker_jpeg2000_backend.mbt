///|
/// JPEG2000 backend bridge:
/// - External package (`trkbt10/jpeg2000`) is used for validation checks.
/// - It also exposes an explicit verification decode bridge for Template 5.40.
/// - Default production path remains the legacy in-package implementation.

///|
fn is_raw_j2k_codestream(data : Bytes) -> Bool {
  data.length() >= 2 &&
  data[0].to_uint().reinterpret_as_int() == 0xFF &&
  data[1].to_uint().reinterpret_as_int() == 0x4F
}

///|
fn bytes_to_int_array(data : Bytes) -> Array[Int] {
  let out : Array[Int] = []
  for b in data {
    out.push(b.to_uint().reinterpret_as_int())
  }
  out
}

///|
fn external_sample_bytes_per_value(
  bits_per_value : Int,
) -> Result[Int, UnpackError] {
  if bits_per_value <= 0 || bits_per_value > 32 {
    return Err(
      InvalidBitsPerValue(
        "external jpeg2000 bits_per_value must be in 1..32, got \{bits_per_value}",
      ),
    )
  }
  Ok((bits_per_value + 7) / 8)
}

///|
fn decode_external_sample_value_le(
  data : Bytes,
  offset : Int,
  byte_count : Int,
  is_signed : Bool,
) -> Result[Int, UnpackError] {
  if byte_count <= 0 || byte_count > 4 {
    return Err(
      InvalidBitsPerValue(
        "external jpeg2000 byte_count must be in 1..4, got \{byte_count}",
      ),
    )
  }
  if offset < 0 || offset + byte_count > data.length() {
    return Err(
      InsufficientData(
        "external jpeg2000 sample read out of bounds: offset=\{offset}, bytes=\{byte_count}, len=\{data.length()}",
      ),
    )
  }
  let mut value = 0
  for i in 0..<(byte_count - 1) {
    value = value | (data[offset + i].to_uint().reinterpret_as_int() << (8 * i))
  }
  let top_raw = data[offset + byte_count - 1].to_uint().reinterpret_as_int()
  let top = if is_signed && top_raw >= 0x80 { top_raw - 0x100 } else { top_raw }
  Ok(value | (top << (8 * (byte_count - 1))))
}

///|
fn decode_external_sample_values(
  decoded : @jpeg2000.DecodeSamplesResult,
  num_points : Int,
) -> Result[Array[Int], UnpackError] {
  let byte_count = match
    external_sample_bytes_per_value(decoded.bits_per_component) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if decoded.width <= 0 || decoded.height <= 0 {
    return Err(
      UnsupportedTemplate(
        "external jpeg2000 decode reported non-positive dimensions: \{decoded.width}x\{decoded.height}",
      ),
    )
  }
  let coded_points = decoded.width * decoded.height
  if coded_points != num_points {
    return Err(
      InsufficientData(
        "external jpeg2000 point count mismatch: decoded=\{coded_points}, template points=\{num_points}",
      ),
    )
  }
  let expected_bytes = coded_points * byte_count
  if decoded.samples.length() != expected_bytes {
    return Err(
      InsufficientData(
        "external jpeg2000 sample byte length mismatch: expected=\{expected_bytes}, actual=\{decoded.samples.length()}",
      ),
    )
  }
  let values : Array[Int] = []
  let mut offset = 0
  for _ in 0..<coded_points {
    let value = match
      decode_external_sample_value_le(
        decoded.samples,
        offset,
        byte_count,
        decoded.is_signed,
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    values.push(value)
    offset += byte_count
  }
  Ok(values)
}

///|
pub fn validate_jpeg2000_with_external_package(
  data : Bytes,
) -> Result[Unit, UnpackError] {
  // Raw codestreams can be parsed directly; JP2-wrapped input is handled by
  // the decoder bridge below, so validation remains codestream-oriented here.
  if !is_raw_j2k_codestream(data) {
    return Ok(())
  }
  let parsed = @jpeg2000.parse_codestream(bytes_to_int_array(data))
  match parsed {
    Ok(_) => Ok(())
    Err(msg) =>
      Err(
        UnsupportedTemplate(
          "external jpeg2000 parser rejected codestream: \{msg}",
        ),
      )
  }
}

///|
pub fn unpack_jpeg2000_with_external_package(
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate540,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  if num_points < 0 {
    return Err(UnsupportedTemplate("num_points must be >= 0"))
  }
  let decoded = match @jpeg2000.decode_samples(data) {
    Ok(v) => v
    Err(msg) =>
      return Err(UnsupportedTemplate("external jpeg2000 decode failed: \{msg}"))
  }
  if !decoded.sample_layout.has_prefix("component0:raster:le:") {
    return Err(
      UnsupportedTemplate(
        "external jpeg2000 sample layout is unsupported for GRIB2 bridge: \{decoded.sample_layout}",
      ),
    )
  }
  if decoded.bits_per_component != template.bits_per_value {
    return Err(
      UnsupportedTemplate(
        "external jpeg2000 bit depth mismatch: decoded=\{decoded.bits_per_component}, template=\{template.bits_per_value}",
      ),
    )
  }
  let scaled_samples = match
    decode_external_sample_values(decoded, num_points) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let ref_value = ieee754_single_to_double(template.reference_value_ieee)
  let binary_scale = jpeg2000_pow2(u16_to_i16(template.binary_scale_factor))
  let decimal_scale = jpeg2000_pow10(u16_to_i16(template.decimal_scale_factor))
  let values : Array[Double] = []
  for sample in scaled_samples {
    values.push((ref_value + sample.to_double() * binary_scale) / decimal_scale)
  }
  Ok({ values, num_points })
}

///|
pub fn unpack_jpeg2000(
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate540,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  unpack_jpeg2000_legacy_impl(data, template, num_points)
}
