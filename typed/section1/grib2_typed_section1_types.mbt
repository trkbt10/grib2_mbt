///|
pub(all) suberror Grib2SectionCodecError {
  InvalidSectionLength(String)
  InvalidSectionNumber(String)
  UnsupportedTemplate(String)
} derive(Show)

///|
pub(all) enum Grib2IdTemplate {
  IdTemplateNone
  IdTemplate10(Int)
  IdTemplate11(Int)
  IdTemplate12(Int, Int)
  IdTemplateUnknown(Bytes)
} derive(Show)

///|
pub(all) struct Grib2Section1Decoded {
  center : Int
  subcenter : Int
  master_table_version : Int
  local_table_version : Int
  significance_of_reference_time : Int
  reference_year : Int
  reference_month : Int
  reference_day : Int
  reference_hour : Int
  reference_minute : Int
  reference_second : Int
  production_status : Int
  processed_data_type : Int
  identification_template : Grib2IdTemplate
  reserved_octets_22_23 : Bytes
  reserved_tail : Bytes
}

///|
pub(all) struct Grib2U64Be {
  high : Int
  low : Int
} derive(Show)
