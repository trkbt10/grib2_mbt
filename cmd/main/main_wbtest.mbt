///|
fn count_crlf_pairs(bytes : Bytes) -> Int {
  let mut n = 0
  if bytes.length() < 2 {
    return 0
  }
  for i in 0..<(bytes.length() - 1) {
    if bytes[i] == b'\r' && bytes[i + 1] == b'\n' {
      n += 1
    }
  }
  n
}

///|
fn line_count(path : String) -> Int {
  let body = @fs.read_file_to_string(path) catch { _ => "" }
  let mut n = 0
  for line in body.split("\n") {
    if line.to_string().length() > 0 {
      n += 1
    }
  }
  n
}

///|
fn count_grib_magic(bytes : Bytes) -> Int {
  if bytes.length() < 4 {
    return 0
  }
  let mut n = 0
  for i in 0..<(bytes.length() - 3) {
    if bytes[i] == b'G' &&
      bytes[i + 1] == b'R' &&
      bytes[i + 2] == b'I' &&
      bytes[i + 3] == b'B' {
      n += 1
    }
  }
  n
}

///|
test "parse_cli_invocation accepts init chain + action" {
  let tokens = [
    "-crlf", "-for_n", "1:5:2", "-match", "UGRD", "-not", "TMP", "-s",
  ]
  let parsed = match parse_cli_invocation(tokens) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.crlf, content="true")
  inspect(init.one_line, content="false")
  inspect(init.append_mode, content="false")
  inspect(init.output_big_endian, content="None")
  inspect(init.no_header, content="false")
  inspect(init.text_col, content="None")
  inspect(init.text_fmt, content="None")
  inspect(init.colon_delimiter, content="None")
  inspect(init.select_last, content="false")
  inspect(init.select_last0, content="false")
  inspect(init.inv_f77_mode, content="None")
  inspect(init.inv_f77_width, content="None")
  inspect(init.nl_out_path, content="None")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  inspect(init.for_n, content="Some(\"1:5:2\")")
  inspect(init.match_patterns.length(), content="1")
  inspect(init.not_patterns.length(), content="1")
  inspect(init.match_patterns[0], content="UGRD")
  inspect(init.not_patterns[0], content="TMP")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_for_n_spec accepts start:end (default step=1)" {
  match parse_for_n_spec("11:11") {
    Some((start, end, step)) => {
      inspect(start, content="11")
      inspect(end, content="11")
      inspect(step, content="1")
    }
    None => fail("expected valid start:end form")
  }
}

///|
test "parse_cli_invocation accepts -for_n start:end form" {
  let parsed = match parse_cli_invocation(["-for_n", "11:11", "-stats"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.for_n, content="Some(\"11:11\")")
  let is_stats = match action {
    Inventory(InventoryStats) => true
    _ => false
  }
  inspect(is_stats, content="true")
}

///|
test "parse_cli_invocation accepts append/no_header/text_fmt + endian + bin" {
  let parsed = match
    parse_cli_invocation([
      "-append", "-no_header", "-text_fmt", "%.2f", "-big_endian", "-for_n", "1:1:1",
      "-bin", "target/out.bin",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.append_mode, content="true")
  inspect(init.one_line, content="false")
  inspect(init.no_header, content="true")
  inspect(init.text_col, content="None")
  inspect(init.output_big_endian, content="Some(true)")
  inspect(init.text_fmt, content="Some(\"%.2f\")")
  inspect(init.colon_delimiter, content="None")
  inspect(init.select_last, content="false")
  inspect(init.select_last0, content="false")
  inspect(init.inv_f77_mode, content="None")
  inspect(init.inv_f77_width, content="None")
  inspect(init.nl_out_path, content="None")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  let is_bin = match action {
    WriteBin("target/out.bin") => true
    _ => false
  }
  inspect(is_bin, content="true")
}

///|
test "parse_cli_invocation accepts write_sec action" {
  let parsed = match
    parse_cli_invocation([
      "-for_n", "1:1:1", "-write_sec", "0", "target/out.sec0",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.for_n, content="Some(\"1:1:1\")")
  let is_write_sec = match action {
    WriteSection(0, "target/out.sec0") => true
    _ => false
  }
  inspect(is_write_sec, content="true")
}

///|
test "parse_cli_invocation supports out aliases grib_out/csv_long" {
  let p1 = match parse_cli_invocation(["-grib_out", "target/o.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteGribOut("target/o.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-csv_long", "target/o.csv"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteCsv("target/o.csv") => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match parse_cli_invocation(["-tosubmsg", "target/o_sub.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteToSubmsg("target/o_sub.grb2") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports AAIG aliases" {
  let p1 = match parse_cli_invocation(["-AAIG", "target/o.asc"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteAaig("target/o.asc", false) => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-AAIGlong", "target/o_long"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteAaig("target/o_long", true) => true
    _ => false
  }
  inspect(ok2, content="true")
}

///|
test "parse_cli_invocation supports grib_ieee output" {
  let p = match parse_cli_invocation(["-grib_ieee", "target/grib_ieee_base"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteGribIeee("target/grib_ieee_base") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports ijbox output" {
  let p = match
    parse_cli_invocation(["-ijbox", "1:2:1", "1:3:1", "target/ij.txt", "text"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteIjbox("1:2:1", "1:3:1", "target/ij.txt", "text") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports ijsmall_grib output" {
  let p = match
    parse_cli_invocation([
      "-ijsmall_grib", "1:360:1", "1:181:1", "target/s.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteIjsmallGrib("1:360:1", "1:181:1", "target/s.grb2") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports small_grib output" {
  let p = match
    parse_cli_invocation(["-small_grib", "0:359", "-90:90", "target/small.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteSmallGrib("0:359", "-90:90", "target/small.grb2") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports lola output" {
  let p = match
    parse_cli_invocation([
      "-lola", "0:360:1", "-90:181:1", "target/lola.bin", "bin",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteLola("0:360:1", "-90:181:1", "target/lola.bin", "bin") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports grib_out_irr/grib_out_irr2/new_grid_order" {
  let p1 = match
    parse_cli_invocation(["-grib_out_irr", "all", "target/irr.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteGribOutIrr("all", "target/irr.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match
    parse_cli_invocation([
      "-grib_out_irr2", "10", "1", "0", "00000000-0000-0000-0000-000000000000", "target/irr2.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteGribOutIrr2(
      "10",
      "1",
      "0",
      "00000000-0000-0000-0000-000000000000",
      "target/irr2.grb2"
    ) => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match
    parse_cli_invocation([
      "-new_grid_order", "target/order_out.grb2", "target/order_out2.grb2",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteNewGridOrder("target/order_out.grb2", "target/order_out2.grb2") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports submsg_uv and ncep_uv" {
  let p1 = match parse_cli_invocation(["-submsg_uv", "target/submsg.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteSubmsgUv("target/submsg.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-ncep_uv", "target/ncep.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteNcepUv("target/ncep.grb2") => true
    _ => false
  }
  inspect(ok2, content="true")
}

///|
test "parse_cli_invocation supports reduced_gaussian_grid" {
  let p = match
    parse_cli_invocation([
      "-reduced_gaussian_grid", "target/rg.grb2", "-1", "neighbor",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a) = p
  let ok = match a {
    WriteReducedGaussianGrid("target/rg.grb2", "-1", "neighbor") => true
    _ => false
  }
  inspect(ok, content="true")
}

///|
test "parse_cli_invocation supports ncep_norm/merge_fcst/unmerge_fcst" {
  let p1 = match parse_cli_invocation(["-ncep_norm", "target/norm.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteNcepNorm("target/norm.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match
    parse_cli_invocation(["-merge_fcst", "0", "target/merge.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteMergeFcst("0", "target/merge.grb2") => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match
    parse_cli_invocation(["-unmerge_fcst", "target/unmerge.grb2", "0hr", "0"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteUnmergeFcst("target/unmerge.grb2", "0hr", "0") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports wind derived out options" {
  let p1 = match parse_cli_invocation(["-wind_speed", "target/ws.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteWindSpeed("target/ws.grb2") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-wind_dir", "target/wd.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteWindDir("target/wd.grb2") => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match parse_cli_invocation(["-wind_uv", "target/wuv.grb2"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteWindUv("target/wuv.grb2") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports gridout/gribtable_used" {
  let p1 = match parse_cli_invocation(["-gridout", "target/grid.txt"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a1) = p1
  let ok1 = match a1 {
    WriteGridout("target/grid.txt") => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-gribtable_used", "target/table.txt"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    WriteGribtableUsed("target/table.txt") => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match parse_cli_invocation(["-export_lonlat", "target/lonlat.bin"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a3) = p3
  let ok3 = match a3 {
    WriteExportLonlat("target/lonlat.bin") => true
    _ => false
  }
  inspect(ok3, content="true")
}

///|
test "parse_cli_invocation supports count/config and end flag" {
  let p1 = match parse_cli_invocation(["-count"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i1, a1) = p1
  inspect(i1.stop_after_first, content="false")
  inspect(i1.one_line, content="false")
  let ok1 = match a1 {
    CountOnly => true
    _ => false
  }
  inspect(ok1, content="true")

  let p2 = match parse_cli_invocation(["-config"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (_, a2) = p2
  let ok2 = match a2 {
    ConfigOnly => true
    _ => false
  }
  inspect(ok2, content="true")

  let p3 = match parse_cli_invocation(["-end", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i3, a3) = p3
  inspect(i3.stop_after_first, content="true")
  let ok3 = match a3 {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(ok3, content="true")

  let p4 = match parse_cli_invocation(["-quit", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i4, a4) = p4
  inspect(i4.stop_after_first, content="true")
  let ok4 = match a4 {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(ok4, content="true")
}

///|
test "parse_cli_invocation supports one_line and timer no-op options" {
  let parsed = match
    parse_cli_invocation(["-start_timer", "-timer", "-fi", "-one_line", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.one_line, content="true")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation supports text_col and colon" {
  let parsed = match
    parse_cli_invocation(["-text_col", "12", "-colon", "|", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.text_col, content="Some(12)")
  inspect(init.colon_delimiter, content="Some(\"|\")")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation supports for alias" {
  let parsed = match parse_cli_invocation(["-for", "2:4:1", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.for_n, content="Some(\"2:4:1\")")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation supports error_final count condition" {
  let parsed = match
    parse_cli_invocation([
      "-for_n", "1:1:1", "-error_final", "count", "eq", "1", "-s",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.for_n, content="Some(\"1:1:1\")")
  let ok_cond = match init.error_final_count {
    Some({ op: ErrorFinalEq, expected: 1 }) => true
    _ => false
  }
  inspect(ok_cond, content="true")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation accepts print_out and last options" {
  let parsed = match
    parse_cli_invocation([
      "-for_n", "1:9:2", "-last0", "-print_out", "target/out.txt", "-print",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.select_last, content="false")
  inspect(init.select_last0, content="true")
  inspect(init.inv_f77_mode, content="None")
  inspect(init.inv_f77_width, content="None")
  inspect(init.inventory_path, content="Some(\"target/out.txt\")")
  inspect(init.nl_out_path, content="None")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_cli_invocation accepts inv_f77 output arguments" {
  let parsed = match
    parse_cli_invocation([
      "-for_n", "1:1:1", "-inv_f77", "bin", "80", "target/inv_f77.txt", "-s",
    ]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.inv_f77_mode, content="Some(\"bin\")")
  inspect(init.inv_f77_width, content="Some(80)")
  inspect(init.inventory_path, content="Some(\"target/inv_f77.txt\")")
  inspect(init.nl_out_path, content="None")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "parse_mode supports added compatibility aliases" {
  let m1 = parse_mode(["-gdt"])
  let m2 = parse_mode(["-timer"])
  let m3 = parse_mode(["-ctl_inv"])
  let m4 = parse_mode(["-pyinv"])
  let m5 = parse_mode(["-spectral_bands_extname"])
  let m6 = parse_mode(["-proj4_ij2ll", "10", "20"])
  let m7 = parse_mode(["-proj4_ll2ij", "139.5", "35.6"])
  let m8 = parse_mode(["-proj4_ll2i", "139.5", "35.6"])
  inspect(m1, content="Some(InventoryGdt)")
  inspect(m2, content="Some(InventoryTimer)")
  inspect(m3, content="Some(InventoryCtlInv)")
  inspect(m4, content="Some(InventoryPyinv)")
  inspect(m5, content="Some(InventorySpectralBandsExtname)")
  inspect(m6, content="Some(InventoryIJLat(10, 20))")
  inspect(m7, content="Some(InventoryLL2IJ(139.5, 35.6))")
  inspect(m8, content="Some(InventoryLL2I(139.5, 35.6))")
}

///|
test "apply_init_filters applies for_n + match + not" {
  let lines = [
    "1:0:d=2026022100:UGRD:surface:anl:", "2:10:d=2026022100:TMP:surface:anl:", "3:20:d=2026022100:UGRD:surface:anl:",
    "4:30:d=2026022100:VGRD:surface:anl:", "5:40:d=2026022100:UGRD:surface:anl:",
  ]
  let init : CliInitOptions = {
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
    nl_out_path: None,
    print_out_text: None,
    print_out_path: None,
    for_n: Some("1:5:2"),
    match_patterns: ["UGRD"],
    not_patterns: ["TMP"],
    inventory_path: None,
    stop_after_first: false,
    error_final_count: None,
  }
  let filtered = match apply_init_filters(lines, init) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(filtered.length(), content="3")
  inspect(filtered[0], content="1:0:d=2026022100:UGRD:surface:anl:")
  inspect(filtered[1], content="3:20:d=2026022100:UGRD:surface:anl:")
  inspect(filtered[2], content="5:40:d=2026022100:UGRD:surface:anl:")
}

///|
test "apply_init_filters applies end shortcut" {
  let lines = [
    "1:0:d=2026022100:UGRD:surface:anl:", "2:10:d=2026022100:TMP:surface:anl:", "3:20:d=2026022100:UGRD:surface:anl:",
  ]
  let init : CliInitOptions = {
    ..default_init_options(),
    stop_after_first: true,
  }
  let filtered = match apply_init_filters(lines, init) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(filtered.length(), content="1")
  inspect(filtered[0], content="1:0:d=2026022100:UGRD:surface:anl:")
}

///|
test "apply_init_filters supports for_n on n.m inventory numbering" {
  let lines = [
    "1.1:0:d=2024120600:PRMSL:mean sea level:anl:", "1.2:0:d=2024120600:PRES:surface:anl:",
    "2.1:100:d=2024120600:UGRD:10 m above ground:anl:", "2.2:100:d=2024120600:VGRD:10 m above ground:anl:",
  ]
  let init : CliInitOptions = { ..default_init_options(), for_n: Some("2:2") }
  let filtered = match apply_init_filters(lines, init) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  inspect(filtered.length(), content="1")
  inspect(filtered[0], content="1.2:0:d=2024120600:PRES:surface:anl:")
}

///|
test "run_cli supports -crlf -inv with filtered inventory output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_inv_test.txt"
  let args = [
    "grib2_mbt", fixture, "-crlf", "-for_n", "1:3:1", "-inv", out, "-s",
  ]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(count_crlf_pairs(bytes), content="3")
}

///|
test "run_cli supports -count output to file with filters" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_count_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:3:1", "-inv", out, "-count",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read count output: " + e.to_string())
  }
  inspect(body, content="3\n")
}

///|
test "run_cli applies -for_n on n.m style inventories" {
  let fixture = "fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin"
  let out = "target/cmd_main_for_n_dot_style_inv.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1", "-inv", out, "-s"])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body.length() > 0, content="true")
  inspect(body.contains("1.1:"), content="true")
}

///|
test "run_cli supports -error_final for count in inventory mode" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:3:1", "-error_final", "count", "eq", "3",
    "-s",
  ])
  inspect(exit, content="8")
}

///|
test "run_cli supports -error_final for count in output mode" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_error_final_bin_test.bin"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-error_final", "count", "eq", "1",
    "-bin", out,
  ])
  inspect(exit, content="8")
}

///|
test "run_cli supports -config output to file" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_config_test.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-inv", out, "-config"])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read config output: " + e.to_string())
  }
  inspect(body.contains("grib2_mbt config"), content="true")
  inspect(body.contains("engine=moonbit"), content="true")
}

///|
test "run_cli supports -AAIG output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_aaig_test.asc"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-AAIG", out])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read aaig output: " + e.to_string())
  }
  inspect(body.contains("ncols "), content="true")
  inspect(body.contains("nrows "), content="true")
  inspect(body.contains("NODATA_value"), content="true")
}

///|
test "run_cli supports -AAIGlong output with .asc suffix" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let base = "target/cmd_main_aaiglong_test"
  let out = base + ".asc"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-AAIGlong", base,
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read aaiglong output: " + e.to_string())
  }
  inspect(body.contains("ncols "), content="true")
}

///|
test "run_cli supports -grib_ieee split outputs" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let base = "target/cmd_main_grib_ieee_test"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_ieee", base,
  ])
  inspect(exit, content="0")
  let grb = @fs.read_file_to_bytes(base + ".grb") catch {
    e => fail("failed to read .grb: " + e.to_string())
  }
  let head = @fs.read_file_to_bytes(base + ".head") catch {
    e => fail("failed to read .head: " + e.to_string())
  }
  let tail = @fs.read_file_to_bytes(base + ".tail") catch {
    e => fail("failed to read .tail: " + e.to_string())
  }
  let h = @fs.read_file_to_string(base + ".h") catch {
    e => fail("failed to read .h: " + e.to_string())
  }
  inspect(grb.length() > 16, content="true")
  inspect(head.length() > 16, content="true")
  inspect(tail.length(), content="4")
  inspect(h.contains("GRIB_IEEE_RECORDS"), content="true")
  inspect(grb[0].to_int(), content="71")
  inspect(grb[1].to_int(), content="82")
  inspect(grb[2].to_int(), content="73")
  inspect(grb[3].to_int(), content="66")
}

///|
test "run_cli supports -ijbox text mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_ijbox_text_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-ijbox", "1:2:1", "1:2:1", out, "text",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read ijbox text output: " + e.to_string())
  }
  inspect(body.contains("1:1:1:"), content="true")
}

///|
test "run_cli supports -ijbox spread mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_ijbox_spread_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-ijbox", "1:3:1", "1:2:1", out, "spread",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read ijbox spread output: " + e.to_string())
  }
  inspect(body.contains(","), content="true")
}

///|
test "run_cli supports -ijbox bin mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_ijbox_bin_test.bin"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-ijbox", "1:2:1", "1:2:1", out, "bin",
  ])
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read ijbox bin output: " + e.to_string())
  }
  inspect(bytes.length(), content="16")
}

///|
test "run_cli supports -version without input file" {
  let exit = run_cli(["grib2_mbt", "-version"])
  inspect(exit, content="0")
}

///|
test "run_cli supports -colon replacement in inventory output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_colon_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-colon", "|", "-inv", out, "-s",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read colon output: " + e.to_string())
  }
  inspect(body.contains("|"), content="true")
  inspect(body.contains(":"), content="false")
}

///|
test "split_line_by_columns splits by requested width" {
  let chunks = split_line_by_columns("abcdefghij", 4)
  inspect(chunks.length(), content="3")
  inspect(chunks[0], content="abcd")
  inspect(chunks[1], content="efgh")
  inspect(chunks[2], content="ij")
}

///|
test "run_cli supports -one_line inventory output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_one_line_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:2:1", "-one_line", "-inv", out, "-s",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read one_line output: " + e.to_string())
  }
  inspect(line_count(out), content="1")
  inspect(body.contains("1:"), content="true")
  inspect(body.contains("2:"), content="true")
}

///|
test "run_cli supports -print_out and -last filter" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_print_out_last_test.txt"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:3:1", "-last", "-print_out", out, "-print",
  ]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines.length(), content="1")
  inspect(lines[0].has_prefix("3:"), content="true")
}

///|
test "run_cli supports -s_out alias" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_s_out_test.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-s_out", out])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body.contains("1:"), content="true")
}

///|
test "parse_cli_invocation accepts nl_out option" {
  let parsed = match parse_cli_invocation(["-nl_out", "target/nl.txt", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, action) = parsed
  inspect(init.nl_out_path, content="Some(\"target/nl.txt\")")
  inspect(init.print_out_text, content="None")
  inspect(init.print_out_path, content="None")
  let is_short = match action {
    Inventory(InventoryShort) => true
    _ => false
  }
  inspect(is_short, content="true")
}

///|
test "run_cli supports -nl_out side effect file" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_nl_out_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-nl_out", out, "-s",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body, content="\n")
}

///|
test "parse_cli_invocation accepts last/last0 with output path" {
  let p1 = match
    parse_cli_invocation(["-for_n", "1:5:1", "-last", "target/a.txt", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i1, _) = p1
  inspect(i1.select_last, content="true")
  inspect(i1.select_last0, content="false")
  inspect(i1.inventory_path, content="Some(\"target/a.txt\")")
  let p2 = match parse_cli_invocation(["-last0", "target/b.txt", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (i2, _) = p2
  inspect(i2.select_last, content="false")
  inspect(i2.select_last0, content="true")
  inspect(i2.inventory_path, content="Some(\"target/b.txt\")")
}

///|
test "parse_cli_invocation accepts print_out string + path form" {
  let parsed = match
    parse_cli_invocation(["-print_out", "hello", "target/p.txt", "-s"]) {
    Ok(v) => v
    Err(e) => fail(e)
  }
  let (init, _) = parsed
  inspect(init.print_out_text, content="Some(\"hello\")")
  inspect(init.print_out_path, content="Some(\"target/p.txt\")")
}

///|
test "run_cli supports -print_out string + path side effect" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_print_out_xy_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-print_out", "hello", out, "-s",
  ])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body, content="hello\n")
}

///|
test "run_cli supports -inv_f77 path output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_inv_f77_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-inv_f77", "bin", "80", out, "-s",
  ])
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output bytes: " + e.to_string())
  }
  inspect(bytes.length(), content="88")
  inspect(bytes[0].to_int(), content="80")
  inspect(bytes[1].to_int(), content="0")
  inspect(bytes[2].to_int(), content="0")
  inspect(bytes[3].to_int(), content="0")
  inspect(bytes[84].to_int(), content="80")
  inspect(bytes[85].to_int(), content="0")
  inspect(bytes[86].to_int(), content="0")
  inspect(bytes[87].to_int(), content="0")
}

///|
test "run_cli supports -inv_f77 ieee marker endianness" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_inv_f77_ieee_test.txt"
  let exit = run_cli([
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-inv_f77", "ieee", "80", out, "-s",
  ])
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output bytes: " + e.to_string())
  }
  inspect(bytes.length(), content="88")
  inspect(bytes[0].to_int(), content="0")
  inspect(bytes[1].to_int(), content="0")
  inspect(bytes[2].to_int(), content="0")
  inspect(bytes[3].to_int(), content="80")
  inspect(bytes[84].to_int(), content="0")
  inspect(bytes[85].to_int(), content="0")
  inspect(bytes[86].to_int(), content="0")
  inspect(bytes[87].to_int(), content="80")
}

///|
test "parse_cli_invocation validates inv_f77 arguments" {
  let bad_mode = parse_cli_invocation(["-inv_f77", "txt", "80", "x", "-s"])
  let bad_width = parse_cli_invocation(["-inv_f77", "bin", "x", "y", "-s"])
  let bad_width2 = parse_cli_invocation(["-inv_f77", "ieee", "0", "y", "-s"])
  let ok_mode = match bad_mode {
    Err("-(dummy)") => false
    Err(msg) => msg.contains("mode")
    Ok(_) => false
  }
  let ok_width = match bad_width {
    Err(msg) => msg.contains("width")
    Ok(_) => false
  }
  let ok_width2 = match bad_width2 {
    Err(msg) => msg.contains("width")
    Ok(_) => false
  }
  inspect(ok_mode, content="true")
  inspect(ok_width, content="true")
  inspect(ok_width2, content="true")
}

///|
test "run_cli supports -grib output with byte-identical copy" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_test.grib2"
  let args = ["grib2_mbt", fixture, "-grib", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let src = @fs.read_file_to_bytes(fixture) catch {
    e => fail("failed to read source: " + e.to_string())
  }
  let dst = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(dst == src, content="true")
}

///|
test "run_cli applies -for_n filter to -grib output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_grib_for_n_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-grib", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let src = @fs.read_file_to_bytes(fixture) catch {
    e => fail("failed to read source: " + e.to_string())
  }
  let dst = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(dst.length() > 0, content="true")
  inspect(dst.length() < src.length(), content="true")
  let magic = dst.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -tosubmsg alias output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_tosubmsg_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-tosubmsg", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read tosubmsg output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -ijsmall_grib full-domain limited mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_ijsmall_grib_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-ijsmall_grib", "1:360:1", "1:181:1",
    out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read ijsmall_grib output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -small_grib full-domain limited mode" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_small_grib_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-small_grib", "0:359", "-90:90", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read small_grib output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -lola identity remap mode=grib" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_lola_grib_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-lola", "0:360:1", "-90:181:1", out,
    "grib",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read lola output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -grib_out_irr limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_out_irr_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr", "all", out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read grib_out_irr output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -grib_out_irr2 limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_out_irr2_test.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr2", "10", "1", "0", "00000000-0000-0000-0000-000000000000",
    out,
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read grib_out_irr2 output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -new_grid_order limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out1 = "target/cmd_main_new_grid_order_out1.grib2"
  let out2 = "target/cmd_main_new_grid_order_out2.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-new_grid_order", out1, out2,
  ]
  inspect(run_cli(args), content="0")
  let bytes1 = @fs.read_file_to_bytes(out1) catch {
    e => fail("failed to read new_grid_order out1: " + e.to_string())
  }
  let bytes2 = @fs.read_file_to_bytes(out2) catch {
    e => fail("failed to read new_grid_order out2: " + e.to_string())
  }
  inspect(bytes1.length() > 16, content="true")
  inspect(bytes2.length(), content="0")
  let magic = bytes1.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli validates -grib_out_irr selector" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_grib_out_irr_bad.grib2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-grib_out_irr", "bad", out,
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -submsg_uv limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_submsg_uv_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-submsg_uv", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read submsg_uv output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -ncep_uv limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_ncep_uv_test.grib2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-ncep_uv", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read ncep_uv output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -reduced_gaussian_grid limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_reduced_gaussian_grid_test.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-reduced_gaussian_grid", out, "-1",
    "neighbor",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read reduced_gaussian_grid output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli validates -reduced_gaussian_grid y argument" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_reduced_gaussian_grid_bad_y.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-reduced_gaussian_grid", out, "0",
    "neighbor",
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -ncep_norm limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_ncep_norm_test.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-ncep_norm", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read ncep_norm output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -merge_fcst limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_merge_fcst_test.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-merge_fcst", "0", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read merge_fcst output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -unmerge_fcst limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_unmerge_fcst_test.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-unmerge_fcst", out, "0hr", "0",
  ]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read unmerge_fcst output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli validates -unmerge_fcst time argument" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_unmerge_fcst_bad_time_test.grb2"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-unmerge_fcst", out, "0", "0",
  ]
  inspect(run_cli(args), content="2")
}

///|
test "run_cli supports -wind_speed limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_speed_test.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-wind_speed", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_speed output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -wind_dir limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_dir_test.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-wind_dir", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_dir output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -wind_uv limited compatibility output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_wind_uv_test.grb2"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-wind_uv", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_uv output: " + e.to_string())
  }
  inspect(bytes.length(), content="0")
}

///|
test "run_cli supports -wind_uv derived output from speed/dir input" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let speed_dir = "target/cmd_main_wind_spddir_test.grb2"
  let uv_out = "target/cmd_main_wind_uv_from_spddir_test.grb2"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "11:12", "-wind_speed", speed_dir]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "11:12", "-wind_dir", speed_dir,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", speed_dir, "-for_n", "1:2", "-wind_uv", uv_out]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(uv_out) catch {
    e => fail("failed to read wind_uv output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  inspect(count_grib_magic(bytes), content="2")
}

///|
test "run_cli supports -wind_speed on complex packing output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_wind_speed_complex_test.grb2"
  let args = ["grib2_mbt", fixture, "-wind_speed", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_speed output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -wind_dir on complex packing output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_wind_dir_complex_test.grb2"
  let args = ["grib2_mbt", fixture, "-wind_dir", out]
  inspect(run_cli(args), content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read wind_dir output: " + e.to_string())
  }
  inspect(bytes.length() > 16, content="true")
  let magic = bytes.sub(start=0, end=4).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -write_sec 0 output begins with GRIB magic" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_sec0_test.bin"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-write_sec", "0", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(bytes.length(), content="24")
  inspect(bytes[0].to_uint().reinterpret_as_int().to_string(), content="16")
  let magic = bytes.sub(start=4, end=8).to_bytes().to_string()
  inspect(magic, content="b\"GRIB\"")
}

///|
test "run_cli supports -write_sec 8 output with 7777 marker" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_sec8_test.bin"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-write_sec", "8", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let bytes = @fs.read_file_to_bytes(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(bytes.length(), content="12")
  inspect(bytes[0].to_uint().reinterpret_as_int().to_string(), content="4")
  let marker = bytes.sub(start=4, end=8).to_bytes().to_string()
  inspect(marker, content="b\"7777\"")
}

///|
test "run_cli supports -gribtable_used output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_gribtable_used_test.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-gribtable_used", out])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  inspect(body.contains("# disc:cat:param:name"), content="true")
  inspect(body.contains(":"), content="true")
}

///|
test "run_cli applies -for_n to -gribtable_used output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out_all = "target/cmd_main_gribtable_used_all.txt"
  let out_one = "target/cmd_main_gribtable_used_one.txt"
  inspect(
    run_cli(["grib2_mbt", fixture, "-gribtable_used", out_all]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-gribtable_used", out_one,
    ]),
    content="0",
  )
  let all_body = @fs.read_file_to_string(out_all) catch {
    e => fail("failed to read all output: " + e.to_string())
  }
  let one_body = @fs.read_file_to_string(out_one) catch {
    e => fail("failed to read one output: " + e.to_string())
  }
  let all_lines = line_count(out_all)
  let one_lines = line_count(out_one)
  inspect(all_body.contains("# disc:cat:param:name"), content="true")
  inspect(one_body.contains("# disc:cat:param:name"), content="true")
  inspect(one_lines >= 2, content="true")
  inspect(one_lines <= all_lines, content="true")
}

///|
test "run_cli gribtable_used append does not duplicate header" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_gribtable_used_append.txt"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-gribtable_used", out]),
    content="0",
  )
  let first = @fs.read_file_to_string(out) catch {
    e => fail("failed to read first output: " + e.to_string())
  }
  let first_lines = line_count(out)
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-gribtable_used", out,
    ]),
    content="0",
  )
  let second = @fs.read_file_to_string(out) catch {
    e => fail("failed to read second output: " + e.to_string())
  }
  let second_lines = line_count(out)
  let mut header_count = 0
  for line in second.split("\n") {
    if line.to_string() == "# disc:cat:param:name" {
      header_count += 1
    }
  }
  inspect(first.contains("# disc:cat:param:name"), content="true")
  inspect(second_lines >= first_lines, content="true")
  inspect(header_count, content="1")
}

///|
test "run_cli supports -gridout output" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out = "target/cmd_main_gridout_test.txt"
  let exit = run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-gridout", out])
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines.length() > 1, content="true")
  inspect(lines[0], content="i j lat lon")
}

///|
test "run_cli supports -export_lonlat output with expected pair count" {
  let fixture = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  let out_bin = "target/cmd_main_export_lonlat_test.bin"
  let out_txt = "target/cmd_main_export_lonlat_gridout.txt"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-export_lonlat", out_bin]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-gridout", out_txt]),
    content="0",
  )
  let bytes = @fs.read_file_to_bytes(out_bin) catch {
    e => fail("failed to read lonlat output: " + e.to_string())
  }
  let points = line_count(out_txt) - 1
  inspect(points > 0, content="true")
  inspect(bytes.length(), content=(points * 8).to_string())
}

///|
test "run_cli supports -csv output with init record filtering" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_csv_test.csv"
  let args = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-csv", out]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines.length() > 1, content="true")
  inspect(lines[0], content="record,point,value")
  for i = 1; i < lines.length(); i = i + 1 {
    let row = lines[i]
    inspect(row.has_prefix("1,"), content="true")
  }
}

///|
test "run_cli supports -csv -no_header -text_fmt" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_csv_no_header_test.csv"
  let args = [
    "grib2_mbt", fixture, "-for_n", "1:1:1", "-no_header", "-text_fmt", "%.2f", "-csv",
    out,
  ]
  let exit = run_cli(args)
  inspect(exit, content="0")
  let body = @fs.read_file_to_string(out) catch {
    e => fail("failed to read output: " + e.to_string())
  }
  let lines : Array[String] = []
  for line in body.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      lines.push(s)
    }
  }
  inspect(lines.length() > 0, content="true")
  inspect(lines[0] == "record,point,value", content="false")
  inspect(lines[0].has_prefix("1,1,"), content="true")
}

///|
test "run_cli supports -bin and -ieee outputs with expected size" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out_bin = "target/cmd_main_bin_test.bin"
  let out_ieee = "target/cmd_main_ieee_test.bin"
  let args_bin = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-bin", out_bin]
  let args_ieee = ["grib2_mbt", fixture, "-for_n", "1:1:1", "-ieee", out_ieee]
  inspect(run_cli(args_bin), content="0")
  inspect(run_cli(args_ieee), content="0")
  let bin_bytes = @fs.read_file_to_bytes(out_bin) catch {
    e => fail("failed to read bin output: " + e.to_string())
  }
  let ieee_bytes = @fs.read_file_to_bytes(out_ieee) catch {
    e => fail("failed to read ieee output: " + e.to_string())
  }
  inspect(bin_bytes.length(), content="260648")
  inspect(ieee_bytes.length(), content="260648")
}

///|
test "run_cli supports append mode for csv output" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out = "target/cmd_main_csv_append_test.csv"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-csv", out]),
    content="0",
  )
  let first_lines = line_count(out)
  inspect(
    run_cli(["grib2_mbt", fixture, "-append", "-for_n", "2:2:1", "-csv", out]),
    content="0",
  )
  let second_lines = line_count(out)
  inspect(second_lines > first_lines, content="true")
}

///|
test "run_cli supports text_fmt scientific styles" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let out_e = "target/cmd_main_csv_scientific_e.csv"
  let out_g = "target/cmd_main_csv_scientific_g.csv"
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-no_header", "-text_fmt", "%.3e",
      "-csv", out_e,
    ]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-no_header", "-text_fmt", "%.4G",
      "-csv", out_g,
    ]),
    content="0",
  )
  let body_e = @fs.read_file_to_string(out_e) catch {
    e => fail("failed to read e output: " + e.to_string())
  }
  let body_g = @fs.read_file_to_string(out_g) catch {
    e => fail("failed to read g output: " + e.to_string())
  }
  let mut first_e = ""
  for line in body_e.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      first_e = s
      break
    }
  }
  let mut first_g = ""
  for line in body_g.split("\n") {
    let s = line.to_string()
    if s.length() > 0 {
      first_g = s
      break
    }
  }
  inspect(first_e.contains("e"), content="true")
  inspect(first_g.contains("E") || first_g.contains("."), content="true")
}

///|
test "run_cli supports endian switches for bin/ieee" {
  let fixture = "fixtures/grib2_noaa/gfs.t00z.pgrb2.1p00.f000.grib2"
  let bin_l = "target/cmd_main_bin_l.bin"
  let bin_b = "target/cmd_main_bin_b.bin"
  let ieee_d = "target/cmd_main_ieee_d.bin"
  let ieee_l = "target/cmd_main_ieee_l.bin"
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-bin", bin_l]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-big_endian", "-bin", bin_b,
    ]),
    content="0",
  )
  inspect(
    run_cli(["grib2_mbt", fixture, "-for_n", "1:1:1", "-ieee", ieee_d]),
    content="0",
  )
  inspect(
    run_cli([
      "grib2_mbt", fixture, "-for_n", "1:1:1", "-little_endian", "-ieee", ieee_l,
    ]),
    content="0",
  )
  let a = @fs.read_file_to_bytes(bin_l) catch {
    e => fail("failed to read bin_l: " + e.to_string())
  }
  let b = @fs.read_file_to_bytes(bin_b) catch {
    e => fail("failed to read bin_b: " + e.to_string())
  }
  let c = @fs.read_file_to_bytes(ieee_d) catch {
    e => fail("failed to read ieee_d: " + e.to_string())
  }
  let d = @fs.read_file_to_bytes(ieee_l) catch {
    e => fail("failed to read ieee_l: " + e.to_string())
  }
  inspect(a.length() >= 4, content="true")
  inspect(b.length() >= 4, content="true")
  inspect(c.length() >= 4, content="true")
  inspect(d.length() >= 4, content="true")
  let a0 = [a[0], a[1], a[2], a[3]]
  let b0 = [b[0], b[1], b[2], b[3]]
  let c0 = [c[0], c[1], c[2], c[3]]
  let d0 = [d[0], d[1], d[2], d[3]]
  inspect(a0 == b0, content="false")
  inspect(b0 == c0, content="true")
  inspect(a0 == d0, content="true")
}
