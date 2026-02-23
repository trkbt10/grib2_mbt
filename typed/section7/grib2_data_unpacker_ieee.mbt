///|
/// IEEE Floating-Point Data unpacker (Template 5.4).
///
/// Template 5.4 stores values in Section 7 directly as IEEE floats.
/// Precision code (Table 5.7):
/// - 1: IEEE 32-bit
/// - 2: IEEE 64-bit
/// - 3: IEEE 128-bit (not implemented)

///|
fn ieee_read_u32_be(data : Bytes, offset : Int) -> Int {
  let b0 = data[offset].to_uint().reinterpret_as_int()
  let b1 = data[offset + 1].to_uint().reinterpret_as_int()
  let b2 = data[offset + 2].to_uint().reinterpret_as_int()
  let b3 = data[offset + 3].to_uint().reinterpret_as_int()
  (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
}

///|
fn ieee754_double_from_parts(
  sign : Int,
  exponent : Int,
  mantissa : Int64,
) -> Double {
  if exponent == 0 && mantissa == 0L {
    if sign == 1 {
      -0.0
    } else {
      0.0
    }
  } else if exponent == 0x7FF {
    if mantissa == 0L {
      if sign == 1 {
        -1.0 / 0.0
      } else {
        1.0 / 0.0
      }
    } else {
      0.0 / 0.0
    }
  } else if exponent == 0 {
    // Denormalized: (-1)^s * (mantissa / 2^52) * 2^-1022
    let frac = mantissa.to_double() / 4503599627370496.0
    let mut value = frac
    for _i = 0; _i < 1022; _i = _i + 1 {
      value = value / 2.0
    }
    if sign == 1 {
      -value
    } else {
      value
    }
  } else {
    // Normalized: (-1)^s * (1 + mantissa/2^52) * 2^(exponent-1023)
    let frac = 1.0 + mantissa.to_double() / 4503599627370496.0
    let exp = exponent - 1023
    let mut value = frac
    if exp >= 0 {
      for _i = 0; _i < exp; _i = _i + 1 {
        value = value * 2.0
      }
    } else {
      for _i = 0; _i < -exp; _i = _i + 1 {
        value = value / 2.0
      }
    }
    if sign == 1 {
      -value
    } else {
      value
    }
  }
}

///|
fn ieee754_double_to_double(hi : Int, lo : Int) -> Double {
  let sign = (hi >> 31) & 1
  let exponent = (hi >> 20) & 0x7FF
  let mant_hi = hi & 0xFFFFF
  let mantissa = (mant_hi.to_int64() << 32) | (lo.to_int64() & 0xFFFFFFFFL)
  ieee754_double_from_parts(sign, exponent, mantissa)
}

///|
/// Unpack IEEE floating-point data (Template 5.4).
pub fn unpack_ieee(
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate54,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  if num_points < 0 {
    return Err(UnsupportedTemplate("num_points must be >= 0"))
  }
  let precision = template.precision
  if precision == 1 {
    let required = num_points * 4
    if data.length() < required {
      return Err(
        InsufficientData(
          "IEEE32 payload too short: need \{required}, got \{data.length()}",
        ),
      )
    }
    let values : Array[Double] = []
    for i = 0; i < num_points; i = i + 1 {
      let bits = ieee_read_u32_be(data, i * 4)
      values.push(ieee754_single_to_double(bits))
    }
    Ok({ values, num_points })
  } else if precision == 2 {
    let required = num_points * 8
    if data.length() < required {
      return Err(
        InsufficientData(
          "IEEE64 payload too short: need \{required}, got \{data.length()}",
        ),
      )
    }
    let values : Array[Double] = []
    for i = 0; i < num_points; i = i + 1 {
      let off = i * 8
      let hi = ieee_read_u32_be(data, off)
      let lo = ieee_read_u32_be(data, off + 4)
      values.push(ieee754_double_to_double(hi, lo))
    }
    Ok({ values, num_points })
  } else if precision == 3 {
    Err(UnsupportedTemplate("IEEE128 precision is not yet supported"))
  } else {
    Err(UnsupportedTemplate("invalid IEEE precision code: \{precision}"))
  }
}

///|
test "unpack_ieee precision=1 basic values" {
  // 1.0, -2.5, 0.0
  let data = b"\x3F\x80\x00\x00\xC0\x20\x00\x00\x00\x00\x00\x00"
  let template : @section5.Grib2DataRepresentationTemplate54 = {
    precision: 1,
    reserved_tail: b"",
  }
  match unpack_ieee(data, template, 3) {
    Ok(grid) => {
      inspect(grid.values.length(), content="3")
      inspect(grid.values[0], content="1")
      inspect(grid.values[1], content="-2.5")
      inspect(grid.values[2], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "unpack_ieee precision=2 basic values" {
  // 1.0, -2.5 (IEEE64)
  let data = b"\x3F\xF0\x00\x00\x00\x00\x00\x00\xC0\x04\x00\x00\x00\x00\x00\x00"
  let template : @section5.Grib2DataRepresentationTemplate54 = {
    precision: 2,
    reserved_tail: b"",
  }
  match unpack_ieee(data, template, 2) {
    Ok(grid) => {
      inspect(grid.values.length(), content="2")
      inspect(grid.values[0], content="1")
      inspect(grid.values[1], content="-2.5")
    }
    Err(_) => fail("unexpected error")
  }
}
