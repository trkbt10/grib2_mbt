///|
test "section1 typed decode and encode roundtrip" {
  let section1 : Grib2Section1Decoded = {
    center: 34,
    subcenter: 0,
    master_table_version: 2,
    local_table_version: 1,
    significance_of_reference_time: 1,
    reference_year: 2026,
    reference_month: 2,
    reference_day: 21,
    reference_hour: 0,
    reference_minute: 0,
    reference_second: 30,
    production_status: 0,
    processed_data_type: 1,
    identification_template: IdTemplate12(24, 2),
    reserved_octets_22_23: b"\x00\x01",
    reserved_tail: b"\xaa\xbb",
  }
  let encoded = encode_section1_bytes(section1)
  inspect(encoded.length(), content="28")
  let decoded = match decode_section1_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.reference_year, content="2026")
  inspect(decoded.reference_second, content="30")
  inspect(decoded.reserved_octets_22_23 == b"\x00\x01", content="true")
  inspect(decoded.reserved_tail == b"\xaa\xbb", content="true")
  let reencoded = encode_section1_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section1 no identification template keeps reserved octets" {
  let section1 : Grib2Section1Decoded = {
    center: 7,
    subcenter: 0,
    master_table_version: 2,
    local_table_version: 1,
    significance_of_reference_time: 1,
    reference_year: 2026,
    reference_month: 2,
    reference_day: 21,
    reference_hour: 0,
    reference_minute: 0,
    reference_second: 0,
    production_status: 0,
    processed_data_type: 1,
    identification_template: IdTemplateNone,
    reserved_octets_22_23: b"\xfe\xfd",
    reserved_tail: b"",
  }
  let encoded = encode_section1_bytes(section1)
  inspect(encoded.length(), content="23")
  let decoded = match decode_section1_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.identification_template.to_string(), content="IdTemplateNone")
  inspect(decoded.reserved_octets_22_23 == b"\xfe\xfd", content="true")
  let reencoded = encode_section1_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
fn sample_template30_base() -> Grib2GridTemplate30 {
  {
    shape_of_earth: 6,
    scale_factor_radius: 0,
    scaled_value_radius: 0,
    scale_factor_major_axis: 0,
    scaled_value_major_axis: 0,
    scale_factor_minor_axis: 0,
    scaled_value_minor_axis: 0,
    ni: 360,
    nj: 181,
    basic_angle: 0,
    subdivisions_of_basic_angle: 0,
    la1: -90000000,
    lo1: 0,
    resolution_and_component_flags: 48,
    la2: 90000000,
    lo2: 359000000,
    di: 1000000,
    dj: 1000000,
    scanning_mode: 0,
  }
}

///|
test "section3 template30 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 65160,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate30(sample_template30_base()),
    optional_points_raw: b"",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_data_points, content="65160")
  match decoded.template {
    GridTemplate30(template30) => {
      inspect(template30.ni, content="360")
      inspect(template30.nj, content="181")
      inspect(template30.la1, content="-90000000")
    }
    _ => fail("template3.0 was not decoded")
  }
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template31 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 65160,
    optional_points_octet_count: 2,
    optional_points_interpretation: 1,
    template: GridTemplate31({
      base: sample_template30_base(),
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
      angle_of_rotation: 1000000,
    }),
    optional_points_raw: b"\x01\x02",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate31(template31) => {
      inspect(template31.latitude_of_southern_pole, content="-30000000")
      inspect(template31.longitude_of_southern_pole, content="120000000")
      inspect(template31.angle_of_rotation, content="1000000")
    }
    _ => fail("template3.1 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\x01\x02", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template32 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 65160,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate32({
      base: sample_template30_base(),
      latitude_of_stretching_pole: 45000000,
      longitude_of_stretching_pole: 135000000,
      stretching_factor: 1500000,
    }),
    optional_points_raw: b"",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate32(template32) => {
      inspect(template32.latitude_of_stretching_pole, content="45000000")
      inspect(template32.longitude_of_stretching_pole, content="135000000")
      inspect(template32.stretching_factor, content="1500000")
    }
    _ => fail("template3.2 was not decoded")
  }
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template33 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 65160,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate33({
      base: sample_template30_base(),
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
      angle_of_rotation: 1000000,
      latitude_of_stretching_pole: 45000000,
      longitude_of_stretching_pole: 135000000,
      stretching_factor: 1500000,
    }),
    optional_points_raw: b"\xaa",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate33(template33) => {
      inspect(template33.angle_of_rotation, content="1000000")
      inspect(template33.latitude_of_stretching_pole, content="45000000")
      inspect(template33.stretching_factor, content="1500000")
    }
    _ => fail("template3.3 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xaa", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template34 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate34({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      ni: 3,
      nj: 2,
      basic_angle: 0,
      subdivisions_of_basic_angle: 0,
      resolution_and_component_flags: 0,
      scanning_mode: 0,
      longitude_list: [1000000, 2000000, 3000000],
      latitude_list: [4000000, 5000000],
    }),
    optional_points_raw: b"\xff",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate34(template34) => {
      inspect(template34.ni, content="3")
      inspect(template34.nj, content="2")
      inspect(template34.longitude_list.length(), content="3")
      inspect(template34.latitude_list.length(), content="2")
    }
    _ => fail("template3.4 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xff", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template35 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate35({
      base: {
        shape_of_earth: 6,
        scale_factor_radius: 0,
        scaled_value_radius: 0,
        scale_factor_major_axis: 0,
        scaled_value_major_axis: 0,
        scale_factor_minor_axis: 0,
        scaled_value_minor_axis: 0,
        ni: 3,
        nj: 2,
        basic_angle: 0,
        subdivisions_of_basic_angle: 0,
        resolution_and_component_flags: 0,
        scanning_mode: 0,
        longitude_list: [1000000, 2000000, 3000000],
        latitude_list: [4000000, 5000000],
      },
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
      angle_of_rotation: 1000000,
    }),
    optional_points_raw: b"",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate35(template35) => {
      inspect(template35.base.longitude_list.length(), content="3")
      inspect(template35.base.latitude_list.length(), content="2")
      inspect(template35.angle_of_rotation, content="1000000")
    }
    _ => fail("template3.5 was not decoded")
  }
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template310 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate310({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      ni: 3,
      nj: 2,
      la1: -1000000,
      lo1: 130000000,
      resolution_and_component_flags: 0,
      lad: 0,
      la2: 1000000,
      lo2: 131000000,
      scanning_mode: 0,
      orientation_of_the_grid: 0,
      di: 16000,
      dj: 16000,
    }),
    optional_points_raw: b"\xdd",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate310(template310) => {
      inspect(template310.ni, content="3")
      inspect(template310.nj, content="2")
      inspect(template310.lo1, content="130000000")
      inspect(template310.di, content="16000")
    }
    _ => fail("template3.10 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xdd", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template312 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate312({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      ni: 3,
      nj: 2,
      lar: 35000000,
      lor: 140000000,
      resolution_and_component_flags: 0,
      m: 1065353216,
      xr: 100,
      yr: 200,
      scanning_mode: 0,
      di: 1600,
      dj: 1600,
      x1: 1000,
      y1: 2000,
      x2: 3000,
      y2: 4000,
    }),
    optional_points_raw: b"\xab",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate312(template312) => {
      inspect(template312.ni, content="3")
      inspect(template312.nj, content="2")
      inspect(template312.lor, content="140000000")
      inspect(template312.x2, content="3000")
    }
    _ => fail("template3.12 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xab", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template313 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate313({
      base: {
        shape_of_earth: 6,
        scale_factor_radius: 0,
        scaled_value_radius: 0,
        scale_factor_major_axis: 0,
        scaled_value_major_axis: 0,
        scale_factor_minor_axis: 0,
        scaled_value_minor_axis: 0,
        ni: 3,
        nj: 2,
        la1: -1000000,
        lo1: 130000000,
        resolution_and_component_flags: 0,
        lad: 0,
        la2: 1000000,
        lo2: 131000000,
        scanning_mode: 0,
        orientation_of_the_grid: 0,
        di: 16000,
        dj: 16000,
      },
      nux: 20,
      ncx: 2,
      nuy: 30,
      ncy: 3,
    }),
    optional_points_raw: b"",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate313(template313) => {
      inspect(template313.base.ni, content="3")
      inspect(template313.base.nj, content="2")
      inspect(template313.nux, content="20")
      inspect(template313.ncy, content="3")
    }
    _ => fail("template3.13 was not decoded")
  }
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template320 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate320({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      nx: 3,
      ny: 2,
      la1: 60000000,
      lo1: 120000000,
      resolution_and_component_flags: 0,
      lad: 60000000,
      lov: 140000000,
      dx: 10000,
      dy: 10000,
      projection_center_flag: 0,
      scanning_mode: 0,
    }),
    optional_points_raw: b"\xac",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate320(template320) => {
      inspect(template320.nx, content="3")
      inspect(template320.ny, content="2")
      inspect(template320.lov, content="140000000")
      inspect(template320.dx, content="10000")
    }
    _ => fail("template3.20 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xac", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template323 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate323({
      base: {
        shape_of_earth: 6,
        scale_factor_radius: 0,
        scaled_value_radius: 0,
        scale_factor_major_axis: 0,
        scaled_value_major_axis: 0,
        scale_factor_minor_axis: 0,
        scaled_value_minor_axis: 0,
        nx: 3,
        ny: 2,
        la1: 60000000,
        lo1: 120000000,
        resolution_and_component_flags: 0,
        lad: 60000000,
        lov: 140000000,
        dx: 10000,
        dy: 10000,
        projection_center_flag: 0,
        scanning_mode: 0,
      },
      nux: 200,
      ncx: 20,
      nuy: 150,
      ncy: 15,
    }),
    optional_points_raw: b"\xad",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate323(template323) => {
      inspect(template323.base.nx, content="3")
      inspect(template323.base.ny, content="2")
      inspect(template323.nux, content="200")
      inspect(template323.ncy, content="15")
    }
    _ => fail("template3.23 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xad", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template330 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate330({
      base: {
        shape_of_earth: 6,
        scale_factor_radius: 0,
        scaled_value_radius: 0,
        scale_factor_major_axis: 0,
        scaled_value_major_axis: 0,
        scale_factor_minor_axis: 0,
        scaled_value_minor_axis: 0,
        nx: 3,
        ny: 2,
        la1: 60000000,
        lo1: 120000000,
        resolution_and_component_flags: 0,
        lad: 60000000,
        lov: 140000000,
        dx: 10000,
        dy: 10000,
        projection_center_flag: 0,
        scanning_mode: 0,
      },
      latin1: 30000000,
      latin2: 60000000,
      latitude_of_southern_pole: -90000000,
      longitude_of_southern_pole: 0,
    }),
    optional_points_raw: b"\xae",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate330(template330) => {
      inspect(template330.base.nx, content="3")
      inspect(template330.base.ny, content="2")
      inspect(template330.latin1, content="30000000")
      inspect(template330.latitude_of_southern_pole, content="-90000000")
    }
    _ => fail("template3.30 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xae", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template331 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate331({
      base: {
        base: {
          shape_of_earth: 6,
          scale_factor_radius: 0,
          scaled_value_radius: 0,
          scale_factor_major_axis: 0,
          scaled_value_major_axis: 0,
          scale_factor_minor_axis: 0,
          scaled_value_minor_axis: 0,
          nx: 3,
          ny: 2,
          la1: 60000000,
          lo1: 120000000,
          resolution_and_component_flags: 0,
          lad: 60000000,
          lov: 140000000,
          dx: 10000,
          dy: 10000,
          projection_center_flag: 0,
          scanning_mode: 0,
        },
        latin1: 25000000,
        latin2: 55000000,
        latitude_of_southern_pole: -90000000,
        longitude_of_southern_pole: 0,
      },
    }),
    optional_points_raw: b"",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate331(template331) => {
      inspect(template331.base.base.nx, content="3")
      inspect(template331.base.latin2, content="55000000")
      inspect(template331.base.longitude_of_southern_pole, content="0")
    }
    _ => fail("template3.31 was not decoded")
  }
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template333 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate333({
      base: {
        base: {
          shape_of_earth: 6,
          scale_factor_radius: 0,
          scaled_value_radius: 0,
          scale_factor_major_axis: 0,
          scaled_value_major_axis: 0,
          scale_factor_minor_axis: 0,
          scaled_value_minor_axis: 0,
          nx: 3,
          ny: 2,
          la1: 60000000,
          lo1: 120000000,
          resolution_and_component_flags: 0,
          lad: 60000000,
          lov: 140000000,
          dx: 10000,
          dy: 10000,
          projection_center_flag: 0,
          scanning_mode: 0,
        },
        latin1: 30000000,
        latin2: 60000000,
        latitude_of_southern_pole: -90000000,
        longitude_of_southern_pole: 0,
      },
      nux: 200,
      ncx: 20,
      nuy: 150,
      ncy: 15,
    }),
    optional_points_raw: b"\xaf",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate333(template333) => {
      inspect(template333.base.base.nx, content="3")
      inspect(template333.base.latin1, content="30000000")
      inspect(template333.nux, content="200")
      inspect(template333.ncy, content="15")
    }
    _ => fail("template3.33 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xaf", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template340 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate340({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      ni: 360,
      nj: 181,
      basic_angle: 0,
      subdivisions_of_basic_angle: 0,
      la1: -90000000,
      lo1: 0,
      resolution_and_component_flags: 48,
      la2: 90000000,
      lo2: 359000000,
      di: 1000000,
      n: 90,
      scanning_mode: 0,
    }),
    optional_points_raw: b"\xb0",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate340(template340) => {
      inspect(template340.ni, content="360")
      inspect(template340.nj, content="181")
      inspect(template340.di, content="1000000")
      inspect(template340.n, content="90")
    }
    _ => fail("template3.40 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb0", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template341 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate341({
      base: {
        shape_of_earth: 6,
        scale_factor_radius: 0,
        scaled_value_radius: 0,
        scale_factor_major_axis: 0,
        scaled_value_major_axis: 0,
        scale_factor_minor_axis: 0,
        scaled_value_minor_axis: 0,
        ni: 360,
        nj: 181,
        basic_angle: 0,
        subdivisions_of_basic_angle: 0,
        la1: -90000000,
        lo1: 0,
        resolution_and_component_flags: 48,
        la2: 90000000,
        lo2: 359000000,
        di: 1000000,
        n: 90,
        scanning_mode: 0,
      },
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
      angle_of_rotation: 1000000,
    }),
    optional_points_raw: b"\xb1",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate341(template341) => {
      inspect(template341.base.ni, content="360")
      inspect(template341.latitude_of_southern_pole, content="-30000000")
      inspect(template341.angle_of_rotation, content="1000000")
    }
    _ => fail("template3.41 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb1", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template342 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate342({
      base: {
        shape_of_earth: 6,
        scale_factor_radius: 0,
        scaled_value_radius: 0,
        scale_factor_major_axis: 0,
        scaled_value_major_axis: 0,
        scale_factor_minor_axis: 0,
        scaled_value_minor_axis: 0,
        ni: 360,
        nj: 181,
        basic_angle: 0,
        subdivisions_of_basic_angle: 0,
        la1: -90000000,
        lo1: 0,
        resolution_and_component_flags: 48,
        la2: 90000000,
        lo2: 359000000,
        di: 1000000,
        n: 90,
        scanning_mode: 0,
      },
      latitude_of_stretching_pole: 45000000,
      longitude_of_stretching_pole: 135000000,
      stretching_factor: 1500000,
    }),
    optional_points_raw: b"\xb2",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate342(template342) => {
      inspect(template342.base.nj, content="181")
      inspect(template342.latitude_of_stretching_pole, content="45000000")
      inspect(template342.stretching_factor, content="1500000")
    }
    _ => fail("template3.42 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb2", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template343 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 6,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate343({
      base: {
        shape_of_earth: 6,
        scale_factor_radius: 0,
        scaled_value_radius: 0,
        scale_factor_major_axis: 0,
        scaled_value_major_axis: 0,
        scale_factor_minor_axis: 0,
        scaled_value_minor_axis: 0,
        ni: 360,
        nj: 181,
        basic_angle: 0,
        subdivisions_of_basic_angle: 0,
        la1: -90000000,
        lo1: 0,
        resolution_and_component_flags: 48,
        la2: 90000000,
        lo2: 359000000,
        di: 1000000,
        n: 90,
        scanning_mode: 0,
      },
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
      angle_of_rotation: 1000000,
      latitude_of_stretching_pole: 45000000,
      longitude_of_stretching_pole: 135000000,
      stretching_factor: 1500000,
    }),
    optional_points_raw: b"\xb3",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate343(template343) => {
      inspect(template343.base.di, content="1000000")
      inspect(template343.longitude_of_southern_pole, content="120000000")
      inspect(template343.longitude_of_stretching_pole, content="135000000")
      inspect(template343.stretching_factor, content="1500000")
    }
    _ => fail("template3.43 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb3", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template350 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate350({
      j: 799,
      k: 799,
      m: 0,
      representation_type: 1,
      representation_mode: 2,
    }),
    optional_points_raw: b"\xb4",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate350(template350) => {
      inspect(template350.j, content="799")
      inspect(template350.k, content="799")
      inspect(template350.representation_mode, content="2")
    }
    _ => fail("template3.50 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb4", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template351 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate351({
      base: {
        j: 799,
        k: 799,
        m: 0,
        representation_type: 1,
        representation_mode: 2,
      },
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
      angle_of_rotation: 1000000,
    }),
    optional_points_raw: b"\xb5",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate351(template351) => {
      inspect(template351.base.j, content="799")
      inspect(template351.latitude_of_southern_pole, content="-30000000")
      inspect(template351.angle_of_rotation, content="1000000")
    }
    _ => fail("template3.51 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb5", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template352 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate352({
      base: {
        j: 799,
        k: 799,
        m: 0,
        representation_type: 1,
        representation_mode: 2,
      },
      latitude_of_stretching_pole: 45000000,
      longitude_of_stretching_pole: 135000000,
      stretching_factor: 1500000,
    }),
    optional_points_raw: b"\xb6",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate352(template352) => {
      inspect(template352.base.k, content="799")
      inspect(template352.latitude_of_stretching_pole, content="45000000")
      inspect(template352.stretching_factor, content="1500000")
    }
    _ => fail("template3.52 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb6", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template353 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate353({
      base: {
        j: 799,
        k: 799,
        m: 0,
        representation_type: 1,
        representation_mode: 2,
      },
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
      angle_of_rotation: 1000000,
      latitude_of_stretching_pole: 45000000,
      longitude_of_stretching_pole: 135000000,
      stretching_factor: 1500000,
    }),
    optional_points_raw: b"\xb7",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate353(template353) => {
      inspect(template353.base.m, content="0")
      inspect(template353.longitude_of_southern_pole, content="120000000")
      inspect(template353.longitude_of_stretching_pole, content="135000000")
      inspect(template353.stretching_factor, content="1500000")
    }
    _ => fail("template3.53 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb7", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template360 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 16,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate360({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      nx: 4,
      ny: 4,
      nc: 3,
      xshift: 0,
      yshift: 1,
      face_number: 2,
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
      angle_of_rotation: 1000000,
      stretching_factor: 1000000,
      gnomonic_grid_spacing_parameter: 500000,
      resolution_and_component_flags: 48,
      scanning_and_staggering_flags: 0,
    }),
    optional_points_raw: b"\xb8",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate360(template360) => {
      inspect(template360.nx, content="4")
      inspect(template360.nc, content="3")
      inspect(template360.face_number, content="2")
      inspect(template360.gnomonic_grid_spacing_parameter, content="500000")
    }
    _ => fail("template3.60 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb8", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template361 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate361({
      spectral_representation_type: 1,
      n: 128,
      m: 64,
      bi_fourier_truncation_type: 2,
      lx: { high: 0, low: 1000000 },
      lux: { high: 0, low: 800000 },
      lcx: { high: 0, low: 10000 },
      ly: { high: 0, low: 900000 },
      luy: { high: 0, low: 700000 },
      lcy: { high: 0, low: 10000 },
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      la1: -1000000,
      lo1: 130000000,
      lad: 0,
      la2: 1000000,
      lo2: 131000000,
      orientation_of_the_grid: 0,
    }),
    optional_points_raw: b"\xb9",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate361(template361) => {
      inspect(template361.n, content="128")
      inspect(template361.lx.low, content="1000000")
      inspect(template361.luy.low, content="700000")
      inspect(template361.orientation_of_the_grid, content="0")
    }
    _ => fail("template3.61 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xb9", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template362 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate362({
      spectral_representation_type: 1,
      n: 128,
      m: 64,
      bi_fourier_truncation_type: 2,
      lx: { high: 0, low: 1000000 },
      lux: { high: 0, low: 800000 },
      lcx: { high: 0, low: 10000 },
      ly: { high: 0, low: 900000 },
      luy: { high: 0, low: 700000 },
      lcy: { high: 0, low: 10000 },
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      la1: -1000000,
      lo1: 130000000,
      resolution_and_component_flags: 48,
      lad: 60000000,
      lov: 140000000,
      projection_center_flag: 0,
    }),
    optional_points_raw: b"\xba",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate362(template362) => {
      inspect(template362.m, content="64")
      inspect(template362.lcx.low, content="10000")
      inspect(template362.lov, content="140000000")
      inspect(template362.projection_center_flag, content="0")
    }
    _ => fail("template3.62 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xba", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template363 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate363({
      spectral_representation_type: 1,
      n: 128,
      m: 64,
      bi_fourier_truncation_type: 2,
      lx: { high: 0, low: 1000000 },
      lux: { high: 0, low: 800000 },
      lcx: { high: 0, low: 10000 },
      ly: { high: 0, low: 900000 },
      luy: { high: 0, low: 700000 },
      lcy: { high: 0, low: 10000 },
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      la1: -1000000,
      lo1: 130000000,
      lad: 60000000,
      lov: 140000000,
      projection_center_flag: 0,
      latin1: 30000000,
      latin2: 60000000,
      latitude_of_southern_pole: -30000000,
      longitude_of_southern_pole: 120000000,
    }),
    optional_points_raw: b"\xbb",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate363(template363) => {
      inspect(template363.n, content="128")
      inspect(template363.lx.low, content="1000000")
      inspect(template363.latin2, content="60000000")
      inspect(template363.longitude_of_southern_pole, content="120000000")
    }
    _ => fail("template3.63 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xbb", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template390 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 16,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate390({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      nx: 4,
      ny: 4,
      latitude_of_sub_satellite_point: 0,
      longitude_of_sub_satellite_point: 140000000,
      resolution_and_component_flags: 48,
      dx: 1000,
      dy: 1000,
      xp: 2000,
      yp: 1500,
      scanning_mode: 0,
      orientation_of_the_grid: 0,
      nr: 42164000,
      xo: 0,
      yo: 0,
    }),
    optional_points_raw: b"\xbc",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate390(template390) => {
      inspect(template390.nx, content="4")
      inspect(template390.ny, content="4")
      inspect(template390.longitude_of_sub_satellite_point, content="140000000")
      inspect(template390.nr, content="42164000")
    }
    _ => fail("template3.90 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xbc", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template3100 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 10,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate3100({
      n2: 4,
      n3: 1,
      ni: 48,
      nd: 10,
      latitude_of_the_pole_point: 90000000,
      longitude_of_the_pole_point: 0,
      longitude_of_the_centre_line_of_first_diamond: 180000000,
      grid_point_position: 1,
      numbering_order_of_diamonds: 0,
      scanning_mode_for_one_diamond: 0,
      nt: 1000,
    }),
    optional_points_raw: b"\xbd",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate3100(template3100) => {
      inspect(template3100.n2, content="4")
      inspect(template3100.ni, content="48")
      inspect(template3100.nd, content="10")
      inspect(template3100.nt, content="1000")
    }
    _ => fail("template3.100 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xbd", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template3101 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 10,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate3101({
      shape_of_earth: 6,
      number_of_grid_used: 42,
      number_of_grid_in_reference: 1,
      uuid_of_horizontal_grid: b"\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99\xaa\xbb\xcc\xdd\xee\xff",
    }),
    optional_points_raw: b"\xbe",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate3101(template3101) => {
      inspect(template3101.shape_of_earth, content="6")
      inspect(template3101.number_of_grid_used, content="42")
      inspect(template3101.number_of_grid_in_reference, content="1")
      inspect(template3101.uuid_of_horizontal_grid.length(), content="16")
    }
    _ => fail("template3.101 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xbe", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template3110 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 16,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate3110({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      nx: 4,
      ny: 4,
      latitude_of_tangency_point: 0,
      longitude_of_tangency_point: 140000000,
      resolution_and_component_flags: 48,
      dx: 1000,
      dy: 1000,
      projection_center_flag: 0,
      scanning_mode: 0,
    }),
    optional_points_raw: b"\xbf",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate3110(template3110) => {
      inspect(template3110.nx, content="4")
      inspect(template3110.ny, content="4")
      inspect(template3110.longitude_of_tangency_point, content="140000000")
      inspect(template3110.dx, content="1000")
    }
    _ => fail("template3.110 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xbf", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template3120 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 12,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate3120({
      nb: 4,
      nr: 3,
      la1: 35000000,
      lo1: 139000000,
      dx: 1000,
      dstart: 500,
      scanning_mode: 0,
      radials: [
        { starting_azimuth: 0, azimuthal_width: 100 },
        { starting_azimuth: 1200, azimuthal_width: 100 },
        { starting_azimuth: 2400, azimuthal_width: 100 },
      ],
    }),
    optional_points_raw: b"\xc0",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate3120(template3120) => {
      inspect(template3120.nb, content="4")
      inspect(template3120.nr, content="3")
      inspect(template3120.radials.length(), content="3")
      inspect(template3120.radials[2].starting_azimuth, content="2400")
    }
    _ => fail("template3.120 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc0", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template3140 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 16,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate3140({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      nx: 4,
      ny: 4,
      la1: 35000000,
      lo1: 139000000,
      standard_parallel: 30000000,
      central_longitude: 140000000,
      resolution_and_component_flags: 48,
      dx: 1000,
      dy: 1000,
      scanning_mode: 0,
    }),
    optional_points_raw: b"\xc1",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate3140(template3140) => {
      inspect(template3140.nx, content="4")
      inspect(template3140.ny, content="4")
      inspect(template3140.standard_parallel, content="30000000")
      inspect(template3140.central_longitude, content="140000000")
    }
    _ => fail("template3.140 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc1", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template3150 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 48,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate3150({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      resolution_and_component_flags: 48,
      nsides: 16,
      lo: 180000000,
      grid_point_position: 1,
      numbering_order: 0,
      scanning_mode: 0,
    }),
    optional_points_raw: b"\xc2",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate3150(template3150) => {
      inspect(template3150.shape_of_earth, content="6")
      inspect(template3150.nsides, content="16")
      inspect(template3150.lo, content="180000000")
      inspect(template3150.grid_point_position, content="1")
    }
    _ => fail("template3.150 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc2", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template3204 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 12,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate3204({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      ni: 4,
      nj: 3,
      reserved_octets_39_54: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
      resolution_and_component_flags: 48,
      reserved_octets_56_71: b"\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01",
      scanning_mode: 0,
    }),
    optional_points_raw: b"\xc3",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate3204(template3204) => {
      inspect(template3204.ni, content="4")
      inspect(template3204.nj, content="3")
      inspect(template3204.resolution_and_component_flags, content="48")
      inspect(template3204.reserved_octets_56_71.length(), content="16")
    }
    _ => fail("template3.204 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc3", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template31000 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 24,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate31000({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      number_of_horizontal_points: 8,
      basic_angle: 0,
      subdivisions_of_basic_angle: 0,
      la1: 35000000,
      lo1: 139000000,
      scanning_mode: 0,
      la2: 36000000,
      lo2: 140000000,
      type_of_horizontal_line: 0,
      number_of_vertical_points: 3,
      physical_meaning_of_vertical_coordinate: 100,
      vertical_dimension_coordinate_values_definition: 1,
      nc: 2,
      vertical_coordinate_values_raw: b"\x3f\x80\x00\x00\x40\x00\x00\x00",
    }),
    optional_points_raw: b"\xc4",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate31000(template31000) => {
      inspect(template31000.number_of_horizontal_points, content="8")
      inspect(template31000.number_of_vertical_points, content="3")
      inspect(template31000.nc, content="2")
      inspect(
        template31000.vertical_coordinate_values_raw.length(),
        content="8",
      )
    }
    _ => fail("template3.1000 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc4", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template31100 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 16,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate31100({
      shape_of_earth: 6,
      scale_factor_radius: 0,
      scaled_value_radius: 0,
      scale_factor_major_axis: 0,
      scaled_value_major_axis: 0,
      scale_factor_minor_axis: 0,
      scaled_value_minor_axis: 0,
      number_of_horizontal_points: 4,
      basic_angle: 0,
      subdivisions_of_basic_angle: 0,
      la1: 35000000,
      lo1: 139000000,
      scanning_mode: 0,
      la2: 36000000,
      lo2: 140000000,
      type_of_horizontal_line: 0,
      nt: 12,
      unit_of_offset_from_reference_time: 1,
      offset_from_reference_of_first_time: 0,
      type_of_time_increment: 2,
      unit_of_time_increment: 1,
      time_increment: 3,
      last_year: 2026,
      last_month: 2,
      last_day: 21,
      last_hour: 9,
      last_minute: 30,
      last_second: 0,
    }),
    optional_points_raw: b"\xc5",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate31100(template31100) => {
      inspect(template31100.nt, content="12")
      inspect(template31100.unit_of_time_increment, content="1")
      inspect(template31100.time_increment, content="3")
      inspect(template31100.last_year, content="2026")
    }
    _ => fail("template3.1100 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc5", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template31200 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 8,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate31200({
      nt: 8,
      unit_of_offset_from_reference_time: 1,
      offset_from_reference_of_first_time: 0,
      type_of_time_increment: 2,
      unit_of_time_increment: 1,
      time_increment: 3,
      last_year: 2026,
      last_month: 2,
      last_day: 21,
      last_hour: 9,
      last_minute: 0,
      last_second: 0,
      number_of_vertical_points: 2,
      physical_meaning_of_vertical_coordinate: 100,
      vertical_dimension_coordinate_values_definition: 1,
      nc: 2,
      vertical_coordinate_values_raw: b"\x3f\x80\x00\x00\x40\x00\x00\x00",
    }),
    optional_points_raw: b"\xc6",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate31200(template31200) => {
      inspect(template31200.nt, content="8")
      inspect(template31200.number_of_vertical_points, content="2")
      inspect(template31200.nc, content="2")
      inspect(
        template31200.vertical_coordinate_values_raw.length(),
        content="8",
      )
    }
    _ => fail("template3.1200 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc6", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template332768 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 65160,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate332768({ base: sample_template30_base() }),
    optional_points_raw: b"\xc7",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate332768(template332768) => {
      inspect(template332768.base.ni, content="360")
      inspect(template332768.base.nj, content="181")
      inspect(template332768.base.scanning_mode, content="0")
    }
    _ => fail("template3.32768 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc7", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section3 template332769 typed decode and encode roundtrip" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 65160,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplate332769({
      base: sample_template30_base(),
      latitude_of_grid_point_ni_nj: 35000000,
      longitude_of_grid_point_ni_nj: 139000000,
    }),
    optional_points_raw: b"\xc8",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    GridTemplate332769(template332769) => {
      inspect(template332769.base.ni, content="360")
      inspect(template332769.latitude_of_grid_point_ni_nj, content="35000000")
      inspect(template332769.longitude_of_grid_point_ni_nj, content="139000000")
    }
    _ => fail("template3.32769 was not decoded")
  }
  inspect(decoded.optional_points_raw == b"\xc8", content="true")
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
fn sample_template40_base() -> Grib2ProductTemplate40 {
  {
    parameter_category: 0,
    parameter_number: 0,
    type_of_generating_process: 2,
    background_process_identifier: 0,
    generating_process_identifier: 96,
    hours_of_observational_data_cutoff: 0,
    minutes_of_observational_data_cutoff: 0,
    time_range_unit: 1,
    forecast_time: 6,
    type_of_first_fixed_surface: 100,
    scale_factor_of_first_fixed_surface: 0,
    scaled_value_of_first_fixed_surface: 50000,
    type_of_second_fixed_surface: 255,
    scale_factor_of_second_fixed_surface: 0,
    scaled_value_of_second_fixed_surface: 0,
  }
}

///|
fn sample_time_range_specs() -> Array[Grib2TimeRangeSpec] {
  [
    {
      statistical_process: 1,
      type_of_time_increment: 2,
      time_range_unit: 1,
      time_range_length: 6,
      time_increment_unit: 1,
      time_increment_length: 3,
    },
    {
      statistical_process: 3,
      type_of_time_increment: 4,
      time_range_unit: 1,
      time_range_length: 12,
      time_increment_unit: 1,
      time_increment_length: 6,
    },
  ]
}

///|
fn sample_verification_definition() -> Grib2VerificationDefinition {
  {
    type_of_reference_dataset: 2,
    type_of_statistical_processing_over_vertical: 1,
    type_of_threshold_operator: 3,
    type_of_additional_arguments: 4,
    number_of_additional_arguments: 2,
    additional_arguments: [
      { scale_factor: 0, scaled_value: 10 },
      { scale_factor: 1, scaled_value: 20 },
    ],
    start_year: 2020,
    start_month: 1,
    start_day: 2,
    start_hour: 3,
    start_minute: 4,
    start_second: 5,
    number_of_verification_period_time_ranges: 2,
    verification_period_time_range_specs: [
      {
        statistical_processing_type: 1,
        time_range_unit: 1,
        time_range_length: 6,
        time_increment_unit: 1,
        time_increment_length: 3,
      },
      {
        statistical_processing_type: 2,
        time_range_unit: 1,
        time_range_length: 12,
        time_increment_unit: 1,
        time_increment_length: 6,
      },
    ],
    number_of_forecasts_in_verification: 77,
  }
}

///|
test "section4 template40 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 2,
    template: ProductTemplate40(sample_template40_base()),
    coordinate_values_raw: b"\x3f\x80\x00\x00\x40\x00\x00\x00",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  inspect(decoded.number_of_coordinate_values, content="2")
  inspect(
    decoded.coordinate_values_raw == b"\x3f\x80\x00\x00\x40\x00\x00\x00",
    content="true",
  )
  match decoded.template {
    ProductTemplate40(template40) => {
      inspect(template40.parameter_number, content="0")
      inspect(template40.forecast_time, content="6")
      inspect(template40.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.0 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41(template41) => {
      inspect(template41.type_of_ensemble_forecast, content="2")
      inspect(template41.perturbation_number, content="3")
      inspect(template41.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.1 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template42 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate42({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate42(template42) => {
      inspect(template42.derived_forecast, content="5")
      inspect(template42.number_of_forecasts_in_ensemble, content="50")
    }
    _ => fail("template4.2 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template43 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate43({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
      cluster_identifier: 1,
      cluster_for_high_resolution_control: 2,
      cluster_for_low_resolution_control: 3,
      total_number_of_clusters: 4,
      clustering_method: 1,
      northern_latitude_of_cluster_domain: 50000000,
      southern_latitude_of_cluster_domain: 30000000,
      eastern_longitude_of_cluster_domain: 140000000,
      western_longitude_of_cluster_domain: 120000000,
      number_of_forecasts_in_cluster: 3,
      scale_factor_of_standard_deviation: 0,
      scaled_value_of_standard_deviation: 1234,
      scale_factor_of_distance_from_ensemble_mean: 0,
      scaled_value_of_distance_from_ensemble_mean: 5678,
      ensemble_forecast_numbers: [1, 2, 3],
      reserved_tail: b"\xaa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate43(template43) => {
      inspect(template43.number_of_forecasts_in_cluster, content="3")
      inspect(template43.ensemble_forecast_numbers.length(), content="3")
      inspect(template43.reserved_tail == b"\xaa", content="true")
    }
    _ => fail("template4.3 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template44 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate44({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
      cluster_identifier: 1,
      cluster_for_high_resolution_control: 2,
      cluster_for_low_resolution_control: 3,
      total_number_of_clusters: 4,
      clustering_method: 1,
      latitude_of_central_point: 40000000,
      longitude_of_central_point: 130000000,
      radius_of_cluster_domain: 1000000,
      number_of_forecasts_in_cluster: 2,
      scale_factor_of_standard_deviation: 0,
      scaled_value_of_standard_deviation: 4321,
      scale_factor_of_distance_from_ensemble_mean: 0,
      scaled_value_of_distance_from_ensemble_mean: 8765,
      ensemble_forecast_numbers: [4, 5],
      reserved_tail: b"\xbb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate44(template44) => {
      inspect(template44.number_of_forecasts_in_cluster, content="2")
      inspect(template44.ensemble_forecast_numbers.length(), content="2")
      inspect(template44.reserved_tail == b"\xbb", content="true")
    }
    _ => fail("template4.4 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template45 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate45({
      base: sample_template40_base(),
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reserved_tail: b"\xcc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate45(template45) => {
      inspect(template45.forecast_probability_number, content="2")
      inspect(template45.scaled_value_of_upper_limit, content="200")
      inspect(template45.reserved_tail == b"\xcc", content="true")
    }
    _ => fail("template4.5 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template46 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate46({
      base: sample_template40_base(),
      percentile_value: 90,
      reserved_tail: b"\xee",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate46(template46) => {
      inspect(template46.percentile_value, content="90")
      inspect(template46.reserved_tail == b"\xee", content="true")
    }
    _ => fail("template4.6 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template47 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate47({
      base: sample_template40_base(),
      reserved_tail: b"\xef",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate47(template47) => {
      inspect(template47.base.forecast_time, content="6")
      inspect(template47.reserved_tail == b"\xef", content="true")
    }
    _ => fail("template4.7 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template48 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate48({
      base: sample_template40_base(),
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 0,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate48(template48) => {
      inspect(template48.end_year, content="2026")
      inspect(template48.number_of_time_ranges, content="2")
      inspect(template48.time_range_specs.length(), content="2")
      inspect(template48.reserved_tail == b"\xfa", content="true")
    }
    _ => fail("template4.8 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template49 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate49({
      base: {
        base: sample_template40_base(),
        forecast_probability_number: 2,
        total_number_of_forecast_probabilities: 10,
        probability_type: 1,
        scale_factor_of_lower_limit: 0,
        scaled_value_of_lower_limit: 100,
        scale_factor_of_upper_limit: 0,
        scaled_value_of_upper_limit: 200,
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate49(template49) => {
      inspect(template49.base.probability_type, content="1")
      inspect(template49.end_year, content="2026")
      inspect(template49.number_of_time_ranges, content="2")
      inspect(template49.time_range_specs.length(), content="2")
      inspect(template49.reserved_tail == b"\xfb", content="true")
    }
    _ => fail("template4.9 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template410 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate410({
      base: {
        base: sample_template40_base(),
        percentile_value: 90,
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 0,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate410(template410) => {
      inspect(template410.base.percentile_value, content="90")
      inspect(template410.number_of_time_ranges, content="2")
      inspect(template410.time_range_specs.length(), content="2")
      inspect(template410.reserved_tail == b"\xfc", content="true")
    }
    _ => fail("template4.10 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template411 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate411({
      base: {
        base: sample_template40_base(),
        type_of_ensemble_forecast: 2,
        perturbation_number: 3,
        number_of_forecasts_in_ensemble: 20,
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfd",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate411(template411) => {
      inspect(template411.base.type_of_ensemble_forecast, content="2")
      inspect(template411.number_of_time_ranges, content="2")
      inspect(template411.time_range_specs.length(), content="2")
      inspect(template411.reserved_tail == b"\xfd", content="true")
    }
    _ => fail("template4.11 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template412 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate412({
      base: {
        base: sample_template40_base(),
        derived_forecast: 5,
        number_of_forecasts_in_ensemble: 50,
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfe",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate412(template412) => {
      inspect(template412.base.derived_forecast, content="5")
      inspect(template412.number_of_time_ranges, content="2")
      inspect(template412.time_range_specs.length(), content="2")
      inspect(template412.reserved_tail == b"\xfe", content="true")
    }
    _ => fail("template4.12 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template413 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate413({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
      cluster_identifier: 1,
      cluster_for_high_resolution_control: 2,
      cluster_for_low_resolution_control: 3,
      total_number_of_clusters: 4,
      clustering_method: 1,
      northern_latitude_of_cluster_domain: 50000000,
      southern_latitude_of_cluster_domain: 30000000,
      eastern_longitude_of_cluster_domain: 140000000,
      western_longitude_of_cluster_domain: 120000000,
      number_of_forecasts_in_cluster: 3,
      scale_factor_of_standard_deviation: 0,
      scaled_value_of_standard_deviation: 1234,
      scale_factor_of_distance_from_ensemble_mean: 0,
      scaled_value_of_distance_from_ensemble_mean: 5678,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      ensemble_forecast_numbers: [1, 2, 3],
      reserved_tail: b"\xde",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate413(template413) => {
      inspect(template413.number_of_forecasts_in_cluster, content="3")
      inspect(template413.number_of_time_ranges, content="2")
      inspect(template413.time_range_specs.length(), content="2")
      inspect(template413.ensemble_forecast_numbers.length(), content="3")
      inspect(template413.reserved_tail == b"\xde", content="true")
    }
    _ => fail("template4.13 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template414 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate414({
      base: sample_template40_base(),
      derived_forecast: 5,
      number_of_forecasts_in_ensemble: 50,
      cluster_identifier: 1,
      cluster_for_high_resolution_control: 2,
      cluster_for_low_resolution_control: 3,
      total_number_of_clusters: 4,
      clustering_method: 1,
      latitude_of_central_point: 40000000,
      longitude_of_central_point: 130000000,
      radius_of_cluster_domain: 1000000,
      number_of_forecasts_in_cluster: 3,
      scale_factor_of_standard_deviation: 0,
      scaled_value_of_standard_deviation: 1234,
      scale_factor_of_distance_from_ensemble_mean: 0,
      scaled_value_of_distance_from_ensemble_mean: 5678,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      ensemble_forecast_numbers: [1, 2, 3],
      reserved_tail: b"\xdf",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate414(template414) => {
      inspect(template414.radius_of_cluster_domain, content="1000000")
      inspect(template414.number_of_time_ranges, content="2")
      inspect(template414.time_range_specs.length(), content="2")
      inspect(template414.ensemble_forecast_numbers.length(), content="3")
      inspect(template414.reserved_tail == b"\xdf", content="true")
    }
    _ => fail("template4.14 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template415 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate415({
      base: sample_template40_base(),
      statistical_process_within_spatial_area: 1,
      type_of_spatial_processing: 2,
      number_of_data_points_used: 9,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate415(template415) => {
      inspect(template415.statistical_process_within_spatial_area, content="1")
      inspect(template415.type_of_spatial_processing, content="2")
      inspect(template415.number_of_data_points_used, content="9")
    }
    _ => fail("template4.15 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template420 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate420({
      parameter_category: 15,
      parameter_number: 2,
      type_of_generating_process: 4,
      number_of_radar_sites_used: 1,
      indicator_of_unit_time_range: 1,
      site_latitude: 35000000,
      site_longitude: 139000000,
      site_elevation: 50,
      site_identifier_alphanumeric: 0x4b544c58,
      site_identifier_numeric: 12,
      operating_mode: 1,
      reflectivity_calibration_constant: 25,
      quality_control_indicator: 1,
      clutter_filter_indicator: 2,
      constant_antenna_elevation_angle: 5,
      accumulation_interval: 10,
      reference_reflectivity: 20,
      range_bin_spacing: 1000,
      radial_angular_spacing: 10,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate420(template420) => {
      inspect(template420.number_of_radar_sites_used, content="1")
      inspect(template420.site_latitude, content="35000000")
      inspect(template420.site_identifier_alphanumeric, content="1263815768")
      inspect(template420.range_bin_spacing, content="1000")
    }
    _ => fail("template4.20 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template430 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate430({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 4,
      observation_generating_process_identifier: 7,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 5,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 6,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      reserved_tail: b"\xa0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate430(template430) => {
      inspect(template430.number_of_contributing_spectral_bands, content="2")
      inspect(template430.bands.length(), content="2")
      inspect(
        template430.bands[1].scaled_value_of_central_wave_number,
        content="654321",
      )
      inspect(template430.reserved_tail == b"\xa0", content="true")
    }
    _ => fail("template4.30 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template431 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate431({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 4,
      observation_generating_process_identifier: 7,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      reserved_tail: b"\xa1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate431(template431) => {
      inspect(template431.number_of_contributing_spectral_bands, content="2")
      inspect(template431.bands.length(), content="2")
      inspect(template431.bands[0].instrument_type, content="300")
      inspect(template431.bands[1].instrument_type, content="400")
      inspect(template431.reserved_tail == b"\xa1", content="true")
    }
    _ => fail("template4.31 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template432 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate432({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      reserved_tail: b"\xa2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate432(template432) => {
      inspect(template432.forecast_time, content="6")
      inspect(template432.number_of_contributing_spectral_bands, content="2")
      inspect(template432.bands.length(), content="2")
      inspect(template432.bands[0].instrument_type, content="300")
      inspect(template432.bands[1].instrument_type, content="400")
      inspect(template432.reserved_tail == b"\xa2", content="true")
    }
    _ => fail("template4.32 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template433 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate433({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reserved_tail: b"\xa3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate433(template433) => {
      inspect(template433.forecast_time, content="6")
      inspect(template433.number_of_contributing_spectral_bands, content="2")
      inspect(template433.bands.length(), content="2")
      inspect(template433.type_of_ensemble_forecast, content="2")
      inspect(template433.perturbation_number, content="3")
      inspect(template433.number_of_forecasts_in_ensemble, content="20")
      inspect(template433.reserved_tail == b"\xa3", content="true")
    }
    _ => fail("template4.33 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template434 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate434({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xa4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate434(template434) => {
      inspect(template434.forecast_time, content="6")
      inspect(template434.bands.length(), content="2")
      inspect(template434.type_of_ensemble_forecast, content="2")
      inspect(template434.number_of_time_ranges, content="2")
      inspect(template434.time_range_specs.length(), content="2")
      inspect(template434.number_of_missing_values, content="1")
      inspect(template434.reserved_tail == b"\xa4", content="true")
    }
    _ => fail("template4.34 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template435 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate435({
      parameter_category: 3,
      parameter_number: 5,
      type_of_generating_process: 4,
      observation_generating_process_identifier: 7,
      quality_value_associated_with_parameter: 1,
      number_of_contributing_spectral_bands: 2,
      bands: [
        {
          satellite_series: 1,
          satellite_number: 100,
          instrument_type: 300,
          scale_factor_of_central_wave_number: 0,
          scaled_value_of_central_wave_number: 123456,
        },
        {
          satellite_series: 2,
          satellite_number: 101,
          instrument_type: 400,
          scale_factor_of_central_wave_number: 1,
          scaled_value_of_central_wave_number: 654321,
        },
      ],
      reserved_tail: b"\xa5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate435(template435) => {
      inspect(template435.quality_value_associated_with_parameter, content="1")
      inspect(template435.number_of_contributing_spectral_bands, content="2")
      inspect(template435.bands.length(), content="2")
      inspect(template435.bands[0].instrument_type, content="300")
      inspect(template435.bands[1].instrument_type, content="400")
      inspect(template435.reserved_tail == b"\xa5", content="true")
    }
    _ => fail("template4.35 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template440 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate440({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate440(template440) => {
      inspect(
        template440.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template440.forecast_time, content="6")
      inspect(template440.type_of_first_fixed_surface, content="100")
      inspect(template440.scaled_value_of_first_fixed_surface, content="50000")
    }
    _ => fail("template4.40 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template441 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate441({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        atmospheric_chemical_constituent_type: 40001,
        type_of_generating_process: 2,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate441(template441) => {
      inspect(
        template441.base.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template441.base.forecast_time, content="6")
      inspect(template441.type_of_ensemble_forecast, content="2")
      inspect(template441.perturbation_number, content="3")
      inspect(template441.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.41 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template442 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate442({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        atmospheric_chemical_constituent_type: 40001,
        type_of_generating_process: 2,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xa6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate442(template442) => {
      inspect(
        template442.base.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template442.base.forecast_time, content="6")
      inspect(template442.number_of_time_ranges, content="2")
      inspect(template442.time_range_specs.length(), content="2")
      inspect(template442.number_of_missing_values, content="1")
      inspect(template442.reserved_tail == b"\xa6", content="true")
    }
    _ => fail("template4.42 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template443 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate443({
      base: {
        base: {
          parameter_category: 20,
          parameter_number: 1,
          atmospheric_chemical_constituent_type: 40001,
          type_of_generating_process: 2,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
        },
        type_of_ensemble_forecast: 2,
        perturbation_number: 3,
        number_of_forecasts_in_ensemble: 20,
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xa7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate443(template443) => {
      inspect(
        template443.base.base.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template443.base.base.forecast_time, content="6")
      inspect(template443.base.type_of_ensemble_forecast, content="2")
      inspect(template443.number_of_time_ranges, content="2")
      inspect(template443.time_range_specs.length(), content="2")
      inspect(template443.number_of_missing_values, content="1")
      inspect(template443.reserved_tail == b"\xa7", content="true")
    }
    _ => fail("template4.43 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template444 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate444({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate444(template444) => {
      inspect(template444.aerosol_type, content="62000")
      inspect(
        template444.type_of_interval_for_first_and_second_size,
        content="2",
      )
      inspect(template444.scaled_value_of_first_size, content="1000")
      inspect(template444.scaled_value_of_second_size, content="2000")
      inspect(template444.forecast_time, content="6")
      inspect(template444.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.44 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template445 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate445({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate445(template445) => {
      inspect(template445.aerosol_type, content="62000")
      inspect(template445.forecast_time, content="6")
      inspect(template445.type_of_ensemble_forecast, content="2")
      inspect(template445.perturbation_number, content="3")
      inspect(template445.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.45 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template446 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate446({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xa8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate446(template446) => {
      inspect(template446.aerosol_type, content="62000")
      inspect(template446.forecast_time, content="6")
      inspect(template446.number_of_time_ranges, content="2")
      inspect(template446.time_range_specs.length(), content="2")
      inspect(template446.number_of_missing_values, content="1")
      inspect(template446.reserved_tail == b"\xa8", content="true")
    }
    _ => fail("template4.46 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template447 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate447({
      parameter_category: 20,
      parameter_number: 1,
      type_of_generating_process: 2,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xa9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate447(template447) => {
      inspect(template447.type_of_generating_process, content="2")
      inspect(template447.aerosol_type, content="62000")
      inspect(template447.forecast_time, content="6")
      inspect(template447.type_of_ensemble_forecast, content="2")
      inspect(template447.number_of_time_ranges, content="2")
      inspect(template447.time_range_specs.length(), content="2")
      inspect(template447.reserved_tail == b"\xa9", content="true")
    }
    _ => fail("template4.47 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template448 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate448({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
      type_of_interval_for_first_and_second_wavelength: 2,
      scale_factor_of_first_wavelength: 0,
      scaled_value_of_first_wavelength: 550,
      scale_factor_of_second_wavelength: 0,
      scaled_value_of_second_wavelength: 700,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate448(template448) => {
      inspect(template448.aerosol_type, content="62000")
      inspect(
        template448.type_of_interval_for_first_and_second_wavelength,
        content="2",
      )
      inspect(template448.scaled_value_of_first_wavelength, content="550")
      inspect(template448.scaled_value_of_second_wavelength, content="700")
      inspect(template448.forecast_time, content="6")
      inspect(template448.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.48 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template449 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate449({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
      type_of_interval_for_first_and_second_wavelength: 2,
      scale_factor_of_first_wavelength: 0,
      scaled_value_of_first_wavelength: 550,
      scale_factor_of_second_wavelength: 0,
      scaled_value_of_second_wavelength: 700,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate449(template449) => {
      inspect(template449.aerosol_type, content="62000")
      inspect(
        template449.type_of_interval_for_first_and_second_wavelength,
        content="2",
      )
      inspect(template449.scaled_value_of_first_wavelength, content="550")
      inspect(template449.scaled_value_of_second_wavelength, content="700")
      inspect(template449.forecast_time, content="6")
      inspect(template449.type_of_ensemble_forecast, content="2")
      inspect(template449.perturbation_number, content="3")
      inspect(template449.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.49 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template450 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate450({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 2,
      scale_factor_of_first_size: 0,
      scaled_value_of_first_size: 1000,
      scale_factor_of_second_size: 0,
      scaled_value_of_second_size: 2000,
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate450(template450) => {
      inspect(template450.aerosol_type, content="62000")
      inspect(
        template450.type_of_interval_for_first_and_second_size,
        content="2",
      )
      inspect(template450.scaled_value_of_first_size, content="1000")
      inspect(template450.scaled_value_of_second_size, content="2000")
      inspect(template450.forecast_time, content="6")
      inspect(template450.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.50 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template451 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate451({
      base: {
        parameter_category: 3,
        parameter_number: 5,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      number_of_categories: 2,
      categories: [
        {
          code_figure: 1,
          type_of_interval_for_first_and_second_limit: 2,
          scale_factor_of_first_limit: 0,
          scaled_value_of_first_limit: 100,
          scale_factor_of_second_limit: 0,
          scaled_value_of_second_limit: 200,
        },
        {
          code_figure: 2,
          type_of_interval_for_first_and_second_limit: 3,
          scale_factor_of_first_limit: 1,
          scaled_value_of_first_limit: 300,
          scale_factor_of_second_limit: 1,
          scaled_value_of_second_limit: 400,
        },
      ],
      reserved_tail: b"\xaa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate451(template451) => {
      inspect(template451.base.parameter_category, content="3")
      inspect(template451.number_of_categories, content="2")
      inspect(template451.categories.length(), content="2")
      inspect(template451.categories[0].code_figure, content="1")
      inspect(
        template451.categories[1].type_of_interval_for_first_and_second_limit,
        content="3",
      )
      inspect(template451.reserved_tail == b"\xaa", content="true")
    }
    _ => fail("template4.51 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template453 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate453({
      parameter_category: 3,
      parameter_number: 5,
      partition_table_number: 1,
      number_of_partitions: 3,
      partition_set: [10, 20, 30],
      partition_number: 20,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      reserved_tail: b"\xab",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate453(template453) => {
      inspect(template453.partition_table_number, content="1")
      inspect(template453.number_of_partitions, content="3")
      inspect(template453.partition_set.length(), content="3")
      inspect(template453.partition_set[1], content="20")
      inspect(template453.partition_number, content="20")
      inspect(template453.forecast_time, content="6")
      inspect(template453.reserved_tail == b"\xab", content="true")
    }
    _ => fail("template4.53 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template454 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate454({
      parameter_category: 3,
      parameter_number: 5,
      partition_table_number: 1,
      number_of_partitions: 3,
      partition_set: [10, 20, 30],
      partition_number: 20,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reserved_tail: b"\xac",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate454(template454) => {
      inspect(template454.partition_table_number, content="1")
      inspect(template454.number_of_partitions, content="3")
      inspect(template454.partition_set.length(), content="3")
      inspect(template454.partition_number, content="20")
      inspect(template454.type_of_ensemble_forecast, content="2")
      inspect(template454.perturbation_number, content="3")
      inspect(template454.number_of_forecasts_in_ensemble, content="20")
      inspect(template454.reserved_tail == b"\xac", content="true")
    }
    _ => fail("template4.54 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template455 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate455({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate455(template455) => {
      inspect(template455.tile_classification, content="1")
      inspect(template455.total_number_of_tile_attribute_pairs, content="5")
      inspect(template455.number_of_used_spatial_tiles, content="3")
      inspect(template455.tile_index, content="2")
      inspect(template455.number_of_used_tile_attributes, content="2")
      inspect(template455.tile_attribute, content="4")
      inspect(template455.forecast_time, content="6")
    }
    _ => fail("template4.55 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template456 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate456({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate456(template456) => {
      inspect(template456.tile_classification, content="1")
      inspect(template456.total_number_of_tile_attribute_pairs, content="5")
      inspect(template456.number_of_used_spatial_tiles, content="3")
      inspect(template456.tile_index, content="2")
      inspect(template456.number_of_used_tile_attributes, content="2")
      inspect(template456.tile_attribute, content="4")
      inspect(template456.perturbation_number, content="3")
      inspect(template456.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.56 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template457 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate457({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      number_of_mode_of_distribution: 2,
      mode_number: 1,
      type_of_distribution_function: 3,
      number_of_following_function_parameters: 2,
      function_parameters: [
        {
          scale_factor_of_fixed_distribution_function_parameter: 0,
          scaled_value_of_fixed_distribution_function_parameter: 123,
        },
        {
          scale_factor_of_fixed_distribution_function_parameter: 1,
          scaled_value_of_fixed_distribution_function_parameter: 456,
        },
      ],
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      reserved_tail: b"\xae",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate457(template457) => {
      inspect(
        template457.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template457.number_of_mode_of_distribution, content="2")
      inspect(template457.mode_number, content="1")
      inspect(template457.type_of_distribution_function, content="3")
      inspect(template457.number_of_following_function_parameters, content="2")
      inspect(template457.function_parameters.length(), content="2")
      inspect(
        template457.function_parameters[1].scaled_value_of_fixed_distribution_function_parameter,
        content="456",
      )
      inspect(template457.reserved_tail == b"\xae", content="true")
    }
    _ => fail("template4.57 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template458 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate458({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      number_of_mode_of_distribution: 2,
      mode_number: 1,
      type_of_distribution_function: 3,
      number_of_following_function_parameters: 2,
      function_parameters: [
        {
          scale_factor_of_fixed_distribution_function_parameter: 0,
          scaled_value_of_fixed_distribution_function_parameter: 123,
        },
        {
          scale_factor_of_fixed_distribution_function_parameter: 1,
          scaled_value_of_fixed_distribution_function_parameter: 456,
        },
      ],
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reserved_tail: b"\xaf",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate458(template458) => {
      inspect(
        template458.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template458.number_of_mode_of_distribution, content="2")
      inspect(template458.mode_number, content="1")
      inspect(template458.type_of_distribution_function, content="3")
      inspect(template458.number_of_following_function_parameters, content="2")
      inspect(template458.function_parameters.length(), content="2")
      inspect(template458.type_of_ensemble_forecast, content="2")
      inspect(template458.perturbation_number, content="3")
      inspect(template458.number_of_forecasts_in_ensemble, content="20")
      inspect(template458.reserved_tail == b"\xaf", content="true")
    }
    _ => fail("template4.58 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template459 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate459({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate459(template459) => {
      inspect(template459.tile_classification, content="1")
      inspect(template459.total_number_of_tile_attribute_pairs, content="5")
      inspect(template459.number_of_used_spatial_tiles, content="3")
      inspect(template459.tile_index, content="2")
      inspect(template459.number_of_used_tile_attributes, content="2")
      inspect(template459.tile_attribute, content="4")
      inspect(template459.type_of_ensemble_forecast, content="2")
      inspect(template459.perturbation_number, content="3")
      inspect(template459.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.59 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template460 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate460({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      year_of_model_version_date: 2024,
      month_of_model_version_date: 5,
      day_of_model_version_date: 1,
      hour_of_model_version_date: 12,
      minute_of_model_version_date: 30,
      second_of_model_version_date: 45,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate460(template460) => {
      inspect(template460.type_of_ensemble_forecast, content="2")
      inspect(template460.perturbation_number, content="3")
      inspect(template460.number_of_forecasts_in_ensemble, content="20")
      inspect(template460.year_of_model_version_date, content="2024")
      inspect(template460.month_of_model_version_date, content="5")
      inspect(template460.day_of_model_version_date, content="1")
      inspect(template460.hour_of_model_version_date, content="12")
      inspect(template460.minute_of_model_version_date, content="30")
      inspect(template460.second_of_model_version_date, content="45")
    }
    _ => fail("template4.60 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template461 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate461({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      year_of_model_version_date: 2024,
      month_of_model_version_date: 5,
      day_of_model_version_date: 1,
      hour_of_model_version_date: 12,
      minute_of_model_version_date: 30,
      second_of_model_version_date: 45,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate461(template461) => {
      inspect(template461.type_of_ensemble_forecast, content="2")
      inspect(template461.perturbation_number, content="3")
      inspect(template461.number_of_forecasts_in_ensemble, content="20")
      inspect(template461.year_of_model_version_date, content="2024")
      inspect(template461.end_year, content="2024")
      inspect(template461.number_of_time_ranges, content="2")
      inspect(template461.time_range_specs.length(), content="2")
      inspect(template461.number_of_missing_values, content="1")
      inspect(template461.reserved_tail == b"\xb0", content="true")
    }
    _ => fail("template4.61 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template462 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate462({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate462(template462) => {
      inspect(template462.tile_classification, content="1")
      inspect(template462.end_year, content="2024")
      inspect(template462.number_of_time_ranges, content="2")
      inspect(template462.time_range_specs.length(), content="2")
      inspect(template462.number_of_missing_values, content="1")
      inspect(template462.reserved_tail == b"\xb1", content="true")
    }
    _ => fail("template4.62 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template463 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate463({
      parameter_category: 3,
      parameter_number: 5,
      tile_classification: 1,
      total_number_of_tile_attribute_pairs: 5,
      number_of_used_spatial_tiles: 3,
      tile_index: 2,
      number_of_used_tile_attributes: 2,
      tile_attribute: 4,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate463(template463) => {
      inspect(template463.tile_classification, content="1")
      inspect(template463.type_of_ensemble_forecast, content="2")
      inspect(template463.perturbation_number, content="3")
      inspect(template463.number_of_forecasts_in_ensemble, content="20")
      inspect(template463.end_year, content="2024")
      inspect(template463.number_of_time_ranges, content="2")
      inspect(template463.time_range_specs.length(), content="2")
      inspect(template463.number_of_missing_values, content="1")
      inspect(template463.reserved_tail == b"\xb2", content="true")
    }
    _ => fail("template4.63 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template467 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate467({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      number_of_mode_of_distribution: 2,
      mode_number: 1,
      type_of_distribution_function: 3,
      number_of_following_function_parameters: 2,
      function_parameters: [
        {
          scale_factor_of_fixed_distribution_function_parameter: 0,
          scaled_value_of_fixed_distribution_function_parameter: 123,
        },
        {
          scale_factor_of_fixed_distribution_function_parameter: 1,
          scaled_value_of_fixed_distribution_function_parameter: 456,
        },
      ],
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate467(template467) => {
      inspect(
        template467.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template467.number_of_following_function_parameters, content="2")
      inspect(template467.function_parameters.length(), content="2")
      inspect(template467.end_year, content="2024")
      inspect(template467.number_of_time_ranges, content="2")
      inspect(template467.time_range_specs.length(), content="2")
      inspect(template467.number_of_missing_values, content="1")
      inspect(template467.reserved_tail == b"\xb3", content="true")
    }
    _ => fail("template4.67 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template468 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate468({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      number_of_mode_of_distribution: 2,
      mode_number: 1,
      type_of_distribution_function: 3,
      number_of_following_function_parameters: 2,
      function_parameters: [
        {
          scale_factor_of_fixed_distribution_function_parameter: 0,
          scaled_value_of_fixed_distribution_function_parameter: 123,
        },
        {
          scale_factor_of_fixed_distribution_function_parameter: 1,
          scaled_value_of_fixed_distribution_function_parameter: 456,
        },
      ],
      type_of_generating_process: 2,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate468(template468) => {
      inspect(
        template468.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template468.number_of_following_function_parameters, content="2")
      inspect(template468.function_parameters.length(), content="2")
      inspect(template468.type_of_ensemble_forecast, content="2")
      inspect(template468.perturbation_number, content="3")
      inspect(template468.number_of_forecasts_in_ensemble, content="20")
      inspect(template468.end_year, content="2024")
      inspect(template468.number_of_time_ranges, content="2")
      inspect(template468.time_range_specs.length(), content="2")
      inspect(template468.number_of_missing_values, content="1")
      inspect(template468.reserved_tail == b"\xb4", content="true")
    }
    _ => fail("template4.68 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template470 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate470({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate470(template470) => {
      inspect(template470.input_process_identifier, content="321")
      inspect(template470.input_originating_centre, content="34")
      inspect(template470.type_of_post_processing, content="2")
      inspect(template470.forecast_time, content="6")
      inspect(template470.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.70 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template471 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate471({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate471(template471) => {
      inspect(template471.input_process_identifier, content="321")
      inspect(template471.input_originating_centre, content="34")
      inspect(template471.type_of_post_processing, content="2")
      inspect(template471.type_of_ensemble_forecast, content="2")
      inspect(template471.perturbation_number, content="3")
      inspect(template471.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.71 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template472 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate472({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate472(template472) => {
      inspect(template472.input_process_identifier, content="321")
      inspect(template472.input_originating_centre, content="34")
      inspect(template472.type_of_post_processing, content="2")
      inspect(template472.end_year, content="2024")
      inspect(template472.number_of_time_ranges, content="2")
      inspect(template472.time_range_specs.length(), content="2")
      inspect(template472.number_of_missing_values, content="1")
      inspect(template472.reserved_tail == b"\xb5", content="true")
    }
    _ => fail("template4.72 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template473 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate473({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate473(template473) => {
      inspect(template473.input_process_identifier, content="321")
      inspect(template473.input_originating_centre, content="34")
      inspect(template473.type_of_post_processing, content="2")
      inspect(template473.type_of_ensemble_forecast, content="2")
      inspect(template473.perturbation_number, content="3")
      inspect(template473.number_of_forecasts_in_ensemble, content="20")
      inspect(template473.end_year, content="2024")
      inspect(template473.number_of_time_ranges, content="2")
      inspect(template473.time_range_specs.length(), content="2")
      inspect(template473.number_of_missing_values, content="1")
      inspect(template473.reserved_tail == b"\xb6", content="true")
    }
    _ => fail("template4.73 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template476 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate476({
      parameter_category: 20,
      parameter_number: 1,
      atmospheric_chemical_constituent_type: 40001,
      source_or_sink: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate476(template476) => {
      inspect(
        template476.atmospheric_chemical_constituent_type,
        content="40001",
      )
      inspect(template476.source_or_sink, content="2")
      inspect(template476.forecast_time, content="6")
    }
    _ => fail("template4.76 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template477 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate477({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        atmospheric_chemical_constituent_type: 40001,
        source_or_sink: 2,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate477(template477) => {
      inspect(template477.base.source_or_sink, content="2")
      inspect(template477.type_of_ensemble_forecast, content="2")
      inspect(template477.perturbation_number, content="3")
      inspect(template477.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.77 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template478 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate478({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        atmospheric_chemical_constituent_type: 40001,
        source_or_sink: 2,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate478(template478) => {
      inspect(template478.base.source_or_sink, content="2")
      inspect(template478.end_year, content="2024")
      inspect(template478.number_of_time_ranges, content="2")
      inspect(template478.time_range_specs.length(), content="2")
      inspect(template478.number_of_missing_values, content="1")
      inspect(template478.reserved_tail == b"\xb7", content="true")
    }
    _ => fail("template4.78 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template479 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate479({
      base: {
        base: {
          parameter_category: 20,
          parameter_number: 1,
          atmospheric_chemical_constituent_type: 40001,
          source_or_sink: 2,
          type_of_generating_process: 4,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
        },
        type_of_ensemble_forecast: 2,
        perturbation_number: 3,
        number_of_forecasts_in_ensemble: 20,
      },
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate479(template479) => {
      inspect(template479.base.base.source_or_sink, content="2")
      inspect(template479.base.type_of_ensemble_forecast, content="2")
      inspect(template479.base.perturbation_number, content="3")
      inspect(template479.base.number_of_forecasts_in_ensemble, content="20")
      inspect(template479.end_year, content="2024")
      inspect(template479.number_of_time_ranges, content="2")
      inspect(template479.time_range_specs.length(), content="2")
      inspect(template479.number_of_missing_values, content="1")
      inspect(template479.reserved_tail == b"\xb8", content="true")
    }
    _ => fail("template4.79 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template480 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate480({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      source_or_sink: 2,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
      type_of_interval_for_first_and_second_wavelength: 1,
      scale_factor_of_first_wavelength: 9,
      scaled_value_of_first_wavelength: 550,
      scale_factor_of_second_wavelength: 9,
      scaled_value_of_second_wavelength: 650,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate480(template480) => {
      inspect(template480.aerosol_type, content="62000")
      inspect(template480.source_or_sink, content="2")
      inspect(template480.scaled_value_of_first_wavelength, content="550")
      inspect(template480.scaled_value_of_second_wavelength, content="650")
    }
    _ => fail("template4.80 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template481 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate481({
      base: {
        parameter_category: 20,
        parameter_number: 1,
        aerosol_type: 62000,
        source_or_sink: 2,
        type_of_interval_for_first_and_second_size: 1,
        scale_factor_of_first_size: 1,
        scaled_value_of_first_size: 500,
        scale_factor_of_second_size: 1,
        scaled_value_of_second_size: 1500,
        type_of_interval_for_first_and_second_wavelength: 1,
        scale_factor_of_first_wavelength: 9,
        scaled_value_of_first_wavelength: 550,
        scale_factor_of_second_wavelength: 9,
        scaled_value_of_second_wavelength: 650,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate481(template481) => {
      inspect(template481.base.aerosol_type, content="62000")
      inspect(template481.base.source_or_sink, content="2")
      inspect(template481.type_of_ensemble_forecast, content="2")
      inspect(template481.perturbation_number, content="3")
      inspect(template481.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.81 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template482 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate482({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      source_or_sink: 2,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xb9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate482(template482) => {
      inspect(template482.aerosol_type, content="62000")
      inspect(template482.source_or_sink, content="2")
      inspect(template482.end_year, content="2024")
      inspect(template482.number_of_time_ranges, content="2")
      inspect(template482.time_range_specs.length(), content="2")
      inspect(template482.number_of_missing_values, content="1")
      inspect(template482.reserved_tail == b"\xb9", content="true")
    }
    _ => fail("template4.82 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template483 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate483({
      parameter_category: 20,
      parameter_number: 1,
      type_of_generating_process: 4,
      aerosol_type: 62000,
      source_or_sink: 2,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xba",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate483(template483) => {
      inspect(template483.aerosol_type, content="62000")
      inspect(template483.source_or_sink, content="2")
      inspect(template483.type_of_ensemble_forecast, content="2")
      inspect(template483.perturbation_number, content="3")
      inspect(template483.number_of_forecasts_in_ensemble, content="20")
      inspect(template483.end_year, content="2024")
      inspect(template483.number_of_time_ranges, content="2")
      inspect(template483.time_range_specs.length(), content="2")
      inspect(template483.number_of_missing_values, content="1")
      inspect(template483.reserved_tail == b"\xba", content="true")
    }
    _ => fail("template4.83 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template484 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate484({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      source_or_sink: 2,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xbb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate484(template484) => {
      inspect(template484.aerosol_type, content="62000")
      inspect(template484.source_or_sink, content="2")
      inspect(template484.type_of_ensemble_forecast, content="2")
      inspect(template484.perturbation_number, content="3")
      inspect(template484.number_of_forecasts_in_ensemble, content="20")
      inspect(template484.end_year, content="2024")
      inspect(template484.number_of_time_ranges, content="2")
      inspect(template484.time_range_specs.length(), content="2")
      inspect(template484.number_of_missing_values, content="1")
      inspect(template484.reserved_tail == b"\xbb", content="true")
    }
    _ => fail("template4.84 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template485 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate485({
      parameter_category: 20,
      parameter_number: 1,
      aerosol_type: 62000,
      type_of_interval_for_first_and_second_size: 1,
      scale_factor_of_first_size: 1,
      scaled_value_of_first_size: 500,
      scale_factor_of_second_size: 1,
      scaled_value_of_second_size: 1500,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xbc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate485(template485) => {
      inspect(template485.aerosol_type, content="62000")
      inspect(template485.type_of_ensemble_forecast, content="2")
      inspect(template485.perturbation_number, content="3")
      inspect(template485.number_of_forecasts_in_ensemble, content="20")
      inspect(template485.end_year, content="2024")
      inspect(template485.number_of_time_ranges, content="2")
      inspect(template485.time_range_specs.length(), content="2")
      inspect(template485.number_of_missing_values, content="1")
      inspect(template485.reserved_tail == b"\xbc", content="true")
    }
    _ => fail("template4.85 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template486 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate486({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      total_number_of_quantiles: 100,
      quantile_value: 95,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate486(template486) => {
      inspect(template486.type_of_generating_process, content="4")
      inspect(template486.forecast_time, content="6")
      inspect(template486.total_number_of_quantiles, content="100")
      inspect(template486.quantile_value, content="95")
    }
    _ => fail("template4.86 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template487 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate487({
      base: {
        parameter_category: 0,
        parameter_number: 1,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
        total_number_of_quantiles: 100,
        quantile_value: 95,
      },
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xbd",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate487(template487) => {
      inspect(template487.base.total_number_of_quantiles, content="100")
      inspect(template487.base.quantile_value, content="95")
      inspect(template487.end_year, content="2024")
      inspect(template487.number_of_time_ranges, content="2")
      inspect(template487.time_range_specs.length(), content="2")
      inspect(template487.number_of_missing_values, content="1")
      inspect(template487.reserved_tail == b"\xbd", content="true")
    }
    _ => fail("template4.87 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template488 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate488({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      method_used_to_derive_data_field_values_at_local_time: 1,
      number_of_analyses_or_forecasts_used: 2,
      analysis_or_forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xbe",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate488(template488) => {
      inspect(
        template488.method_used_to_derive_data_field_values_at_local_time,
        content="1",
      )
      inspect(template488.number_of_analyses_or_forecasts_used, content="2")
      inspect(template488.analysis_or_forecast_specs.length(), content="2")
      inspect(template488.analysis_or_forecast_specs[0].year, content="2024")
      inspect(
        template488.analysis_or_forecast_specs[1].forecast_time,
        content="12",
      )
      inspect(template488.reserved_tail == b"\xbe", content="true")
    }
    _ => fail("template4.88 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template489 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate489({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      total_number_of_quantiles: 100,
      quantile_value: 95,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate489(template489) => {
      inspect(template489.input_process_identifier, content="321")
      inspect(template489.input_originating_centre, content="34")
      inspect(template489.type_of_post_processing, content="2")
      inspect(template489.total_number_of_quantiles, content="100")
      inspect(template489.quantile_value, content="95")
    }
    _ => fail("template4.89 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template490 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate490({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      total_number_of_quantiles: 100,
      quantile_value: 95,
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xbf",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate490(template490) => {
      inspect(template490.input_process_identifier, content="321")
      inspect(template490.input_originating_centre, content="34")
      inspect(template490.total_number_of_quantiles, content="100")
      inspect(template490.quantile_value, content="95")
      inspect(template490.end_year, content="2024")
      inspect(template490.number_of_time_ranges, content="2")
      inspect(template490.time_range_specs.length(), content="2")
      inspect(template490.number_of_missing_values, content="1")
      inspect(template490.reserved_tail == b"\xbf", content="true")
    }
    _ => fail("template4.90 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template491 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate491({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      number_of_categories: 2,
      categories: [
        {
          code_figure: 1,
          type_of_interval_for_first_and_second_limit: 1,
          scale_factor_of_first_limit: 0,
          scaled_value_of_first_limit: 10,
          scale_factor_of_second_limit: 0,
          scaled_value_of_second_limit: 20,
        },
        {
          code_figure: 2,
          type_of_interval_for_first_and_second_limit: 2,
          scale_factor_of_first_limit: 0,
          scaled_value_of_first_limit: 30,
          scale_factor_of_second_limit: 0,
          scaled_value_of_second_limit: 40,
        },
      ],
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
        {
          statistical_process: 2,
          type_of_time_increment: 1,
          time_range_unit: 1,
          time_range_length: 12,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate491(template491) => {
      inspect(template491.number_of_categories, content="2")
      inspect(template491.categories.length(), content="2")
      inspect(template491.categories[0].code_figure, content="1")
      inspect(
        template491.categories[1].scaled_value_of_second_limit,
        content="40",
      )
      inspect(template491.end_year, content="2024")
      inspect(template491.number_of_time_ranges, content="2")
      inspect(template491.time_range_specs.length(), content="2")
      inspect(template491.number_of_missing_values, content="1")
      inspect(template491.reserved_tail == b"\xc0", content="true")
    }
    _ => fail("template4.91 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template492 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate492({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      method_used_to_derive_data_field_values_at_local_time: 1,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate492(template492) => {
      inspect(template492.type_of_ensemble_forecast, content="2")
      inspect(template492.perturbation_number, content="3")
      inspect(template492.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template492.method_used_to_derive_data_field_values_at_local_time,
        content="1",
      )
      inspect(template492.number_of_forecasts_used, content="2")
      inspect(template492.forecast_specs.length(), content="2")
      inspect(template492.forecast_specs[1].forecast_time, content="12")
      inspect(template492.reserved_tail == b"\xc1", content="true")
    }
    _ => fail("template4.92 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template493 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate493({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      method_used_to_derive_data_field_values_at_local_time: 1,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate493(template493) => {
      inspect(template493.input_process_identifier, content="321")
      inspect(template493.input_originating_centre, content="34")
      inspect(template493.type_of_post_processing, content="2")
      inspect(
        template493.method_used_to_derive_data_field_values_at_local_time,
        content="1",
      )
      inspect(template493.number_of_forecasts_used, content="2")
      inspect(template493.forecast_specs.length(), content="2")
      inspect(template493.forecast_specs[1].forecast_time, content="12")
      inspect(template493.reserved_tail == b"\xc2", content="true")
    }
    _ => fail("template4.93 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template494 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate494({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      method_used_to_derive_data_field_values_at_local_time: 1,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate494(template494) => {
      inspect(template494.input_process_identifier, content="321")
      inspect(template494.input_originating_centre, content="34")
      inspect(template494.type_of_post_processing, content="2")
      inspect(template494.type_of_ensemble_forecast, content="2")
      inspect(template494.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template494.method_used_to_derive_data_field_values_at_local_time,
        content="1",
      )
      inspect(template494.number_of_forecasts_used, content="2")
      inspect(template494.forecast_specs.length(), content="2")
      inspect(template494.forecast_specs[1].forecast_time, content="12")
      inspect(template494.reserved_tail == b"\xc3", content="true")
    }
    _ => fail("template4.94 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template495 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate495({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      statistical_process_used_to_calculate_fields_for_local_time_processing: 1,
      statistical_processing_time_range_unit: 1,
      statistical_processing_time_range_length: 24,
      number_of_statistically_processed_fields_in_local_time_composite: 8,
      method_used_to_derive_data_field_values_at_local_time: 2,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate495(template495) => {
      inspect(
        template495.statistical_process_used_to_calculate_fields_for_local_time_processing,
        content="1",
      )
      inspect(template495.statistical_processing_time_range_unit, content="1")
      inspect(
        template495.statistical_processing_time_range_length,
        content="24",
      )
      inspect(
        template495.number_of_statistically_processed_fields_in_local_time_composite,
        content="8",
      )
      inspect(
        template495.method_used_to_derive_data_field_values_at_local_time,
        content="2",
      )
      inspect(template495.number_of_forecasts_used, content="2")
      inspect(template495.forecast_specs.length(), content="2")
      inspect(template495.forecast_specs[1].forecast_time, content="12")
      inspect(template495.reserved_tail == b"\xc4", content="true")
    }
    _ => fail("template4.95 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template496 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate496({
      parameter_category: 0,
      parameter_number: 1,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      statistical_process_used_to_calculate_fields_for_local_time_processing: 1,
      statistical_processing_time_range_unit: 1,
      statistical_processing_time_range_length: 24,
      number_of_statistically_processed_fields_in_local_time_composite: 8,
      method_used_to_derive_data_field_values_at_local_time: 2,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate496(template496) => {
      inspect(template496.type_of_ensemble_forecast, content="2")
      inspect(template496.perturbation_number, content="3")
      inspect(template496.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template496.statistical_process_used_to_calculate_fields_for_local_time_processing,
        content="1",
      )
      inspect(
        template496.statistical_processing_time_range_length,
        content="24",
      )
      inspect(
        template496.number_of_statistically_processed_fields_in_local_time_composite,
        content="8",
      )
      inspect(
        template496.method_used_to_derive_data_field_values_at_local_time,
        content="2",
      )
      inspect(template496.number_of_forecasts_used, content="2")
      inspect(template496.forecast_specs.length(), content="2")
      inspect(template496.forecast_specs[1].forecast_time, content="12")
      inspect(template496.reserved_tail == b"\xc5", content="true")
    }
    _ => fail("template4.96 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template497 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate497({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      statistical_process_used_to_calculate_fields_for_local_time_processing: 1,
      statistical_processing_time_range_unit: 1,
      statistical_processing_time_range_length: 24,
      number_of_statistically_processed_fields_in_local_time_composite: 8,
      method_used_to_derive_data_field_values_at_local_time: 2,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate497(template497) => {
      inspect(template497.input_process_identifier, content="321")
      inspect(template497.input_originating_centre, content="34")
      inspect(template497.type_of_post_processing, content="2")
      inspect(
        template497.statistical_process_used_to_calculate_fields_for_local_time_processing,
        content="1",
      )
      inspect(
        template497.statistical_processing_time_range_length,
        content="24",
      )
      inspect(
        template497.number_of_statistically_processed_fields_in_local_time_composite,
        content="8",
      )
      inspect(
        template497.method_used_to_derive_data_field_values_at_local_time,
        content="2",
      )
      inspect(template497.number_of_forecasts_used, content="2")
      inspect(template497.forecast_specs.length(), content="2")
      inspect(template497.forecast_specs[1].forecast_time, content="12")
      inspect(template497.reserved_tail == b"\xc6", content="true")
    }
    _ => fail("template4.97 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template498 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate498({
      parameter_category: 0,
      parameter_number: 1,
      input_process_identifier: 321,
      input_originating_centre: 34,
      type_of_post_processing: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      statistical_process_used_to_calculate_fields_for_local_time_processing: 1,
      statistical_processing_time_range_unit: 1,
      statistical_processing_time_range_length: 24,
      number_of_statistically_processed_fields_in_local_time_composite: 8,
      method_used_to_derive_data_field_values_at_local_time: 2,
      number_of_forecasts_used: 2,
      forecast_specs: [
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 12,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 6,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
        {
          year: 2024,
          month: 5,
          day: 1,
          hour: 18,
          minute: 0,
          second: 0,
          forecast_time_unit: 1,
          forecast_time: 12,
          number_of_time_increments: 1,
          time_increment_unit: 1,
          time_increment_length: 3,
        },
      ],
      reserved_tail: b"\xc7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate498(template498) => {
      inspect(template498.input_process_identifier, content="321")
      inspect(template498.input_originating_centre, content="34")
      inspect(template498.type_of_post_processing, content="2")
      inspect(template498.type_of_ensemble_forecast, content="2")
      inspect(template498.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template498.statistical_process_used_to_calculate_fields_for_local_time_processing,
        content="1",
      )
      inspect(
        template498.statistical_processing_time_range_length,
        content="24",
      )
      inspect(
        template498.number_of_statistically_processed_fields_in_local_time_composite,
        content="8",
      )
      inspect(
        template498.method_used_to_derive_data_field_values_at_local_time,
        content="2",
      )
      inspect(template498.number_of_forecasts_used, content="2")
      inspect(template498.forecast_specs.length(), content="2")
      inspect(template498.forecast_specs[1].forecast_time, content="12")
      inspect(template498.reserved_tail == b"\xc7", content="true")
    }
    _ => fail("template4.98 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template499 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate499({
      parameter_category: 10,
      parameter_number: 20,
      wave_direction_number: 2,
      number_of_wave_directions: 3,
      wave_frequency_number: 4,
      number_of_wave_frequencies: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      scale_factor_of_wave_directions: 1,
      scaled_wave_directions: [450, 900, 1350],
      scale_factor_of_wave_frequencies: 3,
      scaled_wave_frequencies: [125, 250],
      reserved_tail: b"\xc8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate499(template499) => {
      inspect(template499.wave_direction_number, content="2")
      inspect(template499.number_of_wave_directions, content="3")
      inspect(template499.wave_frequency_number, content="4")
      inspect(template499.number_of_wave_frequencies, content="2")
      inspect(template499.scaled_wave_directions.length(), content="3")
      inspect(template499.scaled_wave_directions[1], content="900")
      inspect(template499.scale_factor_of_wave_frequencies, content="3")
      inspect(template499.scaled_wave_frequencies.length(), content="2")
      inspect(template499.scaled_wave_frequencies[1], content="250")
      inspect(template499.reserved_tail == b"\xc8", content="true")
    }
    _ => fail("template4.99 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4100 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4100({
      parameter_category: 10,
      parameter_number: 20,
      wave_direction_number: 2,
      number_of_wave_directions: 3,
      wave_frequency_number: 4,
      number_of_wave_frequencies: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      scale_factor_of_wave_directions: 1,
      scaled_wave_directions: [450, 900, 1350],
      scale_factor_of_wave_frequencies: 3,
      scaled_wave_frequencies: [125, 250],
      reserved_tail: b"\xc9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4100(template4100) => {
      inspect(template4100.type_of_ensemble_forecast, content="2")
      inspect(template4100.perturbation_number, content="3")
      inspect(template4100.number_of_forecasts_in_ensemble, content="20")
      inspect(template4100.number_of_wave_directions, content="3")
      inspect(template4100.scaled_wave_directions.length(), content="3")
      inspect(template4100.scaled_wave_directions[1], content="900")
      inspect(template4100.scale_factor_of_wave_frequencies, content="3")
      inspect(template4100.scaled_wave_frequencies.length(), content="2")
      inspect(template4100.scaled_wave_frequencies[1], content="250")
      inspect(template4100.reserved_tail == b"\xc9", content="true")
    }
    _ => fail("template4.100 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4101 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4101({
      parameter_category: 10,
      parameter_number: 20,
      wave_direction_number: 2,
      number_of_wave_directions: 3,
      wave_frequency_number: 4,
      number_of_wave_frequencies: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_wave_direction_sequence: 1,
      number_of_wave_direction_sequence_parameters: 2,
      wave_direction_sequence_parameters: [
        { scale_factor: 0, scaled_value: 10 },
        { scale_factor: 1, scaled_value: 20 },
      ],
      type_of_wave_frequency_sequence: 2,
      number_of_wave_frequency_sequence_parameters: 2,
      wave_frequency_sequence_parameters: [
        { scale_factor: 0, scaled_value: 30 },
        { scale_factor: 1, scaled_value: 40 },
      ],
      reserved_tail: b"\xca",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4101(template4101) => {
      inspect(template4101.type_of_wave_direction_sequence, content="1")
      inspect(
        template4101.number_of_wave_direction_sequence_parameters,
        content="2",
      )
      inspect(
        template4101.wave_direction_sequence_parameters.length(),
        content="2",
      )
      inspect(
        template4101.wave_direction_sequence_parameters[1].scaled_value,
        content="20",
      )
      inspect(template4101.type_of_wave_frequency_sequence, content="2")
      inspect(
        template4101.number_of_wave_frequency_sequence_parameters,
        content="2",
      )
      inspect(
        template4101.wave_frequency_sequence_parameters.length(),
        content="2",
      )
      inspect(
        template4101.wave_frequency_sequence_parameters[1].scaled_value,
        content="40",
      )
      inspect(template4101.reserved_tail == b"\xca", content="true")
    }
    _ => fail("template4.101 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4102 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4102({
      parameter_category: 10,
      parameter_number: 20,
      wave_direction_number: 2,
      number_of_wave_directions: 3,
      wave_frequency_number: 4,
      number_of_wave_frequencies: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      type_of_wave_direction_sequence: 1,
      number_of_wave_direction_sequence_parameters: 2,
      wave_direction_sequence_parameters: [
        { scale_factor: 0, scaled_value: 10 },
        { scale_factor: 1, scaled_value: 20 },
      ],
      type_of_wave_frequency_sequence: 2,
      number_of_wave_frequency_sequence_parameters: 2,
      wave_frequency_sequence_parameters: [
        { scale_factor: 0, scaled_value: 30 },
        { scale_factor: 1, scaled_value: 40 },
      ],
      reserved_tail: b"\xcb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4102(template4102) => {
      inspect(template4102.type_of_ensemble_forecast, content="2")
      inspect(template4102.perturbation_number, content="3")
      inspect(template4102.number_of_forecasts_in_ensemble, content="20")
      inspect(template4102.type_of_wave_direction_sequence, content="1")
      inspect(
        template4102.number_of_wave_direction_sequence_parameters,
        content="2",
      )
      inspect(
        template4102.wave_direction_sequence_parameters.length(),
        content="2",
      )
      inspect(
        template4102.wave_direction_sequence_parameters[1].scaled_value,
        content="20",
      )
      inspect(template4102.type_of_wave_frequency_sequence, content="2")
      inspect(
        template4102.number_of_wave_frequency_sequence_parameters,
        content="2",
      )
      inspect(
        template4102.wave_frequency_sequence_parameters.length(),
        content="2",
      )
      inspect(
        template4102.wave_frequency_sequence_parameters[1].scaled_value,
        content="40",
      )
      inspect(template4102.reserved_tail == b"\xcb", content="true")
    }
    _ => fail("template4.102 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4103 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4103({
      parameter_category: 10,
      parameter_number: 20,
      type_of_wave_period_interval: 2,
      scale_factor_of_lower_wave_period_limit: 0,
      scaled_value_of_lower_wave_period_limit: 5,
      scale_factor_of_upper_wave_period_limit: 0,
      scaled_value_of_upper_wave_period_limit: 20,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4103(template4103) => {
      inspect(template4103.type_of_wave_period_interval, content="2")
      inspect(template4103.scaled_value_of_lower_wave_period_limit, content="5")
      inspect(
        template4103.scaled_value_of_upper_wave_period_limit,
        content="20",
      )
      inspect(template4103.forecast_time, content="6")
      inspect(template4103.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.103 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4104 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4104({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 5,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4104(template4104) => {
      inspect(template4104.base.type_of_wave_period_interval, content="2")
      inspect(
        template4104.base.scaled_value_of_upper_wave_period_limit,
        content="20",
      )
      inspect(template4104.type_of_ensemble_forecast, content="2")
      inspect(template4104.perturbation_number, content="3")
      inspect(template4104.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.104 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4105 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4105({
      base: {
        base: {
          parameter_category: 10,
          parameter_number: 20,
          type_of_generating_process: 4,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
        },
        end_year: 2024,
        end_month: 5,
        end_day: 2,
        end_hour: 0,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 1,
        number_of_missing_values: 0,
        time_range_specs: [
          {
            statistical_process: 1,
            type_of_time_increment: 2,
            time_range_unit: 1,
            time_range_length: 6,
            time_increment_unit: 1,
            time_increment_length: 1,
          },
        ],
        reserved_tail: b"",
      },
      reference_period: {
        type_of_reference_dataset: 1,
        type_of_relation_to_reference_dataset: 2,
        number_of_additional_parameters: 1,
        additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
        start_year: 1991,
        start_month: 1,
        start_day: 1,
        start_hour: 0,
        start_minute: 0,
        start_second: 0,
        sample_size: 30,
        number_of_reference_period_time_ranges: 1,
        reference_period_time_range_specs: [
          {
            statistical_processing_type: 1,
            time_range_unit: 1,
            time_range_length: 24,
          },
        ],
      },
      reserved_tail: b"\xcc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4105(template4105) => {
      inspect(template4105.base.number_of_time_ranges, content="1")
      inspect(template4105.base.time_range_specs.length(), content="1")
      inspect(
        template4105.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4105.reference_period.number_of_additional_parameters,
        content="1",
      )
      inspect(
        template4105.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4105.reference_period.additional_parameters[0].scaled_value,
        content="12",
      )
      inspect(template4105.reference_period.start_year, content="1991")
      inspect(
        template4105.reference_period.number_of_reference_period_time_ranges,
        content="1",
      )
      inspect(
        template4105.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4105.reserved_tail == b"\xcc", content="true")
    }
    _ => fail("template4.105 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4106 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4106({
      base: {
        base: {
          parameter_category: 10,
          parameter_number: 20,
          type_of_generating_process: 4,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
        },
        end_year: 2024,
        end_month: 5,
        end_day: 2,
        end_hour: 0,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 1,
        number_of_missing_values: 0,
        time_range_specs: [
          {
            statistical_process: 1,
            type_of_time_increment: 2,
            time_range_unit: 1,
            time_range_length: 6,
            time_increment_unit: 1,
            time_increment_length: 1,
          },
        ],
        reserved_tail: b"",
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reference_period: {
        type_of_reference_dataset: 1,
        type_of_relation_to_reference_dataset: 2,
        number_of_additional_parameters: 1,
        additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
        start_year: 1991,
        start_month: 1,
        start_day: 1,
        start_hour: 0,
        start_minute: 0,
        start_second: 0,
        sample_size: 30,
        number_of_reference_period_time_ranges: 1,
        reference_period_time_range_specs: [
          {
            statistical_processing_type: 1,
            time_range_unit: 1,
            time_range_length: 24,
          },
        ],
      },
      reserved_tail: b"\xcd",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4106(template4106) => {
      inspect(template4106.type_of_ensemble_forecast, content="2")
      inspect(template4106.perturbation_number, content="3")
      inspect(template4106.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template4106.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4106.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4106.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4106.reserved_tail == b"\xcd", content="true")
    }
    _ => fail("template4.106 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4107 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4107({
      base: {
        base: {
          parameter_category: 10,
          parameter_number: 20,
          type_of_generating_process: 4,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
        },
        end_year: 2024,
        end_month: 5,
        end_day: 2,
        end_hour: 0,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 1,
        number_of_missing_values: 0,
        time_range_specs: [
          {
            statistical_process: 1,
            type_of_time_increment: 2,
            time_range_unit: 1,
            time_range_length: 6,
            time_increment_unit: 1,
            time_increment_length: 1,
          },
        ],
        reserved_tail: b"",
      },
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 20,
      reference_period: {
        type_of_reference_dataset: 1,
        type_of_relation_to_reference_dataset: 2,
        number_of_additional_parameters: 1,
        additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
        start_year: 1991,
        start_month: 1,
        start_day: 1,
        start_hour: 0,
        start_minute: 0,
        start_second: 0,
        sample_size: 30,
        number_of_reference_period_time_ranges: 1,
        reference_period_time_range_specs: [
          {
            statistical_processing_type: 1,
            time_range_unit: 1,
            time_range_length: 24,
          },
        ],
      },
      reserved_tail: b"\xce",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4107(template4107) => {
      inspect(template4107.derived_forecast, content="4")
      inspect(template4107.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template4107.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4107.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4107.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4107.reserved_tail == b"\xce", content="true")
    }
    _ => fail("template4.107 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4108 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4108({
      parameter_category: 10,
      parameter_number: 20,
      type_of_interval_for_wavelength: 2,
      scale_factor_of_first_wavelength: 0,
      scaled_value_of_first_wavelength: 550,
      scale_factor_of_second_wavelength: 0,
      scaled_value_of_second_wavelength: 700,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4108(template4108) => {
      inspect(template4108.type_of_interval_for_wavelength, content="2")
      inspect(template4108.scaled_value_of_first_wavelength, content="550")
      inspect(template4108.scaled_value_of_second_wavelength, content="700")
      inspect(template4108.forecast_time, content="6")
      inspect(template4108.type_of_first_fixed_surface, content="100")
    }
    _ => fail("template4.108 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4109 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4109({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_interval_for_wavelength: 2,
        scale_factor_of_first_wavelength: 0,
        scaled_value_of_first_wavelength: 550,
        scale_factor_of_second_wavelength: 0,
        scaled_value_of_second_wavelength: 700,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4109(template4109) => {
      inspect(template4109.base.type_of_interval_for_wavelength, content="2")
      inspect(template4109.base.scaled_value_of_first_wavelength, content="550")
      inspect(
        template4109.base.scaled_value_of_second_wavelength,
        content="700",
      )
      inspect(template4109.type_of_ensemble_forecast, content="2")
      inspect(template4109.perturbation_number, content="3")
      inspect(template4109.number_of_forecasts_in_ensemble, content="20")
    }
    _ => fail("template4.109 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4110 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4110({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_interval_for_wavelength: 2,
        scale_factor_of_first_wavelength: 0,
        scaled_value_of_first_wavelength: 550,
        scale_factor_of_second_wavelength: 0,
        scaled_value_of_second_wavelength: 700,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 1,
      number_of_missing_values: 0,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
      ],
      reserved_tail: b"\xcf",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4110(template4110) => {
      inspect(template4110.base.type_of_interval_for_wavelength, content="2")
      inspect(template4110.base.scaled_value_of_first_wavelength, content="550")
      inspect(
        template4110.base.scaled_value_of_second_wavelength,
        content="700",
      )
      inspect(template4110.number_of_time_ranges, content="1")
      inspect(template4110.time_range_specs.length(), content="1")
      inspect(template4110.time_range_specs[0].time_range_length, content="6")
      inspect(template4110.reserved_tail == b"\xcf", content="true")
    }
    _ => fail("template4.110 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4111 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4111({
      base: {
        base: {
          parameter_category: 10,
          parameter_number: 20,
          type_of_interval_for_wavelength: 2,
          scale_factor_of_first_wavelength: 0,
          scaled_value_of_first_wavelength: 550,
          scale_factor_of_second_wavelength: 0,
          scaled_value_of_second_wavelength: 700,
          type_of_generating_process: 4,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
        },
        type_of_ensemble_forecast: 2,
        perturbation_number: 3,
        number_of_forecasts_in_ensemble: 20,
      },
      end_year: 2024,
      end_month: 5,
      end_day: 2,
      end_hour: 0,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 1,
      number_of_missing_values: 0,
      time_range_specs: [
        {
          statistical_process: 1,
          type_of_time_increment: 2,
          time_range_unit: 1,
          time_range_length: 6,
          time_increment_unit: 1,
          time_increment_length: 1,
        },
      ],
      reserved_tail: b"\xd0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4111(template4111) => {
      inspect(
        template4111.base.base.type_of_interval_for_wavelength,
        content="2",
      )
      inspect(
        template4111.base.base.scaled_value_of_first_wavelength,
        content="550",
      )
      inspect(template4111.base.type_of_ensemble_forecast, content="2")
      inspect(template4111.base.perturbation_number, content="3")
      inspect(template4111.base.number_of_forecasts_in_ensemble, content="20")
      inspect(template4111.number_of_time_ranges, content="1")
      inspect(template4111.time_range_specs.length(), content="1")
      inspect(template4111.time_range_specs[0].time_range_length, content="6")
      inspect(template4111.reserved_tail == b"\xd0", content="true")
    }
    _ => fail("template4.111 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4112 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4112({
      base: {
        base: {
          parameter_category: 10,
          parameter_number: 20,
          type_of_generating_process: 4,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
        },
        end_year: 2024,
        end_month: 5,
        end_day: 2,
        end_hour: 0,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 1,
        number_of_missing_values: 0,
        time_range_specs: [
          {
            statistical_process: 1,
            type_of_time_increment: 2,
            time_range_unit: 1,
            time_range_length: 6,
            time_increment_unit: 1,
            time_increment_length: 1,
          },
        ],
        reserved_tail: b"",
      },
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reference_period: {
        type_of_reference_dataset: 1,
        type_of_relation_to_reference_dataset: 2,
        number_of_additional_parameters: 1,
        additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
        start_year: 1991,
        start_month: 1,
        start_day: 1,
        start_hour: 0,
        start_minute: 0,
        start_second: 0,
        sample_size: 30,
        number_of_reference_period_time_ranges: 1,
        reference_period_time_range_specs: [
          {
            statistical_processing_type: 1,
            time_range_unit: 1,
            time_range_length: 24,
          },
        ],
      },
      reserved_tail: b"\xd1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4112(template4112) => {
      inspect(template4112.base.number_of_time_ranges, content="1")
      inspect(template4112.base.time_range_specs.length(), content="1")
      inspect(template4112.forecast_probability_number, content="2")
      inspect(template4112.total_number_of_forecast_probabilities, content="10")
      inspect(template4112.probability_type, content="1")
      inspect(template4112.scaled_value_of_lower_limit, content="100")
      inspect(template4112.scaled_value_of_upper_limit, content="200")
      inspect(
        template4112.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4112.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4112.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4112.reserved_tail == b"\xd1", content="true")
    }
    _ => fail("template4.112 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
fn sample_generalized_tile_definition() -> Grib2GeneralizedTileDefinition {
  {
    tile_classification: 3,
    type_of_tile: 258,
    number_of_used_spatial_tiles: 4,
    number_of_used_tile_attribute_combinations_for_type_of_tile: 2,
    number_of_used_tile_attributes: 2,
    tile_attributes: [11, 22],
    total_number_of_tile_attribute_combinations: 5,
    tile_index: 7,
    uuid_of_data_group: b"\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
  }
}

///|
test "section4 template4113 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4113({
      base: sample_template40_base(),
      tile: sample_generalized_tile_definition(),
      reserved_tail: b"\xd2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4113(template4113) => {
      inspect(template4113.tile.type_of_tile, content="258")
      inspect(template4113.tile.number_of_used_tile_attributes, content="2")
      inspect(template4113.tile.tile_attributes.length(), content="2")
      inspect(template4113.tile.uuid_of_data_group.length(), content="16")
      inspect(template4113.reserved_tail == b"\xd2", content="true")
    }
    _ => fail("template4.113 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4114 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4114({
      base: {
        base: sample_template40_base(),
        tile: sample_generalized_tile_definition(),
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xd3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4114(template4114) => {
      inspect(
        template4114.base.tile.number_of_used_tile_attributes,
        content="2",
      )
      inspect(template4114.number_of_time_ranges, content="2")
      inspect(template4114.time_range_specs.length(), content="2")
      inspect(template4114.reserved_tail == b"\xd3", content="true")
    }
    _ => fail("template4.114 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4115 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4115({
      base: {
        base: sample_template40_base(),
        tile: sample_generalized_tile_definition(),
        reserved_tail: b"",
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      reserved_tail: b"\xd4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4115(template4115) => {
      inspect(template4115.type_of_ensemble_forecast, content="2")
      inspect(template4115.perturbation_number, content="123456")
      inspect(template4115.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4115.reserved_tail == b"\xd4", content="true")
    }
    _ => fail("template4.115 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4116 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4116({
      base: {
        base: {
          base: sample_template40_base(),
          tile: sample_generalized_tile_definition(),
          reserved_tail: b"",
        },
        type_of_ensemble_forecast: 2,
        perturbation_number: 123456,
        number_of_forecasts_in_ensemble: 987654,
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xd5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4116(template4116) => {
      inspect(template4116.base.base.tile.tile_index, content="7")
      inspect(template4116.base.perturbation_number, content="123456")
      inspect(template4116.number_of_time_ranges, content="2")
      inspect(template4116.time_range_specs.length(), content="2")
      inspect(template4116.reserved_tail == b"\xd5", content="true")
    }
    _ => fail("template4.116 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
fn sample_template4117_base() -> Grib2ProductTemplate4117 {
  {
    base: sample_template40_base(),
    type_of_ensemble_forecast: 2,
    perturbation_number: 123456,
    number_of_forecasts_in_ensemble: 987654,
    reserved_tail: b"",
  }
}

///|
fn sample_reference_period_definition() -> Grib2ReferencePeriodDefinition {
  {
    type_of_reference_dataset: 1,
    type_of_relation_to_reference_dataset: 2,
    number_of_additional_parameters: 1,
    additional_parameters: [{ scale_factor: 0, scaled_value: 12 }],
    start_year: 1991,
    start_month: 1,
    start_day: 1,
    start_hour: 0,
    start_minute: 0,
    start_second: 0,
    sample_size: 30,
    number_of_reference_period_time_ranges: 1,
    reference_period_time_range_specs: [
      {
        statistical_processing_type: 1,
        time_range_unit: 1,
        time_range_length: 24,
      },
    ],
  }
}

///|
fn sample_spatial_vicinity_definition() -> Grib2SpatialVicinityDefinition {
  {
    spatial_vicinity_type: 1,
    number_of_spatial_vicinity_values: 2,
    spatial_vicinity_values: [100, 200],
    spatial_vicinity_processing: 3,
    spatial_vicinity_processing_argument1: 10,
    spatial_vicinity_processing_argument2: 20,
    spatial_vicinity_missing_data: 1,
    temporal_vicinity_processing: 4,
    temporal_vicinity_unit: 1,
    temporal_vicinity_towards_past: 6,
    temporal_vicinity_towards_future: 9,
  }
}

///|
fn sample_template4124(reserved_tail : Bytes) -> Grib2ProductTemplate4124 {
  {
    parameter_category: 20,
    parameter_number: 11,
    atmospheric_chemical_constituent_type: 230,
    source_or_sink: 1,
    transport_model_used: 333,
    requested_by_entity: 34,
    scenario_origin: 335,
    nwp_used: 336,
    release_start_year: 2026,
    release_start_month: 2,
    release_start_day: 21,
    release_start_hour: 6,
    release_start_minute: 30,
    wall_clock_initial_year: 2026,
    wall_clock_initial_month: 2,
    wall_clock_initial_day: 21,
    wall_clock_initial_hour: 5,
    wall_clock_initial_minute: 59,
    wall_clock_initial_second: 10,
    type_of_generating_process: 2,
    background_process_identifier: 1,
    generating_process_identifier: 10,
    hours_of_observational_data_cutoff: 2,
    minutes_of_observational_data_cutoff: 30,
    time_range_unit: 1,
    forecast_time: 6,
    type_of_first_fixed_surface: 100,
    scale_factor_of_first_fixed_surface: 0,
    scaled_value_of_first_fixed_surface: 50000,
    type_of_second_fixed_surface: 255,
    scale_factor_of_second_fixed_surface: 0,
    scaled_value_of_second_fixed_surface: 0,
    reserved_tail,
  }
}

///|
fn sample_template4126(reserved_tail : Bytes) -> Grib2ProductTemplate4126 {
  {
    parameter_category: 20,
    parameter_number: 11,
    atmospheric_chemical_constituent_type: 230,
    source_or_sink: 1,
    transport_model_used: 333,
    requested_by_entity: 34,
    scenario_origin: 335,
    nwp_used: 336,
    release_start_year: 2026,
    release_start_month: 2,
    release_start_day: 21,
    release_start_hour: 6,
    release_start_minute: 30,
    release_start_second: 45,
    wall_clock_initial_year: 2026,
    wall_clock_initial_month: 2,
    wall_clock_initial_day: 21,
    wall_clock_initial_hour: 5,
    wall_clock_initial_minute: 59,
    wall_clock_initial_second: 10,
    type_of_generating_process: 2,
    background_process_identifier: 1,
    generating_process_identifier: 10,
    hours_of_observational_data_cutoff: 2,
    minutes_of_observational_data_cutoff: 30,
    time_range_unit: 1,
    forecast_time: 6,
    type_of_first_fixed_surface: 100,
    scale_factor_of_first_fixed_surface: 0,
    scaled_value_of_first_fixed_surface: 50000,
    type_of_second_fixed_surface: 255,
    scale_factor_of_second_fixed_surface: 0,
    scaled_value_of_second_fixed_surface: 0,
    end_year: 2026,
    end_month: 2,
    end_day: 21,
    end_hour: 6,
    end_minute: 0,
    end_second: 0,
    number_of_time_ranges: 2,
    number_of_missing_values: 1,
    time_range_specs: sample_time_range_specs(),
    reserved_tail,
  }
}

///|
fn sample_template4152(reserved_tail : Bytes) -> Grib2ProductTemplate4152 {
  {
    parameter_category: 20,
    parameter_number: 11,
    atmospheric_chemical_constituent_type: 230,
    type_of_generating_process: 2,
    background_process_identifier: 1,
    generating_process_identifier: 10,
    hours_of_observational_data_cutoff: 2,
    minutes_of_observational_data_cutoff: 30,
    time_range_unit: 1,
    forecast_time: 6,
    type_of_first_fixed_surface: 100,
    scale_factor_of_first_fixed_surface: 0,
    scaled_value_of_first_fixed_surface: 50000,
    type_of_second_fixed_surface: 255,
    scale_factor_of_second_fixed_surface: 0,
    scaled_value_of_second_fixed_surface: 0,
    type_of_ensemble_forecast: 2,
    perturbation_number: 123456,
    number_of_forecasts_in_ensemble: 987654,
    year_of_model_version_date: 2026,
    month_of_model_version_date: 2,
    day_of_model_version_date: 21,
    hour_of_model_version_date: 12,
    minute_of_model_version_date: 34,
    second_of_model_version_date: 56,
    reserved_tail,
  }
}

///|
fn sample_template4154(reserved_tail : Bytes) -> Grib2ProductTemplate4154 {
  {
    base: sample_template40_base(),
    type_of_ensemble_forecast: 2,
    perturbation_number: 123456,
    number_of_forecasts_in_ensemble: 987654,
    year_of_model_version_date: 2026,
    month_of_model_version_date: 2,
    day_of_model_version_date: 21,
    hour_of_model_version_date: 12,
    minute_of_model_version_date: 34,
    second_of_model_version_date: 56,
    reserved_tail,
  }
}

///|
fn sample_template41000(reserved_tail : Bytes) -> Grib2ProductTemplate41000 {
  {
    parameter_category: 0,
    parameter_number: 1,
    type_of_generating_process: 2,
    background_process_identifier: 0,
    generating_process_identifier: 96,
    hours_of_observational_data_cutoff: 0,
    minutes_of_observational_data_cutoff: 0,
    time_range_unit: 1,
    forecast_time: 6,
    reserved_tail,
  }
}

///|
fn sample_template41100(reserved_tail : Bytes) -> Grib2ProductTemplate41100 {
  { base: sample_template40_base(), reserved_tail }
}

///|
test "section4 template4117 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4117({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      reserved_tail: b"\xd6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4117(template4117) => {
      inspect(template4117.type_of_ensemble_forecast, content="2")
      inspect(template4117.perturbation_number, content="123456")
      inspect(template4117.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4117.reserved_tail == b"\xd6", content="true")
    }
    _ => fail("template4.117 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4118 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4118({
      base: sample_template4117_base(),
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xd7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4118(template4118) => {
      inspect(template4118.base.perturbation_number, content="123456")
      inspect(template4118.number_of_time_ranges, content="2")
      inspect(template4118.time_range_specs.length(), content="2")
      inspect(template4118.reserved_tail == b"\xd7", content="true")
    }
    _ => fail("template4.118 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4119 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4119({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      number_of_forecasts_in_ensemble: 987654,
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reserved_tail: b"\xd8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4119(template4119) => {
      inspect(template4119.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4119.forecast_probability_number, content="2")
      inspect(template4119.probability_type, content="1")
      inspect(template4119.scaled_value_of_upper_limit, content="200")
      inspect(template4119.reserved_tail == b"\xd8", content="true")
    }
    _ => fail("template4.119 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4120 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4120({
      base: {
        base: sample_template40_base(),
        type_of_ensemble_forecast: 2,
        number_of_forecasts_in_ensemble: 987654,
        forecast_probability_number: 2,
        total_number_of_forecast_probabilities: 10,
        probability_type: 1,
        scale_factor_of_lower_limit: 0,
        scaled_value_of_lower_limit: 100,
        scale_factor_of_upper_limit: 0,
        scaled_value_of_upper_limit: 200,
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 6,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xd9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4120(template4120) => {
      inspect(
        template4120.base.number_of_forecasts_in_ensemble,
        content="987654",
      )
      inspect(template4120.base.forecast_probability_number, content="2")
      inspect(template4120.number_of_time_ranges, content="2")
      inspect(template4120.time_range_specs.length(), content="2")
      inspect(template4120.reserved_tail == b"\xd9", content="true")
    }
    _ => fail("template4.120 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4121 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4121({
      base: {
        base: sample_template40_base(),
        type_of_ensemble_forecast: 2,
        number_of_forecasts_in_ensemble: 987654,
        forecast_probability_number: 2,
        total_number_of_forecast_probabilities: 10,
        probability_type: 1,
        scale_factor_of_lower_limit: 0,
        scaled_value_of_lower_limit: 100,
        scale_factor_of_upper_limit: 0,
        scaled_value_of_upper_limit: 200,
        reserved_tail: b"",
      },
      spatial_vicinity: sample_spatial_vicinity_definition(),
      reserved_tail: b"\xda",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4121(template4121) => {
      inspect(
        template4121.base.number_of_forecasts_in_ensemble,
        content="987654",
      )
      inspect(
        template4121.spatial_vicinity.number_of_spatial_vicinity_values,
        content="2",
      )
      inspect(
        template4121.spatial_vicinity.spatial_vicinity_values.length(),
        content="2",
      )
      inspect(
        template4121.spatial_vicinity.temporal_vicinity_towards_future,
        content="9",
      )
      inspect(template4121.reserved_tail == b"\xda", content="true")
    }
    _ => fail("template4.121 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4122 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4122({
      base: {
        base: {
          base: sample_template40_base(),
          type_of_ensemble_forecast: 2,
          number_of_forecasts_in_ensemble: 987654,
          forecast_probability_number: 2,
          total_number_of_forecast_probabilities: 10,
          probability_type: 1,
          scale_factor_of_lower_limit: 0,
          scaled_value_of_lower_limit: 100,
          scale_factor_of_upper_limit: 0,
          scaled_value_of_upper_limit: 200,
          reserved_tail: b"",
        },
        end_year: 2026,
        end_month: 2,
        end_day: 21,
        end_hour: 6,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 2,
        number_of_missing_values: 1,
        time_range_specs: sample_time_range_specs(),
        reserved_tail: b"",
      },
      spatial_vicinity: sample_spatial_vicinity_definition(),
      reserved_tail: b"\xdb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4122(template4122) => {
      inspect(template4122.base.number_of_time_ranges, content="2")
      inspect(template4122.base.time_range_specs.length(), content="2")
      inspect(
        template4122.spatial_vicinity.spatial_vicinity_processing_argument2,
        content="20",
      )
      inspect(template4122.reserved_tail == b"\xdb", content="true")
    }
    _ => fail("template4.122 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4123 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4123({
      base: {
        base: sample_template40_base(),
        end_year: 2026,
        end_month: 2,
        end_day: 21,
        end_hour: 6,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 2,
        number_of_missing_values: 1,
        time_range_specs: sample_time_range_specs(),
        reserved_tail: b"",
      },
      type_of_ensemble_forecast: 2,
      number_of_forecasts_in_ensemble: 987654,
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reference_period: sample_reference_period_definition(),
      spatial_vicinity: sample_spatial_vicinity_definition(),
      reserved_tail: b"\xdc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4123(template4123) => {
      inspect(template4123.base.number_of_time_ranges, content="2")
      inspect(template4123.number_of_forecasts_in_ensemble, content="987654")
      inspect(
        template4123.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4123.spatial_vicinity.temporal_vicinity_towards_past,
        content="6",
      )
      inspect(template4123.reserved_tail == b"\xdc", content="true")
    }
    _ => fail("template4.123 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4124 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4124(sample_template4124(b"\xdd")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4124(template4124) => {
      inspect(template4124.atmospheric_chemical_constituent_type, content="230")
      inspect(template4124.transport_model_used, content="333")
      inspect(template4124.release_start_year, content="2026")
      inspect(template4124.forecast_time, content="6")
      inspect(template4124.reserved_tail == b"\xdd", content="true")
    }
    _ => fail("template4.124 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4125 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4125({
      base: sample_template4124(b""),
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reserved_tail: b"\xde",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4125(template4125) => {
      inspect(template4125.base.transport_model_used, content="333")
      inspect(template4125.base.release_start_day, content="21")
      inspect(template4125.type_of_ensemble_forecast, content="2")
      inspect(template4125.perturbation_number, content="3")
      inspect(template4125.number_of_forecasts_in_ensemble, content="20")
      inspect(template4125.reserved_tail == b"\xde", content="true")
    }
    _ => fail("template4.125 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4126 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4126(sample_template4126(b"\xdf")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4126(template4126) => {
      inspect(template4126.transport_model_used, content="333")
      inspect(template4126.release_start_second, content="45")
      inspect(template4126.end_year, content="2026")
      inspect(template4126.number_of_time_ranges, content="2")
      inspect(template4126.time_range_specs.length(), content="2")
      inspect(template4126.reserved_tail == b"\xdf", content="true")
    }
    _ => fail("template4.126 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4127 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4127({
      base: sample_template4126(b""),
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reserved_tail: b"\xe0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4127(template4127) => {
      inspect(template4127.base.release_start_second, content="45")
      inspect(template4127.base.end_year, content="2026")
      inspect(template4127.base.number_of_time_ranges, content="2")
      inspect(template4127.type_of_ensemble_forecast, content="2")
      inspect(template4127.perturbation_number, content="3")
      inspect(template4127.number_of_forecasts_in_ensemble, content="20")
      inspect(template4127.reserved_tail == b"\xe0", content="true")
    }
    _ => fail("template4.127 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4128 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4128({
      base: sample_template40_base(),
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4128(template4128) => {
      inspect(template4128.base.forecast_time, content="6")
      inspect(
        template4128.reference_period.type_of_reference_dataset,
        content="1",
      )
      inspect(
        template4128.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(
        template4128.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4128.reserved_tail == b"\xe1", content="true")
    }
    _ => fail("template4.128 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4129 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4129({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 3,
      number_of_forecasts_in_ensemble: 20,
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4129(template4129) => {
      inspect(template4129.base.forecast_time, content="6")
      inspect(template4129.type_of_ensemble_forecast, content="2")
      inspect(template4129.perturbation_number, content="3")
      inspect(template4129.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template4129.reference_period.reference_period_time_range_specs[0].time_range_length,
        content="24",
      )
      inspect(template4129.reserved_tail == b"\xe2", content="true")
    }
    _ => fail("template4.129 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4130 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4130({
      base: sample_template40_base(),
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 20,
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4130(template4130) => {
      inspect(template4130.base.forecast_time, content="6")
      inspect(template4130.derived_forecast, content="4")
      inspect(template4130.number_of_forecasts_in_ensemble, content="20")
      inspect(
        template4130.reference_period.type_of_relation_to_reference_dataset,
        content="2",
      )
      inspect(template4130.reserved_tail == b"\xe3", content="true")
    }
    _ => fail("template4.130 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4131 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4131({
      base: sample_template40_base(),
      forecast_probability_number: 2,
      total_number_of_forecast_probabilities: 10,
      probability_type: 1,
      scale_factor_of_lower_limit: 0,
      scaled_value_of_lower_limit: 100,
      scale_factor_of_upper_limit: 0,
      scaled_value_of_upper_limit: 200,
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4131(template4131) => {
      inspect(template4131.base.forecast_time, content="6")
      inspect(template4131.forecast_probability_number, content="2")
      inspect(template4131.total_number_of_forecast_probabilities, content="10")
      inspect(template4131.scaled_value_of_upper_limit, content="200")
      inspect(
        template4131.reference_period.additional_parameters.length(),
        content="1",
      )
      inspect(template4131.reserved_tail == b"\xe4", content="true")
    }
    _ => fail("template4.131 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4132 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4132({
      base: sample_template40_base(),
      total_number_of_quantiles: 1000,
      quantile_value: 250,
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4132(template4132) => {
      inspect(template4132.base.forecast_time, content="6")
      inspect(template4132.total_number_of_quantiles, content="1000")
      inspect(template4132.quantile_value, content="250")
      inspect(
        template4132.reference_period.number_of_reference_period_time_ranges,
        content="1",
      )
      inspect(template4132.reserved_tail == b"\xe5", content="true")
    }
    _ => fail("template4.132 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4133 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4133({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        input_process_identifier: 321,
        input_originating_centre: 34,
        type_of_post_processing: 2,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
        total_number_of_quantiles: 1000,
        quantile_value: 250,
      },
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4133(template4133) => {
      inspect(template4133.base.input_process_identifier, content="321")
      inspect(template4133.base.type_of_post_processing, content="2")
      inspect(template4133.base.total_number_of_quantiles, content="1000")
      inspect(template4133.base.quantile_value, content="250")
      inspect(template4133.reference_period.start_year, content="1991")
      inspect(template4133.reserved_tail == b"\xe6", content="true")
    }
    _ => fail("template4.133 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4134 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4134({
      base: {
        base: {
          parameter_category: 10,
          parameter_number: 20,
          type_of_generating_process: 4,
          background_process_identifier: 1,
          generating_process_identifier: 10,
          hours_of_observational_data_cutoff: 2,
          minutes_of_observational_data_cutoff: 30,
          time_range_unit: 1,
          forecast_time: 6,
          type_of_first_fixed_surface: 100,
          scale_factor_of_first_fixed_surface: 0,
          scaled_value_of_first_fixed_surface: 50000,
          type_of_second_fixed_surface: 255,
          scale_factor_of_second_fixed_surface: 0,
          scaled_value_of_second_fixed_surface: 0,
          total_number_of_quantiles: 1000,
          quantile_value: 250,
        },
        end_year: 2026,
        end_month: 2,
        end_day: 21,
        end_hour: 6,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 2,
        number_of_missing_values: 1,
        time_range_specs: sample_time_range_specs(),
        reserved_tail: b"",
      },
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4134(template4134) => {
      inspect(template4134.base.base.total_number_of_quantiles, content="1000")
      inspect(template4134.base.number_of_time_ranges, content="2")
      inspect(template4134.base.time_range_specs.length(), content="2")
      inspect(template4134.reference_period.sample_size, content="30")
      inspect(template4134.reserved_tail == b"\xe7", content="true")
    }
    _ => fail("template4.134 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4135 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4135({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        input_process_identifier: 321,
        input_originating_centre: 34,
        type_of_post_processing: 2,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
        total_number_of_quantiles: 1000,
        quantile_value: 250,
        end_year: 2026,
        end_month: 2,
        end_day: 21,
        end_hour: 6,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 2,
        number_of_missing_values: 1,
        time_range_specs: sample_time_range_specs(),
        reserved_tail: b"",
      },
      reference_period: sample_reference_period_definition(),
      reserved_tail: b"\xe8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4135(template4135) => {
      inspect(template4135.base.input_process_identifier, content="321")
      inspect(template4135.base.type_of_post_processing, content="2")
      inspect(template4135.base.number_of_time_ranges, content="2")
      inspect(template4135.base.time_range_specs.length(), content="2")
      inspect(template4135.reference_period.start_year, content="1991")
      inspect(template4135.reserved_tail == b"\xe8", content="true")
    }
    _ => fail("template4.135 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4136 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4136({
      base: {
        base: sample_template40_base(),
        type_of_ensemble_forecast: 2,
        number_of_forecasts_in_ensemble: 987654,
        forecast_probability_number: 2,
        total_number_of_forecast_probabilities: 10,
        probability_type: 1,
        scale_factor_of_lower_limit: 0,
        scaled_value_of_lower_limit: 100,
        scale_factor_of_upper_limit: 0,
        scaled_value_of_upper_limit: 200,
        reserved_tail: b"",
      },
      reference_period: sample_reference_period_definition(),
      spatial_vicinity: sample_spatial_vicinity_definition(),
      reserved_tail: b"\xe9",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4136(template4136) => {
      inspect(
        template4136.base.number_of_forecasts_in_ensemble,
        content="987654",
      )
      inspect(template4136.base.forecast_probability_number, content="2")
      inspect(
        template4136.reference_period.number_of_reference_period_time_ranges,
        content="1",
      )
      inspect(
        template4136.spatial_vicinity.number_of_spatial_vicinity_values,
        content="2",
      )
      inspect(template4136.reserved_tail == b"\xe9", content="true")
    }
    _ => fail("template4.136 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4137 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4137({
      base: sample_template40_base(),
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 987654,
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      reserved_tail: b"\xea",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4137(template4137) => {
      inspect(template4137.base.forecast_time, content="6")
      inspect(template4137.derived_forecast, content="4")
      inspect(template4137.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4137.year_of_model_version_date, content="2026")
      inspect(template4137.second_of_model_version_date, content="10")
      inspect(template4137.reserved_tail == b"\xea", content="true")
    }
    _ => fail("template4.137 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4138 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4138({
      base: {
        base: sample_template40_base(),
        derived_forecast: 4,
        number_of_forecasts_in_ensemble: 987654,
        year_of_model_version_date: 2026,
        month_of_model_version_date: 2,
        day_of_model_version_date: 21,
        hour_of_model_version_date: 6,
        minute_of_model_version_date: 0,
        second_of_model_version_date: 10,
        reserved_tail: b"",
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xeb",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4138(template4138) => {
      inspect(template4138.base.derived_forecast, content="4")
      inspect(
        template4138.base.number_of_forecasts_in_ensemble,
        content="987654",
      )
      inspect(template4138.end_year, content="2026")
      inspect(template4138.number_of_time_ranges, content="2")
      inspect(template4138.time_range_specs.length(), content="2")
      inspect(template4138.reserved_tail == b"\xeb", content="true")
    }
    _ => fail("template4.138 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4139 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4139({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 10,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      reserved_tail: b"\xec",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4139(template4139) => {
      inspect(template4139.base.type_of_wave_period_interval, content="2")
      inspect(
        template4139.base.scaled_value_of_upper_wave_period_limit,
        content="20",
      )
      inspect(template4139.year_of_model_version_date, content="2026")
      inspect(template4139.second_of_model_version_date, content="10")
      inspect(template4139.reserved_tail == b"\xec", content="true")
    }
    _ => fail("template4.139 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4140 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4140({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 10,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      reserved_tail: b"\xed",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4140(template4140) => {
      inspect(template4140.base.type_of_wave_period_interval, content="2")
      inspect(template4140.type_of_ensemble_forecast, content="2")
      inspect(template4140.perturbation_number, content="123456")
      inspect(template4140.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4140.year_of_model_version_date, content="2026")
      inspect(template4140.reserved_tail == b"\xed", content="true")
    }
    _ => fail("template4.140 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4141 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4141({
      parameter_category: 10,
      parameter_number: 20,
      wave_direction_number: 2,
      number_of_wave_directions: 3,
      wave_frequency_number: 4,
      number_of_wave_frequencies: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      scale_factor_of_wave_directions: 1,
      scaled_wave_directions: [450, 900, 1350],
      scale_factor_of_wave_frequencies: 3,
      scaled_wave_frequencies: [125, 250],
      reserved_tail: b"\xee",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4141(template4141) => {
      inspect(template4141.number_of_wave_directions, content="3")
      inspect(template4141.scaled_wave_directions.length(), content="3")
      inspect(template4141.scaled_wave_directions[1], content="900")
      inspect(template4141.number_of_wave_frequencies, content="2")
      inspect(template4141.scaled_wave_frequencies[1], content="250")
      inspect(template4141.year_of_model_version_date, content="2026")
      inspect(template4141.second_of_model_version_date, content="10")
      inspect(template4141.reserved_tail == b"\xee", content="true")
    }
    _ => fail("template4.141 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4142 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4142({
      parameter_category: 10,
      parameter_number: 20,
      wave_direction_number: 2,
      number_of_wave_directions: 3,
      wave_frequency_number: 4,
      number_of_wave_frequencies: 2,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      year_of_model_version_date: 2026,
      month_of_model_version_date: 2,
      day_of_model_version_date: 21,
      hour_of_model_version_date: 6,
      minute_of_model_version_date: 0,
      second_of_model_version_date: 10,
      scale_factor_of_wave_directions: 1,
      scaled_wave_directions: [450, 900, 1350],
      scale_factor_of_wave_frequencies: 3,
      scaled_wave_frequencies: [125, 250],
      reserved_tail: b"\xef",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4142(template4142) => {
      inspect(template4142.type_of_ensemble_forecast, content="2")
      inspect(template4142.perturbation_number, content="123456")
      inspect(template4142.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4142.number_of_wave_directions, content="3")
      inspect(template4142.scaled_wave_directions.length(), content="3")
      inspect(template4142.scaled_wave_frequencies.length(), content="2")
      inspect(template4142.year_of_model_version_date, content="2026")
      inspect(template4142.reserved_tail == b"\xef", content="true")
    }
    _ => fail("template4.142 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4143 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4143({
      parameter_category: 10,
      parameter_number: 20,
      type_of_generating_process: 4,
      background_process_identifier: 1,
      generating_process_identifier: 10,
      hours_of_observational_data_cutoff: 2,
      minutes_of_observational_data_cutoff: 30,
      time_range_unit: 1,
      forecast_time: 6,
      random_field_number: 7,
      total_number_of_random_fields: 20,
      spatio_temporal_scale_number: 3,
      total_number_of_spatio_temporal_scales: 8,
      scaled_value_of_spatial_scale: 1000,
      scale_factor_of_spatial_scale: 1,
      scaled_value_of_temporal_scale: 3600,
      scale_factor_of_temporal_scale: 0,
      type_of_first_fixed_surface: 100,
      scale_factor_of_first_fixed_surface: 0,
      scaled_value_of_first_fixed_surface: 50000,
      type_of_second_fixed_surface: 255,
      scale_factor_of_second_fixed_surface: 0,
      scaled_value_of_second_fixed_surface: 0,
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      reserved_tail: b"\xf0",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4143(template4143) => {
      inspect(template4143.random_field_number, content="7")
      inspect(template4143.total_number_of_random_fields, content="20")
      inspect(template4143.spatio_temporal_scale_number, content="3")
      inspect(template4143.scaled_value_of_spatial_scale, content="1000")
      inspect(template4143.scaled_value_of_temporal_scale, content="3600")
      inspect(template4143.perturbation_number, content="123456")
      inspect(template4143.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4143.reserved_tail == b"\xf0", content="true")
    }
    _ => fail("template4.143 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4144 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4144({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 10,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xf1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4144(template4144) => {
      inspect(template4144.base.type_of_wave_period_interval, content="2")
      inspect(
        template4144.base.scaled_value_of_upper_wave_period_limit,
        content="20",
      )
      inspect(template4144.end_year, content="2026")
      inspect(template4144.number_of_time_ranges, content="2")
      inspect(template4144.time_range_specs.length(), content="2")
      inspect(template4144.reserved_tail == b"\xf1", content="true")
    }
    _ => fail("template4.144 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4145 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4145({
      base: {
        parameter_category: 10,
        parameter_number: 20,
        type_of_wave_period_interval: 2,
        scale_factor_of_lower_wave_period_limit: 0,
        scaled_value_of_lower_wave_period_limit: 10,
        scale_factor_of_upper_wave_period_limit: 0,
        scaled_value_of_upper_wave_period_limit: 20,
        type_of_generating_process: 4,
        background_process_identifier: 1,
        generating_process_identifier: 10,
        hours_of_observational_data_cutoff: 2,
        minutes_of_observational_data_cutoff: 30,
        time_range_unit: 1,
        forecast_time: 6,
        type_of_first_fixed_surface: 100,
        scale_factor_of_first_fixed_surface: 0,
        scaled_value_of_first_fixed_surface: 50000,
        type_of_second_fixed_surface: 255,
        scale_factor_of_second_fixed_surface: 0,
        scaled_value_of_second_fixed_surface: 0,
      },
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xf2",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4145(template4145) => {
      inspect(template4145.base.type_of_wave_period_interval, content="2")
      inspect(template4145.type_of_ensemble_forecast, content="2")
      inspect(template4145.perturbation_number, content="123456")
      inspect(template4145.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4145.end_year, content="2026")
      inspect(template4145.time_range_specs.length(), content="2")
      inspect(template4145.reserved_tail == b"\xf2", content="true")
    }
    _ => fail("template4.145 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4146 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4146({
      base: sample_template40_base(),
      verification_score: 120,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf3",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4146(template4146) => {
      inspect(template4146.base.forecast_time, content="6")
      inspect(template4146.verification_score, content="120")
      inspect(
        template4146.verification.number_of_additional_arguments,
        content="2",
      )
      inspect(
        template4146.verification.additional_arguments.length(),
        content="2",
      )
      inspect(
        template4146.verification.number_of_verification_period_time_ranges,
        content="2",
      )
      inspect(
        template4146.verification.verification_period_time_range_specs.length(),
        content="2",
      )
      inspect(
        template4146.verification.number_of_forecasts_in_verification,
        content="77",
      )
      inspect(template4146.reserved_tail == b"\xf3", content="true")
    }
    _ => fail("template4.146 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4147 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4147({
      base: {
        base: sample_template40_base(),
        end_year: 2026,
        end_month: 2,
        end_day: 21,
        end_hour: 12,
        end_minute: 0,
        end_second: 0,
        number_of_time_ranges: 2,
        number_of_missing_values: 1,
        time_range_specs: sample_time_range_specs(),
        reserved_tail: b"",
      },
      verification_score: 121,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf4",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4147(template4147) => {
      inspect(template4147.base.number_of_time_ranges, content="2")
      inspect(template4147.base.time_range_specs.length(), content="2")
      inspect(template4147.verification_score, content="121")
      inspect(template4147.verification.start_year, content="2020")
      inspect(
        template4147.verification.additional_arguments[1].scaled_value,
        content="20",
      )
      inspect(
        template4147.verification.verification_period_time_range_specs[1].time_increment_length,
        content="6",
      )
      inspect(template4147.reserved_tail == b"\xf4", content="true")
    }
    _ => fail("template4.147 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4148 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4148({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      verification_score: 122,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf5",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4148(template4148) => {
      inspect(template4148.type_of_ensemble_forecast, content="2")
      inspect(template4148.perturbation_number, content="123456")
      inspect(template4148.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4148.verification_score, content="122")
      inspect(template4148.verification.start_year, content="2020")
      inspect(
        template4148.verification.number_of_forecasts_in_verification,
        content="77",
      )
      inspect(template4148.reserved_tail == b"\xf5", content="true")
    }
    _ => fail("template4.148 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4149 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4149({
      base: sample_template40_base(),
      type_of_ensemble_forecast: 2,
      perturbation_number: 123456,
      number_of_forecasts_in_ensemble: 987654,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      verification_score: 123,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf6",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4149(template4149) => {
      inspect(template4149.type_of_ensemble_forecast, content="2")
      inspect(template4149.perturbation_number, content="123456")
      inspect(template4149.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4149.end_year, content="2026")
      inspect(template4149.number_of_time_ranges, content="2")
      inspect(template4149.time_range_specs.length(), content="2")
      inspect(template4149.verification_score, content="123")
      inspect(
        template4149.verification.number_of_verification_period_time_ranges,
        content="2",
      )
      inspect(template4149.reserved_tail == b"\xf6", content="true")
    }
    _ => fail("template4.149 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4150 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4150({
      base: sample_template40_base(),
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 987654,
      verification_score: 124,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf7",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4150(template4150) => {
      inspect(template4150.derived_forecast, content="4")
      inspect(template4150.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4150.verification_score, content="124")
      inspect(template4150.verification.start_year, content="2020")
      inspect(
        template4150.verification.verification_period_time_range_specs.length(),
        content="2",
      )
      inspect(template4150.reserved_tail == b"\xf7", content="true")
    }
    _ => fail("template4.150 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4151 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4151({
      base: sample_template40_base(),
      derived_forecast: 4,
      number_of_forecasts_in_ensemble: 987654,
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      verification_score: 125,
      verification: sample_verification_definition(),
      reserved_tail: b"\xf8",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4151(template4151) => {
      inspect(template4151.derived_forecast, content="4")
      inspect(template4151.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4151.end_year, content="2026")
      inspect(template4151.number_of_time_ranges, content="2")
      inspect(template4151.time_range_specs.length(), content="2")
      inspect(template4151.verification_score, content="125")
      inspect(template4151.verification.start_year, content="2020")
      inspect(template4151.reserved_tail == b"\xf8", content="true")
    }
    _ => fail("template4.151 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4152 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4152(sample_template4152(b"\xf9")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4152(template4152) => {
      inspect(template4152.atmospheric_chemical_constituent_type, content="230")
      inspect(template4152.perturbation_number, content="123456")
      inspect(template4152.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4152.year_of_model_version_date, content="2026")
      inspect(template4152.second_of_model_version_date, content="56")
      inspect(template4152.reserved_tail == b"\xf9", content="true")
    }
    _ => fail("template4.152 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4153 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4153({
      base: sample_template4152(b""),
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4153(template4153) => {
      inspect(
        template4153.base.atmospheric_chemical_constituent_type,
        content="230",
      )
      inspect(template4153.base.year_of_model_version_date, content="2026")
      inspect(template4153.end_year, content="2026")
      inspect(template4153.number_of_time_ranges, content="2")
      inspect(template4153.time_range_specs.length(), content="2")
      inspect(template4153.reserved_tail == b"\xfa", content="true")
    }
    _ => fail("template4.153 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4154 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4154(sample_template4154(b"\xfb")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4154(template4154) => {
      inspect(template4154.base.forecast_time, content="6")
      inspect(template4154.type_of_ensemble_forecast, content="2")
      inspect(template4154.perturbation_number, content="123456")
      inspect(template4154.number_of_forecasts_in_ensemble, content="987654")
      inspect(template4154.year_of_model_version_date, content="2026")
      inspect(template4154.reserved_tail == b"\xfb", content="true")
    }
    _ => fail("template4.154 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4155 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4155({
      base: sample_template4154(b""),
      end_year: 2026,
      end_month: 2,
      end_day: 21,
      end_hour: 12,
      end_minute: 0,
      end_second: 0,
      number_of_time_ranges: 2,
      number_of_missing_values: 1,
      time_range_specs: sample_time_range_specs(),
      reserved_tail: b"\xfc",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4155(template4155) => {
      inspect(template4155.base.type_of_ensemble_forecast, content="2")
      inspect(template4155.base.year_of_model_version_date, content="2026")
      inspect(template4155.end_year, content="2026")
      inspect(template4155.number_of_time_ranges, content="2")
      inspect(template4155.time_range_specs.length(), content="2")
      inspect(template4155.reserved_tail == b"\xfc", content="true")
    }
    _ => fail("template4.155 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template4254 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate4254({
      parameter_category: 1,
      parameter_number: 2,
      number_of_characters: 5,
      character_string: b"HELLO",
      reserved_tail: b"\xfd",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate4254(template4254) => {
      inspect(template4254.parameter_category, content="1")
      inspect(template4254.parameter_number, content="2")
      inspect(template4254.number_of_characters, content="5")
      inspect(template4254.character_string == b"HELLO", content="true")
      inspect(template4254.reserved_tail == b"\xfd", content="true")
    }
    _ => fail("template4.254 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41000 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41000(sample_template41000(b"\xfe")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41000(template41000) => {
      inspect(template41000.parameter_number, content="1")
      inspect(template41000.forecast_time, content="6")
      inspect(template41000.reserved_tail == b"\xfe", content="true")
    }
    _ => fail("template4.1000 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41001 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41001({
      base: sample_template41000(b""),
      number_of_missing_values: 3,
      time_range_spec: sample_time_range_specs()[0],
      reserved_tail: b"\xff",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41001(template41001) => {
      inspect(template41001.base.forecast_time, content="6")
      inspect(template41001.number_of_missing_values, content="3")
      inspect(template41001.time_range_spec.statistical_process, content="1")
      inspect(template41001.time_range_spec.time_increment_length, content="3")
      inspect(template41001.reserved_tail == b"\xff", content="true")
    }
    _ => fail("template4.1001 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41002 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41002({
      base: sample_template41000(b""),
      horizontal_dimension_processed: 1,
      treatment_of_missing_data: 2,
      statistical_processing_type: 3,
      start_of_range: 10,
      end_of_range: 20,
      number_of_values: 11,
      reserved_tail: b"\xfa",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41002(template41002) => {
      inspect(template41002.base.parameter_number, content="1")
      inspect(template41002.horizontal_dimension_processed, content="1")
      inspect(template41002.treatment_of_missing_data, content="2")
      inspect(template41002.statistical_processing_type, content="3")
      inspect(template41002.start_of_range, content="10")
      inspect(template41002.end_of_range, content="20")
      inspect(template41002.number_of_values, content="11")
      inspect(template41002.reserved_tail == b"\xfa", content="true")
    }
    _ => fail("template4.1002 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41100 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41100(sample_template41100(b"\xf0")),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41100(template41100) => {
      inspect(template41100.base.forecast_time, content="6")
      inspect(template41100.base.type_of_first_fixed_surface, content="100")
      inspect(template41100.reserved_tail == b"\xf0", content="true")
    }
    _ => fail("template4.1100 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "section4 template41101 typed decode and encode roundtrip" {
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 0,
    template: ProductTemplate41101({
      base: sample_template40_base(),
      number_of_missing_values: 3,
      time_range_spec: sample_time_range_specs()[1],
      reserved_tail: b"\xf1",
    }),
    coordinate_values_raw: b"",
  }
  let encoded = encode_section4_bytes(section4)
  let decoded = match decode_section4_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  match decoded.template {
    ProductTemplate41101(template41101) => {
      inspect(template41101.base.forecast_time, content="6")
      inspect(template41101.number_of_missing_values, content="3")
      inspect(template41101.time_range_spec.statistical_process, content="3")
      inspect(template41101.time_range_spec.time_range_length, content="12")
      inspect(template41101.time_range_spec.time_increment_length, content="6")
      inspect(template41101.reserved_tail == b"\xf1", content="true")
    }
    _ => fail("template4.1101 was not decoded")
  }
  let reencoded = encode_section4_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}

///|
test "unknown section3 and section4 templates keep raw payloads" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplateUnknown(70, b"\x11\x22\x33"),
    optional_points_raw: b"\xaa",
  }
  let encoded3 = encode_section3_bytes(section3)
  let decoded3 = match decode_section3_bytes(encoded3) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  let reencoded3 = encode_section3_bytes(decoded3)
  inspect(reencoded3 == encoded3, content="true")
  let section4 : Grib2Section4Decoded = {
    number_of_coordinate_values: 1,
    template: ProductTemplateUnknown(42, b"\x99\x88\x77"),
    coordinate_values_raw: b"\x3f\x80\x00\x00",
  }
  let encoded4 = encode_section4_bytes(section4)
  let decoded4 = match decode_section4_bytes(encoded4) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  let reencoded4 = encode_section4_bytes(decoded4)
  inspect(reencoded4 == encoded4, content="true")
}
