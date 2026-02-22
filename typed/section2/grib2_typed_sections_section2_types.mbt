///|
pub(all) struct Grib2MdlTemplate21 {
  total_number_of_data_groups : Int
  number_of_values_in_first_group : Int
  reference_value_of_first_group_ieee : Int
  decimal_scale_factor : Int
  bits_per_value : Int
  first_group_data_type : Int
  first_group_packed_values_raw : Bytes
} derive(Show)

///|
pub(all) enum Grib2Section2TemplateData {
  MdlTemplate21(Grib2MdlTemplate21)
  LocalUseTemplateUnknown(Int, Bytes)
} derive(Show)

///|
pub(all) struct Grib2Section2Decoded {
  template : Grib2Section2TemplateData
}
