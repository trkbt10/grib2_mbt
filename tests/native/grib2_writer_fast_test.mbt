///|
test "editing API supports remove/insert while keeping strict writer valid" {
  let path = @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000()
  let original_bytes = match @grib2support.grib2_fixture_bytes_read(path) {
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
    @grib2support.grib2_fixture_context_parse(
      @grib2support.grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let messages = [..context.messages]
  messages[0] = @grib2support.grib2_message_with_offset(
    messages[0],
    messages[0].offset + 1,
  )
  let broken : @lib.Grib2FileContext = { messages, }
  let rejected = match @lib.rebuild_strict(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}

///|
test "strict writer rejects malformed typed section4 payload" {
  let path = @grib2support.grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000()
  let bytes = match @grib2support.grib2_fixture_bytes_read(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let parsed = match @lib.parse_grib2_file(bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let section4_num_coord_offset = parsed.messages[0].submessages[0].section4.start +
    5
  let mutated_bytes = @lib.binary_bytes_with_u16_be_at(
    bytes, section4_num_coord_offset, 4096,
  )
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
  let path = @grib2support.grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000()
  let bytes = match @grib2support.grib2_fixture_bytes_read(path) {
    Ok(bytes) => bytes
    Err(error) => fail(error)
  }
  let original = match @lib.parse_grib2_file(bytes) {
    Ok(context) => context
    Err(error) => fail(error.to_string())
  }
  let section4_template_offset = original.messages[0].submessages[0].section4.start +
    7
  let mutated_bytes = @lib.binary_bytes_with_u16_be_at(
    bytes, section4_template_offset, 999,
  )
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

///|
test "strict writer rejects section0 length header mismatch" {
  let context = match
    @grib2support.grib2_fixture_context_parse(
      @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let message0 = context.messages[0]
  let broken_raw = @lib.binary_bytes_with_u32_be_at(
    message0.raw,
    12,
    message0.total_length - 1,
  )
  let broken = @grib2support.grib2_context_with_replaced_message0(
    context,
    @grib2support.grib2_message_with_raw(message0, broken_raw),
  )
  let rejected = match @lib.rebuild_strict(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}

///|
test "strict writer rejects broken section8 magic in raw message" {
  let context = match
    @grib2support.grib2_fixture_context_parse(
      @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let message0 = context.messages[0]
  let broken_raw = @lib.binary_bytes_with_u8_at(
    message0.raw,
    message0.raw.length() - 1,
    56,
  )
  let broken = @grib2support.grib2_context_with_replaced_message0(
    context,
    @grib2support.grib2_message_with_raw(message0, broken_raw),
  )
  let rejected = match @lib.rebuild_strict(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}

///|
test "strict writer rejects section8 offset mismatch" {
  let context = match
    @grib2support.grib2_fixture_context_parse(
      @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let message0 = context.messages[0]
  let broken = @grib2support.grib2_context_with_replaced_message0(
    context,
    @grib2support.grib2_message_with_section8_offset(
      message0,
      message0.section8_offset + 1,
    ),
  )
  let rejected = match @lib.rebuild_strict(broken) {
    Ok(_) => false
    Err(_) => true
  }
  inspect(rejected, content="true")
}
