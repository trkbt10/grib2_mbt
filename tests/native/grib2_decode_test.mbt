///|
fn all_records_have_section5_template(
  records : Array[@lib.Grib2RecordMeta],
  expected_id : Int,
) -> Bool {
  let mut ok = true
  for record in records {
    if record.section5_template.id() != expected_id {
      ok = false
    }
  }
  ok
}

///|
fn unpack_all_submessages(
  context : @lib.Grib2FileContext,
) -> Result[Int, String] {
  let mut ok_count = 0
  for message in context.messages {
    for submessage in message.submessages {
      match @lib.unpack_submessage_data(message, submessage) {
        Ok(unpacked) => {
          if unpacked.values.length() <= 0 || unpacked.num_points <= 0 {
            return Err("unexpected empty unpacked result")
          }
          ok_count += 1
        }
        Err(error) =>
          match error {
            @lib.UnpackError::UnsupportedTemplate(s) =>
              return Err("UnsupportedTemplate: " + s)
            @lib.UnpackError::InsufficientData(s) =>
              return Err("InsufficientData: " + s)
            @lib.UnpackError::InvalidBitsPerValue(s) =>
              return Err("InvalidBitsPerValue: " + s)
          }
      }
    }
  }
  Ok(ok_count)
}

///|
fn decode_fixture_context(
  path : String,
) -> Result[@lib.Grib2FileContext, String] {
  @grib2support.grib2_fixture_context_parse(path)
}

///|
fn derived_fixture_path(file_name : String) -> String {
  "fixtures/grib2_derived/" + file_name
}

///|
fn unpack_flat_record(
  context : @lib.Grib2FileContext,
  record_number : Int,
) -> Result[@lib.UnpackedGridData, String] {
  if record_number <= 0 {
    return Err("record number must be positive")
  }
  let mut current = 1
  for message in context.messages {
    for submessage in message.submessages {
      if current == record_number {
        match @lib.unpack_submessage_data(message, submessage) {
          Ok(data) => return Ok(data)
          Err(error) =>
            match error {
              @lib.UnpackError::UnsupportedTemplate(s) =>
                return Err("UnsupportedTemplate: " + s)
              @lib.UnpackError::InsufficientData(s) =>
                return Err("InsufficientData: " + s)
              @lib.UnpackError::InvalidBitsPerValue(s) =>
                return Err("InvalidBitsPerValue: " + s)
            }
        }
      }
      current += 1
    }
  }
  Err("record not found: " + record_number.to_string())
}

///|
fn is_nan(value : Double) -> Bool {
  value != value
}

///|
fn close_enough(actual : Double, expected : Double, eps : Double) -> Bool {
  (actual - expected).abs() <= eps
}

///|
fn values_prefix_matches(
  actual : Array[Double],
  expected : Array[Double],
  eps : Double,
) -> Bool {
  if actual.length() < expected.length() {
    return false
  }
  for i in 0..<expected.length() {
    if !close_enough(actual[i], expected[i], eps) {
      return false
    }
  }
  true
}

///|
fn unpacked_stats(values : Array[Double]) -> (Double, Double, Double) {
  let mut min_val = values[0]
  let mut max_val = values[0]
  let mut sum = 0.0
  for value in values {
    sum += value
    if value < min_val {
      min_val = value
    }
    if value > max_val {
      max_val = value
    }
  }
  (min_val, max_val, sum / values.length().to_double())
}

///|
fn unpacked_defined_stats(
  values : Array[Double],
) -> (Int, Double, Double, Double) {
  let mut undef_count = 0
  let mut found_defined = false
  let mut min_val = 0.0
  let mut max_val = 0.0
  let mut sum = 0.0
  let mut count = 0
  for value in values {
    if is_nan(value) {
      undef_count += 1
    } else {
      if !found_defined {
        min_val = value
        max_val = value
        found_defined = true
      }
      sum += value
      count += 1
      if value < min_val {
        min_val = value
      }
      if value > max_val {
        max_val = value
      }
    }
  }
  (undef_count, min_val, max_val, sum / count.to_double())
}

///|
test "decode records exposes context fields" {
  let context = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let records = @lib.decode_records(context)
  inspect(records.length(), content="19")
  inspect(records[0].record_id, content="1")
  inspect(records[0].reference_time, content="2026022100")
  inspect(records[0].parameter_name.display(), content="WIND")
  inspect(records[0].level_name.display(), content="surface")
}

///|
test "template dispatch foundation: fixture templates" {
  let context = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let records = @lib.decode_records(context)
  inspect(records[0].section3_template.id(), content="0")
  inspect(records[0].section4_template.id(), content="0")
  inspect(records[0].section5_template.id(), content="3")
  inspect(records[0].section3_template.is_known(), content="true")
  inspect(records[0].section4_template.is_known(), content="true")
  inspect(records[0].section5_template.is_known(), content="true")
}

///|
test "template dispatch foundation: eccodes jpeg2000 fixtures" {
  let context1 = match
    decode_fixture_context(@grib2support.grib2_fixture_path_eccodes_jpeg()) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let records1 = @lib.decode_records(context1)
  inspect(records1.length() > 0, content="true")
  inspect(records1[0].section5_template.id(), content="40")
  inspect(records1[0].section5_template.is_known(), content="true")
  let context2 = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let records2 = @lib.decode_records(context2)
  inspect(records2.length() > 0, content="true")
  inspect(records2[0].section5_template.id(), content="40")
  inspect(records2[0].section5_template.is_known(), content="true")
}

///|
test "template dispatch foundation: eccodes jpeg2000 all records are template40" {
  let context1 = match
    decode_fixture_context(@grib2support.grib2_fixture_path_eccodes_jpeg()) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let records1 = @lib.decode_records(context1)
  inspect(all_records_have_section5_template(records1, 40), content="true")
  let context2 = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let records2 = @lib.decode_records(context2)
  inspect(all_records_have_section5_template(records2, 40), content="true")
}

///|
test "jpeg2000 fixture unpack path succeeds" {
  let parsed = match
    decode_fixture_context(@grib2support.grib2_fixture_path_eccodes_jpeg()) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let message = parsed.messages[0]
  let submessage = message.submessages[0]
  match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => {
      inspect(v.num_points > 0, content="true")
      inspect(v.values.length() > 0, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "jpeg2000 reduced gaussian fixture unpack path succeeds" {
  let parsed = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let message = parsed.messages[0]
  let submessage = message.submessages[0]
  match @lib.unpack_submessage_data(message, submessage) {
    Ok(v) => {
      inspect(v.num_points > 0, content="true")
      inspect(v.values.length() > 0, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "jpeg2000 eccodes fixture first message matches wgrib2 binary output" {
  let parsed = match
    decode_fixture_context(@grib2support.grib2_fixture_path_eccodes_jpeg()) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let message = parsed.messages[0]
  let submessage = message.submessages[0]
  match @lib.unpack_submessage_data(message, submessage) {
    Ok(data) => {
      inspect(data.num_points, content="65160")
      inspect(data.values.length(), content="65160")
      let (min_val, max_val, mean_val) = unpacked_stats(data.values)
      inspect(
        close_enough(data.values[0], 101456.0, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(data.values[1], 101456.0, 0.000000001),
        content="true",
      )
      inspect(close_enough(min_val, 95224.0, 0.000000001), content="true")
      inspect(close_enough(max_val, 103498.0, 0.000000001), content="true")
      inspect(
        close_enough(mean_val, 101089.22363413137, 0.000001),
        content="true",
      )
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "jpeg2000 reduced gaussian fixture first message matches wgrib2 raw order" {
  let parsed = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let message = parsed.messages[0]
  let submessage = message.submessages[0]
  match @lib.unpack_submessage_data(message, submessage) {
    Ok(data) => {
      inspect(data.num_points, content="6114")
      inspect(data.values.length(), content="6114")
      let (min_val, max_val, mean_val) = unpacked_stats(data.values)
      inspect(
        close_enough(data.values[0], 217.3645703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(data.values[1], 215.5545703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(data.values[19], 218.2745703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(data.values[20], 219.9045703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(data.values[6110], 250.7645703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(data.values[6111], 253.0045703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(data.values[6112], 255.3445703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(data.values[6113], 257.2745703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(min_val, 210.2545703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(max_val, 317.4845703125, 0.000000001),
        content="true",
      )
      inspect(
        close_enough(mean_val, 285.34226740114923, 0.000001),
        content="true",
      )
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "jpeg2000 stats lines use wgrib2-style rounded formatting" {
  let jpeg = match
    decode_fixture_context(@grib2support.grib2_fixture_path_eccodes_jpeg()) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let jpeg_stats = @lib.wgrib2_stats_lines(jpeg)
  inspect(
    jpeg_stats[0],
    content="1:0:ndata=65160:undef=0:mean=101089:min=95224:max=103498:cos_wt_mean=101104",
  )
  let reduced = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let reduced_stats = @lib.wgrib2_stats_lines(reduced)
  inspect(
    reduced_stats[0],
    content="1:0:ndata=6114:undef=0:mean=285.342:min=210.255:max=317.485:cos_wt_mean=290.699",
  )
  let gfswave = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let gfswave_stats = @lib.wgrib2_stats_lines(gfswave)
  inspect(
    gfswave_stats[6],
    content="7:242905:ndata=99631:undef=70212:mean=111.369:min=0:max=360:cos_wt_mean=110.174",
  )
}

///|
test "jpeg2000 eccodes fixture all submessages unpack" {
  let parsed = match
    decode_fixture_context(@grib2support.grib2_fixture_path_eccodes_jpeg()) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  match unpack_all_submessages(parsed) {
    Ok(count) => inspect(count > 0, content="true")
    Err(msg) => fail(msg)
  }
}

///|
test "jpeg2000 reduced gaussian fixture all submessages unpack" {
  let parsed = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_eccodes_reduced_gaussian_surface_jpeg(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  match unpack_all_submessages(parsed) {
    Ok(count) => inspect(count > 0, content="true")
    Err(msg) => fail(msg)
  }
}

///|
test "gfswave jpeg2000 selected records preserve wgrib2-defined values" {
  let parsed = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_noaa_gfswave_atlocn_0p16_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let rec7 = match unpack_flat_record(parsed, 7) {
    Ok(data) => data
    Err(error) => fail(error)
  }
  inspect(rec7.num_points, content="99631")
  inspect(rec7.values.length(), content="99631")
  inspect(is_nan(rec7.values[0]), content="true")
  inspect(is_nan(rec7.values[99630]), content="true")
  let (undef7, min7, max7, mean7) = unpacked_defined_stats(rec7.values)
  inspect(undef7, content="70212")
  inspect(close_enough(min7, 0.0, 0.000000001), content="true")
  inspect(close_enough(max7, 360.0, 0.000000001), content="true")
  inspect(close_enough(mean7, 111.36929977225533, 0.000001), content="true")
  inspect(close_enough(rec7.values[11094], 18.51, 0.000000001), content="true")
  inspect(close_enough(rec7.values[11100], 359.91, 0.000000001), content="true")
  inspect(close_enough(rec7.values[81782], 277.42, 0.000000001), content="true")
  let rec18 = match unpack_flat_record(parsed, 18) {
    Ok(data) => data
    Err(error) => fail(error)
  }
  inspect(rec18.num_points, content="99631")
  inspect(rec18.values.length(), content="99631")
  inspect(is_nan(rec18.values[0]), content="true")
  inspect(is_nan(rec18.values[99630]), content="true")
  let (undef18, min18, max18, mean18) = unpacked_defined_stats(rec18.values)
  inspect(undef18, content="86145")
  inspect(close_enough(min18, 0.03, 0.000000001), content="true")
  inspect(close_enough(max18, 359.98, 0.000000001), content="true")
  inspect(close_enough(mean18, 107.39841613525108, 0.000001), content="true")
  inspect(close_enough(rec18.values[11397], 12.55, 0.000000001), content="true")
  inspect(close_enough(rec18.values[11400], 0.99, 0.000000001), content="true")
  inspect(
    close_enough(rec18.values[11701], 357.57, 0.000000001),
    content="true",
  )
  inspect(close_enough(rec18.values[82081], 232.4, 0.000000001), content="true")
}

///|
test "template 5.3 gfs pgrb2b first message unpacking" {
  let parsed = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let message = parsed.messages[0]
  let submessage = message.submessages[0]
  match @lib.unpack_submessage_data(message, submessage) {
    Ok(data) => {
      inspect(data.num_points, content="65160")
      inspect(data.values.length(), content="65160")
      // wgrib2 reference: first=48426.8, min=44934.2, max=48633.5
      inspect(
        data.values[0],
        content=(
          #|48426.82
        ),
      )
      inspect(
        data.values[1],
        content=(
          #|48426.82
        ),
      )
      let mut min_val = data.values[0]
      let mut max_val = data.values[0]
      for v in data.values {
        if v < min_val {
          min_val = v
        }
        if v > max_val {
          max_val = v
        }
      }
      // Note: these values match wgrib2's output (min=44934.2, max=48633.5)
      inspect(
        min_val,
        content=(
          #|44934.18
        ),
      )
      inspect(
        max_val,
        content=(
          #|48633.54
        ),
      )
    }
    Err(_) => fail("unpacking failed")
  }
}

///|
test "template 5.3 gfs pgrb2b stats lines match wgrib2 rounding" {
  let parsed = match
    decode_fixture_context(
      @grib2support.grib2_fixture_path_noaa_gfs_pgrb2b_1p00_f000(),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let stats = @lib.wgrib2_stats_lines(parsed)
  inspect(
    stats[5],
    content="6:233630:ndata=65160:undef=0:mean=2.76756e-07:min=-0.000221467:max=0.000407533:cos_wt_mean=-2.24904e-10",
  )
  inspect(
    stats[202],
    content="203:10068433:ndata=65160:undef=0:mean=0.10182:min=-50.6366:max=36.7834:cos_wt_mean=0.0788723",
  )
  inspect(
    stats[298],
    content="299:15453184:ndata=65160:undef=0:mean=0.00528821:min=2.88438e-05:max=0.0168832:cos_wt_mean=0.00719937",
  )
  inspect(
    stats[315],
    content="316:16800228:ndata=65160:undef=22907:mean=25126:min=5712.55:max=83971.8:cos_wt_mean=20338.8",
  )
}

///|
test "derived scan fixtures match wgrib2 scan labels in grid and scan outputs" {
  let scan32 = match
    decode_fixture_context(
      derived_fixture_path("noaa_gfs_pgrb2_scan32_record1.grib2"),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  inspect(
    @lib.wgrib2_flag_table_3_4_lines(scan32)[0],
    content="1:0:flag table 3.4=32 NS:WE",
  )
  inspect(
    @lib.wgrib2_scan_lines(scan32)[0],
    content="1:0:scan=2 input=NS:WE output=WE:SN",
  )
  inspect(
    @lib.wgrib2_grid_lines(scan32)[1],
    content="\tlat-lon grid:(360 x 181) units 1e-06 input NS:WE output WE:SN res 48",
  )

  let scan48 = match
    decode_fixture_context(
      derived_fixture_path("noaa_gfs_pgrb2_scan48_record1.grib2"),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  inspect(
    @lib.wgrib2_flag_table_3_4_lines(scan48)[0],
    content="1:0:flag table 3.4=48 NS(W|E)",
  )
  inspect(
    @lib.wgrib2_scan_lines(scan48)[0],
    content="1:0:scan=3 input=NS(W|E) output=WE:SN",
  )
  inspect(
    @lib.wgrib2_grid_lines(scan48)[1],
    content="\tlat-lon grid:(360 x 181) units 1e-06 input NS(W|E) output WE:SN res 48",
  )
}

///|
test "derived bitmap reuse fixture resolves Sec6 and bitmap like wgrib2" {
  let bitmap254 = match
    decode_fixture_context(
      derived_fixture_path("noaa_gfswave_global_bitmap254_records5_6.grib2"),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  inspect(
    @lib.wgrib2_sec6_lines(bitmap254)[0],
    content="1.1:0:Sec6 length 129786 bitmap indicator 0",
  )
  inspect(
    @lib.wgrib2_sec6_lines(bitmap254)[1],
    content="1.2:0:Sec6 length 129786 bitmap indicator 0",
  )
  inspect(
    @lib.wgrib2_bitmap_lines(bitmap254)[0],
    content="1.1:0:bitmap 451119 undef pts",
  )
  inspect(
    @lib.wgrib2_bitmap_lines(bitmap254)[1],
    content="1.2:0:bitmap 451119 undef pts",
  )
}

///|
test "derived scan48 fixture normalizes values to wgrib2 output order" {
  let parsed = match
    decode_fixture_context(
      derived_fixture_path("noaa_gfs_pgrb2_scan48_record1.grib2"),
    ) {
    Ok(context) => context
    Err(error) => fail(error)
  }
  let data = match unpack_flat_record(parsed, 1) {
    Ok(v) => v
    Err(error) => fail(error)
  }
  let expected : Array[Double] = [
    102136.0,
    102012.0,
    102284.0,
    101924.0,
    101940.0,
    101916.0,
    101380.0,
    101916.0,
  ]
  inspect(
    values_prefix_matches(data.values, expected, 0.000000001),
    content="true",
  )
}

///|
test "table lookup foundation: parameter and level known-unknown split" {
  inspect(
    @lib.decode_discipline_name(0).display(),
    content="Meteorological Products",
  )
  inspect(
    @lib.decode_discipline_name(10).display(),
    content="Oceanographic Products",
  )
  inspect(@lib.decode_discipline_name(42).display(), content="discipline=42")
  inspect(
    @lib.decode_master_table_version_name(0).display(),
    content="Experimental",
  )
  inspect(
    @lib.decode_master_table_version_name(1).display(),
    content="Operational",
  )
  inspect(
    @lib.decode_master_table_version_name(2).display(),
    content="Version 2",
  )
  inspect(
    @lib.decode_master_table_version_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_master_table_version_name(-1).display(),
    content="master_table_version=-1",
  )
  inspect(@lib.decode_local_table_version_name(0).display(), content="Not Used")
  inspect(
    @lib.decode_local_table_version_name(7).display(),
    content="Version 7",
  )
  inspect(
    @lib.decode_local_table_version_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_significance_of_reference_time_name(0).display(),
    content="Analysis",
  )
  inspect(
    @lib.decode_significance_of_reference_time_name(6).display(),
    content="Start of Data Assimilation",
  )
  inspect(
    @lib.decode_significance_of_reference_time_name(7).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_significance_of_reference_time_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_production_status_name(0).display(),
    content="Operational Products",
  )
  inspect(@lib.decode_production_status_name(16).display(), content="MLMIP")
  inspect(@lib.decode_production_status_name(190).display(), content="Reserved")
  inspect(
    @lib.decode_production_status_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_processed_data_type_name(0).display(),
    content="Analysis Products",
  )
  inspect(
    @lib.decode_processed_data_type_name(10).display(),
    content="ML Based Forecast",
  )
  inspect(
    @lib.decode_processed_data_type_name(192).display(),
    content="Experimental Products",
  )
  inspect(
    @lib.decode_processed_data_type_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_identification_template_number_name(0).display(),
    content="Calendar Definition",
  )
  inspect(
    @lib.decode_identification_template_number_name(2).display(),
    content="Calendar Definition and Paleontological Offset",
  )
  inspect(
    @lib.decode_identification_template_number_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_identification_template_number_name(40000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_identification_template_number_name(65535).display(),
    content="Missing",
  )
  inspect(@lib.decode_calendar_type_name(0).display(), content="Gregorian")
  inspect(
    @lib.decode_calendar_type_name(3).display(),
    content="Proleptic Gregorian",
  )
  inspect(@lib.decode_calendar_type_name(20).display(), content="Reserved")
  inspect(
    @lib.decode_calendar_type_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_grid_definition_source_name(0).display(),
    content="Specified in Table 3.1",
  )
  inspect(
    @lib.decode_grid_definition_source_name(1).display(),
    content="Predetermined Grid Definition",
  )
  inspect(
    @lib.decode_grid_definition_source_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_grid_definition_source_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_grid_definition_source_name(255).display(),
    content="Grid Definition Does Not Apply",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(0).display(),
    content="Latitude/Longitude",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(63).display(),
    content="Spectral Lambert Conformal with Modelling Subdomains",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(1200).display(),
    content="Time Section Grid",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(7).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(40000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_grid_definition_template_number_name(65535).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(0).display(),
    content="Spherical Earth (Radius 6367470.0 m)",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(5).display(),
    content="Earth Represented by WGS84",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(11).display(),
    content="Sun Spherical Reference System",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(20).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_shape_of_reference_system_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_resolution_and_component_flags_name(0).display(),
    content="i_increment=not_given,j_increment=not_given,vector_components=earth_relative",
  )
  inspect(
    @lib.decode_resolution_and_component_flags_name(56).display(),
    content="i_increment=given,j_increment=given,vector_components=grid_relative",
  )
  inspect(
    @lib.decode_scanning_mode_name(0).display(),
    content="i_scan=+i,j_scan=-j,adjacent_consecutive=i,row_scan=same,odd_i_offset=none,even_i_offset=none,j_offset=none,row_col_count=ni_nj",
  )
  inspect(
    @lib.decode_scanning_mode_name(193).display(),
    content="i_scan=-i,j_scan=+j,adjacent_consecutive=i,row_scan=same,odd_i_offset=none,even_i_offset=none,j_offset=none,row_col_count=reduced_when_offset",
  )
  inspect(
    @lib.decode_projection_center_name(0).display(),
    content="pole=north,projection=single_center",
  )
  inspect(
    @lib.decode_projection_center_name(192).display(),
    content="pole=south,projection=bi_polar_symmetric",
  )
  inspect(
    @lib.decode_spectral_data_representation_type_name(1).display(),
    content="Associated Legendre Functions",
  )
  inspect(
    @lib.decode_spectral_data_representation_type_name(2).display(),
    content="Bi-Fourier Representation",
  )
  inspect(
    @lib.decode_spectral_data_representation_mode_name(1).display(),
    content="Complex Coefficients Stored as Re/Im Pairs",
  )
  inspect(
    @lib.decode_spectral_data_representation_mode_name(200).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_spectral_data_representation_mode_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_grid_point_position_name(0).display(),
    content="Triangle Vertices",
  )
  inspect(
    @lib.decode_grid_point_position_name(5).display(),
    content="Midpoints of Shape Sides",
  )
  inspect(
    @lib.decode_grid_point_position_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_grid_point_position_name(200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_diamond_numbering_order_name(0).display(),
    content="orientation=clockwise",
  )
  inspect(
    @lib.decode_diamond_numbering_order_name(128).display(),
    content="orientation=counter_clockwise",
  )
  inspect(
    @lib.decode_diamond_scanning_mode_name(0).display(),
    content="i_scan=pole_to_equator,j_scan=west_to_east,adjacent_consecutive=i",
  )
  inspect(
    @lib.decode_diamond_scanning_mode_name(224).display(),
    content="i_scan=equator_to_pole,j_scan=east_to_west,adjacent_consecutive=j",
  )
  inspect(
    @lib.decode_section3_appended_list_interpretation_name(0).display(),
    content="No Appended List",
  )
  inspect(
    @lib.decode_section3_appended_list_interpretation_name(3).display(),
    content="Actual Latitudes for Each Row",
  )
  inspect(
    @lib.decode_section3_appended_list_interpretation_name(200).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_section3_appended_list_interpretation_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(0).display(),
    content="Template 4.0",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(254).display(),
    content="Template 4.254",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(1101).display(),
    content="Template 4.1101",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(52).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(40000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_product_definition_template_number_name(65535).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_generating_process_name(0).display(),
    content="Analysis",
  )
  inspect(
    @lib.decode_type_of_generating_process_name(23).display(),
    content="Anomaly",
  )
  inspect(
    @lib.decode_type_of_generating_process_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_generating_process_name(192).display(),
    content="Forecast Confidence Indicator",
  )
  inspect(
    @lib.decode_type_of_generating_process_name(198).display(),
    content="Post-Processed Deterministic-Expert-Weighted Forecast",
  )
  inspect(
    @lib.decode_type_of_generating_process_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_generating_process_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_generating_process_name(-1).display(),
    content="type_of_generating_process=-1",
  )
  inspect(
    @lib.decode_indicator_of_unit_of_time_range_name(0).display(),
    content="Minute",
  )
  inspect(
    @lib.decode_indicator_of_unit_of_time_range_name(13).display(),
    content="Second",
  )
  inspect(
    @lib.decode_indicator_of_unit_of_time_range_name(8).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_indicator_of_unit_of_time_range_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_indicator_of_unit_of_time_range_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_indicator_of_unit_of_time_range_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_indicator_of_unit_of_time_range_name(-1).display(),
    content="indicator_of_unit_of_time_range=-1",
  )
  inspect(
    @lib.decode_fixed_surface_type_name(1).display(),
    content="Ground or Water Surface",
  )
  inspect(
    @lib.decode_fixed_surface_type_name(109).display(),
    content="Potential Vorticity Surface",
  )
  inspect(
    @lib.decode_fixed_surface_type_name(150).display(),
    content="Generalized Vertical Height Coordinate",
  )
  inspect(
    @lib.decode_fixed_surface_type_name(191).display(),
    content="Abstract Level with no Vertical Localization",
  )
  inspect(@lib.decode_fixed_surface_type_name(0).display(), content="Reserved")
  inspect(@lib.decode_fixed_surface_type_name(28).display(), content="Reserved")
  inspect(
    @lib.decode_fixed_surface_type_name(200).display(),
    content="Entire atmosphere (considered as a single layer)",
  )
  inspect(
    @lib.decode_fixed_surface_type_name(235).display(),
    content="Ocean Isotherm Level (1/10 C)",
  )
  inspect(
    @lib.decode_fixed_surface_type_name(250).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_fixed_surface_type_name(255).display(), content="Missing")
  inspect(
    @lib.decode_fixed_surface_type_name(-1).display(),
    content="fixed_surface_type=-1",
  )
  inspect(
    @lib.decode_type_of_ensemble_forecast_name(0).display(),
    content="Unperturbed High-Resolution Control Forecast",
  )
  inspect(
    @lib.decode_type_of_ensemble_forecast_name(9).display(),
    content="Initial Conditions and Model Physics Perturbations",
  )
  inspect(
    @lib.decode_type_of_ensemble_forecast_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_ensemble_forecast_name(192).display(),
    content="Perturbed Ensemble Member",
  )
  inspect(
    @lib.decode_type_of_ensemble_forecast_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_ensemble_forecast_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_ensemble_forecast_name(-1).display(),
    content="type_of_ensemble_forecast=-1",
  )
  inspect(
    @lib.decode_derived_forecast_name(0).display(),
    content="Unweighted Mean of All Members",
  )
  inspect(
    @lib.decode_derived_forecast_name(10).display(),
    content="Variance of all ensemble members",
  )
  inspect(@lib.decode_derived_forecast_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_derived_forecast_name(192).display(),
    content="Unweighted Mode of All Members",
  )
  inspect(
    @lib.decode_derived_forecast_name(204).display(),
    content="Percentile value (95%) of All Members",
  )
  inspect(
    @lib.decode_derived_forecast_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_derived_forecast_name(255).display(), content="Missing")
  inspect(
    @lib.decode_derived_forecast_name(-1).display(),
    content="derived_forecast=-1",
  )
  inspect(
    @lib.decode_clustering_method_name(0).display(),
    content="Anomoly Correlation",
  )
  inspect(
    @lib.decode_clustering_method_name(1).display(),
    content="Root Mean Square",
  )
  inspect(@lib.decode_clustering_method_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_clustering_method_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_clustering_method_name(255).display(), content="Missing")
  inspect(
    @lib.decode_clustering_method_name(-1).display(),
    content="clustering_method=-1",
  )
  inspect(
    @lib.decode_probability_type_name(0).display(),
    content="Probability of event below lower limit",
  )
  inspect(
    @lib.decode_probability_type_name(10).display(),
    content="Probability of event within the quantile of the probability distribution function",
  )
  inspect(@lib.decode_probability_type_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_probability_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_probability_type_name(255).display(), content="Missing")
  inspect(
    @lib.decode_probability_type_name(-1).display(),
    content="probability_type=-1",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(0).display(),
    content="Average",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(13).display(),
    content="Median",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(50).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(100).display(),
    content="Severity",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(192).display(),
    content="Climatological Mean Value",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(209).display(),
    content="Coefficient",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_statistical_processing_name(-1).display(),
    content="type_of_statistical_processing=-1",
  )
  inspect(
    @lib.decode_type_of_time_intervals_name(1).display(),
    content="Successive times processed have same forecast time, start time of forecast is incremented",
  )
  inspect(
    @lib.decode_type_of_time_intervals_name(5).display(),
    content="Floating subinterval of time between forecast time and end of overall time interval",
  )
  inspect(
    @lib.decode_type_of_time_intervals_name(0).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_time_intervals_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_time_intervals_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_time_intervals_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_time_intervals_name(-1).display(),
    content="type_of_time_intervals=-1",
  )
  inspect(
    @lib.decode_operating_mode_name(0).display(),
    content="Maintenance Mode",
  )
  inspect(@lib.decode_operating_mode_name(2).display(), content="Precipitation")
  inspect(@lib.decode_operating_mode_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_operating_mode_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_operating_mode_name(255).display(), content="Missing")
  inspect(
    @lib.decode_operating_mode_name(-1).display(),
    content="operating_mode=-1",
  )
  inspect(
    @lib.decode_quality_control_indicator_name(0).display(),
    content="No Quality Control Applied",
  )
  inspect(
    @lib.decode_quality_control_indicator_name(1).display(),
    content="Quality Control Applied",
  )
  inspect(
    @lib.decode_quality_control_indicator_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_quality_control_indicator_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_quality_control_indicator_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_quality_control_indicator_name(-1).display(),
    content="quality_control_indicator=-1",
  )
  inspect(
    @lib.decode_clutter_filter_indicator_name(0).display(),
    content="No Clutter Filter Used",
  )
  inspect(
    @lib.decode_clutter_filter_indicator_name(1).display(),
    content="Clutter Filter Used",
  )
  inspect(
    @lib.decode_clutter_filter_indicator_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_clutter_filter_indicator_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_clutter_filter_indicator_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_clutter_filter_indicator_name(-1).display(),
    content="clutter_filter_indicator=-1",
  )
  inspect(
    @lib.decode_type_of_spatial_processing_name(0).display(),
    content="Data is calculated directly from the source grid with no interpolation",
  )
  inspect(
    @lib.decode_type_of_spatial_processing_name(6).display(),
    content="Neighbor-budget interpolation using the 4 source grid-point values surrounding the nominal grid-point",
  )
  inspect(
    @lib.decode_type_of_spatial_processing_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_spatial_processing_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_spatial_processing_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_spatial_processing_name(-1).display(),
    content="type_of_spatial_processing=-1",
  )
  inspect(
    @lib.decode_quality_value_associated_with_parameter_name(0).display(),
    content="Confidence index",
  )
  inspect(
    @lib.decode_quality_value_associated_with_parameter_name(5).display(),
    content="Probability",
  )
  inspect(
    @lib.decode_quality_value_associated_with_parameter_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_quality_value_associated_with_parameter_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_quality_value_associated_with_parameter_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_quality_value_associated_with_parameter_name(-1).display(),
    content="quality_value_associated_with_parameter=-1",
  )
  inspect(
    @lib.decode_type_of_interval_name(0).display(),
    content="Smaller than first limit",
  )
  inspect(
    @lib.decode_type_of_interval_name(11).display(),
    content="Equal to first limit",
  )
  inspect(@lib.decode_type_of_interval_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_type_of_interval_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_type_of_interval_name(255).display(), content="Missing")
  inspect(
    @lib.decode_type_of_interval_name(-1).display(),
    content="type_of_interval=-1",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_name(0).display(),
    content="Analysis",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_name(5).display(),
    content="Gridded observations",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_name(-1).display(),
    content="type_of_reference_dataset=-1",
  )
  inspect(
    @lib.decode_type_of_relationship_to_reference_dataset_name(0).display(),
    content="Anomaly",
  )
  inspect(
    @lib.decode_type_of_relationship_to_reference_dataset_name(24).display(),
    content="Crossing Point Forecast (CPF)",
  )
  inspect(
    @lib.decode_type_of_relationship_to_reference_dataset_name(10).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_relationship_to_reference_dataset_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_relationship_to_reference_dataset_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_relationship_to_reference_dataset_name(-1).display(),
    content="type_of_relationship_to_reference_dataset=-1",
  )
  inspect(
    @lib.decode_statistical_processing_of_reference_period_name(0).display(),
    content="Average",
  )
  inspect(
    @lib.decode_statistical_processing_of_reference_period_name(31).display(),
    content="Index based on empirical distribution",
  )
  inspect(
    @lib.decode_statistical_processing_of_reference_period_name(10).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_statistical_processing_of_reference_period_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_statistical_processing_of_reference_period_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_statistical_processing_of_reference_period_name(-1).display(),
    content="statistical_processing_of_reference_period=-1",
  )
  inspect(
    @lib.decode_spatial_vicinity_type_name(0).display(),
    content="Circle [m]",
  )
  inspect(
    @lib.decode_spatial_vicinity_type_name(4).display(),
    content="Span of grid boxes centered around grid box i,j [x,y]",
  )
  inspect(
    @lib.decode_spatial_vicinity_type_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_spatial_vicinity_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_spatial_vicinity_type_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_spatial_vicinity_type_name(-1).display(),
    content="spatial_vicinity_type=-1",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_processing_name(0).display(),
    content="Average",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_processing_name(190).display(),
    content="Quantile",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_processing_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_processing_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_processing_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_processing_name(-1).display(),
    content="spatial_and_temporal_vicinity_processing=-1",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_missing_data_name(0).display(),
    content="Ignore missing data",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_missing_data_name(1).display(),
    content="No data",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_missing_data_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_missing_data_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_missing_data_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_spatial_and_temporal_vicinity_missing_data_name(-1).display(),
    content="spatial_and_temporal_vicinity_missing_data=-1",
  )
  inspect(
    @lib.decode_radar_data_quality_flags_name(0).display(),
    content="Normal operating data",
  )
  inspect(
    @lib.decode_radar_data_quality_flags_name(12).display(),
    content="Ships/aircrafts",
  )
  inspect(
    @lib.decode_radar_data_quality_flags_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_radar_data_quality_flags_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_radar_data_quality_flags_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_radar_data_quality_flags_name(-1).display(),
    content="radar_data_quality_flags=-1",
  )
  inspect(
    @lib.decode_verification_scores_name(0).display(),
    content="Mean Error",
  )
  inspect(
    @lib.decode_verification_scores_name(105).display(),
    content="Contingency Table (Probabilistic) - Forecast-by-n-members and not observed",
  )
  inspect(
    @lib.decode_verification_scores_name(50).display(),
    content="Reserved for Future Use",
  )
  inspect(
    @lib.decode_verification_scores_name(500).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_verification_scores_name(64000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_verification_scores_name(65535).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_verification_scores_name(-1).display(),
    content="verification_scores=-1",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_for_verification_name(0).display(),
    content="Analysis Interpolated on Forecast Grid",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_for_verification_name(4).display(),
    content="Gridded Observation wih Forecast Interpolated on Observation Grid",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_for_verification_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_for_verification_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_for_verification_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_reference_dataset_for_verification_name(-1).display(),
    content="type_of_reference_dataset_for_verification=-1",
  )
  inspect(
    @lib.decode_type_of_additional_arguments_for_verification_score_name(0).display(),
    content="Fixed Threshold Value",
  )
  inspect(
    @lib.decode_type_of_additional_arguments_for_verification_score_name(2).display(),
    content="Threshold Specified as a Multiple of the Standard Deviation",
  )
  inspect(
    @lib.decode_type_of_additional_arguments_for_verification_score_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_additional_arguments_for_verification_score_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_additional_arguments_for_verification_score_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_additional_arguments_for_verification_score_name(-1).display(),
    content="type_of_additional_arguments_for_verification_score=-1",
  )
  inspect(@lib.decode_precipitation_type_name(1).display(), content="Rain")
  inspect(
    @lib.decode_precipitation_type_name(14).display(),
    content="Hail (≥ 5 mm)",
  )
  inspect(@lib.decode_precipitation_type_name(0).display(), content="Reserved")
  inspect(
    @lib.decode_precipitation_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_precipitation_type_name(255).display(), content="Missing")
  inspect(
    @lib.decode_precipitation_type_name(-1).display(),
    content="precipitation_type=-1",
  )
  inspect(
    @lib.decode_precipitable_water_category_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_precipitable_water_category_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_precipitable_water_category_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_precipitable_water_category_name(-1).display(),
    content="precipitable_water_category=-1",
  )
  inspect(@lib.decode_cloud_type_name(0).display(), content="Clear")
  inspect(@lib.decode_cloud_type_name(191).display(), content="Unknown")
  inspect(@lib.decode_cloud_type_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_cloud_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_cloud_type_name(255).display(), content="Missing")
  inspect(@lib.decode_cloud_type_name(-1).display(), content="cloud_type=-1")
  inspect(@lib.decode_thunderstorm_coverage_name(0).display(), content="None")
  inspect(
    @lib.decode_thunderstorm_coverage_name(4).display(),
    content="Numerous (>45%)",
  )
  inspect(
    @lib.decode_thunderstorm_coverage_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_thunderstorm_coverage_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_thunderstorm_coverage_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_thunderstorm_coverage_name(-1).display(),
    content="thunderstorm_coverage=-1",
  )
  inspect(
    @lib.decode_presence_of_aerosol_name(1).display(),
    content="Aerosol present",
  )
  inspect(
    @lib.decode_presence_of_aerosol_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_presence_of_aerosol_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_presence_of_aerosol_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_presence_of_aerosol_name(-1).display(),
    content="presence_of_aerosol=-1",
  )
  inspect(@lib.decode_volcanic_ash_name(1).display(), content="Present")
  inspect(@lib.decode_volcanic_ash_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_volcanic_ash_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_volcanic_ash_name(255).display(), content="Missing")
  inspect(
    @lib.decode_volcanic_ash_name(-1).display(),
    content="volcanic_ash=-1",
  )
  inspect(@lib.decode_icing_name(5).display(), content="Heavy")
  inspect(@lib.decode_icing_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_icing_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_icing_name(255).display(), content="Missing")
  inspect(@lib.decode_icing_name(-1).display(), content="icing=-1")
  inspect(@lib.decode_turbulence_name(4).display(), content="Extreme")
  inspect(@lib.decode_turbulence_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_turbulence_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_turbulence_name(255).display(), content="Missing")
  inspect(@lib.decode_turbulence_name(-1).display(), content="turbulence=-1")
  inspect(
    @lib.decode_planetary_boundary_layer_regime_name(1).display(),
    content="Stable",
  )
  inspect(
    @lib.decode_planetary_boundary_layer_regime_name(0).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_planetary_boundary_layer_regime_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_planetary_boundary_layer_regime_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_planetary_boundary_layer_regime_name(-1).display(),
    content="planetary_boundary_layer_regime=-1",
  )
  inspect(
    @lib.decode_contrail_intensity_name(1).display(),
    content="Contrail Present",
  )
  inspect(
    @lib.decode_contrail_intensity_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_contrail_intensity_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_contrail_intensity_name(255).display(), content="Missing")
  inspect(
    @lib.decode_contrail_intensity_name(-1).display(),
    content="contrail_intensity=-1",
  )
  inspect(
    @lib.decode_contrail_engine_type_name(2).display(),
    content="Non-Bypass",
  )
  inspect(
    @lib.decode_contrail_engine_type_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_contrail_engine_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_contrail_engine_type_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_contrail_engine_type_name(-1).display(),
    content="contrail_engine_type=-1",
  )
  inspect(@lib.decode_land_use_name(1).display(), content="Urban Land")
  inspect(@lib.decode_land_use_name(13).display(), content="Savannah")
  inspect(@lib.decode_land_use_name(0).display(), content="Reserved")
  inspect(
    @lib.decode_land_use_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_land_use_name(255).display(), content="Missing")
  inspect(@lib.decode_land_use_name(-1).display(), content="land_use=-1")
  inspect(@lib.decode_soil_type_name(1).display(), content="Sand")
  inspect(@lib.decode_soil_type_name(11).display(), content="Clay")
  inspect(@lib.decode_soil_type_name(0).display(), content="Reserved")
  inspect(
    @lib.decode_soil_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_soil_type_name(255).display(), content="Missing")
  inspect(@lib.decode_soil_type_name(-1).display(), content="soil_type=-1")
  inspect(
    @lib.decode_environmental_factor_qualifier_name(0).display(),
    content="Worst",
  )
  inspect(
    @lib.decode_environmental_factor_qualifier_name(191).display(),
    content="Unknown",
  )
  inspect(
    @lib.decode_environmental_factor_qualifier_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_environmental_factor_qualifier_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_environmental_factor_qualifier_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_environmental_factor_qualifier_name(-1).display(),
    content="environmental_factor_qualifier=-1",
  )
  inspect(
    @lib.decode_remotely_sensed_snow_coverage_name(50).display(),
    content="No-Snow/No-Cloud",
  )
  inspect(
    @lib.decode_remotely_sensed_snow_coverage_name(250).display(),
    content="Snow",
  )
  inspect(
    @lib.decode_remotely_sensed_snow_coverage_name(10).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_remotely_sensed_snow_coverage_name(252).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_remotely_sensed_snow_coverage_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_remotely_sensed_snow_coverage_name(-1).display(),
    content="remotely_sensed_snow_coverage=-1",
  )
  inspect(
    @lib.decode_elevation_of_snow_covered_terrain_name(10).display(),
    content="Elevation in increments of 100 m",
  )
  inspect(
    @lib.decode_elevation_of_snow_covered_terrain_name(200).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_elevation_of_snow_covered_terrain_name(254).display(),
    content="Clouds",
  )
  inspect(
    @lib.decode_elevation_of_snow_covered_terrain_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_elevation_of_snow_covered_terrain_name(-1).display(),
    content="elevation_of_snow_covered_terrain=-1",
  )
  inspect(
    @lib.decode_cloud_mask_type_name(0).display(),
    content="Clear over water",
  )
  inspect(@lib.decode_cloud_mask_type_name(3).display(), content="No data")
  inspect(@lib.decode_cloud_mask_type_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_cloud_mask_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_cloud_mask_type_name(255).display(), content="Missing")
  inspect(
    @lib.decode_cloud_mask_type_name(-1).display(),
    content="cloud_mask_type=-1",
  )
  inspect(
    @lib.decode_pixel_scene_type_name(0).display(),
    content="No Scene Identified",
  )
  inspect(
    @lib.decode_pixel_scene_type_name(112).display(),
    content="Single Layer Ice Cloud",
  )
  inspect(@lib.decode_pixel_scene_type_name(50).display(), content="Reserved")
  inspect(
    @lib.decode_pixel_scene_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_pixel_scene_type_name(255).display(), content="Missing")
  inspect(
    @lib.decode_pixel_scene_type_name(-1).display(),
    content="pixel_scene_type=-1",
  )
  inspect(
    @lib.decode_cloud_top_height_quality_indicator_name(0).display(),
    content="Nominal Cloud Top Height Quality",
  )
  inspect(
    @lib.decode_cloud_top_height_quality_indicator_name(3).display(),
    content="Fog In Segment and Poor Quality Height Estimation",
  )
  inspect(
    @lib.decode_cloud_top_height_quality_indicator_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_cloud_top_height_quality_indicator_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_cloud_top_height_quality_indicator_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_cloud_top_height_quality_indicator_name(-1).display(),
    content="cloud_top_height_quality_indicator=-1",
  )
  inspect(
    @lib.decode_horizontal_dimension_processed_name(0).display(),
    content="Latitude",
  )
  inspect(
    @lib.decode_horizontal_dimension_processed_name(1).display(),
    content="Longitude",
  )
  inspect(
    @lib.decode_horizontal_dimension_processed_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_horizontal_dimension_processed_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_horizontal_dimension_processed_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_horizontal_dimension_processed_name(-1).display(),
    content="horizontal_dimension_processed=-1",
  )
  inspect(
    @lib.decode_treatment_of_missing_data_name(0).display(),
    content="Not Included",
  )
  inspect(
    @lib.decode_treatment_of_missing_data_name(1).display(),
    content="Extrapolated",
  )
  inspect(
    @lib.decode_treatment_of_missing_data_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_treatment_of_missing_data_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_treatment_of_missing_data_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_treatment_of_missing_data_name(-1).display(),
    content="treatment_of_missing_data=-1",
  )
  inspect(@lib.decode_categorical_result_name(0).display(), content="No")
  inspect(@lib.decode_categorical_result_name(1).display(), content="Yes")
  inspect(
    @lib.decode_categorical_result_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_categorical_result_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_categorical_result_name(255).display(), content="Missing")
  inspect(
    @lib.decode_categorical_result_name(-1).display(),
    content="categorical_result=-1",
  )
  inspect(
    @lib.decode_fire_detection_indicator_name(2).display(),
    content="Probable Fire Detected",
  )
  inspect(
    @lib.decode_fire_detection_indicator_name(3).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_fire_detection_indicator_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_fire_detection_indicator_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_fire_detection_indicator_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_fire_detection_indicator_name(-1).display(),
    content="fire_detection_indicator=-1",
  )
  inspect(
    @lib.decode_categorical_outlook_name(0).display(),
    content="No Risk Area",
  )
  inspect(
    @lib.decode_categorical_outlook_name(18).display(),
    content="Extreamly Critical Risk Area",
  )
  inspect(
    @lib.decode_categorical_outlook_name(10).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_categorical_outlook_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_categorical_outlook_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_categorical_outlook_name(-1).display(),
    content="categorical_outlook=-1",
  )
  inspect(
    @lib.decode_weather_name(0).display(),
    content="Cloud development not observed or not observable",
  )
  inspect(
    @lib.decode_weather_name(65).display(),
    content="Rain, not freezing, continuous",
  )
  inspect(
    @lib.decode_weather_name(293).display(),
    content="Shower(s) or thunderstorm over mountains",
  )
  inspect(@lib.decode_weather_name(300).display(), content="Reserved")
  inspect(@lib.decode_weather_name(511).display(), content="Missing value")
  inspect(@lib.decode_weather_name(-1).display(), content="weather=-1")
  inspect(@lib.decode_icing_scenario_name(1).display(), content="General")
  inspect(@lib.decode_icing_scenario_name(4).display(), content="Freezing")
  inspect(@lib.decode_icing_scenario_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_icing_scenario_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_icing_scenario_name(255).display(), content="Missing")
  inspect(
    @lib.decode_icing_scenario_name(-1).display(),
    content="icing_scenario=-1",
  )
  inspect(@lib.decode_icing_severity_name(0).display(), content="None")
  inspect(@lib.decode_icing_severity_name(4).display(), content="Severe")
  inspect(@lib.decode_icing_severity_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_icing_severity_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_icing_severity_name(255).display(), content="Missing")
  inspect(
    @lib.decode_icing_severity_name(-1).display(),
    content="icing_severity=-1",
  )
  inspect(@lib.decode_aerosol_type_name(0).display(), content="Ozone")
  inspect(
    @lib.decode_aerosol_type_name(62036).display(),
    content="Brown Carbon Dry",
  )
  inspect(@lib.decode_aerosol_type_name(10003).display(), content="Reserved")
  inspect(@lib.decode_aerosol_type_name(65535).display(), content="Missing")
  inspect(
    @lib.decode_aerosol_type_name(-1).display(),
    content="aerosol_type=-1",
  )
  inspect(
    @lib.decode_atmospheric_chemical_or_physical_constituent_type_name(0).display(),
    content="Ozone",
  )
  inspect(
    @lib.decode_atmospheric_chemical_or_physical_constituent_type_name(20010).display(),
    content="HCFC-142b",
  )
  inspect(
    @lib.decode_atmospheric_chemical_or_physical_constituent_type_name(62300).display(),
    content="Poaceae (Grass Family) Pollen",
  )
  inspect(
    @lib.decode_atmospheric_chemical_or_physical_constituent_type_name(10003).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_atmospheric_chemical_or_physical_constituent_type_name(63000).display(),
    content="For Experimental Use at Local Level",
  )
  inspect(
    @lib.decode_atmospheric_chemical_or_physical_constituent_type_name(65535).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_atmospheric_chemical_or_physical_constituent_type_name(-1).display(),
    content="constituent_type=-1",
  )
  inspect(
    @lib.decode_canopy_cover_fraction_name(1).display(),
    content="Crops, mixed farming",
  )
  inspect(
    @lib.decode_canopy_cover_fraction_name(20).display(),
    content="Water and land mixtures",
  )
  inspect(
    @lib.decode_canopy_cover_fraction_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_canopy_cover_fraction_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_canopy_cover_fraction_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_canopy_cover_fraction_name(-1).display(),
    content="canopy_cover_fraction=-1",
  )
  inspect(@lib.decode_soil_texture_fraction_name(1).display(), content="Coarse")
  inspect(
    @lib.decode_soil_texture_fraction_name(7).display(),
    content="Tropical-organic",
  )
  inspect(
    @lib.decode_soil_texture_fraction_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_soil_texture_fraction_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_soil_texture_fraction_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_soil_texture_fraction_name(-1).display(),
    content="soil_texture_fraction=-1",
  )
  inspect(@lib.decode_source_or_sink_name(1).display(), content="Aviation")
  inspect(
    @lib.decode_source_or_sink_name(43).display(),
    content="Deforestation",
  )
  inspect(@lib.decode_source_or_sink_name(0).display(), content="Reserved")
  inspect(@lib.decode_source_or_sink_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_source_or_sink_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_source_or_sink_name(255).display(), content="Missing")
  inspect(
    @lib.decode_source_or_sink_name(-1).display(),
    content="source_or_sink=-1",
  )
  inspect(@lib.decode_wetland_type_name(1).display(), content="Bog")
  inspect(@lib.decode_wetland_type_name(12).display(), content="Wet Tundra")
  inspect(@lib.decode_wetland_type_name(0).display(), content="Reserved")
  inspect(@lib.decode_wetland_type_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_wetland_type_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_wetland_type_name(255).display(), content="Missing")
  inspect(
    @lib.decode_wetland_type_name(-1).display(),
    content="wetland_type=-1",
  )
  inspect(
    @lib.decode_type_of_distribution_function_name(0).display(),
    content="No specific distribution function given",
  )
  inspect(
    @lib.decode_type_of_distribution_function_name(8).display(),
    content="No distribution function. The encoded variable is derived from variables characterized by type of distribution function No. 7",
  )
  inspect(
    @lib.decode_type_of_distribution_function_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_type_of_distribution_function_name(60000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_type_of_distribution_function_name(65535).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_type_of_distribution_function_name(-1).display(),
    content="type_of_distribution_function=-1",
  )
  inspect(
    @lib.decode_coverage_attributes_name(0).display(),
    content="Undefined",
  )
  inspect(
    @lib.decode_coverage_attributes_name(7).display(),
    content="Aggregated",
  )
  inspect(
    @lib.decode_coverage_attributes_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_coverage_attributes_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_coverage_attributes_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_coverage_attributes_name(-1).display(),
    content="coverage_attributes=-1",
  )
  inspect(
    @lib.decode_tile_classification_name(1).display(),
    content="Land use classes according to ESA-GLOBCOVER GCV2009",
  )
  inspect(@lib.decode_tile_classification_name(0).display(), content="Reserved")
  inspect(
    @lib.decode_tile_classification_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_tile_classification_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_tile_classification_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_tile_classification_name(-1).display(),
    content="tile_classification=-1",
  )
  inspect(
    @lib.decode_tile_class_name(1).display(),
    content="Evergreen broadleaved forest",
  )
  inspect(@lib.decode_tile_class_name(39).display(), content="Undefined")
  inspect(@lib.decode_tile_class_name(0).display(), content="Reserved")
  inspect(@lib.decode_tile_class_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_tile_class_name(40000).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_tile_class_name(-1).display(), content="tile_class=-1")
  inspect(
    @lib.decode_quality_indicator_name(0).display(),
    content="No Quality Information Available",
  )
  inspect(@lib.decode_quality_indicator_name(2).display(), content="Passed")
  inspect(@lib.decode_quality_indicator_name(100).display(), content="Reserved")
  inspect(
    @lib.decode_quality_indicator_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_quality_indicator_name(255).display(), content="Missing")
  inspect(
    @lib.decode_quality_indicator_name(-1).display(),
    content="quality_indicator=-1",
  )
  inspect(
    @lib.decode_thunderstorm_intensity_index_name(3).display(),
    content="Severe thunderstorm",
  )
  inspect(
    @lib.decode_thunderstorm_intensity_index_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_thunderstorm_intensity_index_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_thunderstorm_intensity_index_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_thunderstorm_intensity_index_name(-1).display(),
    content="thunderstorm_intensity_index=-1",
  )
  inspect(
    @lib.decode_precipitation_intensity_name(3).display(),
    content="Heavy precipitation",
  )
  inspect(
    @lib.decode_precipitation_intensity_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_precipitation_intensity_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_precipitation_intensity_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_precipitation_intensity_name(-1).display(),
    content="precipitation_intensity=-1",
  )
  inspect(
    @lib.decode_method_used_to_derive_data_value_for_local_time_name(0).display(),
    content="Nearest forecast or analysis time to specified local time",
  )
  inspect(
    @lib.decode_method_used_to_derive_data_value_for_local_time_name(1).display(),
    content="Interpolated to be valid at the specified local time",
  )
  inspect(
    @lib.decode_method_used_to_derive_data_value_for_local_time_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_method_used_to_derive_data_value_for_local_time_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_method_used_to_derive_data_value_for_local_time_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_method_used_to_derive_data_value_for_local_time_name(-1).display(),
    content="method_used_to_derive_data_value_for_local_time=-1",
  )
  inspect(
    @lib.decode_character_of_precipitation_name(3).display(),
    content="Continuous",
  )
  inspect(
    @lib.decode_character_of_precipitation_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_character_of_precipitation_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_character_of_precipitation_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_character_of_precipitation_name(-1).display(),
    content="character_of_precipitation=-1",
  )
  inspect(@lib.decode_drainage_direction_name(1).display(), content="Southwest")
  inspect(@lib.decode_drainage_direction_name(0).display(), content="Reserved")
  inspect(
    @lib.decode_drainage_direction_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_drainage_direction_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_drainage_direction_name(255).display(), content="Missing")
  inspect(
    @lib.decode_drainage_direction_name(-1).display(),
    content="drainage_direction=-1",
  )
  inspect(
    @lib.decode_wave_direction_and_frequency_formulae_name(1).display(),
    content="Geometric Sequence",
  )
  inspect(
    @lib.decode_wave_direction_and_frequency_formulae_name(2).display(),
    content="Arithmetic Sequence",
  )
  inspect(
    @lib.decode_wave_direction_and_frequency_formulae_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_wave_direction_and_frequency_formulae_name(220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_wave_direction_and_frequency_formulae_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_wave_direction_and_frequency_formulae_name(-1).display(),
    content="wave_direction_and_frequency_formulae=-1",
  )
  inspect(
    @lib.decode_tile_classes_and_groupings_name(1).display(),
    content="Seas and Oceans",
  )
  inspect(
    @lib.decode_tile_classes_and_groupings_name(3501).display(),
    content="Grouping Using the Dominant Tiles Approach (Dominant Tile Varies per Gridbox)",
  )
  inspect(
    @lib.decode_tile_classes_and_groupings_name(1041).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_tile_classes_and_groupings_name(40000).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_tile_classes_and_groupings_name(65535).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_tile_classes_and_groupings_name(-1).display(),
    content="tile_classes_and_groupings=-1",
  )
  inspect(@lib.decode_hazard_index_name(0).display(), content="Undefined")
  inspect(@lib.decode_hazard_index_name(10).display(), content="Reserved")
  inspect(@lib.decode_hazard_index_name(65535).display(), content="Missing")
  inspect(
    @lib.decode_hazard_index_name(-1).display(),
    content="hazard_index=-1",
  )
  inspect(
    @lib.decode_transport_dispersion_model_name(1).display(),
    content="DERMA (Danish Emergency Response Model of the Atmosphere)",
  )
  inspect(
    @lib.decode_transport_dispersion_model_name(0).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_transport_dispersion_model_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_transport_dispersion_model_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_transport_dispersion_model_name(-1).display(),
    content="transport_dispersion_model=-1",
  )
  inspect(
    @lib.decode_emission_scenario_origin_name(1).display(),
    content="ARGOS (Accident Reporting and Guiding Operational System)",
  )
  inspect(
    @lib.decode_emission_scenario_origin_name(0).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_emission_scenario_origin_name(100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_emission_scenario_origin_name(255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_emission_scenario_origin_name(-1).display(),
    content="emission_scenario_origin=-1",
  )
  inspect(
    @lib.decode_nwp_model_name(1).display(),
    content="AROME (Meso scale NWP, Meteo-France)",
  )
  inspect(@lib.decode_nwp_model_name(0).display(), content="Reserved")
  inspect(@lib.decode_nwp_model_name(100).display(), content="Reserved")
  inspect(@lib.decode_nwp_model_name(255).display(), content="Missing")
  inspect(@lib.decode_nwp_model_name(-1).display(), content="nwp_model=-1")
  inspect(
    @lib.decode_parameter_category_name(0, 0).display(),
    content="Temperature",
  )
  inspect(
    @lib.decode_parameter_category_name(0, 192).display(),
    content="Covariance",
  )
  inspect(
    @lib.decode_parameter_category_name(0, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_category_name(0, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_category_name(1, 2).display(),
    content="Inland Water and Sediment Properties",
  )
  inspect(
    @lib.decode_parameter_category_name(2, 3).display(),
    content="Soil Products",
  )
  inspect(
    @lib.decode_parameter_category_name(3, 192).display(),
    content="Forecast Satellite Imagery",
  )
  inspect(
    @lib.decode_parameter_category_name(4, 10).display(),
    content="Space Weather Indices",
  )
  inspect(
    @lib.decode_parameter_category_name(10, 191).display(),
    content="Miscellaneous",
  )
  inspect(
    @lib.decode_parameter_category_name(20, 5).display(),
    content="Environmental Hazard Indices",
  )
  inspect(
    @lib.decode_parameter_category_name(191, 0).display(),
    content="Stochastic Parameterizations",
  )
  inspect(
    @lib.decode_parameter_category_name(191, 2).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_category_name(999, 1).display(),
    content="parameter_category=disc=999,cat=1",
  )
  inspect(@lib.decode_parameter_number_name(0, 2, 2).display(), content="UGRD")
  inspect(
    @lib.decode_parameter_number_name(0, 2, 200).display(),
    content="LAVV",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, 215).display(),
    content="OMGALF",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, 77).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, -1).display(),
    content="parameter_number=disc=0,cat=2,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 2, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_number_name(0, 3, 5).display(), content="HGT")
  inspect(
    @lib.decode_parameter_number_name(0, 3, 16).display(),
    content="U-GWD",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, 199).display(),
    content="TSLSA",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, 180).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 3, -1).display(),
    content="parameter_number=disc=0,cat=3,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 54).display(),
    content="DNSWRFLX",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 20).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 180).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 199).display(),
    content="CFNSF",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 4, -1).display(),
    content="parameter_number=disc=0,cat=4,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 6).display(),
    content="NLWRCS",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 20).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 194).display(),
    content="LWHR",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 5, -1).display(),
    content="parameter_number=disc=0,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(0, 6, 1).display(), content="TCDC")
  inspect(
    @lib.decode_parameter_number_name(0, 6, 23).display(),
    content="CDCIMR",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, 44).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, 199).display(),
    content="FICE",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 6, -1).display(),
    content="parameter_number=disc=0,cat=6,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(0, 7, 6).display(), content="CAPE")
  inspect(
    @lib.decode_parameter_number_name(0, 7, 14).display(),
    content="Reserved",
  )
  inspect(@lib.decode_parameter_number_name(0, 7, 198).display(), content="LAI")
  inspect(
    @lib.decode_parameter_number_name(0, 7, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 7, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 7, -1).display(),
    content="parameter_number=disc=0,cat=7,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 13, 0).display(),
    content="AEROT",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 13, 22).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 13, 194).display(),
    content="LPMTF",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 13, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 13, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 13, -1).display(),
    content="parameter_number=disc=0,cat=13,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 14, 0).display(),
    content="TOZNE",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 14, 5).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 14, 195).display(),
    content="VDFOZ",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 14, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 14, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 14, -1).display(),
    content="parameter_number=disc=0,cat=14,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(0, 15, 3).display(), content="VIL")
  inspect(
    @lib.decode_parameter_number_name(0, 15, 44).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 15, 192).display(),
    content="RADARVIL",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 15, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 15, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 15, -1).display(),
    content="parameter_number=disc=0,cat=15,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 16, 3).display(),
    content="RETOP",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 16, 44).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 16, 198).display(),
    content="MAXREF",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 16, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 16, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 16, -1).display(),
    content="parameter_number=disc=0,cat=16,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 17, 1).display(),
    content="LTPINX",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 17, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 17, 192).display(),
    content="LTNG",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 17, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 17, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 17, -1).display(),
    content="parameter_number=disc=0,cat=17,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 18, 3).display(),
    content="GDCES",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 18, 9).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 18, 25).display(),
    content="GAMDOSER",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 18, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 18, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 18, -1).display(),
    content="parameter_number=disc=0,cat=18,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 19, 39).display(),
    content="SEEINDEX",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 19, 60).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 19, 219).display(),
    content="TPFI",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 19, 228).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 19, 250).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 19, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 19, -1).display(),
    content="parameter_number=disc=0,cat=19,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 190, 0).display(),
    content="ATEXT",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 190, 50).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 190, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 190, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 190, -1).display(),
    content="parameter_number=disc=0,cat=190,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 191, 0).display(),
    content="TSEC",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 191, 7).display(),
    content="TDTSV",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 191, 80).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 191, 194).display(),
    content="RTSEC",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 191, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 191, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 191, -1).display(),
    content="parameter_number=disc=0,cat=191,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 192, 1).display(),
    content="COVMZ",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 192, 13).display(),
    content="COVVVVV",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 192, 0).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 192, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 192, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 192, -1).display(),
    content="parameter_number=disc=0,cat=192,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(1, 0, 0).display(), content="FFLDG")
  inspect(
    @lib.decode_parameter_number_name(1, 0, 24).display(),
    content="DARVERVEL",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 0, 100).display(),
    content="Reserved",
  )
  inspect(@lib.decode_parameter_number_name(1, 0, 196).display(), content="AHD")
  inspect(
    @lib.decode_parameter_number_name(1, 0, 195).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 0, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 0, -1).display(),
    content="parameter_number=disc=1,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(1, 1, 2).display(), content="POP")
  inspect(
    @lib.decode_parameter_number_name(1, 1, 3).display(),
    content="Reserved",
  )
  inspect(@lib.decode_parameter_number_name(1, 1, 195).display(), content="CWR")
  inspect(
    @lib.decode_parameter_number_name(1, 1, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 1, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 1, -1).display(),
    content="parameter_number=disc=1,cat=1,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 2, 0).display(),
    content="WDPTHIL",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 2, 23).display(),
    content="ARCRF",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 2, 24).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 2, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 2, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(1, 2, -1).display(),
    content="parameter_number=disc=1,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(2, 0, 0).display(), content="LAND")
  inspect(
    @lib.decode_parameter_number_name(2, 0, 63).display(),
    content="CANTMP",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 0, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 0, 205).display(),
    content="RCSOL",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 0, 250).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 0, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 0, -1).display(),
    content="parameter_number=disc=2,cat=0,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 1, 192).display(),
    content="CANL",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 1, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 1, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 1, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 1, -1).display(),
    content="parameter_number=disc=2,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(2, 3, 0).display(), content="SOTYP")
  inspect(@lib.decode_parameter_number_name(2, 3, 30).display(), content="SWET")
  inspect(
    @lib.decode_parameter_number_name(2, 3, 60).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 3, 203).display(),
    content="FLDCP",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 3, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 3, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 3, -1).display(),
    content="parameter_number=disc=2,cat=3,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 4, 0).display(),
    content="FIREOLK",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 4, 44).display(),
    content="IGNLTNG",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 4, 70).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 4, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 4, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 4, -1).display(),
    content="parameter_number=disc=2,cat=4,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 5, 0).display(),
    content="GLACCOV",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 5, 1).display(),
    content="GLACTMP",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 5, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 5, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 5, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 5, -1).display(),
    content="parameter_number=disc=2,cat=5,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 6, 0).display(),
    content="URBCOVER",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 6, 8).display(),
    content="DDROAD",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 6, 50).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 6, 192).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 6, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 6, -1).display(),
    content="parameter_number=disc=2,cat=6,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 7, 0).display(),
    content="HNETFLUX",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 7, 2).display(),
    content="SHTFLUX",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 7, 20).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 7, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 7, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(2, 7, -1).display(),
    content="parameter_number=disc=2,cat=7,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(3, 0, 0).display(), content="SRAD")
  inspect(
    @lib.decode_parameter_number_name(3, 0, 9).display(),
    content="FIREDI",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 0, 150).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 0, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 0, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 0, -1).display(),
    content="parameter_number=disc=3,cat=0,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 1, 27).display(),
    content="BRFLF",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 1, 193).display(),
    content="VSCT",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 1, 50).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 1, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 1, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 1, -1).display(),
    content="parameter_number=disc=3,cat=1,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 2, 0).display(),
    content="CSKPROB",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 2, 30).display(),
    content="MEACST",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 2, 15).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 2, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 2, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 2, -1).display(),
    content="parameter_number=disc=3,cat=2,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 3, 0).display(),
    content="PBMVFRC",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 3, 2).display(),
    content="PBINFRC",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 3, 50).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 3, 210).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 3, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 3, -1).display(),
    content="parameter_number=disc=3,cat=3,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 4, 0).display(),
    content="VOLAPROB",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 4, 8).display(),
    content="VOLAPER",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 4, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 4, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 4, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 4, -1).display(),
    content="parameter_number=disc=3,cat=4,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 5, 0).display(),
    content="ISSTMP",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 5, 5).display(),
    content="EBSDSSTS",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 5, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 5, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 5, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 5, -1).display(),
    content="parameter_number=disc=3,cat=5,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 6, 0).display(),
    content="GSOLIRR",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 6, 3).display(),
    content="DIRSOLEX",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 6, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 6, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 6, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 6, -1).display(),
    content="parameter_number=disc=3,cat=6,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 192, 0).display(),
    content="SBT122",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 192, 87).display(),
    content="SSMS1713",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 192, 120).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 192, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 192, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(3, 192, -1).display(),
    content="parameter_number=disc=3,cat=192,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 0, 0).display(),
    content="TMPSWP",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 0, 5).display(),
    content="PRPTMP",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 0, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 0, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 0, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 0, -1).display(),
    content="parameter_number=disc=4,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(4, 1, 0).display(), content="SPEED")
  inspect(@lib.decode_parameter_number_name(4, 1, 3).display(), content="VEL3")
  inspect(
    @lib.decode_parameter_number_name(4, 1, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 1, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 1, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 1, -1).display(),
    content="parameter_number=disc=4,cat=1,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 2, 0).display(),
    content="PLSMDEN",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 2, 13).display(),
    content="EQSLABT",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 2, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 2, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 2, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 2, -1).display(),
    content="parameter_number=disc=4,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(4, 3, 0).display(), content="BTOT")
  inspect(@lib.decode_parameter_number_name(4, 3, 7).display(), content="EVEC3")
  inspect(
    @lib.decode_parameter_number_name(4, 3, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 3, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 3, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 3, -1).display(),
    content="parameter_number=disc=4,cat=3,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 4, 0).display(),
    content="DIFPFLUX",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 4, 6).display(),
    content="NTRNFLUX",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 4, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 4, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 4, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 4, -1).display(),
    content="parameter_number=disc=4,cat=4,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(4, 5, 0).display(), content="AMPL")
  inspect(
    @lib.decode_parameter_number_name(4, 5, 3).display(),
    content="WAVELGTH",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 5, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 5, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 5, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 5, -1).display(),
    content="parameter_number=disc=4,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(4, 6, 0).display(), content="TSI")
  inspect(@lib.decode_parameter_number_name(4, 6, 6).display(), content="SOLRF")
  inspect(
    @lib.decode_parameter_number_name(4, 6, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 6, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 6, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 6, -1).display(),
    content="parameter_number=disc=4,cat=6,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 7, 0).display(),
    content="LMBINT",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 7, 3).display(),
    content="DSKNGT",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 7, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 7, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 7, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 7, -1).display(),
    content="parameter_number=disc=4,cat=7,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 8, 0).display(),
    content="XRAYRAD",
  )
  inspect(@lib.decode_parameter_number_name(4, 8, 8).display(), content="SICFL")
  inspect(
    @lib.decode_parameter_number_name(4, 8, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 8, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 8, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 8, -1).display(),
    content="parameter_number=disc=4,cat=8,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 9, 0).display(),
    content="SIGPED",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 9, 2).display(),
    content="SIGPAR",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 9, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 9, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 9, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 9, -1).display(),
    content="parameter_number=disc=4,cat=9,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 10, 0).display(),
    content="SCINIDX",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 10, 7).display(),
    content="AURELEC",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 10, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 10, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 10, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(4, 10, -1).display(),
    content="parameter_number=disc=4,cat=10,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 0, 0).display(),
    content="WVSP1",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 0, 104).display(),
    content="VASMF",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 0, 105).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 0, 192).display(),
    content="WSTP",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 0, 194).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 0, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 0, -1).display(),
    content="parameter_number=disc=10,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(10, 1, 0).display(), content="DIRC")
  inspect(
    @lib.decode_parameter_number_name(10, 1, 6).display(),
    content="NRTHCUR",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 1, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 1, 192).display(),
    content="OMLU",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 1, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 1, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 1, -1).display(),
    content="parameter_number=disc=10,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(10, 2, 0).display(), content="ICEC")
  inspect(
    @lib.decode_parameter_number_name(10, 2, 31).display(),
    content="DSWRFICE",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 2, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 2, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 2, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 2, -1).display(),
    content="parameter_number=disc=10,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(10, 3, 0).display(), content="WTMP")
  inspect(
    @lib.decode_parameter_number_name(10, 3, 22).display(),
    content="DSWRFSS",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 3, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 3, 200).display(),
    content="SSST",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 3, 240).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 3, 254).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 3, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 3, -1).display(),
    content="parameter_number=disc=10,cat=3,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(10, 4, 0).display(), content="MTHD")
  inspect(
    @lib.decode_parameter_number_name(10, 4, 58).display(),
    content="DSWRFSEA",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 4, 9).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 4, 192).display(),
    content="WTMPC",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 4, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 4, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 4, -1).display(),
    content="parameter_number=disc=10,cat=4,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 191, 0).display(),
    content="IRTSEC",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 191, 4).display(),
    content="BARDSF",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 191, 2).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 191, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 191, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(10, 191, -1).display(),
    content="parameter_number=disc=10,cat=191,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 0, 0).display(),
    content="UTHCIDX",
  )
  inspect(@lib.decode_parameter_number_name(20, 0, 12).display(), content="ECF")
  inspect(
    @lib.decode_parameter_number_name(20, 0, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 0, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 0, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 0, -1).display(),
    content="parameter_number=disc=20,cat=0,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 1, 0).display(),
    content="MALACASE",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 1, 9).display(),
    content="FMALVRH",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 1, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 1, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 1, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 1, -1).display(),
    content="parameter_number=disc=20,cat=1,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 2, 0).display(),
    content="POPDEN",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 2, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 2, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 2, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 2, -1).display(),
    content="parameter_number=disc=20,cat=2,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 3, 0).display(),
    content="RENPCAP",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 3, 9).display(),
    content="CSPPROD",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 3, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 3, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 3, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 3, -1).display(),
    content="parameter_number=disc=20,cat=3,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 4, 1).display(),
    content="DBURSTHI",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 4, 60).display(),
    content="WINDHI",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 4, 0).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 4, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 4, 191).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 4, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 4, -1).display(),
    content="parameter_number=disc=20,cat=4,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 5, 1).display(),
    content="HHAIRPOLHI",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 5, 24).display(),
    content="EUTROPHI",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 5, 0).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 5, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 5, 191).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 5, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(20, 5, -1).display(),
    content="parameter_number=disc=20,cat=5,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(191, 0, 0).display(),
    content="SPPT",
  )
  inspect(
    @lib.decode_parameter_number_name(191, 0, 5).display(),
    content="STTP",
  )
  inspect(
    @lib.decode_parameter_number_name(191, 0, 100).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(191, 0, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(191, 0, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(191, 0, -1).display(),
    content="parameter_number=disc=191,cat=0,param=-1",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 0, 193).display(),
    content="TTRAD",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 0, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 0, -1).display(),
    content="parameter_number=disc=0,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_number_name(0, 1, 2).display(), content="MIXR")
  inspect(
    @lib.decode_parameter_number_name(0, 1, 62).display(),
    content="SEVAP",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 1, 180).display(),
    content="Reserved",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 1, 243).display(),
    content="Reserved for Local Use",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 1, 255).display(),
    content="Missing",
  )
  inspect(
    @lib.decode_parameter_number_name(0, 1, -1).display(),
    content="parameter_number=disc=0,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 2, 2).display(), content="UGRD")
  inspect(@lib.decode_parameter_name(0, 0, 1).display(), content="VTMP")
  inspect(@lib.decode_parameter_name(0, 0, 17).display(), content="SKINT")
  inspect(@lib.decode_parameter_name(0, 0, 193).display(), content="TTRAD")
  inspect(@lib.decode_parameter_name(0, 0, 70).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 0, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 0, -1).display(),
    content="disc=0,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 1, 2).display(), content="MIXR")
  inspect(@lib.decode_parameter_name(0, 1, 52).display(), content="TPRATE")
  inspect(@lib.decode_parameter_name(0, 1, 143).display(), content="PERATE")
  inspect(@lib.decode_parameter_name(0, 1, 197).display(), content="MDIV")
  inspect(
    @lib.decode_parameter_name(0, 1, 243).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 1, 180).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 1, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 1, -1).display(),
    content="disc=0,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 2, 215).display(), content="OMGALF")
  inspect(
    @lib.decode_parameter_name(0, 2, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 2, 180).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 2, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 2, -1).display(),
    content="disc=0,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 3, 16).display(), content="U-GWD")
  inspect(@lib.decode_parameter_name(0, 3, 199).display(), content="TSLSA")
  inspect(@lib.decode_parameter_name(0, 3, 180).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 3, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 3, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 3, -1).display(),
    content="disc=0,cat=3,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 4, 54).display(), content="DNSWRFLX")
  inspect(@lib.decode_parameter_name(0, 4, 199).display(), content="CFNSF")
  inspect(@lib.decode_parameter_name(0, 4, 180).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 4, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 4, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 4, -1).display(),
    content="disc=0,cat=4,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 5, 6).display(), content="NLWRCS")
  inspect(@lib.decode_parameter_name(0, 5, 194).display(), content="LWHR")
  inspect(@lib.decode_parameter_name(0, 5, 180).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 5, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 5, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 5, -1).display(),
    content="disc=0,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 6, 1).display(), content="TCDC")
  inspect(@lib.decode_parameter_name(0, 6, 23).display(), content="CDCIMR")
  inspect(@lib.decode_parameter_name(0, 6, 180).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 6, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 6, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 6, -1).display(),
    content="disc=0,cat=6,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 7, 6).display(), content="CAPE")
  inspect(@lib.decode_parameter_name(0, 7, 14).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 7, 198).display(), content="LAI")
  inspect(
    @lib.decode_parameter_name(0, 7, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 7, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 7, -1).display(),
    content="disc=0,cat=7,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 13, 0).display(), content="AEROT")
  inspect(@lib.decode_parameter_name(0, 13, 22).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 13, 194).display(), content="LPMTF")
  inspect(
    @lib.decode_parameter_name(0, 13, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 13, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 13, -1).display(),
    content="disc=0,cat=13,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 14, 0).display(), content="TOZNE")
  inspect(@lib.decode_parameter_name(0, 14, 5).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 14, 195).display(), content="VDFOZ")
  inspect(
    @lib.decode_parameter_name(0, 14, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 14, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 14, -1).display(),
    content="disc=0,cat=14,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 15, 3).display(), content="VIL")
  inspect(@lib.decode_parameter_name(0, 15, 44).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 15, 192).display(), content="RADARVIL")
  inspect(
    @lib.decode_parameter_name(0, 15, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 15, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 15, -1).display(),
    content="disc=0,cat=15,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 16, 3).display(), content="RETOP")
  inspect(@lib.decode_parameter_name(0, 16, 44).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 16, 198).display(), content="MAXREF")
  inspect(
    @lib.decode_parameter_name(0, 16, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 16, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 16, -1).display(),
    content="disc=0,cat=16,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 17, 1).display(), content="LTPINX")
  inspect(@lib.decode_parameter_name(0, 17, 100).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 17, 192).display(), content="LTNG")
  inspect(
    @lib.decode_parameter_name(0, 17, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 17, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 17, -1).display(),
    content="disc=0,cat=17,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 18, 3).display(), content="GDCES")
  inspect(@lib.decode_parameter_name(0, 18, 9).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 18, 25).display(), content="GAMDOSER")
  inspect(
    @lib.decode_parameter_name(0, 18, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 18, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 18, -1).display(),
    content="disc=0,cat=18,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 19, 39).display(), content="SEEINDEX")
  inspect(@lib.decode_parameter_name(0, 19, 60).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 19, 219).display(), content="TPFI")
  inspect(@lib.decode_parameter_name(0, 19, 228).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 19, 250).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 19, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 19, -1).display(),
    content="disc=0,cat=19,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 190, 0).display(), content="ATEXT")
  inspect(@lib.decode_parameter_name(0, 190, 50).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 190, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 190, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 190, -1).display(),
    content="disc=0,cat=190,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 191, 0).display(), content="TSEC")
  inspect(@lib.decode_parameter_name(0, 191, 7).display(), content="TDTSV")
  inspect(@lib.decode_parameter_name(0, 191, 80).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(0, 191, 194).display(), content="RTSEC")
  inspect(
    @lib.decode_parameter_name(0, 191, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 191, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 191, -1).display(),
    content="disc=0,cat=191,param=-1",
  )
  inspect(@lib.decode_parameter_name(0, 192, 1).display(), content="COVMZ")
  inspect(@lib.decode_parameter_name(0, 192, 13).display(), content="COVVVVV")
  inspect(@lib.decode_parameter_name(0, 192, 0).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(0, 192, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(0, 192, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(0, 192, -1).display(),
    content="disc=0,cat=192,param=-1",
  )
  inspect(@lib.decode_parameter_name(1, 0, 0).display(), content="FFLDG")
  inspect(@lib.decode_parameter_name(1, 0, 24).display(), content="DARVERVEL")
  inspect(@lib.decode_parameter_name(1, 0, 100).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(1, 0, 196).display(), content="AHD")
  inspect(
    @lib.decode_parameter_name(1, 0, 195).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(1, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(1, 0, -1).display(),
    content="disc=1,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_name(1, 1, 2).display(), content="POP")
  inspect(@lib.decode_parameter_name(1, 1, 3).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(1, 1, 195).display(), content="CWR")
  inspect(
    @lib.decode_parameter_name(1, 1, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(1, 1, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(1, 1, -1).display(),
    content="disc=1,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(1, 2, 0).display(), content="WDPTHIL")
  inspect(@lib.decode_parameter_name(1, 2, 23).display(), content="ARCRF")
  inspect(@lib.decode_parameter_name(1, 2, 24).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(1, 2, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(1, 2, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(1, 2, -1).display(),
    content="disc=1,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_name(2, 0, 0).display(), content="LAND")
  inspect(@lib.decode_parameter_name(2, 0, 63).display(), content="CANTMP")
  inspect(@lib.decode_parameter_name(2, 0, 100).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(2, 0, 205).display(), content="RCSOL")
  inspect(
    @lib.decode_parameter_name(2, 0, 250).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(2, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(2, 0, -1).display(),
    content="disc=2,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_name(2, 1, 192).display(), content="CANL")
  inspect(@lib.decode_parameter_name(2, 1, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(2, 1, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(2, 1, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(2, 1, -1).display(),
    content="disc=2,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(2, 3, 0).display(), content="SOTYP")
  inspect(@lib.decode_parameter_name(2, 3, 30).display(), content="SWET")
  inspect(@lib.decode_parameter_name(2, 3, 60).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(2, 3, 203).display(), content="FLDCP")
  inspect(
    @lib.decode_parameter_name(2, 3, 240).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(2, 3, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(2, 3, -1).display(),
    content="disc=2,cat=3,param=-1",
  )
  inspect(@lib.decode_parameter_name(2, 4, 0).display(), content="FIREOLK")
  inspect(@lib.decode_parameter_name(2, 4, 44).display(), content="IGNLTNG")
  inspect(@lib.decode_parameter_name(2, 4, 70).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(2, 4, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(2, 4, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(2, 4, -1).display(),
    content="disc=2,cat=4,param=-1",
  )
  inspect(@lib.decode_parameter_name(2, 5, 0).display(), content="GLACCOV")
  inspect(@lib.decode_parameter_name(2, 5, 1).display(), content="GLACTMP")
  inspect(@lib.decode_parameter_name(2, 5, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(2, 5, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(2, 5, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(2, 5, -1).display(),
    content="disc=2,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_name(2, 6, 0).display(), content="URBCOVER")
  inspect(@lib.decode_parameter_name(2, 6, 8).display(), content="DDROAD")
  inspect(@lib.decode_parameter_name(2, 6, 50).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(2, 6, 192).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(2, 6, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(2, 6, -1).display(),
    content="disc=2,cat=6,param=-1",
  )
  inspect(@lib.decode_parameter_name(2, 7, 0).display(), content="HNETFLUX")
  inspect(@lib.decode_parameter_name(2, 7, 2).display(), content="SHTFLUX")
  inspect(@lib.decode_parameter_name(2, 7, 20).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(2, 7, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(2, 7, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(2, 7, -1).display(),
    content="disc=2,cat=7,param=-1",
  )
  inspect(@lib.decode_parameter_name(3, 0, 0).display(), content="SRAD")
  inspect(@lib.decode_parameter_name(3, 0, 9).display(), content="FIREDI")
  inspect(@lib.decode_parameter_name(3, 0, 150).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(3, 0, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(3, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(3, 0, -1).display(),
    content="disc=3,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_name(3, 1, 27).display(), content="BRFLF")
  inspect(@lib.decode_parameter_name(3, 1, 193).display(), content="VSCT")
  inspect(@lib.decode_parameter_name(3, 1, 50).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(3, 1, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(3, 1, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(3, 1, -1).display(),
    content="disc=3,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(3, 2, 0).display(), content="CSKPROB")
  inspect(@lib.decode_parameter_name(3, 2, 30).display(), content="MEACST")
  inspect(@lib.decode_parameter_name(3, 2, 15).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(3, 2, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(3, 2, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(3, 2, -1).display(),
    content="disc=3,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_name(3, 3, 0).display(), content="PBMVFRC")
  inspect(@lib.decode_parameter_name(3, 3, 2).display(), content="PBINFRC")
  inspect(@lib.decode_parameter_name(3, 3, 50).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(3, 3, 210).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(3, 3, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(3, 3, -1).display(),
    content="disc=3,cat=3,param=-1",
  )
  inspect(@lib.decode_parameter_name(3, 4, 0).display(), content="VOLAPROB")
  inspect(@lib.decode_parameter_name(3, 4, 8).display(), content="VOLAPER")
  inspect(@lib.decode_parameter_name(3, 4, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(3, 4, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(3, 4, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(3, 4, -1).display(),
    content="disc=3,cat=4,param=-1",
  )
  inspect(@lib.decode_parameter_name(3, 5, 0).display(), content="ISSTMP")
  inspect(@lib.decode_parameter_name(3, 5, 5).display(), content="EBSDSSTS")
  inspect(@lib.decode_parameter_name(3, 5, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(3, 5, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(3, 5, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(3, 5, -1).display(),
    content="disc=3,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_name(3, 6, 0).display(), content="GSOLIRR")
  inspect(@lib.decode_parameter_name(3, 6, 3).display(), content="DIRSOLEX")
  inspect(@lib.decode_parameter_name(3, 6, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(3, 6, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(3, 6, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(3, 6, -1).display(),
    content="disc=3,cat=6,param=-1",
  )
  inspect(@lib.decode_parameter_name(3, 192, 0).display(), content="SBT122")
  inspect(@lib.decode_parameter_name(3, 192, 87).display(), content="SSMS1713")
  inspect(@lib.decode_parameter_name(3, 192, 120).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(3, 192, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(3, 192, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(3, 192, -1).display(),
    content="disc=3,cat=192,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 0, 0).display(), content="TMPSWP")
  inspect(@lib.decode_parameter_name(4, 0, 5).display(), content="PRPTMP")
  inspect(@lib.decode_parameter_name(4, 0, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 0, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 0, -1).display(),
    content="disc=4,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 1, 0).display(), content="SPEED")
  inspect(@lib.decode_parameter_name(4, 1, 3).display(), content="VEL3")
  inspect(@lib.decode_parameter_name(4, 1, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 1, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 1, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 1, -1).display(),
    content="disc=4,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 2, 0).display(), content="PLSMDEN")
  inspect(@lib.decode_parameter_name(4, 2, 13).display(), content="EQSLABT")
  inspect(@lib.decode_parameter_name(4, 2, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 2, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 2, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 2, -1).display(),
    content="disc=4,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 3, 0).display(), content="BTOT")
  inspect(@lib.decode_parameter_name(4, 3, 7).display(), content="EVEC3")
  inspect(@lib.decode_parameter_name(4, 3, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 3, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 3, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 3, -1).display(),
    content="disc=4,cat=3,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 4, 0).display(), content="DIFPFLUX")
  inspect(@lib.decode_parameter_name(4, 4, 6).display(), content="NTRNFLUX")
  inspect(@lib.decode_parameter_name(4, 4, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 4, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 4, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 4, -1).display(),
    content="disc=4,cat=4,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 5, 0).display(), content="AMPL")
  inspect(@lib.decode_parameter_name(4, 5, 3).display(), content="WAVELGTH")
  inspect(@lib.decode_parameter_name(4, 5, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 5, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 5, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 5, -1).display(),
    content="disc=4,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 6, 0).display(), content="TSI")
  inspect(@lib.decode_parameter_name(4, 6, 6).display(), content="SOLRF")
  inspect(@lib.decode_parameter_name(4, 6, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 6, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 6, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 6, -1).display(),
    content="disc=4,cat=6,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 7, 0).display(), content="LMBINT")
  inspect(@lib.decode_parameter_name(4, 7, 3).display(), content="DSKNGT")
  inspect(@lib.decode_parameter_name(4, 7, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 7, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 7, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 7, -1).display(),
    content="disc=4,cat=7,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 8, 0).display(), content="XRAYRAD")
  inspect(@lib.decode_parameter_name(4, 8, 8).display(), content="SICFL")
  inspect(@lib.decode_parameter_name(4, 8, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 8, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 8, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 8, -1).display(),
    content="disc=4,cat=8,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 9, 0).display(), content="SIGPED")
  inspect(@lib.decode_parameter_name(4, 9, 2).display(), content="SIGPAR")
  inspect(@lib.decode_parameter_name(4, 9, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 9, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 9, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 9, -1).display(),
    content="disc=4,cat=9,param=-1",
  )
  inspect(@lib.decode_parameter_name(4, 10, 0).display(), content="SCINIDX")
  inspect(@lib.decode_parameter_name(4, 10, 7).display(), content="AURELEC")
  inspect(@lib.decode_parameter_name(4, 10, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(4, 10, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(4, 10, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(4, 10, -1).display(),
    content="disc=4,cat=10,param=-1",
  )
  inspect(@lib.decode_parameter_name(10, 0, 0).display(), content="WVSP1")
  inspect(@lib.decode_parameter_name(10, 0, 104).display(), content="VASMF")
  inspect(@lib.decode_parameter_name(10, 0, 105).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(10, 0, 192).display(), content="WSTP")
  inspect(
    @lib.decode_parameter_name(10, 0, 194).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(10, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(10, 0, -1).display(),
    content="disc=10,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_name(10, 1, 0).display(), content="DIRC")
  inspect(@lib.decode_parameter_name(10, 1, 6).display(), content="NRTHCUR")
  inspect(@lib.decode_parameter_name(10, 1, 100).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(10, 1, 192).display(), content="OMLU")
  inspect(
    @lib.decode_parameter_name(10, 1, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(10, 1, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(10, 1, -1).display(),
    content="disc=10,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(10, 2, 0).display(), content="ICEC")
  inspect(@lib.decode_parameter_name(10, 2, 31).display(), content="DSWRFICE")
  inspect(@lib.decode_parameter_name(10, 2, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(10, 2, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(10, 2, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(10, 2, -1).display(),
    content="disc=10,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_name(10, 3, 0).display(), content="WTMP")
  inspect(@lib.decode_parameter_name(10, 3, 22).display(), content="DSWRFSS")
  inspect(@lib.decode_parameter_name(10, 3, 100).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(10, 3, 200).display(), content="SSST")
  inspect(@lib.decode_parameter_name(10, 3, 240).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(10, 3, 254).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(10, 3, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(10, 3, -1).display(),
    content="disc=10,cat=3,param=-1",
  )
  inspect(@lib.decode_parameter_name(10, 4, 0).display(), content="MTHD")
  inspect(@lib.decode_parameter_name(10, 4, 58).display(), content="DSWRFSEA")
  inspect(@lib.decode_parameter_name(10, 4, 9).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(10, 4, 192).display(), content="WTMPC")
  inspect(
    @lib.decode_parameter_name(10, 4, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(10, 4, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(10, 4, -1).display(),
    content="disc=10,cat=4,param=-1",
  )
  inspect(@lib.decode_parameter_name(10, 191, 0).display(), content="IRTSEC")
  inspect(@lib.decode_parameter_name(10, 191, 4).display(), content="BARDSF")
  inspect(@lib.decode_parameter_name(10, 191, 2).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(10, 191, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(10, 191, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(10, 191, -1).display(),
    content="disc=10,cat=191,param=-1",
  )
  inspect(@lib.decode_parameter_name(20, 0, 0).display(), content="UTHCIDX")
  inspect(@lib.decode_parameter_name(20, 0, 12).display(), content="ECF")
  inspect(@lib.decode_parameter_name(20, 0, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(20, 0, 200).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(20, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(20, 0, -1).display(),
    content="disc=20,cat=0,param=-1",
  )
  inspect(@lib.decode_parameter_name(20, 1, 0).display(), content="MALACASE")
  inspect(@lib.decode_parameter_name(20, 1, 9).display(), content="FMALVRH")
  inspect(@lib.decode_parameter_name(20, 1, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(20, 1, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(20, 1, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(20, 1, -1).display(),
    content="disc=20,cat=1,param=-1",
  )
  inspect(@lib.decode_parameter_name(20, 2, 0).display(), content="POPDEN")
  inspect(@lib.decode_parameter_name(20, 2, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(20, 2, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(20, 2, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(20, 2, -1).display(),
    content="disc=20,cat=2,param=-1",
  )
  inspect(@lib.decode_parameter_name(20, 3, 0).display(), content="RENPCAP")
  inspect(@lib.decode_parameter_name(20, 3, 9).display(), content="CSPPROD")
  inspect(@lib.decode_parameter_name(20, 3, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(20, 3, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(20, 3, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(20, 3, -1).display(),
    content="disc=20,cat=3,param=-1",
  )
  inspect(@lib.decode_parameter_name(20, 4, 1).display(), content="DBURSTHI")
  inspect(@lib.decode_parameter_name(20, 4, 60).display(), content="WINDHI")
  inspect(@lib.decode_parameter_name(20, 4, 0).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(20, 4, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(20, 4, 191).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(20, 4, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(20, 4, -1).display(),
    content="disc=20,cat=4,param=-1",
  )
  inspect(@lib.decode_parameter_name(20, 5, 1).display(), content="HHAIRPOLHI")
  inspect(@lib.decode_parameter_name(20, 5, 24).display(), content="EUTROPHI")
  inspect(@lib.decode_parameter_name(20, 5, 0).display(), content="Reserved")
  inspect(@lib.decode_parameter_name(20, 5, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(20, 5, 191).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(20, 5, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(20, 5, -1).display(),
    content="disc=20,cat=5,param=-1",
  )
  inspect(@lib.decode_parameter_name(191, 0, 0).display(), content="SPPT")
  inspect(@lib.decode_parameter_name(191, 0, 5).display(), content="STTP")
  inspect(@lib.decode_parameter_name(191, 0, 100).display(), content="Reserved")
  inspect(
    @lib.decode_parameter_name(191, 0, 220).display(),
    content="Reserved for Local Use",
  )
  inspect(@lib.decode_parameter_name(191, 0, 255).display(), content="Missing")
  inspect(
    @lib.decode_parameter_name(191, 0, -1).display(),
    content="disc=191,cat=0,param=-1",
  )
  inspect(
    @lib.decode_parameter_name(0, 99, 99).display(),
    content="disc=0,cat=99,param=99",
  )
  inspect(
    @lib.decode_level_name(100, 0, 500, 255, 0, 0).display(),
    content="5 mb",
  )
  inspect(
    @lib.decode_level_name(250, 0, 0, 251, 0, 0).display(),
    content="type250-type251",
  )
}
