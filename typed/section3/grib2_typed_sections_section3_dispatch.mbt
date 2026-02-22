///|
pub fn decode_section3_bytes(
  section : Bytes,
) -> Result[Grib2Section3Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 3) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 14 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "section3 too short: " + section.length().to_string(),
      ),
    )
  }
  let template_number = typed_read_u16_be(section, 12)
  let template_payload = section.sub(start=14)
  let (template, optional_points_raw) = if template_number == 0 {
    match typed_decode_template_30(template_payload) {
      Ok((template_30, optional_points_raw)) =>
        (GridTemplate30(template_30), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 1 {
    match typed_decode_template_31(template_payload) {
      Ok((template_31, optional_points_raw)) =>
        (GridTemplate31(template_31), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 2 {
    match typed_decode_template_32(template_payload) {
      Ok((template_32, optional_points_raw)) =>
        (GridTemplate32(template_32), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 3 {
    match typed_decode_template_33(template_payload) {
      Ok((template_33, optional_points_raw)) =>
        (GridTemplate33(template_33), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 4 {
    match typed_decode_template_34(template_payload) {
      Ok((template_34, optional_points_raw)) =>
        (GridTemplate34(template_34), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 5 {
    match typed_decode_template_35(template_payload) {
      Ok((template_35, optional_points_raw)) =>
        (GridTemplate35(template_35), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 10 {
    match typed_decode_template_310(template_payload) {
      Ok((template_310, optional_points_raw)) =>
        (GridTemplate310(template_310), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 12 {
    match typed_decode_template_312(template_payload) {
      Ok((template_312, optional_points_raw)) =>
        (GridTemplate312(template_312), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 13 {
    match typed_decode_template_313(template_payload) {
      Ok((template_313, optional_points_raw)) =>
        (GridTemplate313(template_313), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 20 {
    match typed_decode_template_320(template_payload) {
      Ok((template_320, optional_points_raw)) =>
        (GridTemplate320(template_320), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 23 {
    match typed_decode_template_323(template_payload) {
      Ok((template_323, optional_points_raw)) =>
        (GridTemplate323(template_323), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 30 {
    match typed_decode_template_330(template_payload) {
      Ok((template_330, optional_points_raw)) =>
        (GridTemplate330(template_330), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 31 {
    match typed_decode_template_331(template_payload) {
      Ok((template_331, optional_points_raw)) =>
        (GridTemplate331(template_331), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 33 {
    match typed_decode_template_333(template_payload) {
      Ok((template_333, optional_points_raw)) =>
        (GridTemplate333(template_333), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 40 {
    match typed_decode_template_340(template_payload) {
      Ok((template_340, optional_points_raw)) =>
        (GridTemplate340(template_340), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 41 {
    match typed_decode_template_341(template_payload) {
      Ok((template_341, optional_points_raw)) =>
        (GridTemplate341(template_341), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 42 {
    match typed_decode_template_342(template_payload) {
      Ok((template_342, optional_points_raw)) =>
        (GridTemplate342(template_342), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 43 {
    match typed_decode_template_343(template_payload) {
      Ok((template_343, optional_points_raw)) =>
        (GridTemplate343(template_343), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 50 {
    match typed_decode_template_350(template_payload) {
      Ok((template_350, optional_points_raw)) =>
        (GridTemplate350(template_350), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 51 {
    match typed_decode_template_351(template_payload) {
      Ok((template_351, optional_points_raw)) =>
        (GridTemplate351(template_351), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 52 {
    match typed_decode_template_352(template_payload) {
      Ok((template_352, optional_points_raw)) =>
        (GridTemplate352(template_352), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 53 {
    match typed_decode_template_353(template_payload) {
      Ok((template_353, optional_points_raw)) =>
        (GridTemplate353(template_353), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 60 {
    match typed_decode_template_360(template_payload) {
      Ok((template_360, optional_points_raw)) =>
        (GridTemplate360(template_360), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 61 {
    match typed_decode_template_361(template_payload) {
      Ok((template_361, optional_points_raw)) =>
        (GridTemplate361(template_361), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 62 {
    match typed_decode_template_362(template_payload) {
      Ok((template_362, optional_points_raw)) =>
        (GridTemplate362(template_362), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 63 {
    match typed_decode_template_363(template_payload) {
      Ok((template_363, optional_points_raw)) =>
        (GridTemplate363(template_363), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 90 {
    match typed_decode_template_390(template_payload) {
      Ok((template_390, optional_points_raw)) =>
        (GridTemplate390(template_390), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 100 {
    match typed_decode_template_3100(template_payload) {
      Ok((template_3100, optional_points_raw)) =>
        (GridTemplate3100(template_3100), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 101 {
    match typed_decode_template_3101(template_payload) {
      Ok((template_3101, optional_points_raw)) =>
        (GridTemplate3101(template_3101), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 110 {
    match typed_decode_template_3110(template_payload) {
      Ok((template_3110, optional_points_raw)) =>
        (GridTemplate3110(template_3110), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 120 {
    match typed_decode_template_3120(template_payload) {
      Ok((template_3120, optional_points_raw)) =>
        (GridTemplate3120(template_3120), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 140 {
    match typed_decode_template_3140(template_payload) {
      Ok((template_3140, optional_points_raw)) =>
        (GridTemplate3140(template_3140), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 150 {
    match typed_decode_template_3150(template_payload) {
      Ok((template_3150, optional_points_raw)) =>
        (GridTemplate3150(template_3150), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 204 {
    match typed_decode_template_3204(template_payload) {
      Ok((template_3204, optional_points_raw)) =>
        (GridTemplate3204(template_3204), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 1000 {
    match typed_decode_template_31000(template_payload) {
      Ok((template_31000, optional_points_raw)) =>
        (GridTemplate31000(template_31000), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 1100 {
    match typed_decode_template_31100(template_payload) {
      Ok((template_31100, optional_points_raw)) =>
        (GridTemplate31100(template_31100), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 1200 {
    match typed_decode_template_31200(template_payload) {
      Ok((template_31200, optional_points_raw)) =>
        (GridTemplate31200(template_31200), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 32768 {
    match typed_decode_template_332768(template_payload) {
      Ok((template_332768, optional_points_raw)) =>
        (GridTemplate332768(template_332768), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else if template_number == 32769 {
    match typed_decode_template_332769(template_payload) {
      Ok((template_332769, optional_points_raw)) =>
        (GridTemplate332769(template_332769), optional_points_raw)
      Err(error) => return Err(error)
    }
  } else {
    (GridTemplateUnknown(template_number, template_payload.to_bytes()), b"")
  }
  Ok({
    source_of_grid_definition: section[5].to_uint().reinterpret_as_int(),
    number_of_data_points: typed_read_u32_be(section, 6),
    optional_points_octet_count: section[10].to_uint().reinterpret_as_int(),
    optional_points_interpretation: section[11].to_uint().reinterpret_as_int(),
    template,
    optional_points_raw,
  })
}

///|
pub fn encode_section3_bytes(section : Grib2Section3Decoded) -> Bytes {
  let payload : Array[Byte] = []
  payload.push(section.source_of_grid_definition.to_byte())
  typed_push_u32_be(payload, section.number_of_data_points)
  payload.push(section.optional_points_octet_count.to_byte())
  payload.push(section.optional_points_interpretation.to_byte())
  let (template_number, template_raw) = match section.template {
    GridTemplate30(template_30) => (0, typed_encode_template_30(template_30))
    GridTemplate31(template_31) => (1, typed_encode_template_31(template_31))
    GridTemplate32(template_32) => (2, typed_encode_template_32(template_32))
    GridTemplate33(template_33) => (3, typed_encode_template_33(template_33))
    GridTemplate34(template_34) => (4, typed_encode_template_34(template_34))
    GridTemplate35(template_35) => (5, typed_encode_template_35(template_35))
    GridTemplate310(template_310) =>
      (10, typed_encode_template_310(template_310))
    GridTemplate312(template_312) =>
      (12, typed_encode_template_312(template_312))
    GridTemplate313(template_313) =>
      (13, typed_encode_template_313(template_313))
    GridTemplate320(template_320) =>
      (20, typed_encode_template_320(template_320))
    GridTemplate323(template_323) =>
      (23, typed_encode_template_323(template_323))
    GridTemplate330(template_330) =>
      (30, typed_encode_template_330(template_330))
    GridTemplate331(template_331) =>
      (31, typed_encode_template_331(template_331))
    GridTemplate333(template_333) =>
      (33, typed_encode_template_333(template_333))
    GridTemplate340(template_340) =>
      (40, typed_encode_template_340(template_340))
    GridTemplate341(template_341) =>
      (41, typed_encode_template_341(template_341))
    GridTemplate342(template_342) =>
      (42, typed_encode_template_342(template_342))
    GridTemplate343(template_343) =>
      (43, typed_encode_template_343(template_343))
    GridTemplate350(template_350) =>
      (50, typed_encode_template_350(template_350))
    GridTemplate351(template_351) =>
      (51, typed_encode_template_351(template_351))
    GridTemplate352(template_352) =>
      (52, typed_encode_template_352(template_352))
    GridTemplate353(template_353) =>
      (53, typed_encode_template_353(template_353))
    GridTemplate360(template_360) =>
      (60, typed_encode_template_360(template_360))
    GridTemplate361(template_361) =>
      (61, typed_encode_template_361(template_361))
    GridTemplate362(template_362) =>
      (62, typed_encode_template_362(template_362))
    GridTemplate363(template_363) =>
      (63, typed_encode_template_363(template_363))
    GridTemplate390(template_390) =>
      (90, typed_encode_template_390(template_390))
    GridTemplate3100(template_3100) =>
      (100, typed_encode_template_3100(template_3100))
    GridTemplate3101(template_3101) =>
      (101, typed_encode_template_3101(template_3101))
    GridTemplate3110(template_3110) =>
      (110, typed_encode_template_3110(template_3110))
    GridTemplate3120(template_3120) =>
      (120, typed_encode_template_3120(template_3120))
    GridTemplate3140(template_3140) =>
      (140, typed_encode_template_3140(template_3140))
    GridTemplate3150(template_3150) =>
      (150, typed_encode_template_3150(template_3150))
    GridTemplate3204(template_3204) =>
      (204, typed_encode_template_3204(template_3204))
    GridTemplate31000(template_31000) =>
      (1000, typed_encode_template_31000(template_31000))
    GridTemplate31100(template_31100) =>
      (1100, typed_encode_template_31100(template_31100))
    GridTemplate31200(template_31200) =>
      (1200, typed_encode_template_31200(template_31200))
    GridTemplate332768(template_332768) =>
      (32768, typed_encode_template_332768(template_332768))
    GridTemplate332769(template_332769) =>
      (32769, typed_encode_template_332769(template_332769))
    GridTemplateUnknown(template_number, raw) => (template_number, raw)
  }
  typed_push_u16_be(payload, template_number)
  for b in template_raw {
    payload.push(b)
  }
  for b in section.optional_points_raw {
    payload.push(b)
  }
  typed_build_section(3, Bytes::from_array(payload))
}
