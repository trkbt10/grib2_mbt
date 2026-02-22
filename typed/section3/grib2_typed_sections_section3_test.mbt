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
test "unknown section3 templates keep raw payloads" {
  let section3 : Grib2Section3Decoded = {
    source_of_grid_definition: 0,
    number_of_data_points: 1,
    optional_points_octet_count: 0,
    optional_points_interpretation: 0,
    template: GridTemplateUnknown(70, b"\x11\x22\x33"),
    optional_points_raw: b"\xaa",
  }
  let encoded = encode_section3_bytes(section3)
  let decoded = match decode_section3_bytes(encoded) {
    Ok(decoded) => decoded
    Err(error) => fail(error.to_string())
  }
  let reencoded = encode_section3_bytes(decoded)
  inspect(reencoded == encoded, content="true")
}
