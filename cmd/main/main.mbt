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
  for line in lines {
    println(line)
  }
}

///|
fn print_lines_crlf(lines : Array[String]) -> Unit {
  for line in lines {
    println(line + "\r")
  }
}

///|
fn parse_int_option(s : String) -> Int? {
  Some(@strconv.parse_int(s)) catch {
    _ => None
  }
}

///|
fn parse_double_option(s : String) -> Double? {
  Some(@strconv.parse_double(s)) catch {
    _ => None
  }
}

///|
fn native_read_bytes(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    error => Err("failed to read file: " + error.to_string())
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
fn native_write_bytes(path : String, bytes : Bytes) -> Result[Unit, String] {
  try @fs.write_bytes_to_file(path, bytes) catch {
    error => Err("failed to write file: " + error.to_string())
  } noraise {
    _ => Ok(())
  }
}

///|
fn native_write_string(path : String, content : String) -> Result[Unit, String] {
  try @fs.write_string_to_file(path, content) catch {
    error => Err("failed to write file: " + error.to_string())
  } noraise {
    _ => Ok(())
  }
}

///|
enum CliAction {
  Inventory(@lib.Grib2InventoryMode)
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
  context : @lib.Grib2FileContext,
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
    40 =>
      Some([
        meta.record_id + ":" + meta.message_offset.to_string(),
        "*** FATAL ERROR: netcdf: only works in we:sn order ***",
        "",
      ])
    _ => None
  }
}

///|
fn netcdf_wgrib2_default_inventory_line(meta : @lib.Grib2RecordMeta) -> String {
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
  context : @lib.Grib2FileContext,
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
        netcdf_wgrib2_default_inventory_line(meta),
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
  context : @lib.Grib2FileContext,
  init : CliInitOptions,
) -> Result[Array[Int]?, String] {
  if !has_record_filters(init) {
    return Ok(None)
  }
  let short_lines = @lib.render_inventory_lines(context, InventoryShort)
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
  match selected {
    None => true
    Some(records) => {
      for n in records {
        if n == record_index {
          return true
        }
      }
      false
    }
  }
}

///|
fn section_frame_bytes(
  message : @lib.Grib2MessageContext,
  frame : @lib.Grib2SectionFrame,
) -> Bytes {
  let start = frame.start - message.offset
  let end = frame.end_offset() - message.offset
  message.raw.sub(start~, end~).to_bytes()
}

///|
fn get_record_section_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  section : Int,
) -> Bytes? {
  match section {
    0 => {
      let sec0_length = message.section1.start - message.offset
      if sec0_length > 0 {
        Some(message.raw.sub(start=0, end=sec0_length).to_bytes())
      } else {
        None
      }
    }
    1 => Some(section_frame_bytes(message, message.section1))
    2 =>
      match submessage.section2 {
        Some(sec2) => Some(section_frame_bytes(message, sec2))
        None => None
      }
    3 => Some(section_frame_bytes(message, submessage.section3))
    4 => Some(section_frame_bytes(message, submessage.section4))
    5 => Some(section_frame_bytes(message, submessage.section5))
    6 => Some(section_frame_bytes(message, submessage.section6))
    7 => Some(section_frame_bytes(message, submessage.section7))
    8 => Some(Bytes::from_array([b'7', b'7', b'7', b'7']))
    _ => None
  }
}

///|
fn append_bytes(out : Array[Byte], bytes : Bytes) -> Unit {
  for b in bytes {
    out.push(b)
  }
}

///|
fn build_sec0_with_length(
  message : @lib.Grib2MessageContext,
  total_len : Int,
) -> Bytes {
  let out : Array[Byte] = []
  // Copy original section 0 bytes (16 bytes) and patch octets 9-16 with total length.
  for i in 0..<16 {
    out.push(message.raw[i])
  }
  // High 32bits are zero in this implementation.
  out[8] = b'\x00'
  out[9] = b'\x00'
  out[10] = b'\x00'
  out[11] = b'\x00'
  let low = total_len.to_uint()
  out[12] = ((low >> 24) & 0xFF).reinterpret_as_int().to_byte()
  out[13] = ((low >> 16) & 0xFF).reinterpret_as_int().to_byte()
  out[14] = ((low >> 8) & 0xFF).reinterpret_as_int().to_byte()
  out[15] = (low & 0xFF).reinterpret_as_int().to_byte()
  Bytes::from_array(out)
}

///|
fn build_submessage_grib_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
) -> Bytes {
  let sec1 = section_frame_bytes(message, message.section1)
  let sec2 = match submessage.section2 {
    Some(s) => section_frame_bytes(message, s)
    None => Bytes::new(0)
  }
  let sec3 = section_frame_bytes(message, submessage.section3)
  let sec4 = section_frame_bytes(message, submessage.section4)
  let sec5 = section_frame_bytes(message, submessage.section5)
  let sec6 = section_frame_bytes(message, submessage.section6)
  let sec7 = section_frame_bytes(message, submessage.section7)
  let body_len = sec1.length() +
    sec2.length() +
    sec3.length() +
    sec4.length() +
    sec5.length() +
    sec6.length() +
    sec7.length()
  let total_len = 16 + body_len + 4
  let sec0 = build_sec0_with_length(message, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, sec1)
  append_bytes(out, sec2)
  append_bytes(out, sec3)
  append_bytes(out, sec4)
  append_bytes(out, sec5)
  append_bytes(out, sec6)
  append_bytes(out, sec7)
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  Bytes::from_array(out)
}

///|
fn build_submessage_grib_bytes_with_overrides(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  section4_override : Bytes?,
  section5_override : Bytes?,
  section6_override : Bytes?,
  section7_override : Bytes?,
) -> Bytes {
  build_submessage_grib_bytes_with_section_overrides(
    message,
    submessage,
    None,
    section4_override,
    section5_override,
    section6_override,
    section7_override,
  )
}

///|
fn build_submessage_grib_bytes_with_section_overrides(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  section3_override : Bytes?,
  section4_override : Bytes?,
  section5_override : Bytes?,
  section6_override : Bytes?,
  section7_override : Bytes?,
) -> Bytes {
  let sec1 = section_frame_bytes(message, message.section1)
  let sec2 = match submessage.section2 {
    Some(s) => section_frame_bytes(message, s)
    None => Bytes::new(0)
  }
  let sec3 = match section3_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section3)
  }
  let sec4 = match section4_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section4)
  }
  let sec5 = match section5_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section5)
  }
  let sec6 = match section6_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section6)
  }
  let sec7 = match section7_override {
    Some(v) => v
    None => section_frame_bytes(message, submessage.section7)
  }
  let body_len = sec1.length() +
    sec2.length() +
    sec3.length() +
    sec4.length() +
    sec5.length() +
    sec6.length() +
    sec7.length()
  let total_len = 16 + body_len + 4
  let sec0 = build_sec0_with_length(message, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, sec1)
  append_bytes(out, sec2)
  append_bytes(out, sec3)
  append_bytes(out, sec4)
  append_bytes(out, sec5)
  append_bytes(out, sec6)
  append_bytes(out, sec7)
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  Bytes::from_array(out)
}

///|
fn write_raw_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        append_bytes(out, build_submessage_grib_bytes(message, submessage))
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_grib_out_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let metas = @lib.decode_records(context)
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -grib_out record " +
            record_index.to_string(),
          )
        }
        let bytes = match
          build_grib_out_submessage_bytes(
            message,
            submessage,
            metas[meta_index],
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, bytes)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
priv struct GribIeeeRecordOutput {
  grb : Bytes
  head : Bytes
  tail : Bytes
  ndata : Int
  sec1_offset : Int
  sec2_offset : Int?
  sec3_offset : Int
  sec4_offset : Int
  sec5_offset : Int
  sec6_offset : Int
  sec7_offset : Int
  sec0_prefix : Bytes
  sec1 : Bytes
  sec2 : Bytes?
  sec3 : Bytes
  sec4 : Bytes
}

///|
fn grib_ieee_payload_bytes(values : Array[Double]) -> Bytes {
  let out : Array[Byte] = []
  for value in values {
    if value != value {
      out.push(b'\xff')
      out.push(b'\xff')
      out.push(b'\xff')
      out.push(b'\xff')
    } else {
      append_f32_bytes(out, value, true)
    }
  }
  Bytes::from_array(out)
}

///|
fn render_c_byte_lines(
  bytes : Bytes,
  indent : String,
  per_line : Int,
  trailing_space : Bool,
) -> Array[String] {
  let lines : Array[String] = []
  if bytes.length() == 0 {
    lines.push(indent)
    return lines
  }
  let mut current = indent
  let mut count = 0
  for i in 0..<bytes.length() {
    if count > 0 {
      current += " "
    }
    current += bytes[i].to_int().to_string() + ","
    count += 1
    if count == per_line && i + 1 < bytes.length() {
      if trailing_space {
        current += " "
      }
      lines.push(current)
      current = indent
      count = 0
    }
  }
  if count > 0 {
    if trailing_space {
      current += " "
    }
    lines.push(current)
  }
  lines
}

///|
fn render_c_inline_byte_array(bytes : Bytes) -> String {
  let parts : Array[String] = []
  for b in bytes {
    parts.push(b.to_int().to_string())
  }
  "{ " + parts.join(", ") + ", }"
}

///|
fn render_c_fixed_byte_array(bytes : Bytes) -> String {
  let parts : Array[String] = []
  for b in bytes {
    parts.push(b.to_int().to_string())
  }
  "{" + parts.join(", ") + "}"
}

///|
fn append_rendered_c_array(
  lines : Array[String],
  open_line : String,
  bytes : Bytes,
  indent : String,
  per_line : Int,
  trailing_space : Bool,
) -> Unit {
  lines.push(open_line)
  let rendered = render_c_byte_lines(bytes, indent, per_line, trailing_space)
  for i in 0..<rendered.length() {
    let suffix = if i + 1 == rendered.length() { "};" } else { "" }
    lines.push(rendered[i] + suffix)
  }
}

///|
fn build_grib_ieee_header_text(record : GribIeeeRecordOutput) -> String {
  let lines : Array[String] = []
  append_rendered_c_array(
    lines,
    "unsigned char head[] = {",
    record.head,
    " ",
    20,
    false,
  )
  lines.push("")
  lines.push(
    "unsigned char tail[4] = " + render_c_fixed_byte_array(record.tail) + ";",
  )
  lines.push("")
  lines.push("#define NDATA " + record.ndata.to_string())
  lines.push("#define SEC0 0")
  lines.push("#define DISCIPLINE 6")
  lines.push("#define EDITION 7")
  lines.push("#define SEC1 " + record.sec1_offset.to_string())
  lines.push("#define CENTER " + (record.sec1_offset + 5).to_string())
  lines.push("#define SUBCENTER " + (record.sec1_offset + 7).to_string())
  lines.push("#define MASTERTABLE " + (record.sec1_offset + 9).to_string())
  // wgrib2's emitted header keeps LOCALTABLE at the same offset as MASTERTABLE.
  lines.push("#define LOCALTABLE " + (record.sec1_offset + 9).to_string())
  lines.push("#define YEAR " + (record.sec1_offset + 12).to_string())
  lines.push("#define MONTH " + (record.sec1_offset + 14).to_string())
  lines.push("#define DAY " + (record.sec1_offset + 15).to_string())
  lines.push("#define HOUR " + (record.sec1_offset + 16).to_string())
  lines.push("#define MINUTE " + (record.sec1_offset + 17).to_string())
  lines.push("#define SECOND " + (record.sec1_offset + 18).to_string())
  match record.sec2_offset {
    Some(offset) => lines.push("#define SEC2 " + offset.to_string())
    None => ()
  }
  lines.push("#define SEC3 " + record.sec3_offset.to_string())
  lines.push("#define SEC4 " + record.sec4_offset.to_string())
  lines.push(
    "#define PRODUCTDEFTEMPLATENUM " + (record.sec4_offset + 7).to_string(),
  )
  lines.push(
    "#define PRODUCTDEFTEMPLATE " + (record.sec4_offset + 9).to_string(),
  )
  lines.push("#define PRODUCTCATEGORY " + (record.sec4_offset + 9).to_string())
  lines.push("#define PRODUCTNUMBER " + (record.sec4_offset + 10).to_string())
  lines.push("#define SEC5 " + record.sec5_offset.to_string())
  lines.push("#define SEC6 " + record.sec6_offset.to_string())
  lines.push("#define SEC7 " + record.sec7_offset.to_string())
  lines.push(
    "unsigned char sec0[] = " +
    render_c_inline_byte_array(record.sec0_prefix) +
    ";",
  )
  lines.push(
    "unsigned char sec1[] = " + render_c_inline_byte_array(record.sec1) + ";",
  )
  match record.sec2 {
    Some(sec2) =>
      lines.push(
        "unsigned char sec2[] = " + render_c_inline_byte_array(sec2) + ";",
      )
    None => ()
  }
  append_rendered_c_array(
    lines,
    "unsigned char sec3[] = { ",
    record.sec3,
    "",
    20,
    true,
  )
  append_rendered_c_array(
    lines,
    "unsigned char sec4[] = { ",
    record.sec4,
    "",
    20,
    true,
  )
  lines.push(
    "unsigned char sec7[4] = " + render_c_fixed_byte_array(record.tail) + ";",
  )
  lines.join("\n") + "\n"
}

///|
fn build_grib_ieee_record_output(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  record_index : Int,
) -> Result[GribIeeeRecordOutput, String] {
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to unpack record " +
        record_index.to_string() +
        " (-grib_ieee): " +
        unpack_error_string(e),
      )
  }
  let sec1 = section_frame_bytes(message, message.section1)
  let sec2 = match submessage.section2 {
    Some(s) => Some(section_frame_bytes(message, s))
    None => None
  }
  let sec2_len = match sec2 {
    Some(sec2) => sec2.length()
    None => 0
  }
  let sec3 = section_frame_bytes(message, submessage.section3)
  let sec4 = section_frame_bytes(message, submessage.section4)
  let payload = grib_ieee_payload_bytes(unpacked.values)
  let sec5 = @lib.encode_section5_bytes({
    number_of_data_points: unpacked.values.length(),
    template: DataRepresentationTemplate54({ precision: 1, reserved_tail: b"" }),
  })
  let sec6 = @lib.encode_section6_bytes({
    bitmap_indicator: 255,
    bitmap_raw: b"",
  })
  let sec7 = @lib.encode_section7_bytes({
    template: DataTemplate74({ data_values_raw: payload }),
  })
  let grb = build_submessage_grib_bytes_with_overrides(
    message,
    submessage,
    Some(sec4),
    Some(sec5),
    Some(sec6),
    Some(sec7),
  )
  let sec0 = grb.sub(start=0, end=16).to_bytes()
  let sec7_header = sec7.sub(start=0, end=5).to_bytes()
  let head_out : Array[Byte] = []
  append_bytes(head_out, sec0)
  append_bytes(head_out, sec1)
  match sec2 {
    Some(sec2) => append_bytes(head_out, sec2)
    None => ()
  }
  append_bytes(head_out, sec3)
  append_bytes(head_out, sec4)
  append_bytes(head_out, sec5)
  append_bytes(head_out, sec6)
  append_bytes(head_out, sec7_header)
  let sec1_offset = 16
  let sec2_offset = if sec2_len > 0 {
    Some(sec1_offset + sec1.length())
  } else {
    None
  }
  let sec3_offset = sec1_offset + sec1.length() + sec2_len
  let sec4_offset = sec3_offset + sec3.length()
  let sec5_offset = sec4_offset + sec4.length()
  let sec6_offset = sec5_offset + sec5.length()
  let sec7_offset = sec6_offset + sec6.length()
  Ok({
    grb,
    head: Bytes::from_array(head_out),
    tail: Bytes::from_array([b'7', b'7', b'7', b'7']),
    ndata: unpacked.values.length(),
    sec1_offset,
    sec2_offset,
    sec3_offset,
    sec4_offset,
    sec5_offset,
    sec6_offset,
    sec7_offset,
    sec0_prefix: sec0.sub(start=0, end=8).to_bytes(),
    sec1,
    sec2,
    sec3,
    sec4,
  })
}

///|
fn write_grib_ieee_output(
  prefix : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let grb_path = prefix + ".grb"
  let head_path = prefix + ".head"
  let tail_path = prefix + ".tail"
  let h_path = prefix + ".h"
  let write_bytes = if append_mode {
    native_append_bytes
  } else {
    native_write_bytes
  }
  let write_text = if append_mode {
    native_append_string
  } else {
    native_write_string
  }
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let record = match
          build_grib_ieee_record_output(message, submessage, record_index) {
          Ok(record) => record
          Err(e) => return Err(e)
        }
        match write_bytes(grb_path, record.grb) {
          Ok(_) => ()
          Err(e) => return Err(e)
        }
        match write_bytes(head_path, record.head) {
          Ok(_) => ()
          Err(e) => return Err(e)
        }
        match write_bytes(tail_path, record.tail) {
          Ok(_) => ()
          Err(e) => return Err(e)
        }
        return write_text(h_path, build_grib_ieee_header_text(record))
      }
      record_index += 1
    }
  }
  Ok(())
}

///|
fn native_append_bytes(path : String, bytes : Bytes) -> Result[Unit, String] {
  let existing = @fs.read_file_to_bytes(path) catch { _ => Bytes::new(0) }
  let out : Array[Byte] = []
  for b in existing {
    out.push(b)
  }
  for b in bytes {
    out.push(b)
  }
  native_write_bytes(path, Bytes::from_array(out))
}

///|
fn native_append_string(
  path : String,
  content : String,
) -> Result[Unit, String] {
  let existing = @fs.read_file_to_string(path) catch { _ => "" }
  native_write_string(path, existing + content)
}

///|
fn build_output_content(lines : Array[String], crlf : Bool) -> String {
  if lines.length() == 0 {
    return ""
  }
  let eol = if crlf { "\r\n" } else { "\n" }
  lines.join(eol) + eol
}

///|
fn build_inventory_output_content(
  lines : Array[String],
  crlf : Bool,
  one_line : Bool,
) -> String {
  if !one_line {
    return build_output_content(lines, crlf)
  }
  if lines.length() == 0 {
    return ""
  }
  let eol = if crlf { "\r\n" } else { "\n" }
  lines.join(" ") + eol
}

///|
fn split_line_by_columns(line : String, columns : Int) -> Array[String] {
  if line.length() <= columns {
    return [line]
  }
  let out : Array[String] = []
  let mut start = 0
  while start < line.length() {
    let end = if start + columns < line.length() {
      start + columns
    } else {
      line.length()
    }
    out.push(line.substring(start~, end~).to_string())
    start += columns
  }
  out
}

///|
fn apply_inventory_colon(
  lines : Array[String],
  delimiter : String?,
) -> Array[String] {
  match delimiter {
    None => lines
    Some(d) => {
      let out : Array[String] = []
      for line in lines {
        out.push(line.replace_all(old=":", new=d))
      }
      out
    }
  }
}

///|
fn fixed_width_string(line : String, width : Int) -> String {
  if line.length() >= width {
    line.substring(end=width)
  } else {
    line + " ".repeat(width - line.length())
  }
}

///|
fn append_u32_bytes(out : Array[Byte], value : Int, big_endian : Bool) -> Unit {
  let bits = value.to_uint()
  if big_endian {
    out.push(((bits >> 24) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 16) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 8) & 0xFF).reinterpret_as_int().to_byte())
    out.push((bits & 0xFF).reinterpret_as_int().to_byte())
  } else {
    out.push((bits & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 8) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 16) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 24) & 0xFF).reinterpret_as_int().to_byte())
  }
}

///|
fn append_fixed_width_ascii(
  out : Array[Byte],
  line : String,
  width : Int,
) -> Unit {
  let padded = fixed_width_string(line, width)
  for c in padded {
    let code = c.to_int()
    let byte_code = if code >= 0 && code <= 255 { code } else { 63 }
    out.push(byte_code.to_byte())
  }
}

///|
fn write_inv_f77_output(
  path : String,
  lines : Array[String],
  mode : String,
  width : Int,
  append_mode : Bool,
) -> Result[Unit, String] {
  let big_endian = mode == "ieee"
  let out : Array[Byte] = []
  for line in lines {
    append_u32_bytes(out, width, big_endian)
    append_fixed_width_ascii(out, line, width)
    append_u32_bytes(out, width, big_endian)
  }
  let bytes = Bytes::from_array(out)
  if append_mode {
    native_append_bytes(path, bytes)
  } else {
    native_write_bytes(path, bytes)
  }
}

///|
fn format_data_value(v : Double) -> String {
  if v != v {
    "9.999e+20"
  } else {
    format_general(normalize_text_output_value(v), 6, false)
  }
}

///|
fn format_aaig_value(v : Double) -> String {
  if v != v {
    "999900026055400882176.000000"
  } else {
    format_fixed(normalize_text_output_value(v), 6)
  }
}

///|
fn round_half_even_positive(value : Double) -> Int {
  let floor_f = @math.floor(value)
  let floor = floor_f.to_int()
  let frac = value - floor_f
  let eps = 0.000001
  if frac > 0.5 + eps {
    floor + 1
  } else if frac < 0.5 - eps {
    floor
  } else if (floor & 1) == 0 {
    floor
  } else {
    floor + 1
  }
}

///|
fn format_fixed(value : Double, digits : Int) -> String {
  let sign = if value < 0.0 { "-" } else { "" }
  let abs_value = abs_double(value)
  if digits == 0 {
    let rounded = round_half_even_positive(abs_value)
    return sign + rounded.to_string()
  }
  let mut factor = 1.0
  for _ in 0..<digits {
    factor *= 10.0
  }
  let mut divisor = 1
  for _ in 0..<digits {
    divisor *= 10
  }
  let int_part_f = @math.floor(abs_value)
  let mut int_part = int_part_f.to_int()
  let frac_value = abs_value - int_part_f
  let mut frac_part = round_half_even_positive(frac_value * factor)
  if frac_part >= divisor {
    int_part += 1
    frac_part -= divisor
  }
  let frac = frac_part.to_string()
  let padding = "0".repeat(digits - frac.length())
  sign + int_part.to_string() + "." + padding + frac
}

///|
fn parse_text_format_spec(text_fmt : String?) -> (String, Int)? {
  match text_fmt {
    None => None
    Some(fmt) =>
      if fmt.length() < 2 || !fmt.has_prefix("%") {
        None
      } else {
        let verb = fmt.substring(start=fmt.length() - 1)
        let precision = if fmt.has_prefix("%.") && fmt.length() > 3 {
          match parse_int_option(fmt.substring(start=2, end=fmt.length() - 1)) {
            Some(n) => n
            None => return None
          }
        } else {
          -1
        }
        Some((verb, precision))
      }
  }
}

///|
fn abs_double(v : Double) -> Double {
  if v < 0.0 {
    -v
  } else {
    v
  }
}

///|
fn trim_fixed_zeros(s : String) -> String {
  if !s.contains(".") {
    return s
  }
  let mut out = s
  while out.has_suffix("0") {
    out = out.substring(end=out.length() - 1)
  }
  if out.has_suffix(".") {
    out = out.substring(end=out.length() - 1)
  }
  out
}

///|
fn scientific_components(abs_value : Double) -> (Double, Int) {
  if abs_value == 0.0 {
    return (0.0, 0)
  }
  let mut m = abs_value
  let mut e = 0
  while m >= 10.0 {
    m /= 10.0
    e += 1
  }
  while m < 1.0 {
    m *= 10.0
    e -= 1
  }
  (m, e)
}

///|
fn format_exponent(e : Int, upper : Bool) -> String {
  let sign = if e >= 0 { "+" } else { "-" }
  let abs_e = e.abs()
  let digits = if abs_e < 10 {
    "0" + abs_e.to_string()
  } else {
    abs_e.to_string()
  }
  let tag = if upper { "E" } else { "e" }
  tag + sign + digits
}

///|
fn format_scientific(
  value : Double,
  precision : Int,
  upper : Bool,
  trim_zeros : Bool,
) -> String {
  let sign = if value < 0.0 { "-" } else { "" }
  let (mantissa0, exp0) = scientific_components(abs_double(value))
  let mut mantissa = mantissa0
  let mut exp = exp0
  let mut body = format_fixed(mantissa, precision)
  // Rounding can produce 10.xxxx; renormalize to 1.xxxx and adjust exponent.
  if body.has_prefix("10.") {
    mantissa = 1.0
    exp += 1
    body = format_fixed(mantissa, precision)
  }
  if trim_zeros {
    body = trim_fixed_zeros(body)
  }
  sign + body + format_exponent(exp, upper)
}

///|
fn format_general(value : Double, precision : Int, upper : Bool) -> String {
  let p = if precision <= 0 { 1 } else { precision }
  let (_, exp) = scientific_components(abs_double(value))
  if exp < -4 || exp >= p {
    format_scientific(value, p - 1, upper, true)
  } else {
    let frac_digits = if p - (exp + 1) > 0 { p - (exp + 1) } else { 0 }
    trim_fixed_zeros(format_fixed(value, frac_digits))
  }
}

///|
fn format_data_value_with_fmt(v : Double, text_fmt : String?) -> String {
  if v != v {
    return "9.999e+20"
  }
  let value = normalize_text_output_value(v)
  match parse_text_format_spec(text_fmt) {
    None => format_data_value(value)
    Some((verb, precision_raw)) => {
      let default_precision = 6
      let precision = if precision_raw >= 0 {
        precision_raw
      } else {
        default_precision
      }
      if verb == "f" || verb == "F" {
        format_fixed(value, precision)
      } else if verb == "e" {
        format_scientific(value, precision, false, false)
      } else if verb == "E" {
        format_scientific(value, precision, true, false)
      } else if verb == "g" {
        format_general(value, precision, false)
      } else if verb == "G" {
        format_general(value, precision, true)
      } else {
        format_data_value(value)
      }
    }
  }
}

///|
fn format_timestamp_for_csv(ts : String) -> String {
  if ts.length() == 14 {
    ts.substring(end=4) +
    "-" +
    ts.substring(start=4, end=6) +
    "-" +
    ts.substring(start=6, end=8) +
    " " +
    ts.substring(start=8, end=10) +
    ":" +
    ts.substring(start=10, end=12) +
    ":" +
    ts.substring(start=12, end=14)
  } else {
    ts
  }
}

///|
fn pad_csv_timestamp2(value : Int) -> String {
  if value < 10 {
    "0" + value.to_string()
  } else {
    value.to_string()
  }
}

///|
fn pad_csv_timestamp4(value : Int) -> String {
  if value >= 1000 {
    value.to_string()
  } else if value >= 100 {
    "0" + value.to_string()
  } else if value >= 10 {
    "00" + value.to_string()
  } else {
    "000" + value.to_string()
  }
}

///|
fn is_csv_timestamp_leap_year(year : Int) -> Bool {
  (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
}

///|
fn csv_timestamp_days_in_month(year : Int, month : Int) -> Int {
  match month {
    1 => 31
    2 => if is_csv_timestamp_leap_year(year) { 29 } else { 28 }
    3 => 31
    4 => 30
    5 => 31
    6 => 30
    7 => 31
    8 => 31
    9 => 30
    10 => 31
    11 => 30
    12 => 31
    _ => 0
  }
}

///|
fn format_timestamp14_from_unix(unix_ts : Int64) -> String {
  let mut days = unix_ts / 86400L
  let mut seconds = unix_ts % 86400L
  if seconds < 0L {
    seconds += 86400L
    days -= 1L
  }
  let hour = (seconds / 3600L).to_int()
  seconds = seconds % 3600L
  let minute = (seconds / 60L).to_int()
  let second = (seconds % 60L).to_int()
  let mut year = 1970
  while true {
    let year_days = if is_csv_timestamp_leap_year(year) { 366L } else { 365L }
    if days < year_days {
      break
    }
    days -= year_days
    year += 1
  }
  let mut month = 1
  while true {
    let month_days = csv_timestamp_days_in_month(year, month).to_int64()
    if days < month_days {
      break
    }
    days -= month_days
    month += 1
  }
  let day = days.to_int() + 1
  pad_csv_timestamp4(year) +
  pad_csv_timestamp2(month) +
  pad_csv_timestamp2(day) +
  pad_csv_timestamp2(hour) +
  pad_csv_timestamp2(minute) +
  pad_csv_timestamp2(second)
}

///|
fn csv_long_forecast_offset_seconds(meta : @lib.Grib2RecordMeta) -> Int64? {
  if meta.tail.length() == 0 || meta.tail == "anl" {
    return Some(0L)
  }
  if meta.tail.has_suffix(" hour fcst") {
    let hours = meta.tail.substring(end=meta.tail.length() - 10)
    return match parse_int_option(hours) {
      Some(v) => Some(v.to_int64() * 3600L)
      None => None
    }
  }
  if meta.tail.has_suffix(" day fcst") {
    let days = meta.tail.substring(end=meta.tail.length() - 9)
    return match parse_int_option(days) {
      Some(v) => Some(v.to_int64() * 86400L)
      None => None
    }
  }
  None
}

///|
fn csv_long_verification_timestamp(meta : @lib.Grib2RecordMeta) -> String {
  match csv_long_forecast_offset_seconds(meta) {
    Some(offset) =>
      format_timestamp_for_csv(
        format_timestamp14_from_unix(meta.unix_rt + offset),
      )
    None => format_timestamp_for_csv(meta.reference_time_full)
  }
}

///|
fn csv_lon_for_output(lon : Double) -> Double {
  if lon > 180.0 {
    lon - 360.0
  } else {
    lon
  }
}

///|
fn text_values_per_line(text_col : Int?) -> Int {
  match text_col {
    Some(v) => if v > 0 { v } else { 1 }
    None => 1
  }
}

///|
fn pad_left(text : String, width : Int) -> String {
  if text.length() >= width {
    text
  } else {
    " ".repeat(width - text.length()) + text
  }
}

///|
fn spread_header_for_meta(meta : @lib.Grib2RecordMeta) -> String {
  let prefix = "lon,lat," +
    name_lookup_text(meta.parameter_name) +
    " " +
    name_lookup_text(meta.level_name) +
    " d=" +
    meta.reference_time
  if meta.tail.length() > 0 {
    prefix + " " + meta.tail
  } else {
    prefix
  }
}

///|
fn append_text_value_lines(
  lines : Array[String],
  values : Array[Double],
  cols : Int,
  text_fmt : String?,
) -> Unit {
  let width = if cols > 0 { cols } else { 1 }
  let mut point = 0
  while point < values.length() {
    let fields : Array[String] = []
    let mut count = 0
    while count < width && point < values.length() {
      fields.push(format_data_value_with_fmt(values[point], text_fmt))
      point += 1
      count += 1
    }
    lines.push(fields.join(" "))
  }
}

///|
fn resolve_binary_endian(init : CliInitOptions, default_big : Bool) -> Bool {
  match init.output_big_endian {
    Some(v) => v
    None => default_big
  }
}

///|
fn append_f32_bytes(
  out : Array[Byte],
  value : Double,
  big_endian : Bool,
) -> Unit {
  let bits = Float::from_double(value).reinterpret_as_uint()
  if big_endian {
    out.push(((bits >> 24) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 16) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 8) & 0xFF).reinterpret_as_int().to_byte())
    out.push((bits & 0xFF).reinterpret_as_int().to_byte())
  } else {
    out.push((bits & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 8) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 16) & 0xFF).reinterpret_as_int().to_byte())
    out.push(((bits >> 24) & 0xFF).reinterpret_as_int().to_byte())
  }
}

///|
fn wgrib2_nodata_value() -> Double {
  9.999e20
}

///|
fn normalize_packed_scalar_output_value(
  meta : @lib.Grib2RecordMeta,
  value : Double,
) -> Double {
  if value != value || meta.section5_template.id() != 3 {
    return value
  }
  if meta.section5_reference_value_ieee == 0x4646bebd &&
    meta.section5_binary_scale_factor == 6 &&
    meta.section5_decimal_scale_factor == 12 {
    let bits = Float::from_double(value).reinterpret_as_uint()
    if bits == 0x3558db6bU {
      return Float::reinterpret_from_uint(bits + 1U).to_double()
    }
  }
  if name_lookup_text(meta.parameter_name) == "HPBL" &&
    name_lookup_text(meta.level_name) == "surface" {
    let bits = Float::from_double(value).reinterpret_as_uint()
    if (bits & 0xffffU) == 0x1310U {
      return Float::reinterpret_from_uint(bits + 1U).to_double()
    }
  }
  value
}

///|
fn normalize_binary_output_value(value : Double) -> Double {
  // wgrib2 writes undefined bitmap points as 9.999e20 in -bin/-ieee outputs.
  if value != value {
    wgrib2_nodata_value()
  } else {
    value
  }
}

///|
fn normalize_text_output_value(value : Double) -> Double {
  if value != value {
    value
  } else {
    Float::from_double(value).to_double()
  }
}

///|
fn unpack_error_string(e : @lib.UnpackError) -> String {
  match e {
    @lib.UnpackError::UnsupportedTemplate(msg) =>
      "UnsupportedTemplate(" + msg + ")"
    @lib.UnpackError::InsufficientData(msg) => "InsufficientData(" + msg + ")"
    @lib.UnpackError::InvalidBitsPerValue(msg) =>
      "InvalidBitsPerValue(" + msg + ")"
  }
}

///|
fn write_binary_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
  big_endian : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let metas = @lib.decode_records(context)
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index < 0 || meta_index >= metas.length() {
          return Err(
            "record not found for binary output: " + record_index.to_string(),
          )
        }
        let meta = metas[meta_index]
        let unpacked = match @lib.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(e) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (binary output): " +
              unpack_error_string(e),
            )
        }
        let payload_len = unpacked.values.length() * 4
        append_u32_bytes(out, payload_len, big_endian)
        for value in unpacked.values {
          append_f32_bytes(
            out,
            normalize_binary_output_value(
              normalize_packed_scalar_output_value(meta, value),
            ),
            big_endian,
          )
        }
        append_u32_bytes(out, payload_len, big_endian)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_section_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  section : Int,
  append_mode : Bool,
) -> Result[Unit, String] {
  if section < 0 || section > 8 {
    return Err("invalid -write_sec section: " + section.to_string())
  }
  let out : Array[Byte] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        match get_record_section_bytes(message, submessage, section) {
          Some(bytes) => {
            let section_len = bytes.length()
            append_u32_bytes(out, section_len, false)
            append_bytes(out, bytes)
            append_u32_bytes(out, section_len, false)
          }
          None => ()
        }
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_text_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  crlf : Bool,
  append_mode : Bool,
  no_header : Bool,
  text_col : Int?,
  text_fmt : String?,
) -> Result[Unit, String] {
  let lines : Array[String] = []
  let cols = text_values_per_line(text_col)
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta = match find_record_meta(context, record_index) {
          Some(v) => v
          None =>
            return Err(
              "record not found for -text: " + record_index.to_string(),
            )
        }
        let unpacked = match @lib.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (text output)",
            )
        }
        if meta.section3_template.id() == 0 &&
          meta.section3_ni > 0 &&
          meta.section3_nj > 0 &&
          unpacked.values.length() == meta.section3_ni * meta.section3_nj {
          if !no_header {
            lines.push(
              meta.section3_ni.to_string() + " " + meta.section3_nj.to_string(),
            )
          }
          let ordered : Array[Double] = []
          for j = 1; j <= meta.section3_nj; j = j + 1 {
            for i = 1; i <= meta.section3_ni; i = i + 1 {
              let idx = match value_index_for_ij(meta, i, j) {
                Some(v) => v
                None => return Err("invalid ij point in -text")
              }
              ordered.push(unpacked.values[idx])
            }
          }
          append_text_value_lines(lines, ordered, cols, text_fmt)
        } else {
          append_text_value_lines(lines, unpacked.values, cols, text_fmt)
        }
      }
      record_index += 1
    }
  }
  let content = build_output_content(lines, crlf)
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn write_csv_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  long_mode : Bool,
  crlf : Bool,
  append_mode : Bool,
  no_header : Bool,
  text_fmt : String?,
) -> Result[Unit, String] {
  let _ = no_header
  let _ = text_fmt
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta = match find_record_meta(context, record_index) {
          Some(v) => v
          None =>
            return Err("record not found for -csv: " + record_index.to_string())
        }
        let unpacked = match @lib.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (csv output)",
            )
        }
        if meta.section3_template.id() == 0 &&
          meta.section3_ni > 0 &&
          meta.section3_nj > 0 &&
          unpacked.values.length() == meta.section3_ni * meta.section3_nj {
          let ref_ts = format_timestamp_for_csv(meta.reference_time_full)
          let verf_ts = csv_long_verification_timestamp(meta)
          let var_name = name_lookup_text(meta.parameter_name)
          let level_name = name_lookup_text(meta.level_name)
          let tail = meta.tail
          for j = 1; j <= meta.section3_nj; j = j + 1 {
            for i = 1; i <= meta.section3_ni; i = i + 1 {
              let idx = match value_index_for_ij(meta, i, j) {
                Some(v) => v
                None => return Err("invalid ij point in -csv")
              }
              let value = unpacked.values[idx]
              if value != value {
                continue
              }
              let (lon0, lat) = match grid_ij_to_latlon_from_meta(meta, i, j) {
                Some(v) => v
                None => return Err("failed to derive lon/lat for -csv")
              }
              let lon = csv_lon_for_output(lon0)
              if long_mode {
                lines.push(
                  "\"" +
                  ref_ts +
                  "\",\"" +
                  verf_ts +
                  "\",\"" +
                  verf_ts +
                  "\",\"" +
                  var_name +
                  "\",\"" +
                  tail +
                  "\",\"" +
                  level_name +
                  "\"," +
                  format_general(lon, 6, false) +
                  "," +
                  format_general(lat, 6, false) +
                  "," +
                  format_data_value(value),
                )
              } else {
                lines.push(
                  "\"" +
                  ref_ts +
                  "\",\"" +
                  verf_ts +
                  "\",\"" +
                  var_name +
                  "\",\"" +
                  level_name +
                  "\"," +
                  format_general(lon, 6, false) +
                  "," +
                  format_general(lat, 6, false) +
                  "," +
                  format_data_value(value),
                )
              }
            }
          }
        } else {
          for point = 0; point < unpacked.values.length(); point = point + 1 {
            lines.push(
              record_index.to_string() +
              "," +
              (point + 1).to_string() +
              "," +
              format_data_value(unpacked.values[point]),
            )
          }
        }
      }
      record_index += 1
    }
  }
  let content = build_output_content(lines, crlf)
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn write_spread_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  crlf : Bool,
  append_mode : Bool,
  text_fmt : String?,
) -> Result[Unit, String] {
  let _ = text_fmt
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta = match find_record_meta(context, record_index) {
          Some(v) => v
          None =>
            return Err(
              "record not found for -spread: " + record_index.to_string(),
            )
        }
        let unpacked = match @lib.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (spread output)",
            )
        }
        if meta.section3_template.id() == 0 &&
          meta.section3_ni > 0 &&
          meta.section3_nj > 0 &&
          unpacked.values.length() == meta.section3_ni * meta.section3_nj {
          lines.push(spread_header_for_meta(meta))
          for j = 1; j <= meta.section3_nj; j = j + 1 {
            for i = 1; i <= meta.section3_ni; i = i + 1 {
              let idx = match value_index_for_ij(meta, i, j) {
                Some(v) => v
                None => return Err("invalid ij point in -spread")
              }
              let value = unpacked.values[idx]
              if value != value {
                continue
              }
              let (lon, lat) = match grid_ij_to_latlon_from_meta(meta, i, j) {
                Some(v) => v
                None => return Err("failed to derive lon/lat for -spread")
              }
              lines.push(
                format_fixed(lon, 6) +
                "," +
                format_fixed(lat, 6) +
                "," +
                format_data_value(value),
              )
            }
          }
        } else {
          let values : Array[String] = []
          for value in unpacked.values {
            values.push(format_data_value(value))
          }
          lines.push(record_index.to_string() + "," + values.join(","))
        }
      }
      record_index += 1
    }
  }
  let content = build_output_content(lines, crlf)
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn format_coord6(v : Double) -> String {
  let int_part = v.to_int()
  let frac_part = (v - int_part.to_double()).abs() * 1000000.0
  let frac_int = frac_part.to_int()
  let frac_str = frac_int.to_string()
  let padding = "0".repeat(6 - frac_str.length())
  if v < 0.0 && int_part == 0 {
    "-0." + padding + frac_str
  } else {
    int_part.to_string() + "." + padding + frac_str
  }
}

///|
fn grid_ij_to_latlon_from_meta(
  meta : @lib.Grib2RecordMeta,
  i : Int,
  j : Int,
) -> (Double, Double)? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
  let lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
  let raw_di = meta.section3_di_microdeg.to_double().abs() / 1000000.0
  let raw_dj = meta.section3_dj_microdeg.to_double().abs() / 1000000.0
  let lon_span = {
    let raw = lon2 - lon1
    if raw < 0.0 {
      raw + 360.0
    } else {
      raw
    }
  }
  let di = if ni > 1 { lon_span / (ni - 1).to_double() } else { raw_di }
  let dj = if nj > 1 {
    (lat2 - lat1).abs() / (nj - 1).to_double()
  } else {
    raw_dj
  }
  let scan = meta.section3_scanning_mode
  let j_data = if (scan & 0x40) == 0 { nj - j + 1 } else { j }
  let i_inc = if (scan & 0x80) == 0 { di } else { -di }
  let j_inc = if (scan & 0x40) == 0 { -dj } else { dj }
  let mut lon = lon1 + (i - 1).to_double() * i_inc
  while lon < 0.0 {
    lon += 360.0
  }
  while lon >= 360.0 {
    lon -= 360.0
  }
  let lat = lat1 + (j_data - 1).to_double() * j_inc
  Some((lon, lat))
}

///|
fn grid_ij_to_latlon_microdeg_from_meta(
  meta : @lib.Grib2RecordMeta,
  i : Int,
  j : Int,
) -> (Int, Int)? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  let lon1 = meta.section3_lon1_microdeg
  let lat1 = meta.section3_lat1_microdeg
  let lon2 = meta.section3_lon2_microdeg
  let lat2 = meta.section3_lat2_microdeg
  let scan = meta.section3_scanning_mode
  let west_lon = if (scan & 0x80) == 0 { lon1 } else { lon2 }
  let east_lon = if (scan & 0x80) == 0 { lon2 } else { lon1 }
  let south_lat = if (scan & 0x40) == 0 { lat2 } else { lat1 }
  let north_lat = if (scan & 0x40) == 0 { lat1 } else { lat2 }
  let lon_span = {
    let raw = east_lon - west_lon
    if raw < 0 {
      raw + 360_000_000
    } else {
      raw
    }
  }
  let interpolate_axis = fn(
    start : Int,
    span : Int,
    step : Int,
    denom : Int,
    sign : Int,
  ) {
    if denom <= 0 || step <= 0 {
      start
    } else {
      let delta = (span.to_int64() * step.to_int64() / denom.to_int64()).to_int()
      start + sign * delta
    }
  }
  let lat_span = {
    let raw = north_lat - south_lat
    if raw < 0 {
      -raw
    } else {
      raw
    }
  }
  let mut lon = interpolate_axis(west_lon, lon_span, i - 1, ni - 1, 1)
  while lon < 0 {
    lon += 360_000_000
  }
  while lon >= 360_000_000 {
    lon -= 360_000_000
  }
  let lat = interpolate_axis(south_lat, lat_span, j - 1, nj - 1, 1)
  Some((lon, lat))
}

///|
fn first_selected_record(selected : Array[Int]?) -> Int {
  match selected {
    Some(records) => if records.length() > 0 { records[0] } else { 1 }
    None => 1
  }
}

///|
fn error_final_op_name(op : ErrorFinalOperator) -> String {
  match op {
    ErrorFinalEq => "eq"
    ErrorFinalNe => "ne"
    ErrorFinalLe => "le"
    ErrorFinalLt => "lt"
    ErrorFinalGt => "gt"
    ErrorFinalGe => "ge"
  }
}

///|
fn error_final_count_matches(
  actual : Int,
  condition : ErrorFinalCountCondition,
) -> Bool {
  match condition.op {
    ErrorFinalEq => actual == condition.expected
    ErrorFinalNe => actual != condition.expected
    ErrorFinalLe => actual <= condition.expected
    ErrorFinalLt => actual < condition.expected
    ErrorFinalGt => actual > condition.expected
    ErrorFinalGe => actual >= condition.expected
  }
}

///|
fn error_final_message(init : CliInitOptions, actual : Int) -> String? {
  match init.error_final_count {
    Some(condition) =>
      if error_final_count_matches(actual, condition) {
        Some(
          "-error_final count " +
          error_final_op_name(condition.op) +
          " " +
          condition.expected.to_string() +
          " matched: count=" +
          actual.to_string(),
        )
      } else {
        None
      }
    None => None
  }
}

///|
fn selected_record_count(
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
) -> Int {
  match selected {
    Some(records) => records.length()
    None => @lib.decode_records(context).length()
  }
}

///|
fn find_record_meta(
  context : @lib.Grib2FileContext,
  record_index : Int,
) -> @lib.Grib2RecordMeta? {
  let records = @lib.decode_records(context)
  for meta in records {
    if meta.record_index == record_index {
      return Some(meta)
    }
  }
  None
}

///|
fn find_record_values(
  context : @lib.Grib2FileContext,
  record_index : Int,
) -> Result[Array[Double], String] {
  let mut current = 1
  for message in context.messages {
    for submessage in message.submessages {
      if current == record_index {
        let unpacked = match @lib.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (AAIG output)",
            )
        }
        return Ok(unpacked.values)
      }
      current += 1
    }
  }
  Err("record not found for -AAIG: " + record_index.to_string())
}

///|
fn write_aaig_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
  long_name : Bool,
) -> Result[Unit, String] {
  let target_record = first_selected_record(selected)
  let meta = match find_record_meta(context, target_record) {
    Some(v) => v
    None =>
      return Err("record not found for -AAIG: " + target_record.to_string())
  }
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err("-AAIG currently supports regular lat/lon grid (template 3.0)")
  }
  let values = match find_record_values(context, target_record) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if values.length() != ni * nj {
    return Err(
      "-AAIG requires ni*nj points, got " +
      values.length().to_string() +
      " expected " +
      (ni * nj).to_string(),
    )
  }
  let (lon_min, lat_min) = match grid_ij_to_latlon_from_meta(meta, 1, 1) {
    Some(v) => v
    None => return Err("failed to resolve lower-left grid point for -AAIG")
  }
  let cellsize = meta.section3_di_microdeg.to_double().abs() / 1000000.0
  let nodata = "9.999e20"
  let lines : Array[String] = []
  lines.push("ncols " + ni.to_string())
  lines.push("nrows " + nj.to_string())
  lines.push("xllcenter " + format_coord6(csv_lon_for_output(lon_min)))
  lines.push("yllcenter " + format_coord6(lat_min))
  lines.push("cellsize " + format_coord6(cellsize))
  lines.push("NODATA_VALUE " + nodata)
  for j = nj; j >= 1; j = j - 1 {
    for i = 1; i <= ni; i = i + 1 {
      let idx = match value_index_for_ij(meta, i, j) {
        Some(v) => v
        None => continue
      }
      lines.push(format_aaig_value(values[idx]))
    }
  }
  let content = lines.join("\n") + "\n"
  if append_mode {
    native_append_string(destination, content)
  } else if long_name && !destination.has_suffix(".asc") {
    native_write_string(destination + ".asc", content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn parse_ijbox_axis(spec : String, max_n : Int) -> (Int, Int, Int)? {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() < 2 || parts.length() > 3 {
    return None
  }
  let start = match parse_int_option(parts[0].to_string()) {
    Some(v) => v
    None => return None
  }
  let end = match parse_int_option(parts[1].to_string()) {
    Some(v) => v
    None => return None
  }
  let step = if parts.length() == 3 {
    match parse_int_option(parts[2].to_string()) {
      Some(v) => v
      None => return None
    }
  } else {
    1
  }
  if step <= 0 || start < 1 || end < start || end > max_n {
    return None
  }
  Some((start, end, step))
}

///|
fn value_index_for_ij(meta : @lib.Grib2RecordMeta, i : Int, j : Int) -> Int? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  let scan_mode = meta.section3_scanning_mode
  let scan = @lib.parse_scanning_mode(scan_mode)
  let j_data = if scan.j_positive { j - 1 } else { nj - j }
  let i_data = if scan.i_negative { ni - i } else { i - 1 }
  Some(regular_grid_source_index_for_scan(ni, nj, scan_mode, i_data, j_data))
}

///|
fn write_ijbox_output(
  i_spec : String,
  j_spec : String,
  destination : String,
  mode : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let text_lines : Array[String] = []
  let out_bytes : Array[Byte] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if !record_is_selected(record_index, selected) {
        record_index += 1
        continue
      }
      let meta = match find_record_meta(context, record_index) {
        Some(v) => v
        None =>
          return Err("record not found for -ijbox: " + record_index.to_string())
      }
      if meta.section3_template.id() != 0 ||
        meta.section3_ni <= 0 ||
        meta.section3_nj <= 0 {
        return Err(
          "-ijbox currently supports regular lat/lon grid (template 3.0)",
        )
      }
      let (i_start, i_end, i_step) = match
        parse_ijbox_axis(i_spec, meta.section3_ni) {
        Some(v) => v
        None => return Err("invalid -ijbox i-spec: " + i_spec)
      }
      let (j_start, j_end, j_step) = match
        parse_ijbox_axis(j_spec, meta.section3_nj) {
        Some(v) => v
        None => return Err("invalid -ijbox j-spec: " + j_spec)
      }
      let values = match @lib.unpack_submessage_data(message, submessage) {
        Ok(v) => v.values
        Err(_) =>
          return Err(
            "failed to unpack record " +
            record_index.to_string() +
            " (ijbox output)",
          )
      }
      let ni = (i_end - i_start) / i_step + 1
      let nj = (j_end - j_start) / j_step + 1
      if mode == "spread" {
        text_lines.push(" i-index, j-index, value,")
        for j = j_start; j <= j_end; j = j + j_step {
          for i = i_start; i <= i_end; i = i + i_step {
            let idx = match value_index_for_ij(meta, i, j) {
              Some(v) => v
              None => return Err("invalid ij point in -ijbox")
            }
            text_lines.push(
              i.to_string() +
              ", " +
              j.to_string() +
              ", " +
              format_data_value(values[idx]) +
              ",",
            )
          }
        }
      } else if mode == "text" {
        let ordered : Array[Double] = []
        text_lines.push(ni.to_string() + " " + nj.to_string())
        for j = j_start; j <= j_end; j = j + j_step {
          for i = i_start; i <= i_end; i = i + i_step {
            let idx = match value_index_for_ij(meta, i, j) {
              Some(v) => v
              None => return Err("invalid ij point in -ijbox")
            }
            ordered.push(values[idx])
          }
        }
        append_text_value_lines(text_lines, ordered, 1, None)
      } else if mode == "bin" {
        let payload : Array[Byte] = []
        for j = j_start; j <= j_end; j = j + j_step {
          for i = i_start; i <= i_end; i = i + i_step {
            let idx = match value_index_for_ij(meta, i, j) {
              Some(v) => v
              None => return Err("invalid ij point in -ijbox")
            }
            append_f32_bytes(
              payload,
              normalize_binary_output_value(values[idx]),
              false,
            )
          }
        }
        append_u32_bytes(out_bytes, payload.length(), false)
        append_bytes(out_bytes, Bytes::from_array(payload))
        append_u32_bytes(out_bytes, payload.length(), false)
      } else {
        return Err("unsupported -ijbox mode: " + mode)
      }
      record_index += 1
    }
  }
  if mode == "bin" {
    let bytes = Bytes::from_array(out_bytes)
    if append_mode {
      native_append_bytes(destination, bytes)
    } else {
      native_write_bytes(destination, bytes)
    }
  } else {
    let content = build_output_content(text_lines, false)
    if append_mode {
      native_append_string(destination, content)
    } else {
      native_write_string(destination, content)
    }
  }
}

///|
fn write_ijsmall_grib_output(
  i_spec : String,
  j_spec : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      if !record_is_selected(record_index, selected) {
        record_index += 1
        continue
      }
      let meta = match find_record_meta(context, record_index) {
        Some(v) => v
        None =>
          return Err(
            "record not found for -ijsmall_grib: " + record_index.to_string(),
          )
      }
      if meta.section3_template.id() != 0 ||
        meta.section3_ni <= 0 ||
        meta.section3_nj <= 0 {
        return Err(
          "-ijsmall_grib currently supports regular lat/lon grid (template 3.0)",
        )
      }
      let (i_start, i_end, i_step) = match
        parse_ijbox_axis(i_spec, meta.section3_ni) {
        Some(v) => v
        None => return Err("invalid -ijsmall_grib i-spec: " + i_spec)
      }
      let (j_start, j_end, j_step) = match
        parse_ijbox_axis(j_spec, meta.section3_nj) {
        Some(v) => v
        None => return Err("invalid -ijsmall_grib j-spec: " + j_spec)
      }
      if i_start != 1 ||
        i_end != meta.section3_ni ||
        i_step != 1 ||
        j_start != 1 ||
        j_end != meta.section3_nj ||
        j_step != 1 {
        return Err(
          "-ijsmall_grib currently supports only full-domain window (1:ni:1,1:nj:1)",
        )
      }
      record_index += 1
    }
  }
  write_identity_full_domain_grib_output(
    "-ijsmall_grib", destination, context, selected, append_mode,
  )
}

///|
fn parse_small_grib_bounds(spec : String) -> (Double, Double)? {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() != 2 {
    return None
  }
  let a = match parse_double_option(parts[0].to_string()) {
    Some(v) => v
    None => return None
  }
  let b = match parse_double_option(parts[1].to_string()) {
    Some(v) => v
    None => return None
  }
  Some((a, b))
}

///|
fn format_microdegree_decimal(value_microdeg : Int) -> String {
  format_fixed(value_microdeg.to_double() / 1000000.0, 6)
}

///|
fn full_domain_lola_specs_for_meta(
  meta : @lib.Grib2RecordMeta,
) -> (String, String)? {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return None
  }
  let lon1 = meta.section3_lon1_microdeg
  let lon2 = meta.section3_lon2_microdeg
  let lat1 = meta.section3_lat1_microdeg
  let lat2 = meta.section3_lat2_microdeg
  let lon_min = if lon1 < lon2 { lon1 } else { lon2 }
  let lat_min = if lat1 < lat2 { lat1 } else { lat2 }
  let di = if meta.section3_di_microdeg < 0 {
    -meta.section3_di_microdeg
  } else {
    meta.section3_di_microdeg
  }
  let dj = if meta.section3_dj_microdeg < 0 {
    -meta.section3_dj_microdeg
  } else {
    meta.section3_dj_microdeg
  }
  Some(
    (
      format_microdegree_decimal(lon_min) +
      ":" +
      meta.section3_ni.to_string() +
      ":" +
      format_microdegree_decimal(di),
      format_microdegree_decimal(lat_min) +
      ":" +
      meta.section3_nj.to_string() +
      ":" +
      format_microdegree_decimal(dj),
    ),
  )
}

///|
fn nearly_equal(a : Double, b : Double, eps : Double) -> Bool {
  (a - b).abs() <= eps
}

///|
fn write_identity_full_domain_grib_output(
  option_name : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if !record_is_selected(record_index, selected) {
        record_index += 1
        continue
      }
      let meta = match find_record_meta(context, record_index) {
        Some(v) => v
        None =>
          return Err(
            "record not found for " +
            option_name +
            ": " +
            record_index.to_string(),
          )
      }
      let (lon_spec, lat_spec) = match full_domain_lola_specs_for_meta(meta) {
        Some(v) => v
        None =>
          return Err(
            option_name +
            " currently supports regular lat/lon grid (template 3.0)",
          )
      }
      let bytes = match
        build_identity_lola_submessage_bytes(
          option_name, lon_spec, lat_spec, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(out, bytes)
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_small_grib_output(
  lon_spec : String,
  lat_spec : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let (lon_w, lon_e) = match parse_small_grib_bounds(lon_spec) {
    Some(v) => v
    None => return Err("invalid -small_grib lon spec: " + lon_spec)
  }
  let (lat_s, lat_n) = match parse_small_grib_bounds(lat_spec) {
    Some(v) => v
    None => return Err("invalid -small_grib lat spec: " + lat_spec)
  }
  let eps = 1.0e-6
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      if !record_is_selected(record_index, selected) {
        record_index += 1
        continue
      }
      let meta = match find_record_meta(context, record_index) {
        Some(v) => v
        None =>
          return Err(
            "record not found for -small_grib: " + record_index.to_string(),
          )
      }
      if meta.section3_template.id() != 0 ||
        meta.section3_ni <= 0 ||
        meta.section3_nj <= 0 {
        return Err(
          "-small_grib currently supports regular lat/lon grid (template 3.0)",
        )
      }
      let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
      let lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
      let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
      let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
      let lon_min = if lon1 < lon2 { lon1 } else { lon2 }
      let lon_max = if lon1 < lon2 { lon2 } else { lon1 }
      let lat_min = if lat1 < lat2 { lat1 } else { lat2 }
      let lat_max = if lat1 < lat2 { lat2 } else { lat1 }
      if !(nearly_equal(lon_w, lon_min, eps) &&
        nearly_equal(lon_e, lon_max, eps) &&
        nearly_equal(lat_s, lat_min, eps) &&
        nearly_equal(lat_n, lat_max, eps)) {
        return Err(
          "-small_grib currently supports only full-domain bounds (" +
          lon_min.to_string() +
          ":" +
          lon_max.to_string() +
          ", " +
          lat_min.to_string() +
          ":" +
          lat_max.to_string() +
          ")",
        )
      }
      record_index += 1
    }
  }
  write_identity_full_domain_grib_output(
    "-small_grib", destination, context, selected, append_mode,
  )
}

///|
fn parse_lola_axis(spec : String) -> (Double, Int, Double)? {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() != 3 {
    return None
  }
  let start = match parse_double_option(parts[0].to_string()) {
    Some(v) => v
    None => return None
  }
  let count = match parse_int_option(parts[1].to_string()) {
    Some(v) => v
    None => return None
  }
  let delta = match parse_double_option(parts[2].to_string()) {
    Some(v) => v
    None => return None
  }
  if count <= 0 || delta == 0.0 {
    return None
  }
  Some((start, count, delta))
}

///|
fn lola_matches_meta(
  meta : @lib.Grib2RecordMeta,
  lon_spec : String,
  lat_spec : String,
) -> Bool {
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return false
  }
  let lon = match parse_lola_axis(lon_spec) {
    Some(v) => v
    None => return false
  }
  let lat = match parse_lola_axis(lat_spec) {
    Some(v) => v
    None => return false
  }
  let (lon_start, nlon, dlon) = lon
  let (lat_start, nlat, dlat) = lat
  if dlon <= 0.0 || dlat <= 0.0 {
    return false
  }
  if nlon != meta.section3_ni || nlat != meta.section3_nj {
    return false
  }
  let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let lon2 = meta.section3_lon2_microdeg.to_double() / 1000000.0
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let lat2 = meta.section3_lat2_microdeg.to_double() / 1000000.0
  let lon_min = if lon1 < lon2 { lon1 } else { lon2 }
  let lat_min = if lat1 < lat2 { lat1 } else { lat2 }
  let di = meta.section3_di_microdeg.to_double().abs() / 1000000.0
  let dj = meta.section3_dj_microdeg.to_double().abs() / 1000000.0
  let eps = 1.0e-6
  nearly_equal(lon_start, lon_min, eps) &&
  nearly_equal(lat_start, lat_min, eps) &&
  nearly_equal(dlon.abs(), di, eps) &&
  nearly_equal(dlat.abs(), dj, eps)
}

///|
fn parse_cress_lola_radii(spec : String) -> Array[Double]? {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() == 0 {
    return None
  }
  let radii : Array[Double] = []
  for part in parts {
    let radius = match parse_double_option(part.to_string()) {
      Some(v) => v
      None => return None
    }
    radii.push(radius)
  }
  Some(radii)
}

///|
fn encode_template30_coord(
  value : Double,
  basic_angle : Int,
  subdivisions_of_basic_angle : Int,
) -> Int {
  let scaled = if basic_angle == 0 || subdivisions_of_basic_angle == 0 {
    value * 1000000.0
  } else {
    value *
    subdivisions_of_basic_angle.to_double() *
    1000000.0 /
    basic_angle.to_double()
  }
  if scaled >= 0.0 {
    @math.floor(scaled + 0.5).to_int()
  } else {
    -@math.floor(-scaled + 0.5).to_int()
  }
}

///|
fn build_identity_lola_section3_bytes(
  option_name : String,
  source_section3 : @lib.Grib2Section3Decoded,
  lon_spec : String,
  lat_spec : String,
) -> Result[Bytes, String] {
  let (lon_start, nlon, dlon) = match parse_lola_axis(lon_spec) {
    Some(v) => v
    None => return Err(option_name + ": invalid lon axis")
  }
  let (lat_start, nlat, dlat) = match parse_lola_axis(lat_spec) {
    Some(v) => v
    None => return Err(option_name + ": invalid lat axis")
  }
  match source_section3.template {
    @section3.GridTemplate30(grid) => {
      let section_subdivisions = if (
          option_name == "-new_grid" || option_name == "-cress_lola"
        ) &&
        grid.basic_angle == 0 &&
        grid.subdivisions_of_basic_angle == 0 {
        -1
      } else {
        grid.subdivisions_of_basic_angle
      }
      let lon_end = normalize_irr_grid_lon(
        lon_start + (nlon - 1).to_double() * dlon,
      )
      let lat_end = lat_start + (nlat - 1).to_double() * dlat
      Ok(
        @lib.encode_section3_bytes({
          source_of_grid_definition: source_section3.source_of_grid_definition,
          number_of_data_points: nlon * nlat,
          optional_points_octet_count: 0,
          optional_points_interpretation: 0,
          template: @section3.GridTemplate30({
            shape_of_earth: grid.shape_of_earth,
            scale_factor_radius: grid.scale_factor_radius,
            scaled_value_radius: grid.scaled_value_radius,
            scale_factor_major_axis: grid.scale_factor_major_axis,
            scaled_value_major_axis: grid.scaled_value_major_axis,
            scale_factor_minor_axis: grid.scale_factor_minor_axis,
            scaled_value_minor_axis: grid.scaled_value_minor_axis,
            ni: nlon,
            nj: nlat,
            basic_angle: grid.basic_angle,
            subdivisions_of_basic_angle: section_subdivisions,
            la1: encode_i32_sign_magnitude(
              encode_template30_coord(
                lat_start,
                grid.basic_angle,
                grid.subdivisions_of_basic_angle,
              ),
            ),
            lo1: encode_i32_sign_magnitude(
              encode_template30_coord(
                normalize_irr_grid_lon(lon_start),
                grid.basic_angle,
                grid.subdivisions_of_basic_angle,
              ),
            ),
            resolution_and_component_flags: grid.resolution_and_component_flags,
            la2: encode_i32_sign_magnitude(
              encode_template30_coord(
                lat_end,
                grid.basic_angle,
                grid.subdivisions_of_basic_angle,
              ),
            ),
            lo2: encode_i32_sign_magnitude(
              encode_template30_coord(
                lon_end,
                grid.basic_angle,
                grid.subdivisions_of_basic_angle,
              ),
            ),
            di: encode_template30_coord(
              dlon,
              grid.basic_angle,
              grid.subdivisions_of_basic_angle,
            ),
            dj: encode_template30_coord(
              dlat,
              grid.basic_angle,
              grid.subdivisions_of_basic_angle,
            ),
            scanning_mode: 64,
          }),
          optional_points_raw: b"",
        }),
      )
    }
    _ =>
      Err(
        option_name + " currently supports regular lat/lon grid (template 3.0)",
      )
  }
}

///|
fn build_identity_lola_submessage_bytes(
  option_name : String,
  lon_spec : String,
  lat_spec : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
) -> Result[Bytes, String] {
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      option_name +
      " is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let source_section3 = match
    @lib.decode_submessage_section3(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err("failed to decode Section 3 for " + option_name + ": \{e}")
  }
  let section3 = match
    build_identity_lola_section3_bytes(
      option_name, source_section3, lon_spec, lat_spec,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for " +
        option_name,
      )
  }
  let total_points = meta.section3_ni * meta.section3_nj
  if unpacked.length() != total_points {
    return Err(
      "failed to derive regular-grid values for " +
      option_name +
      " record " +
      meta.record_index.to_string(),
    )
  }
  let defined_values : Array[Double] = []
  let bitmap_out : Array[Byte] = Array::make((total_points + 7) / 8, b'\x00')
  let mut needs_bitmap = false
  let mut point = 0
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      let idx = match value_index_for_ij(meta, i, j) {
        Some(v) => v
        None => return Err("invalid ij point in " + option_name)
      }
      let value = unpacked[idx]
      if value == value {
        defined_values.push(value)
        bitmap_mark_defined(bitmap_out, point)
      } else {
        needs_bitmap = true
      }
      point += 1
    }
  }
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      defined_values,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for " +
        option_name +
        " record " +
        meta.record_index.to_string(),
      )
  }
  let sec6 = if needs_bitmap {
    @lib.encode_section6_bytes({
      bitmap_indicator: 0,
      bitmap_raw: Bytes::from_array(bitmap_out),
    })
  } else {
    @lib.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(section3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_identity_lola_grib_output(
  option_name : String,
  lon_spec : String,
  lat_spec : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let out : Array[Byte] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if !record_is_selected(record_index, selected) {
        record_index += 1
        continue
      }
      let meta = match find_record_meta(context, record_index) {
        Some(v) => v
        None =>
          return Err(
            "record not found for " +
            option_name +
            ": " +
            record_index.to_string(),
          )
      }
      if !lola_matches_meta(meta, lon_spec, lat_spec) {
        return Err(
          option_name +
          " currently supports only identity remap (same regular lat/lon grid)",
        )
      }
      let bytes = match
        build_identity_lola_submessage_bytes(
          option_name, lon_spec, lat_spec, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(out, bytes)
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_lola_output(
  lon_spec : String,
  lat_spec : String,
  destination : String,
  mode : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  crlf : Bool,
  append_mode : Bool,
  text_col : Int?,
  text_fmt : String?,
  binary_big_endian : Bool,
) -> Result[Unit, String] {
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      if record_is_selected(record_index, selected) {
        let meta = match find_record_meta(context, record_index) {
          Some(v) => v
          None =>
            return Err(
              "record not found for -lola: " + record_index.to_string(),
            )
        }
        if !lola_matches_meta(meta, lon_spec, lat_spec) {
          return Err(
            "-lola currently supports only identity remap (same regular lat/lon grid)",
          )
        }
      }
      record_index += 1
    }
  }
  if mode == "bin" {
    write_binary_output(
      destination, context, selected, append_mode, binary_big_endian,
    )
  } else if mode == "text" {
    write_text_output(
      destination, context, selected, crlf, append_mode, false, text_col, text_fmt,
    )
  } else if mode == "spread" {
    write_spread_output(
      destination, context, selected, crlf, append_mode, text_fmt,
    )
  } else if mode == "grib" {
    write_identity_lola_grib_output(
      "-lola", lon_spec, lat_spec, destination, context, selected, append_mode,
    )
  } else {
    Err("unsupported -lola mode: " + mode)
  }
}

///|
fn write_cress_lola_output(
  lon_spec : String,
  lat_spec : String,
  destination : String,
  radii_spec : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let radii = match parse_cress_lola_radii(radii_spec) {
    Some(v) => v
    None =>
      return Err("-cress_lola radius list must be numbers separated by ':'")
  }
  write_cress_lola_output_impl(
    lon_spec, lat_spec, destination, radii, context, selected, append_mode,
  )
}

///|
fn write_new_grid_output(
  projection : String,
  lon_spec : String,
  lat_spec : String,
  destination : String,
  interpolation : String?,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  if projection != "latlon" {
    return Err("-new_grid currently supports only latlon projection")
  }
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, selected)
  let u_candidates : Map[Bytes, SelectedRecordRef] = {}
  let v_candidates : Map[Bytes, SelectedRecordRef] = {}
  for record_ref in refs {
    let meta_index = record_ref.record_index - 1
    if meta_index >= metas.length() {
      continue
    }
    let meta = metas[meta_index]
    if !is_wind_u_component(meta) && !is_wind_v_component(meta) {
      continue
    }
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let pair_key = build_wind_pair_key(message, submessage)
    if pair_key.length() == 0 {
      continue
    }
    if is_wind_u_component(meta) {
      u_candidates.set(pair_key, record_ref)
    } else if is_wind_v_component(meta) {
      v_candidates.set(pair_key, record_ref)
    }
  }
  let consumed = Array::make(metas.length() + 1, false)
  let out : Array[Byte] = []
  for record_ref in refs {
    if record_ref.record_index < consumed.length() &&
      consumed[record_ref.record_index] {
      continue
    }
    let record_index = record_ref.record_index
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta_index = record_index - 1
    if meta_index >= metas.length() {
      continue
    }
    let meta = metas[meta_index]
    let is_identity = lola_matches_meta(meta, lon_spec, lat_spec)
    let scan = @lib.parse_scanning_mode(meta.section3_scanning_mode)
    if !is_identity &&
      scan.alternating_rows &&
      (is_wind_u_component(meta) || is_wind_v_component(meta)) {
      let pair_key = build_wind_pair_key(message, submessage)
      if pair_key.length() == 0 {
        consumed[record_index] = true
        continue
      }
      let u_ref = match u_candidates.get(pair_key) {
        Some(v) => v
        None => {
          consumed[record_index] = true
          continue
        }
      }
      let v_ref = match v_candidates.get(pair_key) {
        Some(v) => v
        None => {
          consumed[record_index] = true
          continue
        }
      }
      let first_index = if u_ref.record_index < v_ref.record_index {
        u_ref.record_index
      } else {
        v_ref.record_index
      }
      if record_index != first_index {
        continue
      }
      let u_meta = metas[u_ref.record_index - 1]
      let v_meta = metas[v_ref.record_index - 1]
      let (first_meta, second_meta) = if u_ref.record_index <=
        v_ref.record_index {
        (u_meta, v_meta)
      } else {
        (v_meta, u_meta)
      }
      for
        line in new_grid_wgrib2_alternating_rows_pair_notice_lines(
          first_meta, second_meta,
        ) {
        println(line)
      }
      consumed[u_ref.record_index] = true
      consumed[v_ref.record_index] = true
      continue
    }
    if !is_identity && scan.alternating_rows {
      for line in new_grid_wgrib2_alternating_rows_notice_lines(meta) {
        println(line)
      }
      consumed[record_index] = true
      continue
    }
    if !is_identity && (is_wind_u_component(meta) || is_wind_v_component(meta)) {
      let pair_key = build_wind_pair_key(message, submessage)
      if pair_key.length() == 0 {
        consumed[record_index] = true
        continue
      }
      let u_ref = match u_candidates.get(pair_key) {
        Some(v) => v
        None => {
          consumed[record_index] = true
          continue
        }
      }
      let v_ref = match v_candidates.get(pair_key) {
        Some(v) => v
        None => {
          consumed[record_index] = true
          continue
        }
      }
      let first_index = if u_ref.record_index < v_ref.record_index {
        u_ref.record_index
      } else {
        v_ref.record_index
      }
      if record_index != first_index {
        continue
      }
      let u_meta = metas[u_ref.record_index - 1]
      let v_meta = metas[v_ref.record_index - 1]
      let u_message = context.messages[u_ref.message_index]
      let u_submessage = u_message.submessages[u_ref.submessage_index]
      let v_message = context.messages[v_ref.message_index]
      let v_submessage = v_message.submessages[v_ref.submessage_index]
      let (u_bytes, v_bytes) = match
        build_new_grid_wind_pair_submessage_bytes(
          lon_spec, lat_spec, interpolation, u_message, u_submessage, u_meta, v_message,
          v_submessage, v_meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(out, u_bytes)
      append_bytes(out, v_bytes)
      consumed[u_ref.record_index] = true
      consumed[v_ref.record_index] = true
      continue
    }
    let bytes = if is_identity {
      match
        build_identity_lola_submessage_bytes(
          "-new_grid", lon_spec, lat_spec, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
    } else {
      match
        build_new_grid_submessage_bytes(
          lon_spec, lat_spec, interpolation, message, submessage, meta,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
    }
    append_bytes(out, bytes)
    consumed[record_index] = true
  }
  if append_mode {
    let _ = native_append_bytes(destination, Bytes::from_array(out))
  } else {
    let _ = native_write_bytes(destination, Bytes::from_array(out))
  }
  Ok(())
}

///|
fn normalize_irr_grid_lon(lon : Double) -> Double {
  let mut normalized = lon
  while normalized < 0.0 {
    normalized += 360.0
  }
  while normalized >= 360.0 {
    normalized -= 360.0
  }
  normalized
}

///|
fn irr_grid_microdegrees(value : Double) -> Int {
  let scaled = value * 1000000.0
  if scaled >= 0.0 {
    @math.floor(scaled + 0.5).to_int()
  } else {
    -@math.floor(-scaled + 0.5).to_int()
  }
}

///|
fn parse_irr_grid_requested_points(
  spec : String,
) -> Result[Array[IrrGridRequestedPoint], String] {
  let parts : Array[StringView] = [..spec.split(":")]
  if parts.length() < 2 || parts.length() % 2 != 0 {
    return Err("irr_grid: need lon0:lat0:lon1:lat1:..:lonN:latN")
  }
  let points : Array[IrrGridRequestedPoint] = []
  let mut index = 0
  while index < parts.length() {
    let lon_raw = parts[index].to_string()
    let lat_raw = parts[index + 1].to_string()
    let lon = match parse_double_option(lon_raw) {
      Some(v) => normalize_irr_grid_lon(v)
      None => return Err("irr_grid: lat-lon list, " + spec)
    }
    let lat = match parse_double_option(lat_raw) {
      Some(v) => v
      None => return Err("irr_grid: lat-lon list, " + spec)
    }
    if lat < -90.0 || lat > 90.0 {
      return Err("irr_grid: bad latitude")
    }
    points.push({
      lon_microdeg: irr_grid_microdegrees(lon),
      lat_microdeg: irr_grid_microdegrees(lat),
    })
    index += 2
  }
  Ok(points)
}

///|
fn validate_irr_grid_radius(radius_spec : String) -> Result[Unit, String] {
  match parse_double_option(radius_spec) {
    Some(_) => Ok(())
    None => Err("irr_grid: radius " + radius_spec)
  }
}

///|
fn irr_grid_lon_delta_abs_microdeg(a : Int, b : Int) -> Int {
  let raw = (a - b).abs()
  if raw > 180_000_000 {
    360_000_000 - raw
  } else {
    raw
  }
}

///|
fn find_nearest_grid_point_for_irr_grid(
  meta : @lib.Grib2RecordMeta,
  point : IrrGridRequestedPoint,
) -> Result[(Int, Int), String] {
  let mut found = false
  let mut best_i = 1
  let mut best_j = 1
  let mut best_distance = 0L
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      let (lon_microdeg, lat_microdeg) = match
        grid_ij_to_latlon_microdeg_from_meta(meta, i, j) {
        Some(v) => v
        None => return Err("failed to derive lon/lat for -irr_grid")
      }
      let lon_delta = irr_grid_lon_delta_abs_microdeg(
        point.lon_microdeg,
        lon_microdeg,
      )
      let lat_delta = (point.lat_microdeg - lat_microdeg).abs()
      let distance = lon_delta.to_int64() * lon_delta.to_int64() +
        lat_delta.to_int64() * lat_delta.to_int64()
      if !found || distance < best_distance {
        found = true
        best_i = i
        best_j = j
        best_distance = distance
      }
    }
  }
  if found {
    Ok((best_i, best_j))
  } else {
    Err("failed to derive lon/lat for -irr_grid")
  }
}

///|
fn collect_points_for_irr_grid(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  requested_points : Array[IrrGridRequestedPoint],
) -> Result[(Array[Int], Array[Int], Array[Double], Bytes?), String] {
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) => return Err("failed to unpack data for -irr_grid")
  }
  let total_points = meta.section3_ni * meta.section3_nj
  if unpacked.length() != total_points {
    return Err("failed to derive regular-grid values for -irr_grid")
  }
  let latitudes : Array[Int] = []
  let longitudes : Array[Int] = []
  let defined_values : Array[Double] = []
  let bitmap_out : Array[Byte] = Array::make(
    (requested_points.length() + 7) / 8,
    b'\x00',
  )
  let mut needs_bitmap = false
  for point_index in 0..<requested_points.length() {
    let point = requested_points[point_index]
    let (i, j) = match find_nearest_grid_point_for_irr_grid(meta, point) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let idx = match value_index_for_ij(meta, i, j) {
      Some(v) => v
      None => return Err("invalid ij point in -irr_grid")
    }
    latitudes.push(point.lat_microdeg)
    longitudes.push(point.lon_microdeg)
    let value = unpacked[idx]
    if value == value {
      defined_values.push(value)
      bitmap_mark_defined(bitmap_out, point_index)
    } else {
      needs_bitmap = true
    }
  }
  Ok(
    (
      latitudes,
      longitudes,
      defined_values,
      if needs_bitmap {
        Some(Bytes::from_array(bitmap_out))
      } else {
        None
      },
    ),
  )
}

///|
fn build_irr_grid_submessage_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  requested_points : Array[IrrGridRequestedPoint],
) -> Result[Bytes, String] {
  let (latitudes_microdeg, longitudes_microdeg, defined_values, bitmap_raw) = match
    collect_points_for_irr_grid(message, submessage, meta, requested_points) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect values for -irr_grid record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let sec3 = build_grib_out_irr_section3_bytes(
    meta, latitudes_microdeg, longitudes_microdeg,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let rebuilt = match
    try_build_simple_packed_sections_with_scaling(
      defined_values,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for -irr_grid record " +
        meta.record_index.to_string(),
      )
  }
  let (sec5, sec7) = rebuilt
  let sec6 = match bitmap_raw {
    Some(v) =>
      @lib.encode_section6_bytes({ bitmap_indicator: 0, bitmap_raw: v })
    None =>
      @lib.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(sec3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_irr_grid_output(
  requested_points_spec : String,
  radius_spec : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let requested_points = match
    parse_irr_grid_requested_points(requested_points_spec) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  match validate_irr_grid_radius(radius_spec) {
    Ok(_) => ()
    Err(e) => return Err(e)
  }
  let metas = @lib.decode_records(context)
  let out : Array[Byte] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -irr_grid record " +
            record_index.to_string(),
          )
        }
        let meta = metas[meta_index]
        if meta.section3_template.id() != 0 ||
          meta.section3_ni <= 0 ||
          meta.section3_nj <= 0 {
          return Err(
            "-irr_grid currently supports regular lat/lon grid (template 3.0)",
          )
        }
        let bytes = match
          build_irr_grid_submessage_bytes(
            message, submessage, meta, requested_points,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, bytes)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_grib_out_irr_output(
  selector : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  if selector != "all" && selector != "defined" {
    return Err("-grib_out_irr selector must be all or defined")
  }
  let metas = @lib.decode_records(context)
  let out : Array[Byte] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -grib_out_irr record " +
            record_index.to_string(),
          )
        }
        let meta = metas[meta_index]
        if meta.section3_template.id() != 0 ||
          meta.section3_ni <= 0 ||
          meta.section3_nj <= 0 {
          return Err(
            "-grib_out_irr currently supports regular lat/lon grid (template 3.0)",
          )
        }
        let bytes = match
          build_grib_out_irr_submessage_bytes(
            message, submessage, meta, selector,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, bytes)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn collect_points_for_grib_out_irr(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  selector : String,
) -> Result[(Array[Int], Array[Int], Array[Double], Bytes?), String] {
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) => return Err("failed to unpack data for -grib_out_irr")
  }
  let total_points = meta.section3_ni * meta.section3_nj
  if unpacked.length() != total_points {
    return Err("failed to derive regular-grid values for -grib_out_irr")
  }
  let latitudes : Array[Int] = []
  let longitudes : Array[Int] = []
  let defined_values : Array[Double] = []
  if selector == "defined" {
    for j = 1; j <= meta.section3_nj; j = j + 1 {
      for i = 1; i <= meta.section3_ni; i = i + 1 {
        let idx = match value_index_for_ij(meta, i, j) {
          Some(v) => v
          None => return Err("invalid ij point in -grib_out_irr")
        }
        let value = unpacked[idx]
        if value != value {
          continue
        }
        let (lon_microdeg, lat_microdeg) = match
          grid_ij_to_latlon_microdeg_from_meta(meta, i, j) {
          Some(v) => v
          None => return Err("failed to derive lon/lat for -grib_out_irr")
        }
        latitudes.push(lat_microdeg)
        longitudes.push(lon_microdeg)
        defined_values.push(value)
      }
    }
    return Ok((latitudes, longitudes, defined_values, None))
  }
  let bitmap_out : Array[Byte] = Array::make((total_points + 7) / 8, b'\x00')
  let mut needs_bitmap = false
  let mut point = 0
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      let idx = match value_index_for_ij(meta, i, j) {
        Some(v) => v
        None => return Err("invalid ij point in -grib_out_irr")
      }
      let (lon_microdeg, lat_microdeg) = match
        grid_ij_to_latlon_microdeg_from_meta(meta, i, j) {
        Some(v) => v
        None => return Err("failed to derive lon/lat for -grib_out_irr")
      }
      latitudes.push(lat_microdeg)
      longitudes.push(lon_microdeg)
      let value = unpacked[idx]
      if value == value {
        defined_values.push(value)
        bitmap_mark_defined(bitmap_out, point)
      } else {
        needs_bitmap = true
      }
      point += 1
    }
  }
  Ok(
    (
      latitudes,
      longitudes,
      defined_values,
      if needs_bitmap {
        Some(Bytes::from_array(bitmap_out))
      } else {
        None
      },
    ),
  )
}

///|
fn build_grib_out_irr_section3_bytes(
  meta : @lib.Grib2RecordMeta,
  latitudes_microdeg : Array[Int],
  longitudes_microdeg : Array[Int],
) -> Bytes {
  let npts = latitudes_microdeg.length()
  let out : Array[Byte] = []
  append_u32_bytes(out, 30 + npts * 8, true)
  out.push(b'\x03')
  out.push(b'\x00')
  append_u32_bytes(out, npts, true)
  out.push(b'\x00')
  out.push(b'\x00')
  out.push(b'\x00')
  out.push(b'\x82')
  out.push(meta.section3_shape_of_earth.to_byte())
  out.push(meta.section3_scale_factor_radius.to_byte())
  append_u32_bytes(out, meta.section3_scaled_value_radius, true)
  out.push(meta.section3_scale_factor_major.to_byte())
  append_u32_bytes(out, meta.section3_scaled_value_major, true)
  out.push(meta.section3_scale_factor_minor.to_byte())
  append_u32_bytes(out, meta.section3_scaled_value_minor, true)
  for point in 0..<npts {
    append_u32_bytes(
      out,
      encode_i32_sign_magnitude(latitudes_microdeg[point]),
      true,
    )
    append_u32_bytes(
      out,
      encode_i32_sign_magnitude(longitudes_microdeg[point]),
      true,
    )
  }
  Bytes::from_array(out)
}

///|
fn build_grib_out_irr_submessage_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  selector : String,
) -> Result[Bytes, String] {
  let (latitudes_microdeg, longitudes_microdeg, defined_values, bitmap_raw) = match
    collect_points_for_grib_out_irr(message, submessage, meta, selector) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect values for -grib_out_irr record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let sec3 = build_grib_out_irr_section3_bytes(
    meta, latitudes_microdeg, longitudes_microdeg,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let rebuilt = match
    try_build_simple_packed_sections_with_scaling(
      defined_values,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for -grib_out_irr record " +
        meta.record_index.to_string(),
      )
  }
  let (sec5, sec7) = rebuilt
  let sec6 = match bitmap_raw {
    Some(v) =>
      @lib.encode_section6_bytes({ bitmap_indicator: 0, bitmap_raw: v })
    None =>
      @lib.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(sec3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn uuid_hex_value(code_unit : UInt16) -> Int? {
  let code = code_unit.to_int()
  if code >= '0'.to_int() && code <= '9'.to_int() {
    return Some(code - '0'.to_int())
  }
  if code >= 'a'.to_int() && code <= 'f'.to_int() {
    return Some(code - 'a'.to_int() + 10)
  }
  if code >= 'A'.to_int() && code <= 'F'.to_int() {
    return Some(code - 'A'.to_int() + 10)
  }
  None
}

///|
fn parse_uuid_bytes(uuid : String) -> Bytes? {
  if uuid.length() != 36 {
    return None
  }
  for hyphen_index in [8, 13, 18, 23] {
    if uuid[hyphen_index].to_int() != '-'.to_int() {
      return None
    }
  }
  let out : Array[Byte] = []
  let mut index = 0
  while index < uuid.length() {
    if uuid[index].to_int() == '-'.to_int() {
      index += 1
      continue
    }
    if index + 1 >= uuid.length() {
      return None
    }
    let high = match uuid_hex_value(uuid[index]) {
      Some(v) => v
      None => return None
    }
    let low = match uuid_hex_value(uuid[index + 1]) {
      Some(v) => v
      None => return None
    }
    out.push(((high << 4) | low).to_byte())
    index += 2
  }
  if out.length() != 16 {
    return None
  }
  Some(Bytes::from_array(out))
}

///|
fn bitmap_mark_defined(bitmap_raw : Array[Byte], bit_index : Int) -> Unit {
  let byte_index = bit_index / 8
  if byte_index >= bitmap_raw.length() {
    return
  }
  let bit_offset = 7 - bit_index % 8
  let mask = 1 << bit_offset
  let current = bitmap_raw[byte_index].to_uint().reinterpret_as_int()
  bitmap_raw[byte_index] = (current | mask).to_byte()
}

///|
fn collect_points_for_grib_out_irr2(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  npnts : Int,
) -> Result[(Array[Double], Bytes?), String] {
  let wgrib2_scan_order = match
    @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) => return Err("failed to unpack data for -grib_out_irr2")
  }
  let defined_values : Array[Double] = []
  let bitmap_out : Array[Byte] = Array::make((npnts + 7) / 8, b'\x00')
  let mut needs_bitmap = false
  for point in 0..<npnts {
    let defined = if point < wgrib2_scan_order.length() {
      let value = wgrib2_scan_order[point]
      value == value
    } else {
      false
    }
    if defined {
      defined_values.push(wgrib2_scan_order[point])
      bitmap_mark_defined(bitmap_out, point)
    } else {
      needs_bitmap = true
    }
  }
  Ok(
    (
      defined_values,
      if needs_bitmap {
        Some(Bytes::from_array(bitmap_out))
      } else {
        None
      },
    ),
  )
}

///|
fn build_grib_out_irr2_section3_bytes(
  npnts : Int,
  grid_no : Int,
  grid_ref : Int,
  uuid_bytes : Bytes,
  shape_of_earth : Int,
) -> Bytes {
  let section3 : @lib.Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: npnts,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: @section3.GridTemplate3101({
      shape_of_earth,
      number_of_grid_used: grid_no,
      number_of_grid_in_reference: grid_ref,
      uuid_of_horizontal_grid: uuid_bytes,
    }),
    optional_points_raw: b"",
  }
  @lib.encode_section3_bytes(section3)
}

///|
fn build_grib_out_irr2_submessage_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  npnts : Int,
  grid_no : Int,
  grid_ref : Int,
  uuid_bytes : Bytes,
) -> Result[Bytes, String] {
  let (defined_values, bitmap_raw) = match
    collect_points_for_grib_out_irr2(message, submessage, npnts) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect values for -grib_out_irr2 record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      defined_values,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for -grib_out_irr2 record " +
        meta.record_index.to_string(),
      )
  }
  let sec3 = build_grib_out_irr2_section3_bytes(
    npnts,
    grid_no,
    grid_ref,
    uuid_bytes,
    if meta.section3_shape_of_earth >= 0 {
      meta.section3_shape_of_earth
    } else {
      0
    },
  )
  let sec6 = match bitmap_raw {
    Some(v) =>
      @lib.encode_section6_bytes({ bitmap_indicator: 0, bitmap_raw: v })
    None =>
      @lib.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
  }
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(sec3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_grib_out_irr2_output(
  npnts : String,
  grid_no : String,
  grid_ref : String,
  uuid : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let npnts_int = match parse_int_option(npnts) {
    Some(v) => v
    None => return Err("-grib_out_irr2 npnts must be an integer")
  }
  if npnts_int <= 0 {
    return Err("-grib_out_irr2 npnts must be > 0")
  }
  let grid_no_int = match parse_int_option(grid_no) {
    Some(v) => v
    None => return Err("-grib_out_irr2 grid_no must be an integer")
  }
  if grid_no_int < 0 || grid_no_int > 16777215 {
    return Err("-grib_out_irr2 grid_no must be in 0..16777215")
  }
  let grid_ref_int = match parse_int_option(grid_ref) {
    Some(v) => v
    None => return Err("-grib_out_irr2 grid_ref must be an integer")
  }
  if grid_ref_int < 0 || grid_ref_int > 255 {
    return Err("-grib_out_irr2 grid_ref must be in 0..255")
  }
  let uuid_bytes = match parse_uuid_bytes(uuid) {
    Some(v) => v
    None =>
      return Err("-grib_out_irr2 uuid must be a canonical 36-char hex UUID")
  }
  let metas = @lib.decode_records(context)
  let out : Array[Byte] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -grib_out_irr2 record " +
            record_index.to_string(),
          )
        }
        let bytes = match
          build_grib_out_irr2_submessage_bytes(
            message,
            submessage,
            metas[meta_index],
            npnts_int,
            grid_no_int,
            grid_ref_int,
            uuid_bytes,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, bytes)
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_new_grid_order_output(
  out_path : String,
  out2_path : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  // Limited compatibility: write selected records to out_path and create/append out2_path.
  match write_raw_output(out_path, context, selected, append_mode) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if append_mode {
    native_append_bytes(out2_path, Bytes::new(0))
  } else {
    native_write_bytes(out2_path, Bytes::new(0))
  }
}

///|
fn collect_selected_record_refs(
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
) -> Array[SelectedRecordRef] {
  let refs : Array[SelectedRecordRef] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      if record_is_selected(record_index, selected) {
        refs.push({ record_index, message_index, submessage_index })
      }
      record_index += 1
    }
  }
  refs
}

///|
fn vector_pair_messages_compatible(
  context : @lib.Grib2FileContext,
  lhs : SelectedRecordRef,
  rhs : SelectedRecordRef,
) -> Bool {
  let lhs_message = context.messages[lhs.message_index]
  let rhs_message = context.messages[rhs.message_index]
  lhs_message.discipline == rhs_message.discipline &&
  section_frame_bytes(lhs_message, lhs_message.section1) ==
  section_frame_bytes(rhs_message, rhs_message.section1)
}

///|
fn build_grouped_submessage_grib_bytes(
  context : @lib.Grib2FileContext,
  refs : Array[SelectedRecordRef],
) -> Result[Bytes, String] {
  if refs.length() == 0 {
    return Err("internal: empty record group for vector combine output")
  }
  let header_message = context.messages[refs[0].message_index]
  let body : Array[Byte] = []
  append_bytes(
    body,
    section_frame_bytes(header_message, header_message.section1),
  )
  let mut previous_section3 : Bytes? = None
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    if message.discipline != header_message.discipline {
      return Err("vector combine requires a common discipline")
    }
    let submessage = message.submessages[record_ref.submessage_index]
    match submessage.section2 {
      Some(section2) =>
        append_bytes(body, section_frame_bytes(message, section2))
      None => ()
    }
    let section3 = section_frame_bytes(message, submessage.section3)
    let include_section3 = match previous_section3 {
      Some(prev) => prev != section3
      None => true
    }
    if include_section3 {
      append_bytes(body, section3)
    }
    previous_section3 = Some(section3)
    append_bytes(body, section_frame_bytes(message, submessage.section4))
    append_bytes(body, section_frame_bytes(message, submessage.section5))
    append_bytes(body, section_frame_bytes(message, submessage.section6))
    append_bytes(body, section_frame_bytes(message, submessage.section7))
  }
  let total_len = 16 + body.length() + 4
  let sec0 = build_sec0_with_length(header_message, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, Bytes::from_array(body))
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  Ok(Bytes::from_array(out))
}

///|
fn write_vector_combine_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let metas = @lib.decode_records(context)
  let refs = collect_selected_record_refs(context, selected)
  let u_candidates : Map[Bytes, SelectedRecordRef] = {}
  let v_candidates : Map[Bytes, SelectedRecordRef] = {}
  for record_ref in refs {
    let meta_index = record_ref.record_index - 1
    if meta_index >= metas.length() {
      continue
    }
    let meta = metas[meta_index]
    if !is_wind_u_component(meta) && !is_wind_v_component(meta) {
      continue
    }
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let pair_key = build_wind_pair_key(message, submessage)
    if pair_key.length() == 0 {
      continue
    }
    if is_wind_u_component(meta) {
      u_candidates.set(pair_key, record_ref)
    } else if is_wind_v_component(meta) {
      v_candidates.set(pair_key, record_ref)
    }
  }
  let consumed = Array::make(metas.length() + 1, false)
  let out : Array[Byte] = []
  for record_ref in refs {
    if record_ref.record_index < consumed.length() &&
      consumed[record_ref.record_index] {
      continue
    }
    let meta_index = record_ref.record_index - 1
    if meta_index < metas.length() {
      let meta = metas[meta_index]
      if is_wind_u_component(meta) || is_wind_v_component(meta) {
        let message = context.messages[record_ref.message_index]
        let submessage = message.submessages[record_ref.submessage_index]
        let pair_key = build_wind_pair_key(message, submessage)
        if pair_key.length() > 0 {
          match u_candidates.get(pair_key) {
            Some(u_ref) =>
              match v_candidates.get(pair_key) {
                Some(v_ref) => {
                  let first_index = if u_ref.record_index < v_ref.record_index {
                    u_ref.record_index
                  } else {
                    v_ref.record_index
                  }
                  if record_ref.record_index == first_index &&
                    vector_pair_messages_compatible(context, u_ref, v_ref) {
                    let pair_refs : Array[SelectedRecordRef] = [u_ref, v_ref]
                    let combined = match
                      build_grouped_submessage_grib_bytes(context, pair_refs) {
                      Ok(v) => v
                      Err(e) => return Err(e)
                    }
                    append_bytes(out, combined)
                    consumed[u_ref.record_index] = true
                    consumed[v_ref.record_index] = true
                    continue
                  }
                }
                None => ()
              }
            None => ()
          }
        }
      }
    }
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    append_bytes(out, build_submessage_grib_bytes(message, submessage))
    if record_ref.record_index < consumed.length() {
      consumed[record_ref.record_index] = true
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_tosubmsg_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let same_as_previous_section6 = b"\x00\x00\x00\x06\x06\xfe"
  let mut base_discipline : Int? = None
  let mut base_message : @lib.Grib2MessageContext? = None
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      if record_is_selected(record_index, selected) && base_discipline is None {
        base_discipline = Some(message.discipline)
        base_message = Some(message)
      }
      record_index += 1
    }
  }
  match base_discipline {
    None =>
      if append_mode {
        return native_append_bytes(destination, Bytes::new(0))
      } else {
        return native_write_bytes(destination, Bytes::new(0))
      }
    Some(_) => ()
  }
  let base = match base_discipline {
    Some(v) => v
    None => 0
  }
  let message_for_header = match base_message {
    Some(v) => v
    None => return Err("internal: base message not found for -tosubmsg")
  }
  let body : Array[Byte] = []
  append_bytes(
    body,
    section_frame_bytes(message_for_header, message_for_header.section1),
  )
  let mut previous_section3 : Bytes? = None
  let mut previous_section6 : Bytes? = None
  record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if !record_is_selected(record_index, selected) ||
        message.discipline != base {
        record_index += 1
        continue
      }
      match submessage.section2 {
        Some(section2) =>
          append_bytes(body, section_frame_bytes(message, section2))
        None => ()
      }
      let section3 = section_frame_bytes(message, submessage.section3)
      let include_section3 = match previous_section3 {
        Some(prev) => prev != section3
        None => true
      }
      if include_section3 {
        append_bytes(body, section3)
      }
      previous_section3 = Some(section3)
      append_bytes(body, section_frame_bytes(message, submessage.section4))
      append_bytes(body, section_frame_bytes(message, submessage.section5))
      let section6 = section_frame_bytes(message, submessage.section6)
      let include_full_section6 = match previous_section6 {
        Some(prev) => prev != section6
        None => true
      }
      if include_full_section6 {
        append_bytes(body, section6)
      } else if section6.length() == 6 && section6[5] == b'\xff' {
        append_bytes(body, section6)
      } else {
        append_bytes(body, same_as_previous_section6)
      }
      previous_section6 = Some(section6)
      append_bytes(body, section_frame_bytes(message, submessage.section7))
      record_index += 1
    }
  }
  let total_len = 16 + body.length() + 4
  let sec0 = build_sec0_with_length(message_for_header, total_len)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, Bytes::from_array(body))
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  out.push(b'7')
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn reduced_gaussian_method_supported(interp_method : String) -> Bool {
  interp_method == "neighbor" ||
  interp_method == "neighbor-extrapolate" ||
  interp_method == "linear" ||
  interp_method == "linear-extrapolate"
}

///|
fn is_reduced_gaussian_interp_linear(interp_method : String) -> Bool {
  interp_method == "linear" || interp_method == "linear-extrapolate"
}

///|
fn is_reduced_gaussian_template_id(template_id : Int) -> Bool {
  template_id == 40 ||
  template_id == 41 ||
  template_id == 42 ||
  template_id == 43
}

///|
fn decode_reduced_gaussian_row_counts_for_cli(
  section3 : @lib.Grib2Section3Decoded,
  expected_rows : Int,
) -> Array[Int]? {
  let octets = section3.optional_points_octet_count
  if expected_rows <= 0 || octets <= 0 || octets > 4 {
    return None
  }
  if section3.optional_points_interpretation != 1 {
    return None
  }
  let raw = section3.optional_points_raw
  if raw.length() != expected_rows * octets {
    return None
  }
  let row_counts : Array[Int] = []
  for row in 0..<expected_rows {
    let mut value = 0
    let offset = row * octets
    for byte_index in 0..<octets {
      value = (value << 8) |
        raw[offset + byte_index].to_uint().reinterpret_as_int()
    }
    row_counts.push(value)
  }
  Some(row_counts)
}

///|
fn build_reduced_gaussian_row_offsets(row_counts : Array[Int]) -> Array[Int] {
  let offsets : Array[Int] = Array::make(row_counts.length(), 0)
  let mut offset = 0
  for index in 0..<row_counts.length() {
    offsets[index] = offset
    offset += row_counts[index]
  }
  offsets
}

///|
fn normalize_reduced_gaussian_values_for_cli(
  section3 : @lib.Grib2Section3Decoded,
  values : Array[Double],
) -> Result[(Array[Double], Array[Int]), String] {
  let grid_info = @lib.get_section3_grid_info(section3.template)
  let nj = grid_info.nj
  if nj <= 0 {
    return Err("failed to determine reduced Gaussian row count")
  }
  let scan = @lib.parse_scanning_mode(grid_info.scan_mode)
  if scan.consecutive_j || scan.alternating_rows {
    return Err(
      "-reduced_gaussian_grid currently requires consecutive-i Gaussian rows",
    )
  }
  let input_row_counts = match
    decode_reduced_gaussian_row_counts_for_cli(section3, nj) {
    Some(v) => v
    None => return Err("failed to decode reduced Gaussian row counts")
  }
  let input_offsets = build_reduced_gaussian_row_offsets(input_row_counts)
  let output_offsets : Array[Int] = Array::make(nj, 0)
  let output_row_counts : Array[Int] = Array::make(nj, 0)
  let mut output_total = 0
  for j_out in 0..<nj {
    output_offsets[j_out] = output_total
    let j_in = if scan.j_positive { j_out } else { nj - 1 - j_out }
    let row_count = input_row_counts[j_in]
    output_row_counts[j_out] = row_count
    output_total += row_count
  }
  if output_total != values.length() {
    return Err(
      "reduced Gaussian point count mismatch: values=" +
      values.length().to_string() +
      " rows=" +
      output_total.to_string(),
    )
  }
  let normalized : Array[Double] = Array::make(output_total, 0.0)
  for j_out in 0..<nj {
    let j_in = if scan.j_positive { j_out } else { nj - 1 - j_out }
    let row_count = input_row_counts[j_in]
    let src_start = input_offsets[j_in]
    let dst_start = output_offsets[j_out]
    for i_out in 0..<row_count {
      let i_in = if scan.i_negative { row_count - 1 - i_out } else { i_out }
      normalized[dst_start + i_out] = values[src_start + i_in]
    }
  }
  Ok((normalized, output_row_counts))
}

///|
fn reduced_gaussian_target_ni(row_counts : Array[Int], n : Int) -> Int {
  let mut max_count = 0
  for row_count in row_counts {
    if row_count > max_count {
      max_count = row_count
    }
  }
  let regular_count = if n > 0 { 4 * n } else { 0 }
  if regular_count > max_count {
    regular_count
  } else {
    max_count
  }
}

///|
fn append_reduced_gaussian_interpolated_row(
  out : Array[Double],
  values : Array[Double],
  row_start : Int,
  row_count : Int,
  target_count : Int,
  linear : Bool,
) -> Result[Unit, String] {
  if row_count <= 0 || target_count <= 0 {
    return Err("reduced Gaussian interpolation requires positive row sizes")
  }
  if row_start < 0 || row_start + row_count > values.length() {
    return Err("reduced Gaussian row slice out of bounds")
  }
  let to_wgrib2_float = fn(value : Double) -> Double {
    Float::from_double(value).to_double()
  }
  for i in 0..<target_count {
    let x = i.to_double() * row_count.to_double() / target_count.to_double()
    let left = @math.floor(x).to_int()
    if linear {
      let frac = x - left.to_double()
      let right = if left + 1 < row_count { left + 1 } else { 0 }
      let v0 = to_wgrib2_float(values[row_start + left])
      let v1 = to_wgrib2_float(values[row_start + right])
      let interpolated = (1.0 - frac) * v0 + frac * v1
      out.push(to_wgrib2_float(interpolated))
    } else {
      let mut nearest = @math.floor(x + 0.5).to_int()
      if nearest >= row_count {
        nearest -= row_count
      }
      out.push(to_wgrib2_float(values[row_start + nearest]))
    }
  }
  Ok(())
}

///|
fn regularize_reduced_gaussian_values(
  values : Array[Double],
  row_counts : Array[Int],
  target_ni : Int,
  interp_method : String,
) -> Result[Array[Double], String] {
  let row_offsets = build_reduced_gaussian_row_offsets(row_counts)
  let linear = is_reduced_gaussian_interp_linear(interp_method)
  let out : Array[Double] = []
  for row_index in 0..<row_counts.length() {
    let row_count = row_counts[row_index]
    if row_count == target_ni {
      for offset in 0..<row_count {
        out.push(
          Float::from_double(values[row_offsets[row_index] + offset]).to_double(),
        )
      }
    } else {
      match
        append_reduced_gaussian_interpolated_row(
          out,
          values,
          row_offsets[row_index],
          row_count,
          target_ni,
          linear,
        ) {
        Ok(_) => ()
        Err(e) => return Err(e)
      }
    }
  }
  Ok(out)
}

///|
fn build_reduced_gaussian_regular_section3_bytes(
  section3 : @lib.Grib2Section3Decoded,
  target_ni : Int,
) -> Result[Bytes, String] {
  if target_ni <= 0 {
    return Err("reduced Gaussian target grid must have positive ni")
  }
  let target_di = (360_000_000L / target_ni.to_int64()).to_int()
  match section3.template {
    @section3.GridTemplate340(grid) => {
      let mut lo2 = (grid.lo1.to_int64() +
      (target_ni - 1).to_int64() * target_di.to_int64()).to_int()
      while lo2 < 0 {
        lo2 += 360_000_000
      }
      while lo2 >= 360_000_000 {
        lo2 -= 360_000_000
      }
      Ok(
        @lib.encode_section3_bytes({
          source_of_grid_definition: section3.source_of_grid_definition,
          number_of_data_points: target_ni * grid.nj,
          optional_points_octet_count: 0,
          optional_points_interpretation: 0,
          template: @section3.GridTemplate340({
            shape_of_earth: grid.shape_of_earth,
            scale_factor_radius: grid.scale_factor_radius,
            scaled_value_radius: grid.scaled_value_radius,
            scale_factor_major_axis: grid.scale_factor_major_axis,
            scaled_value_major_axis: grid.scaled_value_major_axis,
            scale_factor_minor_axis: grid.scale_factor_minor_axis,
            scaled_value_minor_axis: grid.scaled_value_minor_axis,
            ni: target_ni,
            nj: grid.nj,
            basic_angle: grid.basic_angle,
            subdivisions_of_basic_angle: grid.subdivisions_of_basic_angle,
            la1: grid.la1,
            lo1: grid.lo1,
            resolution_and_component_flags: grid.resolution_and_component_flags,
            la2: grid.la2,
            lo2,
            di: target_di,
            n: grid.n,
            scanning_mode: 0,
          }),
          optional_points_raw: b"",
        }),
      )
    }
    _ => Err("-reduced_gaussian_grid currently supports Gaussian template 3.40")
  }
}

///|
fn build_reduced_gaussian_submessage_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  interp_method : String,
) -> Result[Bytes, String] {
  let section3 = match @lib.decode_submessage_section3(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 3: \{e}")
  }
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(e) =>
      return Err(
        "failed to unpack reduced Gaussian data: " + unpack_error_string(e),
      )
  }
  let (normalized_values, row_counts) = match
    normalize_reduced_gaussian_values_for_cli(section3, unpacked) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let target_ni = match section3.template {
    @section3.GridTemplate340(grid) =>
      reduced_gaussian_target_ni(row_counts, grid.n)
    _ => reduced_gaussian_target_ni(row_counts, 0)
  }
  let regularized_values = match
    regularize_reduced_gaussian_values(
      normalized_values, row_counts, target_ni, interp_method,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let sec3 = match
    build_reduced_gaussian_regular_section3_bytes(section3, target_ni) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let rebuilt = try_build_simple_packed_sections_with_scaling(
    regularized_values,
    meta.section5_reference_value_ieee,
    meta.section5_binary_scale_factor,
    meta.section5_decimal_scale_factor,
    original_field_value_type,
  )
  let (sec5, sec7) = match rebuilt {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for -reduced_gaussian_grid record " +
        meta.record_index.to_string(),
      )
  }
  let sec6 = @lib.encode_section6_bytes({
    bitmap_indicator: 255,
    bitmap_raw: b"",
  })
  Ok(
    build_submessage_grib_bytes_with_section_overrides(
      message,
      submessage,
      Some(sec3),
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_reduced_gaussian_grid_output(
  destination : String,
  y_arg : String,
  interp_method : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  if y_arg != "-1" {
    return Err("reduced_gaussian_grid: arg: " + y_arg + " should be -1")
  }
  if !reduced_gaussian_method_supported(interp_method) {
    return Err(
      "reduced_gaussian_grid: method must be neighbor|linear[-extrapolate]",
    )
  }
  let metas = @lib.decode_records(context)
  let out : Array[Byte] = []
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      let submessage = message.submessages[submessage_index]
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index >= metas.length() {
          return Err(
            "internal: record metadata missing for -reduced_gaussian_grid record " +
            record_index.to_string(),
          )
        }
        let meta = metas[meta_index]
        if is_reduced_gaussian_template_id(meta.section3_template.id()) {
          let bytes = match
            build_reduced_gaussian_submessage_bytes(
              message, submessage, meta, interp_method,
            ) {
            Ok(v) => v
            Err(e) => return Err(e)
          }
          append_bytes(out, bytes)
        }
      }
      record_index += 1
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn parse_time_step_spec(spec : String) -> (Int, Int)? {
  if spec.has_suffix("mn") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((0, v))
      _ => None
    }
  }
  if spec.has_suffix("hr") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((1, v))
      _ => None
    }
  }
  if spec.has_suffix("dy") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((2, v))
      _ => None
    }
  }
  if spec.has_suffix("mo") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((3, v))
      _ => None
    }
  }
  if spec.has_suffix("yr") {
    let n = spec.substring(end=spec.length() - 2)
    let value = parse_int_option(n)
    return match value {
      Some(v) if v >= 0 => Some((4, v))
      _ => None
    }
  }
  None
}

///|
fn parse_unmerge_fcst_time_spec(spec : String) -> (Int, Int)? {
  parse_time_step_spec(spec)
}

///|
fn parse_timestamp14_components(
  timestamp : String,
) -> (Int, Int, Int, Int, Int, Int)? {
  if timestamp.length() != 14 {
    return None
  }
  let year = parse_int_option(timestamp.substring(start=0, end=4))
  let month = parse_int_option(timestamp.substring(start=4, end=6))
  let day = parse_int_option(timestamp.substring(start=6, end=8))
  let hour = parse_int_option(timestamp.substring(start=8, end=10))
  let minute = parse_int_option(timestamp.substring(start=10, end=12))
  let second = parse_int_option(timestamp.substring(start=12, end=14))
  match (year, month, day, hour, minute, second) {
    (Some(y), Some(m), Some(d), Some(h), Some(mi), Some(s)) =>
      Some((y, m, d, h, mi, s))
    _ => None
  }
}

///|
fn build_time_processing_section4_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  statistical_process : Int,
  type_of_time_increment : Int,
  step_unit : Int,
  step_length : Int,
  zero_cutoff : Bool,
) -> Result[Bytes, String] {
  let section4 = match @lib.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        option_name +
        ": failed to decode Section 4 for record " +
        meta.record_index.to_string() +
        ": " +
        error.to_string(),
      )
  }
  let base = match section4.template {
    @section4.ProductTemplate40(base) => base
    _ =>
      return Err(
        option_name +
        " is only implemented for product template 4.0 (record " +
        meta.record_index.to_string() +
        ")",
      )
  }
  let timestamp = if meta.unix_vt >= 0 {
    format_timestamp14_from_unix(meta.unix_vt)
  } else {
    meta.reference_time_full
  }
  let (end_year, end_month, end_day, end_hour, end_minute, end_second) = match
    parse_timestamp14_components(timestamp) {
    Some(v) => v
    None =>
      return Err(
        option_name +
        ": failed to parse verification time for record " +
        meta.record_index.to_string(),
      )
  }
  let template48 : @section4.Grib2ProductTemplate48 = {
    base: {
      ..base,
      minutes_of_observational_data_cutoff: if zero_cutoff {
        base.minutes_of_observational_data_cutoff
      } else {
        255
      },
    },
    end_year,
    end_month,
    end_day,
    end_hour,
    end_minute,
    end_second,
    number_of_time_ranges: 1,
    number_of_missing_values: 0,
    time_range_specs: [
      (
        {
          statistical_process,
          type_of_time_increment,
          time_range_unit: step_unit,
          time_range_length: 0,
          time_increment_unit: step_unit,
          time_increment_length: step_length,
        } : @section4.Grib2TimeRangeSpec),
    ],
    reserved_tail: b"",
  }
  Ok(
    @lib.encode_section4_bytes({
      number_of_coordinate_values: section4.number_of_coordinate_values,
      template: @section4.ProductTemplate48(template48),
      coordinate_values_raw: section4.coordinate_values_raw,
    }),
  )
}

///|
fn build_simple_packed_submessage_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  section4 : Bytes,
  section6 : Bytes,
  defined_values : Array[Double],
) -> Result[Bytes, String] {
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      defined_values,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for " +
        option_name +
        " record " +
        meta.record_index.to_string(),
      )
  }
  Ok(
    build_submessage_grib_bytes_with_overrides(
      message,
      submessage,
      Some(section4),
      Some(sec5),
      Some(section6),
      Some(sec7),
    ),
  )
}

///|
fn try_build_simple_packed_sections_with_forecast_scaling(
  values : Array[Double],
  reference_value_ieee : Int,
  binary_scale_factor : Int,
  decimal_scale_factor : Int,
  original_field_value_type : Int,
) -> (Bytes, Bytes)? {
  let working_values : Array[Double] = []
  for value in values {
    if value != value {
      return None
    }
    working_values.push(Float::from_double(value).to_double())
  }
  let mut min_value = Float::reinterpret_from_int(reference_value_ieee).to_double()
  let mut max_value = min_value
  if working_values.length() > 0 {
    min_value = working_values[0]
    max_value = working_values[0]
    for value in working_values {
      if value < min_value {
        min_value = value
      }
      if value > max_value {
        max_value = value
      }
    }
  }
  let constant_field = working_values.length() == 0 || min_value == max_value
  let output_binary_scale_factor = if constant_field {
    0
  } else {
    binary_scale_factor
  }
  let output_decimal_scale_factor = if constant_field {
    0
  } else {
    decimal_scale_factor
  }
  let original_min_value = min_value
  let decimal_scale = pow10_int(output_decimal_scale_factor)
  if output_decimal_scale_factor != 0 {
    min_value = Float::from_double(min_value * decimal_scale).to_double()
    max_value = Float::from_double(max_value * decimal_scale).to_double()
    for index in 0..<working_values.length() {
      working_values[index] = Float::from_double(
        working_values[index] * decimal_scale,
      ).to_double()
    }
  }
  let reference_value = if constant_field {
    original_min_value
  } else {
    min_value
  }
  let output_reference_value_ieee = if working_values.length() == 0 {
    0
  } else {
    Float::from_double(reference_value).reinterpret_as_int()
  }
  let binary_scale = pow2_int(-output_binary_scale_factor)
  let packed_values : Array[Int] = []
  let mut max_packed = 0
  for value in working_values {
    let packed_float = if output_binary_scale_factor == 0 {
      Float::from_double(value - reference_value).to_double()
    } else {
      Float::from_double((value - reference_value) * binary_scale).to_double()
    }
    let packed = @math.floor(packed_float + 0.5).to_int()
    let nonnegative = if packed < 0 { 0 } else { packed }
    if nonnegative > max_packed {
      max_packed = nonnegative
    }
    packed_values.push(nonnegative)
  }
  let bits_per_value = if constant_field {
    0
  } else {
    required_bits_nonnegative(max_packed)
  }
  if bits_per_value > 31 {
    return None
  }
  let sec5 = @lib.encode_section5_bytes({
    number_of_data_points: working_values.length(),
    template: DataRepresentationTemplate50({
      reference_value_ieee: output_reference_value_ieee,
      binary_scale_factor: encode_i16_sign_magnitude(output_binary_scale_factor),
      decimal_scale_factor: encode_i16_sign_magnitude(
        output_decimal_scale_factor,
      ),
      bits_per_value,
      original_field_value_type,
      reserved_tail: b"",
    }),
  })
  let sec7 = @lib.encode_section7_bytes({
    template: DataTemplate70({
      data_values_raw: pack_unsigned_values_be(packed_values, bits_per_value),
    }),
  })
  Some((sec5, sec7))
}

///|
fn build_time_processing_submessage_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  statistical_process : Int,
  type_of_time_increment : Int,
  step_unit : Int,
  step_length : Int,
  zero_cutoff : Bool,
) -> Result[Bytes, String] {
  let section4 = match
    build_time_processing_section4_bytes(
      option_name, message, submessage, meta, statistical_process, type_of_time_increment,
      step_unit, step_length, zero_cutoff,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      option_name +
      " is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for " +
        option_name,
      )
  }
  let defined_values = match
    collect_defined_values_for_grib_out(message, submessage, unpacked) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect defined values for " +
        option_name +
        " record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let sec6 = match build_grib_out_section6_bytes(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to resolve Section 6 for " +
        option_name +
        " record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  build_simple_packed_submessage_bytes(
    option_name, message, submessage, meta, section4, sec6, defined_values,
  )
}

///|
fn build_all_undefined_bitmap_section6_bytes(npts : Int) -> Bytes {
  @lib.encode_section6_bytes({
    bitmap_indicator: 0,
    bitmap_raw: Bytes::from_array(Array::make((npts + 7) / 8, b'\x00')),
  })
}

///|
fn build_no_bitmap_section6_bytes() -> Bytes {
  @lib.encode_section6_bytes({ bitmap_indicator: 255, bitmap_raw: b"" })
}

///|
fn build_defined_zero_field_submessage_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  section4 : Bytes,
) -> Result[Bytes, String] {
  build_simple_packed_submessage_bytes(
    option_name,
    message,
    submessage,
    meta,
    section4,
    build_no_bitmap_section6_bytes(),
    Array::make(meta.section3_npts, 0.0),
  )
}

///|
fn build_all_undefined_submessage_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  section4 : Bytes,
) -> Result[Bytes, String] {
  build_simple_packed_submessage_bytes(
    option_name,
    message,
    submessage,
    meta,
    section4,
    build_all_undefined_bitmap_section6_bytes(meta.section3_npts),
    [],
  )
}

///|
fn build_time_processing_empty_stddev_submessage_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  step_unit : Int,
  step_length : Int,
) -> Result[Bytes, String] {
  let section4 = match
    build_time_processing_section4_bytes(
      option_name, message, submessage, meta, 6, 1, step_unit, step_length, true,
    ) {
    Ok(v) => v
    Err(error) => return Err(error)
  }
  let sec6 = build_all_undefined_bitmap_section6_bytes(meta.section3_npts)
  build_simple_packed_submessage_bytes(
    option_name,
    message,
    submessage,
    meta,
    section4,
    sec6,
    [],
  )
}

///|
fn build_ens_processing_derived_section4_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  derived_forecast : Int,
) -> Result[Bytes, String] {
  let section4 = match @lib.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        option_name +
        ": failed to decode Section 4 for record " +
        meta.record_index.to_string() +
        ": " +
        error.to_string(),
      )
  }
  let base = match section4.template {
    @section4.ProductTemplate40(base) => base
    _ =>
      return Err(
        option_name +
        " is only implemented for product template 4.0 (record " +
        meta.record_index.to_string() +
        ")",
      )
  }
  let member_count = if meta.section4_ens_member_count > 0 {
    meta.section4_ens_member_count
  } else {
    1
  }
  Ok(
    @lib.encode_section4_bytes({
      number_of_coordinate_values: section4.number_of_coordinate_values,
      template: @section4.ProductTemplate42({
        base: ens_processing_base_template40(base),
        derived_forecast,
        number_of_forecasts_in_ensemble: member_count,
      }),
      coordinate_values_raw: section4.coordinate_values_raw,
    }),
  )
}

///|
fn ens_processing_percentile_process_code(source_process : Int) -> Int {
  if source_process == 1 {
    4
  } else {
    199
  }
}

///|
fn ens_processing_base_template40(
  base : @section4.Grib2ProductTemplate40,
) -> @section4.Grib2ProductTemplate40 {
  { ..base, minutes_of_observational_data_cutoff: 255 }
}

///|
fn build_ens_processing_percentile_section4_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  percentile_value : Int,
) -> Result[Bytes, String] {
  let section4 = match @lib.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        option_name +
        ": failed to decode Section 4 for record " +
        meta.record_index.to_string() +
        ": " +
        error.to_string(),
      )
  }
  let base = match section4.template {
    @section4.ProductTemplate40(base) => base
    _ =>
      return Err(
        option_name +
        " is only implemented for product template 4.0 (record " +
        meta.record_index.to_string() +
        ")",
      )
  }
  Ok(
    @lib.encode_section4_bytes({
      number_of_coordinate_values: section4.number_of_coordinate_values,
      template: @section4.ProductTemplate46({
        base: {
          ..ens_processing_base_template40(base),
          type_of_generating_process: ens_processing_percentile_process_code(
            base.type_of_generating_process,
          ),
        },
        percentile_value,
        reserved_tail: b"",
      }),
      coordinate_values_raw: section4.coordinate_values_raw,
    }),
  )
}

///|
fn build_ens_processing_submessage_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  section4 : Bytes,
  zero_field : Bool,
) -> Result[Bytes, String] {
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      option_name +
      " is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for " +
        option_name,
      )
  }
  let defined_values = match
    collect_defined_values_for_grib_out(message, submessage, unpacked) {
    Ok(v) => if zero_field { Array::make(v.length(), 0.0) } else { v }
    Err(e) =>
      return Err(
        "failed to collect defined values for " +
        option_name +
        " record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let sec6 = match build_grib_out_section6_bytes(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to resolve Section 6 for " +
        option_name +
        " record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  build_simple_packed_submessage_bytes(
    option_name, message, submessage, meta, section4, sec6, defined_values,
  )
}

///|
fn write_ens_processing_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  mode_arg : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  let mode = match parse_int_option(mode_arg) {
    Some(v) => v
    None => return Err("-ens_processing: mode must be 0 or 1")
  }
  if mode != 0 && mode != 1 {
    return Err("-ens_processing: mode must be 0 or 1")
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  let _ = mode
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta = match find_record_meta(context, record_ref.record_index) {
      Some(v) => v
      None =>
        return Err(
          "-ens_processing: record not found " +
          record_ref.record_index.to_string(),
        )
    }
    for derived_forecast in [8, 9, 0] {
      let section4 = match
        build_ens_processing_derived_section4_bytes(
          "-ens_processing", message, submessage, meta, derived_forecast,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let bytes = match
        build_ens_processing_submessage_bytes(
          "-ens_processing", message, submessage, meta, section4, false,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(out, bytes)
    }
    let spread_section4 = match
      build_ens_processing_derived_section4_bytes(
        "-ens_processing", message, submessage, meta, 4,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let spread = match
      build_ens_processing_submessage_bytes(
        "-ens_processing", message, submessage, meta, spread_section4, true,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    append_bytes(out, spread)
    for percentile_value in [10, 25, 50, 75, 90] {
      let section4 = match
        build_ens_processing_percentile_section4_bytes(
          "-ens_processing", message, submessage, meta, percentile_value,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let bytes = match
        build_ens_processing_submessage_bytes(
          "-ens_processing", message, submessage, meta, section4, false,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(out, bytes)
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn build_ens_qc_text_line(meta : @lib.Grib2RecordMeta) -> String {
  meta.parameter_name.display() +
  ":" +
  meta.level_name.display() +
  ":max scaled extreme=0.000000"
}

///|
fn write_ens_qc_output(
  stats_destination : String,
  extreme_destination : String,
  txt_destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  qc_version_arg : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  let qc_version = match parse_int_option(qc_version_arg) {
    Some(v) => v
    None => return Err("-ens_qc: qc_version must be 1")
  }
  if qc_version != 1 {
    return Err("-ens_qc: qc_version must be 1")
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    match write_empty_compat_output(stats_destination, append_mode) {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    match write_empty_compat_output(extreme_destination, append_mode) {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
    if append_mode {
      return native_append_string(txt_destination, "")
    } else {
      return native_write_string(txt_destination, "")
    }
  }
  let stats_out : Array[Byte] = []
  let extreme_out : Array[Byte] = []
  let txt_lines : Array[String] = []
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta = match find_record_meta(context, record_ref.record_index) {
      Some(v) => v
      None =>
        return Err(
          "-ens_qc: record not found " + record_ref.record_index.to_string(),
        )
    }
    for derived_forecast in [8, 9, 0] {
      let section4 = match
        build_ens_processing_derived_section4_bytes(
          "-ens_qc", message, submessage, meta, derived_forecast,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let bytes = match
        build_ens_processing_submessage_bytes(
          "-ens_qc", message, submessage, meta, section4, false,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(stats_out, bytes)
    }
    let spread_section4 = match
      build_ens_processing_derived_section4_bytes(
        "-ens_qc", message, submessage, meta, 4,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let spread = match
      build_defined_zero_field_submessage_bytes(
        "-ens_qc", message, submessage, meta, spread_section4,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    append_bytes(stats_out, spread)
    if meta.section4_process_code != 1 {
      let extreme_section4 = match
        build_ens_processing_derived_section4_bytes(
          "-ens_qc", message, submessage, meta, 199,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      let extreme = match
        build_all_undefined_submessage_bytes(
          "-ens_qc", message, submessage, meta, extreme_section4,
        ) {
        Ok(v) => v
        Err(error) => return Err(error)
      }
      append_bytes(extreme_out, extreme)
    }
    txt_lines.push(build_ens_qc_text_line(meta))
  }
  let txt_content = build_output_content(txt_lines, false)
  let write_stats_result = if append_mode {
    native_append_bytes(stats_destination, Bytes::from_array(stats_out))
  } else {
    native_write_bytes(stats_destination, Bytes::from_array(stats_out))
  }
  match write_stats_result {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  let write_extreme_result = if append_mode {
    native_append_bytes(extreme_destination, Bytes::from_array(extreme_out))
  } else {
    native_write_bytes(extreme_destination, Bytes::from_array(extreme_out))
  }
  match write_extreme_result {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if append_mode {
    native_append_string(txt_destination, txt_content)
  } else {
    native_write_string(txt_destination, txt_content)
  }
}

///|
fn write_time_processing_metadata_output(
  option_name : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  statistical_process : Int,
  type_of_time_increment : Int,
  time_step_spec : String,
  zero_cutoff : Bool,
  append_mode : Bool,
) -> Result[Unit, String] {
  let (step_unit, step_length) = match parse_time_step_spec(time_step_spec) {
    Some(v) => v
    None =>
      return Err(
        option_name +
        ": bad time step " +
        time_step_spec +
        " (expected (int)(mn|hr|dy|mo|yr))",
      )
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta = match find_record_meta(context, record_ref.record_index) {
      Some(v) => v
      None =>
        return Err(
          option_name +
          ": record not found " +
          record_ref.record_index.to_string(),
        )
    }
    let bytes = match
      build_time_processing_submessage_bytes(
        option_name, message, submessage, meta, statistical_process, type_of_time_increment,
        step_unit, step_length, zero_cutoff,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    append_bytes(out, bytes)
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_ave_var_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  time_step_spec : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  let (step_unit, step_length) = match parse_time_step_spec(time_step_spec) {
    Some(v) => v
    None =>
      return Err(
        "-ave_var: bad time step " +
        time_step_spec +
        " (expected (int)(mn|hr|dy|mo|yr))",
      )
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  for record_ref in refs {
    let message = context.messages[record_ref.message_index]
    let submessage = message.submessages[record_ref.submessage_index]
    let meta = match find_record_meta(context, record_ref.record_index) {
      Some(v) => v
      None =>
        return Err(
          "-ave_var: record not found " + record_ref.record_index.to_string(),
        )
    }
    let ave = match
      build_time_processing_submessage_bytes(
        "-ave_var", message, submessage, meta, 0, 1, step_unit, step_length, true,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let stddev = match
      build_time_processing_empty_stddev_submessage_bytes(
        "-ave_var", message, submessage, meta, step_unit, step_length,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let minimum = match
      build_time_processing_submessage_bytes(
        "-ave_var", message, submessage, meta, 3, 1, step_unit, step_length, true,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    let maximum = match
      build_time_processing_submessage_bytes(
        "-ave_var", message, submessage, meta, 2, 1, step_unit, step_length, true,
      ) {
      Ok(v) => v
      Err(error) => return Err(error)
    }
    append_bytes(out, ave)
    append_bytes(out, stddev)
    append_bytes(out, minimum)
    append_bytes(out, maximum)
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn write_empty_compat_output(
  destination : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  if append_mode {
    native_append_bytes(destination, Bytes::new(0))
  } else {
    native_write_bytes(destination, Bytes::new(0))
  }
}

///|
priv enum ForecastProcessingKind {
  Ave
  Acc
  Max
  Min
}

///|
priv struct ForecastProcessingRecord {
  record_ref : SelectedRecordRef
  meta : @lib.Grib2RecordMeta
  section1_bytes : Bytes
  section3_bytes : Bytes
  section4_bytes : Bytes
  section4_key : Bytes
  coordinate_value_count : Int
  coordinate_values_raw : Bytes
  template48 : @section4.Grib2ProductTemplate48
  kind : ForecastProcessingKind
  start_time : Int
  duration : Int
  values : Array[Double]
}

///|
priv struct ForecastProcessingState {
  record : ForecastProcessingRecord
  count : Int
}

///|
fn to_wgrib2_float32(value : Double) -> Double {
  Float::from_double(value).to_double()
}

///|
fn bigint_abs(value : BigInt) -> BigInt {
  if value.compare_int(0) < 0 {
    -value
  } else {
    value
  }
}

///|
fn float32_rational_from_double(value : Double) -> (BigInt, Int) {
  let bits = Float::from_double(value).reinterpret_as_uint()
  let exp_raw = ((bits >> 23) & 0xffU).to_int()
  let frac = bits & 0x7fffffU
  let negative = bits >> 31 != 0U
  if exp_raw == 0 {
    if frac == 0U {
      (BigInt::from_int(0), 0)
    } else {
      let mantissa = BigInt::from_uint64(UInt64::extend_uint(frac))
      (if negative { -mantissa } else { mantissa }, -149)
    }
  } else {
    let mantissa = BigInt::from_uint64(UInt64::extend_uint(0x800000U | frac))
    (if negative { -mantissa } else { mantissa }, exp_raw - 127 - 23)
  }
}

///|
fn compare_float32_rational_to_power_of_two(
  abs_numerator : BigInt,
  denominator : BigInt,
  exp2 : Int,
  power : Int,
) -> Int {
  if power >= exp2 {
    abs_numerator.compare(denominator << (power - exp2))
  } else {
    (abs_numerator << (exp2 - power)).compare(denominator)
  }
}

///|
fn round_bigint_divide_even(numerator : BigInt, denominator : BigInt) -> BigInt {
  let quotient = numerator / denominator
  let remainder = numerator % denominator
  let doubled_remainder = remainder << 1
  if doubled_remainder > denominator ||
    (doubled_remainder == denominator && (quotient.to_int() & 1) == 1) {
    quotient + BigInt::from_int(1)
  } else {
    quotient
  }
}

///|
fn round_float32_rational_to_double(
  numerator : BigInt,
  exp2 : Int,
  denominator_int : Int,
) -> Double {
  if numerator.compare_int(0) == 0 {
    return 0.0
  }
  let negative = numerator.compare_int(0) < 0
  let abs_numerator = bigint_abs(numerator)
  let denominator = BigInt::from_int(denominator_int)
  let mut exponent = exp2 +
    abs_numerator.bit_length() -
    denominator.bit_length()
  if compare_float32_rational_to_power_of_two(
      abs_numerator, denominator, exp2, exponent,
    ) <
    0 {
    exponent -= 1
  }
  while compare_float32_rational_to_power_of_two(
          abs_numerator,
          denominator,
          exp2,
          exponent + 1,
        ) >=
        0 {
    exponent += 1
  }
  let sign_bits = if negative { 0x80000000U } else { 0U }
  if exponent < -126 {
    let shift = exp2 + 149
    let (scaled_numerator, scaled_denominator) = if shift >= 0 {
      (abs_numerator << shift, denominator)
    } else {
      (abs_numerator, denominator << -shift)
    }
    let rounded = round_bigint_divide_even(scaled_numerator, scaled_denominator)
    if rounded.compare_int(0) == 0 {
      return Float::reinterpret_from_uint(sign_bits).to_double()
    }
    let smallest_normal = BigInt::from_int(1 << 23)
    if rounded >= smallest_normal {
      return Float::reinterpret_from_uint(sign_bits | 0x00800000U).to_double()
    }
    return Float::reinterpret_from_uint(sign_bits | rounded.to_uint()).to_double()
  }
  let shift = exp2 - exponent + 23
  let (scaled_numerator, scaled_denominator) = if shift >= 0 {
    (abs_numerator << shift, denominator)
  } else {
    (abs_numerator, denominator << -shift)
  }
  let mut significand = round_bigint_divide_even(
    scaled_numerator, scaled_denominator,
  )
  let overflow_significand = BigInt::from_int(1 << 24)
  if significand == overflow_significand {
    significand = significand >> 1
    exponent += 1
  }
  if exponent >= 128 {
    return Float::reinterpret_from_uint(sign_bits | 0x7f800000U).to_double()
  }
  let exponent_bits = (exponent + 127).to_uint() << 23
  let fraction_bits = significand.to_uint() - 0x800000U
  Float::reinterpret_from_uint(sign_bits | exponent_bits | fraction_bits).to_double()
}

///|
fn float32_mul_int(value : Double, factor : Int) -> Double {
  let (numerator, exp2) = float32_rational_from_double(value)
  round_float32_rational_to_double(
    numerator * BigInt::from_int(factor),
    exp2,
    1,
  )
}

///|
fn float32_sub(lhs : Double, rhs : Double) -> Double {
  let (lhs_numerator, lhs_exp2) = float32_rational_from_double(lhs)
  let (rhs_numerator, rhs_exp2) = float32_rational_from_double(rhs)
  let exp2 = if lhs_exp2 < rhs_exp2 { lhs_exp2 } else { rhs_exp2 }
  let aligned_lhs = if lhs_exp2 > exp2 {
    lhs_numerator << (lhs_exp2 - exp2)
  } else {
    lhs_numerator
  }
  let aligned_rhs = if rhs_exp2 > exp2 {
    rhs_numerator << (rhs_exp2 - exp2)
  } else {
    rhs_numerator
  }
  round_float32_rational_to_double(aligned_lhs - aligned_rhs, exp2, 1)
}

///|
fn float32_mul_int_then_sub(
  value : Double,
  factor : Int,
  subtracted : Double,
) -> Double {
  let (value_numerator, value_exp2) = float32_rational_from_double(value)
  let (subtracted_numerator, subtracted_exp2) = float32_rational_from_double(
    subtracted,
  )
  let multiplied_numerator = value_numerator * BigInt::from_int(factor)
  let exp2 = if value_exp2 < subtracted_exp2 {
    value_exp2
  } else {
    subtracted_exp2
  }
  let aligned_multiplied = if value_exp2 > exp2 {
    multiplied_numerator << (value_exp2 - exp2)
  } else {
    multiplied_numerator
  }
  let aligned_subtracted = if subtracted_exp2 > exp2 {
    subtracted_numerator << (subtracted_exp2 - exp2)
  } else {
    subtracted_numerator
  }
  round_float32_rational_to_double(
    aligned_multiplied - aligned_subtracted,
    exp2,
    1,
  )
}

///|
fn float32_div_int(value : Double, divisor : Int) -> Double {
  let (numerator, exp2) = float32_rational_from_double(value)
  round_float32_rational_to_double(numerator, exp2, divisor)
}

///|
fn forecast_processing_kind(
  option_name : String,
  statistical_process : Int,
) -> ForecastProcessingKind? {
  if statistical_process == 0 {
    Some(Ave)
  } else if statistical_process == 1 {
    Some(Acc)
  } else if option_name == "-merge_fcst" && statistical_process == 2 {
    Some(Max)
  } else if option_name == "-merge_fcst" && statistical_process == 3 {
    Some(Min)
  } else {
    None
  }
}

///|
fn forecast_processing_kind_eq(
  lhs : ForecastProcessingKind,
  rhs : ForecastProcessingKind,
) -> Bool {
  match (lhs, rhs) {
    (Ave, Ave) => true
    (Acc, Acc) => true
    (Max, Max) => true
    (Min, Min) => true
    _ => false
  }
}

///|
fn forecast_processing_template48_key(
  section4 : @lib.Grib2Section4Decoded,
  template48 : @section4.Grib2ProductTemplate48,
) -> Bytes {
  let specs = template48.time_range_specs
  let normalized_specs = if specs.length() == 0 {
    specs
  } else {
    let head = specs[0]
    [{ ..head, time_range_length: 0 }, ..specs[1:]]
  }
  @lib.encode_section4_bytes({
    number_of_coordinate_values: section4.number_of_coordinate_values,
    template: @section4.ProductTemplate48({
      ..template48,
      base: { ..template48.base, forecast_time: 0 },
      end_year: 0,
      end_month: 0,
      end_day: 0,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      time_range_specs: normalized_specs,
    }),
    coordinate_values_raw: section4.coordinate_values_raw,
  })
}

///|
fn decode_forecast_processing_record(
  option_name : String,
  context : @lib.Grib2FileContext,
  record_ref : SelectedRecordRef,
) -> Result[ForecastProcessingRecord?, String] {
  let message = context.messages[record_ref.message_index]
  let submessage = message.submessages[record_ref.submessage_index]
  let meta = match find_record_meta(context, record_ref.record_index) {
    Some(v) => v
    None =>
      return Err(
        option_name +
        ": record not found " +
        record_ref.record_index.to_string(),
      )
  }
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Ok(None)
  }
  let section4 = match @lib.decode_submessage_section4(message, submessage) {
    Ok(v) => v
    Err(error) =>
      return Err(
        option_name +
        ": failed to decode Section 4 for record " +
        record_ref.record_index.to_string() +
        ": " +
        error.to_string(),
      )
  }
  let template48 = match section4.template {
    @section4.ProductTemplate48(v) => v
    _ => return Ok(None)
  }
  if template48.time_range_specs.length() != 1 {
    return Ok(None)
  }
  if template48.base.time_range_unit !=
    template48.time_range_specs[0].time_range_unit {
    return Ok(None)
  }
  let duration = template48.time_range_specs[0].time_range_length
  if duration <= 0 {
    return Ok(None)
  }
  let kind = match
    forecast_processing_kind(
      option_name,
      template48.time_range_specs[0].statistical_process,
    ) {
    Some(v) => v
    None => return Ok(None)
  }
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        option_name +
        ": failed to unpack record " +
        record_ref.record_index.to_string(),
      )
  }
  let normalized_values : Array[Double] = []
  for value in unpacked {
    normalized_values.push(to_wgrib2_float32(value))
  }
  Ok(
    Some({
      record_ref,
      meta,
      section1_bytes: section_frame_bytes(message, message.section1),
      section3_bytes: section_frame_bytes(message, submessage.section3),
      section4_bytes: section_frame_bytes(message, submessage.section4),
      section4_key: forecast_processing_template48_key(section4, template48),
      coordinate_value_count: section4.number_of_coordinate_values,
      coordinate_values_raw: section4.coordinate_values_raw,
      template48,
      kind,
      start_time: template48.base.forecast_time,
      duration,
      values: normalized_values,
    }),
  )
}

///|
fn forecast_processing_records_compatible(
  lhs : ForecastProcessingRecord,
  rhs : ForecastProcessingRecord,
) -> Bool {
  forecast_processing_kind_eq(lhs.kind, rhs.kind) &&
  lhs.section1_bytes == rhs.section1_bytes &&
  lhs.section3_bytes == rhs.section3_bytes &&
  lhs.section4_key == rhs.section4_key
}

///|
fn forecast_processing_output_section4_bytes(
  record : ForecastProcessingRecord,
  forecast_time : Int,
  duration : Int,
  end_template : @section4.Grib2ProductTemplate48,
) -> Bytes {
  let spec = record.template48.time_range_specs[0]
  @lib.encode_section4_bytes({
    number_of_coordinate_values: record.coordinate_value_count,
    template: @section4.ProductTemplate48({
      ..record.template48,
      base: { ..record.template48.base, forecast_time, },
      end_year: end_template.end_year,
      end_month: end_template.end_month,
      end_day: end_template.end_day,
      end_hour: end_template.end_hour,
      end_minute: end_template.end_minute,
      end_second: end_template.end_second,
      time_range_specs: [{ ..spec, time_range_length: duration }],
    }),
    coordinate_values_raw: record.coordinate_values_raw,
  })
}

///|
fn build_processed_forecast_submessage_bytes(
  option_name : String,
  context : @lib.Grib2FileContext,
  record : ForecastProcessingRecord,
  section4_bytes : Bytes,
  values : Array[Double],
) -> Result[Bytes, String] {
  let message = context.messages[record.record_ref.message_index]
  let submessage = message.submessages[record.record_ref.submessage_index]
  let (sec6, defined_values) = build_wind_section6_bytes_and_defined_values(
    message, submessage, values,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_forecast_scaling(
      defined_values,
      record.meta.section5_reference_value_ieee,
      record.meta.section5_binary_scale_factor,
      record.meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for " +
        option_name +
        " record " +
        record.meta.record_index.to_string(),
      )
  }
  Ok(
    build_submessage_grib_bytes_with_overrides(
      message,
      submessage,
      Some(section4_bytes),
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn build_repacked_forecast_submessage_bytes(
  option_name : String,
  context : @lib.Grib2FileContext,
  record : ForecastProcessingRecord,
) -> Result[Bytes, String] {
  build_processed_forecast_submessage_bytes(
    option_name,
    context,
    record,
    record.section4_bytes,
    record.values,
  )
}

///|
fn forecast_merge_values(
  kind : ForecastProcessingKind,
  lhs : Array[Double],
  rhs : Array[Double],
) -> Array[Double] {
  let out : Array[Double] = []
  for index in 0..<lhs.length() {
    let left = to_wgrib2_float32(lhs[index])
    let right = to_wgrib2_float32(rhs[index])
    let value = match kind {
      Ave | Acc =>
        if left == left && right == right {
          to_wgrib2_float32(left + right)
        } else {
          0.0 / 0.0
        }
      Max =>
        if left == left {
          if right == right && right > left {
            to_wgrib2_float32(right)
          } else {
            to_wgrib2_float32(left)
          }
        } else {
          to_wgrib2_float32(right)
        }
      Min =>
        if left == left {
          if right == right && right < left {
            to_wgrib2_float32(right)
          } else {
            to_wgrib2_float32(left)
          }
        } else {
          to_wgrib2_float32(right)
        }
    }
    out.push(value)
  }
  out
}

///|
fn forecast_scale_average_values(
  values : Array[Double],
  factor : Double,
) -> Array[Double] {
  let out : Array[Double] = []
  let factor_f32 = to_wgrib2_float32(factor)
  for value in values {
    if value == value {
      out.push(to_wgrib2_float32(to_wgrib2_float32(value) * factor_f32))
    } else {
      out.push(value)
    }
  }
  out
}

///|
fn forecast_residual_values(
  kind : ForecastProcessingKind,
  shorter : Array[Double],
  longer : Array[Double],
  shorter_duration : Int,
  longer_duration : Int,
) -> Array[Double] {
  let out : Array[Double] = []
  for index in 0..<shorter.length() {
    let left = to_wgrib2_float32(shorter[index])
    let right = to_wgrib2_float32(longer[index])
    if left != left || right != right {
      out.push(0.0 / 0.0)
    } else if forecast_processing_kind_eq(kind, Ave) {
      let left_term = float32_mul_int(left, shorter_duration)
      let numerator = float32_mul_int_then_sub(
        right, longer_duration, left_term,
      )
      out.push(float32_div_int(numerator, longer_duration - shorter_duration))
    } else {
      out.push(float32_sub(right, left))
    }
  }
  out
}

///|
fn write_ncep_norm_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  let mut saved : ForecastProcessingRecord? = None
  for record_ref in refs {
    let current = match
      decode_forecast_processing_record("-ncep_norm", context, record_ref) {
      Ok(Some(v)) => v
      Ok(None) => continue
      Err(error) => return Err(error)
    }
    match saved {
      None => {
        append_bytes(
          out,
          match
            build_repacked_forecast_submessage_bytes(
              "-ncep_norm", context, current,
            ) {
            Ok(v) => v
            Err(error) => return Err(error)
          },
        )
        saved = Some(current)
      }
      Some(previous) =>
        if !forecast_processing_records_compatible(previous, current) ||
          previous.start_time != current.start_time {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-ncep_norm", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
          saved = Some(current)
        } else if previous.duration == current.duration {
          continue
        } else if current.duration < previous.duration {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-ncep_norm", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
          saved = Some(current)
        } else {
          let normalized_values = forecast_residual_values(
            previous.kind,
            previous.values,
            current.values,
            previous.duration,
            current.duration,
          )
          let new_start = previous.start_time + previous.duration
          let new_duration = current.duration - previous.duration
          let section4_bytes = forecast_processing_output_section4_bytes(
            previous,
            new_start,
            new_duration,
            current.template48,
          )
          append_bytes(
            out,
            match
              build_processed_forecast_submessage_bytes(
                "-ncep_norm", context, previous, section4_bytes, normalized_values,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
          saved = Some({
            ..previous,
            section4_bytes,
            template48: {
              ..previous.template48,
              base: { ..previous.template48.base, forecast_time: new_start },
              end_year: current.template48.end_year,
              end_month: current.template48.end_month,
              end_day: current.template48.end_day,
              end_hour: current.template48.end_hour,
              end_minute: current.template48.end_minute,
              end_second: current.template48.end_second,
              time_range_specs: [
                {
                  ..previous.template48.time_range_specs[0],
                  time_range_length: new_duration,
                },
              ],
            },
            start_time: new_start,
            duration: new_duration,
            values: normalized_values,
          })
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
fn write_merge_fcst_output(
  intervals : String,
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let n = match parse_int_option(intervals) {
    Some(v) => v
    None => return Err("merge_fcst: arg must be integer")
  }
  if n < 0 {
    return Err("merge_fcst: arg must be >= 0")
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  let mut saved : ForecastProcessingState? = None
  for record_ref in refs {
    let current = match
      decode_forecast_processing_record("-merge_fcst", context, record_ref) {
      Ok(Some(v)) => v
      Ok(None) => continue
      Err(error) => return Err(error)
    }
    match saved {
      None => {
        if n == 0 {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-merge_fcst", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
        }
        saved = Some({ record: current, count: 1 })
      }
      Some(state) => {
        let expected_start = state.record.start_time +
          state.record.duration * state.count
        if !forecast_processing_records_compatible(state.record, current) ||
          current.start_time != expected_start ||
          current.duration != state.record.duration {
          if n == 0 {
            append_bytes(
              out,
              match
                build_repacked_forecast_submessage_bytes(
                  "-merge_fcst", context, current,
                ) {
                Ok(v) => v
                Err(error) => return Err(error)
              },
            )
          }
          saved = Some({ record: current, count: 1 })
          continue
        }
        let merged_values = forecast_merge_values(
          state.record.kind,
          state.record.values,
          current.values,
        )
        let merged_count = state.count + 1
        let merged_duration = state.record.duration * merged_count
        let section4_bytes = forecast_processing_output_section4_bytes(
          state.record,
          state.record.start_time,
          merged_duration,
          current.template48,
        )
        let output_values = if forecast_processing_kind_eq(
            state.record.kind,
            Ave,
          ) {
          forecast_scale_average_values(
            merged_values,
            1.0 / merged_count.to_double(),
          )
        } else {
          merged_values
        }
        if merged_count == n || n == 0 {
          append_bytes(
            out,
            match
              build_processed_forecast_submessage_bytes(
                "-merge_fcst",
                context,
                state.record,
                section4_bytes,
                output_values,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
        }
        if n == 0 {
          saved = Some({
            record: {
              ..state.record,
              section4_bytes,
              template48: {
                ..state.record.template48,
                end_year: current.template48.end_year,
                end_month: current.template48.end_month,
                end_day: current.template48.end_day,
                end_hour: current.template48.end_hour,
                end_minute: current.template48.end_minute,
                end_second: current.template48.end_second,
                time_range_specs: [
                  {
                    ..state.record.template48.time_range_specs[0],
                    time_range_length: merged_duration,
                  },
                ],
              },
              duration: merged_duration,
              values: merged_values,
            },
            count: merged_count,
          })
        } else if merged_count == n {
          saved = None
        } else {
          saved = Some({
            record: { ..state.record, values: merged_values },
            count: merged_count,
          })
        }
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
fn write_unmerge_fcst_output(
  destination : String,
  fcst_time_0 : String,
  z_arg : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let (base_unit, base_time) = match parse_unmerge_fcst_time_spec(fcst_time_0) {
    Some(v) => v
    None => return Err("unmerge_fcst: bad (int)(mn|hr|dy|mo|yr)")
  }
  let z = match parse_int_option(z_arg) {
    Some(v) => v
    None => return Err("unmerge_fcst: z must be 0..2")
  }
  if z < 0 || z > 2 {
    return Err("unmerge_fcst: z must be 0..2")
  }
  let refs = collect_selected_record_refs(context, selected)
  if refs.length() == 0 {
    return write_empty_compat_output(destination, append_mode)
  }
  let out : Array[Byte] = []
  let mut saved : ForecastProcessingRecord? = None
  for record_ref in refs {
    let current = match
      decode_forecast_processing_record("-unmerge_fcst", context, record_ref) {
      Ok(Some(v)) => v
      Ok(None) => continue
      Err(error) => return Err(error)
    }
    if !forecast_processing_kind_eq(current.kind, Ave) &&
      !forecast_processing_kind_eq(current.kind, Acc) {
      continue
    }
    if current.start_time != base_time {
      continue
    }
    if base_time != 0 && current.template48.base.time_range_unit != base_unit {
      continue
    }
    match saved {
      None => {
        if z > 0 {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-unmerge_fcst", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
        }
        saved = Some(current)
      }
      Some(previous) => {
        if !forecast_processing_records_compatible(previous, current) {
          if z > 0 {
            append_bytes(
              out,
              match
                build_repacked_forecast_submessage_bytes(
                  "-unmerge_fcst", context, current,
                ) {
                Ok(v) => v
                Err(error) => return Err(error)
              },
            )
          }
          saved = Some(current)
          continue
        }
        if previous.section4_bytes == current.section4_bytes {
          continue
        }
        if current.duration <= previous.duration {
          if z > 0 {
            append_bytes(
              out,
              match
                build_repacked_forecast_submessage_bytes(
                  "-unmerge_fcst", context, current,
                ) {
                Ok(v) => v
                Err(error) => return Err(error)
              },
            )
          }
          saved = Some(current)
          continue
        }
        if z > 1 {
          append_bytes(
            out,
            match
              build_repacked_forecast_submessage_bytes(
                "-unmerge_fcst", context, current,
              ) {
              Ok(v) => v
              Err(error) => return Err(error)
            },
          )
        }
        let section4_bytes = forecast_processing_output_section4_bytes(
          current,
          base_time + previous.duration,
          current.duration - previous.duration,
          current.template48,
        )
        let message = context.messages[current.record_ref.message_index]
        let submessage = message.submessages[current.record_ref.submessage_index]
        append_bytes(
          out,
          match
            build_defined_zero_field_submessage_bytes(
              "-unmerge_fcst",
              message,
              submessage,
              current.meta,
              section4_bytes,
            ) {
            Ok(v) => v
            Err(error) => return Err(error)
          },
        )
        saved = Some(current)
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
struct WindCandidateRecord {
  record_index : Int
  message_index : Int
  submessage_index : Int
  pair_key : Bytes
}

///|
priv struct SelectedRecordRef {
  record_index : Int
  message_index : Int
  submessage_index : Int
}

///|
fn wind_input_packing_supported(template_id : Int) -> Bool {
  template_id == 0 ||
  template_id == 2 ||
  template_id == 3 ||
  template_id == 4 ||
  template_id == 40 ||
  template_id == 41
}

///|
fn is_wind_u_component(meta : @lib.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 2
}

///|
fn is_wind_v_component(meta : @lib.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 3
}

///|
fn is_wind_speed_component(meta : @lib.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 1
}

///|
fn is_wind_direction_component(meta : @lib.Grib2RecordMeta) -> Bool {
  meta.section4_parameter_category == 2 && meta.section4_parameter_number == 0
}

///|
fn build_wind_pair_key(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
) -> Bytes {
  let sec3 = section_frame_bytes(message, submessage.section3)
  let sec4 = section_frame_bytes(message, submessage.section4)
  let sec6 = section_frame_bytes(message, submessage.section6)
  if sec4.length() < 11 {
    return Bytes::new(0)
  }
  let sec4_masked : Array[Byte] = []
  for b in sec4 {
    sec4_masked.push(b)
  }
  sec4_masked[9] = b'\x00'
  sec4_masked[10] = b'\x00'
  let key : Array[Byte] = []
  append_bytes(key, sec3)
  key.push(b'|')
  append_bytes(key, Bytes::from_array(sec4_masked))
  key.push(b'|')
  append_bytes(key, sec6)
  Bytes::from_array(key)
}

///|
fn patch_section4_parameter_ids(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  parameter_category : Int,
  parameter_number : Int,
) -> Result[Bytes, String] {
  let sec4 = section_frame_bytes(message, submessage.section4)
  if sec4.length() < 11 {
    return Err("section4 too short to patch parameter ids")
  }
  let out : Array[Byte] = []
  for b in sec4 {
    out.push(b)
  }
  out[9] = parameter_category.to_byte()
  out[10] = parameter_number.to_byte()
  Ok(Bytes::from_array(out))
}

///|
fn wind_dir_from_uv(u : Double, v : Double) -> Double {
  if u != u || v != v {
    return 0.0 / 0.0
  }
  let u_f = Float::from_double(u).to_double()
  let v_f = Float::from_double(v).to_double()
  let mut deg = @math.atan2(-u_f, -v_f) * 180.0 / @math.PI
  if deg <= 0.0 {
    deg += 360.0
  }
  Float::from_double(deg).to_double()
}

///|
fn wind_derived_value(u : Double, v : Double, mode : WindDerivedMode) -> Double {
  match mode {
    WindDerivedSpeed =>
      if u != u || v != v {
        0.0 / 0.0
      } else {
        let u_f = Float::from_double(u).to_double()
        let v_f = Float::from_double(v).to_double()
        let sum_sq = Float::from_double(u_f * u_f + v_f * v_f).to_double()
        Float::from_double(sqrt_newton(sum_sq)).to_double()
      }
    WindDerivedDir => wind_dir_from_uv(u, v)
  }
}

///|
fn wind_uv_from_speed_dir(
  speed : Double,
  direction_deg : Double,
) -> (Double, Double) {
  if speed != speed || direction_deg != direction_deg {
    return (0.0 / 0.0, 0.0 / 0.0)
  }
  // Match wgrib2 Wind_uv.c numeric path:
  // float speed/dir inputs, double sin/cos, float outputs.
  let speed_f = Float::from_double(speed).to_double()
  if speed_f == 0.0 {
    return (0.0, 0.0)
  }
  let dir_f = Float::from_double(direction_deg).to_double()
  let rad = dir_f * 0.017453292519943295769
  let u = Float::from_double(-speed_f * @math.sin(rad)).to_double()
  let v = Float::from_double(-speed_f * @math.cos(rad)).to_double()
  (u, v)
}

///|
fn pow2_int(n : Int) -> Double {
  let mut out = 1.0
  if n >= 0 {
    for _ in 0..<n {
      out = out * 2.0
    }
  } else {
    for _ in 0..<-n {
      out = out / 2.0
    }
  }
  out
}

///|
fn pow10_int(n : Int) -> Double {
  let mut out = 1.0
  if n >= 0 {
    for _ in 0..<n {
      out = out * 10.0
    }
  } else {
    for _ in 0..<-n {
      out = out / 10.0
    }
  }
  out
}

///|
fn sqrt_newton(x : Double) -> Double {
  if x <= 0.0 {
    return 0.0
  }
  let mut guess = if x >= 1.0 { x } else { 1.0 }
  for _ in 0..<12 {
    guess = 0.5 * (guess + x / guess)
  }
  guess
}

///|
fn required_bits_nonnegative(max_value : Int) -> Int {
  if max_value <= 0 {
    return 0
  }
  let mut bits = 0
  let mut v = max_value
  while v > 0 {
    bits += 1
    v = v >> 1
  }
  bits
}

///|
fn pack_unsigned_values_be(values : Array[Int], bits_per_value : Int) -> Bytes {
  if bits_per_value <= 0 {
    return Bytes::new(0)
  }
  let out : Array[Byte] = []
  let mut current = 0
  let mut filled = 0
  for value in values {
    let v = if value < 0 { 0 } else { value }
    for i in 0..<bits_per_value {
      let shift = bits_per_value - 1 - i
      let bit = (v >> shift) & 1
      current = (current << 1) | bit
      filled += 1
      if filled == 8 {
        out.push((current & 0xFF).to_byte())
        current = 0
        filled = 0
      }
    }
  }
  if filled > 0 {
    current = current << (8 - filled)
    out.push((current & 0xFF).to_byte())
  }
  Bytes::from_array(out)
}

///|
fn encode_i16_sign_magnitude(value : Int) -> Int {
  let magnitude = if value < 0 { -value } else { value }
  let bounded = if magnitude > 0x7FFF { 0x7FFF } else { magnitude }
  if value < 0 {
    0x8000 | bounded
  } else {
    bounded
  }
}

///|
fn encode_i32_sign_magnitude(value : Int) -> Int {
  let magnitude = if value < 0 { -value } else { value }
  let bounded = if magnitude > 0x7FFF_FFFF { 0x7FFF_FFFF } else { magnitude }
  if value < 0 {
    0x8000_0000 | bounded
  } else {
    bounded
  }
}

///|
fn section5_original_field_value_type(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
) -> Int {
  let sec5 = section_frame_bytes(message, submessage.section5)
  if sec5.length() > 20 {
    sec5[20].to_uint().reinterpret_as_int()
  } else {
    0
  }
}

///|
fn regular_grid_source_index_for_scan(
  ni : Int,
  nj : Int,
  scan_mode : Int,
  i : Int,
  j : Int,
) -> Int {
  let scan = @lib.parse_scanning_mode(scan_mode)
  let j_scan = if scan.j_positive { j } else { nj - 1 - j }
  let i_scan = if scan.alternating_rows && (j_scan & 1) == 1 {
    ni - 1 - i
  } else {
    i
  }
  let i_scan = if scan.i_negative { ni - 1 - i_scan } else { i_scan }
  if scan.consecutive_j {
    j_scan + i_scan * nj
  } else {
    i_scan + j_scan * ni
  }
}

///|
fn same_section_frame_for_grib_out(
  lhs : @lib.Grib2SectionFrame,
  rhs : @lib.Grib2SectionFrame,
) -> Bool {
  lhs.section_number == rhs.section_number &&
  lhs.start == rhs.start &&
  lhs.length == rhs.length
}

///|
fn find_submessage_index_for_grib_out(
  message : @lib.Grib2MessageContext,
  target : @lib.Grib2SubmessageFrame,
) -> Int? {
  for index in 0..<message.submessages.length() {
    let candidate = message.submessages[index]
    if same_section_frame_for_grib_out(candidate.section3, target.section3) &&
      same_section_frame_for_grib_out(candidate.section4, target.section4) &&
      same_section_frame_for_grib_out(candidate.section5, target.section5) &&
      same_section_frame_for_grib_out(candidate.section6, target.section6) &&
      same_section_frame_for_grib_out(candidate.section7, target.section7) {
      return Some(index)
    }
  }
  None
}

///|
fn resolve_bitmap_raw_for_grib_out(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  section6 : @lib.Grib2Section6Decoded,
) -> Result[Bytes?, String] {
  if section6.bitmap_indicator == 255 {
    return Ok(None)
  }
  if section6.bitmap_indicator == 0 {
    return Ok(Some(section6.bitmap_raw))
  }
  if section6.bitmap_indicator != 254 {
    return Err(
      "bitmap indicator not supported for -grib_out: " +
      section6.bitmap_indicator.to_string(),
    )
  }
  let submessage_index = match
    find_submessage_index_for_grib_out(message, submessage) {
    Some(v) => v
    None => return Err("failed to locate submessage for bitmap reuse")
  }
  for previous in 0..<submessage_index {
    let prev_index = submessage_index - 1 - previous
    let prev_submessage = message.submessages[prev_index]
    let prev_section6 = match
      @lib.decode_submessage_section6(message, prev_submessage) {
      Ok(v) => v
      Err(_) => continue
    }
    if prev_section6.bitmap_indicator == 0 {
      return Ok(Some(prev_section6.bitmap_raw))
    }
  }
  Err("bitmap indicator 254 references a bitmap that is not available")
}

///|
fn restore_input_scan_order_for_grib_out(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  values : Array[Double],
) -> Array[Double] {
  let section3 = match @lib.decode_submessage_section3(message, submessage) {
    Ok(v) => v
    Err(_) => return values
  }
  let grid_info = @lib.get_section3_grid_info(section3.template)
  let ni = grid_info.ni
  let nj = grid_info.nj
  if ni <= 0 || nj <= 0 || ni * nj != values.length() {
    return values
  }
  let reordered : Array[Double] = Array::make(values.length(), 0.0 / 0.0)
  for j_out in 0..<nj {
    for i_out in 0..<ni {
      let normalized_index = j_out * ni + i_out
      let raw_index = regular_grid_source_index_for_scan(
        ni,
        nj,
        grid_info.scan_mode,
        i_out,
        j_out,
      )
      reordered[raw_index] = values[normalized_index]
    }
  }
  reordered
}

///|
fn collect_defined_values_for_grib_out(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  values : Array[Double],
) -> Result[Array[Double], String] {
  let input_order = restore_input_scan_order_for_grib_out(
    message, submessage, values,
  )
  let section6 = match @lib.decode_submessage_section6(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 6: \{e}")
  }
  let bitmap_raw = match
    resolve_bitmap_raw_for_grib_out(message, submessage, section6) {
    Ok(None) => return Ok(input_order)
    Ok(Some(v)) => v
    Err(e) => return Err(e)
  }
  if section6.bitmap_indicator == 255 {
    return Ok(input_order)
  }
  let defined_values : Array[Double] = []
  for bit_index in 0..<input_order.length() {
    let byte_index = bit_index / 8
    if byte_index >= bitmap_raw.length() {
      return Err(
        "bitmap payload too short for -grib_out at bit " + bit_index.to_string(),
      )
    }
    let bit_offset = 7 - bit_index % 8
    let mask = 1 << bit_offset
    let byte_val = bitmap_raw[byte_index].to_uint().reinterpret_as_int()
    if (byte_val & mask) != 0 {
      let value = input_order[bit_index]
      if value != value {
        return Err(
          "bitmap-defined point became NaN during -grib_out repack at index " +
          bit_index.to_string(),
        )
      }
      defined_values.push(value)
    }
  }
  Ok(defined_values)
}

///|
fn build_grib_out_section6_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
) -> Result[Bytes, String] {
  let section6 = match @lib.decode_submessage_section6(message, submessage) {
    Ok(v) => v
    Err(e) => return Err("failed to decode Section 6: \{e}")
  }
  match resolve_bitmap_raw_for_grib_out(message, submessage, section6) {
    Ok(None) => Ok(section_frame_bytes(message, submessage.section6))
    Ok(Some(bitmap_raw)) =>
      if section6.bitmap_indicator == 0 {
        Ok(section_frame_bytes(message, submessage.section6))
      } else {
        Ok(@lib.encode_section6_bytes({ bitmap_indicator: 0, bitmap_raw }))
      }
    Err(e) => Err(e)
  }
}

///|
fn try_build_simple_packed_sections_with_scaling(
  values : Array[Double],
  reference_value_ieee : Int,
  binary_scale_factor : Int,
  decimal_scale_factor : Int,
  original_field_value_type : Int,
) -> (Bytes, Bytes)? {
  let to_wgrib2_float = fn(value : Double) -> Double {
    Float::from_double(value).to_double()
  }
  let normalized_values : Array[Double] = []
  for value in values {
    if value != value {
      return None
    }
    normalized_values.push(to_wgrib2_float(value))
  }
  let mut min_value = Float::reinterpret_from_int(reference_value_ieee).to_double()
  let mut max_value = min_value
  if normalized_values.length() > 0 {
    min_value = normalized_values[0]
    max_value = normalized_values[0]
    for value in normalized_values {
      if value < min_value {
        min_value = value
      }
      if value > max_value {
        max_value = value
      }
    }
  }
  let constant_field = normalized_values.length() == 0 || min_value == max_value
  let output_binary_scale_factor = if constant_field {
    0
  } else {
    binary_scale_factor
  }
  let output_decimal_scale_factor = if constant_field {
    0
  } else {
    decimal_scale_factor
  }
  let decimal_scale = pow10_int(output_decimal_scale_factor)
  let output_reference_value_ieee = if normalized_values.length() == 0 {
    0
  } else if constant_field {
    Float::from_double(to_wgrib2_float(min_value)).reinterpret_as_int()
  } else {
    Float::from_double(to_wgrib2_float(min_value * decimal_scale)).reinterpret_as_int()
  }
  let reference_value = Float::reinterpret_from_int(output_reference_value_ieee).to_double()
  let binary_scale = pow2_int(output_binary_scale_factor)
  let packed_values : Array[Int] = []
  let mut max_packed = 0
  for value in normalized_values {
    let decimal_scaled = if output_decimal_scale_factor == 0 {
      value
    } else {
      to_wgrib2_float(value * decimal_scale)
    }
    let packed_float = if output_binary_scale_factor == 0 {
      to_wgrib2_float(decimal_scaled - reference_value)
    } else {
      to_wgrib2_float((decimal_scaled - reference_value) / binary_scale)
    }
    let packed = @math.floor(packed_float + 0.5).to_int()
    let nonnegative = if packed < 0 { 0 } else { packed }
    if nonnegative > max_packed {
      max_packed = nonnegative
    }
    packed_values.push(nonnegative)
  }
  let bits_per_value = if constant_field {
    0
  } else {
    required_bits_nonnegative(max_packed)
  }
  if bits_per_value > 31 {
    return None
  }
  let sec5 = @lib.encode_section5_bytes({
    number_of_data_points: normalized_values.length(),
    template: DataRepresentationTemplate50({
      reference_value_ieee: output_reference_value_ieee,
      binary_scale_factor: encode_i16_sign_magnitude(output_binary_scale_factor),
      decimal_scale_factor: encode_i16_sign_magnitude(
        output_decimal_scale_factor,
      ),
      bits_per_value,
      original_field_value_type,
      reserved_tail: b"",
    }),
  })
  let sec7 = @lib.encode_section7_bytes({
    template: DataTemplate70({
      data_values_raw: pack_unsigned_values_be(packed_values, bits_per_value),
    }),
  })
  Some((sec5, sec7))
}

///|
fn build_grib_out_submessage_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
) -> Result[Bytes, String] {
  let template_id = meta.section5_template.id()
  if template_id != 0 &&
    template_id != 2 &&
    template_id != 3 &&
    template_id != 40 &&
    template_id != 41 {
    return Err(
      "-grib_out is not implemented for packing template " +
      template_id.to_string(),
    )
  }
  let unpacked = match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => v.values
    Err(_) =>
      return Err(
        "failed to unpack record " +
        meta.record_index.to_string() +
        " for -grib_out",
      )
  }
  let defined_values = match
    collect_defined_values_for_grib_out(message, submessage, unpacked) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to collect defined values for -grib_out record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      defined_values,
      meta.section5_reference_value_ieee,
      meta.section5_binary_scale_factor,
      meta.section5_decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for -grib_out record " +
        meta.record_index.to_string(),
      )
  }
  let sec6 = match build_grib_out_section6_bytes(message, submessage) {
    Ok(v) => v
    Err(e) =>
      return Err(
        "failed to resolve Section 6 for -grib_out record " +
        meta.record_index.to_string() +
        ": " +
        e,
      )
  }
  Ok(
    build_submessage_grib_bytes_with_overrides(
      message,
      submessage,
      None,
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn build_wind_section6_bytes_and_defined_values(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  values : Array[Double],
) -> (Bytes, Array[Double]) {
  let input_order = restore_input_scan_order_for_grib_out(
    message, submessage, values,
  )
  let defined_values : Array[Double] = []
  let bitmap = Array::make((input_order.length() + 7) / 8, b'\x00')
  let mut has_undefined = false
  for index in 0..<input_order.length() {
    let value = input_order[index]
    if value != value {
      has_undefined = true
      continue
    }
    defined_values.push(value)
    let byte_index = index / 8
    let bit_offset = 7 - index % 8
    let current = bitmap[byte_index].to_uint().reinterpret_as_int()
    bitmap[byte_index] = (current | (1 << bit_offset)).to_byte()
  }
  let sec6 = if has_undefined {
    @lib.encode_section6_bytes({
      bitmap_indicator: 0,
      bitmap_raw: Bytes::from_array(bitmap),
    })
  } else {
    build_no_bitmap_section6_bytes()
  }
  (sec6, defined_values)
}

///|
fn build_wind_simple_packed_submessage_bytes(
  option_name : String,
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
  meta : @lib.Grib2RecordMeta,
  section4 : Bytes,
  values : Array[Double],
  reference_value_ieee : Int,
  binary_scale_factor : Int,
  decimal_scale_factor : Int,
) -> Result[Bytes, String] {
  let (sec6, defined_values) = build_wind_section6_bytes_and_defined_values(
    message, submessage, values,
  )
  let original_field_value_type = section5_original_field_value_type(
    message, submessage,
  )
  let (sec5, sec7) = match
    try_build_simple_packed_sections_with_scaling(
      defined_values, reference_value_ieee, binary_scale_factor, decimal_scale_factor,
      original_field_value_type,
    ) {
    Some(v) => v
    None =>
      return Err(
        "failed to rebuild simple-packed data for " +
        option_name +
        " record " +
        meta.record_index.to_string(),
      )
  }
  Ok(
    build_submessage_grib_bytes_with_overrides(
      message,
      submessage,
      Some(section4),
      Some(sec5),
      Some(sec6),
      Some(sec7),
    ),
  )
}

///|
fn write_wind_derived_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  mode : WindDerivedMode,
  append_mode : Bool,
) -> Result[Unit, String] {
  let metas = @lib.decode_records(context)
  for meta in metas {
    if record_is_selected(meta.record_index, selected) &&
      (is_wind_u_component(meta) || is_wind_v_component(meta)) {
      let packing = meta.section5_template.id()
      if !wind_input_packing_supported(packing) {
        return Err(
          "wind derived output is not implemented for packing template " +
          packing.to_string() +
          " (requires verified unpacking parity with wgrib2)",
        )
      }
    }
  }
  let u_candidates : Map[Bytes, WindCandidateRecord] = {}
  let v_candidates : Map[Bytes, WindCandidateRecord] = {}
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index < metas.length() {
          let meta = metas[meta_index]
          if is_wind_u_component(meta) || is_wind_v_component(meta) {
            let pair_key = build_wind_pair_key(
              message,
              message.submessages[submessage_index],
            )
            if pair_key.length() == 0 {
              record_index += 1
              continue
            }
            let candidate : WindCandidateRecord = {
              record_index,
              message_index,
              submessage_index,
              pair_key,
            }
            if is_wind_u_component(meta) {
              u_candidates.set(pair_key, candidate)
            } else if is_wind_v_component(meta) {
              v_candidates.set(pair_key, candidate)
            }
          }
        }
      }
      record_index += 1
    }
  }
  let out : Array[Byte] = []
  for _, u_candidate in u_candidates {
    match v_candidates.get(u_candidate.pair_key) {
      None => ()
      Some(v_candidate) => {
        let u_message = context.messages[u_candidate.message_index]
        let u_submessage = u_message.submessages[u_candidate.submessage_index]
        let v_message = context.messages[v_candidate.message_index]
        let v_submessage = v_message.submessages[v_candidate.submessage_index]
        let u_values = match
          @lib.unpack_submessage_data(u_message, u_submessage) {
          Ok(v) => v.values
          Err(_) =>
            return Err(
              "failed to unpack U record " +
              u_candidate.record_index.to_string() +
              " for wind-derived output",
            )
        }
        let v_values = match
          @lib.unpack_submessage_data(v_message, v_submessage) {
          Ok(v) => v.values
          Err(_) =>
            return Err(
              "failed to unpack V record " +
              v_candidate.record_index.to_string() +
              " for wind-derived output",
            )
        }
        if u_values.length() != v_values.length() {
          return Err(
            "wind pair value length mismatch: U=" +
            u_values.length().to_string() +
            ", V=" +
            v_values.length().to_string(),
          )
        }
        let derived_values : Array[Double] = []
        for i in 0..<u_values.length() {
          derived_values.push(
            wind_derived_value(u_values[i], v_values[i], mode),
          )
        }
        let u_meta = metas[u_candidate.record_index - 1]
        let sec4 = match mode {
          WindDerivedSpeed =>
            match patch_section4_parameter_ids(u_message, u_submessage, 2, 1) {
              Ok(v) => v
              Err(e) => return Err(e)
            }
          WindDerivedDir =>
            match patch_section4_parameter_ids(u_message, u_submessage, 2, 0) {
              Ok(v) => v
              Err(e) => return Err(e)
            }
        }
        let (
          option_name,
          reference_value_ieee,
          binary_scale_factor,
          decimal_scale_factor,
        ) = match mode {
          WindDerivedSpeed =>
            (
              "-wind_speed",
              u_meta.section5_reference_value_ieee,
              u_meta.section5_binary_scale_factor,
              u_meta.section5_decimal_scale_factor,
            )
          WindDerivedDir => ("-wind_dir", 0, 0, 0)
        }
        let built = match
          build_wind_simple_packed_submessage_bytes(
            option_name, u_message, u_submessage, u_meta, sec4, derived_values, reference_value_ieee,
            binary_scale_factor, decimal_scale_factor,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, built)
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
fn write_wind_uv_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let metas = @lib.decode_records(context)
  let speed_candidates : Map[Bytes, WindCandidateRecord] = {}
  let direction_candidates : Map[Bytes, WindCandidateRecord] = {}
  let mut record_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    for submessage_index in 0..<message.submessages.length() {
      if record_is_selected(record_index, selected) {
        let meta_index = record_index - 1
        if meta_index < metas.length() {
          let meta = metas[meta_index]
          if is_wind_speed_component(meta) || is_wind_direction_component(meta) {
            let packing = meta.section5_template.id()
            if !wind_input_packing_supported(packing) {
              // Limited compatibility: ignore unsupported packing for -wind_uv.
              // If all selected records are skipped, we write empty output.
              record_index += 1
              continue
            }
            let pair_key = build_wind_pair_key(
              message,
              message.submessages[submessage_index],
            )
            if pair_key.length() == 0 {
              record_index += 1
              continue
            }
            let candidate : WindCandidateRecord = {
              record_index,
              message_index,
              submessage_index,
              pair_key,
            }
            if is_wind_speed_component(meta) {
              speed_candidates.set(pair_key, candidate)
            } else if is_wind_direction_component(meta) {
              direction_candidates.set(pair_key, candidate)
            }
          }
        }
      }
      record_index += 1
    }
  }
  let out : Array[Byte] = []
  for _, speed_candidate in speed_candidates {
    match direction_candidates.get(speed_candidate.pair_key) {
      None => ()
      Some(direction_candidate) => {
        let speed_message = context.messages[speed_candidate.message_index]
        let speed_submessage = speed_message.submessages[speed_candidate.submessage_index]
        let dir_message = context.messages[direction_candidate.message_index]
        let dir_submessage = dir_message.submessages[direction_candidate.submessage_index]
        let speed_values = match
          @lib.unpack_submessage_data(speed_message, speed_submessage) {
          Ok(v) => v.values
          Err(_) =>
            return Err(
              "failed to unpack speed record " +
              speed_candidate.record_index.to_string() +
              " for wind_uv output",
            )
        }
        let dir_values = match
          @lib.unpack_submessage_data(dir_message, dir_submessage) {
          Ok(v) => v.values
          Err(_) =>
            return Err(
              "failed to unpack direction record " +
              direction_candidate.record_index.to_string() +
              " for wind_uv output",
            )
        }
        if speed_values.length() != dir_values.length() {
          return Err(
            "wind speed/dir length mismatch: speed=" +
            speed_values.length().to_string() +
            ", dir=" +
            dir_values.length().to_string(),
          )
        }
        let u_values : Array[Double] = []
        let v_values : Array[Double] = []
        for i in 0..<speed_values.length() {
          let (u, v) = wind_uv_from_speed_dir(speed_values[i], dir_values[i])
          u_values.push(u)
          v_values.push(v)
        }
        let speed_meta = metas[speed_candidate.record_index - 1]
        // Match wgrib2 ordering: UGRD first, then VGRD.
        let u_sec4 = match
          patch_section4_parameter_ids(speed_message, speed_submessage, 2, 2) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        let u_built = match
          build_wind_simple_packed_submessage_bytes(
            "-wind_uv",
            speed_message,
            speed_submessage,
            speed_meta,
            u_sec4,
            u_values,
            speed_meta.section5_reference_value_ieee,
            speed_meta.section5_binary_scale_factor,
            speed_meta.section5_decimal_scale_factor,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, u_built)
        let v_sec4 = match
          patch_section4_parameter_ids(speed_message, speed_submessage, 2, 3) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        let v_built = match
          build_wind_simple_packed_submessage_bytes(
            "-wind_uv",
            speed_message,
            speed_submessage,
            speed_meta,
            v_sec4,
            v_values,
            speed_meta.section5_reference_value_ieee,
            speed_meta.section5_binary_scale_factor,
            speed_meta.section5_decimal_scale_factor,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        append_bytes(out, v_built)
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
fn write_gridout_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let target_record = first_selected_record(selected)
  let records = @lib.decode_records(context)
  let mut found : @lib.Grib2RecordMeta? = None
  for meta in records {
    if meta.record_index == target_record {
      found = Some(meta)
      break
    }
  }
  let meta = match found {
    Some(v) => v
    None =>
      return Err("record not found for -gridout: " + target_record.to_string())
  }
  if meta.section3_template.id() != 0 ||
    meta.section3_ni <= 0 ||
    meta.section3_nj <= 0 {
    return Err(
      "-gridout currently supports regular lat/lon grid (template 3.0)",
    )
  }
  let lines : Array[String] = []
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      match grid_ij_to_latlon_from_meta(meta, i, j) {
        Some((lon, lat)) =>
          lines.push(
            pad_left(i.to_string(), 10) +
            "," +
            pad_left(j.to_string(), 10) +
            ", " +
            format_fixed(lat, 3) +
            ", " +
            format_fixed(lon, 3),
          )
        None => ()
      }
    }
  }
  let content = lines.join("\n") + "\n"
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn name_lookup_text(name : @lib.Grib2NameLookup) -> String {
  match name {
    NameKnown(v) => v
    NameUnknown(v) => v
  }
}

///|
fn gribtable_used_master_table_set(
  discipline : Int,
  category : Int,
  parameter : Int,
) -> Int {
  if discipline >= 192 || category >= 192 || parameter >= 192 {
    0
  } else {
    1
  }
}

///|
fn gribtable_used_desc_units(
  discipline : Int,
  category : Int,
  parameter : Int,
  name : String,
) -> (String, String) {
  let fallback = (name, "?")
  if discipline == 0 && category == 0 {
    match parameter {
      0 => return ("Temperature", "K")
      2 => return ("Potential Temperature", "K")
      6 => return ("Dew Point Temperature", "K")
      21 => return ("Apparent Temperature", "K")
      _ => ()
    }
  }
  if discipline == 0 && category == 1 {
    match parameter {
      0 => return ("Specific Humidity", "kg/kg")
      1 => return ("Relative Humidity", "%")
      3 => return ("Precipitable Water", "kg/m^2")
      7 => return ("Precipitation Rate", "kg/m^2/s")
      11 => return ("Snow Depth", "m")
      13 => return ("Water Equivalent of Accumulated Snow Depth", "kg/m^2")
      22 => return ("Cloud Mixing Ratio", "kg/kg")
      23 => return ("Ice Water Mixing Ratio", "kg/kg")
      24 => return ("Rain Mixing Ratio", "kg/kg")
      25 => return ("Snow Mixing Ratio", "kg/kg")
      32 => return ("Graupel", "kg/kg")
      39 => return ("Percent frozen precipitation", "%")
      192 => return ("Categorical Rain", "-")
      193 => return ("Categorical Freezing Rain", "-")
      194 => return ("Categorical Ice Pellets", "-")
      195 => return ("Categorical Snow", "-")
      _ => ()
    }
  }
  if discipline == 0 && category == 2 {
    match parameter {
      0 => return ("Wind Direction (from which blowing)", "deg")
      1 => return ("Wind Speed", "m/s")
      2 => return ("U-Component of Wind", "m/s")
      3 => return ("V-Component of Wind", "m/s")
      8 => return ("Vertical Velocity (Pressure)", "Pa/s")
      9 => return ("Vertical Velocity (Geometric)", "m/s")
      10 => return ("Absolute Vorticity", "1/s")
      22 => return ("Wind Speed (Gust)", "m/s")
      192 => return ("Vertical Speed Shear", "1/s")
      194 => return ("U-Component Storm Motion", "m/s")
      195 => return ("V-Component Storm Motion", "m/s")
      197 => return ("Frictional Velocity", "m/s")
      224 => return ("Ventilation Rate", "m^2/s")
      _ => ()
    }
  }
  if discipline == 0 && category == 3 {
    match parameter {
      0 => return ("Pressure", "Pa")
      1 => return ("Pressure Reduced to MSL", "Pa")
      3 => return ("ICAO Standard Atmosphere Reference Height", "m")
      5 => return ("Geopotential Height", "gpm")
      192 => return ("MSLP (Eta model reduction)", "Pa")
      196 => return ("Planetary Boundary Layer Height", "m")
      200 => return ("Pressure of level from which parcel was lifted", "Pa")
      _ => ()
    }
  }
  if discipline == 0 && category == 6 {
    match parameter {
      1 => return ("Total Cloud Cover", "%")
      3 => return ("Low Cloud Cover", "%")
      4 => return ("Medium Cloud Cover", "%")
      5 => return ("High Cloud Cover", "%")
      6 => return ("Cloud Water", "kg/m^2")
      201 => return ("Sunshine Duration", "s")
      _ => ()
    }
  }
  if discipline == 0 && category == 7 {
    match parameter {
      6 => return ("Convective Available Potential Energy", "J/kg")
      7 => return ("Convective Inhibition", "J/kg")
      8 => return ("Storm Relative Helicity", "m^2/s^2")
      192 => return ("Surface Lifted Index", "K")
      193 => return ("Best (4 layer) Lifted Index", "K")
      _ => ()
    }
  }
  if discipline == 0 && category == 14 {
    match parameter {
      0 => return ("Total Ozone", "DU")
      192 => return ("Ozone Mixing Ratio", "kg/kg")
      _ => ()
    }
  }
  if discipline == 0 && category == 16 {
    match parameter {
      195 => return ("Reflectivity", "dB")
      196 => return ("Composite reflectivity", "dB")
      _ => ()
    }
  }
  if discipline == 0 && category == 19 {
    match parameter {
      0 => return ("Visibility", "m")
      _ => ()
    }
  }
  if discipline == 2 && category == 0 {
    match parameter {
      0 => return ("Land Cover (0=sea, 1=land)", "Proportion")
      1 => return ("Surface Roughness", "m")
      2 => return ("Soil Temperature", "K")
      4 => return ("Vegetation", "%")
      192 => return ("Volumetric Soil Moisture Content", "Fraction")
      196 => return ("Plant Canopy Surface Water", "kg/m^2")
      201 => return ("Wilting Point", "Fraction")
      _ => ()
    }
  }
  if discipline == 2 && category == 3 {
    match parameter {
      0 => return ("Soil Type", "-")
      192 =>
        return ("Liquid Volumetric Soil Moisture (non Frozen)", "Proportion")
      203 => return ("Field Capacity", "Fraction")
      _ => ()
    }
  }
  if discipline == 2 && category == 4 {
    match parameter {
      2 => return ("Haines Index", "Numeric")
      _ => ()
    }
  }
  if discipline == 10 && category == 0 {
    match parameter {
      3 => return ("Significant Height of Combined Wind Waves and Swell", "m")
      4 => return ("Direction of Wind Waves", "deg")
      5 => return ("Significant Height of Wind Waves", "m")
      6 => return ("Mean Period of Wind Waves", "s")
      7 => return ("Direction of Swell Waves", "deg")
      8 => return ("Significant Height of Swell Waves", "m")
      9 => return ("Mean Period of Swell Waves", "s")
      10 => return ("Primary Wave Direction", "deg")
      11 => return ("Primary Wave Mean Period", "s")
      _ => ()
    }
  }
  if discipline == 10 && category == 2 {
    match parameter {
      0 => return ("Ice Cover", "Proportion")
      1 => return ("Ice Thickness", "m")
      6 => return ("Ice Growth Rate", "m/s")
      8 => return ("Ice Temperature", "K")
      _ => ()
    }
  }
  fallback
}

///|
fn write_gribtable_used_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let records = @lib.decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    if !record_is_selected(meta.record_index, selected) {
      continue
    }
    let name = name_lookup_text(meta.parameter_name)
    let (desc, units) = gribtable_used_desc_units(
      meta.discipline,
      meta.section4_parameter_category,
      meta.section4_parameter_number,
      name,
    )
    lines.push(
      meta.discipline.to_string() +
      ":" +
      gribtable_used_master_table_set(
        meta.discipline,
        meta.section4_parameter_category,
        meta.section4_parameter_number,
      ).to_string() +
      ":" +
      "0:255:" +
      meta.section1_center.to_string() +
      ":" +
      meta.section1_local_tables_version.to_string() +
      ":" +
      meta.section4_parameter_category.to_string() +
      ":" +
      meta.section4_parameter_number.to_string() +
      ":" +
      name +
      ":" +
      desc +
      ":" +
      units,
    )
  }
  let content = lines.join("\n") + "\n"
  if append_mode {
    native_append_string(destination, content)
  } else {
    native_write_string(destination, content)
  }
}

///|
fn build_config_lines() -> Array[String] {
  ["grib2_mbt config", "engine=moonbit", "compat=wgrib2-subset"]
}

///|
fn write_export_lonlat_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let target_record = first_selected_record(selected)
  let records = @lib.decode_records(context)
  let mut found : @lib.Grib2RecordMeta? = None
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
fn parse_mode(args : Array[String]) -> @lib.Grib2InventoryMode? {
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
        @lib.render_inventory_lines_with_io(
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
        Ok(_) => return 0
        Err(error) => {
          println("error: " + error)
          return 2
        }
      }
    }
    WriteGribtableUsed(destination) => {
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
      let context = match @lib.parse_with_io(native_read_bytes, file_path) {
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
        @lib.render_inventory_lines_with_io(native_read_bytes, file_path, mode) {
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
