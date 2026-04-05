///|
fn print_usage() -> Unit {
  println("usage: grib2_mbt <grib2-file> [option]")
  println("options:")
  println("  -s      print inventory lines")
  println("  -Sec0   print section0 summary lines")
  println("  -Sec3   print section3 summary lines")
  println("  -Sec4   print section4 summary lines")
  println("  -Sec5   print section5 summary lines")
  println("  -Sec6   print section6 summary lines")
  println("  -Sec_len  print section length summary lines")
  println("  -n      print record indices")
  println("  -range  print byte ranges")
  println("  -var    print variable names")
  println("  -lev    print level names")
  println("  -ftime  print forecast time labels")
  println("  -t      print reference time YYYYMMDDHH")
  println("  -T      print reference time YYYYMMDDHHMMSS")
  println("  -vt     print verification time YYYYMMDDHH")
  println("  -VT     print verification time YYYYMMDDHHMMSS")
  println("  -YY     print reference year YYYY")
  println("  -MM     print reference month MM")
  println("  -RT     print type of reference time")
  println("  -start_ft  print forecast start time YYYYMMDDHH")
  println("  -start_FT  print forecast start time YYYYMMDDHHMMSS")
  println("  -end_ft  print forecast end time YYYYMMDDHH")
  println("  -end_FT  print forecast end time YYYYMMDDHHMMSS")
  println("  -S      print inventory with D=YYYYMMDDHHMMSS")
  println("  -verf   print inventory using verification time")
  println("  -unix_time  print unix timestamps")
  println("  -grid   print grid description lines")
  println("  -pdt    print product definition template numbers")
  println("  -process  print process type (code table 4.3)")
  println("  -ens    print ensemble information")
  println("  -prob   print probability information")
  println("  -disc   print discipline information")
  println("  -center  print center id")
  println("  -subcenter  print subcenter id")
  println("  -packing  print packing mode")
  println("  -bitmap  print bitmap mode")
  println("  -nxny   print grid nx/ny")
  println("  -npts   print total grid points")
  println("  -var -lev  print variable and level lines")
  println("  -code_table_0.0  print discipline (code table 0.0)")
  println("  -code_table_1.0  print master tables version (code table 1.0)")
  println("  -code_table_1.1  print local tables version (code table 1.1)")
  println(
    "  -code_table_1.2  print significance of reference time (code table 1.2)",
  )
  println("  -code_table_1.3  print production status (code table 1.3)")
  println("  -code_table_1.4  print type of data (code table 1.4)")
  println("  -code_table_3.0  print source of grid definition (code table 3.0)")
  println("  -code_table_3.1  print grid definition template (code table 3.1)")
  println("  -code_table_6.0  print bitmap indicator (code table 6.0)")
  println(
    "  -code_table_4.0  print product definition template (code table 4.0)",
  )
  println("  -code_table_4.1  print parameter category (code table 4.1)")
  println("  -code_table_4.2  print parameter number (code table 4.2)")
  println("  -code_table_4.3  print process type (code table 4.3)")
  println("  -code_table_4.4  print unit of time range (code table 4.4)")
  println(
    "  -code_table_5.0  print data representation template (code table 5.0)",
  )
  println("  -flag_table_3.3  print resolution and component flags")
  println("  -flag_table_3.4  print scanning mode")
  println("  -flag_table_3.5  print projection center flags")
  println("  -flag_table_3.9  print numbering order of diamonds")
  println("  -flag_table_3.10  print scanning mode for one diamond")
  println("  -scan   print scanning mode with input/output")
  println("  -ext_name  print extended parameter name")
  println("  -full_name  print VAR.LEVEL format")
  println("  -lev0   print simple level name")
  println("  -cyclic  print grid cyclic status")
  println("  -domain  print N/S/W/E grid bounds")
  println("  -scale  print decimal/binary scale factors")
  println("  -scaling  print scaling parameters")
  println("  -radius  print earth radius information")
  println("  -varX  print extended variable identifier")
  println("  -grid_id  print grid identification")
  println("  -nl  add blank line after each record")
  println("  -misc  print miscellaneous inventory")
  println("  -Match_inv  print comprehensive match inventory")
  println(
    "  -match_inv  print comprehensive match inventory (same as -Match_inv)",
  )
  println("  -code_table_3.2  print earth shape (code table 3.2)")
  println("  -code_table_4.5a  print first surface type (code table 4.5)")
  println("  -code_table_4.5b  print second surface type (code table 4.5)")
  println("  -code_table_1.5  print identification template number")
  println("  -code_table_1.6  print calendar")
  println("  -code_table_4.6  print ensemble type")
  println("  -code_table_4.9  print probability type")
  println("  -code_table_4.10  print statistical processing type")
  println("  -code_table_4.11  print type of time intervals")
  println("  -code_table_3.11  print regional/global thinned/reduced grid")
  println("  -code_table_5.1  print type of original field values")
  println("  -code_table_3.6  print spectral data representation type")
  println("  -code_table_3.7  print spectral data representation mode")
  println("  -code_table_3.8  print grid point position")
  println("  -code_table_3.15  print physical meaning of vertical coordinate")
  println("  -code_table_3.20  print type of horizontal line")
  println("  -code_table_3.21  print vertical dimension coordinate values")
  println("  -code_table_4.7  print derived forecast type")
  println("  -code_table_4.8  print cluster mean type")
  println("  -code_table_4.11s  print type of time intervals (all)")
  println("  -code_table_4.15  print type of areal statistical processing")
  println("  -code_table_4.16  print quality control value")
  println("  -code_table_4.91  print type of interval")
  println("  -code_table_4.91b  print type of interval (2nd)")
  println("  -code_table_4.230  print chemical constituent type")
  println("  -code_table_4.233  print aerosol type")
  println("  -code_table_4.235  print wind-generated wave spectral description")
  println("  -code_table_4.240  print type of distribution function")
  println("  -code_table_4.241  print coverage attributes")
  println("  -code_table_4.242  print tile classification")
  println("  -code_table_5.4  print group splitting method")
  println("  -code_table_5.5  print missing value management")
  println("  -code_table_5.6  print spatial differencing")
  println("  -code_table_5.7  print precision in IEEE packing")
  println("  -ftime1  print forecast time (same as -ftime)")
  println("  -s2  print simple inventory")
  println("  -pds_fcst_time  print forecast time in PDS units")
  println("  -type_reftime  print type of reference time")
  println("  -table  print parameter table info")
  println("  -vector_dir  print wind direction type")
  println("  -precision  print packing precision")
  println(
    "  -number_of_coordinate_values_after_template  print coordinate values count",
  )
  println("  -N_ens  print number of ensemble members")
  println("  -N_clusters  print number of clusters")
  println("  -aerosol_size  print aerosol size")
  println("  -aerosol_wavelength  print aerosol wavelength")
  println("  -cluster  print cluster identifier")
  println("  -cluster_info  print cluster information")
  println("  -model_version_date  print model version date")
  println("  -percent  print percentage probability")
  println("  -post_processing  print post-processing type")
  println("  -spatial_proc  print spatial processing")
  println("  -spectral_bands  print spectral bands")
  println("  -spectral_bands_extname  print spectral bands (ext_name style)")
  println("  -gdt  print grid definition template details")
  println("  -timer  print timer readout")
  println("  -ctl_inv  print inventory for g2ctl/GrADS")
  println("  -pyinv  print inventory metadata for pywgrib2")
  println("  -inv_f77 X Y Z  write inventory to Z in Fortran-style format")
  println("  -ctl_ens  print ensemble info for GrADS")
  println("  -warn_old_g2  print old g2lib warnings")
  println("  -wave_partition  print wave partition")
  println("  -processid  print process identifiers")
  println("  -ftime2  print forecast time (future replacement)")
  println("  -geolocation  print geolocation package")
  println("  -JMA  print JMA locally defined PDT")
  println("  -JMA_Nb  print JMA Nb value")
  println("  -JMA_Nr  print JMA Nr value")
  println("  -reset_delayed_error  clear delayed error flag")
  println("  -ftn_api_fn0  print Fortran API format")
  println("  -grib_max_bits  print maximum bits used in encoding")
  println("  -hybrid  print hybrid vertical coordinates")
  println("  -V  print diagnostic output")
  println("  -crlf  use CRLF line endings")
  println("  -inv  print standard inventory")
  println("  -count  print number of matching inventory lines")
  println("  -config  print build/configuration summary")
  println("  -version  print version")
  println("  -end  stop after first matching record")
  println("  -quit  stop after first matching record (compat alias)")
  println(
    "  -error_final X Y Z  fail at end if X=count and count Y Z (Y=ne,eq,le,lt,gt,ge)",
  )
  println("  -export_lonlat file  write lon/lat pairs as binary float32")
  println("  -print  print standard inventory (alias of -s)")
  println("  -print_out file  write inventory output to file")
  println("  -s_out file  write short inventory output to file")
  println("  -nl_out file  append a newline to file")
  println("  -0xSec N  hex dump of section N (0,1,3,4,5,6,7)")
  println("  -checksum N  CRC checksum of section N (0,1,3,4,5,6,7)")
  println(
    "  -get_byte sec oct count  get count bytes from section sec at octet oct",
  )
  println(
    "  -get_hex sec oct count  get count bytes as hex from section sec at octet oct",
  )
  println(
    "  -get_int sec oct count  get count bytes as unsigned int from section sec at octet oct",
  )
  println(
    "  -get_int2 sec oct count  get count bytes as signed int from section sec at octet oct",
  )
  println(
    "  -get_ieee sec oct count  get count 4-byte IEEE floats from section sec at octet oct",
  )
  println("  -min    print minimum data value")
  println("  -max    print maximum data value")
  println("  -stats  print data statistics (ndata, undef, mean, min, max)")
  println("  -nlons  print number of longitudes for each latitude")
  println("  -ij X Y  print value at grid point (X,Y)")
  println("  -ijlat X Y  print lat,lon,value at grid point (X,Y)")
  println("  -ilat X  print lat,lon,value at Xth grid point")
  println("  -lon X Y  print value at nearest grid point to lon=X lat=Y")
  println("  -ll2ij X Y  convert lon=X lat=Y to grid indices (i,j)")
  println("  -ll2i X Y  convert lon=X lat=Y to linear index")
  println("  -proj4_ij2ll X Y  convert i,j to lon,lat (compat mapping)")
  println("  -proj4_ll2ij X Y  convert lon,lat to i,j (compat mapping)")
  println("  -proj4_ll2i X Y  convert lon,lat to i (compat mapping)")
  println("  -grib file  write GRIB2 to file (raw passthrough)")
  println("  -grib_out file  write GRIB2 to file (compat alias)")
  println("  -bin file  write unpacked data as native-order binary float32")
  println("  -ieee file  write unpacked data as big-endian IEEE float32")
  println(
    "  -grib_ieee X  write compatibility split files X.grb/X.head/X.tail/X.h",
  )
  println("  -text file  write unpacked data as text rows (record:point:value)")
  println("  -csv file  write unpacked data as CSV (record,point,value)")
  println("  -csv_long file  write unpacked data as long CSV")
  println("  -spread file  write one CSV line per record with all values")
  println("  -AAIG file  write ArcInfo Ascii Grid for selected record")
  println("  -AAIGlong file  write ArcInfo Ascii Grid (compat long-name)")
  println("  -ijbox I J file mode  write box values, mode=bin|text|spread")
  println("  -ijsmall_grib I J file  make small-domain grib (limited support)")
  println("  -small_grib lonW:lonE latS:latN file  small-domain grib (limited)")
  println("  -lola X Y file mode  lon-lat grid output (identity remap only)")
  println(
    "  -cress_lola X Y file R  Cressman lon-lat grid output (regular lat/lon, negative radii mask)",
  )
  println(
    "  -cubeface2global X file  current build reports unavailable like wgrib2",
  )
  println(
    "  -irr_grid X Y file  irregular grid output (nearest-neighbor, template 3.130)",
  )
  println(
    "  -grib_out_irr all|defined file  irregular-grid grib (template 3.130 compat)",
  )
  println(
    "  -grib_out_irr2 N G R UUID file  irregular-grid grib2 (template 3.101 compat)",
  )
  println(
    "  -new_grid projection xspec yspec out  limited latlon bilinear remap",
  )
  println("  -new_grid_interpolation X  remap method: bilinear|neighbor")
  println("  -new_grid_order out out2  vector ordering compat (limited)")
  println("  -submsg_uv file  vector submessage combine (UGRD/VGRD pairs)")
  println("  -ncep_uv file  NCEP-style UV combine (UGRD/VGRD pairs)")
  println("  -reduced_gaussian_grid out -1 method  reduced Gaussian grid")
  println("  -ave step out  average/time-processing metadata transform")
  println("  -ave0 step out  average transform with zero cutoff metadata")
  println("  -ave_var step out  ave/stddev/min/max metadata transform")
  println("  -fcst_ave step out  forecast-average metadata transform")
  println("  -fcst_ave0 step out  forecast-average transform with zero cutoff")
  println("  -time_processing p i step out  generic time-processing transform")
  println("  -ens_processing out mode  ensemble stats/percentiles transform")
  println("  -ens_qc stats extreme txt version  ensemble qc compat transform")
  println("  -ncep_norm out  normalize PDT4.8 NCEP-style ave/acc")
  println("  -merge_fcst n out  merge PDT4.8 fcst ave/acc/min/max")
  println("  -unmerge_fcst out t z  unmerge PDT4.8 fcst ave/acc")
  println("  -wind_speed out  calculate wind speed (limited compat)")
  println("  -wind_dir out  calculate wind direction (limited compat)")
  println("  -wind_uv out  calculate U/V from speed/dir (limited compat)")
  println(
    "  -tosubmsg file  convert message to submessage stream (discipline-aware)",
  )
  println("  -gridout file  write i j lat lon table for selected record")
  println("  -netcdf file  write NetCDF classic (single-record regular grid)")
  println("  -gribtable_used file  write derived parameter table entries")
  println("  -mysql H U P D T  current build reports unavailable like wgrib2")
  println(
    "  -mysql_dump H U P D T W PV  current build reports unavailable like wgrib2",
  )
  println(
    "  -mysql_speed H U P D T W PV  current build reports unavailable like wgrib2",
  )
  println("  -write_sec N file  write concatenated section N bytes (0-8)")
  println("  -append  append mode for output files")
  println("  -no_append  disable append mode (default)")
  println("  -big_endian  set binary output endianness to big")
  println("  -little_endian  set binary output endianness to little")
  println("  -colon X  replace inventory delimiter ':' with X")
  println("  -last  keep only last matching record")
  println("  -last0  keep only last matching record (compat)")
  println("  -no_header  suppress nx ny header in text output")
  println("  -text_col N  write N values per line in text output")
  println("  -text_fmt FMT  numeric format for text output (e.g. %.6f, %.6g)")
}

///|
fn print_lines(lines : Array[String]) -> Unit {
  @common.print_lines(lines)
}

///|
fn print_lines_crlf(lines : Array[String]) -> Unit {
  @common.print_lines_crlf(lines)
}

///|
fn parse_int_option(s : String) -> Int? {
  @common.parse_int_option(s)
}

///|
fn parse_double_option(s : String) -> Double? {
  @common.parse_double_option(s)
}

///|
fn native_read_bytes(path : String) -> Result[Bytes, String] {
  @common.native_read_bytes(path)
}

///|
fn native_write_bytes(path : String, bytes : Bytes) -> Result[Unit, String] {
  @common.native_write_bytes(path, bytes)
}

///|
fn native_write_string(path : String, content : String) -> Result[Unit, String] {
  @common.native_write_string(path, content)
}

///|
enum CliAction {
  Inventory(@wgrib2_lib.Grib2InventoryMode)
  CountOnly
  ConfigOnly
  WriteRaw(String)
  WriteGribOut(String)
  WriteBin(String)
  WriteIeee(String)
  WriteText(String)
  WriteCsv(String, Bool)
  WriteSpread(String)
  WriteAaig(String, Bool)
  WriteGribIeee(String)
  WriteIjbox(String, String, String, String)
  WriteIjsmallGrib(String, String, String)
  WriteSmallGrib(String, String, String)
  WriteLola(String, String, String, String)
  WriteCressLola(String, String, String, String)
  WriteCubeface2Global
  WriteIrrGrid(String, String, String)
  WriteGribOutIrr(String, String)
  WriteGribOutIrr2(String, String, String, String, String)
  WriteNewGrid(String, String, String, String)
  WriteNewGridOrder(String, String)
  WriteSubmsgUv(String)
  WriteNcepUv(String)
  WriteReducedGaussianGrid(String, String, String)
  WriteAve(String, String)
  WriteAve0(String, String)
  WriteAveVar(String, String)
  WriteFcstAve(String, String)
  WriteFcstAve0(String, String)
  WriteTimeProcessing(String, String, String, String)
  WriteEnsProcessing(String, String)
  WriteEnsQc(String, String, String, String)
  WriteNcepNorm(String)
  WriteMergeFcst(String, String)
  WriteUnmergeFcst(String, String, String)
  WriteWindSpeed(String)
  WriteWindDir(String)
  WriteWindUv(String)
  WriteToSubmsg(String)
  WriteSection(Int, String)
  WriteGridout(String)
  WriteNetcdf(String)
  WriteGribtableUsed(String)
  WriteMysql
  WriteMysqlDump
  WriteMysqlSpeed
  WriteExportLonlat(String)
}

///|
fn unavailable_out_action_lines(action : CliAction) -> Array[String]? {
  match action {
    WriteCubeface2Global =>
      Some(["", "*** FATAL ERROR: cubeface2global: not installed ***", ""])
    WriteMysql => Some(["mysql package not installed"])
    WriteMysqlDump => Some(["mysql package not installed"])
    WriteMysqlSpeed => Some(["mysql package not installed"])
    _ => None
  }
}

///|
fn netcdf_wgrib2_fatal_lines(
  _context : @context.Grib2FileContext,
  _selected : Array[Int]?,
) -> Array[String]? {
  None
}

///|
fn netcdf_selected_record_index(selected : Array[Int]?, position : Int) -> Int {
  match selected {
    Some(records) => records[position]
    None => position + 1
  }
}

///|
fn netcdf_wgrib2_fatal_lines_for_reason(
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  reason : NetcdfPlanFatalReason,
) -> Array[String] {
  match reason {
    NetcdfMixedGridType(valid_prefix_count, failing_record_index) => {
      let lines : Array[String] = []
      for i in 0..<valid_prefix_count {
        let record_index = netcdf_selected_record_index(selected, i)
        match find_record_meta(context, record_index) {
          Some(meta) => lines.push(wgrib2_default_inventory_line(meta))
          None => ()
        }
      }
      lines.push("")
      lines.push("*** FATAL ERROR: netcdf: only one grid type at a time ***")
      lines.push("")
      match find_record_meta(context, failing_record_index) {
        Some(meta) =>
          lines.push(meta.record_id + ":" + meta.message_offset.to_string())
        None => ()
      }
      lines
    }
  }
}

///|
fn wgrib2_default_inventory_line(meta : @decode.Grib2RecordMeta) -> String {
  meta.record_id +
  ":" +
  meta.message_offset.to_string() +
  ":d=" +
  meta.reference_time +
  ":" +
  meta.parameter_name.display() +
  ":" +
  meta.level_name.display() +
  ":" +
  meta.tail +
  ":"
}

///|
fn netcdf_wgrib2_notice_lines(
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
) -> Array[String]? {
  let first_record_index = match selected {
    Some(records) => if records.length() == 0 { None } else { Some(records[0]) }
    None => Some(1)
  }
  let record_index = match first_record_index {
    Some(v) => v
    None => return None
  }
  let meta = match find_record_meta(context, record_index) {
    Some(v) => v
    None => return None
  }
  match meta.section3_template.id() {
    1 =>
      Some([
        "netcdf: doesn't support yet grid_template 1",
        wgrib2_default_inventory_line(meta),
      ])
    _ => None
  }
}

///|
enum ErrorFinalOperator {
  ErrorFinalEq
  ErrorFinalNe
  ErrorFinalLe
  ErrorFinalLt
  ErrorFinalGt
  ErrorFinalGe
}

///|
enum WindDerivedMode {
  WindDerivedSpeed
  WindDerivedDir
}

///|
struct ErrorFinalCountCondition {
  op : ErrorFinalOperator
  expected : Int
}

///|
struct CliInitOptions {
  crlf : Bool
  one_line : Bool
  append_mode : Bool
  new_grid_interpolation : String?
  output_big_endian : Bool?
  no_header : Bool
  text_col : Int?
  text_fmt : String?
  colon_delimiter : String?
  select_last : Bool
  select_last0 : Bool
  inv_f77_mode : String?
  inv_f77_width : Int?
  for_n : String?
  match_patterns : Array[String]
  not_patterns : Array[String]
  inventory_path : String?
  nl_out_path : String?
  print_out_text : String?
  print_out_path : String?
  stop_after_first : Bool
  error_final_count : ErrorFinalCountCondition?
}

///|
struct IrrGridRequestedPoint {
  lon_microdeg : Int
  lat_microdeg : Int
}

///|
fn default_init_options() -> CliInitOptions {
  {
    crlf: false,
    one_line: false,
    append_mode: false,
    new_grid_interpolation: None,
    output_big_endian: None,
    no_header: false,
    text_col: None,
    text_fmt: None,
    colon_delimiter: None,
    select_last: false,
    select_last0: false,
    inv_f77_mode: None,
    inv_f77_width: None,
    for_n: None,
    match_patterns: [],
    not_patterns: [],
    inventory_path: None,
    nl_out_path: None,
    print_out_text: None,
    print_out_path: None,
    stop_after_first: false,
    error_final_count: None,
  }
}

///|
fn parse_cli_invocation(
  tokens : Array[String],
) -> Result[(CliInitOptions, CliAction), String] {
  let mut index = 0
  let mut init = default_init_options()
  while index < tokens.length() {
    let tok = tokens[index]
    if tok == "-one_line" {
      init = { ..init, one_line: true }
      index += 1
      continue
    }
    if tok == "-start_timer" {
      index += 1
      continue
    }
    if tok == "-timer" {
      index += 1
      continue
    }
    if tok == "-fi" {
      index += 1
      continue
    }
    if tok == "-crlf" {
      init = { ..init, crlf: true }
      index += 1
      continue
    }
    if tok == "-append" {
      init = { ..init, append_mode: true }
      index += 1
      continue
    }
    if tok == "-no_append" {
      init = { ..init, append_mode: false }
      index += 1
      continue
    }
    if tok == "-new_grid_interpolation" {
      if index + 1 >= tokens.length() {
        return Err("-new_grid_interpolation requires an argument")
      }
      init = { ..init, new_grid_interpolation: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    if tok == "-big_endian" {
      init = { ..init, output_big_endian: Some(true) }
      index += 1
      continue
    }
    if tok == "-little_endian" {
      init = { ..init, output_big_endian: Some(false) }
      index += 1
      continue
    }
    if tok == "-no_header" {
      init = { ..init, no_header: true }
      index += 1
      continue
    }
    if tok == "-text_col" {
      if index + 1 >= tokens.length() {
        return Err("-text_col requires an argument")
      }
      let n = match parse_int_option(tokens[index + 1]) {
        Some(v) => v
        None => return Err("-text_col requires integer argument")
      }
      if n <= 0 {
        return Err("-text_col requires positive integer")
      }
      init = { ..init, text_col: Some(n) }
      index += 2
      continue
    }
    if tok == "-header" {
      init = { ..init, no_header: false }
      index += 1
      continue
    }
    if tok == "-text_fmt" {
      if index + 1 >= tokens.length() {
        return Err("-text_fmt requires an argument")
      }
      init = { ..init, text_fmt: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    if tok == "-last" {
      if index + 1 < tokens.length() && !tokens[index + 1].has_prefix("-") {
        init = {
          ..init,
          select_last: true,
          inventory_path: Some(tokens[index + 1]),
        }
        index += 2
      } else {
        init = { ..init, select_last: true }
        index += 1
      }
      continue
    }
    if tok == "-last0" {
      if index + 1 < tokens.length() && !tokens[index + 1].has_prefix("-") {
        init = {
          ..init,
          select_last0: true,
          inventory_path: Some(tokens[index + 1]),
        }
        index += 2
      } else {
        init = { ..init, select_last0: true }
        index += 1
      }
      continue
    }
    if tok == "-print" {
      index += 1
      continue
    }
    if tok == "-colon" {
      if index + 1 >= tokens.length() {
        return Err("-colon requires an argument")
      }
      init = { ..init, colon_delimiter: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    if tok == "-end" {
      init = { ..init, stop_after_first: true }
      index += 1
      continue
    }
    if tok == "-quit" {
      init = { ..init, stop_after_first: true }
      index += 1
      continue
    }
    if tok == "-error_final" {
      if index + 3 >= tokens.length() {
        return Err("-error_final requires 3 arguments: count op value")
      }
      if tokens[index + 1] != "count" {
        return Err("-error_final currently supports only X=count")
      }
      let op = match tokens[index + 2] {
        "eq" => Some(ErrorFinalEq)
        "ne" => Some(ErrorFinalNe)
        "le" => Some(ErrorFinalLe)
        "lt" => Some(ErrorFinalLt)
        "gt" => Some(ErrorFinalGt)
        "ge" => Some(ErrorFinalGe)
        _ => None
      }
      let op = match op {
        Some(v) => v
        None => return Err("-error_final op must be one of ne,eq,le,lt,gt,ge")
      }
      let expected = match parse_int_option(tokens[index + 3]) {
        Some(v) => v
        None => return Err("-error_final value must be an integer")
      }
      init = { ..init, error_final_count: Some({ op, expected }) }
      index += 4
      continue
    }
    if tok == "-print_out" {
      if index + 2 < tokens.length() && !tokens[index + 2].has_prefix("-") {
        init = {
          ..init,
          print_out_text: Some(tokens[index + 1]),
          print_out_path: Some(tokens[index + 2]),
        }
        index += 3
        continue
      }
      if index + 1 >= tokens.length() {
        return Err(tok + " requires an argument")
      }
      init = { ..init, inventory_path: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    if tok == "-s_out" {
      if index + 1 >= tokens.length() {
        return Err(tok + " requires an argument")
      }
      init = { ..init, inventory_path: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    if tok == "-nl_out" {
      if index + 1 >= tokens.length() {
        return Err("-nl_out requires an argument")
      }
      init = { ..init, nl_out_path: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    if tok == "-inv_f77" {
      if index + 3 >= tokens.length() {
        return Err("-inv_f77 requires 3 arguments: bin|ieee width output")
      }
      let mode = tokens[index + 1]
      if mode != "bin" && mode != "ieee" {
        return Err("-inv_f77 mode must be bin or ieee")
      }
      let width = match parse_int_option(tokens[index + 2]) {
        Some(v) => v
        None => return Err("-inv_f77 width must be an integer")
      }
      if width <= 0 {
        return Err("-inv_f77 width must be > 0")
      }
      init = {
        ..init,
        inv_f77_mode: Some(mode),
        inv_f77_width: Some(width),
        inventory_path: Some(tokens[index + 3]),
      }
      index += 4
      continue
    }
    if tok == "-for_n" {
      if index + 1 >= tokens.length() {
        return Err("-for_n requires an argument")
      }
      init = { ..init, for_n: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    if tok == "-for" {
      if index + 1 >= tokens.length() {
        return Err("-for requires an argument")
      }
      init = { ..init, for_n: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    if tok == "-match" ||
      tok == "-match_fs" ||
      tok == "-egrep" ||
      tok == "-fgrep" {
      if index + 1 >= tokens.length() {
        return Err(tok + " requires an argument")
      }
      init = {
        ..init,
        match_patterns: [..init.match_patterns, tokens[index + 1]],
      }
      index += 2
      continue
    }
    if tok == "-not" ||
      tok == "-not_fs" ||
      tok == "-egrep_v" ||
      tok == "-fgrep_v" {
      if index + 1 >= tokens.length() {
        return Err(tok + " requires an argument")
      }
      init = { ..init, not_patterns: [..init.not_patterns, tokens[index + 1]] }
      index += 2
      continue
    }
    if tok == "-inv" &&
      index + 1 < tokens.length() &&
      !tokens[index + 1].has_prefix("-") {
      init = { ..init, inventory_path: Some(tokens[index + 1]) }
      index += 2
      continue
    }
    break
  }

  let action_tokens = [..tokens[index:]]
  if action_tokens.length() == 0 {
    return Ok((init, Inventory(InventoryShort)))
  }
  if action_tokens.length() == 1 && action_tokens[0] == "-count" {
    return Ok((init, CountOnly))
  }
  if action_tokens.length() == 1 && action_tokens[0] == "-config" {
    return Ok((init, ConfigOnly))
  }
  if action_tokens.length() == 2 &&
    (action_tokens[0] == "-GRIB" || action_tokens[0] == "-grib") {
    return Ok((init, WriteRaw(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-tosubmsg" {
    return Ok((init, WriteToSubmsg(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-grib_out" {
    return Ok((init, WriteGribOut(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-bin" {
    return Ok((init, WriteBin(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-ieee" {
    return Ok((init, WriteIeee(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-grib_ieee" {
    return Ok((init, WriteGribIeee(action_tokens[1])))
  }
  if action_tokens.length() == 5 && action_tokens[0] == "-ijbox" {
    return Ok(
      (
        init,
        WriteIjbox(
          action_tokens[1],
          action_tokens[2],
          action_tokens[3],
          action_tokens[4],
        ),
      ),
    )
  }
  if action_tokens.length() == 4 && action_tokens[0] == "-ijsmall_grib" {
    return Ok(
      (
        init,
        WriteIjsmallGrib(action_tokens[1], action_tokens[2], action_tokens[3]),
      ),
    )
  }
  if action_tokens.length() == 4 && action_tokens[0] == "-small_grib" {
    return Ok(
      (
        init,
        WriteSmallGrib(action_tokens[1], action_tokens[2], action_tokens[3]),
      ),
    )
  }
  if action_tokens.length() == 5 && action_tokens[0] == "-lola" {
    return Ok(
      (
        init,
        WriteLola(
          action_tokens[1],
          action_tokens[2],
          action_tokens[3],
          action_tokens[4],
        ),
      ),
    )
  }
  if action_tokens.length() == 5 && action_tokens[0] == "-cress_lola" {
    return Ok(
      (
        init,
        WriteCressLola(
          action_tokens[1],
          action_tokens[2],
          action_tokens[3],
          action_tokens[4],
        ),
      ),
    )
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-cubeface2global" {
    return Ok((init, WriteCubeface2Global))
  }
  if action_tokens.length() == 4 && action_tokens[0] == "-irr_grid" {
    return Ok(
      (init, WriteIrrGrid(action_tokens[1], action_tokens[2], action_tokens[3])),
    )
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-grib_out_irr" {
    return Ok((init, WriteGribOutIrr(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 6 && action_tokens[0] == "-grib_out_irr2" {
    return Ok(
      (
        init,
        WriteGribOutIrr2(
          action_tokens[1],
          action_tokens[2],
          action_tokens[3],
          action_tokens[4],
          action_tokens[5],
        ),
      ),
    )
  }
  if action_tokens.length() == 5 && action_tokens[0] == "-new_grid" {
    return Ok(
      (
        init,
        WriteNewGrid(
          action_tokens[1],
          action_tokens[2],
          action_tokens[3],
          action_tokens[4],
        ),
      ),
    )
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-new_grid_order" {
    return Ok((init, WriteNewGridOrder(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-submsg_uv" {
    return Ok((init, WriteSubmsgUv(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-ncep_uv" {
    return Ok((init, WriteNcepUv(action_tokens[1])))
  }
  if action_tokens.length() == 4 && action_tokens[0] == "-reduced_gaussian_grid" {
    return Ok(
      (
        init,
        WriteReducedGaussianGrid(
          action_tokens[1],
          action_tokens[2],
          action_tokens[3],
        ),
      ),
    )
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-ave" {
    return Ok((init, WriteAve(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-ave0" {
    return Ok((init, WriteAve0(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-ave_var" {
    return Ok((init, WriteAveVar(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-fcst_ave" {
    return Ok((init, WriteFcstAve(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-fcst_ave0" {
    return Ok((init, WriteFcstAve0(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 5 && action_tokens[0] == "-time_processing" {
    return Ok(
      (
        init,
        WriteTimeProcessing(
          action_tokens[1],
          action_tokens[2],
          action_tokens[3],
          action_tokens[4],
        ),
      ),
    )
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-ens_processing" {
    return Ok((init, WriteEnsProcessing(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 5 && action_tokens[0] == "-ens_qc" {
    return Ok(
      (
        init,
        WriteEnsQc(
          action_tokens[1],
          action_tokens[2],
          action_tokens[3],
          action_tokens[4],
        ),
      ),
    )
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-ncep_norm" {
    return Ok((init, WriteNcepNorm(action_tokens[1])))
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-merge_fcst" {
    return Ok((init, WriteMergeFcst(action_tokens[1], action_tokens[2])))
  }
  if action_tokens.length() == 4 && action_tokens[0] == "-unmerge_fcst" {
    return Ok(
      (
        init,
        WriteUnmergeFcst(action_tokens[1], action_tokens[2], action_tokens[3]),
      ),
    )
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-wind_speed" {
    return Ok((init, WriteWindSpeed(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-wind_dir" {
    return Ok((init, WriteWindDir(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-wind_uv" {
    return Ok((init, WriteWindUv(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-text" {
    return Ok((init, WriteText(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-csv" {
    return Ok((init, WriteCsv(action_tokens[1], false)))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-csv_long" {
    return Ok((init, WriteCsv(action_tokens[1], true)))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-spread" {
    return Ok((init, WriteSpread(action_tokens[1])))
  }
  if action_tokens.length() == 2 &&
    (action_tokens[0] == "-AAIG" || action_tokens[0] == "-AAIGlong") {
    return Ok(
      (init, WriteAaig(action_tokens[1], action_tokens[0] == "-AAIGlong")),
    )
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-gridout" {
    return Ok((init, WriteGridout(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-netcdf" {
    return Ok((init, WriteNetcdf(action_tokens[1])))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-gribtable_used" {
    return Ok((init, WriteGribtableUsed(action_tokens[1])))
  }
  if action_tokens.length() == 6 && action_tokens[0] == "-mysql" {
    return Ok((init, WriteMysql))
  }
  if action_tokens.length() == 8 && action_tokens[0] == "-mysql_dump" {
    return Ok((init, WriteMysqlDump))
  }
  if action_tokens.length() == 8 && action_tokens[0] == "-mysql_speed" {
    return Ok((init, WriteMysqlSpeed))
  }
  if action_tokens.length() == 2 && action_tokens[0] == "-export_lonlat" {
    return Ok((init, WriteExportLonlat(action_tokens[1])))
  }
  if action_tokens.length() == 3 && action_tokens[0] == "-write_sec" {
    match parse_int_option(action_tokens[1]) {
      Some(section) =>
        return Ok((init, WriteSection(section, action_tokens[2])))
      None => return Err("-write_sec requires numeric section")
    }
  }
  match parse_mode(action_tokens) {
    Some(mode) => Ok((init, Inventory(mode)))
    None => Err("unsupported action option")
  }
}

///|
fn parse_for_n_spec(spec : String) -> (Int, Int, Int)? {
  let parts : Array[String] = []
  for part in spec.split(":") {
    parts.push(part.to_string())
  }
  if parts.length() == 2 {
    match (parse_int_option(parts[0]), parse_int_option(parts[1])) {
      (Some(start), Some(end)) => Some((start, end, 1))
      _ => None
    }
  } else if parts.length() == 3 {
    match
      (
        parse_int_option(parts[0]),
        parse_int_option(parts[1]),
        parse_int_option(parts[2]),
      ) {
      (Some(start), Some(end), Some(step)) =>
        if step == 0 {
          None
        } else {
          Some((start, end, step))
        }
      _ => None
    }
  } else {
    None
  }
}

///|
fn in_for_n_range(record : Int, start : Int, end : Int, step : Int) -> Bool {
  if step > 0 {
    if record < start || record > end {
      return false
    }
    (record - start) % step == 0
  } else {
    if record > start || record < end {
      return false
    }
    (start - record) % -step == 0
  }
}

///|
fn apply_init_filters(
  lines : Array[String],
  init : CliInitOptions,
) -> Result[Array[String], String] {
  let mut filtered = lines
  match init.for_n {
    Some(spec) =>
      match parse_for_n_spec(spec) {
        Some((start, end, step)) => {
          let next : Array[String] = []
          for i = 0; i < filtered.length(); i = i + 1 {
            let n = i + 1
            if in_for_n_range(n, start, end, step) {
              next.push(filtered[i])
            }
          }
          filtered = next
        }
        None => return Err("invalid -for_n range: " + spec)
      }
    None => ()
  }
  for pattern in init.match_patterns {
    let next : Array[String] = []
    for line in filtered {
      if line.contains(pattern) {
        next.push(line)
      }
    }
    filtered = next
  }
  for pattern in init.not_patterns {
    let next : Array[String] = []
    for line in filtered {
      if !line.contains(pattern) {
        next.push(line)
      }
    }
    filtered = next
  }
  if init.stop_after_first && filtered.length() > 0 {
    filtered = [filtered[0]]
  }
  if (init.select_last || init.select_last0) && filtered.length() > 0 {
    filtered = [filtered[filtered.length() - 1]]
  }
  Ok(filtered)
}

///|
fn has_record_filters(init : CliInitOptions) -> Bool {
  if init.stop_after_first {
    return true
  }
  if init.select_last || init.select_last0 {
    return true
  }
  match init.for_n {
    Some(_) => true
    None => init.match_patterns.length() > 0 || init.not_patterns.length() > 0
  }
}

///|
fn build_selected_record_indices(
  context : @context.Grib2FileContext,
  init : CliInitOptions,
) -> Result[Array[Int]?, String] {
  if !has_record_filters(init) {
    return Ok(None)
  }
  let short_lines = @wgrib2_lib.render_inventory_lines(context, InventoryShort)
  let filtered = match apply_init_filters(short_lines, init) {
    Ok(lines) => lines
    Err(error) => return Err(error)
  }
  let records : Array[Int] = []
  let mut cursor = 0
  for line in filtered {
    while cursor < short_lines.length() && short_lines[cursor] != line {
      cursor += 1
    }
    if cursor < short_lines.length() {
      records.push(cursor + 1)
      cursor += 1
    }
  }
  Ok(Some(records))
}

///|
fn record_is_selected(record_index : Int, selected : Array[Int]?) -> Bool {
  @common.record_is_selected(record_index, selected)
}

///|
fn build_config_lines() -> Array[String] {
  ["grib2_mbt config", "engine=moonbit", "compat=wgrib2-subset"]
}

///|
fn write_export_lonlat_output(
  destination : String,
  context : @context.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let target_record = first_selected_record(selected)
  let records = @decode.decode_records(context)
  let mut found : @decode.Grib2RecordMeta? = None
  for meta in records {
    if meta.record_index == target_record {
      found = Some(meta)
      break
    }
  }
  let meta = match found {
    Some(v) => v
    None =>
      return Err(
        "record not found for -export_lonlat: " + target_record.to_string(),
      )
  }
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err(
      "-export_lonlat currently supports regular lat/lon grid (template 3.0)",
    )
  }
  let out : Array[Byte] = []
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      match grid_ij_to_latlon_from_meta(meta, i, j) {
        Some((lon, lat)) => {
          append_f32_bytes(out, lon, true)
          append_f32_bytes(out, lat, true)
        }
        None => ()
      }
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn parse_mode(args : Array[String]) -> @wgrib2_lib.Grib2InventoryMode? {
  if args.length() == 0 || (args.length() == 1 && args[0] == "-s") {
    return Some(InventoryShort)
  }
  if args.length() == 1 && args[0] == "-print" {
    return Some(InventoryShort)
  }
  if args.length() == 1 && args[0] == "-one_line" {
    return Some(InventoryShort)
  }
  if args.length() == 1 && args[0] == "-Sec0" {
    return Some(InventorySec0)
  }
  if args.length() == 1 && args[0] == "-Sec3" {
    return Some(InventorySec3)
  }
  if args.length() == 1 && args[0] == "-Sec4" {
    return Some(InventorySec4)
  }
  if args.length() == 1 && args[0] == "-Sec5" {
    return Some(InventorySec5)
  }
  if args.length() == 1 && args[0] == "-Sec6" {
    return Some(InventorySec6)
  }
  if args.length() == 1 && args[0] == "-Sec_len" {
    return Some(InventorySecLen)
  }
  if args.length() == 1 && args[0] == "-n" {
    return Some(InventoryN)
  }
  if args.length() == 1 && args[0] == "-range" {
    return Some(InventoryRange)
  }
  if args.length() == 1 && args[0] == "-var" {
    return Some(InventoryVar)
  }
  if args.length() == 1 && args[0] == "-lev" {
    return Some(InventoryLev)
  }
  if args.length() == 1 && args[0] == "-ftime" {
    return Some(InventoryFtime)
  }
  if args.length() == 1 && args[0] == "-t" {
    return Some(InventoryT)
  }
  if args.length() == 1 && args[0] == "-vt" {
    return Some(InventoryVt)
  }
  if args.length() == 1 && args[0] == "-T" {
    return Some(InventoryTFull)
  }
  if args.length() == 1 && args[0] == "-VT" {
    return Some(InventoryVtFull)
  }
  if args.length() == 1 && args[0] == "-YY" {
    return Some(InventoryYY)
  }
  if args.length() == 1 && args[0] == "-MM" {
    return Some(InventoryMM)
  }
  if args.length() == 1 && args[0] == "-RT" {
    return Some(InventoryRT)
  }
  if args.length() == 1 && args[0] == "-start_ft" {
    return Some(InventoryStartFt)
  }
  if args.length() == 1 && args[0] == "-start_FT" {
    return Some(InventoryStartFT)
  }
  if args.length() == 1 && args[0] == "-end_ft" {
    return Some(InventoryEndFt)
  }
  if args.length() == 1 && args[0] == "-end_FT" {
    return Some(InventoryEndFT)
  }
  if args.length() == 1 && args[0] == "-S" {
    return Some(InventoryS)
  }
  if args.length() == 1 && args[0] == "-verf" {
    return Some(InventoryVerf)
  }
  if args.length() == 1 && args[0] == "-unix_time" {
    return Some(InventoryUnixTime)
  }
  if args.length() == 1 && args[0] == "-grid" {
    return Some(InventoryGrid)
  }
  if args.length() == 1 && args[0] == "-pdt" {
    return Some(InventoryPdt)
  }
  if args.length() == 1 && args[0] == "-process" {
    return Some(InventoryProcess)
  }
  if args.length() == 1 && args[0] == "-ens" {
    return Some(InventoryEns)
  }
  if args.length() == 1 && args[0] == "-prob" {
    return Some(InventoryProb)
  }
  if args.length() == 1 && args[0] == "-disc" {
    return Some(InventoryDisc)
  }
  if args.length() == 1 && args[0] == "-center" {
    return Some(InventoryCenter)
  }
  if args.length() == 1 && args[0] == "-subcenter" {
    return Some(InventorySubcenter)
  }
  if args.length() == 1 && args[0] == "-packing" {
    return Some(InventoryPacking)
  }
  if args.length() == 1 && args[0] == "-bitmap" {
    return Some(InventoryBitmap)
  }
  if args.length() == 1 && args[0] == "-nxny" {
    return Some(InventoryNxny)
  }
  if args.length() == 1 && args[0] == "-npts" {
    return Some(InventoryNpts)
  }
  if args.length() == 2 && args[0] == "-var" && args[1] == "-lev" {
    return Some(InventoryVarLev)
  }
  if args.length() == 1 && args[0] == "-code_table_0.0" {
    return Some(InventoryCodeTable00)
  }
  if args.length() == 1 && args[0] == "-code_table_1.0" {
    return Some(InventoryCodeTable10)
  }
  if args.length() == 1 && args[0] == "-code_table_1.1" {
    return Some(InventoryCodeTable11)
  }
  if args.length() == 1 && args[0] == "-code_table_1.2" {
    return Some(InventoryCodeTable12)
  }
  if args.length() == 1 && args[0] == "-code_table_1.3" {
    return Some(InventoryCodeTable13)
  }
  if args.length() == 1 && args[0] == "-code_table_1.4" {
    return Some(InventoryCodeTable14)
  }
  if args.length() == 1 && args[0] == "-code_table_3.0" {
    return Some(InventoryCodeTable30)
  }
  if args.length() == 1 && args[0] == "-code_table_3.1" {
    return Some(InventoryCodeTable31)
  }
  if args.length() == 1 && args[0] == "-code_table_6.0" {
    return Some(InventoryCodeTable60)
  }
  if args.length() == 1 && args[0] == "-code_table_4.0" {
    return Some(InventoryCodeTable40)
  }
  if args.length() == 1 && args[0] == "-code_table_4.1" {
    return Some(InventoryCodeTable41)
  }
  if args.length() == 1 && args[0] == "-code_table_4.2" {
    return Some(InventoryCodeTable42)
  }
  if args.length() == 1 && args[0] == "-code_table_4.3" {
    return Some(InventoryCodeTable43)
  }
  if args.length() == 1 && args[0] == "-code_table_4.4" {
    return Some(InventoryCodeTable44)
  }
  if args.length() == 1 && args[0] == "-code_table_5.0" {
    return Some(InventoryCodeTable50)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.3" {
    return Some(InventoryFlagTable33)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.4" {
    return Some(InventoryFlagTable34)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.5" {
    return Some(InventoryFlagTable35)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.9" {
    return Some(InventoryFlagTable39)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.10" {
    return Some(InventoryFlagTable310)
  }
  if args.length() == 1 && args[0] == "-scan" {
    return Some(InventoryScan)
  }
  if args.length() == 1 && args[0] == "-ext_name" {
    return Some(InventoryExtName)
  }
  if args.length() == 1 && args[0] == "-full_name" {
    return Some(InventoryFullName)
  }
  if args.length() == 1 && args[0] == "-lev0" {
    return Some(InventoryLev0)
  }
  if args.length() == 1 && args[0] == "-cyclic" {
    return Some(InventoryCyclic)
  }
  if args.length() == 1 && args[0] == "-domain" {
    return Some(InventoryDomain)
  }
  if args.length() == 1 && args[0] == "-scale" {
    return Some(InventoryScale)
  }
  if args.length() == 1 && args[0] == "-scaling" {
    return Some(InventoryScaling)
  }
  if args.length() == 1 && args[0] == "-radius" {
    return Some(InventoryRadius)
  }
  if args.length() == 1 && args[0] == "-varX" {
    return Some(InventoryVarX)
  }
  if args.length() == 1 && args[0] == "-grid_id" {
    return Some(InventoryGridId)
  }
  if args.length() == 1 && args[0] == "-nl" {
    return Some(InventoryNl)
  }
  if args.length() == 1 && args[0] == "-misc" {
    return Some(InventoryMisc)
  }
  if args.length() == 1 && args[0] == "-Match_inv" {
    return Some(InventoryMatchInv)
  }
  if args.length() == 1 && args[0] == "-match_inv" {
    return Some(InventoryMatchInv)
  }
  if args.length() == 1 && args[0] == "-code_table_3.2" {
    return Some(InventoryCodeTable32)
  }
  if args.length() == 1 && args[0] == "-code_table_4.5a" {
    return Some(InventoryCodeTable45a)
  }
  if args.length() == 1 && args[0] == "-code_table_4.5b" {
    return Some(InventoryCodeTable45b)
  }
  if args.length() == 1 && args[0] == "-code_table_1.5" {
    return Some(InventoryCodeTable15)
  }
  if args.length() == 1 && args[0] == "-code_table_1.6" {
    return Some(InventoryCodeTable16)
  }
  if args.length() == 1 && args[0] == "-code_table_4.6" {
    return Some(InventoryCodeTable46)
  }
  if args.length() == 1 && args[0] == "-code_table_4.9" {
    return Some(InventoryCodeTable49)
  }
  if args.length() == 1 && args[0] == "-code_table_4.10" {
    return Some(InventoryCodeTable410)
  }
  if args.length() == 1 && args[0] == "-code_table_4.11" {
    return Some(InventoryCodeTable411)
  }
  if args.length() == 1 && args[0] == "-code_table_3.11" {
    return Some(InventoryCodeTable311)
  }
  if args.length() == 1 && args[0] == "-code_table_5.1" {
    return Some(InventoryCodeTable51)
  }
  if args.length() == 1 && args[0] == "-code_table_3.6" {
    return Some(InventoryCodeTable36)
  }
  if args.length() == 1 && args[0] == "-code_table_3.7" {
    return Some(InventoryCodeTable37)
  }
  if args.length() == 1 && args[0] == "-code_table_3.8" {
    return Some(InventoryCodeTable38)
  }
  if args.length() == 1 && args[0] == "-code_table_3.15" {
    return Some(InventoryCodeTable315)
  }
  if args.length() == 1 && args[0] == "-code_table_3.20" {
    return Some(InventoryCodeTable320)
  }
  if args.length() == 1 && args[0] == "-code_table_3.21" {
    return Some(InventoryCodeTable321)
  }
  if args.length() == 1 && args[0] == "-code_table_4.7" {
    return Some(InventoryCodeTable47)
  }
  if args.length() == 1 && args[0] == "-code_table_4.8" {
    return Some(InventoryCodeTable48)
  }
  if args.length() == 1 && args[0] == "-code_table_4.11s" {
    return Some(InventoryCodeTable411s)
  }
  if args.length() == 1 && args[0] == "-code_table_4.15" {
    return Some(InventoryCodeTable415)
  }
  if args.length() == 1 && args[0] == "-code_table_4.16" {
    return Some(InventoryCodeTable416)
  }
  if args.length() == 1 && args[0] == "-code_table_4.91" {
    return Some(InventoryCodeTable491)
  }
  if args.length() == 1 && args[0] == "-code_table_4.91b" {
    return Some(InventoryCodeTable491b)
  }
  if args.length() == 1 && args[0] == "-code_table_4.230" {
    return Some(InventoryCodeTable4230)
  }
  if args.length() == 1 && args[0] == "-code_table_4.233" {
    return Some(InventoryCodeTable4233)
  }
  if args.length() == 1 && args[0] == "-code_table_4.235" {
    return Some(InventoryCodeTable4235)
  }
  if args.length() == 1 && args[0] == "-code_table_4.240" {
    return Some(InventoryCodeTable4240)
  }
  if args.length() == 1 && args[0] == "-code_table_4.241" {
    return Some(InventoryCodeTable4241)
  }
  if args.length() == 1 && args[0] == "-code_table_4.242" {
    return Some(InventoryCodeTable4242)
  }
  if args.length() == 1 && args[0] == "-code_table_5.4" {
    return Some(InventoryCodeTable54)
  }
  if args.length() == 1 && args[0] == "-code_table_5.5" {
    return Some(InventoryCodeTable55)
  }
  if args.length() == 1 && args[0] == "-code_table_5.6" {
    return Some(InventoryCodeTable56)
  }
  if args.length() == 1 && args[0] == "-code_table_5.7" {
    return Some(InventoryCodeTable57)
  }
  if args.length() == 1 && args[0] == "-ftime1" {
    return Some(InventoryFtime1)
  }
  if args.length() == 1 && args[0] == "-s2" {
    return Some(InventoryS2)
  }
  if args.length() == 1 && args[0] == "-pds_fcst_time" {
    return Some(InventoryPdsFcstTime)
  }
  if args.length() == 1 && args[0] == "-type_reftime" {
    return Some(InventoryTypeReftime)
  }
  if args.length() == 1 && args[0] == "-table" {
    return Some(InventoryTable)
  }
  if args.length() == 1 && args[0] == "-vector_dir" {
    return Some(InventoryVectorDir)
  }
  if args.length() == 1 && args[0] == "-precision" {
    return Some(InventoryPrecision)
  }
  if args.length() == 1 &&
    args[0] == "-number_of_coordinate_values_after_template" {
    return Some(InventoryNumCoordValues)
  }
  if args.length() == 1 && args[0] == "-N_ens" {
    return Some(InventoryNEns)
  }
  if args.length() == 1 && args[0] == "-N_clusters" {
    return Some(InventoryNClusters)
  }
  if args.length() == 1 && args[0] == "-aerosol_size" {
    return Some(InventoryAerosolSize)
  }
  if args.length() == 1 && args[0] == "-aerosol_wavelength" {
    return Some(InventoryAerosolWavelength)
  }
  if args.length() == 1 && args[0] == "-cluster" {
    return Some(InventoryCluster)
  }
  if args.length() == 1 && args[0] == "-cluster_info" {
    return Some(InventoryClusterInfo)
  }
  if args.length() == 1 && args[0] == "-model_version_date" {
    return Some(InventoryModelVersionDate)
  }
  if args.length() == 1 && args[0] == "-percent" {
    return Some(InventoryPercent)
  }
  if args.length() == 1 && args[0] == "-post_processing" {
    return Some(InventoryPostProcessing)
  }
  if args.length() == 1 && args[0] == "-spatial_proc" {
    return Some(InventorySpatialProc)
  }
  if args.length() == 1 && args[0] == "-spectral_bands" {
    return Some(InventorySpectralBands)
  }
  if args.length() == 1 && args[0] == "-spectral_bands_extname" {
    return Some(InventorySpectralBandsExtname)
  }
  if args.length() == 1 && args[0] == "-gdt" {
    return Some(InventoryGdt)
  }
  if args.length() == 1 && args[0] == "-timer" {
    return Some(InventoryTimer)
  }
  if args.length() == 1 && args[0] == "-ctl_inv" {
    return Some(InventoryCtlInv)
  }
  if args.length() == 1 && args[0] == "-pyinv" {
    return Some(InventoryPyinv)
  }
  if args.length() == 1 && args[0] == "-ctl_ens" {
    return Some(InventoryCtlEns)
  }
  if args.length() == 1 && args[0] == "-warn_old_g2" {
    return Some(InventoryWarnOldG2)
  }
  if args.length() == 1 && args[0] == "-wave_partition" {
    return Some(InventoryWavePartition)
  }
  if args.length() == 1 && args[0] == "-processid" {
    return Some(InventoryProcessId)
  }
  if args.length() == 1 && args[0] == "-ftime2" {
    return Some(InventoryFtime2)
  }
  if args.length() == 1 && args[0] == "-geolocation" {
    return Some(InventoryGeolocation)
  }
  if args.length() == 1 && args[0] == "-JMA" {
    return Some(InventoryJMA)
  }
  if args.length() == 1 && args[0] == "-JMA_Nb" {
    return Some(InventoryJMANb)
  }
  if args.length() == 1 && args[0] == "-JMA_Nr" {
    return Some(InventoryJMANr)
  }
  if args.length() == 1 && args[0] == "-reset_delayed_error" {
    return Some(InventoryResetDelayedError)
  }
  if args.length() == 1 && args[0] == "-ftn_api_fn0" {
    return Some(InventoryFtnApiFn0)
  }
  if args.length() == 1 && args[0] == "-grib_max_bits" {
    return Some(InventoryGribMaxBits)
  }
  if args.length() == 1 && args[0] == "-hybrid" {
    return Some(InventoryHybrid)
  }
  if args.length() == 1 && args[0] == "-V" {
    return Some(InventoryVerbose)
  }
  if args.length() == 1 && args[0] == "-crlf" {
    return Some(InventoryCrlf)
  }
  if args.length() == 1 && args[0] == "-inv" {
    return Some(InventoryInv)
  }
  if args.length() == 1 && args[0] == "-min" {
    return Some(InventoryMin)
  }
  if args.length() == 1 && args[0] == "-max" {
    return Some(InventoryMax)
  }
  if args.length() == 1 && args[0] == "-stats" {
    return Some(InventoryStats)
  }
  if args.length() == 1 && args[0] == "-nlons" {
    return Some(InventoryNlons)
  }
  // Position/location options
  if args.length() == 3 && args[0] == "-ij" {
    match (parse_int_option(args[1]), parse_int_option(args[2])) {
      (Some(i), Some(j)) => return Some(InventoryIJ(i, j))
      _ => ()
    }
  }
  if args.length() == 3 && args[0] == "-ijlat" {
    match (parse_int_option(args[1]), parse_int_option(args[2])) {
      (Some(i), Some(j)) => return Some(InventoryIJLat(i, j))
      _ => ()
    }
  }
  if args.length() == 2 && args[0] == "-ilat" {
    match parse_int_option(args[1]) {
      Some(idx) => return Some(InventoryILat(idx))
      _ => ()
    }
  }
  if args.length() == 3 && args[0] == "-lon" {
    match (parse_double_option(args[1]), parse_double_option(args[2])) {
      (Some(lon), Some(lat)) => return Some(InventoryLon(lon, lat))
      _ => ()
    }
  }
  if args.length() == 3 && args[0] == "-ll2ij" {
    match (parse_double_option(args[1]), parse_double_option(args[2])) {
      (Some(lon), Some(lat)) => return Some(InventoryLL2IJ(lon, lat))
      _ => ()
    }
  }
  if args.length() == 3 && args[0] == "-ll2i" {
    match (parse_double_option(args[1]), parse_double_option(args[2])) {
      (Some(lon), Some(lat)) => return Some(InventoryLL2I(lon, lat))
      _ => ()
    }
  }
  if args.length() == 3 && args[0] == "-proj4_ij2ll" {
    match (parse_int_option(args[1]), parse_int_option(args[2])) {
      (Some(i), Some(j)) => return Some(InventoryIJLat(i, j))
      _ => ()
    }
  }
  if args.length() == 3 && args[0] == "-proj4_ll2ij" {
    match (parse_double_option(args[1]), parse_double_option(args[2])) {
      (Some(lon), Some(lat)) => return Some(InventoryLL2IJ(lon, lat))
      _ => ()
    }
  }
  if args.length() == 3 && args[0] == "-proj4_ll2i" {
    match (parse_double_option(args[1]), parse_double_option(args[2])) {
      (Some(lon), Some(lat)) => return Some(InventoryLL2I(lon, lat))
      _ => ()
    }
  }
  // Hex dump options
  if args.length() == 2 && args[0] == "-0xSec" && args[1] == "0" {
    return Some(Inventory0xSec0)
  }
  if args.length() == 2 && args[0] == "-0xSec" && args[1] == "1" {
    return Some(Inventory0xSec1)
  }
  if args.length() == 2 && args[0] == "-0xSec" && args[1] == "3" {
    return Some(Inventory0xSec3)
  }
  if args.length() == 2 && args[0] == "-0xSec" && args[1] == "4" {
    return Some(Inventory0xSec4)
  }
  if args.length() == 2 && args[0] == "-0xSec" && args[1] == "5" {
    return Some(Inventory0xSec5)
  }
  if args.length() == 2 && args[0] == "-0xSec" && args[1] == "6" {
    return Some(Inventory0xSec6)
  }
  if args.length() == 2 && args[0] == "-0xSec" && args[1] == "7" {
    return Some(Inventory0xSec7)
  }
  // Checksum options
  if args.length() == 2 && args[0] == "-checksum" && args[1] == "0" {
    return Some(InventoryChecksum0)
  }
  if args.length() == 2 && args[0] == "-checksum" && args[1] == "1" {
    return Some(InventoryChecksum1)
  }
  if args.length() == 2 && args[0] == "-checksum" && args[1] == "3" {
    return Some(InventoryChecksum3)
  }
  if args.length() == 2 && args[0] == "-checksum" && args[1] == "4" {
    return Some(InventoryChecksum4)
  }
  if args.length() == 2 && args[0] == "-checksum" && args[1] == "5" {
    return Some(InventoryChecksum5)
  }
  if args.length() == 2 && args[0] == "-checksum" && args[1] == "6" {
    return Some(InventoryChecksum6)
  }
  if args.length() == 2 && args[0] == "-checksum" && args[1] == "7" {
    return Some(InventoryChecksum7)
  }
  // get_byte, get_hex, get_int, get_int2 options (require 3 arguments each)
  if args.length() == 4 && args[0] == "-get_byte" {
    match
      (
        parse_int_option(args[1]),
        parse_int_option(args[2]),
        parse_int_option(args[3]),
      ) {
      (Some(sec), Some(oct), Some(cnt)) =>
        return Some(InventoryGetByte(sec, oct, cnt))
      _ => ()
    }
  }
  if args.length() == 4 && args[0] == "-get_hex" {
    match
      (
        parse_int_option(args[1]),
        parse_int_option(args[2]),
        parse_int_option(args[3]),
      ) {
      (Some(sec), Some(oct), Some(cnt)) =>
        return Some(InventoryGetHex(sec, oct, cnt))
      _ => ()
    }
  }
  if args.length() == 4 && args[0] == "-get_int" {
    match
      (
        parse_int_option(args[1]),
        parse_int_option(args[2]),
        parse_int_option(args[3]),
      ) {
      (Some(sec), Some(oct), Some(cnt)) =>
        return Some(InventoryGetInt(sec, oct, cnt))
      _ => ()
    }
  }
  if args.length() == 4 && args[0] == "-get_int2" {
    match
      (
        parse_int_option(args[1]),
        parse_int_option(args[2]),
        parse_int_option(args[3]),
      ) {
      (Some(sec), Some(oct), Some(cnt)) =>
        return Some(InventoryGetInt2(sec, oct, cnt))
      _ => ()
    }
  }
  if args.length() == 4 && args[0] == "-get_ieee" {
    match
      (
        parse_int_option(args[1]),
        parse_int_option(args[2]),
        parse_int_option(args[3]),
      ) {
      (Some(sec), Some(oct), Some(cnt)) =>
        return Some(InventoryGetIeee(sec, oct, cnt))
      _ => ()
    }
  }
  None
}

///|
fn run_cli(args : Array[String]) -> Int {
  if args.length() == 2 && (args[1] == "-version" || args[1] == "--version") {
    println("grib2_mbt (wgrib2 compatibility target: v3.1.3)")
    return 0
  }
  if args.length() < 2 {
    print_usage()
    return 1
  }
  let file_path = args[1]
  let rest = if args.length() > 2 { [args[2], ..args[3:]] } else { [] }
  let invocation = match parse_cli_invocation(rest) {
    Ok(v) => v
    Err(error) => {
      println("error: " + error)
      return 3
    }
  }
  let (init, action) = invocation
  match action {
    WriteCubeface2Global | WriteMysql | WriteMysqlDump | WriteMysqlSpeed =>
      match unavailable_out_action_lines(action) {
        Some(lines) => {
          print_lines(lines)
          return 8
        }
        None => return 8
      }
    CountOnly => {
      let lines = match
        @io.render_inventory_lines_with_io(
          native_read_bytes,
          file_path,
          InventoryShort,
        ) {
        Ok(lines) => lines
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let filtered = match apply_init_filters(lines, init) {
        Ok(lines) => lines
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match error_final_message(init, filtered.length()) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      let out = filtered.length().to_string() + "\n"
      match init.inventory_path {
        Some(path) =>
          match native_write_string(path, out) {
            Ok(_) => return 0
            Err(error) => {
              println("error: " + error)
              return 2
            }
          }
        None => {
          println(filtered.length().to_string())
          return 0
        }
      }
    }
    ConfigOnly => {
      match error_final_message(init, 0) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      let out = build_output_content(build_config_lines(), init.crlf)
      match init.inventory_path {
        Some(path) => {
          let result = if init.append_mode {
            native_append_string(path, out)
          } else {
            native_write_string(path, out)
          }
          match result {
            Ok(_) => return 0
            Err(error) => {
              println("error: " + error)
              return 2
            }
          }
        }
        None => {
          if init.crlf {
            print_lines_crlf(build_config_lines())
          } else {
            print_lines(build_config_lines())
          }
          return 0
        }
      }
    }
    WriteRaw(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match write_raw_output(destination, context, selected, init.append_mode) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteGribOut(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_grib_out_output(destination, context, selected, init.append_mode) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteBin(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_binary_output(
          destination,
          context,
          selected,
          init.append_mode,
          resolve_binary_endian(init, false),
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteIeee(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_binary_output(
          destination,
          context,
          selected,
          init.append_mode,
          resolve_binary_endian(init, true),
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteGribIeee(prefix) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_grib_ieee_output(prefix, context, selected, init.append_mode) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteIjbox(i_spec, j_spec, destination, mode) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_ijbox_output(
          i_spec,
          j_spec,
          destination,
          mode,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteIjsmallGrib(i_spec, j_spec, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_ijsmall_grib_output(
          i_spec,
          j_spec,
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteSmallGrib(lon_spec, lat_spec, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_small_grib_output(
          lon_spec,
          lat_spec,
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteLola(lon_spec, lat_spec, destination, mode) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_lola_output(
          lon_spec,
          lat_spec,
          destination,
          mode,
          context,
          selected,
          init.crlf,
          init.append_mode,
          init.text_col,
          init.text_fmt,
          resolve_binary_endian(init, false),
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteCressLola(lon_spec, lat_spec, destination, radii_spec) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_cress_lola_output(
          lon_spec,
          lat_spec,
          destination,
          radii_spec,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteGribOutIrr(selector, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_grib_out_irr_output(
          selector,
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteIrrGrid(requested_points, radius, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_irr_grid_output(
          requested_points,
          radius,
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteGribOutIrr2(npnts, grid_no, grid_ref, uuid, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_grib_out_irr2_output(
          npnts,
          grid_no,
          grid_ref,
          uuid,
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteNewGrid(projection, lon_spec, lat_spec, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_new_grid_output(
          projection,
          lon_spec,
          lat_spec,
          destination,
          init.new_grid_interpolation,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteNewGridOrder(out_path, out2_path) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_new_grid_order_output(
          out_path,
          out2_path,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteSubmsgUv(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_vector_combine_output(
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteNcepUv(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_vector_combine_output(
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteReducedGaussianGrid(destination, y_arg, interp_method) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_reduced_gaussian_grid_output(
          destination,
          y_arg,
          interp_method,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteNcepNorm(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_ncep_norm_output(destination, context, selected, init.append_mode) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteAve(time_step_spec, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_time_processing_metadata_output(
          "-ave",
          destination,
          context,
          selected,
          0,
          1,
          time_step_spec,
          false,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteAve0(time_step_spec, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_time_processing_metadata_output(
          "-ave0",
          destination,
          context,
          selected,
          0,
          1,
          time_step_spec,
          true,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteAveVar(time_step_spec, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_ave_var_output(
          destination,
          context,
          selected,
          time_step_spec,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteFcstAve(time_step_spec, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_time_processing_metadata_output(
          "-fcst_ave",
          destination,
          context,
          selected,
          0,
          2,
          time_step_spec,
          false,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteFcstAve0(time_step_spec, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_time_processing_metadata_output(
          "-fcst_ave0",
          destination,
          context,
          selected,
          0,
          2,
          time_step_spec,
          true,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteTimeProcessing(
      statistical_process_arg,
      type_of_time_increment_arg,
      time_step_spec,
      destination
    ) => {
      let statistical_process = match
        parse_int_option(statistical_process_arg) {
        Some(v) => v
        None => {
          println("error: -time_processing: bad code table 4.10")
          return 2
        }
      }
      if statistical_process < 0 || statistical_process > 255 {
        println("error: -time_processing: code table 4.10 must be 0..255")
        return 2
      }
      let type_of_time_increment = match
        parse_int_option(type_of_time_increment_arg) {
        Some(v) => v
        None => {
          println("error: -time_processing: bad code table 4.11")
          return 2
        }
      }
      if type_of_time_increment < 0 || type_of_time_increment > 255 {
        println("error: -time_processing: code table 4.11 must be 0..255")
        return 2
      }
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_time_processing_metadata_output(
          "-time_processing",
          destination,
          context,
          selected,
          statistical_process,
          type_of_time_increment,
          time_step_spec,
          false,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteEnsProcessing(destination, mode_arg) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_ens_processing_output(
          destination,
          context,
          selected,
          mode_arg,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteEnsQc(
      stats_destination,
      extreme_destination,
      txt_destination,
      qc_version_arg
    ) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_ens_qc_output(
          stats_destination,
          extreme_destination,
          txt_destination,
          context,
          selected,
          qc_version_arg,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteMergeFcst(intervals, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_merge_fcst_output(
          intervals,
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteUnmergeFcst(destination, fcst_time_0, z_arg) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_unmerge_fcst_output(
          destination,
          fcst_time_0,
          z_arg,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteWindSpeed(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_wind_derived_output(
          destination,
          context,
          selected,
          WindDerivedSpeed,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteWindDir(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_wind_derived_output(
          destination,
          context,
          selected,
          WindDerivedDir,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteWindUv(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_wind_uv_output(destination, context, selected, init.append_mode) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteToSubmsg(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_tosubmsg_output(destination, context, selected, init.append_mode) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteText(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_text_output(
          destination,
          context,
          selected,
          init.crlf,
          init.append_mode,
          init.no_header,
          init.text_col,
          init.text_fmt,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteCsv(destination, long_mode) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_csv_output(
          destination,
          context,
          selected,
          long_mode,
          init.crlf,
          init.append_mode,
          init.no_header,
          init.text_fmt,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteSpread(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_spread_output(
          destination,
          context,
          selected,
          init.crlf,
          init.append_mode,
          init.text_fmt,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteAaig(destination, long_name) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_aaig_output(
          destination,
          context,
          selected,
          init.append_mode,
          long_name,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteSection(section, destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_section_output(
          destination,
          context,
          selected,
          section,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
    }
    WriteGridout(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_gridout_output(destination, context, selected, init.append_mode) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteNetcdf(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match netcdf_wgrib2_fatal_lines(context, selected) {
        Some(lines) => {
          print_lines(lines)
          return 8
        }
        None => ()
      }
      match netcdf_wgrib2_notice_lines(context, selected) {
        Some(lines) => print_lines(lines)
        None => ()
      }
      match
        write_netcdf_output(destination, context, selected, init.append_mode) {
        Ok(Some(reason)) => {
          print_lines(
            netcdf_wgrib2_fatal_lines_for_reason(context, selected, reason),
          )
          return 8
        }
        Ok(None) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteGribtableUsed(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_gribtable_used_output(
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteExportLonlat(destination) => {
      let context = match @io.parse_with_io(native_read_bytes, file_path) {
        Ok(context) => context
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let selected = match build_selected_record_indices(context, init) {
        Ok(v) => v
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      match
        error_final_message(init, selected_record_count(context, selected)) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match
        write_export_lonlat_output(
          destination,
          context,
          selected,
          init.append_mode,
        ) {
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    Inventory(mode) => {
      let lines = match
        @io.render_inventory_lines_with_io(native_read_bytes, file_path, mode) {
        Ok(lines) => lines
        Err(error) => {
          println("error: " + error.to_string())
          return 2
        }
      }
      let filtered = match apply_init_filters(lines, init) {
        Ok(lines) => lines
        Err(error) => {
          println("error: " + error)
          return 3
        }
      }
      let rendered = apply_inventory_colon(filtered, init.colon_delimiter)
      match error_final_message(init, filtered.length()) {
        Some(error) => {
          println("error: " + error)
          return 8
        }
        None => ()
      }
      match (init.print_out_text, init.print_out_path) {
        (Some(text), Some(path)) => {
          let eol = if init.crlf { "\r\n" } else { "\n" }
          let content = text + eol
          let result = if init.append_mode {
            native_append_string(path, content)
          } else {
            native_write_string(path, content)
          }
          match result {
            Ok(_) => ()
            Err(error) => {
              println("error: " + error)
              return 2
            }
          }
        }
        _ => ()
      }
      match init.nl_out_path {
        Some(path) => {
          let eol = if init.crlf { "\r\n" } else { "\n" }
          let result = if init.append_mode {
            native_append_string(path, eol)
          } else {
            native_write_string(path, eol)
          }
          match result {
            Ok(_) => ()
            Err(error) => {
              println("error: " + error)
              return 2
            }
          }
        }
        None => ()
      }
      match init.inventory_path {
        Some(path) =>
          match init.inv_f77_width {
            Some(width) => {
              let mode = match init.inv_f77_mode {
                Some(v) => v
                None => "bin"
              }
              match
                write_inv_f77_output(
                  path,
                  rendered,
                  mode,
                  width,
                  init.append_mode,
                ) {
                Ok(_) => return 0
                Err(error) => {
                  println("error: " + error)
                  return 2
                }
              }
            }
            None => {
              let content = build_inventory_output_content(
                rendered,
                init.crlf,
                init.one_line,
              )
              match native_write_string(path, content) {
                Ok(_) => return 0
                Err(error) => {
                  println("error: " + error)
                  return 2
                }
              }
            }
          }
        None => {
          if init.one_line {
            if rendered.length() > 0 {
              let line = rendered.join(" ")
              if init.crlf {
                println(line + "\r")
              } else {
                println(line)
              }
            }
          } else if init.crlf {
            print_lines_crlf(rendered)
          } else {
            print_lines(rendered)
          }
          return 0
        }
      }
    }
  }
}

///|
fn main {
  let args = @sys.get_cli_args()
  let exit_code = run_cli(args)
  @sys.exit(exit_code)
}
