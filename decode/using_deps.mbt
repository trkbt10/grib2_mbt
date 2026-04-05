///|
using @context {
  type Grib2ParseError,
  type Grib2SectionFrame,
  type Grib2SubmessageFrame,
  type Grib2MessageContext,
  type Grib2FileContext,
}

///|
using @core {
  binary_read_u8_as_int,
  binary_read_u32_be_uint,
  binary_read_u16_be,
  binary_read_u16_be_view,
  binary_read_u32_be_view,
  binary_has_magic_at,
  binary_has_magic_tail,
  parse_grib2_file,
  pad_zero,
  hex_byte,
  is_leap_year,
  days_in_month,
  datetime_to_unix,
}
