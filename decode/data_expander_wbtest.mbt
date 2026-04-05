///|
fn fake_section_frame(
  section_number : Int,
  start : Int,
  length : Int,
) -> Grib2SectionFrame {
  { section_number, start, length }
}

///|
test "normalize regular grid supports consecutive_j scan order" {
  let normalized = normalize_regular_grid_to_wgrib2_scan_order(
    2,
    3,
    @typed.parse_scanning_mode(32),
    { values: [10.0, 20.0, 30.0, 40.0, 50.0, 60.0], num_points: 6 },
  )
  inspect(normalized.values[0], content="30")
  inspect(normalized.values[1], content="60")
  inspect(normalized.values[2], content="20")
  inspect(normalized.values[3], content="50")
  inspect(normalized.values[4], content="10")
  inspect(normalized.values[5], content="40")
}

///|
test "normalize regular grid supports alternating rows" {
  let normalized = normalize_regular_grid_to_wgrib2_scan_order(
    2,
    3,
    @typed.parse_scanning_mode(16),
    { values: [10.0, 11.0, 21.0, 20.0, 30.0, 31.0], num_points: 6 },
  )
  inspect(normalized.values[0], content="30")
  inspect(normalized.values[1], content="31")
  inspect(normalized.values[2], content="20")
  inspect(normalized.values[3], content="21")
  inspect(normalized.values[4], content="10")
  inspect(normalized.values[5], content="11")
}

///|
test "bitmap indicator 254 reuses previous explicit bitmap" {
  let raw = b"\x00\x00\x00\x07\x06\x00\xa0\x00\x00\x00\x06\x06\xfe"
  let dummy3 = fake_section_frame(3, 0, 0)
  let dummy4 = fake_section_frame(4, 0, 0)
  let dummy5 = fake_section_frame(5, 0, 0)
  let dummy7 = fake_section_frame(7, 0, 0)
  let message : Grib2MessageContext = {
    offset: 0,
    total_length: raw.length(),
    discipline: 0,
    edition: 2,
    section1: fake_section_frame(1, 0, 0),
    section8_offset: raw.length(),
    sections: [],
    submessages: [
      {
        section2: None,
        section3: dummy3,
        section4: dummy4,
        section5: dummy5,
        section6: fake_section_frame(6, 0, 7),
        section7: dummy7,
      },
      {
        section2: None,
        section3: dummy3,
        section4: dummy4,
        section5: dummy5,
        section6: fake_section_frame(6, 7, 6),
        section7: dummy7,
      },
    ],
    raw,
  }
  let section6 = match
    decode_submessage_section6(message, message.submessages[1]) {
    Ok(v) => v
    Err(_) => fail("decode_submessage_section6 failed")
  }
  match resolve_bitmap_raw(message, message.submessages[1], section6) {
    Ok(Some(bitmap_raw)) => inspect(bitmap_raw == b"\xa0", content="true")
    Ok(None) => fail("expected reused bitmap")
    Err(_) => fail("resolve_bitmap_raw failed")
  }
}
