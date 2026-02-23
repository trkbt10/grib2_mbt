///|
/// JPEG2000 Data Unpacker Stub (Template 5.40)
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
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate540,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  if num_points < 0 {
    return Err(UnsupportedTemplate("num_points must be >= 0"))
  }
  let info = match parse_jpeg2000_codestream_info(data) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if info.siz.num_components != 1 {
    return Err(
      UnsupportedTemplate(
        "JPEG2000 with \{info.siz.num_components} components is not yet supported",
      ),
    )
  }
  if info.siz.bits_per_component != template.bits_per_value {
    return Err(
      UnsupportedTemplate(
        "JPEG2000 bit depth mismatch: codestream=\{info.siz.bits_per_component}, template=\{template.bits_per_value}",
      ),
    )
  }
  let coded_points = info.siz.width * info.siz.height
  if coded_points != num_points {
    return Err(
      InsufficientData(
        "JPEG2000 point count mismatch: codestream=\{coded_points}, template points=\{num_points}",
      ),
    )
  }
  Err(
    UnsupportedTemplate(
      "JPEG2000 codestream parsed, but Tier-1/Tier-2 and inverse wavelet reconstruction are not implemented yet.",
    ),
  )
}

///|
/// Legacy placeholder kept for API compatibility.
/// Template 5.41 is PNG in GRIB2 and should use `unpack_png`.
pub fn unpack_jpeg2000_differencing(
  _data : Bytes,
  _template : @section5.Grib2DataRepresentationTemplate541,
  _num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  Err(UnsupportedTemplate("Template 5.41 is PNG. Use unpack_png()."))
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
  template : @section5.Grib2DataRepresentationTemplate540,
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
    Err(_) => inspect(true, content="true")
    _ => fail("expected error")
  }
}
