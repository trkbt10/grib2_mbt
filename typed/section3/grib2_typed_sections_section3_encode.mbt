///|
fn typed_encode_template_30(template : Grib2GridTemplate30) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  typed_push_u32_be(out, template.di)
  typed_push_u32_be(out, template.dj)
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_31(template : Grib2GridTemplate31) -> Bytes {
  let out = typed_encode_template_30(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_32(template : Grib2GridTemplate32) -> Bytes {
  let out = typed_encode_template_30(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_33(template : Grib2GridTemplate33) -> Bytes {
  let out = typed_encode_template_30(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_34(template : Grib2GridTemplate34) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  out.push(template.resolution_and_component_flags.to_byte())
  out.push(template.scanning_mode.to_byte())
  for value in template.longitude_list {
    typed_push_u32_be(out, value)
  }
  for value in template.latitude_list {
    typed_push_u32_be(out, value)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_35(template : Grib2GridTemplate35) -> Bytes {
  let base = template.base
  let out : Array[Byte] = []
  out.push(base.shape_of_earth.to_byte())
  out.push(base.scale_factor_radius.to_byte())
  typed_push_u32_be(out, base.scaled_value_radius)
  out.push(base.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, base.scaled_value_major_axis)
  out.push(base.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, base.scaled_value_minor_axis)
  typed_push_u32_be(out, base.ni)
  typed_push_u32_be(out, base.nj)
  typed_push_u32_be(out, base.basic_angle)
  typed_push_u32_be(out, base.subdivisions_of_basic_angle)
  out.push(base.resolution_and_component_flags.to_byte())
  out.push(base.scanning_mode.to_byte())
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  for value in base.longitude_list {
    typed_push_u32_be(out, value)
  }
  for value in base.latitude_list {
    typed_push_u32_be(out, value)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_310(template : Grib2GridTemplate310) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.orientation_of_the_grid)
  typed_push_u32_be(out, template.di)
  typed_push_u32_be(out, template.dj)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_312(template : Grib2GridTemplate312) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.lar)
  typed_push_u32_be(out, template.lor)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.m)
  typed_push_u32_be(out, template.xr)
  typed_push_u32_be(out, template.yr)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.di)
  typed_push_u32_be(out, template.dj)
  typed_push_u32_be(out, template.x1)
  typed_push_u32_be(out, template.y1)
  typed_push_u32_be(out, template.x2)
  typed_push_u32_be(out, template.y2)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_313(template : Grib2GridTemplate313) -> Bytes {
  let out = typed_encode_template_310(template.base).to_array()
  typed_push_u32_be(out, template.nux)
  typed_push_u32_be(out, template.ncx)
  typed_push_u32_be(out, template.nuy)
  typed_push_u32_be(out, template.ncy)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_320(template : Grib2GridTemplate320) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.lov)
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dy)
  out.push(template.projection_center_flag.to_byte())
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_323(template : Grib2GridTemplate323) -> Bytes {
  let out = typed_encode_template_320(template.base).to_array()
  typed_push_u32_be(out, template.nux)
  typed_push_u32_be(out, template.ncx)
  typed_push_u32_be(out, template.nuy)
  typed_push_u32_be(out, template.ncy)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_330(template : Grib2GridTemplate330) -> Bytes {
  let out = typed_encode_template_320(template.base).to_array()
  typed_push_u32_be(out, template.latin1)
  typed_push_u32_be(out, template.latin2)
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_331(template : Grib2GridTemplate331) -> Bytes {
  typed_encode_template_330(template.base)
}

///|
fn typed_encode_template_333(template : Grib2GridTemplate333) -> Bytes {
  let out = typed_encode_template_330(template.base).to_array()
  typed_push_u32_be(out, template.nux)
  typed_push_u32_be(out, template.ncx)
  typed_push_u32_be(out, template.nuy)
  typed_push_u32_be(out, template.ncy)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_340(template : Grib2GridTemplate340) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  typed_push_u32_be(out, template.di)
  typed_push_u32_be(out, template.n)
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_341(template : Grib2GridTemplate341) -> Bytes {
  let out = typed_encode_template_340(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_342(template : Grib2GridTemplate342) -> Bytes {
  let out = typed_encode_template_340(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_343(template : Grib2GridTemplate343) -> Bytes {
  let out = typed_encode_template_340(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_350(template : Grib2GridTemplate350) -> Bytes {
  let out : Array[Byte] = []
  typed_push_u32_be(out, template.j)
  typed_push_u32_be(out, template.k)
  typed_push_u32_be(out, template.m)
  out.push(template.representation_type.to_byte())
  out.push(template.representation_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_351(template : Grib2GridTemplate351) -> Bytes {
  let out = typed_encode_template_350(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_352(template : Grib2GridTemplate352) -> Bytes {
  let out = typed_encode_template_350(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_353(template : Grib2GridTemplate353) -> Bytes {
  let out = typed_encode_template_350(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  typed_push_u32_be(out, template.latitude_of_stretching_pole)
  typed_push_u32_be(out, template.longitude_of_stretching_pole)
  typed_push_u32_be(out, template.stretching_factor)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_360(template : Grib2GridTemplate360) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.nc)
  typed_push_u32_be(out, template.xshift)
  typed_push_u32_be(out, template.yshift)
  out.push(template.face_number.to_byte())
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  typed_push_u32_be(out, template.angle_of_rotation)
  typed_push_u32_be(out, template.stretching_factor)
  typed_push_u32_be(out, template.gnomonic_grid_spacing_parameter)
  out.push(template.resolution_and_component_flags.to_byte())
  out.push(template.scanning_and_staggering_flags.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_361(template : Grib2GridTemplate361) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.spectral_representation_type.to_byte())
  typed_push_u32_be(out, template.n)
  typed_push_u32_be(out, template.m)
  out.push(template.bi_fourier_truncation_type.to_byte())
  typed_push_u64_be(out, template.lx)
  typed_push_u64_be(out, template.lux)
  typed_push_u64_be(out, template.lcx)
  typed_push_u64_be(out, template.ly)
  typed_push_u64_be(out, template.luy)
  typed_push_u64_be(out, template.lcy)
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  typed_push_u32_be(out, template.orientation_of_the_grid)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_362(template : Grib2GridTemplate362) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.spectral_representation_type.to_byte())
  typed_push_u32_be(out, template.n)
  typed_push_u32_be(out, template.m)
  out.push(template.bi_fourier_truncation_type.to_byte())
  typed_push_u64_be(out, template.lx)
  typed_push_u64_be(out, template.lux)
  typed_push_u64_be(out, template.lcx)
  typed_push_u64_be(out, template.ly)
  typed_push_u64_be(out, template.luy)
  typed_push_u64_be(out, template.lcy)
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.lov)
  out.push(template.projection_center_flag.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_363(template : Grib2GridTemplate363) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.spectral_representation_type.to_byte())
  typed_push_u32_be(out, template.n)
  typed_push_u32_be(out, template.m)
  out.push(template.bi_fourier_truncation_type.to_byte())
  typed_push_u64_be(out, template.lx)
  typed_push_u64_be(out, template.lux)
  typed_push_u64_be(out, template.lcx)
  typed_push_u64_be(out, template.ly)
  typed_push_u64_be(out, template.luy)
  typed_push_u64_be(out, template.lcy)
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  typed_push_u32_be(out, template.lad)
  typed_push_u32_be(out, template.lov)
  out.push(template.projection_center_flag.to_byte())
  typed_push_u32_be(out, template.latin1)
  typed_push_u32_be(out, template.latin2)
  typed_push_u32_be(out, template.latitude_of_southern_pole)
  typed_push_u32_be(out, template.longitude_of_southern_pole)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_390(template : Grib2GridTemplate390) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.latitude_of_sub_satellite_point)
  typed_push_u32_be(out, template.longitude_of_sub_satellite_point)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dy)
  typed_push_u32_be(out, template.xp)
  typed_push_u32_be(out, template.yp)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.orientation_of_the_grid)
  typed_push_u32_be(out, template.nr)
  typed_push_u32_be(out, template.xo)
  typed_push_u32_be(out, template.yo)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3100(template : Grib2GridTemplate3100) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.n2.to_byte())
  out.push(template.n3.to_byte())
  typed_push_u16_be(out, template.ni)
  out.push(template.nd.to_byte())
  typed_push_u32_be(out, template.latitude_of_the_pole_point)
  typed_push_u32_be(out, template.longitude_of_the_pole_point)
  typed_push_u32_be(out, template.longitude_of_the_centre_line_of_first_diamond)
  out.push(template.grid_point_position.to_byte())
  out.push(template.numbering_order_of_diamonds.to_byte())
  out.push(template.scanning_mode_for_one_diamond.to_byte())
  typed_push_u32_be(out, template.nt)
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3101(template : Grib2GridTemplate3101) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  typed_push_u24_be(out, template.number_of_grid_used)
  out.push(template.number_of_grid_in_reference.to_byte())
  for b in template.uuid_of_horizontal_grid {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3110(template : Grib2GridTemplate3110) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.latitude_of_tangency_point)
  typed_push_u32_be(out, template.longitude_of_tangency_point)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dy)
  out.push(template.projection_center_flag.to_byte())
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3120(template : Grib2GridTemplate3120) -> Bytes {
  let out : Array[Byte] = []
  typed_push_u32_be(out, template.nb)
  typed_push_u32_be(out, template.nr)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dstart)
  out.push(template.scanning_mode.to_byte())
  for radial in template.radials {
    typed_push_u16_be(out, radial.starting_azimuth)
    typed_push_u16_be(out, radial.azimuthal_width)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3140(template : Grib2GridTemplate3140) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.nx)
  typed_push_u32_be(out, template.ny)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  typed_push_u32_be(out, template.standard_parallel)
  typed_push_u32_be(out, template.central_longitude)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.dx)
  typed_push_u32_be(out, template.dy)
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3150(template : Grib2GridTemplate3150) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  out.push(template.resolution_and_component_flags.to_byte())
  typed_push_u32_be(out, template.nsides)
  typed_push_u32_be(out, template.lo)
  out.push(template.grid_point_position.to_byte())
  out.push(template.numbering_order.to_byte())
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_3204(template : Grib2GridTemplate3204) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.ni)
  typed_push_u32_be(out, template.nj)
  for b in template.reserved_octets_39_54 {
    out.push(b)
  }
  out.push(template.resolution_and_component_flags.to_byte())
  for b in template.reserved_octets_56_71 {
    out.push(b)
  }
  out.push(template.scanning_mode.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_31000(template : Grib2GridTemplate31000) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.number_of_horizontal_points)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  out.push(template.type_of_horizontal_line.to_byte())
  typed_push_u16_be(out, template.number_of_vertical_points)
  out.push(template.physical_meaning_of_vertical_coordinate.to_byte())
  out.push(template.vertical_dimension_coordinate_values_definition.to_byte())
  typed_push_u16_be(out, template.nc)
  for b in template.vertical_coordinate_values_raw {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_31100(template : Grib2GridTemplate31100) -> Bytes {
  let out : Array[Byte] = []
  out.push(template.shape_of_earth.to_byte())
  out.push(template.scale_factor_radius.to_byte())
  typed_push_u32_be(out, template.scaled_value_radius)
  out.push(template.scale_factor_major_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_major_axis)
  out.push(template.scale_factor_minor_axis.to_byte())
  typed_push_u32_be(out, template.scaled_value_minor_axis)
  typed_push_u32_be(out, template.number_of_horizontal_points)
  typed_push_u32_be(out, template.basic_angle)
  typed_push_u32_be(out, template.subdivisions_of_basic_angle)
  typed_push_u32_be(out, template.la1)
  typed_push_u32_be(out, template.lo1)
  out.push(template.scanning_mode.to_byte())
  typed_push_u32_be(out, template.la2)
  typed_push_u32_be(out, template.lo2)
  out.push(template.type_of_horizontal_line.to_byte())
  typed_push_u32_be(out, template.nt)
  out.push(template.unit_of_offset_from_reference_time.to_byte())
  typed_push_u32_be(out, template.offset_from_reference_of_first_time)
  out.push(template.type_of_time_increment.to_byte())
  out.push(template.unit_of_time_increment.to_byte())
  typed_push_u32_be(out, template.time_increment)
  typed_push_u16_be(out, template.last_year)
  out.push(template.last_month.to_byte())
  out.push(template.last_day.to_byte())
  out.push(template.last_hour.to_byte())
  out.push(template.last_minute.to_byte())
  out.push(template.last_second.to_byte())
  Bytes::from_array(out)
}

///|
fn typed_encode_template_31200(template : Grib2GridTemplate31200) -> Bytes {
  let out : Array[Byte] = []
  typed_push_u32_be(out, template.nt)
  out.push(template.unit_of_offset_from_reference_time.to_byte())
  typed_push_u32_be(out, template.offset_from_reference_of_first_time)
  out.push(template.type_of_time_increment.to_byte())
  out.push(template.unit_of_time_increment.to_byte())
  typed_push_u32_be(out, template.time_increment)
  typed_push_u16_be(out, template.last_year)
  out.push(template.last_month.to_byte())
  out.push(template.last_day.to_byte())
  out.push(template.last_hour.to_byte())
  out.push(template.last_minute.to_byte())
  out.push(template.last_second.to_byte())
  typed_push_u16_be(out, template.number_of_vertical_points)
  out.push(template.physical_meaning_of_vertical_coordinate.to_byte())
  out.push(template.vertical_dimension_coordinate_values_definition.to_byte())
  typed_push_u16_be(out, template.nc)
  for b in template.vertical_coordinate_values_raw {
    out.push(b)
  }
  Bytes::from_array(out)
}

///|
fn typed_encode_template_332768(template : Grib2GridTemplate332768) -> Bytes {
  typed_encode_template_30(template.base)
}

///|
fn typed_encode_template_332769(template : Grib2GridTemplate332769) -> Bytes {
  let out = typed_encode_template_30(template.base).to_array()
  typed_push_u32_be(out, template.latitude_of_grid_point_ni_nj)
  typed_push_u32_be(out, template.longitude_of_grid_point_ni_nj)
  Bytes::from_array(out)
}
