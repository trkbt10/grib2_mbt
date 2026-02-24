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
  InventoryCodeTable13
  InventoryCodeTable14
  InventoryCodeTable30
  InventoryCodeTable31
  InventoryCodeTable60
  InventoryCodeTable40
  InventoryCodeTable41
  InventoryCodeTable42
  InventoryCodeTable43
  InventoryCodeTable44
  InventoryCodeTable50
  InventoryFlagTable33
  InventoryFlagTable34
  InventoryScan
  InventoryExtName
  InventoryFullName
  InventoryLev0
  InventoryCyclic
  InventoryDomain
  InventoryScale
  InventoryScaling
  InventoryRadius
  InventoryVarX
  InventoryGridId
  InventoryNl
  InventoryMisc
  InventoryFlagTable35
  InventoryFlagTable39
  InventoryFlagTable310
  InventoryMatchInv
  InventoryCodeTable32
  InventoryCodeTable45a
  InventoryCodeTable45b
  InventoryCodeTable15
  InventoryCodeTable16
  InventoryCodeTable46
  InventoryCodeTable49
  InventoryCodeTable410
  InventoryCodeTable411
  InventoryCodeTable311
  InventoryCodeTable51
  InventoryCodeTable36
  InventoryCodeTable37
  InventoryCodeTable38
  InventoryCodeTable315
  InventoryCodeTable320
  InventoryCodeTable321
  InventoryCodeTable47
  InventoryCodeTable48
  InventoryCodeTable411s
  InventoryCodeTable415
  InventoryCodeTable416
  InventoryCodeTable491
  InventoryCodeTable491b
  InventoryCodeTable4230
  InventoryCodeTable4233
  InventoryCodeTable4235
  InventoryCodeTable4240
  InventoryCodeTable4241
  InventoryCodeTable4242
  InventoryCodeTable54
  InventoryCodeTable55
  InventoryCodeTable56
  InventoryCodeTable57
  InventoryFtime1
  InventoryS2
  InventoryPdsFcstTime
  InventoryTypeReftime
  InventoryTable
  InventoryVectorDir
  InventoryPrecision
  InventoryNumCoordValues
  InventoryNEns
  InventoryNClusters
  InventoryAerosolSize
  InventoryAerosolWavelength
  InventoryCluster
  InventoryClusterInfo
  InventoryModelVersionDate
  InventoryPercent
  InventoryPostProcessing
  InventorySpatialProc
  InventorySpectralBands
  InventoryCtlEns
  InventoryWarnOldG2
  InventoryWavePartition
  InventoryProcessId
  InventoryFtime2
  InventoryGeolocation
  InventoryJMA
  InventoryJMANb
  InventoryJMANr
  InventoryResetDelayedError
  InventoryFtnApiFn0
  InventoryGribMaxBits
  InventoryHybrid
  InventoryVerbose
  InventoryCrlf
  InventoryInv
  // Hex dump options
  Inventory0xSec0
  Inventory0xSec1
  Inventory0xSec3
  Inventory0xSec4
  Inventory0xSec5
  Inventory0xSec6
  Inventory0xSec7
  // Checksum options
  InventoryChecksum0
  InventoryChecksum1
  InventoryChecksum3
  InventoryChecksum4
  InventoryChecksum5
  InventoryChecksum6
  InventoryChecksum7
  // Parameterized byte access options
  InventoryGetByte(Int, Int, Int) // section, octet, count
  InventoryGetHex(Int, Int, Int)
  InventoryGetInt(Int, Int, Int)
  InventoryGetInt2(Int, Int, Int)
  InventoryGetIeee(Int, Int, Int)
  // Data statistics options
  InventoryMin
  InventoryMax
  InventoryStats
  // Grid information
  InventoryNlons
  // Position/location options
  InventoryIJ(Int, Int) // i, j
  InventoryIJLat(Int, Int)
  InventoryILat(Int) // linear index
  InventoryLon(Double, Double) // lon, lat
  InventoryLL2IJ(Double, Double)
  InventoryLL2I(Double, Double)
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
    InventoryCodeTable13 => wgrib2_code_table_1_3_lines(context)
    InventoryCodeTable14 => wgrib2_code_table_1_4_lines(context)
    InventoryCodeTable30 => wgrib2_code_table_3_0_lines(context)
    InventoryCodeTable31 => wgrib2_code_table_3_1_lines(context)
    InventoryCodeTable60 => wgrib2_code_table_6_0_lines(context)
    InventoryCodeTable40 => wgrib2_code_table_4_0_lines(context)
    InventoryCodeTable41 => wgrib2_code_table_4_1_lines(context)
    InventoryCodeTable42 => wgrib2_code_table_4_2_lines(context)
    InventoryCodeTable43 => wgrib2_code_table_4_3_lines(context)
    InventoryCodeTable44 => wgrib2_code_table_4_4_lines(context)
    InventoryCodeTable50 => wgrib2_code_table_5_0_lines(context)
    InventoryFlagTable33 => wgrib2_flag_table_3_3_lines(context)
    InventoryFlagTable34 => wgrib2_flag_table_3_4_lines(context)
    InventoryScan => wgrib2_scan_lines(context)
    InventoryExtName => wgrib2_ext_name_lines(context)
    InventoryFullName => wgrib2_full_name_lines(context)
    InventoryLev0 => wgrib2_lev0_lines(context)
    InventoryCyclic => wgrib2_cyclic_lines(context)
    InventoryDomain => wgrib2_domain_lines(context)
    InventoryScale => wgrib2_scale_lines(context)
    InventoryScaling => wgrib2_scaling_lines(context)
    InventoryRadius => wgrib2_radius_lines(context)
    InventoryVarX => wgrib2_varX_lines(context)
    InventoryGridId => wgrib2_grid_id_lines(context)
    InventoryNl => wgrib2_nl_lines(context)
    InventoryMisc => wgrib2_misc_lines(context)
    InventoryFlagTable35 => wgrib2_flag_table_3_5_lines(context)
    InventoryFlagTable39 => wgrib2_flag_table_3_9_lines(context)
    InventoryFlagTable310 => wgrib2_flag_table_3_10_lines(context)
    InventoryMatchInv => wgrib2_match_inv_lines(context)
    InventoryCodeTable32 => wgrib2_code_table_3_2_lines(context)
    InventoryCodeTable45a => wgrib2_code_table_4_5a_lines(context)
    InventoryCodeTable45b => wgrib2_code_table_4_5b_lines(context)
    InventoryCodeTable15 => wgrib2_code_table_1_5_lines(context)
    InventoryCodeTable16 => wgrib2_code_table_1_6_lines(context)
    InventoryCodeTable46 => wgrib2_code_table_4_6_lines(context)
    InventoryCodeTable49 => wgrib2_code_table_4_9_lines(context)
    InventoryCodeTable410 => wgrib2_code_table_4_10_lines(context)
    InventoryCodeTable411 => wgrib2_code_table_4_11_lines(context)
    InventoryCodeTable311 => wgrib2_code_table_3_11_lines(context)
    InventoryCodeTable51 => wgrib2_code_table_5_1_lines(context)
    InventoryCodeTable36 => wgrib2_code_table_3_6_lines(context)
    InventoryCodeTable37 => wgrib2_code_table_3_7_lines(context)
    InventoryCodeTable38 => wgrib2_code_table_3_8_lines(context)
    InventoryCodeTable315 => wgrib2_code_table_3_15_lines(context)
    InventoryCodeTable320 => wgrib2_code_table_3_20_lines(context)
    InventoryCodeTable321 => wgrib2_code_table_3_21_lines(context)
    InventoryCodeTable47 => wgrib2_code_table_4_7_lines(context)
    InventoryCodeTable48 => wgrib2_code_table_4_8_lines(context)
    InventoryCodeTable411s => wgrib2_code_table_4_11s_lines(context)
    InventoryCodeTable415 => wgrib2_code_table_4_15_lines(context)
    InventoryCodeTable416 => wgrib2_code_table_4_16_lines(context)
    InventoryCodeTable491 => wgrib2_code_table_4_91_lines(context)
    InventoryCodeTable491b => wgrib2_code_table_4_91b_lines(context)
    InventoryCodeTable4230 => wgrib2_code_table_4_230_lines(context)
    InventoryCodeTable4233 => wgrib2_code_table_4_233_lines(context)
    InventoryCodeTable4235 => wgrib2_code_table_4_235_lines(context)
    InventoryCodeTable4240 => wgrib2_code_table_4_240_lines(context)
    InventoryCodeTable4241 => wgrib2_code_table_4_241_lines(context)
    InventoryCodeTable4242 => wgrib2_code_table_4_242_lines(context)
    InventoryCodeTable54 => wgrib2_code_table_5_4_lines(context)
    InventoryCodeTable55 => wgrib2_code_table_5_5_lines(context)
    InventoryCodeTable56 => wgrib2_code_table_5_6_lines(context)
    InventoryCodeTable57 => wgrib2_code_table_5_7_lines(context)
    InventoryFtime1 => wgrib2_ftime1_lines(context)
    InventoryS2 => wgrib2_s2_lines(context)
    InventoryPdsFcstTime => wgrib2_pds_fcst_time_lines(context)
    InventoryTypeReftime => wgrib2_type_reftime_lines(context)
    InventoryTable => wgrib2_table_lines(context)
    InventoryVectorDir => wgrib2_vector_dir_lines(context)
    InventoryPrecision => wgrib2_precision_lines(context)
    InventoryNumCoordValues => wgrib2_number_of_coordinate_values_lines(context)
    InventoryNEns => wgrib2_N_ens_lines(context)
    InventoryNClusters => wgrib2_N_clusters_lines(context)
    InventoryAerosolSize => wgrib2_aerosol_size_lines(context)
    InventoryAerosolWavelength => wgrib2_aerosol_wavelength_lines(context)
    InventoryCluster => wgrib2_cluster_lines(context)
    InventoryClusterInfo => wgrib2_cluster_info_lines(context)
    InventoryModelVersionDate => wgrib2_model_version_date_lines(context)
    InventoryPercent => wgrib2_percent_lines(context)
    InventoryPostProcessing => wgrib2_post_processing_lines(context)
    InventorySpatialProc => wgrib2_spatial_proc_lines(context)
    InventorySpectralBands => wgrib2_spectral_bands_lines(context)
    InventoryCtlEns => wgrib2_ctl_ens_lines(context)
    InventoryWarnOldG2 => wgrib2_warn_old_g2_lines(context)
    InventoryWavePartition => wgrib2_wave_partition_lines(context)
    InventoryProcessId => wgrib2_processid_lines(context)
    InventoryFtime2 => wgrib2_ftime2_lines(context)
    InventoryGeolocation => wgrib2_geolocation_lines(context)
    InventoryJMA => wgrib2_JMA_lines(context)
    InventoryJMANb => wgrib2_JMA_Nb_lines(context)
    InventoryJMANr => wgrib2_JMA_Nr_lines(context)
    InventoryResetDelayedError => wgrib2_reset_delayed_error_lines(context)
    InventoryFtnApiFn0 => wgrib2_ftn_api_fn0_lines(context)
    InventoryGribMaxBits => wgrib2_grib_max_bits_lines(context)
    InventoryHybrid => wgrib2_hybrid_lines(context)
    InventoryVerbose => wgrib2_V_lines(context)
    InventoryCrlf => wgrib2_crlf_lines(context)
    InventoryInv => wgrib2_inv_lines(context)
    // Hex dump options
    Inventory0xSec0 => wgrib2_0xSec0_lines(context)
    Inventory0xSec1 => wgrib2_0xSec1_lines(context)
    Inventory0xSec3 => wgrib2_0xSec3_lines(context)
    Inventory0xSec4 => wgrib2_0xSec4_lines(context)
    Inventory0xSec5 => wgrib2_0xSec5_lines(context)
    Inventory0xSec6 => wgrib2_0xSec6_lines(context)
    Inventory0xSec7 => wgrib2_0xSec7_lines(context)
    // Checksum options
    InventoryChecksum0 => wgrib2_checksum0_lines(context)
    InventoryChecksum1 => wgrib2_checksum1_lines(context)
    InventoryChecksum3 => wgrib2_checksum3_lines(context)
    InventoryChecksum4 => wgrib2_checksum4_lines(context)
    InventoryChecksum5 => wgrib2_checksum5_lines(context)
    InventoryChecksum6 => wgrib2_checksum6_lines(context)
    InventoryChecksum7 => wgrib2_checksum7_lines(context)
    // Parameterized byte access options
    InventoryGetByte(sec, oct, cnt) =>
      wgrib2_get_byte_lines(context, sec, oct, cnt)
    InventoryGetHex(sec, oct, cnt) =>
      wgrib2_get_hex_lines(context, sec, oct, cnt)
    InventoryGetInt(sec, oct, cnt) =>
      wgrib2_get_int_lines(context, sec, oct, cnt)
    InventoryGetInt2(sec, oct, cnt) =>
      wgrib2_get_int2_lines(context, sec, oct, cnt)
    InventoryGetIeee(sec, oct, cnt) =>
      wgrib2_get_ieee_lines(context, sec, oct, cnt)
    // Data statistics options
    InventoryMin => wgrib2_min_lines(context)
    InventoryMax => wgrib2_max_lines(context)
    InventoryStats => wgrib2_stats_lines(context)
    // Grid information
    InventoryNlons => wgrib2_nlons_lines(context)
    // Position/location options
    InventoryIJ(i, j) => wgrib2_ij_lines(context, i, j)
    InventoryIJLat(i, j) => wgrib2_ijlat_lines(context, i, j)
    InventoryILat(idx) => wgrib2_ilat_lines(context, idx)
    InventoryLon(lon, lat) => wgrib2_lon_lines(context, lon, lat)
    InventoryLL2IJ(lon, lat) => wgrib2_ll2ij_lines(context, lon, lat)
    InventoryLL2I(lon, lat) => wgrib2_ll2i_lines(context, lon, lat)
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
