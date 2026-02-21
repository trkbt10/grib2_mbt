///|
fn format_prefix(meta : Grib2RecordMeta) -> String {
  meta.record_id + ":" + meta.message_offset.to_string() + ":"
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
pub fn inventory_lines(context : Grib2FileContext) -> Array[String] {
  wgrib2_s_lines(context)
}

///|
pub fn sec0_lines(context : Grib2FileContext) -> Array[String] {
  wgrib2_sec0_lines(context)
}
