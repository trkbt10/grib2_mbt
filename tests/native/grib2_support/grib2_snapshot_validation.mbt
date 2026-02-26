///|
fn grib2_snapshot_lines_read(path : String) -> Result[Array[String], String] {
  try @fs.read_file_to_string(path) catch {
    error => Err("failed to read snapshot " + path + ": " + error.to_string())
  } noraise {
    content => {
      let lines : Array[String] = []
      for line in content.split("\n") {
        let text = line.to_string()
        if text != "" {
          lines.push(text)
        }
      }
      Ok(lines)
    }
  }
}

///|
fn grib2_snapshot_compare(
  name : String,
  actual : Array[String],
  snapshot_path : String,
) -> Result[Unit, String] {
  let expected = match grib2_snapshot_lines_read(snapshot_path) {
    Ok(expected) => expected
    Err(error) => return Err(error)
  }
  let min_len = if actual.length() < expected.length() {
    actual.length()
  } else {
    expected.length()
  }
  loop 0 {
    index => {
      if index == min_len {
        if actual.length() != expected.length() {
          return Err(
            name +
            ": line count mismatch: actual=" +
            actual.length().to_string() +
            ", expected=" +
            expected.length().to_string(),
          )
        }
        return Ok(())
      }
      if actual[index] != expected[index] {
        return Err(
          name +
          ": first mismatch at line " +
          (index + 1).to_string() +
          ", actual=\"" +
          actual[index] +
          "\", expected=\"" +
          expected[index] +
          "\"",
        )
      }
      continue index + 1
    }
  }
}

///|
priv enum Grib2SnapshotView {
  SnapshotDefault
  SnapshotS
  SnapshotSec0
  SnapshotSec3
  SnapshotSec4
  SnapshotSec5
  SnapshotSec6
  SnapshotSecLen
  SnapshotN
  SnapshotRange
  SnapshotVar
  SnapshotLev
  SnapshotFtime
  SnapshotGrid
  SnapshotPdt
  SnapshotProcess
  SnapshotEns
  SnapshotProb
  SnapshotDisc
  SnapshotCenter
  SnapshotSubcenter
  SnapshotPacking
  SnapshotBitmap
  SnapshotNxny
  SnapshotNpts
  SnapshotVarLev
}

///|
fn grib2_snapshot_view_name(view : Grib2SnapshotView) -> String {
  match view {
    SnapshotDefault => "default"
    SnapshotS => "s"
    SnapshotSec0 => "Sec0"
    SnapshotSec3 => "Sec3"
    SnapshotSec4 => "Sec4"
    SnapshotSec5 => "Sec5"
    SnapshotSec6 => "Sec6"
    SnapshotSecLen => "Sec_len"
    SnapshotN => "n"
    SnapshotRange => "range"
    SnapshotVar => "var"
    SnapshotLev => "lev"
    SnapshotFtime => "ftime"
    SnapshotGrid => "grid"
    SnapshotPdt => "pdt"
    SnapshotProcess => "process"
    SnapshotEns => "ens"
    SnapshotProb => "prob"
    SnapshotDisc => "disc"
    SnapshotCenter => "center"
    SnapshotSubcenter => "subcenter"
    SnapshotPacking => "packing"
    SnapshotBitmap => "bitmap"
    SnapshotNxny => "nxny"
    SnapshotNpts => "npts"
    SnapshotVarLev => "var_lev"
  }
}

///|
fn grib2_snapshot_view_lines(
  context : @lib.Grib2FileContext,
  view : Grib2SnapshotView,
) -> Array[String] {
  match view {
    SnapshotDefault => @lib.wgrib2_default_lines(context)
    SnapshotS => @lib.wgrib2_s_lines(context)
    SnapshotSec0 => @lib.wgrib2_sec0_lines(context)
    SnapshotSec3 => @lib.wgrib2_sec3_lines(context)
    SnapshotSec4 => @lib.wgrib2_sec4_lines(context)
    SnapshotSec5 => @lib.wgrib2_sec5_lines(context)
    SnapshotSec6 => @lib.wgrib2_sec6_lines(context)
    SnapshotSecLen => @lib.wgrib2_sec_len_lines(context)
    SnapshotN => @lib.wgrib2_n_lines(context)
    SnapshotRange => @lib.wgrib2_range_lines(context)
    SnapshotVar => @lib.wgrib2_var_lines(context)
    SnapshotLev => @lib.wgrib2_lev_lines(context)
    SnapshotFtime => @lib.wgrib2_ftime_lines(context)
    SnapshotGrid => @lib.wgrib2_grid_lines(context)
    SnapshotPdt => @lib.wgrib2_pdt_lines(context)
    SnapshotProcess => @lib.wgrib2_process_lines(context)
    SnapshotEns => @lib.wgrib2_ens_lines(context)
    SnapshotProb => @lib.wgrib2_prob_lines(context)
    SnapshotDisc => @lib.wgrib2_disc_lines(context)
    SnapshotCenter => @lib.wgrib2_center_lines(context)
    SnapshotSubcenter => @lib.wgrib2_subcenter_lines(context)
    SnapshotPacking => @lib.wgrib2_packing_lines(context)
    SnapshotBitmap => @lib.wgrib2_bitmap_lines(context)
    SnapshotNxny => @lib.wgrib2_nxny_lines(context)
    SnapshotNpts => @lib.wgrib2_npts_lines(context)
    SnapshotVarLev => @lib.wgrib2_var_lev_lines(context)
  }
}

///|
pub fn grib2_verify_wgrib2_snapshots(
  fixture_path : String,
  snapshot_dir : String,
) -> Result[Unit, String] {
  let context = match grib2_fixture_context_parse(fixture_path) {
    Ok(context) => context
    Err(error) => return Err(error)
  }
  let views : Array[Grib2SnapshotView] = [
    SnapshotDefault,
    SnapshotS,
    SnapshotSec0,
    SnapshotSec3,
    SnapshotSec4,
    SnapshotSec5,
    SnapshotSec6,
    SnapshotSecLen,
    SnapshotN,
    SnapshotRange,
    SnapshotVar,
    SnapshotLev,
    SnapshotFtime,
    SnapshotGrid,
    SnapshotPdt,
    SnapshotProcess,
    SnapshotEns,
    SnapshotProb,
    SnapshotDisc,
    SnapshotCenter,
    SnapshotSubcenter,
    SnapshotPacking,
    SnapshotBitmap,
    SnapshotNxny,
    SnapshotNpts,
    SnapshotVarLev,
  ]
  for view in views {
    let suffix = grib2_snapshot_view_name(view)
    let actual = grib2_snapshot_view_lines(context, view)
    match
      grib2_snapshot_compare(
        fixture_path + " " + suffix,
        actual,
        snapshot_dir + "/" + suffix + ".txt",
      ) {
      Ok(_) => ()
      Err(error) => return Err(error)
    }
  }
  Ok(())
}
