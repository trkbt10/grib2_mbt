///|
fn typed_encode_section6_payload(section : Grib2Section6Decoded) -> Bytes {
  let out : Array[Byte] = [section.bitmap_indicator.to_byte()]
  for b in section.bitmap_raw {
    out.push(b)
  }
  Bytes::from_array(out)
}
