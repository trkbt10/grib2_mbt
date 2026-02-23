///|
fn format_prefix(meta : Grib2RecordMeta) -> String {
  meta.record_id + ":" + meta.message_offset.to_string() + ":"
}

///|
fn pad6(value : Int) -> String {
  if value >= 100000 {
    value.to_string()
  } else if value >= 10000 {
    "0" + value.to_string()
  } else if value >= 1000 {
    "00" + value.to_string()
  } else if value >= 100 {
    "000" + value.to_string()
  } else if value >= 10 {
    "0000" + value.to_string()
  } else {
    "00000" + value.to_string()
  }
}

///|
fn format_microdegrees(value : Int) -> String {
  let sign = if value < 0 { "-" } else { "" }
  let absolute = if value < 0 { -value } else { value }
  let integer = absolute / 1000000
  let fraction = absolute % 1000000
  sign + integer.to_string() + "." + pad6(fraction)
}

///|
fn process_label(value : Int) -> String {
  match value {
    0 => "anl"
    1 => "init"
    2 => "fcst"
    3 => "bias-corr fcst"
    4 => "ens fcst"
    5 => "prob fcst"
    6 => "fcst err"
    7 => "anl err"
    8 => "obs"
    9 => "clim"
    10 => "prob wt fcst"
    11 => "bias-corr ens fcst"
    12 => "post-proc anl"
    13 => "post-proc fcst"
    14 => "nowcast"
    15 => "hindcast"
    16 => "physical retrieval"
    17 => "regression analysis"
    18 => "difference between two forecasts"
    19 => "first guess"
    20 => "analysis increment"
    21 => "initialization increment for analysis"
    255 => "missing"
    _ =>
      if value >= 192 && value <= 254 {
        "undefined"
      } else {
        ""
      }
  }
}

///|
fn discipline_label(value : Int) -> String {
  match value {
    0 => "Meteorological products"
    1 => "Hydrological products"
    2 => "Land surface products"
    3 => "Satellite remote sensing products (formerly Space products)"
    4 => "Space weather products"
    10 => "Oceanographic products"
    20 => "Health and socioeconomic impacts"
    255 => "Missing"
    _ => ""
  }
}

///|
fn packing_label(meta : Grib2RecordMeta) -> String {
  let template_id = meta.section5_template.id()
  match template_id {
    0 => "Grid point data - simple packing,s"
    2 =>
      if meta.section6_bitmap_indicator == 0 {
        "Grid point data - complex packing,c1b"
      } else {
        "Grid point data - complex packing,c1"
      }
    3 =>
      if meta.section6_bitmap_indicator == 0 {
        "Grid point data - complex packing and spatial differencing,c3b"
      } else {
        "Grid point data - complex packing and spatial differencing,c3"
      }
    4 => "Grid point data - IEEE floating point data,_"
    40 => "Grid point data - JPEG 2000 code stream format,j"
    41 => "Grid point data - Portable Network Graphics (PNG),_"
    50 => "Spectral data - simple packing,_"
    51 => "Spherical harmonics data - complex packing,_"
    61 => "Grid point data - simple packing with logarithm pre-processing,_"
    200 => "Run length packing with level values,_"
    _ => "unknown packing,_"
  }
}

///|
fn ens_label(meta : Grib2RecordMeta) -> String {
  let template_id = meta.section4_template.id()
  if template_id == 1 || template_id == 11 {
    let ens_type = meta.section4_ens_type
    let pert = meta.section4_ens_perturbation_number
    match ens_type {
      0 => "ENS=hi-res ctl"
      1 => "ENS=low-res ctl"
      2 => "ENS=-" + pert.to_string()
      3 => "ENS=+" + pert.to_string()
      4 => "MM-ENS=" + pert.to_string()
      _ =>
        if ens_type >= 0 {
          "ENS=? table4.6=" + ens_type.to_string() + " pert=" + pert.to_string()
        } else {
          ""
        }
    }
  } else if template_id == 2 || template_id == 12 {
    match meta.section4_ens_type {
      0 => "ens mean"
      1 => "wt ens mean"
      2 => "ens std dev"
      3 => "normalized ens std dev"
      4 => "ens spread"
      5 => "ens large anom index"
      6 => "unwt ens mean"
      7 => "25%-75% range"
      8 => "min all members"
      9 => "max all members"
      _ =>
        if meta.section4_ens_type >= 0 {
          "unknown derived fcst"
        } else {
          ""
        }
    }
  } else {
    ""
  }
}

///|
fn prob_scale_divisor(scale_factor : Int) -> Int {
  if scale_factor <= 0 {
    return 1
  }
  let mut divisor = 1
  for _ in 0..<scale_factor {
    divisor *= 10
  }
  divisor
}

///|
fn prob_scaled_value(scale_factor : Int, raw_value : Int) -> String {
  if scale_factor <= 0 {
    let mut multiplier = 1
    for _ in 0..<(-scale_factor) {
      multiplier *= 10
    }
    return (raw_value * multiplier).to_string()
  }
  let sign = if raw_value < 0 { "-" } else { "" }
  let absolute = if raw_value < 0 { -raw_value } else { raw_value }
  let divisor = prob_scale_divisor(scale_factor)
  let integer = absolute / divisor
  let fraction = absolute % divisor
  if fraction == 0 {
    sign + integer.to_string()
  } else {
    let mut frac = fraction.to_string()
    let mut pad = scale_factor - frac.length()
    while pad > 0 {
      frac = "0" + frac
      pad -= 1
    }
    sign + integer.to_string() + "." + frac
  }
}

///|
fn prob_label(meta : Grib2RecordMeta) -> String {
  let template_id = meta.section4_template.id()
  if template_id != 5 && template_id != 9 {
    return ""
  }
  let prob_type = meta.section4_prob_type
  if prob_type < 0 {
    return ""
  }
  let lower = prob_scaled_value(
    meta.section4_prob_lower_scale_factor,
    meta.section4_prob_lower_value,
  )
  let upper = prob_scaled_value(
    meta.section4_prob_upper_scale_factor,
    meta.section4_prob_upper_value,
  )
  let head = match prob_type {
    0 => "prob <" + lower
    1 => "prob >" + upper
    2 => "prob >=" + lower + " <" + upper
    3 => "prob >" + lower
    4 => "prob <" + upper
    5 => "prob =" + lower
    6 => "prob above normal"
    7 => "prob near normal"
    8 => "prob below normal"
    _ => "prob ?? (code table 4.9=" + prob_type.to_string() + ")"
  }
  if meta.section4_prob_forecast_index >= 0 &&
    meta.section4_prob_total_forecasts >= 0 {
    head +
    ":prob fcst " +
    meta.section4_prob_forecast_index.to_string() +
    "/" +
    meta.section4_prob_total_forecasts.to_string()
  } else {
    head
  }
}

///|
pub fn wgrib2_default_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "d=" +
      meta.reference_time +
      ":" +
      meta.parameter_name.display() +
      ":" +
      meta.level_name.display() +
      ":" +
      meta.tail +
      ":",
    )
  }
  lines
}

///|
pub fn wgrib2_s_lines(context : Grib2FileContext) -> Array[String] {
  wgrib2_default_lines(context)
}

///|
pub fn wgrib2_var_lev_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      meta.parameter_name.display() +
      ":" +
      meta.level_name.display(),
    )
  }
  lines
}

///|
pub fn wgrib2_var_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + meta.parameter_name.display())
  }
  lines
}

///|
pub fn wgrib2_lev_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + meta.level_name.display())
  }
  lines
}

///|
pub fn wgrib2_ftime_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + meta.tail)
  }
  lines
}

///|
pub fn wgrib2_n_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "n=" + meta.record_index.to_string())
  }
  lines
}

///|
pub fn wgrib2_range_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let end_offset = meta.message_offset + meta.message_total_length - 1
    lines.push(
      format_prefix(meta) +
      "range=" +
      meta.message_offset.to_string() +
      "-" +
      end_offset.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_sec0_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "Sec0=GRIB reserved " +
      meta.section0_reserved +
      " Discipline=" +
      meta.discipline.to_string() +
      " Grib_Edition=" +
      meta.edition.to_string() +
      " len=" +
      meta.message_total_length.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_sec3_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "Sec3 len=" +
      meta.section3_length.to_string() +
      " src gdef=" +
      meta.section3_gdef_source.to_string() +
      " npts=" +
      meta.section3_npts.to_string() +
      " Grid Def Template=3." +
      meta.section3_template.id().to_string() +
      " opt arg=0",
    )
  }
  lines
}

///|
pub fn wgrib2_sec4_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "Sec4 len=" +
      meta.section4_length.to_string() +
      " #vert coordinate=" +
      meta.section4_num_coord.to_string() +
      " Product Defn Template=4." +
      meta.section4_template.id().to_string() +
      " size=" +
      meta.section4_length.to_string() +
      " expected size=" +
      meta.section4_length.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_sec5_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "Sec5 len=" +
      meta.section5_length.to_string() +
      " #defined data points=" +
      meta.section5_num_defined_points.to_string() +
      " Data Repr. Template=5." +
      meta.section5_template.id().to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_sec6_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "Sec6 length " +
      meta.section6_length.to_string() +
      " bitmap indicator " +
      meta.section6_bitmap_indicator.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_sec_len_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let section3 = if meta.section3_reused {
      meta.section3_length.to_string() + "*"
    } else {
      meta.section3_length.to_string()
    }
    lines.push(
      format_prefix(meta) +
      "Sec size msg=" +
      meta.message_total_length.to_string() +
      " id(1)=" +
      meta.section1_length.to_string() +
      " local(2)=" +
      meta.section2_length.to_string() +
      " grid(3)=" +
      section3 +
      " product(4)=" +
      meta.section4_length.to_string() +
      " data-rep(5)=" +
      meta.section5_length.to_string() +
      " bitmap(6)=" +
      meta.section6_length.to_string() +
      " data(7)=" +
      meta.section7_length.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_grid_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let template_id = meta.section3_template.id()
    if template_id == 0 &&
      meta.section3_ni >= 0 &&
      meta.section3_nj >= 0 &&
      meta.section3_di_microdeg >= 0 &&
      meta.section3_dj_microdeg >= 0 {
      lines.push(format_prefix(meta) + "grid_template=0:winds(N/S):")
      lines.push(
        "\tlat-lon grid:(" +
        meta.section3_ni.to_string() +
        " x " +
        meta.section3_nj.to_string() +
        ") units 1e-06 input WE:NS output WE:SN res " +
        meta.section3_resolution_flags.to_string(),
      )
      lines.push(
        "\tlat " +
        format_microdegrees(meta.section3_lat1_microdeg) +
        " to " +
        format_microdegrees(meta.section3_lat2_microdeg) +
        " by " +
        format_microdegrees(meta.section3_dj_microdeg),
      )
      lines.push(
        "\tlon " +
        format_microdegrees(meta.section3_lon1_microdeg) +
        " to " +
        format_microdegrees(meta.section3_lon2_microdeg) +
        " by " +
        format_microdegrees(meta.section3_di_microdeg) +
        " #points=" +
        meta.section3_npts.to_string(),
      )
    } else {
      lines.push(
        format_prefix(meta) +
        "grid_template=" +
        template_id.to_string() +
        ":unsupported",
      )
    }
  }
  lines
}

///|
pub fn wgrib2_pdt_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "pdt=" + meta.section4_template.id().to_string())
  }
  lines
}

///|
pub fn wgrib2_process_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.section4_process_code
    let label = process_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 4.3=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 4.3=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
pub fn wgrib2_ens_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + ens_label(meta))
  }
  lines
}

///|
pub fn wgrib2_prob_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + prob_label(meta))
  }
  lines
}

///|
pub fn wgrib2_disc_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.discipline
    let label = discipline_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 0.0=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 0.0=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
pub fn wgrib2_center_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "center=" + meta.section1_center.to_string())
  }
  lines
}

///|
pub fn wgrib2_subcenter_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) + "subcenter=" + meta.section1_subcenter.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_packing_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "packing=" + packing_label(meta))
  }
  lines
}

///|
pub fn wgrib2_bitmap_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let text = if meta.section6_bitmap_indicator == 255 {
      "no bitmap"
    } else if meta.section6_bitmap_indicator == 0 {
      "bitmap " + meta.section6_undef_points.to_string() + " undef pts"
    } else {
      "bitmap code table 6.0=" + meta.section6_bitmap_indicator.to_string()
    }
    lines.push(format_prefix(meta) + text)
  }
  lines
}

///|
pub fn wgrib2_nxny_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let text = if meta.section3_ni >= 0 && meta.section3_nj >= 0 {
      "(" + meta.section3_ni.to_string() + " x " + meta.section3_nj.to_string() + ")"
    } else {
      ""
    }
    lines.push(format_prefix(meta) + text)
  }
  lines
}

///|
pub fn wgrib2_npts_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "npts=" + meta.section3_npts.to_string())
  }
  lines
}

///|
pub fn inventory_lines(context : Grib2FileContext) -> Array[String] {
  wgrib2_s_lines(context)
}

///|
pub fn sec0_lines(context : Grib2FileContext) -> Array[String] {
  wgrib2_sec0_lines(context)
}
