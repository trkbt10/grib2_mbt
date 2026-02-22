///|
test "editing API supports remove/insert while keeping strict writer valid" {
  let path = "fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2"
  let original_bytes = match read_fixture_bytes(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let original = match @lib.parse_grib2_file(original_bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let first_raw = original.messages[0].raw
  let removed = match original.remove_message(0) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(removed.message_count(), content="346")
  inspect(removed.messages[0].offset, content="0")
  let restored = match removed.insert_message_raw(0, first_raw) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  inspect(restored.message_count(), content="347")
  inspect(@lib.rebuild_raw(restored) == original_bytes, content="true")
  let strict_bytes = match @lib.rebuild_strict(restored) {
    Ok(bytes) => bytes
    Err(error) => fail(error.to_string())
  }
  inspect(strict_bytes == original_bytes, content="true")
}

///|
test "strict writer detects invariant violations" {
  let context = match
    parse_fixture_for_writer(
      "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2",
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let messages = [..context.messages]
  messages[0] = message_with_offset(messages[0], messages[0].offset + 1)
  let broken : @lib.Grib2FileContext = { messages, }
  let rejected = match @lib.rebuild_strict(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}

///|
test "strict writer rejects malformed typed section4 payload" {
  let path = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let bytes = match read_fixture_bytes(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let parsed = match @lib.parse_grib2_file(bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let section4_num_coord_offset = parsed.messages[0].submessages[0].section4.start +
    5
  let mutated_bytes = with_u16_be(bytes, section4_num_coord_offset, 4096)
  let mutated = match @lib.parse_grib2_file(mutated_bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let rejected = match @lib.rebuild_strict(mutated) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}

///|
test "unknown template id is preserved through parse and rebuild" {
  let path = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let bytes = match read_fixture_bytes(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let original = match @lib.parse_grib2_file(bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let section4_template_offset = original.messages[0].submessages[0].section4.start +
    7
  let mutated_bytes = with_u16_be(bytes, section4_template_offset, 999)
  let mutated = match @lib.parse_grib2_file(mutated_bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let records = @lib.decode_records(mutated)
  inspect(records[0].section4_template.id(), content="999")
  inspect(records[0].section4_template.is_known(), content="false")
  inspect(@lib.rebuild_raw(mutated) == mutated_bytes, content="true")
  let strict_bytes = match @lib.rebuild_strict(mutated) {
    Ok(bytes) => bytes
    Err(error) => fail(error.to_string())
  }
  inspect(strict_bytes == mutated_bytes, content="true")
}
