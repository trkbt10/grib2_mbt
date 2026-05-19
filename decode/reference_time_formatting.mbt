///|
/// Build the wgrib2 inventory ID string for a record. Compound IDs of the
/// form `<msg>.<sub>` are used whenever a single message owns several
/// submessages or when there are multiple records in a single message file;
/// otherwise the global record counter is shown as-is.
fn format_record_id(
  context : @context.Grib2FileContext,
  message_index : Int,
  submessage_index : Int,
  submessage_count : Int,
  global_index : Int,
) -> String {
  if submessage_count > 1 ||
    (context.message_count() == 1 && context.record_count() > 1) {
    message_index.to_string() + "." + submessage_index.to_string()
  } else {
    global_index.to_string()
  }
}

///|
/// Reference time formatted as `YYYYMMDDHH` (the wgrib2 `d=` field). Falls
/// back to a manual decode of section 1 if the typed decoder errors.
fn format_ref_time_yyyymmddhh(message : @context.Grib2MessageContext) -> String {
  match decode_message_section1(message) {
    Ok(section1) =>
      @core.pad_zero(section1.reference_year, 4) +
      @core.pad_zero(section1.reference_month, 2) +
      @core.pad_zero(section1.reference_day, 2) +
      @core.pad_zero(section1.reference_hour, 2)
    Err(_) => {
      let section1 = section_slice(message, message.section1)
      if section1.length() < 20 {
        return "0000000000"
      }
      let year = read_u16_be_from(section1, 12)
      let month = section1[14].to_uint().reinterpret_as_int()
      let day = section1[15].to_uint().reinterpret_as_int()
      let hour = section1[16].to_uint().reinterpret_as_int()
      @core.pad_zero(year, 4) + @core.pad_zero(month, 2) + @core.pad_zero(day, 2) + @core.pad_zero(hour, 2)
    }
  }
}

///|
/// Reference time formatted as `YYYYMMDDHHMMSS` (the wgrib2 `D=` field).
fn format_ref_time_yyyymmddhhmmss(message : @context.Grib2MessageContext) -> String {
  match decode_message_section1(message) {
    Ok(section1) =>
      @core.pad_zero(section1.reference_year, 4) +
      @core.pad_zero(section1.reference_month, 2) +
      @core.pad_zero(section1.reference_day, 2) +
      @core.pad_zero(section1.reference_hour, 2) +
      @core.pad_zero(section1.reference_minute, 2) +
      @core.pad_zero(section1.reference_second, 2)
    Err(_) => {
      let section1 = section_slice(message, message.section1)
      if section1.length() < 20 {
        return "00000000000000"
      }
      let year = read_u16_be_from(section1, 12)
      let month = section1[14].to_uint().reinterpret_as_int()
      let day = section1[15].to_uint().reinterpret_as_int()
      let hour = section1[16].to_uint().reinterpret_as_int()
      let minute = section1[17].to_uint().reinterpret_as_int()
      let second = section1[18].to_uint().reinterpret_as_int()
      @core.pad_zero(year, 4) +
      @core.pad_zero(month, 2) +
      @core.pad_zero(day, 2) +
      @core.pad_zero(hour, 2) +
      @core.pad_zero(minute, 2) +
      @core.pad_zero(second, 2)
    }
  }
}

///|
/// Reference time as a Unix epoch (`unix_rt` field). Same fallback strategy
/// as the formatted-string variants above.
fn compute_ref_time_unix(message : @context.Grib2MessageContext) -> Int64 {
  match decode_message_section1(message) {
    Ok(section1) =>
      @core.datetime_to_unix(
        section1.reference_year,
        section1.reference_month,
        section1.reference_day,
        section1.reference_hour,
        section1.reference_minute,
        section1.reference_second,
      )
    Err(_) => {
      let section1 = section_slice(message, message.section1)
      if section1.length() < 20 {
        return 0L
      }
      let year = read_u16_be_from(section1, 12)
      let month = section1[14].to_uint().reinterpret_as_int()
      let day = section1[15].to_uint().reinterpret_as_int()
      let hour = section1[16].to_uint().reinterpret_as_int()
      let minute = section1[17].to_uint().reinterpret_as_int()
      let second = section1[18].to_uint().reinterpret_as_int()
      @core.datetime_to_unix(year, month, day, hour, minute, second)
    }
  }
}
