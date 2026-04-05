///|
using @context {
  type Grib2ParseError,
  type Grib2FileContext,
}

///|
using @core {
  parse_grib2_file,
}

///|
using @decode {
  type Grib2WriteError,
  rebuild_raw,
  rebuild_strict,
}

///|
using @wgrib2 {
  type Grib2InventoryMode,
  render_inventory_lines,
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
