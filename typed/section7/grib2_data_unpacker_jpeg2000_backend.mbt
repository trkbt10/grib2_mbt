///|
/// JPEG2000 backend bridge:
/// - External package (`trkbt10/jpeg2000`) is used for validation checks.
/// - The default public unpack path uses the external package for Template 5.40.
/// - Template 5.41 remains a small compatibility stub because GRIB2 defines it as PNG.

///|
fn jpeg2000_pow2(n : Int) -> Double {
  if n >= 0 {
    let mut result = 1.0
    for i = 0; i < n; i = i + 1 {
      result = result * 2.0
    }
    result
  } else {
    let mut result = 1.0
    for i = 0; i < -n; i = i + 1 {
      result = result / 2.0
    }
    result
  }
}

///|
fn jpeg2000_pow10(n : Int) -> Double {
  if n >= 0 {
    let mut result = 1.0
    for i = 0; i < n; i = i + 1 {
      result = result * 10.0
    }
    result
  } else {
    let mut result = 1.0
    for i = 0; i < -n; i = i + 1 {
      result = result / 10.0
    }
    result
  }
}

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
fn external_sample_top_byte_mask(bits_per_value : Int, byte_count : Int) -> Int {
  let used_top_bits = bits_per_value - (byte_count - 1) * 8
  if used_top_bits >= 8 {
    0xFF
  } else {
    (1 << used_top_bits) - 1
  }
}

///|
fn decode_external_sample_value_le(
  data : Bytes,
  offset : Int,
  bits_per_value : Int,
  is_signed : Bool,
) -> Result[Int, UnpackError] {
  let byte_count = match external_sample_bytes_per_value(bits_per_value) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
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
  let top_mask = external_sample_top_byte_mask(bits_per_value, byte_count)
  let top = data[offset + byte_count - 1].to_uint().reinterpret_as_int() &
    top_mask
  value = value | (top << (8 * (byte_count - 1)))
  if is_signed && bits_per_value < 32 {
    let shift = 32 - bits_per_value
    return Ok(value << shift >> shift)
  }
  Ok(value)
}

///|
fn decode_and_scale_external_sample_values(
  decoded : @jpeg2000.DecodeSamplesResult,
  template : @section5.Grib2DataRepresentationTemplate540,
  num_points : Int,
) -> Result[Array[Double], UnpackError] {
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
  let ref_value = ieee754_single_to_double(template.reference_value_ieee)
  let binary_scale = jpeg2000_pow2(u16_to_i16(template.binary_scale_factor))
  let decimal_scale = jpeg2000_pow10(u16_to_i16(template.decimal_scale_factor))
  let values : Array[Double] = []
  let mut offset = 0
  for _ in 0..<coded_points {
    let value = match
      decode_external_sample_value_le(
        decoded.samples,
        offset,
        decoded.bits_per_component,
        decoded.is_signed,
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    values.push((ref_value + value.to_double() * binary_scale) / decimal_scale)
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
  let values = match
    decode_and_scale_external_sample_values(decoded, template, num_points) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok({ values, num_points })
}

///|
pub fn unpack_jpeg2000(
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate540,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  unpack_jpeg2000_with_external_package(data, template, num_points)
}

///|
/// Template 5.41 is PNG in GRIB2 and should use `unpack_png`.
pub fn unpack_jpeg2000_differencing(
  _data : Bytes,
  _template : @section5.Grib2DataRepresentationTemplate541,
  _num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  Err(UnsupportedTemplate("Template 5.41 is PNG. Use unpack_png()."))
}
