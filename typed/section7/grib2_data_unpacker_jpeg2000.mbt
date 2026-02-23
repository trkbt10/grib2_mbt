///|
/// JPEG2000 Data Unpacker Stub (Template 5.40/5.41)
///
/// JPEG2000 decoding is not implemented in pure MoonBit.
/// Use this stub to get raw bytes for JS-side decoding with
/// external JPEG2000 libraries (e.g., OpenJPEG).

///|
/// Unpack JPEG2000 compressed data (Template 5.40).
/// This is a stub that returns an error directing users to use JS-side decoding.
///
/// For actual JPEG2000 decoding, extract the raw bytes using
/// `get_jpeg2000_raw_bytes` and decode using a JS library.
pub fn unpack_jpeg2000(
  _data : Bytes,
  _template : @section5.Grib2DataRepresentationTemplate540,
  _num_points : Int
) -> Result[UnpackedGridData, UnpackError] {
  Err(
    UnsupportedTemplate(
      "JPEG2000 decoding requires external decoder. Use get_jpeg2000_raw_bytes() to extract raw data for JS-side decoding.",
    ),
  )
}

///|
/// Unpack JPEG2000 compressed data with order-2 spatial differencing (Template 5.41).
/// This is a stub that returns an error directing users to use JS-side decoding.
pub fn unpack_jpeg2000_differencing(
  _data : Bytes,
  _template : @section5.Grib2DataRepresentationTemplate541,
  _num_points : Int
) -> Result[UnpackedGridData, UnpackError] {
  Err(
    UnsupportedTemplate(
      "JPEG2000 decoding requires external decoder. Use get_jpeg2000_raw_bytes() to extract raw data for JS-side decoding.",
    ),
  )
}

///|
/// Get raw JPEG2000 bytes for JS-side decoding.
/// The returned bytes can be passed to an external JPEG2000 decoder.
pub fn get_jpeg2000_raw_bytes(data : Bytes) -> Bytes {
  data
}

///|
/// Get JPEG2000 encoding parameters from template.
/// Returns (reference_value_ieee, binary_scale_factor, decimal_scale_factor, bits_per_value)
/// for post-processing after JPEG2000 decoding.
pub fn get_jpeg2000_params(
  template : @section5.Grib2DataRepresentationTemplate540
) -> (Int, Int, Int, Int) {
  (
    template.reference_value_ieee,
    template.binary_scale_factor,
    template.decimal_scale_factor,
    template.bits_per_value,
  )
}

///|
test "unpack_jpeg2000 returns stub error" {
  let empty_data = Bytes::new(0)
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 0,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(empty_data, template, 0) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}
