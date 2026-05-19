///|
/// Core facade: re-export `parse_grib2_file` (the top-level parser) and the
/// message-mutation helpers `context_replace_message_raw`,
/// `context_insert_message_raw`, `context_append_message_raw`, and
/// `context_remove_message`.
pub using @core {
  parse_grib2_file,
  context_replace_message_raw,
  context_insert_message_raw,
  context_append_message_raw,
  context_remove_message,
}
