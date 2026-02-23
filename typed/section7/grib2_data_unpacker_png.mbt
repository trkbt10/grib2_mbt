///|
/// PNG Data Unpacker Stub (Template 5.4)
///
/// PNG decoding is not implemented in pure MoonBit.
/// Use this stub to get raw bytes for JS-side decoding with
/// browser's native PNG decoding or external PNG libraries.

///|
/// Unpack PNG compressed data (Template 5.4).
/// This is a stub that returns an error directing users to use JS-side decoding.
///
/// For actual PNG decoding, extract the raw bytes using
/// `get_png_raw_bytes` and decode using a JS library or browser API.
pub fn unpack_png(
  _data : Bytes,
  _template : @section5.Grib2DataRepresentationTemplate54,
  _num_points : Int
) -> Result[UnpackedGridData, UnpackError] {
  Err(
    UnsupportedTemplate(
      "PNG decoding requires external decoder. Use get_png_raw_bytes() to extract raw data for JS-side decoding.",
    ),
  )
}

///|
/// Get raw PNG bytes for JS-side decoding.
/// The returned bytes can be passed to an external PNG decoder
/// (e.g., browser's Image API or pngjs library).
pub fn get_png_raw_bytes(data : Bytes) -> Bytes {
  data
}

///|
test "unpack_png returns stub error" {
  let empty_data = Bytes::new(0)
  let template : @section5.Grib2DataRepresentationTemplate54 = {
    precision: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_png(empty_data, template, 0) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}
