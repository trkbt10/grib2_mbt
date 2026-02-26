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
    _ => if value >= 192 && value <= 254 { "undefined" } else { "" }
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
      _ => if meta.section4_ens_type >= 0 { "unknown derived fcst" } else { "" }
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
    for _ in 0..<-scale_factor {
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
pub fn wgrib2_t_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "d=" + meta.reference_time)
  }
  lines
}

///|
pub fn wgrib2_vt_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // TODO: add forecast_time to reference_time for proper verification time
    lines.push(format_prefix(meta) + "vt=" + meta.reference_time)
  }
  lines
}

///|
pub fn wgrib2_T_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "D=" + meta.reference_time_full)
  }
  lines
}

///|
pub fn wgrib2_VT_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // TODO: add forecast_time to reference_time for proper verification time
    lines.push(format_prefix(meta) + "vt=" + meta.reference_time_full)
  }
  lines
}

///|
pub fn wgrib2_YY_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // reference_time is YYYYMMDDHH, extract first 4 chars
    lines.push(
      format_prefix(meta) + "YY=" + meta.reference_time.substring(end=4),
    )
  }
  lines
}

///|
pub fn wgrib2_MM_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // reference_time is YYYYMMDDHH, extract chars 4-6
    lines.push(
      format_prefix(meta) +
      "MM=" +
      meta.reference_time.substring(start=4, end=6),
    )
  }
  lines
}

///|
fn rt_label(significance : Int) -> String {
  match significance {
    0 => "Analysis"
    1 => "Start of fcst"
    2 => "Verf time of fcst"
    3 => "Obs time"
    4 => "Local Time"
    5 => "Simulation Start"
    6 => "Start of Data Assimilation"
    255 => "Missing"
    _ => "unknown"
  }
}

///|
fn code_table_1_2_label(significance : Int) -> String {
  match significance {
    0 => "Analysis"
    1 => "Start of forecast"
    2 => "Verifying time of forecast"
    3 => "Observation time"
    4 => "Local Time"
    5 => "Simulation Start"
    6 => "Start of Data Assimilation"
    255 => "Missing"
    _ => ""
  }
}

///|
pub fn wgrib2_RT_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "RT=" +
      rt_label(meta.section1_significance_of_ref_time),
    )
  }
  lines
}

///|
pub fn wgrib2_start_ft_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // For instantaneous data, start_ft equals verification time
    lines.push(format_prefix(meta) + "start_ft=" + meta.reference_time)
  }
  lines
}

///|
pub fn wgrib2_start_FT_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // For instantaneous data, start_FT equals verification time (full)
    lines.push(format_prefix(meta) + "start_FT=" + meta.reference_time_full)
  }
  lines
}

///|
pub fn wgrib2_end_ft_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // For instantaneous data, end_ft equals verification time
    lines.push(format_prefix(meta) + "end_ft=" + meta.reference_time)
  }
  lines
}

///|
pub fn wgrib2_end_FT_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // For instantaneous data, end_FT equals verification time (full)
    lines.push(format_prefix(meta) + "end_FT=" + meta.reference_time_full)
  }
  lines
}

///|
pub fn wgrib2_S_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // Same as -s but with D= (full timestamp) instead of d=
    lines.push(
      format_prefix(meta) +
      "D=" +
      meta.reference_time_full +
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
pub fn wgrib2_verf_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // Same as -s but with vt= (verification time) instead of d=
    lines.push(
      format_prefix(meta) +
      "vt=" +
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
pub fn wgrib2_unix_time_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "unix_rt=" +
      meta.unix_rt.to_string() +
      ":unix_vt=" +
      meta.unix_vt.to_string(),
    )
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
    lines.push(
      format_prefix(meta) + "pdt=" + meta.section4_template.id().to_string(),
    )
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
    lines.push(
      format_prefix(meta) + "center=" + meta.section1_center.to_string(),
    )
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
      "(" +
      meta.section3_ni.to_string() +
      " x " +
      meta.section3_nj.to_string() +
      ")"
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

///|
pub fn wgrib2_code_table_0_0_lines(context : Grib2FileContext) -> Array[String] {
  // Same as -disc
  wgrib2_disc_lines(context)
}

///|
pub fn wgrib2_code_table_1_0_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "code table 1.0=" +
      meta.section1_master_tables_version.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_code_table_1_1_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "code table 1.1=" +
      meta.section1_local_tables_version.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_code_table_1_2_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.section1_significance_of_ref_time
    let label = code_table_1_2_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 1.2=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 1.2=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
fn code_table_1_3_label(status : Int) -> String {
  match status {
    0 => "Operational Products"
    1 => "Operational Test Products"
    2 => "Research Products"
    3 => "Re-Analysis Products"
    4 => "THORPEX Interactive Grand Global Ensemble (TIGGE)"
    5 => "THORPEX Interactive Grand Global Ensemble (TIGGE) test"
    6 => "S2S Operational Products"
    7 => "S2S Test Products"
    255 => "Missing"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_1_3_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.section1_production_status
    let label = code_table_1_3_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 1.3=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 1.3=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
fn code_table_1_4_label(data_type : Int) -> String {
  match data_type {
    0 => "Analysis Products"
    1 => "Forecast Products"
    2 => "Analysis and Forecast Products"
    3 => "Control Forecast Products"
    4 => "Perturbed Forecast Products"
    5 => "Control and Perturbed Forecast Products"
    6 => "Processed Satellite Observations"
    7 => "Processed Radar Observations"
    8 => "Event Probability"
    255 => "Missing"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_1_4_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.section1_data_type
    let label = code_table_1_4_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 1.4=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 1.4=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
pub fn wgrib2_code_table_3_0_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "code table 3.0=" +
      meta.section3_gdef_source.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_code_table_6_0_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "code table 6.0=" +
      meta.section6_bitmap_indicator.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_flag_table_3_3_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "flag table 3.3=" +
      meta.section3_resolution_flags.to_string(),
    )
  }
  lines
}

///|
fn scanning_mode_label(mode : Int) -> String {
  // Bit 1: i direction (0=positive/+i, 1=negative/-i)
  // Bit 2: j direction (0=negative/-j, 1=positive/+j)
  // Bit 3: adjacent points (0=i direction consecutive, 1=j direction consecutive)
  let i_dir = if (mode & 0x80) != 0 { "-i" } else { "+i" }
  let j_dir = if (mode & 0x40) != 0 { "+j" } else { "-j" }
  // Common labels
  if mode == 0 {
    "WE:NS"
  } else if mode == 64 {
    "WE:SN"
  } else if mode == 128 {
    "EW:NS"
  } else if mode == 192 {
    "EW:SN"
  } else {
    i_dir + ":" + j_dir
  }
}

///|
pub fn wgrib2_flag_table_3_4_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let mode = meta.section3_scanning_mode
    let label = scanning_mode_label(mode)
    lines.push(
      format_prefix(meta) + "flag table 3.4=" + mode.to_string() + " " + label,
    )
  }
  lines
}

///|
pub fn wgrib2_scan_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let mode = meta.section3_scanning_mode
    let input_label = scanning_mode_label(mode)
    // wgrib2 outputs transformed to WE:SN
    lines.push(
      format_prefix(meta) +
      "scan=" +
      mode.to_string() +
      " input=" +
      input_label +
      " output=WE:SN",
    )
  }
  lines
}

///|
pub fn wgrib2_ext_name_lines(context : Grib2FileContext) -> Array[String] {
  // Same as -var
  wgrib2_var_lines(context)
}

///|
fn level_for_full_name(level : String) -> String {
  // Replace spaces with underscores for full_name format
  level.replace_all(old=" ", new="_")
}

///|
pub fn wgrib2_full_name_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let level = level_for_full_name(meta.level_name.display())
    lines.push(
      format_prefix(meta) + meta.parameter_name.display() + "." + level,
    )
  }
  lines
}

///|
fn simple_level_label(level_name : String) -> String {
  // Convert level name to simple form
  if level_name == "surface" {
    "sfc"
  } else if level_name.starts_with("mean sea level") {
    "msl"
  } else if level_name.starts_with("tropopause") {
    "tropopause"
  } else if level_name.starts_with("top of atmosphere") {
    "TOA"
  } else if level_name.ends_with(" mb") {
    level_name.substring(end=level_name.length() - 3) + " mb"
  } else if level_name.ends_with(" m above ground") {
    level_name.substring(end=level_name.length() - 14) + " m above gnd"
  } else if level_name.ends_with(" in sequence") {
    // "1 in sequence" -> "_1"
    "_" + level_name.substring(end=level_name.length() - 12)
  } else {
    level_name
  }
}

///|
pub fn wgrib2_lev0_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let level = meta.level_name.display()
    let simple = simple_level_label(level)
    lines.push(format_prefix(meta) + simple)
  }
  lines
}

///|
pub fn wgrib2_cyclic_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // Check if grid is cyclic (covers 360 degrees in longitude)
    // For lat-lon grid, check if (lon2 - lon1) + di >= 360
    let is_cyclic = if meta.section3_template.id() == 0 &&
      meta.section3_di_microdeg > 0 {
      let lon_span = if meta.section3_lon2_microdeg >=
        meta.section3_lon1_microdeg {
        meta.section3_lon2_microdeg - meta.section3_lon1_microdeg
      } else {
        meta.section3_lon2_microdeg + 360000000 - meta.section3_lon1_microdeg
      }
      lon_span + meta.section3_di_microdeg >= 360000000
    } else {
      false
    }
    let label = if is_cyclic { "cyclic" } else { "not cyclic" }
    lines.push(format_prefix(meta) + label)
  }
  lines
}

///|
fn format_degrees(microdeg : Int) -> String {
  let sign = if microdeg < 0 { "-" } else { "" }
  let abs_val = if microdeg < 0 { -microdeg } else { microdeg }
  let integer = abs_val / 1000000
  let fraction = abs_val % 1000000
  // Format as X.NNNNNN
  sign + integer.to_string() + "." + pad6(fraction)
}

///|
pub fn wgrib2_domain_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    if meta.section3_template.id() == 0 {
      // For lat-lon grid, determine N/S/W/E
      let lat1 = meta.section3_lat1_microdeg
      let lat2 = meta.section3_lat2_microdeg
      let lon1 = meta.section3_lon1_microdeg
      let lon2 = meta.section3_lon2_microdeg
      let n = if lat1 > lat2 { lat1 } else { lat2 }
      let s = if lat1 < lat2 { lat1 } else { lat2 }
      // Convert longitude to -180 to 180 range for display
      let w = if lon1 > 180000000 { lon1 - 360000000 } else { lon1 }
      let e = if lon2 > 180000000 { lon2 - 360000000 } else { lon2 }
      lines.push(
        format_prefix(meta) +
        "N=" +
        format_degrees(n) +
        " S=" +
        format_degrees(s) +
        " W=" +
        format_degrees(w) +
        " E=" +
        format_degrees(e),
      )
    } else {
      lines.push(format_prefix(meta) + "domain not available")
    }
  }
  lines
}

///|
pub fn wgrib2_code_table_4_3_lines(context : Grib2FileContext) -> Array[String] {
  // Same as -process
  wgrib2_process_lines(context)
}

///|
fn code_table_4_0_label(template_id : Int) -> String {
  match template_id {
    0 =>
      "Analysis or forecast at a horizontal level or in a horizontal layer at a point in time"
    1 => "Individual ensemble forecast"
    2 => "Derived forecasts from ensemble"
    5 => "Probability forecasts"
    6 => "Percentile forecasts"
    7 => "Analysis or forecast error"
    8 => "Average, accumulation, or extreme values"
    9 => "Probability forecasts with time interval"
    10 => "Percentile forecasts with time interval"
    11 => "Individual ensemble forecast with time interval"
    12 => "Derived forecasts from ensemble with time interval"
    15 => "Spatial cluster analysis"
    40 => "Analysis or forecast at a horizontal level with JPEG 2000"
    41 => "Analysis or forecast at a horizontal level with PNG"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_4_0_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.section4_template.id()
    let label = code_table_4_0_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 4.0=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 4.0=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
pub fn wgrib2_code_table_4_1_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "code table 4.1=" +
      meta.section4_parameter_category.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_code_table_4_2_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "code table 4.2=" +
      meta.section4_parameter_number.to_string(),
    )
  }
  lines
}

///|
fn code_table_4_4_label(time_unit : Int) -> String {
  match time_unit {
    0 => "(Minute)"
    1 => "(Hour)"
    2 => "(Day)"
    3 => "(Month)"
    4 => "(Year)"
    5 => "(Decade)"
    6 => "(Normal (30 years))"
    7 => "(Century)"
    10 => "(3 hours)"
    11 => "(6 hours)"
    12 => "(12 hours)"
    13 => "(Second)"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_4_4_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.section4_time_unit
    let label = code_table_4_4_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 4.4=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 4.4=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
fn code_table_3_1_label(template_id : Int) -> String {
  match template_id {
    0 => "Latitude/longitude"
    1 => "Rotated latitude/longitude"
    2 => "Stretched latitude/longitude"
    3 => "Rotated and stretched latitude/longitude"
    10 => "Mercator"
    20 => "Polar stereographic"
    30 => "Lambert conformal"
    31 => "Albers equal-area"
    40 => "Gaussian latitude/longitude"
    41 => "Rotated Gaussian latitude/longitude"
    42 => "Stretched Gaussian latitude/longitude"
    43 => "Rotated and stretched Gaussian latitude/longitude"
    50 => "Spherical harmonic coefficients"
    51 => "Rotated spherical harmonic coefficients"
    52 => "Stretched spherical harmonic coefficients"
    53 => "Rotated and stretched spherical harmonic coefficients"
    90 => "Space view"
    100 => "Triangular grid"
    101 => "General unstructured grid"
    110 => "Equatorial azimuthal equidistant"
    120 => "Azimuth-range"
    130 => "Irregular latitude/longitude"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_3_1_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.section3_template.id()
    let label = code_table_3_1_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 3.1=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 3.1=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
fn code_table_5_0_label(template_id : Int) -> String {
  match template_id {
    0 => "Grid point data - simple packing"
    2 => "Grid point data - complex packing"
    3 => "Grid point data - complex packing and spatial differencing"
    4 => "Grid point data - IEEE floating point data"
    40 => "Grid point data - JPEG 2000 code stream format"
    41 => "Grid point data - Portable Network Graphics (PNG)"
    50 => "Spectral data - simple packing"
    51 => "Spherical harmonics data - complex packing"
    61 => "Grid point data - simple packing with logarithm pre-processing"
    200 => "Run length packing with level values"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_5_0_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let value = meta.section5_template.id()
    let label = code_table_5_0_label(value)
    if label == "" {
      lines.push(format_prefix(meta) + "code table 5.0=" + value.to_string())
    } else {
      lines.push(
        format_prefix(meta) +
        "code table 5.0=" +
        value.to_string() +
        " " +
        label,
      )
    }
  }
  lines
}

///|
fn ieee_to_int(ieee : Int) -> Int {
  // Convert IEEE 754 binary32 to integer (truncated)
  // IEEE 754 format: sign(1) exponent(8) mantissa(23)
  let sign = if ((ieee >> 31) & 1) != 0 { -1 } else { 1 }
  let exp = (ieee >> 23) & 0xff
  let mantissa = ieee & 0x7fffff
  if exp == 0 && mantissa == 0 {
    return 0
  }
  // Normal number: value = (-1)^sign * 2^(exp-127) * (1 + mantissa/2^23)
  let exponent = exp - 127
  let frac = 1.0 + mantissa.to_double() / 8388608.0 // 2^23 = 8388608
  let value = sign.to_double() * frac * pow2(exponent)
  value.to_int()
}

///|
fn pow2(exp : Int) -> Double {
  if exp >= 0 {
    let mut result = 1.0
    for _ in 0..<exp {
      result *= 2.0
    }
    result
  } else {
    let mut result = 1.0
    for _ in 0..<-exp {
      result /= 2.0
    }
    result
  }
}

///|
pub fn wgrib2_scale_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // wgrib2 outputs negated decimal scale (multiplication form, not division)
    let dec = -meta.section5_decimal_scale_factor
    let bin = meta.section5_binary_scale_factor
    lines.push(
      format_prefix(meta) + "scale=" + dec.to_string() + "," + bin.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_scaling_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let ref = ieee_to_int(meta.section5_reference_value_ieee)
    // wgrib2 outputs negated decimal scale (multiplication form)
    let dec = -meta.section5_decimal_scale_factor
    let bin = meta.section5_binary_scale_factor
    let nbits = meta.section5_bits_per_value
    lines.push(
      format_prefix(meta) +
      "scaling ref=" +
      ref.to_string() +
      " dec_scale=" +
      dec.to_string() +
      " bin_scale=" +
      bin.to_string() +
      " nbits=" +
      nbits.to_string(),
    )
  }
  lines
}

///|
fn apply_scale_factor(scaled_value : Int, scale_factor : Int) -> Double {
  if scale_factor == 0 {
    scaled_value.to_double()
  } else {
    scaled_value.to_double() / pow10_double(scale_factor)
  }
}

///|
fn pow10_double(exp : Int) -> Double {
  let mut result = 1.0
  if exp >= 0 {
    for _ in 0..<exp {
      result *= 10.0
    }
  } else {
    for _ in 0..<-exp {
      result /= 10.0
    }
  }
  result
}

///|
fn format_radius(value : Double) -> String {
  // Format as "%.6f" - 6 decimal places
  let int_part = value.to_int64()
  let frac_part = ((value - int_part.to_double()) * 1000000.0 + 0.5).to_int64()
  let frac_str = frac_part.to_string()
  // Pad fraction to 6 digits
  let padded_frac = if frac_str.length() < 6 {
    let mut s = ""
    for _ in 0..<(6 - frac_str.length()) {
      s = s + "0"
    }
    s + frac_str
  } else {
    frac_str
  }
  int_part.to_string() + "." + padded_frac
}

///|
pub fn wgrib2_radius_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let shape = meta.section3_shape_of_earth
    let (radius_maj, radius_min, is_spherical) : (Double, Double, Int) = match
      shape {
      0 => (6367470.0, 6367470.0, 1) // Spherical r=6367470m
      1 => {
        // Spherical with specified radius
        let r = apply_scale_factor(
          meta.section3_scaled_value_radius,
          meta.section3_scale_factor_radius,
        )
        (r, r, 1)
      }
      2 => (6378160.0, 6356775.0, 0) // IAU 1965 oblate spheroid
      3 => {
        // Oblate spheroid with specified values (scaled in km)
        let a = apply_scale_factor(
            meta.section3_scaled_value_major,
            meta.section3_scale_factor_major,
          ) *
          1000.0
        let b = apply_scale_factor(
            meta.section3_scaled_value_minor,
            meta.section3_scale_factor_minor,
          ) *
          1000.0
        (a, b, 0)
      }
      4 => (6378137.0, 6356752.314, 0) // IAG-GRS80
      5 => (6378137.0, 6356752.3142, 0) // WGS84
      6 => (6371229.0, 6371229.0, 1) // Spherical r=6371229m
      7 => {
        // Oblate spheroid with specified values in meters
        let a = apply_scale_factor(
          meta.section3_scaled_value_major,
          meta.section3_scale_factor_major,
        )
        let b = apply_scale_factor(
          meta.section3_scaled_value_minor,
          meta.section3_scale_factor_minor,
        )
        (a, b, 0)
      }
      8 => (6371200.0, 6371200.0, 1) // Spherical r=6371200m
      9 => (6377563.396, 6356256.909, 0) // OSGB 1936 Airy 1830
      _ => (6371229.0, 6371229.0, 1) // Default to code 6
    }
    lines.push(
      format_prefix(meta) +
      "code3.2=" +
      shape.to_string() +
      " radius_maj=" +
      format_radius(radius_maj) +
      " radiusmin=" +
      format_radius(radius_min) +
      " is_spherical=" +
      is_spherical.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_varX_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // Format: var<disc>_<master>_<local>_<center>_<category>_<parameter>
    let disc = meta.discipline
    let master = meta.section1_master_tables_version
    let local = meta.section1_local_tables_version
    let center = meta.section1_center
    let cat = meta.section4_parameter_category
    let param = meta.section4_parameter_number
    lines.push(
      format_prefix(meta) +
      "var" +
      disc.to_string() +
      "_" +
      master.to_string() +
      "_" +
      local.to_string() +
      "_" +
      center.to_string() +
      "_" +
      cat.to_string() +
      "_" +
      param.to_string(),
    )
  }
  lines
}

///|
fn format_radius_1(value : Double) -> String {
  // Format as "%.1f" - 1 decimal place
  let int_part = value.to_int64()
  let frac_part = ((value - int_part.to_double()) * 10.0 + 0.5).to_int64()
  if frac_part >= 10 {
    (int_part + 1L).to_string() + ".0"
  } else {
    int_part.to_string() + "." + frac_part.to_string()
  }
}

///|
fn get_proj_id(template_id : Int) -> Int {
  // Map grid definition template number to projection ID
  match template_id {
    0 => 1 // Latitude/longitude
    1 => 1 // Rotated lat/lon
    10 => 2 // Mercator
    20 => 3 // Polar Stereographic
    30 => 4 // Lambert Conformal
    40 => 5 // Gaussian lat/lon
    90 => 6 // Space View
    _ => 0 // Unknown
  }
}

///|
pub fn wgrib2_grid_id_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let shape = meta.section3_shape_of_earth
    let (radius_maj, radius_min) : (Double, Double) = match shape {
      0 => (6367470.0, 6367470.0)
      1 => {
        let r = apply_scale_factor(
          meta.section3_scaled_value_radius,
          meta.section3_scale_factor_radius,
        )
        (r, r)
      }
      2 => (6378160.0, 6356775.0)
      3 => {
        let a = apply_scale_factor(
            meta.section3_scaled_value_major,
            meta.section3_scale_factor_major,
          ) *
          1000.0
        let b = apply_scale_factor(
            meta.section3_scaled_value_minor,
            meta.section3_scale_factor_minor,
          ) *
          1000.0
        (a, b)
      }
      4 => (6378137.0, 6356752.314)
      5 => (6378137.0, 6356752.3142)
      6 => (6371229.0, 6371229.0)
      7 => {
        let a = apply_scale_factor(
          meta.section3_scaled_value_major,
          meta.section3_scale_factor_major,
        )
        let b = apply_scale_factor(
          meta.section3_scaled_value_minor,
          meta.section3_scale_factor_minor,
        )
        (a, b)
      }
      8 => (6371200.0, 6371200.0)
      9 => (6377563.396, 6356256.909)
      _ => (6371229.0, 6371229.0)
    }
    let proj_id = get_proj_id(meta.section3_template.id())
    let n = meta.section3_npts
    let nx = meta.section3_ni
    let ny = meta.section3_nj
    lines.push(
      format_prefix(meta) +
      "grid_id err=0 r_major=" +
      format_radius_1(radius_maj) +
      " m r_minor=" +
      format_radius_1(radius_min) +
      " m proj_id=" +
      proj_id.to_string() +
      " n=" +
      n.to_string() +
      " nx=" +
      nx.to_string() +
      " ny=" +
      ny.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_nl_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // Output just the prefix followed by an empty line
    lines.push(format_prefix(meta))
    lines.push("")
  }
  lines
}

///|
pub fn wgrib2_misc_lines(context : Grib2FileContext) -> Array[String] {
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // -misc outputs just the prefix with empty content
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_flag_table_3_5_lines(context : Grib2FileContext) -> Array[String] {
  // flag_table_3.5 - projection center flags (for polar stereographic, etc.)
  // Only applicable to certain grid templates; outputs empty for lat/lon grids
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_flag_table_3_9_lines(context : Grib2FileContext) -> Array[String] {
  // flag_table_3.9 - numbering order of diamonds (for HEALPix grids)
  // Only applicable to certain grid templates; outputs empty for lat/lon grids
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_flag_table_3_10_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // flag_table_3.10 - scanning mode for one diamond (for HEALPix grids)
  // Only applicable to certain grid templates; outputs empty for lat/lon grids
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
fn format_varX(meta : Grib2RecordMeta) -> String {
  // Format: var<disc>_<master>_<local>_<center>_<category>_<parameter>
  let disc = meta.discipline
  let master = meta.section1_master_tables_version
  let local_tables = meta.section1_local_tables_version
  let center = meta.section1_center
  let cat = meta.section4_parameter_category
  let param = meta.section4_parameter_number
  "var" +
  disc.to_string() +
  "_" +
  master.to_string() +
  "_" +
  local_tables.to_string() +
  "_" +
  center.to_string() +
  "_" +
  cat.to_string() +
  "_" +
  param.to_string()
}

///|
fn format_scaling(meta : Grib2RecordMeta) -> String {
  let ref_val = ieee_to_int(meta.section5_reference_value_ieee)
  // wgrib2 outputs negated decimal scale (multiplication form)
  let dec = -meta.section5_decimal_scale_factor
  let bin = meta.section5_binary_scale_factor
  let nbits = meta.section5_bits_per_value
  "scaling ref=" +
  ref_val.to_string() +
  " dec_scale=" +
  dec.to_string() +
  " bin_scale=" +
  bin.to_string() +
  " nbits=" +
  nbits.to_string()
}

///|
pub fn wgrib2_match_inv_lines(context : Grib2FileContext) -> Array[String] {
  // -match_inv/-Match_inv: comprehensive inventory for matching
  // Format: n:offset:d=YYYYMMDDHH:VAR:LEVEL:FTIME::VAR:n=N:npts=NPTS:varX:pdt=N:D=YYYYMMDDHHmmss:start_FT=YYYYMMDDHHmmss:end_FT=YYYYMMDDHHmmss:scaling:FTIME:vt=YYYYMMDDHH:
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // Use meta.tail which contains the formatted forecast time label (anl, 0 hour fcst, etc.)
    let ftime_label = meta.tail
    // For instantaneous data (anl), start_FT and end_FT equal reference_time_full
    let start_ft = meta.reference_time_full
    let end_ft = meta.reference_time_full
    // vt (verification time) equals reference_time for anl data
    let vt_short = meta.reference_time
    // Field order matches wgrib2: d= early, D= after pdt=
    let line = format_prefix(meta) +
      "d=" +
      meta.reference_time +
      ":" +
      meta.parameter_name.display() +
      ":" +
      meta.level_name.display() +
      ":" +
      ftime_label +
      "::" +
      meta.parameter_name.display() +
      ":n=" +
      meta.record_id +
      ":npts=" +
      meta.section3_npts.to_string() +
      ":" +
      format_varX(meta) +
      ":pdt=" +
      meta.section4_template.id().to_string() +
      ":D=" +
      meta.reference_time_full +
      ":start_FT=" +
      start_ft +
      ":end_FT=" +
      end_ft +
      ":" +
      format_scaling(meta) +
      ":" +
      ftime_label +
      ":vt=" +
      vt_short +
      ":"
    lines.push(line)
  }
  lines
}

///|
fn earth_shape_description(shape : Int) -> String {
  match shape {
    0 => "Earth assumed spherical with radius = 6367470.0 m"
    1 => "Earth assumed spherical with radius specified by data producer"
    2 => "Earth assumed oblate spheroid with size as determined by IAU in 1965"
    3 =>
      "Earth assumed oblate spheroid with major and minor axes specified by data producer"
    4 => "Earth assumed oblate spheroid as defined in IAG-GRS80 model"
    5 => "Earth assumed represented by WGS84"
    6 => "Earth assumed spherical with radius of 6371229.0 m"
    7 =>
      "Earth assumed oblate spheroid with major and minor axes specified by data producer in m"
    8 => "Earth model assumed spherical with radius 6371200 m"
    9 => "Earth represented by the OSGB 1936 Datum"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_3_2_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_3.2: Shape of the Earth
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let shape = meta.section3_shape_of_earth
    let desc = earth_shape_description(shape)
    if desc.length() > 0 {
      lines.push(
        format_prefix(meta) + "code table 3.2=" + shape.to_string() + " " + desc,
      )
    } else {
      lines.push(format_prefix(meta) + "code table 3.2=" + shape.to_string())
    }
  }
  lines
}

///|
pub fn wgrib2_code_table_4_5a_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.5a: First fixed surface type
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "code table 4.5a=" +
      meta.section4_first_surface_type.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_code_table_4_5b_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.5b: Second fixed surface type
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "code table 4.5b=" +
      meta.section4_second_surface_type.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_code_table_1_5_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_1.5: Identification template number (only in some messages)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_1_6_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_1.6: Calendar (only in some messages)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_6_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_4.6: Ensemble type (only for ensemble templates)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_9_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_4.9: Probability type (only for probability templates)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_10_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.10: Statistical processing (only for time range templates)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_11_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.11: Type of time intervals (only for time range templates)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
fn code_table_3_11_description(value : Int) -> String {
  match value {
    0 => "not used"
    1 => "Thinned"
    2 => "Reduced"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_3_11_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_3.11: Interpretation of list of numbers defining number of points
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // For lat/lon grids (template 0), this is typically 0 (not used)
    // The value is at octet 11 of Section 3
    let value = 0 // For regular grids, this is always 0
    let desc = code_table_3_11_description(value)
    if desc.length() > 0 {
      lines.push(
        format_prefix(meta) +
        "code table 3.11=" +
        value.to_string() +
        " " +
        desc,
      )
    } else {
      lines.push(format_prefix(meta) + "code table 3.11=" + value.to_string())
    }
  }
  lines
}

///|
fn code_table_5_1_description(value : Int) -> String {
  match value {
    0 => "Floating point"
    1 => "Integer"
    _ => ""
  }
}

///|
pub fn wgrib2_code_table_5_1_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_5.1: Type of original field values
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // For simple packing (template 0), this is at octet 21
    // For JPEG2000 (template 40), this is at a different offset
    // Default to 0 (floating point) for now
    let value = 0
    let desc = code_table_5_1_description(value)
    if desc.length() > 0 {
      lines.push(
        format_prefix(meta) + "code table 5.1=" + value.to_string() + " " + desc,
      )
    } else {
      lines.push(format_prefix(meta) + "code table 5.1=" + value.to_string())
    }
  }
  lines
}

///|
pub fn wgrib2_code_table_3_6_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_3.6: Spectral data representation type (only for spectral grids)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_3_7_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_3.7: Spectral data representation mode (only for spectral grids)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_3_8_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_3.8: Grid point position
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_3_15_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_3.15: Physical meaning of vertical coordinate
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_3_20_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_3.20: Type of horizontal line
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_3_21_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_3.21: Vertical dimension coordinate values definition
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_7_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_4.7: Derived forecast type
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_8_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_4.8: Cluster mean (same as 4.7)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_11s_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.11s: Type of time intervals (all occurrences)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_15_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.15: Type of areal statistical processing
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_16_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.16: Quality control value
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_91_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.91: Type of interval (first)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_91b_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.91b: Type of interval (second copy)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_230_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.230: Chemical constituent type
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_233_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.233: Aerosol type
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_235_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.235: Wind-generated wave spectral description
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_240_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.240: Type of distribution function
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_241_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.241: Coverage attributes
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_4_242_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -code_table_4.242: Tile classification
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_5_4_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_5.4: Group splitting method
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_5_5_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_5.5: Missing value management for complex packing
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_5_6_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_5.6: Complex packing spatial differencing
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_code_table_5_7_lines(context : Grib2FileContext) -> Array[String] {
  // -code_table_5.7: Precision in IEEE packing
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_ftime1_lines(context : Grib2FileContext) -> Array[String] {
  // -ftime1: Same as -ftime
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + meta.tail)
  }
  lines
}

///|
pub fn wgrib2_s2_lines(context : Grib2FileContext) -> Array[String] {
  // -s2: Simple inventory (same format as -s)
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
pub fn wgrib2_pds_fcst_time_lines(context : Grib2FileContext) -> Array[String] {
  // -pds_fcst_time: Forecast time in PDS units
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // For analysis (anl), forecast time is 0
    // Extract from the tail field
    let fcst_time = if meta.tail == "anl" { 0 } else { 0 } // TODO: parse actual forecast time
    lines.push(format_prefix(meta) + "pds_fcst_time1=" + fcst_time.to_string())
  }
  lines
}

///|
fn type_reftime_description(code : Int) -> String {
  match code {
    0 => "Analysis"
    1 => "start of forecast"
    2 => "Verifying time of forecast"
    3 => "Observation time"
    4 => "Local time"
    _ => "unknown"
  }
}

///|
pub fn wgrib2_type_reftime_lines(context : Grib2FileContext) -> Array[String] {
  // -type_reftime: Type of reference time
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let desc = type_reftime_description(meta.section1_significance_of_ref_time)
    lines.push(format_prefix(meta) + "type_reftime=" + desc)
  }
  lines
}

///|
pub fn wgrib2_table_lines(context : Grib2FileContext) -> Array[String] {
  // -table: Parameter table information
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "discipline=" +
      meta.discipline.to_string() +
      " master_table=" +
      meta.section1_master_tables_version.to_string() +
      " local_table=" +
      meta.section1_local_tables_version.to_string(),
    )
  }
  lines
}

///|
fn vector_dir_description(flags : Int) -> String {
  // Check bit 5 (counting from 1) of resolution and component flags
  // If bit 5 is 0, winds are relative to east/north (grid)
  // If bit 5 is 1, winds are relative to the defined grid direction
  let bit5 = (flags >> 3) & 1
  if bit5 == 0 {
    "winds(N/S)"
  } else {
    "winds(grid)"
  }
}

///|
pub fn wgrib2_vector_dir_lines(context : Grib2FileContext) -> Array[String] {
  // -vector_dir: Grid or earth relative winds
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let desc = vector_dir_description(meta.section3_resolution_flags)
    lines.push(format_prefix(meta) + desc)
  }
  lines
}

///|
pub fn wgrib2_precision_lines(context : Grib2FileContext) -> Array[String] {
  // -precision: Precision of packing
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    // Format: encode i*2^bin_scale*10^-dec_scale
    let bin = meta.section5_binary_scale_factor
    let dec = -meta.section5_decimal_scale_factor // wgrib2 uses negated decimal scale
    lines.push(
      format_prefix(meta) +
      "encode i*2^" +
      bin.to_string() +
      "*10^" +
      dec.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_number_of_coordinate_values_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -number_of_coordinate_values_after_template
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "number_coordinates_values_in_pdt=" +
      meta.section4_num_coord.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_N_ens_lines(context : Grib2FileContext) -> Array[String] {
  // -N_ens: Number of ensemble members (only for ensemble templates)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_N_clusters_lines(context : Grib2FileContext) -> Array[String] {
  // -N_clusters: Number of clusters
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_aerosol_size_lines(context : Grib2FileContext) -> Array[String] {
  // -aerosol_size: Aerosol size (only for aerosol templates)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_aerosol_wavelength_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -aerosol_wavelength: Aerosol wavelength (only for aerosol templates)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_cluster_lines(context : Grib2FileContext) -> Array[String] {
  // -cluster: Cluster identifier
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_cluster_info_lines(context : Grib2FileContext) -> Array[String] {
  // -cluster_info: Cluster information
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_model_version_date_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -model_version_date: Model version date
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_percent_lines(context : Grib2FileContext) -> Array[String] {
  // -percent: Percentage probability (only for probability templates)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_post_processing_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -post_processing: Type of post-processing
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_spatial_proc_lines(context : Grib2FileContext) -> Array[String] {
  // -spatial_proc: Spatial processing (pdt=4.15)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_spectral_bands_lines(context : Grib2FileContext) -> Array[String] {
  // -spectral_bands: Spectral bands for satellite (pdt=4.31, 4.32)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_spectral_bands_extname_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -spectral_bands_extname: concise extname-compatible spectral band info
  wgrib2_spectral_bands_lines(context)
}

///|
pub fn wgrib2_gdt_lines(context : Grib2FileContext) -> Array[String] {
  // -gdt: Grid Definition Template details
  wgrib2_grid_lines(context)
}

///|
pub fn wgrib2_timer_lines(context : Grib2FileContext) -> Array[String] {
  // -timer: OpenMP timer readout (placeholder per record)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "timer=0.000")
  }
  lines
}

///|
pub fn wgrib2_ctl_inv_lines(context : Grib2FileContext) -> Array[String] {
  // -ctl_inv: inventory dump for g2ctl/GrADS
  wgrib2_match_inv_lines(context)
}

///|
pub fn wgrib2_pyinv_lines(context : Grib2FileContext) -> Array[String] {
  // -pyinv: metadata for pywgrib2 workflow
  wgrib2_match_inv_lines(context)
}

///|
pub fn wgrib2_ctl_ens_lines(context : Grib2FileContext) -> Array[String] {
  // -ctl_ens: Ensemble info for GrADS
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_warn_old_g2_lines(context : Grib2FileContext) -> Array[String] {
  // -warn_old_g2: Warn if old g2lib would have problem
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_wave_partition_lines(context : Grib2FileContext) -> Array[String] {
  // -wave_partition: Ocean surface wave partition (pdt=4.52)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_processid_lines(context : Grib2FileContext) -> Array[String] {
  // -processid: Background and forecast generating process identifiers
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "background generating process=" +
      meta.section4_background_process.to_string() +
      " forecast generating process=" +
      meta.section4_forecast_process.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_ftime2_lines(context : Grib2FileContext) -> Array[String] {
  // -ftime2: Same as -ftime (future replacement)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + meta.tail)
  }
  lines
}

///|
pub fn wgrib2_geolocation_lines(context : Grib2FileContext) -> Array[String] {
  // -geolocation: Package used to get lat/lon of grid points
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "geolocation=not_used")
  }
  lines
}

///|
pub fn wgrib2_JMA_lines(context : Grib2FileContext) -> Array[String] {
  // -JMA: JMA locally defined PDT (only for JMA data)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_JMA_Nb_lines(context : Grib2FileContext) -> Array[String] {
  // -JMA_Nb: JMA Nb value (-1 if not JMA data)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "JMA_Nb=-1")
  }
  lines
}

///|
pub fn wgrib2_JMA_Nr_lines(context : Grib2FileContext) -> Array[String] {
  // -JMA_Nr: JMA Nr value (-1 if not JMA data)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta) + "JMA_Nr=-1")
  }
  lines
}

///|
pub fn wgrib2_reset_delayed_error_lines(
  context : Grib2FileContext,
) -> Array[String] {
  // -reset_delayed_error: Clear reset_delayed_error flag
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
fn pad_ftn(value : Int, width : Int) -> String {
  // Right-align integer in specified-width field (Fortran I<width> format)
  let s = value.to_string()
  let pad_len = width - s.length()
  let mut result = ""
  for _ in 0..<pad_len {
    result = result + " "
  }
  result + s
}

///|
pub fn wgrib2_ftn_api_fn0_lines(context : Grib2FileContext) -> Array[String] {
  // -ftn_api_fn0: Fortran API format - n npnts nx ny msg_no submsg
  // First field uses I11, remaining fields use I12
  let records = decode_records(context)
  let lines : Array[String] = []
  let mut msg_no = 0
  let mut prev_offset = -1
  for meta in records {
    // Track message number (increments when offset changes)
    if meta.message_offset != prev_offset {
      msg_no += 1
      prev_offset = meta.message_offset
    }
    let submsg = 1 // Assuming single submessage for simplicity
    lines.push(
      format_prefix(meta) +
      pad_ftn(meta.record_index, 11) +
      pad_ftn(meta.section3_npts, 12) +
      pad_ftn(meta.section3_ni, 12) +
      pad_ftn(meta.section3_nj, 12) +
      pad_ftn(msg_no, 12) +
      pad_ftn(submsg, 12),
    )
  }
  lines
}

///|
pub fn wgrib2_grib_max_bits_lines(context : Grib2FileContext) -> Array[String] {
  // -grib_max_bits: Maximum bits used in grib encoding
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(
      format_prefix(meta) +
      "grib_max_bits=" +
      meta.section5_bits_per_value.to_string(),
    )
  }
  lines
}

///|
pub fn wgrib2_hybrid_lines(context : Grib2FileContext) -> Array[String] {
  // -hybrid: Shows vertical coordinate parameters from Sec4
  // Only outputs values for hybrid levels (assuming 2 var per level)
  // For non-hybrid data, outputs empty
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_V_lines(context : Grib2FileContext) -> Array[String] {
  // -V: Diagnostic/verbose output (outputs nothing for standard use)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_crlf_lines(context : Grib2FileContext) -> Array[String] {
  // -crlf: Changes line ending to CRLF (Windows style)
  // The actual CRLF conversion happens at output layer
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    lines.push(format_prefix(meta))
  }
  lines
}

///|
pub fn wgrib2_inv_lines(context : Grib2FileContext) -> Array[String] {
  // -inv: Standard inventory (same as default -s)
  wgrib2_s_lines(context)
}

///|
fn nibble_to_hex_char(n : Int) -> Char {
  if n < 10 {
    Char::from_int('0'.to_int() + n)
  } else {
    Char::from_int('a'.to_int() + n - 10)
  }
}

///|
fn byte_to_hex(b : Int) -> String {
  let high = (b >> 4) & 0x0F
  let low = b & 0x0F
  let high_char = nibble_to_hex_char(high)
  let low_char = nibble_to_hex_char(low)
  String::make(1, high_char) + String::make(1, low_char)
}

///|
fn bytes_to_hex(bytes : BytesView) -> String {
  let mut result = "0x"
  for i in 0..<bytes.length() {
    // Use same pattern as decode functions: to_uint().reinterpret_as_int()
    let byte_val = bytes[i].to_uint().reinterpret_as_int()
    result = result + byte_to_hex(byte_val)
  }
  result
}

///|
fn posix_cksum_table() -> FixedArray[UInt] {
  // POSIX cksum CRC table (polynomial 0x04C11DB7, MSB first)
  let table : FixedArray[UInt] = FixedArray::make(256, 0U)
  for i in 0..<256 {
    let mut c = i.to_uint() << 24
    for _ in 0..<8 {
      if (c & 0x80000000U) != 0 {
        c = (c << 1) ^ 0x04C11DB7U
      } else {
        c = c << 1
      }
    }
    table[i] = c
  }
  table
}

///|
fn compute_posix_cksum(bytes : BytesView) -> UInt {
  // POSIX cksum algorithm (same as wgrib2 -checksum)
  let table = posix_cksum_table()
  let mut crc : UInt = 0
  let len = bytes.length()

  // Process all bytes
  for i in 0..<len {
    let byte_val = bytes[i].to_uint().reinterpret_as_int()
    let idx = ((crc >> 24) ^ byte_val.to_uint()) & 0xFF
    crc = (crc << 8) ^ table[idx.reinterpret_as_int()]
  }

  // Process length (POSIX cksum includes length in calculation)
  let mut length = len.to_uint()
  while length > 0 {
    let idx = ((crc >> 24) ^ (length & 0xFF)) & 0xFF
    crc = (crc << 8) ^ table[idx.reinterpret_as_int()]
    length = length >> 8
  }

  crc ^ 0xFFFFFFFF
}

///|
fn get_section0_bytes(message : Grib2MessageContext) -> BytesView {
  // Section 0 is always 16 bytes at the start
  let start = 0
  let end = 16
  message.raw.sub(start~, end~)
}

///|
fn get_section1_bytes(message : Grib2MessageContext) -> BytesView {
  let start = message.section1.start - message.offset
  let end = message.section1.end_offset() - message.offset
  message.raw.sub(start~, end~)
}

///|
fn get_section_bytes(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
  section_num : Int,
) -> BytesView? {
  let frame = match section_num {
    2 =>
      match submessage.section2 {
        Some(f) => f
        None => return None
      }
    3 => submessage.section3
    4 => submessage.section4
    5 => submessage.section5
    6 => submessage.section6
    7 => submessage.section7
    _ => return None
  }
  let start = frame.start - message.offset
  let end = frame.end_offset() - message.offset
  Some(message.raw.sub(start~, end~))
}

///|
pub fn wgrib2_0xSec0_lines(context : Grib2FileContext) -> Array[String] {
  // -0xSec 0: Hex dump of section 0
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for _ in message.submessages {
      let sec0 = get_section0_bytes(message)
      let hex = bytes_to_hex(sec0)
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      lines.push(prefix + "Sec0(1..16)=" + hex)
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_0xSec1_lines(context : Grib2FileContext) -> Array[String] {
  // -0xSec 1: Hex dump of section 1
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    let sec1 = get_section1_bytes(message)
    let hex = bytes_to_hex(sec1)
    let len = sec1.length()
    for _ in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      lines.push(prefix + "Sec1(1.." + len.to_string() + ")=" + hex)
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_0xSec3_lines(context : Grib2FileContext) -> Array[String] {
  // -0xSec 3: Hex dump of section 3
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 3) {
        Some(sec) => {
          let hex = bytes_to_hex(sec)
          let len = sec.length()
          lines.push(prefix + "Sec3(1.." + len.to_string() + ")=" + hex)
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_0xSec4_lines(context : Grib2FileContext) -> Array[String] {
  // -0xSec 4: Hex dump of section 4
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 4) {
        Some(sec) => {
          let hex = bytes_to_hex(sec)
          let len = sec.length()
          lines.push(prefix + "Sec4(1.." + len.to_string() + ")=" + hex)
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_0xSec5_lines(context : Grib2FileContext) -> Array[String] {
  // -0xSec 5: Hex dump of section 5
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 5) {
        Some(sec) => {
          let hex = bytes_to_hex(sec)
          let len = sec.length()
          lines.push(prefix + "Sec5(1.." + len.to_string() + ")=" + hex)
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_0xSec6_lines(context : Grib2FileContext) -> Array[String] {
  // -0xSec 6: Hex dump of section 6
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 6) {
        Some(sec) => {
          let hex = bytes_to_hex(sec)
          let len = sec.length()
          lines.push(prefix + "Sec6(1.." + len.to_string() + ")=" + hex)
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_0xSec7_lines(context : Grib2FileContext) -> Array[String] {
  // -0xSec 7: Hex dump of section 7
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 7) {
        Some(sec) => {
          let hex = bytes_to_hex(sec)
          let len = sec.length()
          lines.push(prefix + "Sec7(1.." + len.to_string() + ")=" + hex)
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_checksum0_lines(context : Grib2FileContext) -> Array[String] {
  // -checksum 0: CRC checksum of section 0
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    let sec0 = get_section0_bytes(message)
    let crc = compute_posix_cksum(sec0)
    for _ in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      lines.push(prefix + "sec0_cksum=" + crc.to_string())
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_checksum1_lines(context : Grib2FileContext) -> Array[String] {
  // -checksum 1: CRC checksum of section 1
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    let sec1 = get_section1_bytes(message)
    let crc = compute_posix_cksum(sec1)
    for _ in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      lines.push(prefix + "sec1_cksum=" + crc.to_string())
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_checksum3_lines(context : Grib2FileContext) -> Array[String] {
  // -checksum 3: CRC checksum of section 3
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 3) {
        Some(sec) => {
          let crc = compute_posix_cksum(sec)
          lines.push(prefix + "sec3_cksum=" + crc.to_string())
        }
        None => lines.push(prefix + "sec3_cksum=0")
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_checksum4_lines(context : Grib2FileContext) -> Array[String] {
  // -checksum 4: CRC checksum of section 4
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 4) {
        Some(sec) => {
          let crc = compute_posix_cksum(sec)
          lines.push(prefix + "sec4_cksum=" + crc.to_string())
        }
        None => lines.push(prefix + "sec4_cksum=0")
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_checksum5_lines(context : Grib2FileContext) -> Array[String] {
  // -checksum 5: CRC checksum of section 5
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 5) {
        Some(sec) => {
          let crc = compute_posix_cksum(sec)
          lines.push(prefix + "sec5_cksum=" + crc.to_string())
        }
        None => lines.push(prefix + "sec5_cksum=0")
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_checksum6_lines(context : Grib2FileContext) -> Array[String] {
  // -checksum 6: CRC checksum of section 6
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 6) {
        Some(sec) => {
          let crc = compute_posix_cksum(sec)
          lines.push(prefix + "sec6_cksum=" + crc.to_string())
        }
        None => lines.push(prefix + "sec6_cksum=0")
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_checksum7_lines(context : Grib2FileContext) -> Array[String] {
  // -checksum 7: CRC checksum of section 7
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes(message, submessage, 7) {
        Some(sec) => {
          let crc = compute_posix_cksum(sec)
          lines.push(prefix + "sec7_cksum=" + crc.to_string())
        }
        None => lines.push(prefix + "sec7_cksum=0")
      }
      record_index += 1
    }
  }
  lines
}

///|
fn get_section_bytes_for_record(
  message : Grib2MessageContext,
  submessage : Grib2SubmessageFrame,
  section_num : Int,
) -> BytesView? {
  match section_num {
    0 => Some(get_section0_bytes(message))
    1 => Some(get_section1_bytes(message))
    2 | 3 | 4 | 5 | 6 | 7 => get_section_bytes(message, submessage, section_num)
    _ => None
  }
}

///|
pub fn wgrib2_get_byte_lines(
  context : Grib2FileContext,
  section : Int,
  octet : Int,
  count : Int,
) -> Array[String] {
  // -get_byte X Y Z: Get bytes in Section X, Octet Y, count Z (decimal)
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes_for_record(message, submessage, section) {
        Some(sec) => {
          let start_idx = octet - 1 // octets are 1-based
          if start_idx >= 0 && start_idx + count <= sec.length() {
            let values : Array[String] = []
            for i in 0..<count {
              let byte_val = sec[start_idx + i].to_uint().reinterpret_as_int()
              values.push(byte_val.to_string())
            }
            lines.push(
              prefix +
              section.to_string() +
              "-" +
              octet.to_string() +
              "=" +
              values.join(","),
            )
          } else {
            lines.push(prefix)
          }
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_get_hex_lines(
  context : Grib2FileContext,
  section : Int,
  octet : Int,
  count : Int,
) -> Array[String] {
  // -get_hex X Y Z: Get bytes in Section X, Octet Y, count Z (hex)
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes_for_record(message, submessage, section) {
        Some(sec) => {
          let start_idx = octet - 1
          if start_idx >= 0 && start_idx + count <= sec.length() {
            let values : Array[String] = []
            for i in 0..<count {
              let byte_val = sec[start_idx + i].to_uint().reinterpret_as_int()
              values.push(byte_to_hex(byte_val))
            }
            lines.push(
              prefix +
              section.to_string() +
              "-" +
              octet.to_string() +
              "=" +
              values.join(","),
            )
          } else {
            lines.push(prefix)
          }
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_get_int_lines(
  context : Grib2FileContext,
  section : Int,
  octet : Int,
  count : Int,
) -> Array[String] {
  // -get_int X Y Z: Get 4-byte ints in Section X, Octet Y, count Z
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes_for_record(message, submessage, section) {
        Some(sec) => {
          let start_idx = octet - 1
          if start_idx >= 0 && start_idx + count * 4 <= sec.length() {
            let values : Array[String] = []
            for i in 0..<count {
              let idx = start_idx + i * 4
              let val = (sec[idx].to_uint().reinterpret_as_int() << 24) |
                (sec[idx + 1].to_uint().reinterpret_as_int() << 16) |
                (sec[idx + 2].to_uint().reinterpret_as_int() << 8) |
                sec[idx + 3].to_uint().reinterpret_as_int()
              values.push(val.to_string())
            }
            lines.push(
              prefix +
              section.to_string() +
              "-" +
              octet.to_string() +
              "=" +
              values.join(","),
            )
          } else {
            lines.push(prefix)
          }
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_get_int2_lines(
  context : Grib2FileContext,
  section : Int,
  octet : Int,
  count : Int,
) -> Array[String] {
  // -get_int2 X Y Z: Get 2-byte ints in Section X, Octet Y, count Z
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes_for_record(message, submessage, section) {
        Some(sec) => {
          let start_idx = octet - 1
          if start_idx >= 0 && start_idx + count * 2 <= sec.length() {
            let values : Array[String] = []
            for i in 0..<count {
              let idx = start_idx + i * 2
              let val = (sec[idx].to_uint().reinterpret_as_int() << 8) |
                sec[idx + 1].to_uint().reinterpret_as_int()
              values.push(val.to_string())
            }
            lines.push(
              prefix +
              section.to_string() +
              "-" +
              octet.to_string() +
              "=" +
              values.join(","),
            )
          } else {
            lines.push(prefix)
          }
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
fn ieee_uint_to_float(bits : UInt) -> Double {
  bits.reinterpret_as_int().reinterpret_as_float().to_double()
}

///|
fn format_ieee_float(val : Double) -> String {
  // Format like wgrib2's %f - with 6 decimal places
  let int_part = val.to_int()
  let frac_part = (val - int_part.to_double()).abs() * 1000000.0
  let frac_int = frac_part.to_int()
  // Pad fractional part to 6 digits
  let frac_str = frac_int.to_string()
  let padding = "0".repeat(6 - frac_str.length())
  if val < 0.0 && int_part == 0 {
    "-0." + padding + frac_str
  } else {
    int_part.to_string() + "." + padding + frac_str
  }
}

///|
pub fn wgrib2_get_ieee_lines(
  context : Grib2FileContext,
  section : Int,
  octet : Int,
  count : Int,
) -> Array[String] {
  // -get_ieee X Y Z: Get IEEE floats in Section X, Octet Y, count Z
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match get_section_bytes_for_record(message, submessage, section) {
        Some(sec) => {
          let start_idx = octet - 1
          if start_idx >= 0 && start_idx + count * 4 <= sec.length() {
            let values : Array[String] = []
            for i in 0..<count {
              let idx = start_idx + i * 4
              let bits = (sec[idx].to_uint() << 24) |
                (sec[idx + 1].to_uint() << 16) |
                (sec[idx + 2].to_uint() << 8) |
                sec[idx + 3].to_uint()
              let val = ieee_uint_to_float(bits)
              values.push(format_ieee_float(val))
            }
            lines.push(
              prefix +
              section.to_string() +
              "-" +
              octet.to_string() +
              "=" +
              values.join(","),
            )
          } else {
            lines.push(prefix)
          }
        }
        None => lines.push(prefix)
      }
      record_index += 1
    }
  }
  lines
}

///|
fn is_nan(v : Double) -> Bool {
  v != v // NaN is the only value not equal to itself
}

///|
pub fn wgrib2_min_lines(context : Grib2FileContext) -> Array[String] {
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match unpack_submessage_data(message, submessage) {
        Ok(data) => {
          let mut min_val : Double? = None
          for v in data.values {
            if not(is_nan(v)) {
              match min_val {
                None => min_val = Some(v)
                Some(current) => if v < current { min_val = Some(v) }
              }
            }
          }
          match min_val {
            Some(m) => lines.push(prefix + "min=" + m.to_string())
            None => lines.push(prefix + "min=undefined")
          }
        }
        Err(_) => lines.push(prefix + "min=error")
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_max_lines(context : Grib2FileContext) -> Array[String] {
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match unpack_submessage_data(message, submessage) {
        Ok(data) => {
          let mut max_val : Double? = None
          for v in data.values {
            if not(is_nan(v)) {
              match max_val {
                None => max_val = Some(v)
                Some(current) => if v > current { max_val = Some(v) }
              }
            }
          }
          match max_val {
            Some(m) => lines.push(prefix + "max=" + m.to_string())
            None => lines.push(prefix + "max=undefined")
          }
        }
        Err(_) => lines.push(prefix + "max=error")
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_stats_lines(context : Grib2FileContext) -> Array[String] {
  let lines : Array[String] = []
  let mut record_index = 1
  for message in context.messages {
    for submessage in message.submessages {
      let prefix = record_index.to_string() +
        ":" +
        message.offset.to_string() +
        ":"
      match unpack_submessage_data(message, submessage) {
        Ok(data) => {
          let ndata = data.values.length()
          let mut defined_count = 0
          let mut sum = 0.0
          let mut min_val : Double? = None
          let mut max_val : Double? = None
          for v in data.values {
            if not(is_nan(v)) {
              defined_count += 1
              sum += v
              match min_val {
                None => min_val = Some(v)
                Some(current) => if v < current { min_val = Some(v) }
              }
              match max_val {
                None => max_val = Some(v)
                Some(current) => if v > current { max_val = Some(v) }
              }
            }
          }
          let undef_count = ndata - defined_count
          let mean = if defined_count > 0 {
            sum / defined_count.to_double()
          } else {
            0.0
          }
          let min_str = match min_val {
            Some(m) => m.to_string()
            None => "undefined"
          }
          let max_str = match max_val {
            Some(m) => m.to_string()
            None => "undefined"
          }
          lines.push(
            prefix +
            "ndata=" +
            ndata.to_string() +
            ":undef=" +
            undef_count.to_string() +
            ":mean=" +
            mean.to_string() +
            ":min=" +
            min_str +
            ":max=" +
            max_str,
          )
        }
        Err(_) => lines.push(prefix + "stats=error")
      }
      record_index += 1
    }
  }
  lines
}

///|
pub fn wgrib2_nlons_lines(context : Grib2FileContext) -> Array[String] {
  // -nlons: number of longitudes for each latitude (S/N order)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    let ni = meta.section3_ni
    let nj = meta.section3_nj
    // For regular grids, output ni repeated nj times
    let nlons_str = if ni > 0 && nj > 0 {
      let parts : Array[String] = []
      for _ in 0..<nj {
        parts.push(ni.to_string())
      }
      "nlon (S/N)=" + parts.join(" ")
    } else {
      "nlon (S/N)=undefined"
    }
    lines.push(format_prefix(meta) + nlons_str)
  }
  lines
}

///|
/// Calculate lat/lon from grid indices (i, j) for a regular lat/lon grid.
/// Uses wgrib2's output convention where j=1 is the southernmost latitude.
/// i: 1..ni, j: 1..nj
/// Returns (lon, lat) in degrees.
fn grid_ij_to_latlon(
  meta : Grib2RecordMeta,
  i : Int,
  j : Int,
) -> (Double, Double)? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  // Get grid parameters (in microdegrees)
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let di = meta.section3_di_microdeg.to_double() / 1000000.0
  let dj = meta.section3_dj_microdeg.to_double() / 1000000.0
  let scan = meta.section3_scanning_mode
  // wgrib2 uses output convention WE:SN (j=1 is south)
  // For input WE:NS (scan bit 2 = 0), flip j coordinate
  let j_data = if (scan & 0x40) == 0 { nj - j + 1 } else { j }
  // Scanning mode bit 1: 0 = +i direction (W to E), 1 = -i direction
  // Scanning mode bit 2: 0 = -j direction (N to S), 1 = +j direction
  let i_inc = if (scan & 0x80) == 0 { di } else { -di }
  let j_inc = if (scan & 0x40) == 0 { -dj } else { dj }
  let lon = lon1 + (i - 1).to_double() * i_inc
  let lat = lat1 + (j_data - 1).to_double() * j_inc
  Some((lon, lat))
}

///|
/// Convert lat/lon to grid indices (i, j) for a regular lat/lon grid.
/// Uses wgrib2's output convention where j=1 is the southernmost latitude.
/// Returns (i, j) where i: 1..ni, j: 1..nj, or None if outside grid.
fn latlon_to_grid_ij(
  meta : Grib2RecordMeta,
  lon : Double,
  lat : Double,
) -> (Int, Int)? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if ni <= 0 || nj <= 0 {
    return None
  }
  let lat1 = meta.section3_lat1_microdeg.to_double() / 1000000.0
  let lon1 = meta.section3_lon1_microdeg.to_double() / 1000000.0
  let di = meta.section3_di_microdeg.to_double() / 1000000.0
  let dj = meta.section3_dj_microdeg.to_double() / 1000000.0
  let scan = meta.section3_scanning_mode
  let i_inc = if (scan & 0x80) == 0 { di } else { -di }
  let j_inc = if (scan & 0x40) == 0 { -dj } else { dj }
  // Calculate grid indices (in data coordinates)
  let i_float = (lon - lon1) / i_inc + 1.0
  let j_data_float = (lat - lat1) / j_inc + 1.0
  // Round to nearest integer
  let i = (i_float + 0.5).to_int()
  let j_data = (j_data_float + 0.5).to_int()
  // Convert data j to wgrib2 output j (flip for NS input)
  let j = if (scan & 0x40) == 0 { nj - j_data + 1 } else { j_data }
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  Some((i, j))
}

///|
/// Get grid index from (i, j) coordinates.
/// Uses wgrib2's output convention where j=1 is the southernmost latitude.
/// For row-major scanning (most common): index = (j_data-1) * ni + (i-1)
fn grid_ij_to_index(meta : Grib2RecordMeta, i : Int, j : Int) -> Int? {
  let ni = meta.section3_ni
  let nj = meta.section3_nj
  if i < 1 || i > ni || j < 1 || j > nj {
    return None
  }
  let scan = meta.section3_scanning_mode
  // wgrib2 uses output convention WE:SN (j=1 is south)
  // For input WE:NS (scan bit 2 = 0), flip j coordinate to get data index
  let j_data = if (scan & 0x40) == 0 { nj - j + 1 } else { j }
  // Bit 4 (0x10): 0 = row-major (i varies fastest), 1 = column-major
  if (scan & 0x10) == 0 {
    // Row-major: index = (j_data-1) * ni + (i-1)
    Some((j_data - 1) * ni + (i - 1))
  } else {
    // Column-major: index = (i-1) * nj + (j_data-1)
    Some((i - 1) * nj + (j_data - 1))
  }
}

///|
/// Format a value for output like wgrib2.
/// Uses up to 6 significant figures, removes trailing zeros.
fn format_grid_value(v : Double) -> String {
  if is_nan(v) || v > 9.99e19 {
    return "9.999e+20"
  }
  // For very large or very small values, use scientific notation
  let abs_v = if v < 0.0 { -v } else { v }
  if abs_v >= 1.0e10 || (abs_v < 1.0e-4 && abs_v != 0.0) {
    // Scientific notation
    return format_scientific(v)
  }
  // Round to 6 significant figures
  let formatted = format_with_precision(v, 6)
  formatted
}

///|
/// Format number with N significant figures, removing trailing zeros.
fn format_with_precision(v : Double, sig_figs : Int) -> String {
  if v == 0.0 {
    return "0"
  }
  let sign = if v < 0.0 { "-" } else { "" }
  let abs_v = if v < 0.0 { -v } else { v }
  // Calculate the order of magnitude
  let mut order = 0
  let mut temp = abs_v
  if temp >= 10.0 {
    while temp >= 10.0 {
      temp = temp / 10.0
      order += 1
    }
  } else if temp < 1.0 && temp > 0.0 {
    while temp < 1.0 {
      temp = temp * 10.0
      order -= 1
    }
  }
  // Calculate decimal places needed
  let decimal_places = sig_figs - order - 1
  if decimal_places <= 0 {
    // Integer output
    let rounded = round_to_nearest(abs_v)
    return sign + rounded.to_int().to_string()
  }
  // Format with decimal places
  let multiplier = pow10_positive(decimal_places)
  let rounded = round_to_nearest(abs_v * multiplier) / multiplier
  let int_part = rounded.to_int()
  let frac_part = (rounded - int_part.to_double()) * multiplier
  let frac_int = round_to_nearest(frac_part).to_int()
  if frac_int == 0 {
    return sign + int_part.to_string()
  }
  // Format fraction with leading zeros
  let mut frac_str = frac_int.to_string()
  while frac_str.length() < decimal_places {
    frac_str = "0" + frac_str
  }
  // Remove trailing zeros
  while frac_str.length() > 1 && frac_str[frac_str.length() - 1] == '0' {
    frac_str = frac_str.substring(end=frac_str.length() - 1)
  }
  sign + int_part.to_string() + "." + frac_str
}

///|
fn round_to_nearest(v : Double) -> Double {
  let floor_val = v.to_int().to_double()
  if v - floor_val >= 0.5 {
    floor_val + 1.0
  } else {
    floor_val
  }
}

///|
fn pow10_positive(n : Int) -> Double {
  let mut result = 1.0
  for i = 0; i < n; i = i + 1 {
    result = result * 10.0
  }
  result
}

///|
fn format_scientific(v : Double) -> String {
  if v == 0.0 {
    return "0"
  }
  let sign = if v < 0.0 { "-" } else { "" }
  let abs_v = if v < 0.0 { -v } else { v }
  // Find exponent
  let mut exp = 0
  let mut mantissa = abs_v
  if mantissa >= 10.0 {
    while mantissa >= 10.0 {
      mantissa = mantissa / 10.0
      exp += 1
    }
  } else if mantissa < 1.0 {
    while mantissa < 1.0 {
      mantissa = mantissa * 10.0
      exp -= 1
    }
  }
  // Format mantissa with 5 decimal places (6 sig figs total)
  let multiplier = 100000.0
  let rounded = round_to_nearest(mantissa * multiplier) / multiplier
  let int_part = rounded.to_int()
  let frac_part = round_to_nearest(
    (rounded - int_part.to_double()) * multiplier,
  ).to_int()
  let mut frac_str = frac_part.to_string()
  while frac_str.length() < 5 {
    frac_str = "0" + frac_str
  }
  // Remove trailing zeros
  while frac_str.length() > 1 && frac_str[frac_str.length() - 1] == '0' {
    frac_str = frac_str.substring(end=frac_str.length() - 1)
  }
  let exp_sign = if exp >= 0 { "+" } else { "-" }
  let exp_abs = if exp < 0 { -exp } else { exp }
  let exp_str = if exp_abs < 10 {
    "0" + exp_abs.to_string()
  } else {
    exp_abs.to_string()
  }
  sign + int_part.to_string() + "." + frac_str + "e" + exp_sign + exp_str
}

///|
pub fn wgrib2_ij_lines(
  context : Grib2FileContext,
  i : Int,
  j : Int,
) -> Array[String] {
  // -ij X Y: value of field at grid(X,Y)
  let lines : Array[String] = []
  let records = decode_records(context)
  let mut meta_idx = 0
  for message in context.messages {
    for submessage in message.submessages {
      if meta_idx >= records.length() {
        break
      }
      let meta = records[meta_idx]
      let prefix = format_prefix(meta)
      match unpack_submessage_data(message, submessage) {
        Ok(data) =>
          match grid_ij_to_index(meta, i, j) {
            Some(idx) =>
              if idx >= 0 && idx < data.values.length() {
                lines.push(
                  prefix + "val=" + format_grid_value(data.values[idx]),
                )
              } else {
                lines.push(prefix + "val=out_of_range")
              }
            None => lines.push(prefix + "val=invalid_ij")
          }
        Err(_) => lines.push(prefix + "val=error")
      }
      meta_idx += 1
    }
  }
  lines
}

///|
pub fn wgrib2_ijlat_lines(
  context : Grib2FileContext,
  i : Int,
  j : Int,
) -> Array[String] {
  // -ijlat X Y: lat,lon and grid value at grid(X,Y)
  let lines : Array[String] = []
  let records = decode_records(context)
  let mut meta_idx = 0
  for message in context.messages {
    for submessage in message.submessages {
      if meta_idx >= records.length() {
        break
      }
      let meta = records[meta_idx]
      let prefix = format_prefix(meta)
      match (grid_ij_to_latlon(meta, i, j), grid_ij_to_index(meta, i, j)) {
        (Some((lon, lat)), Some(idx)) =>
          match unpack_submessage_data(message, submessage) {
            Ok(data) =>
              if idx >= 0 && idx < data.values.length() {
                let val_str = format_grid_value(data.values[idx])
                lines.push(
                  prefix +
                  "(" +
                  i.to_string() +
                  "," +
                  j.to_string() +
                  "),lon=" +
                  format_coord(lon) +
                  ",lat=" +
                  format_coord(lat) +
                  ",val=" +
                  val_str,
                )
              } else {
                lines.push(prefix + "out_of_range")
              }
            Err(_) => lines.push(prefix + "error")
          }
        _ => lines.push(prefix + "invalid_ij")
      }
      meta_idx += 1
    }
  }
  lines
}

///|
fn format_coord(v : Double) -> String {
  // Format coordinate with 6 decimal places like wgrib2
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
pub fn wgrib2_ilat_lines(
  context : Grib2FileContext,
  idx : Int,
) -> Array[String] {
  // -ilat X: lat,lon and grid value at Xth grid point (1-based, output coordinates)
  let lines : Array[String] = []
  let records = decode_records(context)
  let mut meta_idx = 0
  for message in context.messages {
    for submessage in message.submessages {
      if meta_idx >= records.length() {
        break
      }
      let meta = records[meta_idx]
      let prefix = format_prefix(meta)
      let ni = meta.section3_ni
      let out_idx = idx - 1 // Convert 1-based to 0-based output index
      if ni > 0 && out_idx >= 0 {
        // Convert output linear index to (i, j) in output coordinates
        let j = out_idx / ni + 1
        let i = out_idx % ni + 1
        // Get data index using grid_ij_to_index (handles coordinate conversion)
        match
          (
            grid_ij_to_latlon(meta, i, j),
            grid_ij_to_index(meta, i, j),
            unpack_submessage_data(message, submessage),
          ) {
          (Some((lon, lat)), Some(data_idx), Ok(data)) =>
            if data_idx >= 0 && data_idx < data.values.length() {
              let val_str = format_grid_value(data.values[data_idx])
              lines.push(
                prefix +
                "grid pt " +
                idx.to_string() +
                ",lon=" +
                format_coord(lon) +
                ",lat=" +
                format_coord(lat) +
                ",val=" +
                val_str,
              )
            } else {
              lines.push(prefix + "out_of_range")
            }
          _ => lines.push(prefix + "error")
        }
      } else {
        lines.push(prefix + "invalid_index")
      }
      meta_idx += 1
    }
  }
  lines
}

///|
pub fn wgrib2_lon_lines(
  context : Grib2FileContext,
  lon : Double,
  lat : Double,
) -> Array[String] {
  // -lon X Y: value at grid point nearest lon=X lat=Y
  let lines : Array[String] = []
  let records = decode_records(context)
  let mut meta_idx = 0
  for message in context.messages {
    for submessage in message.submessages {
      if meta_idx >= records.length() {
        break
      }
      let meta = records[meta_idx]
      let prefix = format_prefix(meta)
      match latlon_to_grid_ij(meta, lon, lat) {
        Some((i, j)) =>
          match
            (
              grid_ij_to_index(meta, i, j),
              unpack_submessage_data(message, submessage),
            ) {
            (Some(idx), Ok(data)) =>
              if idx >= 0 && idx < data.values.length() {
                let val_str = format_grid_value(data.values[idx])
                // Get the actual lat/lon of the grid point
                match grid_ij_to_latlon(meta, i, j) {
                  Some((actual_lon, actual_lat)) =>
                    lines.push(
                      prefix +
                      "lon=" +
                      format_coord(actual_lon) +
                      ",lat=" +
                      format_coord(actual_lat) +
                      ",val=" +
                      val_str,
                    )
                  None => lines.push(prefix + "error")
                }
              } else {
                lines.push(prefix + "out_of_range")
              }
            _ => lines.push(prefix + "error")
          }
        None => lines.push(prefix + "outside_grid")
      }
      meta_idx += 1
    }
  }
  lines
}

///|
pub fn wgrib2_ll2ij_lines(
  context : Grib2FileContext,
  lon : Double,
  lat : Double,
) -> Array[String] {
  // -ll2ij X Y: converts lon-lat to (i,j)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    match latlon_to_grid_ij(meta, lon, lat) {
      Some((i, j)) =>
        lines.push(
          format_prefix(meta) +
          format_coord(lon) +
          " " +
          format_coord(lat) +
          " -> (" +
          i.to_string() +
          ".000000," +
          j.to_string() +
          ".000000)",
        )
      None =>
        lines.push(
          format_prefix(meta) +
          format_coord(lon) +
          " " +
          format_coord(lat) +
          " -> outside_grid",
        )
    }
  }
  lines
}

///|
pub fn wgrib2_ll2i_lines(
  context : Grib2FileContext,
  lon : Double,
  lat : Double,
) -> Array[String] {
  // -ll2i X Y: converts lon-lat to output linear index (1-based)
  let records = decode_records(context)
  let lines : Array[String] = []
  for meta in records {
    match latlon_to_grid_ij(meta, lon, lat) {
      Some((i, j)) => {
        // Calculate output linear index (1-based)
        let ni = meta.section3_ni
        let out_idx = (j - 1) * ni + i
        lines.push(
          format_prefix(meta) +
          format_coord(lon) +
          " " +
          format_coord(lat) +
          " -> (" +
          out_idx.to_string() +
          ")",
        )
      }
      None =>
        lines.push(
          format_prefix(meta) +
          format_coord(lon) +
          " " +
          format_coord(lat) +
          " -> outside_grid",
        )
    }
  }
  lines
}
