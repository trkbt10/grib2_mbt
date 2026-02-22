///|
test "section6 indicator 0 preserves bitmap bytes" {
  let section6 : Grib2Section6Decoded = {
    bitmap_indicator: 0,
    bitmap_raw: b"\x80\x00\xff",
  }
  let encoded = encode_section6_bytes(section6)
  let decoded = match decode_section6_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.bitmap_indicator, content="0")
  inspect(decoded.bitmap_raw == b"\x80\x00\xff", content="true")
  let reencoded = encode_section6_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section6 indicator 255 allows empty bitmap payload" {
  let section6 : Grib2Section6Decoded = {
    bitmap_indicator: 255,
    bitmap_raw: b"",
  }
  let encoded = encode_section6_bytes(section6)
  let decoded = match decode_section6_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.bitmap_indicator, content="255")
  inspect(decoded.bitmap_raw == b"", content="true")
  inspect(encoded.length(), content="6")
  let reencoded = encode_section6_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section6 nonzero indicator preserves trailing bytes" {
  let section6 : Grib2Section6Decoded = {
    bitmap_indicator: 200,
    bitmap_raw: b"\xaa\xbb",
  }
  let encoded = encode_section6_bytes(section6)
  let decoded = match decode_section6_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.bitmap_indicator, content="200")
  inspect(decoded.bitmap_raw == b"\xaa\xbb", content="true")
  let reencoded = encode_section6_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
