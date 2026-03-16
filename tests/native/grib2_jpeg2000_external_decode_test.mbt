///|
fn format_section7_unpack_error(error : @section7.UnpackError) -> String {
  match error {
    @section7.UnpackError::UnsupportedTemplate(msg) =>
      "UnsupportedTemplate: " + msg
    @section7.UnpackError::InsufficientData(msg) => "InsufficientData: " + msg
    @section7.UnpackError::InvalidBitsPerValue(msg) =>
      "InvalidBitsPerValue: " + msg
  }
}

///|
fn unpack_jpeg2000_submessage_with_public_api(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
) -> Result[@section7.UnpackedGridData, String] {
  let section5_decoded = match
    @lib.decode_submessage_section5(message, submessage) {
    Ok(v) => v
    Err(error) => return Err("failed to decode Section 5: \{error}")
  }
  let raw_data = match @lib.get_submessage_raw_data(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        "failed to extract Section 7 raw data: " +
        format_section7_unpack_error(error),
      )
  }
  match section5_decoded.template {
    @section5.DataRepresentationTemplate540(template540) =>
      match
        @section7.unpack_jpeg2000(
          raw_data,
          template540,
          section5_decoded.number_of_data_points,
        ) {
        Ok(v) => Ok(v)
        Err(error) =>
          Err(
            "public jpeg2000 unpack failed: " +
            format_section7_unpack_error(error),
          )
      }
    _ => Err("submessage is not JPEG2000 template 5.40")
  }
}

///|
fn assert_fixture_jpeg2000_public_paths_succeed(
  path : String,
) -> Result[Unit, String] {
  let parsed = match decode_fixture_context(path) {
    Ok(context) => context
    Err(error) => return Err(error)
  }
  let mut checked = 0
  for message_index in 0..<parsed.messages.length() {
    let message = parsed.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      let section5_decoded = match
        @lib.decode_submessage_section5(message, submessage) {
        Ok(v) => v
        Err(error) =>
          return Err(
            "failed to decode Section 5 for message \{message_index} submessage \{submessage_index}: \{error}",
          )
      }
      match section5_decoded.template {
        @section5.DataRepresentationTemplate540(_) => {
          let low_level = match
            unpack_jpeg2000_submessage_with_public_api(message, submessage) {
            Ok(v) => v
            Err(error) =>
              return Err(
                "\{path} m\{message_index} s\{submessage_index} low-level jpeg2000 unpack failed: \{error}",
              )
          }
          if low_level.num_points <= 0 {
            return Err(
              "\{path} m\{message_index} s\{submessage_index} low-level jpeg2000 unpack returned non-positive num_points",
            )
          }
          if low_level.values.length() != low_level.num_points {
            return Err(
              "\{path} m\{message_index} s\{submessage_index} low-level value length mismatch: len=\{low_level.values.length()} num_points=\{low_level.num_points}",
            )
          }
          let expanded = match
            @lib.unpack_submessage_data(message, submessage) {
            Ok(v) => v
            Err(error) =>
              return Err(
                "\{path} m\{message_index} s\{submessage_index} high-level unpack failed: \{format_section7_unpack_error(error)}",
              )
          }
          if expanded.num_points <= 0 {
            return Err(
              "\{path} m\{message_index} s\{submessage_index} high-level unpack returned non-positive num_points",
            )
          }
          if expanded.values.length() != expanded.num_points {
            return Err(
              "\{path} m\{message_index} s\{submessage_index} high-level value length mismatch: len=\{expanded.values.length()} num_points=\{expanded.num_points}",
            )
          }
          checked += 1
        }
        _ => ()
      }
    }
  }
  if checked <= 0 {
    return Err("no JPEG2000 submessages found in fixture: " + path)
  }
  Ok(())
}

///|
test "jpeg2000 public paths decode eccodes fixture" {
  match
    assert_fixture_jpeg2000_public_paths_succeed(
      @grib2support.grib2_fixture_path_eccodes_jpeg(),
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "jpeg2000 public paths decode reduced gaussian fixture" {
  match
    assert_fixture_jpeg2000_public_paths_succeed(
      @grib2support.grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg(),
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}
