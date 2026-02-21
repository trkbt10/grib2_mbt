///|
fn print_usage() -> Unit {
  println("usage: grib2_mbt <grib2-file> [option]")
  println("options:")
  println("  -s      print inventory lines")
  println("  -Sec0   print section0 summary lines")
  println("  -Sec3   print section3 summary lines")
  println("  -Sec4   print section4 summary lines")
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
      println("supported options: -s, -Sec0, -Sec3, -Sec4, -var -lev")
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
