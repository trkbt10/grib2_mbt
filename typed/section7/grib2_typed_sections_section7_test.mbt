///|
test "section7 template70 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate70({ data_values_raw: b"\x12\x34\x56\x78" }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 0) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate70(template70) =>
      inspect(template70.data_values_raw == b"\x12\x34\x56\x78", content="true")
    _ => fail("template7.0 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template71 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate71({ data_values_raw: b"\x9a\xbc\xde\xf0" }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 1) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate71(template71) =>
      inspect(template71.data_values_raw == b"\x9a\xbc\xde\xf0", content="true")
    _ => fail("template7.1 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template72 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate72({ data_values_raw: b"\x01\x23\x45\x67\x89" }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 2) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate72(template72) =>
      inspect(
        template72.data_values_raw == b"\x01\x23\x45\x67\x89",
        content="true",
      )
    _ => fail("template7.2 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template73 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate73({ data_values_raw: b"\xfe\xdc\xba\x98\x76\x54" }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 3) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate73(template73) =>
      inspect(
        template73.data_values_raw == b"\xfe\xdc\xba\x98\x76\x54",
        content="true",
      )
    _ => fail("template7.3 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template74 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate74({
      data_values_raw: b"\x10\x20\x30\x40\x50\x60\x70",
    }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 4) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate74(template74) =>
      inspect(
        template74.data_values_raw == b"\x10\x20\x30\x40\x50\x60\x70",
        content="true",
      )
    _ => fail("template7.4 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template740 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate740({ data_values_raw: b"\xff\x4f\xff\x51\x00\x2f" }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 40) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate740(template740) =>
      inspect(
        template740.data_values_raw == b"\xff\x4f\xff\x51\x00\x2f",
        content="true",
      )
    _ => fail("template7.40 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template741 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate741({
      data_values_raw: b"\x89\x50\x4e\x47\x0d\x0a\x1a\x0a",
    }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 41) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate741(template741) =>
      inspect(
        template741.data_values_raw == b"\x89\x50\x4e\x47\x0d\x0a\x1a\x0a",
        content="true",
      )
    _ => fail("template7.41 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template742 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate742({
      data_values_raw: b"\x1f\x8b\x08\x00\x00\x00\x00\x00",
    }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 42) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate742(template742) =>
      inspect(
        template742.data_values_raw == b"\x1f\x8b\x08\x00\x00\x00\x00\x00",
        content="true",
      )
    _ => fail("template7.42 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template750 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate750({ data_values_raw: b"\x00\x11\x22\x33\x44\x55" }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 50) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate750(template750) =>
      inspect(
        template750.data_values_raw == b"\x00\x11\x22\x33\x44\x55",
        content="true",
      )
    _ => fail("template7.50 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template751 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate751({ data_values_raw: b"\x66\x55\x44\x33\x22\x11" }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 51) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate751(template751) =>
      inspect(
        template751.data_values_raw == b"\x66\x55\x44\x33\x22\x11",
        content="true",
      )
    _ => fail("template7.51 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 template753 typed decode and encode roundtrip" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplate753({ data_values_raw: b"\xaa\xbb\xcc\xdd\xee\xff" }),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 53) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplate753(template753) =>
      inspect(
        template753.data_values_raw == b"\xaa\xbb\xcc\xdd\xee\xff",
        content="true",
      )
    _ => fail("template7.53 was not decoded")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section7 unknown template preserves raw payload" {
  let section7 : Grib2Section7Decoded = {
    template: DataTemplateUnknown(200, b"\xaa\xbb\xcc"),
  }
  let encoded = encode_section7_bytes(section7)
  let decoded = match decode_section7_bytes(encoded, 200) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    DataTemplateUnknown(template_number, raw) => {
      inspect(template_number, content="200")
      inspect(raw == b"\xaa\xbb\xcc", content="true")
    }
    _ => fail("unknown template was not preserved")
  }
  let reencoded = encode_section7_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
