///|
/// wgrib2 facade: re-export the inventory dispatcher — `Grib2InventoryMode`
/// (the enum that names every CLI option) and `render_inventory_lines` (the
/// driver that maps a mode + parsed context to the printable lines).
pub using @wgrib2 {
  type Grib2InventoryMode,
  render_inventory_lines,
}
