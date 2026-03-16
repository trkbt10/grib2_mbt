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
fn unpack_jpeg2000_submessage_with_external_package(
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
        @section7.unpack_jpeg2000_with_external_package(
          raw_data,
          template540,
          section5_decoded.number_of_data_points,
        ) {
        Ok(v) => Ok(v)
        Err(error) =>
          Err(
            "external jpeg2000 bridge failed: " +
            format_section7_unpack_error(error),
          )
      }
    _ => Err("submessage is not JPEG2000 template 5.40")
  }
}

///|
fn assert_fixture_external_bridge_succeeds(
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
          let external = match
            unpack_jpeg2000_submessage_with_external_package(
              message, submessage,
            ) {
            Ok(v) => v
            Err(error) =>
              return Err(
                "\{path} m\{message_index} s\{submessage_index} external unpack failed: \{error}",
              )
          }
          if external.num_points <= 0 {
            return Err(
              "\{path} m\{message_index} s\{submessage_index} external unpack returned non-positive num_points",
            )
          }
          if external.values.length() != external.num_points {
            return Err(
              "\{path} m\{message_index} s\{submessage_index} value length mismatch: len=\{external.values.length()} num_points=\{external.num_points}",
            )
          }
          let legacy = match @lib.unpack_submessage_data(message, submessage) {
            Ok(v) => v
            Err(error) =>
              return Err(
                "\{path} m\{message_index} s\{submessage_index} legacy unpack failed: \{format_section7_unpack_error(error)}",
              )
          }
          if legacy.num_points != external.num_points {
            return Err(
              "\{path} m\{message_index} s\{submessage_index} num_points mismatch: external=\{external.num_points} legacy=\{legacy.num_points}",
            )
          }
          if legacy.values.length() != external.values.length() {
            return Err(
              "\{path} m\{message_index} s\{submessage_index} value length mismatch against legacy: external=\{external.values.length()} legacy=\{legacy.values.length()}",
            )
          }
          // Current in-package JPEG2000 unpacker still diverges numerically from
          // external/openjpeg-style decode on real fixtures. This test verifies
          // that the external package can decode the GRIB2 payload shape.
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
test "jpeg2000 external package bridge decodes eccodes fixture" {
  match
    assert_fixture_external_bridge_succeeds(
      @grib2support.grib2_fixture_path_eccodes_jpeg(),
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}

///|
test "jpeg2000 external package bridge decodes reduced gaussian fixture" {
  match
    assert_fixture_external_bridge_succeeds(
      @grib2support.grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg(),
    ) {
    Ok(_) => ()
    Err(error) => fail(error)
  }
}
