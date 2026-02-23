///|
/// High-level data expansion functions.
/// Combines Section 5 (Data Representation) and Section 7 (Data)
/// to unpack grid data values.

///| Re-export from @typed for local use
pub using @typed {
  type UnpackedGridData,
  type UnpackError,
  unpack_simple,
}

///|
/// Unpack grid data from a submessage using Section 5 and Section 7.
///
/// This function decodes both sections and applies the appropriate
/// unpacking algorithm based on the Data Representation Template.
///
/// Supported templates:
/// - Template 5.0 (Simple Packing) - fully supported
/// - Template 5.40/5.41 (JPEG2000) - returns error, use JS-side decoder
/// - Template 5.4 (PNG) - returns error, use JS-side decoder
pub fn unpack_submessage_data(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame
) -> Result[@typed.UnpackedGridData, @typed.UnpackError] {
  // Decode Section 5
  let section5 = match decode_submessage_section5(message, submessage) {
    Ok(s5) => s5
    Err(e) => return Err(UnsupportedTemplate("Failed to decode Section 5: \{e}"))
  }
  // Decode Section 7
  let section7 = match decode_submessage_section7(message, submessage) {
    Ok(s7) => s7
    Err(e) => return Err(UnsupportedTemplate("Failed to decode Section 7: \{e}"))
  }
  // Extract raw data bytes from Section 7
  let raw_data = extract_section7_raw_data(section7)
  // Dispatch based on Data Representation Template
  match section5.template {
    DataRepresentationTemplate50(t50) =>
      unpack_simple(
        raw_data,
        t50.reference_value_ieee,
        t50.binary_scale_factor,
        t50.decimal_scale_factor,
        t50.bits_per_value,
        section5.number_of_data_points,
      )
    DataRepresentationTemplate540(_) =>
      Err(
        UnsupportedTemplate(
          "JPEG2000 (Template 5.40) decoding requires JS-side decoder",
        ),
      )
    DataRepresentationTemplate541(_) =>
      Err(
        UnsupportedTemplate(
          "JPEG2000 (Template 5.41) decoding requires JS-side decoder",
        ),
      )
    DataRepresentationTemplate54(_) =>
      Err(UnsupportedTemplate("PNG (Template 5.4) decoding requires JS-side decoder"))
    DataRepresentationTemplate52(t52) =>
      Err(
        UnsupportedTemplate(
          "Complex Packing (Template 5.2) not yet implemented, groups=\{t52.number_of_groups}",
        ),
      )
    DataRepresentationTemplate53(t53) =>
      Err(
        UnsupportedTemplate(
          "Complex Packing with Spatial Differencing (Template 5.3) not yet implemented, order=\{t53.order_of_spatial_difference}",
        ),
      )
    DataRepresentationTemplateUnknown(num, _) =>
      Err(UnsupportedTemplate("Unknown Data Representation Template: \{num}"))
    _ =>
      Err(
        UnsupportedTemplate(
          "Data Representation Template not yet supported for unpacking",
        ),
      )
  }
}

///|
/// Extract raw data bytes from Section 7 template.
fn extract_section7_raw_data(section7 : Grib2Section7Decoded) -> Bytes {
  match section7.template {
    DataTemplate70(t) => t.data_values_raw
    DataTemplate71(t) => t.data_values_raw
    DataTemplate72(t) => t.data_values_raw
    DataTemplate73(t) => t.data_values_raw
    DataTemplate74(t) => t.data_values_raw
    DataTemplate740(t) => t.data_values_raw
    DataTemplate741(t) => t.data_values_raw
    DataTemplate742(t) => t.data_values_raw
    DataTemplate750(t) => t.data_values_raw
    DataTemplate751(t) => t.data_values_raw
    DataTemplate753(t) => t.data_values_raw
    DataTemplateUnknown(_, data) => data
  }
}

///|
/// Get raw packed data bytes for JS-side decoding.
/// Use this for JPEG2000/PNG data that requires external decoders.
pub fn get_submessage_raw_data(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame
) -> Result[Bytes, @typed.UnpackError] {
  match decode_submessage_section7(message, submessage) {
    Ok(s7) => Ok(extract_section7_raw_data(s7))
    Err(e) => Err(UnsupportedTemplate("Failed to decode Section 7: \{e}"))
  }
}

///|
/// Get data representation parameters for JS-side decoding.
/// Returns the Section 5 template data needed for external decoders.
pub fn get_submessage_data_representation(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame
) -> Result[Grib2Section5Decoded, @typed.UnpackError] {
  match decode_submessage_section5(message, submessage) {
    Ok(s5) => Ok(s5)
    Err(e) => Err(UnsupportedTemplate("Failed to decode Section 5: \{e}"))
  }
}
