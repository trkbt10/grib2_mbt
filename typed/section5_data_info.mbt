///|
/// Flattened Section 5 data-representation descriptor for JSON export. Reports
/// the packing template ID alongside the four scaling parameters that every
/// numeric template shares.
pub(all) struct Section5DataInfo {
  template_id : Int
  reference_value_ieee : Int
  binary_scale : Int
  decimal_scale : Int
  bits_per_value : Int
}

///|
/// Extract data representation info from Section 5 template data.
pub fn get_section5_data_info(
  template : @section5.Grib2Section5TemplateData,
) -> Section5DataInfo {
  match template {
    @section5.DataRepresentationTemplate50(t) =>
      {
        template_id: 0,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate51(t) =>
      {
        template_id: 1,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate52(t) =>
      {
        template_id: 2,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate53(t) =>
      {
        template_id: 3,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate540(t) =>
      {
        template_id: 40,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate541(t) =>
      {
        template_id: 41,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplateUnknown(id, _) =>
      {
        template_id: id,
        reference_value_ieee: -1,
        binary_scale: -1,
        decimal_scale: -1,
        bits_per_value: -1,
      }
    _ =>
      {
        template_id: -1,
        reference_value_ieee: -1,
        binary_scale: -1,
        decimal_scale: -1,
        bits_per_value: -1,
      }
  }
}
