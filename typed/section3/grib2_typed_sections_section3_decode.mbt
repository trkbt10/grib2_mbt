///|
fn typed_decode_latlon_base(
  template_payload : BytesView,
  template_name : String,
) -> Result[Grib2GridTemplate30, Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        template_name + " too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let t = template_payload.sub(end=58)
  Ok({
    shape_of_earth: t[0].to_uint().reinterpret_as_int(),
    scale_factor_radius: t[1].to_uint().reinterpret_as_int(),
    scaled_value_radius: typed_read_u32_be_view(t, 2),
    scale_factor_major_axis: t[6].to_uint().reinterpret_as_int(),
    scaled_value_major_axis: typed_read_u32_be_view(t, 7),
    scale_factor_minor_axis: t[11].to_uint().reinterpret_as_int(),
    scaled_value_minor_axis: typed_read_u32_be_view(t, 12),
    ni: typed_read_u32_be_view(t, 16),
    nj: typed_read_u32_be_view(t, 20),
    basic_angle: typed_read_u32_be_view(t, 24),
    subdivisions_of_basic_angle: typed_read_u32_be_view(t, 28),
    la1: typed_read_u32_be_view(t, 32),
    lo1: typed_read_u32_be_view(t, 36),
    resolution_and_component_flags: t[40].to_uint().reinterpret_as_int(),
    la2: typed_read_u32_be_view(t, 41),
    lo2: typed_read_u32_be_view(t, 45),
    di: typed_read_u32_be_view(t, 49),
    dj: typed_read_u32_be_view(t, 53),
    scanning_mode: t[57].to_uint().reinterpret_as_int(),
  })
}

///|
fn typed_decode_template_30(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate30, Bytes), Grib2SectionCodecError] {
  let base = match typed_decode_latlon_base(template_payload, "template 3.0") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok((base, template_payload.sub(start=58).to_bytes()))
}

///|
fn typed_decode_template_31(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate31, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.1 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_latlon_base(template_payload, "template 3.1") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 58),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 62),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_32(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate32, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.2 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_latlon_base(template_payload, "template 3.2") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 58,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 62,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_33(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate33, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 82 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.3 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_latlon_base(template_payload, "template 3.3") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 58),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 62),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 66),
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 70,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 74,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 78),
      },
      template_payload.sub(start=82).to_bytes(),
    ),
  )
}

///|
fn typed_read_u32_list(
  payload : BytesView,
  start : Int,
  count : Int,
) -> Array[Int] {
  let values : Array[Int] = []
  for i in 0..<count {
    values.push(typed_read_u32_be_view(payload, start + i * 4))
  }
  values
}

///|
fn typed_decode_template_34(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate34, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 34 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.4 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let ni = typed_read_u32_be_view(template_payload, 16)
  let nj = typed_read_u32_be_view(template_payload, 20)
  if ni < 0 || nj < 0 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.4 negative list count: ni=" +
        ni.to_string() +
        ", nj=" +
        nj.to_string(),
      ),
    )
  }
  let list_bytes = (ni + nj) * 4
  let required = 34 + list_bytes
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.4 list payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let longitude_list = typed_read_u32_list(template_payload, 34, ni)
  let latitude_list = typed_read_u32_list(template_payload, 34 + ni * 4, nj)
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni,
        nj,
        basic_angle: typed_read_u32_be_view(template_payload, 24),
        subdivisions_of_basic_angle: typed_read_u32_be_view(
          template_payload, 28,
        ),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        scanning_mode: template_payload[33].to_uint().reinterpret_as_int(),
        longitude_list,
        latitude_list,
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_35(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate35, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 46 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.5 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let ni = typed_read_u32_be_view(template_payload, 16)
  let nj = typed_read_u32_be_view(template_payload, 20)
  if ni < 0 || nj < 0 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.5 negative list count: ni=" +
        ni.to_string() +
        ", nj=" +
        nj.to_string(),
      ),
    )
  }
  let list_bytes = (ni + nj) * 4
  let required = 46 + list_bytes
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.5 list payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let longitude_list = typed_read_u32_list(template_payload, 46, ni)
  let latitude_list = typed_read_u32_list(template_payload, 46 + ni * 4, nj)
  Ok(
    (
      {
        base: {
          shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
          scale_factor_radius: template_payload[1]
          .to_uint()
          .reinterpret_as_int(),
          scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
          scale_factor_major_axis: template_payload[6]
          .to_uint()
          .reinterpret_as_int(),
          scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
          scale_factor_minor_axis: template_payload[11]
          .to_uint()
          .reinterpret_as_int(),
          scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
          ni,
          nj,
          basic_angle: typed_read_u32_be_view(template_payload, 24),
          subdivisions_of_basic_angle: typed_read_u32_be_view(
            template_payload, 28,
          ),
          resolution_and_component_flags: template_payload[32]
          .to_uint()
          .reinterpret_as_int(),
          scanning_mode: template_payload[33].to_uint().reinterpret_as_int(),
          longitude_list,
          latitude_list,
        },
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 34),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 38),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 42),
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_310(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate310, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.10 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni: typed_read_u32_be_view(template_payload, 16),
        nj: typed_read_u32_be_view(template_payload, 20),
        la1: typed_read_u32_be_view(template_payload, 24),
        lo1: typed_read_u32_be_view(template_payload, 28),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        lad: typed_read_u32_be_view(template_payload, 33),
        la2: typed_read_u32_be_view(template_payload, 37),
        lo2: typed_read_u32_be_view(template_payload, 41),
        scanning_mode: template_payload[45].to_uint().reinterpret_as_int(),
        orientation_of_the_grid: typed_read_u32_be_view(template_payload, 46),
        di: typed_read_u32_be_view(template_payload, 50),
        dj: typed_read_u32_be_view(template_payload, 54),
      },
      template_payload.sub(start=58).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_312(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate312, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.12 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni: typed_read_u32_be_view(template_payload, 16),
        nj: typed_read_u32_be_view(template_payload, 20),
        lar: typed_read_u32_be_view(template_payload, 24),
        lor: typed_read_u32_be_view(template_payload, 28),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        m: typed_read_u32_be_view(template_payload, 33),
        xr: typed_read_u32_be_view(template_payload, 37),
        yr: typed_read_u32_be_view(template_payload, 41),
        scanning_mode: template_payload[45].to_uint().reinterpret_as_int(),
        di: typed_read_u32_be_view(template_payload, 46),
        dj: typed_read_u32_be_view(template_payload, 50),
        x1: typed_read_u32_be_view(template_payload, 54),
        y1: typed_read_u32_be_view(template_payload, 58),
        x2: typed_read_u32_be_view(template_payload, 62),
        y2: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_313(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate313, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 74 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.13 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_310(template_payload.sub(end=58)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        nux: typed_read_u32_be_view(template_payload, 58),
        ncx: typed_read_u32_be_view(template_payload, 62),
        nuy: typed_read_u32_be_view(template_payload, 66),
        ncy: typed_read_u32_be_view(template_payload, 70),
      },
      template_payload.sub(start=74).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_320(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate320, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 51 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.20 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        la1: typed_read_u32_be_view(template_payload, 24),
        lo1: typed_read_u32_be_view(template_payload, 28),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        lad: typed_read_u32_be_view(template_payload, 33),
        lov: typed_read_u32_be_view(template_payload, 37),
        dx: typed_read_u32_be_view(template_payload, 41),
        dy: typed_read_u32_be_view(template_payload, 45),
        projection_center_flag: template_payload[49]
        .to_uint()
        .reinterpret_as_int(),
        scanning_mode: template_payload[50].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=51).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_323(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate323, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 67 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.23 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_320(template_payload.sub(end=51)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        nux: typed_read_u32_be_view(template_payload, 51),
        ncx: typed_read_u32_be_view(template_payload, 55),
        nuy: typed_read_u32_be_view(template_payload, 59),
        ncy: typed_read_u32_be_view(template_payload, 63),
      },
      template_payload.sub(start=67).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_330(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate330, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 67 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.30 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_320(template_payload.sub(end=51)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latin1: typed_read_u32_be_view(template_payload, 51),
        latin2: typed_read_u32_be_view(template_payload, 55),
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 59),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 63),
      },
      template_payload.sub(start=67).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_331(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate331, Bytes), Grib2SectionCodecError] {
  let (base, optional_points_raw) = match
    typed_decode_template_330(template_payload) {
    Ok((base, optional_points_raw)) => (base, optional_points_raw)
    Err(error) => return Err(error)
  }
  Ok(({ base, }, optional_points_raw))
}

///|
fn typed_decode_template_333(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate333, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 83 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.33 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_330(template_payload.sub(end=67)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        nux: typed_read_u32_be_view(template_payload, 67),
        ncx: typed_read_u32_be_view(template_payload, 71),
        nuy: typed_read_u32_be_view(template_payload, 75),
        ncy: typed_read_u32_be_view(template_payload, 79),
      },
      template_payload.sub(start=83).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_340(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate340, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.40 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni: typed_read_u32_be_view(template_payload, 16),
        nj: typed_read_u32_be_view(template_payload, 20),
        basic_angle: typed_read_u32_be_view(template_payload, 24),
        subdivisions_of_basic_angle: typed_read_u32_be_view(
          template_payload, 28,
        ),
        la1: typed_read_u32_be_view(template_payload, 32),
        lo1: typed_read_u32_be_view(template_payload, 36),
        resolution_and_component_flags: template_payload[40]
        .to_uint()
        .reinterpret_as_int(),
        la2: typed_read_u32_be_view(template_payload, 41),
        lo2: typed_read_u32_be_view(template_payload, 45),
        di: typed_read_u32_be_view(template_payload, 49),
        n: typed_read_u32_be_view(template_payload, 53),
        scanning_mode: template_payload[57].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=58).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_341(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate341, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.41 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_340(template_payload.sub(end=58)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 58),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 62),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_342(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate342, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 70 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.42 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_340(template_payload.sub(end=58)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 58,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 62,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 66),
      },
      template_payload.sub(start=70).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_343(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate343, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 82 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.43 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_340(template_payload.sub(end=58)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 58),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 62),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 66),
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 70,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 74,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 78),
      },
      template_payload.sub(start=82).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_350(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate350, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 14 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.50 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        j: typed_read_u32_be_view(template_payload, 0),
        k: typed_read_u32_be_view(template_payload, 4),
        m: typed_read_u32_be_view(template_payload, 8),
        representation_type: template_payload[12].to_uint().reinterpret_as_int(),
        representation_mode: template_payload[13].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=14).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_351(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate351, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 26 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.51 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_350(template_payload.sub(end=14)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 14),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 18),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 22),
      },
      template_payload.sub(start=26).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_352(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate352, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 26 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.52 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_350(template_payload.sub(end=14)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 14,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 18,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 22),
      },
      template_payload.sub(start=26).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_353(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate353, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 38 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.53 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match typed_decode_template_350(template_payload.sub(end=14)) {
    Ok((base, _)) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 14),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 18),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 22),
        latitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 26,
        ),
        longitude_of_stretching_pole: typed_read_u32_be_view(
          template_payload, 30,
        ),
        stretching_factor: typed_read_u32_be_view(template_payload, 34),
      },
      template_payload.sub(start=38).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_360(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate360, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 59 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.60 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        nc: typed_read_u32_be_view(template_payload, 24),
        xshift: typed_read_u32_be_view(template_payload, 28),
        yshift: typed_read_u32_be_view(template_payload, 32),
        face_number: template_payload[36].to_uint().reinterpret_as_int(),
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 37),
        longitude_of_southern_pole: typed_read_u32_be_view(template_payload, 41),
        angle_of_rotation: typed_read_u32_be_view(template_payload, 45),
        stretching_factor: typed_read_u32_be_view(template_payload, 49),
        gnomonic_grid_spacing_parameter: typed_read_u32_be_view(
          template_payload, 53,
        ),
        resolution_and_component_flags: template_payload[57]
        .to_uint()
        .reinterpret_as_int(),
        scanning_and_staggering_flags: template_payload[58]
        .to_uint()
        .reinterpret_as_int(),
      },
      template_payload.sub(start=59).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_361(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate361, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 98 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.61 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        spectral_representation_type: template_payload[0]
        .to_uint()
        .reinterpret_as_int(),
        n: typed_read_u32_be_view(template_payload, 1),
        m: typed_read_u32_be_view(template_payload, 5),
        bi_fourier_truncation_type: template_payload[9]
        .to_uint()
        .reinterpret_as_int(),
        lx: typed_read_u64_be_view(template_payload, 10),
        lux: typed_read_u64_be_view(template_payload, 18),
        lcx: typed_read_u64_be_view(template_payload, 26),
        ly: typed_read_u64_be_view(template_payload, 34),
        luy: typed_read_u64_be_view(template_payload, 42),
        lcy: typed_read_u64_be_view(template_payload, 50),
        shape_of_earth: template_payload[58].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[59].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 60),
        scale_factor_major_axis: template_payload[64]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 65),
        scale_factor_minor_axis: template_payload[69]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 70),
        la1: typed_read_u32_be_view(template_payload, 74),
        lo1: typed_read_u32_be_view(template_payload, 78),
        lad: typed_read_u32_be_view(template_payload, 82),
        la2: typed_read_u32_be_view(template_payload, 86),
        lo2: typed_read_u32_be_view(template_payload, 90),
        orientation_of_the_grid: typed_read_u32_be_view(template_payload, 94),
      },
      template_payload.sub(start=98).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_362(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate362, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 92 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.62 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        spectral_representation_type: template_payload[0]
        .to_uint()
        .reinterpret_as_int(),
        n: typed_read_u32_be_view(template_payload, 1),
        m: typed_read_u32_be_view(template_payload, 5),
        bi_fourier_truncation_type: template_payload[9]
        .to_uint()
        .reinterpret_as_int(),
        lx: typed_read_u64_be_view(template_payload, 10),
        lux: typed_read_u64_be_view(template_payload, 18),
        lcx: typed_read_u64_be_view(template_payload, 26),
        ly: typed_read_u64_be_view(template_payload, 34),
        luy: typed_read_u64_be_view(template_payload, 42),
        lcy: typed_read_u64_be_view(template_payload, 50),
        shape_of_earth: template_payload[58].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[59].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 60),
        scale_factor_major_axis: template_payload[64]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 65),
        scale_factor_minor_axis: template_payload[69]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 70),
        la1: typed_read_u32_be_view(template_payload, 74),
        lo1: typed_read_u32_be_view(template_payload, 78),
        resolution_and_component_flags: template_payload[82]
        .to_uint()
        .reinterpret_as_int(),
        lad: typed_read_u32_be_view(template_payload, 83),
        lov: typed_read_u32_be_view(template_payload, 87),
        projection_center_flag: template_payload[91]
        .to_uint()
        .reinterpret_as_int(),
      },
      template_payload.sub(start=92).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_363(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate363, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 107 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.63 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        spectral_representation_type: template_payload[0]
        .to_uint()
        .reinterpret_as_int(),
        n: typed_read_u32_be_view(template_payload, 1),
        m: typed_read_u32_be_view(template_payload, 5),
        bi_fourier_truncation_type: template_payload[9]
        .to_uint()
        .reinterpret_as_int(),
        lx: typed_read_u64_be_view(template_payload, 10),
        lux: typed_read_u64_be_view(template_payload, 18),
        lcx: typed_read_u64_be_view(template_payload, 26),
        ly: typed_read_u64_be_view(template_payload, 34),
        luy: typed_read_u64_be_view(template_payload, 42),
        lcy: typed_read_u64_be_view(template_payload, 50),
        shape_of_earth: template_payload[58].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[59].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 60),
        scale_factor_major_axis: template_payload[64]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 65),
        scale_factor_minor_axis: template_payload[69]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 70),
        la1: typed_read_u32_be_view(template_payload, 74),
        lo1: typed_read_u32_be_view(template_payload, 78),
        lad: typed_read_u32_be_view(template_payload, 82),
        lov: typed_read_u32_be_view(template_payload, 86),
        projection_center_flag: template_payload[90]
        .to_uint()
        .reinterpret_as_int(),
        latin1: typed_read_u32_be_view(template_payload, 91),
        latin2: typed_read_u32_be_view(template_payload, 95),
        latitude_of_southern_pole: typed_read_u32_be_view(template_payload, 99),
        longitude_of_southern_pole: typed_read_u32_be_view(
          template_payload, 103,
        ),
      },
      template_payload.sub(start=107).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_390(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate390, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 66 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.90 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        latitude_of_sub_satellite_point: typed_read_u32_be_view(
          template_payload, 24,
        ),
        longitude_of_sub_satellite_point: typed_read_u32_be_view(
          template_payload, 28,
        ),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        dx: typed_read_u32_be_view(template_payload, 33),
        dy: typed_read_u32_be_view(template_payload, 37),
        xp: typed_read_u32_be_view(template_payload, 41),
        yp: typed_read_u32_be_view(template_payload, 45),
        scanning_mode: template_payload[49].to_uint().reinterpret_as_int(),
        orientation_of_the_grid: typed_read_u32_be_view(template_payload, 50),
        nr: typed_read_u32_be_view(template_payload, 54),
        xo: typed_read_u32_be_view(template_payload, 58),
        yo: typed_read_u32_be_view(template_payload, 62),
      },
      template_payload.sub(start=66).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3100(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3100, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 24 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.100 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        n2: template_payload[0].to_uint().reinterpret_as_int(),
        n3: template_payload[1].to_uint().reinterpret_as_int(),
        ni: typed_read_u16_be_view(template_payload, 2),
        nd: template_payload[4].to_uint().reinterpret_as_int(),
        latitude_of_the_pole_point: typed_read_u32_be_view(template_payload, 5),
        longitude_of_the_pole_point: typed_read_u32_be_view(template_payload, 9),
        longitude_of_the_centre_line_of_first_diamond: typed_read_u32_be_view(
          template_payload, 13,
        ),
        grid_point_position: template_payload[17].to_uint().reinterpret_as_int(),
        numbering_order_of_diamonds: template_payload[18]
        .to_uint()
        .reinterpret_as_int(),
        scanning_mode_for_one_diamond: template_payload[19]
        .to_uint()
        .reinterpret_as_int(),
        nt: typed_read_u32_be_view(template_payload, 20),
      },
      template_payload.sub(start=24).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3101(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3101, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 21 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.101 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        number_of_grid_used: typed_read_u24_be_view(template_payload, 1),
        number_of_grid_in_reference: template_payload[4]
        .to_uint()
        .reinterpret_as_int(),
        uuid_of_horizontal_grid: template_payload
        .sub(start=5, end=21)
        .to_bytes(),
      },
      template_payload.sub(start=21).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3110(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3110, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 43 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.110 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        latitude_of_tangency_point: typed_read_u32_be_view(template_payload, 24),
        longitude_of_tangency_point: typed_read_u32_be_view(
          template_payload, 28,
        ),
        resolution_and_component_flags: template_payload[32]
        .to_uint()
        .reinterpret_as_int(),
        dx: typed_read_u32_be_view(template_payload, 33),
        dy: typed_read_u32_be_view(template_payload, 37),
        projection_center_flag: template_payload[41]
        .to_uint()
        .reinterpret_as_int(),
        scanning_mode: template_payload[42].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=43).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3120(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3120, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 25 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.120 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nr = typed_read_u32_be_view(template_payload, 4)
  let required = 25 + nr * 4
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.120 radial payload too short: expected at least " +
        required.to_string() +
        ", got " +
        template_payload.length().to_string(),
      ),
    )
  }
  let radials : Array[Grib2AzimuthRangeRadial] = []
  for i in 0..<nr {
    let offset = 25 + i * 4
    radials.push({
      starting_azimuth: typed_read_u16_be_view(template_payload, offset),
      azimuthal_width: typed_read_u16_be_view(template_payload, offset + 2),
    })
  }
  Ok(
    (
      {
        nb: typed_read_u32_be_view(template_payload, 0),
        nr,
        la1: typed_read_u32_be_view(template_payload, 8),
        lo1: typed_read_u32_be_view(template_payload, 12),
        dx: typed_read_u32_be_view(template_payload, 16),
        dstart: typed_read_u32_be_view(template_payload, 20),
        scanning_mode: template_payload[24].to_uint().reinterpret_as_int(),
        radials,
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3140(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3140, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 50 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.140 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        nx: typed_read_u32_be_view(template_payload, 16),
        ny: typed_read_u32_be_view(template_payload, 20),
        la1: typed_read_u32_be_view(template_payload, 24),
        lo1: typed_read_u32_be_view(template_payload, 28),
        standard_parallel: typed_read_u32_be_view(template_payload, 32),
        central_longitude: typed_read_u32_be_view(template_payload, 36),
        resolution_and_component_flags: template_payload[40]
        .to_uint()
        .reinterpret_as_int(),
        dx: typed_read_u32_be_view(template_payload, 41),
        dy: typed_read_u32_be_view(template_payload, 45),
        scanning_mode: template_payload[49].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=50).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3150(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3150, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 28 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.150 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        resolution_and_component_flags: template_payload[16]
        .to_uint()
        .reinterpret_as_int(),
        nsides: typed_read_u32_be_view(template_payload, 17),
        lo: typed_read_u32_be_view(template_payload, 21),
        grid_point_position: template_payload[25].to_uint().reinterpret_as_int(),
        numbering_order: template_payload[26].to_uint().reinterpret_as_int(),
        scanning_mode: template_payload[27].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=28).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_3204(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate3204, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 58 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.204 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        ni: typed_read_u32_be_view(template_payload, 16),
        nj: typed_read_u32_be_view(template_payload, 20),
        reserved_octets_39_54: template_payload.sub(start=24, end=40).to_bytes(),
        resolution_and_component_flags: template_payload[40]
        .to_uint()
        .reinterpret_as_int(),
        reserved_octets_56_71: template_payload.sub(start=41, end=57).to_bytes(),
        scanning_mode: template_payload[57].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=58).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_31000(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate31000, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 52 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.1000 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nc = typed_read_u16_be_view(template_payload, 50)
  let required = 52 + nc * 4
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.1000 expected at least " +
        required.to_string() +
        " octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        number_of_horizontal_points: typed_read_u32_be_view(
          template_payload, 16,
        ),
        basic_angle: typed_read_u32_be_view(template_payload, 20),
        subdivisions_of_basic_angle: typed_read_u32_be_view(
          template_payload, 24,
        ),
        la1: typed_read_u32_be_view(template_payload, 28),
        lo1: typed_read_u32_be_view(template_payload, 32),
        scanning_mode: template_payload[36].to_uint().reinterpret_as_int(),
        la2: typed_read_u32_be_view(template_payload, 37),
        lo2: typed_read_u32_be_view(template_payload, 41),
        type_of_horizontal_line: template_payload[45]
        .to_uint()
        .reinterpret_as_int(),
        number_of_vertical_points: typed_read_u16_be_view(template_payload, 46),
        physical_meaning_of_vertical_coordinate: template_payload[48]
        .to_uint()
        .reinterpret_as_int(),
        vertical_dimension_coordinate_values_definition: template_payload[49]
        .to_uint()
        .reinterpret_as_int(),
        nc,
        vertical_coordinate_values_raw: template_payload
        .sub(start=52, end=required)
        .to_bytes(),
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_31100(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate31100, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 68 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.1100 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        shape_of_earth: template_payload[0].to_uint().reinterpret_as_int(),
        scale_factor_radius: template_payload[1].to_uint().reinterpret_as_int(),
        scaled_value_radius: typed_read_u32_be_view(template_payload, 2),
        scale_factor_major_axis: template_payload[6]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_major_axis: typed_read_u32_be_view(template_payload, 7),
        scale_factor_minor_axis: template_payload[11]
        .to_uint()
        .reinterpret_as_int(),
        scaled_value_minor_axis: typed_read_u32_be_view(template_payload, 12),
        number_of_horizontal_points: typed_read_u32_be_view(
          template_payload, 16,
        ),
        basic_angle: typed_read_u32_be_view(template_payload, 20),
        subdivisions_of_basic_angle: typed_read_u32_be_view(
          template_payload, 24,
        ),
        la1: typed_read_u32_be_view(template_payload, 28),
        lo1: typed_read_u32_be_view(template_payload, 32),
        scanning_mode: template_payload[36].to_uint().reinterpret_as_int(),
        la2: typed_read_u32_be_view(template_payload, 37),
        lo2: typed_read_u32_be_view(template_payload, 41),
        type_of_horizontal_line: template_payload[45]
        .to_uint()
        .reinterpret_as_int(),
        nt: typed_read_u32_be_view(template_payload, 46),
        unit_of_offset_from_reference_time: template_payload[50]
        .to_uint()
        .reinterpret_as_int(),
        offset_from_reference_of_first_time: typed_read_u32_be_view(
          template_payload, 51,
        ),
        type_of_time_increment: template_payload[55]
        .to_uint()
        .reinterpret_as_int(),
        unit_of_time_increment: template_payload[56]
        .to_uint()
        .reinterpret_as_int(),
        time_increment: typed_read_u32_be_view(template_payload, 57),
        last_year: typed_read_u16_be_view(template_payload, 61),
        last_month: template_payload[63].to_uint().reinterpret_as_int(),
        last_day: template_payload[64].to_uint().reinterpret_as_int(),
        last_hour: template_payload[65].to_uint().reinterpret_as_int(),
        last_minute: template_payload[66].to_uint().reinterpret_as_int(),
        last_second: template_payload[67].to_uint().reinterpret_as_int(),
      },
      template_payload.sub(start=68).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_31200(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate31200, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 28 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.1200 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let nc = typed_read_u16_be_view(template_payload, 26)
  let required = 28 + nc * 4
  if template_payload.length() < required {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.1200 expected at least " +
        required.to_string() +
        " octets, got " +
        template_payload.length().to_string(),
      ),
    )
  }
  Ok(
    (
      {
        nt: typed_read_u32_be_view(template_payload, 0),
        unit_of_offset_from_reference_time: template_payload[4]
        .to_uint()
        .reinterpret_as_int(),
        offset_from_reference_of_first_time: typed_read_u32_be_view(
          template_payload, 5,
        ),
        type_of_time_increment: template_payload[9]
        .to_uint()
        .reinterpret_as_int(),
        unit_of_time_increment: template_payload[10]
        .to_uint()
        .reinterpret_as_int(),
        time_increment: typed_read_u32_be_view(template_payload, 11),
        last_year: typed_read_u16_be_view(template_payload, 15),
        last_month: template_payload[17].to_uint().reinterpret_as_int(),
        last_day: template_payload[18].to_uint().reinterpret_as_int(),
        last_hour: template_payload[19].to_uint().reinterpret_as_int(),
        last_minute: template_payload[20].to_uint().reinterpret_as_int(),
        last_second: template_payload[21].to_uint().reinterpret_as_int(),
        number_of_vertical_points: typed_read_u16_be_view(template_payload, 22),
        physical_meaning_of_vertical_coordinate: template_payload[24]
        .to_uint()
        .reinterpret_as_int(),
        vertical_dimension_coordinate_values_definition: template_payload[25]
        .to_uint()
        .reinterpret_as_int(),
        nc,
        vertical_coordinate_values_raw: template_payload
        .sub(start=28, end=required)
        .to_bytes(),
      },
      template_payload.sub(start=required).to_bytes(),
    ),
  )
}

///|
fn typed_decode_template_332768(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate332768, Bytes), Grib2SectionCodecError] {
  match typed_decode_template_30(template_payload) {
    Ok((base, optional_points_raw)) => Ok(({ base, }, optional_points_raw))
    Err(error) => Err(error)
  }
}

///|
fn typed_decode_template_332769(
  template_payload : BytesView,
) -> Result[(Grib2GridTemplate332769, Bytes), Grib2SectionCodecError] {
  if template_payload.length() < 66 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "template 3.32769 too short: " + template_payload.length().to_string(),
      ),
    )
  }
  let base = match
    typed_decode_latlon_base(template_payload, "template 3.32769") {
    Ok(base) => base
    Err(error) => return Err(error)
  }
  Ok(
    (
      {
        base,
        latitude_of_grid_point_ni_nj: typed_read_u32_be_view(
          template_payload, 58,
        ),
        longitude_of_grid_point_ni_nj: typed_read_u32_be_view(
          template_payload, 62,
        ),
      },
      template_payload.sub(start=66).to_bytes(),
    ),
  )
}
