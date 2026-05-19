///|
/// Render the wgrib2 `level` column from the pair of fixed-surface descriptors
/// encoded in Section 4 (`l1t`/`l1sf`/`l1v` for the first surface and
/// `l2t`/`l2sf`/`l2v` for the second). Code Table 4.5 governs the surface
/// types; the supported subset matches wgrib2 v3.1.3 verbatim, with unknown
/// pairs falling back to `typeN` / `typeN-typeM` so callers still get a
/// deterministic identifier.
pub fn decode_level_name(
  l1t : Int,
  l1sf : Int,
  l1v : Int,
  l2t : Int,
  l2sf : Int,
  l2v : Int,
) -> Grib2NameLookup {
  if l1t == 1 {
    return NameKnown("surface")
  }
  if l1t == 101 {
    return NameKnown("mean sea level")
  }
  if l1t == 241 && l1sf == 0 && l2t == 255 {
    return NameKnown(l1v.to_string() + " in sequence")
  }
  if l1t == 100 && l2t == 255 {
    let scale_magnitude = l1sf & 0x7F
    let scale = if (l1sf & 0x80) != 0 {
      -scale_magnitude
    } else {
      scale_magnitude
    }
    return NameKnown(format_scaled_decimal(l1v, scale + 2) + " mb")
  }
  if l1t == 103 && l2t == 255 {
    return NameKnown(l1v.to_string() + " m above ground")
  }
  if l1t == 102 && l2t == 255 {
    return NameKnown(l1v.to_string() + " m above mean sea level")
  }
  if l1t == 106 && l1sf == 2 && l2t == 106 && l2sf == 2 {
    let top_x10 = l1v / 10
    let bot_x10 = l2v / 10
    return NameKnown(
      format_decimal_tenths(top_x10) +
      "-" +
      format_decimal_tenths(bot_x10) +
      " m below ground",
    )
  }
  if l1t == 108 && l1sf == 0 && l2t == 108 && l2sf == 0 {
    return NameKnown(
      (l1v / 100).to_string() +
      "-" +
      (l2v / 100).to_string() +
      " mb above ground",
    )
  }
  if l1t == 104 && l2t == 104 {
    return NameKnown(
      format_scaled_decimal(l1v, l1sf) +
      "-" +
      format_scaled_decimal(l2v, l2sf) +
      " sigma layer",
    )
  }
  if l1t == 104 && l2t == 255 {
    return NameKnown(format_scaled_decimal(l1v, l1sf) + " sigma level")
  }
  if l1t == 109 && l1sf == 9 && l2t == 255 {
    let magnitude = l1v & 0x7fffffff
    let pv_scaled = if l1v < 0 { -magnitude } else { magnitude }
    let pv_label = match pv_scaled {
      500 => "5e-07"
      1000 => "1e-06"
      1500 => "1.5e-06"
      2000 => "2e-06"
      -500 => "-5e-07"
      -1000 => "-1e-06"
      -1500 => "-1.5e-06"
      -2000 => "-2e-06"
      _ => pv_scaled.to_string() + "e-09"
    }
    return NameKnown("PV=" + pv_label + " (Km^2/kg/s) surface")
  }
  // Type 105: Hybrid level
  if l1t == 105 && l2t == 255 {
    return NameKnown(l1v.to_string() + " hybrid level")
  }
  // Type 10: Entire atmosphere (considered as a single layer)
  if l1t == 10 && l2t == 255 {
    return NameKnown("entire atmosphere")
  }
  // Type 8: Nominal top of atmosphere
  if l1t == 8 && l2t == 255 {
    return NameKnown("top of atmosphere")
  }
  // Type 200: Entire atmosphere (considered as a single layer)
  if l1t == 200 && l2t == 255 {
    return NameKnown("entire atmosphere (considered as a single layer)")
  }
  // Type 214/224/234: cloud layer categories
  if l1t == 214 && l2t == 255 {
    return NameKnown("low cloud layer")
  }
  if l1t == 224 && l2t == 255 {
    return NameKnown("middle cloud layer")
  }
  if l1t == 234 && l2t == 255 {
    return NameKnown("high cloud layer")
  }
  // Type 215: cloud ceiling
  if l1t == 215 && l2t == 255 {
    return NameKnown("cloud ceiling")
  }
  // Type 220: Planetary boundary layer
  if l1t == 220 && l2t == 255 {
    return NameKnown("planetary boundary layer")
  }
  // Type 204: Highest tropospheric freezing level
  if l1t == 204 && l2t == 255 {
    return NameKnown("highest tropospheric freezing level")
  }
  // Type 2: Cloud base level
  if l1t == 2 && l2t == 255 {
    return NameKnown("cloud base")
  }
  // Type 3: Cloud top level
  if l1t == 3 && l2t == 255 {
    return NameKnown("cloud top")
  }
  // Type 6: Maximum wind level
  if l1t == 6 && l2t == 255 {
    return NameKnown("max wind")
  }
  // Type 7: Tropopause
  if l1t == 7 && l2t == 255 {
    return NameKnown("tropopause")
  }
  // Type 4: Level of 0°C isotherm
  if l1t == 4 && l2t == 255 {
    return NameKnown("0C isotherm")
  }
  if l1t == 103 && l2t == 103 {
    return NameKnown(
      l1v.to_string() + "-" + l2v.to_string() + " m above ground",
    )
  }
  if l2t == 255 {
    return NameUnknown("type" + l1t.to_string())
  }
  NameUnknown("type" + l1t.to_string() + "-type" + l2t.to_string())
}

///|
/// Format the `tail` field of `Grib2RecordMeta` from the GRIB2 time-unit code
/// and forecast offset. Mirrors wgrib2's `anl` / `N hour fcst` / `N day fcst`
/// shorthand.
fn format_tail(time_unit : Int, forecast_time : Int) -> String {
  if time_unit == 1 && forecast_time == 0 {
    "anl"
  } else if time_unit == 1 {
    forecast_time.to_string() + " hour fcst"
  } else if time_unit == 2 {
    forecast_time.to_string() + " day fcst"
  } else {
    "fcst"
  }
}
