///|
/// I/O facade: re-export the callback-based adapter from @io —
/// `Grib2IoAdapterError`, `parse_with_io`, `render_inventory_lines_with_io`,
/// and `write_with_io`. Lets consumers stream GRIB2 content through their
/// own reader/writer without depending on @io directly.
pub using @io {
  type Grib2IoAdapterError,
  parse_with_io,
  render_inventory_lines_with_io,
  write_with_io,
}
