///|
pub fn decode_section4_bytes(
  section : Bytes,
) -> Result[Grib2Section4Decoded, Grib2SectionCodecError] {
  match typed_validate_section_header(section, 4) {
    Ok(_) => ()
    Err(error) => return Err(error)
  }
  if section.length() < 9 {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "section4 too short: " + section.length().to_string(),
      ),
    )
  }
  let number_of_coordinate_values = typed_read_u16_be(section, 5)
  let template_number = typed_read_u16_be(section, 7)
  let payload = section.sub(start=9)
  let coord_len = number_of_coordinate_values * 4
  if payload.length() < coord_len {
    return Err(
      @section1.Grib2SectionCodecError::InvalidSectionLength(
        "section4 coordinate payload too short: expected at least " +
        coord_len.to_string() +
        ", got " +
        payload.length().to_string(),
      ),
    )
  }
  let template_len = payload.length() - coord_len
  let template_payload = payload.sub(end=template_len)
  let coordinate_values_raw = payload.sub(start=template_len).to_bytes()
  let template = if template_number == 0 {
    match typed_decode_template_40(template_payload) {
      Ok(template_40) => ProductTemplate40(template_40)
      Err(error) => return Err(error)
    }
  } else if template_number == 1 {
    match typed_decode_template_41(template_payload) {
      Ok(template_41) => ProductTemplate41(template_41)
      Err(error) => return Err(error)
    }
  } else if template_number == 2 {
    match typed_decode_template_42(template_payload) {
      Ok(template_42) => ProductTemplate42(template_42)
      Err(error) => return Err(error)
    }
  } else if template_number == 3 {
    match typed_decode_template_43(template_payload) {
      Ok(template_43) => ProductTemplate43(template_43)
      Err(error) => return Err(error)
    }
  } else if template_number == 4 {
    match typed_decode_template_44(template_payload) {
      Ok(template_44) => ProductTemplate44(template_44)
      Err(error) => return Err(error)
    }
  } else if template_number == 5 {
    match typed_decode_template_45(template_payload) {
      Ok(template_45) => ProductTemplate45(template_45)
      Err(error) => return Err(error)
    }
  } else if template_number == 6 {
    match typed_decode_template_46(template_payload) {
      Ok(template_46) => ProductTemplate46(template_46)
      Err(error) => return Err(error)
    }
  } else if template_number == 7 {
    match typed_decode_template_47(template_payload) {
      Ok(template_47) => ProductTemplate47(template_47)
      Err(error) => return Err(error)
    }
  } else if template_number == 8 {
    match typed_decode_template_48(template_payload) {
      Ok(template_48) => ProductTemplate48(template_48)
      Err(error) => return Err(error)
    }
  } else if template_number == 9 {
    match typed_decode_template_49(template_payload) {
      Ok(template_49) => ProductTemplate49(template_49)
      Err(error) => return Err(error)
    }
  } else if template_number == 10 {
    match typed_decode_template_410(template_payload) {
      Ok(template_410) => ProductTemplate410(template_410)
      Err(error) => return Err(error)
    }
  } else if template_number == 11 {
    match typed_decode_template_411(template_payload) {
      Ok(template_411) => ProductTemplate411(template_411)
      Err(error) => return Err(error)
    }
  } else if template_number == 12 {
    match typed_decode_template_412(template_payload) {
      Ok(template_412) => ProductTemplate412(template_412)
      Err(error) => return Err(error)
    }
  } else if template_number == 13 {
    match typed_decode_template_413(template_payload) {
      Ok(template_413) => ProductTemplate413(template_413)
      Err(error) => return Err(error)
    }
  } else if template_number == 14 {
    match typed_decode_template_414(template_payload) {
      Ok(template_414) => ProductTemplate414(template_414)
      Err(error) => return Err(error)
    }
  } else if template_number == 15 {
    match typed_decode_template_415(template_payload) {
      Ok(template_415) => ProductTemplate415(template_415)
      Err(error) => return Err(error)
    }
  } else if template_number == 20 {
    match typed_decode_template_420(template_payload) {
      Ok(template_420) => ProductTemplate420(template_420)
      Err(error) => return Err(error)
    }
  } else if template_number == 30 {
    match typed_decode_template_430(template_payload) {
      Ok(template_430) => ProductTemplate430(template_430)
      Err(error) => return Err(error)
    }
  } else if template_number == 31 {
    match typed_decode_template_431(template_payload) {
      Ok(template_431) => ProductTemplate431(template_431)
      Err(error) => return Err(error)
    }
  } else if template_number == 32 {
    match typed_decode_template_432(template_payload) {
      Ok(template_432) => ProductTemplate432(template_432)
      Err(error) => return Err(error)
    }
  } else if template_number == 33 {
    match typed_decode_template_433(template_payload) {
      Ok(template_433) => ProductTemplate433(template_433)
      Err(error) => return Err(error)
    }
  } else if template_number == 34 {
    match typed_decode_template_434(template_payload) {
      Ok(template_434) => ProductTemplate434(template_434)
      Err(error) => return Err(error)
    }
  } else if template_number == 35 {
    match typed_decode_template_435(template_payload) {
      Ok(template_435) => ProductTemplate435(template_435)
      Err(error) => return Err(error)
    }
  } else if template_number == 40 {
    match typed_decode_template_440(template_payload) {
      Ok(template_440) => ProductTemplate440(template_440)
      Err(error) => return Err(error)
    }
  } else if template_number == 41 {
    match typed_decode_template_441(template_payload) {
      Ok(template_441) => ProductTemplate441(template_441)
      Err(error) => return Err(error)
    }
  } else if template_number == 42 {
    match typed_decode_template_442(template_payload) {
      Ok(template_442) => ProductTemplate442(template_442)
      Err(error) => return Err(error)
    }
  } else if template_number == 43 {
    match typed_decode_template_443(template_payload) {
      Ok(template_443) => ProductTemplate443(template_443)
      Err(error) => return Err(error)
    }
  } else if template_number == 44 {
    match typed_decode_template_444(template_payload) {
      Ok(template_444) => ProductTemplate444(template_444)
      Err(error) => return Err(error)
    }
  } else if template_number == 45 {
    match typed_decode_template_445(template_payload) {
      Ok(template_445) => ProductTemplate445(template_445)
      Err(error) => return Err(error)
    }
  } else if template_number == 46 {
    match typed_decode_template_446(template_payload) {
      Ok(template_446) => ProductTemplate446(template_446)
      Err(error) => return Err(error)
    }
  } else if template_number == 47 {
    match typed_decode_template_447(template_payload) {
      Ok(template_447) => ProductTemplate447(template_447)
      Err(error) => return Err(error)
    }
  } else if template_number == 48 {
    match typed_decode_template_448(template_payload) {
      Ok(template_448) => ProductTemplate448(template_448)
      Err(error) => return Err(error)
    }
  } else if template_number == 49 {
    match typed_decode_template_449(template_payload) {
      Ok(template_449) => ProductTemplate449(template_449)
      Err(error) => return Err(error)
    }
  } else if template_number == 50 {
    match typed_decode_template_450(template_payload) {
      Ok(template_450) => ProductTemplate450(template_450)
      Err(error) => return Err(error)
    }
  } else if template_number == 51 {
    match typed_decode_template_451(template_payload) {
      Ok(template_451) => ProductTemplate451(template_451)
      Err(error) => return Err(error)
    }
  } else if template_number == 53 {
    match typed_decode_template_453(template_payload) {
      Ok(template_453) => ProductTemplate453(template_453)
      Err(error) => return Err(error)
    }
  } else if template_number == 54 {
    match typed_decode_template_454(template_payload) {
      Ok(template_454) => ProductTemplate454(template_454)
      Err(error) => return Err(error)
    }
  } else if template_number == 55 {
    match typed_decode_template_455(template_payload) {
      Ok(template_455) => ProductTemplate455(template_455)
      Err(error) => return Err(error)
    }
  } else if template_number == 56 {
    match typed_decode_template_456(template_payload) {
      Ok(template_456) => ProductTemplate456(template_456)
      Err(error) => return Err(error)
    }
  } else if template_number == 57 {
    match typed_decode_template_457(template_payload) {
      Ok(template_457) => ProductTemplate457(template_457)
      Err(error) => return Err(error)
    }
  } else if template_number == 58 {
    match typed_decode_template_458(template_payload) {
      Ok(template_458) => ProductTemplate458(template_458)
      Err(error) => return Err(error)
    }
  } else if template_number == 59 {
    match typed_decode_template_459(template_payload) {
      Ok(template_459) => ProductTemplate459(template_459)
      Err(error) => return Err(error)
    }
  } else if template_number == 60 {
    match typed_decode_template_460(template_payload) {
      Ok(template_460) => ProductTemplate460(template_460)
      Err(error) => return Err(error)
    }
  } else if template_number == 61 {
    match typed_decode_template_461(template_payload) {
      Ok(template_461) => ProductTemplate461(template_461)
      Err(error) => return Err(error)
    }
  } else if template_number == 62 {
    match typed_decode_template_462(template_payload) {
      Ok(template_462) => ProductTemplate462(template_462)
      Err(error) => return Err(error)
    }
  } else if template_number == 63 {
    match typed_decode_template_463(template_payload) {
      Ok(template_463) => ProductTemplate463(template_463)
      Err(error) => return Err(error)
    }
  } else if template_number == 67 {
    match typed_decode_template_467(template_payload) {
      Ok(template_467) => ProductTemplate467(template_467)
      Err(error) => return Err(error)
    }
  } else if template_number == 68 {
    match typed_decode_template_468(template_payload) {
      Ok(template_468) => ProductTemplate468(template_468)
      Err(error) => return Err(error)
    }
  } else if template_number == 70 {
    match typed_decode_template_470(template_payload) {
      Ok(template_470) => ProductTemplate470(template_470)
      Err(error) => return Err(error)
    }
  } else if template_number == 71 {
    match typed_decode_template_471(template_payload) {
      Ok(template_471) => ProductTemplate471(template_471)
      Err(error) => return Err(error)
    }
  } else if template_number == 72 {
    match typed_decode_template_472(template_payload) {
      Ok(template_472) => ProductTemplate472(template_472)
      Err(error) => return Err(error)
    }
  } else if template_number == 73 {
    match typed_decode_template_473(template_payload) {
      Ok(template_473) => ProductTemplate473(template_473)
      Err(error) => return Err(error)
    }
  } else if template_number == 76 {
    match typed_decode_template_476(template_payload) {
      Ok(template_476) => ProductTemplate476(template_476)
      Err(error) => return Err(error)
    }
  } else if template_number == 77 {
    match typed_decode_template_477(template_payload) {
      Ok(template_477) => ProductTemplate477(template_477)
      Err(error) => return Err(error)
    }
  } else if template_number == 78 {
    match typed_decode_template_478(template_payload) {
      Ok(template_478) => ProductTemplate478(template_478)
      Err(error) => return Err(error)
    }
  } else if template_number == 79 {
    match typed_decode_template_479(template_payload) {
      Ok(template_479) => ProductTemplate479(template_479)
      Err(error) => return Err(error)
    }
  } else if template_number == 80 {
    match typed_decode_template_480(template_payload) {
      Ok(template_480) => ProductTemplate480(template_480)
      Err(error) => return Err(error)
    }
  } else if template_number == 81 {
    match typed_decode_template_481(template_payload) {
      Ok(template_481) => ProductTemplate481(template_481)
      Err(error) => return Err(error)
    }
  } else if template_number == 82 {
    match typed_decode_template_482(template_payload) {
      Ok(template_482) => ProductTemplate482(template_482)
      Err(error) => return Err(error)
    }
  } else if template_number == 83 {
    match typed_decode_template_483(template_payload) {
      Ok(template_483) => ProductTemplate483(template_483)
      Err(error) => return Err(error)
    }
  } else if template_number == 84 {
    match typed_decode_template_484(template_payload) {
      Ok(template_484) => ProductTemplate484(template_484)
      Err(error) => return Err(error)
    }
  } else if template_number == 85 {
    match typed_decode_template_485(template_payload) {
      Ok(template_485) => ProductTemplate485(template_485)
      Err(error) => return Err(error)
    }
  } else if template_number == 86 {
    match typed_decode_template_486(template_payload) {
      Ok(template_486) => ProductTemplate486(template_486)
      Err(error) => return Err(error)
    }
  } else if template_number == 87 {
    match typed_decode_template_487(template_payload) {
      Ok(template_487) => ProductTemplate487(template_487)
      Err(error) => return Err(error)
    }
  } else if template_number == 88 {
    match typed_decode_template_488(template_payload) {
      Ok(template_488) => ProductTemplate488(template_488)
      Err(error) => return Err(error)
    }
  } else if template_number == 89 {
    match typed_decode_template_489(template_payload) {
      Ok(template_489) => ProductTemplate489(template_489)
      Err(error) => return Err(error)
    }
  } else if template_number == 90 {
    match typed_decode_template_490(template_payload) {
      Ok(template_490) => ProductTemplate490(template_490)
      Err(error) => return Err(error)
    }
  } else if template_number == 91 {
    match typed_decode_template_491(template_payload) {
      Ok(template_491) => ProductTemplate491(template_491)
      Err(error) => return Err(error)
    }
  } else if template_number == 92 {
    match typed_decode_template_492(template_payload) {
      Ok(template_492) => ProductTemplate492(template_492)
      Err(error) => return Err(error)
    }
  } else if template_number == 93 {
    match typed_decode_template_493(template_payload) {
      Ok(template_493) => ProductTemplate493(template_493)
      Err(error) => return Err(error)
    }
  } else if template_number == 94 {
    match typed_decode_template_494(template_payload) {
      Ok(template_494) => ProductTemplate494(template_494)
      Err(error) => return Err(error)
    }
  } else if template_number == 95 {
    match typed_decode_template_495(template_payload) {
      Ok(template_495) => ProductTemplate495(template_495)
      Err(error) => return Err(error)
    }
  } else if template_number == 96 {
    match typed_decode_template_496(template_payload) {
      Ok(template_496) => ProductTemplate496(template_496)
      Err(error) => return Err(error)
    }
  } else if template_number == 97 {
    match typed_decode_template_497(template_payload) {
      Ok(template_497) => ProductTemplate497(template_497)
      Err(error) => return Err(error)
    }
  } else if template_number == 98 {
    match typed_decode_template_498(template_payload) {
      Ok(template_498) => ProductTemplate498(template_498)
      Err(error) => return Err(error)
    }
  } else if template_number == 99 {
    match typed_decode_template_499(template_payload) {
      Ok(template_499) => ProductTemplate499(template_499)
      Err(error) => return Err(error)
    }
  } else if template_number == 100 {
    match typed_decode_template_4100(template_payload) {
      Ok(template_4100) => ProductTemplate4100(template_4100)
      Err(error) => return Err(error)
    }
  } else if template_number == 101 {
    match typed_decode_template_4101(template_payload) {
      Ok(template_4101) => ProductTemplate4101(template_4101)
      Err(error) => return Err(error)
    }
  } else if template_number == 102 {
    match typed_decode_template_4102(template_payload) {
      Ok(template_4102) => ProductTemplate4102(template_4102)
      Err(error) => return Err(error)
    }
  } else if template_number == 103 {
    match typed_decode_template_4103(template_payload) {
      Ok(template_4103) => ProductTemplate4103(template_4103)
      Err(error) => return Err(error)
    }
  } else if template_number == 104 {
    match typed_decode_template_4104(template_payload) {
      Ok(template_4104) => ProductTemplate4104(template_4104)
      Err(error) => return Err(error)
    }
  } else if template_number == 105 {
    match typed_decode_template_4105(template_payload) {
      Ok(template_4105) => ProductTemplate4105(template_4105)
      Err(error) => return Err(error)
    }
  } else if template_number == 106 {
    match typed_decode_template_4106(template_payload) {
      Ok(template_4106) => ProductTemplate4106(template_4106)
      Err(error) => return Err(error)
    }
  } else if template_number == 107 {
    match typed_decode_template_4107(template_payload) {
      Ok(template_4107) => ProductTemplate4107(template_4107)
      Err(error) => return Err(error)
    }
  } else if template_number == 108 {
    match typed_decode_template_4108(template_payload) {
      Ok(template_4108) => ProductTemplate4108(template_4108)
      Err(error) => return Err(error)
    }
  } else if template_number == 109 {
    match typed_decode_template_4109(template_payload) {
      Ok(template_4109) => ProductTemplate4109(template_4109)
      Err(error) => return Err(error)
    }
  } else if template_number == 110 {
    match typed_decode_template_4110(template_payload) {
      Ok(template_4110) => ProductTemplate4110(template_4110)
      Err(error) => return Err(error)
    }
  } else if template_number == 111 {
    match typed_decode_template_4111(template_payload) {
      Ok(template_4111) => ProductTemplate4111(template_4111)
      Err(error) => return Err(error)
    }
  } else if template_number == 112 {
    match typed_decode_template_4112(template_payload) {
      Ok(template_4112) => ProductTemplate4112(template_4112)
      Err(error) => return Err(error)
    }
  } else if template_number == 113 {
    match typed_decode_template_4113(template_payload) {
      Ok(template_4113) => ProductTemplate4113(template_4113)
      Err(error) => return Err(error)
    }
  } else if template_number == 114 {
    match typed_decode_template_4114(template_payload) {
      Ok(template_4114) => ProductTemplate4114(template_4114)
      Err(error) => return Err(error)
    }
  } else if template_number == 115 {
    match typed_decode_template_4115(template_payload) {
      Ok(template_4115) => ProductTemplate4115(template_4115)
      Err(error) => return Err(error)
    }
  } else if template_number == 116 {
    match typed_decode_template_4116(template_payload) {
      Ok(template_4116) => ProductTemplate4116(template_4116)
      Err(error) => return Err(error)
    }
  } else if template_number == 117 {
    match typed_decode_template_4117(template_payload) {
      Ok(template_4117) => ProductTemplate4117(template_4117)
      Err(error) => return Err(error)
    }
  } else if template_number == 118 {
    match typed_decode_template_4118(template_payload) {
      Ok(template_4118) => ProductTemplate4118(template_4118)
      Err(error) => return Err(error)
    }
  } else if template_number == 119 {
    match typed_decode_template_4119(template_payload) {
      Ok(template_4119) => ProductTemplate4119(template_4119)
      Err(error) => return Err(error)
    }
  } else if template_number == 120 {
    match typed_decode_template_4120(template_payload) {
      Ok(template_4120) => ProductTemplate4120(template_4120)
      Err(error) => return Err(error)
    }
  } else if template_number == 121 {
    match typed_decode_template_4121(template_payload) {
      Ok(template_4121) => ProductTemplate4121(template_4121)
      Err(error) => return Err(error)
    }
  } else if template_number == 122 {
    match typed_decode_template_4122(template_payload) {
      Ok(template_4122) => ProductTemplate4122(template_4122)
      Err(error) => return Err(error)
    }
  } else if template_number == 123 {
    match typed_decode_template_4123(template_payload) {
      Ok(template_4123) => ProductTemplate4123(template_4123)
      Err(error) => return Err(error)
    }
  } else if template_number == 124 {
    match typed_decode_template_4124(template_payload) {
      Ok(template_4124) => ProductTemplate4124(template_4124)
      Err(error) => return Err(error)
    }
  } else if template_number == 125 {
    match typed_decode_template_4125(template_payload) {
      Ok(template_4125) => ProductTemplate4125(template_4125)
      Err(error) => return Err(error)
    }
  } else if template_number == 126 {
    match typed_decode_template_4126(template_payload) {
      Ok(template_4126) => ProductTemplate4126(template_4126)
      Err(error) => return Err(error)
    }
  } else if template_number == 127 {
    match typed_decode_template_4127(template_payload) {
      Ok(template_4127) => ProductTemplate4127(template_4127)
      Err(error) => return Err(error)
    }
  } else if template_number == 128 {
    match typed_decode_template_4128(template_payload) {
      Ok(template_4128) => ProductTemplate4128(template_4128)
      Err(error) => return Err(error)
    }
  } else if template_number == 129 {
    match typed_decode_template_4129(template_payload) {
      Ok(template_4129) => ProductTemplate4129(template_4129)
      Err(error) => return Err(error)
    }
  } else if template_number == 130 {
    match typed_decode_template_4130(template_payload) {
      Ok(template_4130) => ProductTemplate4130(template_4130)
      Err(error) => return Err(error)
    }
  } else if template_number == 131 {
    match typed_decode_template_4131(template_payload) {
      Ok(template_4131) => ProductTemplate4131(template_4131)
      Err(error) => return Err(error)
    }
  } else if template_number == 132 {
    match typed_decode_template_4132(template_payload) {
      Ok(template_4132) => ProductTemplate4132(template_4132)
      Err(error) => return Err(error)
    }
  } else if template_number == 133 {
    match typed_decode_template_4133(template_payload) {
      Ok(template_4133) => ProductTemplate4133(template_4133)
      Err(error) => return Err(error)
    }
  } else if template_number == 134 {
    match typed_decode_template_4134(template_payload) {
      Ok(template_4134) => ProductTemplate4134(template_4134)
      Err(error) => return Err(error)
    }
  } else if template_number == 135 {
    match typed_decode_template_4135(template_payload) {
      Ok(template_4135) => ProductTemplate4135(template_4135)
      Err(error) => return Err(error)
    }
  } else if template_number == 136 {
    match typed_decode_template_4136(template_payload) {
      Ok(template_4136) => ProductTemplate4136(template_4136)
      Err(error) => return Err(error)
    }
  } else if template_number == 137 {
    match typed_decode_template_4137(template_payload) {
      Ok(template_4137) => ProductTemplate4137(template_4137)
      Err(error) => return Err(error)
    }
  } else if template_number == 138 {
    match typed_decode_template_4138(template_payload) {
      Ok(template_4138) => ProductTemplate4138(template_4138)
      Err(error) => return Err(error)
    }
  } else if template_number == 139 {
    match typed_decode_template_4139(template_payload) {
      Ok(template_4139) => ProductTemplate4139(template_4139)
      Err(error) => return Err(error)
    }
  } else if template_number == 140 {
    match typed_decode_template_4140(template_payload) {
      Ok(template_4140) => ProductTemplate4140(template_4140)
      Err(error) => return Err(error)
    }
  } else if template_number == 141 {
    match typed_decode_template_4141(template_payload) {
      Ok(template_4141) => ProductTemplate4141(template_4141)
      Err(error) => return Err(error)
    }
  } else if template_number == 142 {
    match typed_decode_template_4142(template_payload) {
      Ok(template_4142) => ProductTemplate4142(template_4142)
      Err(error) => return Err(error)
    }
  } else if template_number == 143 {
    match typed_decode_template_4143(template_payload) {
      Ok(template_4143) => ProductTemplate4143(template_4143)
      Err(error) => return Err(error)
    }
  } else if template_number == 144 {
    match typed_decode_template_4144(template_payload) {
      Ok(template_4144) => ProductTemplate4144(template_4144)
      Err(error) => return Err(error)
    }
  } else if template_number == 145 {
    match typed_decode_template_4145(template_payload) {
      Ok(template_4145) => ProductTemplate4145(template_4145)
      Err(error) => return Err(error)
    }
  } else if template_number == 146 {
    match typed_decode_template_4146(template_payload) {
      Ok(template_4146) => ProductTemplate4146(template_4146)
      Err(error) => return Err(error)
    }
  } else if template_number == 147 {
    match typed_decode_template_4147(template_payload) {
      Ok(template_4147) => ProductTemplate4147(template_4147)
      Err(error) => return Err(error)
    }
  } else if template_number == 148 {
    match typed_decode_template_4148(template_payload) {
      Ok(template_4148) => ProductTemplate4148(template_4148)
      Err(error) => return Err(error)
    }
  } else if template_number == 149 {
    match typed_decode_template_4149(template_payload) {
      Ok(template_4149) => ProductTemplate4149(template_4149)
      Err(error) => return Err(error)
    }
  } else if template_number == 150 {
    match typed_decode_template_4150(template_payload) {
      Ok(template_4150) => ProductTemplate4150(template_4150)
      Err(error) => return Err(error)
    }
  } else if template_number == 151 {
    match typed_decode_template_4151(template_payload) {
      Ok(template_4151) => ProductTemplate4151(template_4151)
      Err(error) => return Err(error)
    }
  } else if template_number == 152 {
    match typed_decode_template_4152(template_payload) {
      Ok(template_4152) => ProductTemplate4152(template_4152)
      Err(error) => return Err(error)
    }
  } else if template_number == 153 {
    match typed_decode_template_4153(template_payload) {
      Ok(template_4153) => ProductTemplate4153(template_4153)
      Err(error) => return Err(error)
    }
  } else if template_number == 154 {
    match typed_decode_template_4154(template_payload) {
      Ok(template_4154) => ProductTemplate4154(template_4154)
      Err(error) => return Err(error)
    }
  } else if template_number == 155 {
    match typed_decode_template_4155(template_payload) {
      Ok(template_4155) => ProductTemplate4155(template_4155)
      Err(error) => return Err(error)
    }
  } else if template_number == 254 {
    match typed_decode_template_4254(template_payload) {
      Ok(template_4254) => ProductTemplate4254(template_4254)
      Err(error) => return Err(error)
    }
  } else if template_number == 1000 {
    match typed_decode_template_41000(template_payload) {
      Ok(template_41000) => ProductTemplate41000(template_41000)
      Err(error) => return Err(error)
    }
  } else if template_number == 1001 {
    match typed_decode_template_41001(template_payload) {
      Ok(template_41001) => ProductTemplate41001(template_41001)
      Err(error) => return Err(error)
    }
  } else if template_number == 1002 {
    match typed_decode_template_41002(template_payload) {
      Ok(template_41002) => ProductTemplate41002(template_41002)
      Err(error) => return Err(error)
    }
  } else if template_number == 1100 {
    match typed_decode_template_41100(template_payload) {
      Ok(template_41100) => ProductTemplate41100(template_41100)
      Err(error) => return Err(error)
    }
  } else if template_number == 1101 {
    match typed_decode_template_41101(template_payload) {
      Ok(template_41101) => ProductTemplate41101(template_41101)
      Err(error) => return Err(error)
    }
  } else {
    ProductTemplateUnknown(template_number, template_payload.to_bytes())
  }
  Ok({ number_of_coordinate_values, template, coordinate_values_raw })
}

///|
pub fn encode_section4_bytes(section : Grib2Section4Decoded) -> Bytes {
  let payload : Array[Byte] = []
  typed_push_u16_be(payload, section.number_of_coordinate_values)
  let (template_number, template_raw) = match section.template {
    ProductTemplate40(template_40) => (0, typed_encode_template_40(template_40))
    ProductTemplate41(template_41) => (1, typed_encode_template_41(template_41))
    ProductTemplate42(template_42) => (2, typed_encode_template_42(template_42))
    ProductTemplate43(template_43) => (3, typed_encode_template_43(template_43))
    ProductTemplate44(template_44) => (4, typed_encode_template_44(template_44))
    ProductTemplate45(template_45) => (5, typed_encode_template_45(template_45))
    ProductTemplate46(template_46) => (6, typed_encode_template_46(template_46))
    ProductTemplate47(template_47) => (7, typed_encode_template_47(template_47))
    ProductTemplate48(template_48) => (8, typed_encode_template_48(template_48))
    ProductTemplate49(template_49) => (9, typed_encode_template_49(template_49))
    ProductTemplate410(template_410) =>
      (10, typed_encode_template_410(template_410))
    ProductTemplate411(template_411) =>
      (11, typed_encode_template_411(template_411))
    ProductTemplate412(template_412) =>
      (12, typed_encode_template_412(template_412))
    ProductTemplate413(template_413) =>
      (13, typed_encode_template_413(template_413))
    ProductTemplate414(template_414) =>
      (14, typed_encode_template_414(template_414))
    ProductTemplate415(template_415) =>
      (15, typed_encode_template_415(template_415))
    ProductTemplate420(template_420) =>
      (20, typed_encode_template_420(template_420))
    ProductTemplate430(template_430) =>
      (30, typed_encode_template_430(template_430))
    ProductTemplate431(template_431) =>
      (31, typed_encode_template_431(template_431))
    ProductTemplate432(template_432) =>
      (32, typed_encode_template_432(template_432))
    ProductTemplate433(template_433) =>
      (33, typed_encode_template_433(template_433))
    ProductTemplate434(template_434) =>
      (34, typed_encode_template_434(template_434))
    ProductTemplate435(template_435) =>
      (35, typed_encode_template_435(template_435))
    ProductTemplate440(template_440) =>
      (40, typed_encode_template_440(template_440))
    ProductTemplate441(template_441) =>
      (41, typed_encode_template_441(template_441))
    ProductTemplate442(template_442) =>
      (42, typed_encode_template_442(template_442))
    ProductTemplate443(template_443) =>
      (43, typed_encode_template_443(template_443))
    ProductTemplate444(template_444) =>
      (44, typed_encode_template_444(template_444))
    ProductTemplate445(template_445) =>
      (45, typed_encode_template_445(template_445))
    ProductTemplate446(template_446) =>
      (46, typed_encode_template_446(template_446))
    ProductTemplate447(template_447) =>
      (47, typed_encode_template_447(template_447))
    ProductTemplate448(template_448) =>
      (48, typed_encode_template_448(template_448))
    ProductTemplate449(template_449) =>
      (49, typed_encode_template_449(template_449))
    ProductTemplate450(template_450) =>
      (50, typed_encode_template_450(template_450))
    ProductTemplate451(template_451) =>
      (51, typed_encode_template_451(template_451))
    ProductTemplate453(template_453) =>
      (53, typed_encode_template_453(template_453))
    ProductTemplate454(template_454) =>
      (54, typed_encode_template_454(template_454))
    ProductTemplate455(template_455) =>
      (55, typed_encode_template_455(template_455))
    ProductTemplate456(template_456) =>
      (56, typed_encode_template_456(template_456))
    ProductTemplate457(template_457) =>
      (57, typed_encode_template_457(template_457))
    ProductTemplate458(template_458) =>
      (58, typed_encode_template_458(template_458))
    ProductTemplate459(template_459) =>
      (59, typed_encode_template_459(template_459))
    ProductTemplate460(template_460) =>
      (60, typed_encode_template_460(template_460))
    ProductTemplate461(template_461) =>
      (61, typed_encode_template_461(template_461))
    ProductTemplate462(template_462) =>
      (62, typed_encode_template_462(template_462))
    ProductTemplate463(template_463) =>
      (63, typed_encode_template_463(template_463))
    ProductTemplate467(template_467) =>
      (67, typed_encode_template_467(template_467))
    ProductTemplate468(template_468) =>
      (68, typed_encode_template_468(template_468))
    ProductTemplate470(template_470) =>
      (70, typed_encode_template_470(template_470))
    ProductTemplate471(template_471) =>
      (71, typed_encode_template_471(template_471))
    ProductTemplate472(template_472) =>
      (72, typed_encode_template_472(template_472))
    ProductTemplate473(template_473) =>
      (73, typed_encode_template_473(template_473))
    ProductTemplate476(template_476) =>
      (76, typed_encode_template_476(template_476))
    ProductTemplate477(template_477) =>
      (77, typed_encode_template_477(template_477))
    ProductTemplate478(template_478) =>
      (78, typed_encode_template_478(template_478))
    ProductTemplate479(template_479) =>
      (79, typed_encode_template_479(template_479))
    ProductTemplate480(template_480) =>
      (80, typed_encode_template_480(template_480))
    ProductTemplate481(template_481) =>
      (81, typed_encode_template_481(template_481))
    ProductTemplate482(template_482) =>
      (82, typed_encode_template_482(template_482))
    ProductTemplate483(template_483) =>
      (83, typed_encode_template_483(template_483))
    ProductTemplate484(template_484) =>
      (84, typed_encode_template_484(template_484))
    ProductTemplate485(template_485) =>
      (85, typed_encode_template_485(template_485))
    ProductTemplate486(template_486) =>
      (86, typed_encode_template_486(template_486))
    ProductTemplate487(template_487) =>
      (87, typed_encode_template_487(template_487))
    ProductTemplate488(template_488) =>
      (88, typed_encode_template_488(template_488))
    ProductTemplate489(template_489) =>
      (89, typed_encode_template_489(template_489))
    ProductTemplate490(template_490) =>
      (90, typed_encode_template_490(template_490))
    ProductTemplate491(template_491) =>
      (91, typed_encode_template_491(template_491))
    ProductTemplate492(template_492) =>
      (92, typed_encode_template_492(template_492))
    ProductTemplate493(template_493) =>
      (93, typed_encode_template_493(template_493))
    ProductTemplate494(template_494) =>
      (94, typed_encode_template_494(template_494))
    ProductTemplate495(template_495) =>
      (95, typed_encode_template_495(template_495))
    ProductTemplate496(template_496) =>
      (96, typed_encode_template_496(template_496))
    ProductTemplate497(template_497) =>
      (97, typed_encode_template_497(template_497))
    ProductTemplate498(template_498) =>
      (98, typed_encode_template_498(template_498))
    ProductTemplate499(template_499) =>
      (99, typed_encode_template_499(template_499))
    ProductTemplate4100(template_4100) =>
      (100, typed_encode_template_4100(template_4100))
    ProductTemplate4101(template_4101) =>
      (101, typed_encode_template_4101(template_4101))
    ProductTemplate4102(template_4102) =>
      (102, typed_encode_template_4102(template_4102))
    ProductTemplate4103(template_4103) =>
      (103, typed_encode_template_4103(template_4103))
    ProductTemplate4104(template_4104) =>
      (104, typed_encode_template_4104(template_4104))
    ProductTemplate4105(template_4105) =>
      (105, typed_encode_template_4105(template_4105))
    ProductTemplate4106(template_4106) =>
      (106, typed_encode_template_4106(template_4106))
    ProductTemplate4107(template_4107) =>
      (107, typed_encode_template_4107(template_4107))
    ProductTemplate4108(template_4108) =>
      (108, typed_encode_template_4108(template_4108))
    ProductTemplate4109(template_4109) =>
      (109, typed_encode_template_4109(template_4109))
    ProductTemplate4110(template_4110) =>
      (110, typed_encode_template_4110(template_4110))
    ProductTemplate4111(template_4111) =>
      (111, typed_encode_template_4111(template_4111))
    ProductTemplate4112(template_4112) =>
      (112, typed_encode_template_4112(template_4112))
    ProductTemplate4113(template_4113) =>
      (113, typed_encode_template_4113(template_4113))
    ProductTemplate4114(template_4114) =>
      (114, typed_encode_template_4114(template_4114))
    ProductTemplate4115(template_4115) =>
      (115, typed_encode_template_4115(template_4115))
    ProductTemplate4116(template_4116) =>
      (116, typed_encode_template_4116(template_4116))
    ProductTemplate4117(template_4117) =>
      (117, typed_encode_template_4117(template_4117))
    ProductTemplate4118(template_4118) =>
      (118, typed_encode_template_4118(template_4118))
    ProductTemplate4119(template_4119) =>
      (119, typed_encode_template_4119(template_4119))
    ProductTemplate4120(template_4120) =>
      (120, typed_encode_template_4120(template_4120))
    ProductTemplate4121(template_4121) =>
      (121, typed_encode_template_4121(template_4121))
    ProductTemplate4122(template_4122) =>
      (122, typed_encode_template_4122(template_4122))
    ProductTemplate4123(template_4123) =>
      (123, typed_encode_template_4123(template_4123))
    ProductTemplate4124(template_4124) =>
      (124, typed_encode_template_4124(template_4124))
    ProductTemplate4125(template_4125) =>
      (125, typed_encode_template_4125(template_4125))
    ProductTemplate4126(template_4126) =>
      (126, typed_encode_template_4126(template_4126))
    ProductTemplate4127(template_4127) =>
      (127, typed_encode_template_4127(template_4127))
    ProductTemplate4128(template_4128) =>
      (128, typed_encode_template_4128(template_4128))
    ProductTemplate4129(template_4129) =>
      (129, typed_encode_template_4129(template_4129))
    ProductTemplate4130(template_4130) =>
      (130, typed_encode_template_4130(template_4130))
    ProductTemplate4131(template_4131) =>
      (131, typed_encode_template_4131(template_4131))
    ProductTemplate4132(template_4132) =>
      (132, typed_encode_template_4132(template_4132))
    ProductTemplate4133(template_4133) =>
      (133, typed_encode_template_4133(template_4133))
    ProductTemplate4134(template_4134) =>
      (134, typed_encode_template_4134(template_4134))
    ProductTemplate4135(template_4135) =>
      (135, typed_encode_template_4135(template_4135))
    ProductTemplate4136(template_4136) =>
      (136, typed_encode_template_4136(template_4136))
    ProductTemplate4137(template_4137) =>
      (137, typed_encode_template_4137(template_4137))
    ProductTemplate4138(template_4138) =>
      (138, typed_encode_template_4138(template_4138))
    ProductTemplate4139(template_4139) =>
      (139, typed_encode_template_4139(template_4139))
    ProductTemplate4140(template_4140) =>
      (140, typed_encode_template_4140(template_4140))
    ProductTemplate4141(template_4141) =>
      (141, typed_encode_template_4141(template_4141))
    ProductTemplate4142(template_4142) =>
      (142, typed_encode_template_4142(template_4142))
    ProductTemplate4143(template_4143) =>
      (143, typed_encode_template_4143(template_4143))
    ProductTemplate4144(template_4144) =>
      (144, typed_encode_template_4144(template_4144))
    ProductTemplate4145(template_4145) =>
      (145, typed_encode_template_4145(template_4145))
    ProductTemplate4146(template_4146) =>
      (146, typed_encode_template_4146(template_4146))
    ProductTemplate4147(template_4147) =>
      (147, typed_encode_template_4147(template_4147))
    ProductTemplate4148(template_4148) =>
      (148, typed_encode_template_4148(template_4148))
    ProductTemplate4149(template_4149) =>
      (149, typed_encode_template_4149(template_4149))
    ProductTemplate4150(template_4150) =>
      (150, typed_encode_template_4150(template_4150))
    ProductTemplate4151(template_4151) =>
      (151, typed_encode_template_4151(template_4151))
    ProductTemplate4152(template_4152) =>
      (152, typed_encode_template_4152(template_4152))
    ProductTemplate4153(template_4153) =>
      (153, typed_encode_template_4153(template_4153))
    ProductTemplate4154(template_4154) =>
      (154, typed_encode_template_4154(template_4154))
    ProductTemplate4155(template_4155) =>
      (155, typed_encode_template_4155(template_4155))
    ProductTemplate4254(template_4254) =>
      (254, typed_encode_template_4254(template_4254))
    ProductTemplate41000(template_41000) =>
      (1000, typed_encode_template_41000(template_41000))
    ProductTemplate41001(template_41001) =>
      (1001, typed_encode_template_41001(template_41001))
    ProductTemplate41002(template_41002) =>
      (1002, typed_encode_template_41002(template_41002))
    ProductTemplate41100(template_41100) =>
      (1100, typed_encode_template_41100(template_41100))
    ProductTemplate41101(template_41101) =>
      (1101, typed_encode_template_41101(template_41101))
    ProductTemplateUnknown(template_number, raw) => (template_number, raw)
  }
  typed_push_u16_be(payload, template_number)
  for b in template_raw {
    payload.push(b)
  }
  for b in section.coordinate_values_raw {
    payload.push(b)
  }
  typed_build_section(4, Bytes::from_array(payload))
}
