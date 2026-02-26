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
  println("  -csv_long file  write unpacked data as CSV (compat alias)")
  println("  -spread file  write one CSV line per record with all values")
  println("  -AAIG file  write ArcInfo Ascii Grid for selected record")
  println("  -AAIGlong file  write ArcInfo Ascii Grid (compat long-name)")
  println("  -ijbox I J file mode  write box values, mode=bin|text|spread")
  println("  -ijsmall_grib I J file  make small-domain grib (limited support)")
  println("  -small_grib lonW:lonE latS:latN file  small-domain grib (limited)")
  println("  -lola X Y file mode  lon-lat grid output (identity remap only)")
  println("  -grib_out_irr all|defined file  irregular-grid grib (raw compat)")
  println("  -grib_out_irr2 N G R UUID file  irregular-grid grib2 (raw compat)")
  println("  -new_grid_order out out2  vector ordering compat (limited)")
  println("  -submsg_uv file  vector submessage combine (raw compat)")
  println("  -ncep_uv file  NCEP-style UV combine (raw compat)")
  println(
    "  -reduced_gaussian_grid out -1 method  reduced Gaussian (limited compat)",
  )
  println("  -ncep_norm out  normalize NCEP ave/acc (limited compat)")
  println("  -merge_fcst n out  merge fcst intervals (limited compat)")
  println("  -unmerge_fcst out t z  unmerge fcst (limited compat)")
  println("  -wind_speed out  calculate wind speed (limited compat)")
  println("  -wind_dir out  calculate wind direction (limited compat)")
  println("  -wind_uv out  calculate U/V from speed/dir (limited compat)")
  println(
    "  -tosubmsg file  convert message to submessage stream (discipline-aware)",
  )
  println("  -gridout file  write i j lat lon table for selected record")
  println("  -gribtable_used file  write derived parameter table entries")
  println("  -write_sec N file  write concatenated section N bytes (0-8)")
  println("  -append  append mode for output files")
  println("  -no_append  disable append mode (default)")
  println("  -big_endian  set binary output endianness to big")
  println("  -little_endian  set binary output endianness to little")
  println("  -colon X  replace inventory delimiter ':' with X")
  println("  -last  keep only last matching record")
  println("  -last0  keep only last matching record (compat)")
  println("  -no_header  suppress csv header")
  println("  -text_col N  wrap text output lines at N columns")
  println(
    "  -text_fmt FMT  numeric format for text/csv/spread (e.g. %.6f, %.6g)",
  )
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
  WriteCsv(String)
  WriteSpread(String)
  WriteAaig(String, Bool)
  WriteGribIeee(String)
  WriteIjbox(String, String, String, String)
  WriteIjsmallGrib(String, String, String)
  WriteSmallGrib(String, String, String)
  WriteLola(String, String, String, String)
  WriteGribOutIrr(String, String)
  WriteGribOutIrr2(String, String, String, String, String)
  WriteNewGridOrder(String, String)
  WriteSubmsgUv(String)
  WriteNcepUv(String)
  WriteReducedGaussianGrid(String, String, String)
  WriteNcepNorm(String)
  WriteMergeFcst(String, String)
  WriteUnmergeFcst(String, String, String)
  WriteWindSpeed(String)
  WriteWindDir(String)
  WriteWindUv(String)
  WriteToSubmsg(String)
  WriteSection(Int, String)
  WriteGridout(String)
  WriteGribtableUsed(String)
  WriteExportLonlat(String)
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
fn default_init_options() -> CliInitOptions {
  {
    crlf: false,
    one_line: false,
    append_mode: false,
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
  if action_tokens.length() == 2 &&
    (action_tokens[0] == "-csv" || action_tokens[0] == "-csv_long") {
    return Ok((init, WriteCsv(action_tokens[1])))
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
  if action_tokens.length() == 2 && action_tokens[0] == "-gribtable_used" {
    return Ok((init, WriteGribtableUsed(action_tokens[1])))
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
  let sec1 = section_frame_bytes(message, message.section1)
  let sec2 = match submessage.section2 {
    Some(s) => section_frame_bytes(message, s)
    None => Bytes::new(0)
  }
  let sec3 = section_frame_bytes(message, submessage.section3)
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
  let mut record_index = 1
  for message in context.messages {
    let mut selected_in_message = false
    for _ in message.submessages {
      if record_is_selected(record_index, selected) {
        selected_in_message = true
      }
      record_index += 1
    }
    if selected_in_message {
      append_bytes(out, message.raw)
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::from_array(out))
  } else {
    native_write_bytes(destination, Bytes::from_array(out))
  }
}

///|
fn build_submessage_header_bytes(
  message : @lib.Grib2MessageContext,
  submessage : @lib.Grib2SubmessageFrame,
) -> Bytes {
  let sec0 = match get_record_section_bytes(message, submessage, 0) {
    Some(v) => v
    None => Bytes::new(0)
  }
  let sec1 = section_frame_bytes(message, message.section1)
  let sec2 = match submessage.section2 {
    Some(s) => section_frame_bytes(message, s)
    None => Bytes::new(0)
  }
  let sec3 = section_frame_bytes(message, submessage.section3)
  let sec4 = section_frame_bytes(message, submessage.section4)
  let sec5 = section_frame_bytes(message, submessage.section5)
  let sec6 = section_frame_bytes(message, submessage.section6)
  let out : Array[Byte] = []
  append_bytes(out, sec0)
  append_bytes(out, sec1)
  append_bytes(out, sec2)
  append_bytes(out, sec3)
  append_bytes(out, sec4)
  append_bytes(out, sec5)
  append_bytes(out, sec6)
  Bytes::from_array(out)
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
  let grb_out : Array[Byte] = []
  let head_out : Array[Byte] = []
  let tail_out : Array[Byte] = []
  let mut records = 0
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        append_bytes(grb_out, build_submessage_grib_bytes(message, submessage))
        append_bytes(
          head_out,
          build_submessage_header_bytes(message, submessage),
        )
        append_bytes(tail_out, Bytes::from_array([b'7', b'7', b'7', b'7']))
        records += 1
      }
      record_index += 1
    }
  }
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
  match write_bytes(grb_path, Bytes::from_array(grb_out)) {
    Ok(_) => ()
    Err(e) => return Err(e)
  }
  match write_bytes(head_path, Bytes::from_array(head_out)) {
    Ok(_) => ()
    Err(e) => return Err(e)
  }
  match write_bytes(tail_path, Bytes::from_array(tail_out)) {
    Ok(_) => ()
    Err(e) => return Err(e)
  }
  let header = "/* grib_ieee compatibility output */\n" +
    "#define GRIB_IEEE_RECORDS " +
    records.to_string() +
    "\n"
  write_text(h_path, header)
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
fn apply_text_columns(lines : Array[String], columns : Int?) -> Array[String] {
  match columns {
    None => lines
    Some(n) => {
      let out : Array[String] = []
      for line in lines {
        for part in split_line_by_columns(line, n) {
          out.push(part)
        }
      }
      out
    }
  }
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
    "nan"
  } else {
    v.to_string()
  }
}

///|
fn format_fixed(value : Double, digits : Int) -> String {
  let mut factor = 1.0
  for _ in 0..<digits {
    factor *= 10.0
  }
  let mut divisor = 1
  for _ in 0..<digits {
    divisor *= 10
  }
  let adjust = if value >= 0.0 { 0.5 } else { -0.5 }
  let rounded = (value * factor + adjust).to_int()
  let abs_rounded = rounded.abs()
  let int_part = abs_rounded / divisor
  let frac_part = abs_rounded % divisor
  if digits == 0 {
    if rounded < 0 {
      "-" + int_part.to_string()
    } else {
      int_part.to_string()
    }
  } else {
    let frac = frac_part.to_string()
    let padding = "0".repeat(digits - frac.length())
    if rounded < 0 {
      "-" + int_part.to_string() + "." + padding + frac
    } else {
      int_part.to_string() + "." + padding + frac
    }
  }
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
    return "nan"
  }
  match parse_text_format_spec(text_fmt) {
    None => format_data_value(v)
    Some((verb, precision_raw)) => {
      let default_precision = 6
      let precision = if precision_raw >= 0 {
        precision_raw
      } else {
        default_precision
      }
      if verb == "f" || verb == "F" {
        format_fixed(v, precision)
      } else if verb == "e" {
        format_scientific(v, precision, false, false)
      } else if verb == "E" {
        format_scientific(v, precision, true, false)
      } else if verb == "g" {
        format_general(v, precision, false)
      } else if verb == "G" {
        format_general(v, precision, true)
      } else {
        format_data_value(v)
      }
    }
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
fn normalize_binary_output_value(value : Double) -> Double {
  // wgrib2 writes undefined bitmap points as 9.999e20 in -bin/-ieee outputs.
  if value != value {
    wgrib2_nodata_value()
  } else {
    value
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
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
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
            normalize_binary_output_value(value),
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
  text_col : Int?,
  text_fmt : String?,
) -> Result[Unit, String] {
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let unpacked = match @lib.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (text output)",
            )
        }
        for point = 0; point < unpacked.values.length(); point = point + 1 {
          lines.push(
            record_index.to_string() +
            ":" +
            (point + 1).to_string() +
            ":" +
            format_data_value_with_fmt(unpacked.values[point], text_fmt),
          )
        }
      }
      record_index += 1
    }
  }
  let content = build_output_content(apply_text_columns(lines, text_col), crlf)
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
  crlf : Bool,
  append_mode : Bool,
  no_header : Bool,
  text_fmt : String?,
) -> Result[Unit, String] {
  let lines : Array[String] = []
  if !no_header && !append_mode {
    lines.push("record,point,value")
  }
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let unpacked = match @lib.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (csv output)",
            )
        }
        for point = 0; point < unpacked.values.length(); point = point + 1 {
          lines.push(
            record_index.to_string() +
            "," +
            (point + 1).to_string() +
            "," +
            format_data_value_with_fmt(unpacked.values[point], text_fmt),
          )
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
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      if record_is_selected(record_index, selected) {
        let unpacked = match @lib.unpack_submessage_data(message, submessage) {
          Ok(v) => v
          Err(_) =>
            return Err(
              "failed to unpack record " +
              record_index.to_string() +
              " (spread output)",
            )
        }
        let values : Array[String] = []
        for value in unpacked.values {
          values.push(format_data_value_with_fmt(value, text_fmt))
        }
        lines.push(record_index.to_string() + "," + values.join(","))
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
  let di = meta.section3_di_microdeg.to_double() / 1000000.0
  let dj = meta.section3_dj_microdeg.to_double() / 1000000.0
  let scan = meta.section3_scanning_mode
  let j_data = if (scan & 0x40) == 0 { nj - j + 1 } else { j }
  let i_inc = if (scan & 0x80) == 0 { di } else { -di }
  let j_inc = if (scan & 0x40) == 0 { -dj } else { dj }
  let lon = lon1 + (i - 1).to_double() * i_inc
  let lat = lat1 + (j_data - 1).to_double() * j_inc
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
fn aaig_row_index(meta : @lib.Grib2RecordMeta, row : Int) -> Int {
  let nj = meta.section3_nj
  let scan = meta.section3_scanning_mode
  if (scan & 0x40) == 0 {
    // source rows are north -> south
    row
  } else {
    // source rows are south -> north
    nj - row + 1
  }
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
  let lon_min = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let lat_min = (
      meta.section3_lat1_microdeg.to_double() -
      (nj - 1).to_double() * meta.section3_dj_microdeg.to_double()
    ) /
    1000000.0
  let cellsize = meta.section3_di_microdeg.to_double().abs() / 1000000.0
  let nodata = "9.999e20"
  let lines : Array[String] = []
  lines.push("ncols " + ni.to_string())
  lines.push("nrows " + nj.to_string())
  lines.push("xllcorner " + format_coord6(lon_min))
  lines.push("yllcorner " + format_coord6(lat_min))
  lines.push("cellsize " + format_coord6(cellsize))
  lines.push("NODATA_value " + nodata)
  for row = 1; row <= nj; row = row + 1 {
    let source_row = aaig_row_index(meta, row)
    let start = (source_row - 1) * ni
    let fields : Array[String] = []
    for col = 0; col < ni; col = col + 1 {
      fields.push(format_data_value(values[start + col]))
    }
    lines.push(fields.join(" "))
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
  let scan = meta.section3_scanning_mode
  let j_data = if (scan & 0x40) == 0 { nj - j + 1 } else { j }
  let i_data = if (scan & 0x80) == 0 { i } else { ni - i + 1 }
  Some((j_data - 1) * ni + (i_data - 1))
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
      if mode == "spread" {
        for j = j_start; j <= j_end; j = j + j_step {
          let row : Array[String] = []
          for i = i_start; i <= i_end; i = i + i_step {
            let idx = match value_index_for_ij(meta, i, j) {
              Some(v) => v
              None => return Err("invalid ij point in -ijbox")
            }
            row.push(format_data_value(values[idx]))
          }
          text_lines.push(row.join(","))
        }
      } else {
        for j = j_start; j <= j_end; j = j + j_step {
          for i = i_start; i <= i_end; i = i + i_step {
            let idx = match value_index_for_ij(meta, i, j) {
              Some(v) => v
              None => return Err("invalid ij point in -ijbox")
            }
            let value = values[idx]
            if mode == "bin" {
              append_f32_bytes(out_bytes, value, false)
            } else if mode == "text" {
              text_lines.push(
                record_index.to_string() +
                ":" +
                i.to_string() +
                ":" +
                j.to_string() +
                ":" +
                format_data_value(value),
              )
            } else {
              return Err("unsupported -ijbox mode: " + mode)
            }
          }
        }
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
  write_raw_output(destination, context, selected, append_mode)
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
fn nearly_equal(a : Double, b : Double, eps : Double) -> Bool {
  (a - b).abs() <= eps
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
  write_raw_output(destination, context, selected, append_mode)
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
      destination, context, selected, crlf, append_mode, text_col, text_fmt,
    )
  } else if mode == "spread" {
    write_spread_output(
      destination, context, selected, crlf, append_mode, text_fmt,
    )
  } else if mode == "grib" {
    write_raw_output(destination, context, selected, append_mode)
  } else {
    Err("unsupported -lola mode: " + mode)
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
  // Limited compatibility: pass selected records through as GRIB.
  write_raw_output(destination, context, selected, append_mode)
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
  let n = match parse_int_option(npnts) {
    Some(v) => v
    None => return Err("-grib_out_irr2 npnts must be an integer")
  }
  if n <= 0 {
    return Err("-grib_out_irr2 npnts must be > 0")
  }
  match parse_int_option(grid_no) {
    Some(_) => ()
    None => return Err("-grib_out_irr2 grid_no must be an integer")
  }
  match parse_int_option(grid_ref) {
    Some(_) => ()
    None => return Err("-grib_out_irr2 grid_ref must be an integer")
  }
  if uuid.length() == 0 {
    return Err("-grib_out_irr2 uuid must not be empty")
  }
  // Limited compatibility: keep selected GRIB payload, ignore irregular-grid metadata.
  write_raw_output(destination, context, selected, append_mode)
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
fn write_vector_combine_compat_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  // Limited compatibility: keep selected records unchanged as GRIB output.
  write_raw_output(destination, context, selected, append_mode)
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
  // Limited compatibility:
  // - for non-Gaussian records, match wgrib2 behavior by producing no records.
  // - for Gaussian records, transformation path is not implemented yet.
  let records = @lib.decode_records(context)
  for meta in records {
    if record_is_selected(meta.record_index, selected) &&
      meta.section3_template.id() == 40 {
      return Err(
        "-reduced_gaussian_grid for Gaussian grids is not implemented yet",
      )
    }
  }
  if append_mode {
    native_append_bytes(destination, Bytes::new(0))
  } else {
    native_write_bytes(destination, Bytes::new(0))
  }
}

///|
fn parse_unmerge_fcst_time_spec(spec : String) -> Bool {
  if spec.has_suffix("mn") ||
    spec.has_suffix("hr") ||
    spec.has_suffix("dy") ||
    spec.has_suffix("mo") ||
    spec.has_suffix("yr") {
    let n = spec.substring(end=spec.length() - 2)
    return parse_int_option(n) != None
  }
  false
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
fn write_ncep_norm_output(
  destination : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  // Limited compatibility: transformation is not implemented yet.
  write_empty_compat_output(destination, append_mode)
}

///|
fn write_merge_fcst_output(
  intervals : String,
  destination : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  let n = match parse_int_option(intervals) {
    Some(v) => v
    None => return Err("merge_fcst: arg must be integer")
  }
  if n < 0 {
    return Err("merge_fcst: arg must be >= 0")
  }
  // Limited compatibility: merge transformation is not implemented yet.
  write_empty_compat_output(destination, append_mode)
}

///|
fn write_unmerge_fcst_output(
  destination : String,
  fcst_time_0 : String,
  z_arg : String,
  append_mode : Bool,
) -> Result[Unit, String] {
  if !parse_unmerge_fcst_time_spec(fcst_time_0) {
    return Err("unmerge_fcst: bad (int)(mn|hr|dy|mo|yr)")
  }
  let z = match parse_int_option(z_arg) {
    Some(v) => v
    None => return Err("unmerge_fcst: z must be 0..2")
  }
  if z < 0 || z > 2 {
    return Err("unmerge_fcst: z must be 0..2")
  }
  // Limited compatibility: unmerge transformation is not implemented yet.
  write_empty_compat_output(destination, append_mode)
}

///|
struct WindCandidateRecord {
  record_index : Int
  message_index : Int
  submessage_index : Int
  pair_key : Bytes
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
fn f32_ieee_big_endian_bytes(values : Array[Double]) -> Bytes {
  let out : Array[Byte] = []
  for value in values {
    append_f32_bytes(out, value, true)
  }
  Bytes::from_array(out)
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
  let mut deg = @math.atan2(-u, -v) * 180.0 / @math.PI
  if deg < 0.0 {
    deg += 360.0
  }
  deg
}

///|
fn wind_derived_value(u : Double, v : Double, mode : WindDerivedMode) -> Double {
  match mode {
    WindDerivedSpeed =>
      if u != u || v != v {
        0.0 / 0.0
      } else {
        @math.hypot(u, v)
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
fn round_to_int(v : Double) -> Int {
  let lower_f = @math.floor(v)
  let frac = v - lower_f
  let lower = lower_f.to_int()
  if frac < 0.5 {
    lower
  } else if frac > 0.5 {
    lower + 1
    // Tie: round to nearest even.
  } else if lower % 2 == 0 {
    lower
  } else {
    lower + 1
  }
}

///|
fn pow10_int(n : Int) -> Double {
  if n <= 0 {
    return 1.0
  }
  let mut out = 1.0
  for _ in 0..<n {
    out = out * 10.0
  }
  out
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
fn try_build_wind_simple_packed_sections(
  derived_values : Array[Double],
) -> (Bytes, Bytes)? {
  if derived_values.length() == 0 {
    return None
  }
  let mut min_value = derived_values[0]
  let mut max_value = derived_values[0]
  for v in derived_values {
    if v != v {
      return None
    }
    if v < min_value {
      min_value = v
    }
    if v > max_value {
      max_value = v
    }
  }
  let decimal_scale_factor = if max_value <= 180.0 { 1 } else { 0 }
  let scale = pow10_int(decimal_scale_factor)
  let reference_value = Float::from_double(min_value * scale).to_double()
  let scaled_ints : Array[Int] = []
  let mut max_scaled = 0
  for v in derived_values {
    let x = round_to_int(v * scale - reference_value)
    let nonneg = if x < 0 { 0 } else { x }
    if nonneg > max_scaled {
      max_scaled = nonneg
    }
    scaled_ints.push(nonneg)
  }
  let bits_per_value = required_bits_nonnegative(max_scaled)
  if bits_per_value > 31 {
    return None
  }
  let sec5 = @lib.encode_section5_bytes({
    number_of_data_points: derived_values.length(),
    template: DataRepresentationTemplate50({
      reference_value_ieee: Float::from_double(reference_value).reinterpret_as_int(),
      binary_scale_factor: 0,
      decimal_scale_factor,
      bits_per_value,
      original_field_value_type: 0,
      reserved_tail: b"",
    }),
  })
  let sec7 = @lib.encode_section7_bytes({
    template: DataTemplate70({
      data_values_raw: pack_unsigned_values_be(scaled_ints, bits_per_value),
    }),
  })
  Some((sec5, sec7))
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
      if packing != 0 && packing != 3 && packing != 4 {
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
        let (sec5, sec7) = match
          try_build_wind_simple_packed_sections(derived_values) {
          Some((p5, p7)) => (p5, p7)
          None => {
            let p5 = @lib.encode_section5_bytes({
              number_of_data_points: derived_values.length(),
              template: DataRepresentationTemplate54({
                precision: 1,
                reserved_tail: b"",
              }),
            })
            let p7 = @lib.encode_section7_bytes({
              template: DataTemplate74({
                data_values_raw: f32_ieee_big_endian_bytes(derived_values),
              }),
            })
            (p5, p7)
          }
        }
        let sec6 = @lib.encode_section6_bytes({
          bitmap_indicator: 255,
          bitmap_raw: b"",
        })
        append_bytes(
          out,
          build_submessage_grib_bytes_with_overrides(
            u_message,
            u_submessage,
            Some(sec4),
            Some(sec5),
            Some(sec6),
            Some(sec7),
          ),
        )
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
            if packing != 0 && packing != 3 && packing != 4 {
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
        let sec6 = @lib.encode_section6_bytes({
          bitmap_indicator: 255,
          bitmap_raw: b"",
        })
        // Match wgrib2 ordering: UGRD first, then VGRD.
        let u_sec4 = match
          patch_section4_parameter_ids(speed_message, speed_submessage, 2, 2) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        let (u_sec5, u_sec7) = match
          try_build_wind_simple_packed_sections(u_values) {
          Some((p5, p7)) => (p5, p7)
          None => {
            let p5 = @lib.encode_section5_bytes({
              number_of_data_points: u_values.length(),
              template: DataRepresentationTemplate54({
                precision: 1,
                reserved_tail: b"",
              }),
            })
            let p7 = @lib.encode_section7_bytes({
              template: DataTemplate74({
                data_values_raw: f32_ieee_big_endian_bytes(u_values),
              }),
            })
            (p5, p7)
          }
        }
        append_bytes(
          out,
          build_submessage_grib_bytes_with_overrides(
            speed_message,
            speed_submessage,
            Some(u_sec4),
            Some(u_sec5),
            Some(sec6),
            Some(u_sec7),
          ),
        )
        let v_sec4 = match
          patch_section4_parameter_ids(speed_message, speed_submessage, 2, 3) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        let (v_sec5, v_sec7) = match
          try_build_wind_simple_packed_sections(v_values) {
          Some((p5, p7)) => (p5, p7)
          None => {
            let p5 = @lib.encode_section5_bytes({
              number_of_data_points: v_values.length(),
              template: DataRepresentationTemplate54({
                precision: 1,
                reserved_tail: b"",
              }),
            })
            let p7 = @lib.encode_section7_bytes({
              template: DataTemplate74({
                data_values_raw: f32_ieee_big_endian_bytes(v_values),
              }),
            })
            (p5, p7)
          }
        }
        append_bytes(
          out,
          build_submessage_grib_bytes_with_overrides(
            speed_message,
            speed_submessage,
            Some(v_sec4),
            Some(v_sec5),
            Some(sec6),
            Some(v_sec7),
          ),
        )
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
  lines.push("i j lat lon")
  for j = 1; j <= meta.section3_nj; j = j + 1 {
    for i = 1; i <= meta.section3_ni; i = i + 1 {
      match grid_ij_to_latlon_from_meta(meta, i, j) {
        Some((lon, lat)) =>
          lines.push(
            i.to_string() +
            " " +
            j.to_string() +
            " " +
            format_coord6(lat) +
            " " +
            format_coord6(lon),
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
fn write_gribtable_used_output(
  destination : String,
  context : @lib.Grib2FileContext,
  selected : Array[Int]?,
  append_mode : Bool,
) -> Result[Unit, String] {
  let records = @lib.decode_records(context)
  let seen : Array[String] = []
  let lines : Array[String] = []
  let should_write_header = if append_mode {
    let existing = @fs.read_file_to_string(destination) catch { _ => "" }
    existing.length() == 0
  } else {
    true
  }
  if should_write_header {
    lines.push("# disc:cat:param:name")
  }
  for meta in records {
    if !record_is_selected(meta.record_index, selected) {
      continue
    }
    let key = meta.discipline.to_string() +
      ":" +
      meta.section4_parameter_category.to_string() +
      ":" +
      meta.section4_parameter_number.to_string()
    let mut exists = false
    for k in seen {
      if k == key {
        exists = true
        break
      }
    }
    if !exists {
      seen.push(key)
      lines.push(key + ":" + name_lookup_text(meta.parameter_name))
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
        write_vector_combine_compat_output(
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
        write_vector_combine_compat_output(
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
      match write_ncep_norm_output(destination, init.append_mode) {
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
      match write_merge_fcst_output(intervals, destination, init.append_mode) {
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
    WriteCsv(destination) => {
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
