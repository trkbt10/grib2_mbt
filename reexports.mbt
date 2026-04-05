///|
/// Public API of the grib2_mbt library.
///
/// This root package provides the high-level API for GRIB2 file processing.
/// For low-level binary I/O, import @core directly.
/// For individual code table lookups, import @decode directly.
/// For wgrib2-compatible inventory, import @wgrib2 directly.

///|
/// Context types (data model).
pub using @context {
  type Grib2ParseError,
  type Grib2ContextEditError,
  type Grib2SectionFrame,
  type Grib2SubmessageFrame,
  type Grib2MessageContext,
  type Grib2FileContext,
}

///|
/// Parsing and context operations.
pub using @core {
  parse_grib2_file,
  context_replace_message_raw,
  context_insert_message_raw,
  context_append_message_raw,
  context_remove_message,
}

///|
/// Section decoding, metadata extraction, and data unpacking.
pub using @decode {
  type Grib2SectionCodecError,
  type Grib2Section1Decoded,
  type Grib2Section2Decoded,
  type Grib2Section3Decoded,
  type Grib2Section4Decoded,
  type Grib2Section5Decoded,
  type Grib2Section6Decoded,
  type Grib2Section7Decoded,
  type Grib2RecordMeta,
  type Grib2WriteError,
  decode_message_section1,
  decode_submessage_section2,
  decode_submessage_section3,
  decode_submessage_section4,
  decode_submessage_section5,
  decode_submessage_section6,
  decode_submessage_section7,
  decode_records,
  unpack_submessage_data,
  validate_context_invariants,
  rebuild_raw,
  rebuild_strict,
}

///|
/// wgrib2-compatible inventory rendering.
pub using @wgrib2 {
  type Grib2InventoryMode,
  render_inventory_lines,
}

///|
/// High-level target-agnostic API (JSON section access, data extraction).
pub using @api {
  parse,
  find_submessage,
  error_to_json,
  get_section1_json,
  get_section3_json,
  get_section4_json,
  get_section5_json,
  get_section6_json,
  get_grid_data,
  get_latitudes,
  get_longitudes,
  generate_coordinates,
}

///|
/// I/O adapter with callback-based file access.
pub using @io {
  type Grib2IoAdapterError,
  parse_with_io,
  render_inventory_lines_with_io,
  write_with_io,
}
