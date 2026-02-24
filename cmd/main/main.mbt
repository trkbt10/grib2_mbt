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
  println("  -code_table_1.2  print significance of reference time (code table 1.2)")
  println("  -code_table_1.3  print production status (code table 1.3)")
  println("  -code_table_1.4  print type of data (code table 1.4)")
  println("  -code_table_3.0  print source of grid definition (code table 3.0)")
  println("  -code_table_3.1  print grid definition template (code table 3.1)")
  println("  -code_table_6.0  print bitmap indicator (code table 6.0)")
  println("  -code_table_4.0  print product definition template (code table 4.0)")
  println("  -code_table_4.1  print parameter category (code table 4.1)")
  println("  -code_table_4.2  print parameter number (code table 4.2)")
  println("  -code_table_4.3  print process type (code table 4.3)")
  println("  -code_table_4.4  print unit of time range (code table 4.4)")
  println("  -code_table_5.0  print data representation template (code table 5.0)")
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
  println("  -code_table_3.2  print earth shape (code table 3.2)")
  println("  -code_table_4.5a  print first surface type (code table 4.5)")
  println("  -code_table_4.5b  print second surface type (code table 4.5)")
  println("  -code_table_1.5  print identification template number")
  println("  -code_table_1.6  print calendar")
  println("  -code_table_4.6  print ensemble type")
  println("  -code_table_4.9  print probability type")
  println("  -code_table_4.10  print statistical processing type")
  println("  -code_table_4.11  print type of time intervals")
}

///|
fn print_lines(lines : Array[String]) -> Unit {
  for line in lines {
    println(line)
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
fn parse_mode(args : Array[String]) -> @lib.Grib2InventoryMode? {
  if args.length() == 0 || (args.length() == 1 && args[0] == "-s") {
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
  None
}

///|
fn run_cli(args : Array[String]) -> Int {
  if args.length() < 2 {
    print_usage()
    return 1
  }
  if args.length() > 4 {
    println("error: too many arguments")
    print_usage()
    return 1
  }
  let file_path = args[1]
  let rest = if args.length() > 2 { [args[2], ..args[3:]] } else { [] }
  let mode = match parse_mode(rest) {
    Some(mode) => mode
    None => {
      println("error: unsupported option")
      println(
        "supported options: -s, -Sec0, -Sec3, -Sec4, -Sec5, -Sec6, -Sec_len, -n, -range, -var, -lev, -ftime, -t, -T, -vt, -VT, -YY, -MM, -grid, -pdt, -process, -ens, -prob, -disc, -center, -subcenter, -packing, -bitmap, -nxny, -npts, -var -lev",
      )
      return 3
    }
  }
  let lines = match
    @lib.render_inventory_lines_with_io(native_read_bytes, file_path, mode) {
    Ok(lines) => lines
    Err(error) => {
      println("error: " + error.to_string())
      return 2
    }
  }
  print_lines(lines)
  0
}

///|
fn main {
  let args = @sys.get_cli_args()
  let exit_code = run_cli(args)
  @sys.exit(exit_code)
}
