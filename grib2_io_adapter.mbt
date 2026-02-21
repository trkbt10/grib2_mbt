///|
pub(all) enum Grib2InventoryMode {
  InventoryDefault
  InventoryShort
  InventorySec0
  InventorySec3
  InventorySec4
  InventoryVarLev
} derive(Show)

///|
pub fn render_inventory_lines(
  context : Grib2FileContext,
  mode : Grib2InventoryMode,
) -> Array[String] {
  match mode {
    InventoryDefault => wgrib2_default_lines(context)
    InventoryShort => wgrib2_s_lines(context)
    InventorySec0 => wgrib2_sec0_lines(context)
    InventorySec3 => wgrib2_sec3_lines(context)
    InventorySec4 => wgrib2_sec4_lines(context)
    InventoryVarLev => wgrib2_var_lev_lines(context)
  }
}

///|
pub(all) suberror Grib2IoAdapterError {
  ReadFailed(String)
  ParseFailed(Grib2ParseError)
  ValidateFailed(Grib2WriteError)
  WriteFailed(String)
} derive(Show)

///|
pub fn parse_with_io(
  read_bytes : (String) -> Result[Bytes, String],
  source : String,
) -> Result[Grib2FileContext, Grib2IoAdapterError] {
  let bytes = match read_bytes(source) {
    Ok(bytes) => bytes
    Err(error) => return Err(ReadFailed(error))
  }
  match parse_grib2_file(bytes) {
    Ok(context) => Ok(context)
    Err(error) => Err(ParseFailed(error))
  }
}

///|
pub fn render_inventory_lines_with_io(
  read_bytes : (String) -> Result[Bytes, String],
  source : String,
  mode : Grib2InventoryMode,
) -> Result[Array[String], Grib2IoAdapterError] {
  let context = match parse_with_io(read_bytes, source) {
    Ok(context) => context
    Err(error) => return Err(error)
  }
  Ok(render_inventory_lines(context, mode))
}

///|
pub fn write_with_io(
  write_bytes : (String, Bytes) -> Result[Unit, String],
  destination : String,
  context : Grib2FileContext,
  strict? : Bool = true,
) -> Result[Unit, Grib2IoAdapterError] {
  let out = if strict {
    match rebuild_strict(context) {
      Ok(bytes) => bytes
      Err(error) => return Err(ValidateFailed(error))
    }
  } else {
    rebuild_raw(context)
  }
  match write_bytes(destination, out) {
    Ok(_) => Ok(())
    Err(error) => Err(WriteFailed(error))
  }
}
