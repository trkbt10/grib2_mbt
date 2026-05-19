///|
/// API facade: re-export the target-agnostic JSON / data-extraction layer —
/// `parse`, `find_submessage`, `error_to_json`, the per-section
/// `get_section{1,3,4,5,6}_json` helpers, `get_grid_data`, `get_latitudes`,
/// `get_longitudes`, and `generate_coordinates`. Used by the WASM bindings
/// and any TypeScript consumer.
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
