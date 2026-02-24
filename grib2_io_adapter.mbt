///|
pub(all) enum Grib2InventoryMode {
  InventoryDefault
  InventoryShort
  InventorySec0
  InventorySec3
  InventorySec4
  InventorySec5
  InventorySec6
  InventorySecLen
  InventoryN
  InventoryRange
  InventoryVar
  InventoryLev
  InventoryFtime
  InventoryT
  InventoryVt
  InventoryTFull
  InventoryVtFull
  InventoryYY
  InventoryMM
  InventoryRT
  InventoryStartFt
  InventoryStartFT
  InventoryEndFt
  InventoryEndFT
  InventoryS
  InventoryVerf
  InventoryUnixTime
  InventoryGrid
  InventoryPdt
  InventoryProcess
  InventoryEns
  InventoryProb
  InventoryDisc
  InventoryCenter
  InventorySubcenter
  InventoryPacking
  InventoryBitmap
  InventoryNxny
  InventoryNpts
  InventoryVarLev
  InventoryCodeTable00
  InventoryCodeTable10
  InventoryCodeTable11
  InventoryCodeTable12
  InventoryCodeTable31
  InventoryCodeTable40
  InventoryCodeTable41
  InventoryCodeTable42
  InventoryCodeTable43
  InventoryCodeTable44
  InventoryCodeTable50
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
    InventorySec5 => wgrib2_sec5_lines(context)
    InventorySec6 => wgrib2_sec6_lines(context)
    InventorySecLen => wgrib2_sec_len_lines(context)
    InventoryN => wgrib2_n_lines(context)
    InventoryRange => wgrib2_range_lines(context)
    InventoryVar => wgrib2_var_lines(context)
    InventoryLev => wgrib2_lev_lines(context)
    InventoryFtime => wgrib2_ftime_lines(context)
    InventoryT => wgrib2_t_lines(context)
    InventoryVt => wgrib2_vt_lines(context)
    InventoryTFull => wgrib2_T_lines(context)
    InventoryVtFull => wgrib2_VT_lines(context)
    InventoryYY => wgrib2_YY_lines(context)
    InventoryMM => wgrib2_MM_lines(context)
    InventoryRT => wgrib2_RT_lines(context)
    InventoryStartFt => wgrib2_start_ft_lines(context)
    InventoryStartFT => wgrib2_start_FT_lines(context)
    InventoryEndFt => wgrib2_end_ft_lines(context)
    InventoryEndFT => wgrib2_end_FT_lines(context)
    InventoryS => wgrib2_S_lines(context)
    InventoryVerf => wgrib2_verf_lines(context)
    InventoryUnixTime => wgrib2_unix_time_lines(context)
    InventoryGrid => wgrib2_grid_lines(context)
    InventoryPdt => wgrib2_pdt_lines(context)
    InventoryProcess => wgrib2_process_lines(context)
    InventoryEns => wgrib2_ens_lines(context)
    InventoryProb => wgrib2_prob_lines(context)
    InventoryDisc => wgrib2_disc_lines(context)
    InventoryCenter => wgrib2_center_lines(context)
    InventorySubcenter => wgrib2_subcenter_lines(context)
    InventoryPacking => wgrib2_packing_lines(context)
    InventoryBitmap => wgrib2_bitmap_lines(context)
    InventoryNxny => wgrib2_nxny_lines(context)
    InventoryNpts => wgrib2_npts_lines(context)
    InventoryVarLev => wgrib2_var_lev_lines(context)
    InventoryCodeTable00 => wgrib2_code_table_0_0_lines(context)
    InventoryCodeTable10 => wgrib2_code_table_1_0_lines(context)
    InventoryCodeTable11 => wgrib2_code_table_1_1_lines(context)
    InventoryCodeTable12 => wgrib2_code_table_1_2_lines(context)
    InventoryCodeTable31 => wgrib2_code_table_3_1_lines(context)
    InventoryCodeTable40 => wgrib2_code_table_4_0_lines(context)
    InventoryCodeTable41 => wgrib2_code_table_4_1_lines(context)
    InventoryCodeTable42 => wgrib2_code_table_4_2_lines(context)
    InventoryCodeTable43 => wgrib2_code_table_4_3_lines(context)
    InventoryCodeTable44 => wgrib2_code_table_4_4_lines(context)
    InventoryCodeTable50 => wgrib2_code_table_5_0_lines(context)
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
