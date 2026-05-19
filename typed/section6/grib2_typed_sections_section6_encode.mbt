///|
fn typed_encode_section6_payload(section : Grib2Section6Decoded) -> Bytes {
  let out : Array[Byte] = [section.bitmap_indicator.to_byte()]
  @section1.typed_push_bytes(out, section.bitmap_raw)
  Bytes::from_array(out)
}
