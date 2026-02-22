///|
pub(all) struct Grib2DataTemplate70 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate71 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate72 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate73 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate74 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate740 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate741 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate742 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate750 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate751 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) struct Grib2DataTemplate753 {
  data_values_raw : Bytes
} derive(Show)

///|
pub(all) enum Grib2Section7TemplateData {
  DataTemplate70(Grib2DataTemplate70)
  DataTemplate71(Grib2DataTemplate71)
  DataTemplate72(Grib2DataTemplate72)
  DataTemplate73(Grib2DataTemplate73)
  DataTemplate74(Grib2DataTemplate74)
  DataTemplate740(Grib2DataTemplate740)
  DataTemplate741(Grib2DataTemplate741)
  DataTemplate742(Grib2DataTemplate742)
  DataTemplate750(Grib2DataTemplate750)
  DataTemplate751(Grib2DataTemplate751)
  DataTemplate753(Grib2DataTemplate753)
  DataTemplateUnknown(Int, Bytes)
} derive(Show)

///|
pub(all) struct Grib2Section7Decoded {
  template : Grib2Section7TemplateData
}
