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
        "supported options: -s, -Sec0, -Sec3, -Sec4, -Sec5, -Sec6, -Sec_len, -n, -range, -var, -lev, -ftime, -grid, -pdt, -process, -ens, -prob, -disc, -center, -subcenter, -packing, -bitmap, -nxny, -npts, -var -lev",
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
