///|
/// PNG Data Unpacker (Template 5.41)
///
/// This decoder targets the GRIB2 PNG profile used by Template 5.41:
/// - Grayscale images (color type 0), plus RGB/RGBA for 24/32-bit fields
/// - Non-interlaced
/// - Bit depth 1/2/4/8/16 (grayscale), 8 (RGB/RGBA)
/// - zlib-compressed IDAT payload

///|
fn png_read_u32_be(data : Bytes, offset : Int) -> Int {
  let b0 = data[offset].to_uint().reinterpret_as_int()
  let b1 = data[offset + 1].to_uint().reinterpret_as_int()
  let b2 = data[offset + 2].to_uint().reinterpret_as_int()
  let b3 = data[offset + 3].to_uint().reinterpret_as_int()
  (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
}

///|
fn png_signature_ok(data : Bytes) -> Bool {
  if data.length() < 8 {
    return false
  }
  data[0] == b'\x89' &&
  data[1] == b'P' &&
  data[2] == b'N' &&
  data[3] == b'G' &&
  data[4] == b'\r' &&
  data[5] == b'\n' &&
  data[6] == b'\x1A' &&
  data[7] == b'\n'
}

///|
fn paeth_predictor(a : Int, b : Int, c : Int) -> Int {
  let p = a + b - c
  let pa = if p > a { p - a } else { a - p }
  let pb = if p > b { p - b } else { b - p }
  let pc = if p > c { p - c } else { c - p }
  if pa <= pb && pa <= pc {
    a
  } else if pb <= pc {
    b
  } else {
    c
  }
}

///|
fn unfilter_scanline(
  filter_type : Int,
  raw : Array[Byte],
  prev : Array[Byte],
  bytes_per_pixel : Int,
) -> Result[Array[Byte], UnpackError] {
  let out = [..raw]
  let row_len = out.length()
  match filter_type {
    0 => Ok(out)
    1 => {
      for i = 0; i < row_len; i = i + 1 {
        let left = if i >= bytes_per_pixel {
          out[i - bytes_per_pixel].to_uint().reinterpret_as_int()
        } else {
          0
        }
        let value = out[i].to_uint().reinterpret_as_int()
        out[i] = ((value + left) & 0xFF).to_byte()
      }
      Ok(out)
    }
    2 => {
      for i = 0; i < row_len; i = i + 1 {
        let up = if i < prev.length() {
          prev[i].to_uint().reinterpret_as_int()
        } else {
          0
        }
        let value = out[i].to_uint().reinterpret_as_int()
        out[i] = ((value + up) & 0xFF).to_byte()
      }
      Ok(out)
    }
    3 => {
      for i = 0; i < row_len; i = i + 1 {
        let left = if i >= bytes_per_pixel {
          out[i - bytes_per_pixel].to_uint().reinterpret_as_int()
        } else {
          0
        }
        let up = if i < prev.length() {
          prev[i].to_uint().reinterpret_as_int()
        } else {
          0
        }
        let value = out[i].to_uint().reinterpret_as_int()
        out[i] = ((value + (left + up) / 2) & 0xFF).to_byte()
      }
      Ok(out)
    }
    4 => {
      for i = 0; i < row_len; i = i + 1 {
        let left = if i >= bytes_per_pixel {
          out[i - bytes_per_pixel].to_uint().reinterpret_as_int()
        } else {
          0
        }
        let up = if i < prev.length() {
          prev[i].to_uint().reinterpret_as_int()
        } else {
          0
        }
        let up_left = if i >= bytes_per_pixel &&
          i - bytes_per_pixel < prev.length() {
          prev[i - bytes_per_pixel].to_uint().reinterpret_as_int()
        } else {
          0
        }
        let predictor = paeth_predictor(left, up, up_left)
        let value = out[i].to_uint().reinterpret_as_int()
        out[i] = ((value + predictor) & 0xFF).to_byte()
      }
      Ok(out)
    }
    _ =>
      Err(UnsupportedTemplate("PNG filter type not supported: \{filter_type}"))
  }
}

///|
fn decode_png_samples(data : Bytes) -> Result[Array[Int], UnpackError] {
  if !png_signature_ok(data) {
    return Err(UnsupportedTemplate("invalid PNG signature"))
  }
  let mut offset = 8
  let mut width = -1
  let mut height = -1
  let mut bit_depth = -1
  let mut color_type = -1
  let mut compression_method = -1
  let mut filter_method = -1
  let mut interlace_method = -1
  let mut seen_ihdr = false
  let mut seen_iend = false
  let idat : Array[Byte] = []
  while offset + 8 <= data.length() {
    let chunk_len = png_read_u32_be(data, offset)
    if chunk_len < 0 {
      return Err(UnsupportedTemplate("invalid PNG chunk length"))
    }
    offset += 4
    if offset + 4 > data.length() {
      return Err(InsufficientData("PNG chunk type is truncated"))
    }
    let chunk_type = data.sub(start=offset, end=offset + 4).to_bytes()
    offset += 4
    if offset + chunk_len + 4 > data.length() {
      return Err(InsufficientData("PNG chunk payload is truncated"))
    }
    let chunk_data = data.sub(start=offset, end=offset + chunk_len).to_bytes()
    offset += chunk_len
    // Skip CRC for now (4 bytes).
    offset += 4
    if chunk_type == b"IHDR" {
      if chunk_data.length() < 13 {
        return Err(InsufficientData("IHDR too short"))
      }
      seen_ihdr = true
      width = png_read_u32_be(chunk_data, 0)
      height = png_read_u32_be(chunk_data, 4)
      bit_depth = chunk_data[8].to_uint().reinterpret_as_int()
      color_type = chunk_data[9].to_uint().reinterpret_as_int()
      compression_method = chunk_data[10].to_uint().reinterpret_as_int()
      filter_method = chunk_data[11].to_uint().reinterpret_as_int()
      interlace_method = chunk_data[12].to_uint().reinterpret_as_int()
    } else if chunk_type == b"IDAT" {
      for b in chunk_data {
        idat.push(b)
      }
    } else if chunk_type == b"IEND" {
      seen_iend = true
      break
    } else {
      ()
    }
  }
  if !seen_ihdr {
    return Err(UnsupportedTemplate("PNG missing IHDR chunk"))
  }
  if !seen_iend {
    return Err(UnsupportedTemplate("PNG missing IEND chunk"))
  }
  if width <= 0 || height <= 0 {
    return Err(UnsupportedTemplate("PNG width/height must be positive"))
  }
  if !(color_type == 0 || color_type == 2 || color_type == 6) {
    return Err(
      UnsupportedTemplate(
        "PNG color type not supported for GRIB2: \{color_type}",
      ),
    )
  }
  if compression_method != 0 || filter_method != 0 || interlace_method != 0 {
    return Err(
      UnsupportedTemplate(
        "PNG compression/filter/interlace combination not supported",
      ),
    )
  }
  let bit_depth_ok = if color_type == 0 {
    bit_depth == 1 ||
    bit_depth == 2 ||
    bit_depth == 4 ||
    bit_depth == 8 ||
    bit_depth == 16
  } else {
    bit_depth == 8
  }
  if !bit_depth_ok {
    return Err(UnsupportedTemplate("PNG bit depth not supported: \{bit_depth}"))
  }
  if idat.length() == 0 {
    return Err(UnsupportedTemplate("PNG missing IDAT chunk"))
  }
  let input = @io.Buffer::from_bytes(Bytes::from_array(idat))
  let (zr, zerr) = @zlib.Reader::new(input)
  if zerr != None {
    return Err(UnsupportedTemplate("PNG zlib stream init failed"))
  }
  let (inflated, rerr) = @io.read_all(zr)
  let cerr = zr.close()
  if rerr != None || cerr != None {
    return Err(UnsupportedTemplate("PNG zlib stream decode failed"))
  }
  let inflated_bytes = inflated.to_bytes()
  let pixels = width * height
  let channels = if color_type == 0 {
    1
  } else if color_type == 2 {
    3
  } else {
    4
  }
  let row_bytes = (width * bit_depth * channels + 7) / 8
  let expected = height * (row_bytes + 1)
  if inflated_bytes.length() < expected {
    return Err(
      InsufficientData(
        "PNG scanline data too short: need \{expected}, got \{inflated_bytes.length()}",
      ),
    )
  }
  let bytes_per_sample = if bit_depth == 16 { 2 } else { 1 }
  let bytes_per_pixel = channels * bytes_per_sample
  let samples : Array[Int] = []
  let mut prev_row = Array::make(row_bytes, b'\x00')
  let mut in_offset = 0
  for _row = 0; _row < height; _row = _row + 1 {
    let filter_type = inflated_bytes[in_offset].to_uint().reinterpret_as_int()
    in_offset += 1
    let row_raw : Array[Byte] = []
    for i = 0; i < row_bytes; i = i + 1 {
      row_raw.push(inflated_bytes[in_offset + i])
    }
    in_offset += row_bytes
    let row = match
      unfilter_scanline(filter_type, row_raw, prev_row, bytes_per_pixel) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    prev_row = row
    if color_type == 0 {
      if bit_depth == 8 {
        for b in row {
          samples.push(b.to_uint().reinterpret_as_int())
        }
      } else if bit_depth == 16 {
        if row.length() % 2 != 0 {
          return Err(UnsupportedTemplate("invalid 16-bit PNG row length"))
        }
        let mut i = 0
        while i + 1 < row.length() {
          let hi = row[i].to_uint().reinterpret_as_int()
          let lo = row[i + 1].to_uint().reinterpret_as_int()
          samples.push((hi << 8) | lo)
          i += 2
        }
      } else if bit_depth == 4 {
        for b in row {
          let v = b.to_uint().reinterpret_as_int()
          samples.push((v >> 4) & 0x0F)
          samples.push(v & 0x0F)
        }
      } else if bit_depth == 2 {
        for b in row {
          let v = b.to_uint().reinterpret_as_int()
          samples.push((v >> 6) & 0x03)
          samples.push((v >> 4) & 0x03)
          samples.push((v >> 2) & 0x03)
          samples.push(v & 0x03)
        }
      } else {
        // bit_depth == 1
        for b in row {
          let v = b.to_uint().reinterpret_as_int()
          samples.push((v >> 7) & 0x01)
          samples.push((v >> 6) & 0x01)
          samples.push((v >> 5) & 0x01)
          samples.push((v >> 4) & 0x01)
          samples.push((v >> 3) & 0x01)
          samples.push((v >> 2) & 0x01)
          samples.push((v >> 1) & 0x01)
          samples.push(v & 0x01)
        }
      }
    } else if color_type == 2 {
      if row.length() % 3 != 0 {
        return Err(UnsupportedTemplate("invalid RGB PNG row length"))
      }
      let mut i = 0
      while i + 2 < row.length() {
        let r = row[i].to_uint().reinterpret_as_int()
        let g = row[i + 1].to_uint().reinterpret_as_int()
        let b = row[i + 2].to_uint().reinterpret_as_int()
        samples.push((r << 16) | (g << 8) | b)
        i += 3
      }
    } else {
      if row.length() % 4 != 0 {
        return Err(UnsupportedTemplate("invalid RGBA PNG row length"))
      }
      let mut i = 0
      while i + 3 < row.length() {
        let r = row[i].to_uint().reinterpret_as_int()
        let g = row[i + 1].to_uint().reinterpret_as_int()
        let b = row[i + 2].to_uint().reinterpret_as_int()
        let a = row[i + 3].to_uint().reinterpret_as_int()
        samples.push((r << 24) | (g << 16) | (b << 8) | a)
        i += 4
      }
    }
  }
  if samples.length() < pixels {
    return Err(
      InsufficientData(
        "decoded PNG samples too short: need \{pixels}, got \{samples.length()}",
      ),
    )
  }
  // Trim packed tail bits in the final row for bit_depth < 8.
  if samples.length() > pixels {
    let trimmed : Array[Int] = []
    for i = 0; i < pixels; i = i + 1 {
      trimmed.push(samples[i])
    }
    Ok(trimmed)
  } else {
    Ok(samples)
  }
}

///|
fn png_pow2(n : Int) -> Double {
  if n >= 0 {
    let mut result = 1.0
    for _i = 0; _i < n; _i = _i + 1 {
      result = result * 2.0
    }
    result
  } else {
    let mut result = 1.0
    for _i = 0; _i < -n; _i = _i + 1 {
      result = result / 2.0
    }
    result
  }
}

///|
fn png_pow10(n : Int) -> Double {
  if n >= 0 {
    let mut result = 1.0
    for _i = 0; _i < n; _i = _i + 1 {
      result = result * 10.0
    }
    result
  } else {
    let mut result = 1.0
    for _i = 0; _i < -n; _i = _i + 1 {
      result = result / 10.0
    }
    result
  }
}

///|
/// Unpack PNG compressed data (Template 5.41).
pub fn unpack_png(
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate541,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  if num_points < 0 {
    return Err(UnsupportedTemplate("num_points must be >= 0"))
  }
  let samples = match decode_png_samples(data) {
    Ok(values) => values
    Err(e) => return Err(e)
  }
  if samples.length() != num_points {
    return Err(
      InsufficientData(
        "decoded PNG samples mismatch: expected \{num_points}, got \{samples.length()}",
      ),
    )
  }
  if template.bits_per_value < 1 || template.bits_per_value > 32 {
    return Err(
      InvalidBitsPerValue(
        "template 5.41 bits_per_value out of range: \{template.bits_per_value}",
      ),
    )
  }
  let ref_value = ieee754_single_to_double(template.reference_value_ieee)
  let binary_scale = png_pow2(u16_to_i16(template.binary_scale_factor))
  let decimal_scale = png_pow10(u16_to_i16(template.decimal_scale_factor))
  let values : Array[Double] = []
  for sample in samples {
    values.push(ref_value + sample.to_double() * binary_scale / decimal_scale)
  }
  Ok({ values, num_points })
}

///|
/// Get raw PNG bytes for external decoding.
pub fn get_png_raw_bytes(data : Bytes) -> Bytes {
  data
}

///|
test "unpack_png invalid signature" {
  let template : @section5.Grib2DataRepresentationTemplate541 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_png(b"not-png", template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_png 1x1 grayscale" {
  let png_data = b"\x89PNG\r\n\x1A\n\x00\x00\x00\x0DIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x00\x00\x00\x00\x3A\x7E\x9BU\x00\x00\x00\x0AIDATx\x9Cc`\x07\x00\x00\x09\x00\x08\x20\x23\xC3\x8C\x00\x00\x00\x00IEND\xAE\x42\x60\x82"
  let template : @section5.Grib2DataRepresentationTemplate541 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    reserved_tail: Bytes::new(0),
  }
  let result = unpack_png(png_data, template, 1)
  match result {
    Ok(grid) => {
      inspect(grid.num_points, content="1")
      inspect(grid.values[0], content="7")
    }
    Err(_) => fail("unexpected error")
  }
}
