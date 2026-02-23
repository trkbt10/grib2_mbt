///|
fn jp2_read_u16_be(data : Bytes, offset : Int) -> Int {
  let b0 = data[offset].to_uint().reinterpret_as_int()
  let b1 = data[offset + 1].to_uint().reinterpret_as_int()
  (b0 << 8) | b1
}

///|
fn jp2_read_u32_be(data : Bytes, offset : Int) -> Int {
  let b0 = data[offset].to_uint().reinterpret_as_int()
  let b1 = data[offset + 1].to_uint().reinterpret_as_int()
  let b2 = data[offset + 2].to_uint().reinterpret_as_int()
  let b3 = data[offset + 3].to_uint().reinterpret_as_int()
  (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
}

///|
priv struct Jpeg2000SizInfo {
  width : Int
  height : Int
  num_components : Int
  bits_per_component : Int
  signed_components : Bool
}

///|
priv struct Jpeg2000CodestreamInfo {
  codestream_start : Int
  siz : Jpeg2000SizInfo
  has_cod : Bool
  has_qcd : Bool
  has_sod : Bool
  num_tile_parts : Int
  has_eoc : Bool
  cod_use_sop : Bool
  cod_use_eph : Bool
  first_packet_header_bit : Int
  first_packet_zero_bitplanes : Int
  first_packet_header_bytes : Int
  cod_progression_order : Int
  cod_num_layers : Int
  cod_num_decomposition_levels : Int
  cod_wavelet_transform : Int
}

///|
priv struct Jpeg2000CodInfo {
  progression_order : Int
  num_layers : Int
  num_decomposition_levels : Int
  wavelet_transform : Int
  use_sop : Bool
  use_eph : Bool
}

///|
priv struct TilePartsInfo {
  num_tile_parts : Int
  has_sod : Bool
  has_eoc : Bool
  first_packet_header_bit : Int
  first_packet_zero_bitplanes : Int
  first_packet_header_bytes : Int
}

///|
fn parse_cod_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
) -> Result[Jpeg2000CodInfo, UnpackError] {
  if segment_len < 12 {
    return Err(UnsupportedTemplate("COD segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("COD segment is truncated"))
  }
  let scod = data[payload_start + 2].to_uint().reinterpret_as_int()
  let progression_order = data[payload_start + 3].to_uint().reinterpret_as_int()
  let num_layers = jp2_read_u16_be(data, payload_start + 4)
  let num_decomposition_levels = data[payload_start + 7]
    .to_uint()
    .reinterpret_as_int()
  let codeblock_width_raw = data[payload_start + 8]
    .to_uint()
    .reinterpret_as_int()
  let codeblock_height_raw = data[payload_start + 9]
    .to_uint()
    .reinterpret_as_int()
  let codeblock_style = data[payload_start + 10].to_uint().reinterpret_as_int()
  let wavelet_transform = data[payload_start + 11]
    .to_uint()
    .reinterpret_as_int()
  let use_precincts = (scod & 0x01) != 0
  let use_sop = (scod & 0x02) != 0
  let use_eph = (scod & 0x04) != 0
  let expected_len = if use_precincts {
    12 + num_decomposition_levels + 1
  } else {
    12
  }
  if segment_len != expected_len {
    return Err(
      UnsupportedTemplate(
        "COD segment length mismatch: expected \{expected_len}, got \{segment_len}",
      ),
    )
  }
  if num_layers <= 0 {
    return Err(UnsupportedTemplate("COD num_layers must be > 0"))
  }
  if codeblock_width_raw > 10 || codeblock_height_raw > 10 {
    return Err(UnsupportedTemplate("COD codeblock raw size out of range"))
  }
  if (codeblock_style & 0xC0) != 0 {
    return Err(UnsupportedTemplate("COD codeblock style has reserved bits set"))
  }
  Ok({
    progression_order,
    num_layers,
    num_decomposition_levels,
    wavelet_transform,
    use_sop,
    use_eph,
  })
}

///|
fn parse_siz_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
) -> Result[Jpeg2000SizInfo, UnpackError] {
  // Lsiz includes its own 2-byte length field.
  if segment_len < 41 {
    return Err(UnsupportedTemplate("SIZ segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("SIZ segment is truncated"))
  }
  let xsiz = jp2_read_u32_be(data, payload_start + 4)
  let ysiz = jp2_read_u32_be(data, payload_start + 8)
  let xosiz = jp2_read_u32_be(data, payload_start + 12)
  let yosiz = jp2_read_u32_be(data, payload_start + 16)
  let width = xsiz - xosiz
  let height = ysiz - yosiz
  if width <= 0 || height <= 0 {
    return Err(UnsupportedTemplate("invalid SIZ image dimensions"))
  }
  let csiz = jp2_read_u16_be(data, payload_start + 36)
  if csiz <= 0 {
    return Err(UnsupportedTemplate("SIZ component count must be > 0"))
  }
  let expected_len = 38 + 3 * csiz
  if segment_len != expected_len {
    return Err(
      UnsupportedTemplate(
        "SIZ segment length mismatch: expected \{expected_len}, got \{segment_len}",
      ),
    )
  }
  let first_ssiz = data[payload_start + 38].to_uint().reinterpret_as_int()
  let first_bits = (first_ssiz & 0x7F) + 1
  let first_signed = (first_ssiz & 0x80) != 0
  if first_bits <= 0 {
    return Err(UnsupportedTemplate("invalid SIZ component precision"))
  }
  for comp = 0; comp < csiz; comp = comp + 1 {
    let ssiz = data[payload_start + 38 + comp * 3]
      .to_uint()
      .reinterpret_as_int()
    let bits = (ssiz & 0x7F) + 1
    let is_signed = (ssiz & 0x80) != 0
    if bits != first_bits || is_signed != first_signed {
      return Err(
        UnsupportedTemplate(
          "mixed component precision/sign in SIZ is not supported",
        ),
      )
    }
  }
  Ok({
    width,
    height,
    num_components: csiz,
    bits_per_component: first_bits,
    signed_components: first_signed,
  })
}

///|
fn locate_jpeg2000_codestream_start(data : Bytes) -> Result[Int, UnpackError] {
  if data.length() < 2 {
    return Err(InsufficientData("JPEG2000 data is too short"))
  }
  // Raw codestream (J2K)
  if data[0] == b'\xFF' && data[1] == b'\x4F' {
    return Ok(0)
  }
  // JP2 boxed stream: locate jp2c box.
  let mut offset = 0
  while offset + 8 <= data.length() {
    let lbox = jp2_read_u32_be(data, offset)
    let tbox = data.sub(start=offset + 4, end=offset + 8).to_bytes()
    let mut box_header_len = 8
    let box_len = if lbox == 0 {
      data.length() - offset
    } else if lbox == 1 {
      if offset + 16 > data.length() {
        return Err(InsufficientData("JP2 extended box header is truncated"))
      }
      let hi = jp2_read_u32_be(data, offset + 8)
      let lo = jp2_read_u32_be(data, offset + 12)
      if hi != 0 {
        return Err(
          UnsupportedTemplate("JP2 boxes larger than 4GiB are not supported"),
        )
      }
      box_header_len = 16
      lo
    } else {
      lbox
    }
    if box_len < box_header_len {
      return Err(UnsupportedTemplate("invalid JP2 box length"))
    }
    if offset + box_len > data.length() {
      return Err(InsufficientData("JP2 box extends past end of data"))
    }
    if tbox == b"jp2c" {
      return Ok(offset + box_header_len)
    }
    offset += box_len
    if lbox == 0 {
      break
    }
  }
  Err(UnsupportedTemplate("JPEG2000 codestream (SOC/jp2c) not found"))
}

///|
fn parse_tile_parts(
  data : Bytes,
  first_sot_offset : Int,
  use_sop : Bool,
) -> Result[TilePartsInfo, UnpackError] {
  let mut offset = first_sot_offset
  let mut num_tile_parts = 0
  let mut seen_sod = false
  let mut seen_eoc = false
  let mut first_packet_header_bit = -1
  let mut first_packet_zero_bitplanes = -1
  let mut first_packet_header_bytes = -1
  while offset + 2 <= data.length() {
    if data[offset] != b'\xFF' {
      return Err(
        UnsupportedTemplate("invalid marker prefix while parsing tile-parts"),
      )
    }
    let marker_tail = data[offset + 1].to_uint().reinterpret_as_int()
    if marker_tail == 0xD9 {
      seen_eoc = true
      break
    }
    if marker_tail != 0x90 {
      return Err(
        UnsupportedTemplate(
          "expected SOT or EOC while parsing tile-parts, got marker 0xFF\{marker_tail.to_string(radix=16)}",
        ),
      )
    }
    if offset + 12 > data.length() {
      return Err(InsufficientData("truncated SOT segment"))
    }
    let lsot = jp2_read_u16_be(data, offset + 2)
    if lsot != 10 {
      return Err(
        UnsupportedTemplate("invalid SOT segment length (Lsot): \{lsot}"),
      )
    }
    let psot = jp2_read_u32_be(data, offset + 6)
    if psot <= 0 {
      return Err(UnsupportedTemplate("unsupported SOT Psot value: \{psot}"))
    }
    let tile_end = offset + psot
    if tile_end > data.length() {
      return Err(InsufficientData("tile-part extends past end of codestream"))
    }
    let payload_start = match
      find_tile_part_payload_start(data, offset + 12, tile_end) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let packet_probe = match
      probe_first_packet_header(
        data.sub(start=payload_start, end=tile_end).to_bytes(),
        use_sop,
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    if first_packet_header_bit < 0 {
      first_packet_header_bit = packet_probe.first_inclusion_bit
      first_packet_zero_bitplanes = packet_probe.zero_bitplanes
      first_packet_header_bytes = packet_probe.bytes_consumed
    }
    seen_sod = true
    num_tile_parts += 1
    offset = tile_end
    if offset + 2 <= data.length() &&
      data[offset] == b'\xFF' &&
      data[offset + 1] == b'\xD9' {
      seen_eoc = true
      break
    }
  }
  if num_tile_parts == 0 {
    return Err(UnsupportedTemplate("JPEG2000 codestream has no tile-parts"))
  }
  if !seen_eoc {
    return Err(UnsupportedTemplate("JPEG2000 codestream missing EOC marker"))
  }
  Ok({
    num_tile_parts,
    has_sod: seen_sod,
    has_eoc: seen_eoc,
    first_packet_header_bit,
    first_packet_zero_bitplanes,
    first_packet_header_bytes,
  })
}

///|
fn find_tile_part_payload_start(
  data : Bytes,
  header_start : Int,
  tile_end : Int,
) -> Result[Int, UnpackError] {
  let mut p = header_start
  let mut tile_seen_sod = false
  while p + 2 <= tile_end {
    if data[p] != b'\xFF' {
      return Err(
        UnsupportedTemplate(
          "invalid marker prefix in tile-part header before SOD",
        ),
      )
    }
    let mut marker_tail_inner = data[p + 1].to_uint().reinterpret_as_int()
    while marker_tail_inner == 0xFF {
      p += 1
      if p + 2 > tile_end {
        return Err(InsufficientData("truncated marker stream in tile-part"))
      }
      marker_tail_inner = data[p + 1].to_uint().reinterpret_as_int()
    }
    let marker = (0xFF << 8) | marker_tail_inner
    p += 2
    if marker == 0xFF93 {
      tile_seen_sod = true
      break
    }
    if marker == 0xFF4F ||
      marker == 0xFFD9 ||
      (marker >= 0xFFD0 && marker <= 0xFFD7) {
      return Err(
        UnsupportedTemplate(
          "unexpected marker 0x\{marker.to_string(radix=16)} in tile-part header",
        ),
      )
    }
    if p + 2 > tile_end {
      return Err(
        InsufficientData("truncated marker segment length in tile-part header"),
      )
    }
    let segment_len = jp2_read_u16_be(data, p)
    if segment_len < 2 {
      return Err(
        UnsupportedTemplate("invalid marker segment length in tile-part"),
      )
    }
    if p + segment_len > tile_end {
      return Err(InsufficientData("tile-part marker segment exceeds tile-part"))
    }
    p += segment_len
  }
  if !tile_seen_sod {
    return Err(UnsupportedTemplate("tile-part missing SOD marker"))
  }
  Ok(p)
}

///|
fn parse_jpeg2000_codestream_info(
  data : Bytes,
) -> Result[Jpeg2000CodestreamInfo, UnpackError] {
  let start = match locate_jpeg2000_codestream_start(data) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if start + 2 > data.length() {
    return Err(InsufficientData("JPEG2000 codestream header is truncated"))
  }
  if !(data[start] == b'\xFF' && data[start + 1] == b'\x4F') {
    return Err(
      UnsupportedTemplate("JPEG2000 codestream must start with SOC marker"),
    )
  }
  let mut parsed_siz : Jpeg2000SizInfo? = None
  let mut seen_siz = false
  let mut has_cod = false
  let mut has_qcd = false
  let mut parsed_tile_parts : TilePartsInfo? = None
  let mut parsed_cod : Jpeg2000CodInfo? = None
  let mut offset = start + 2
  // Parse main header markers up to first SOT.
  while offset + 2 <= data.length() {
    if data[offset] != b'\xFF' {
      return Err(
        UnsupportedTemplate("invalid JPEG2000 marker prefix in main header"),
      )
    }
    let marker_offset = offset
    let mut marker_tail = data[offset + 1].to_uint().reinterpret_as_int()
    while marker_tail == 0xFF {
      offset += 1
      if offset + 2 > data.length() {
        return Err(InsufficientData("truncated JPEG2000 marker stream"))
      }
      marker_tail = data[offset + 1].to_uint().reinterpret_as_int()
    }
    let marker = (0xFF << 8) | marker_tail
    offset += 2
    if marker == 0xFF90 {
      let cod = match parsed_cod {
        Some(v) => v
        None =>
          return Err(
            UnsupportedTemplate("JPEG2000 codestream missing COD marker"),
          )
      }
      if cod.progression_order < 0 || cod.progression_order > 4 {
        return Err(
          UnsupportedTemplate(
            "unsupported COD progression order: \{cod.progression_order}",
          ),
        )
      }
      if cod.wavelet_transform != 0 && cod.wavelet_transform != 1 {
        return Err(
          UnsupportedTemplate(
            "unsupported COD wavelet transform: \{cod.wavelet_transform}",
          ),
        )
      }
      let tile_parts = match
        parse_tile_parts(data, marker_offset, cod.use_sop) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      parsed_tile_parts = Some(tile_parts)
      break
    }
    if marker == 0xFF93 {
      return Err(
        UnsupportedTemplate("unexpected SOD in main header (missing SOT)"),
      )
    }
    if marker == 0xFFD9 {
      return Err(UnsupportedTemplate("unexpected EOC in main header"))
    }
    // Markers without segment length.
    if marker == 0xFF4F || (marker >= 0xFFD0 && marker <= 0xFFD7) {
      continue
    }
    if offset + 2 > data.length() {
      return Err(InsufficientData("truncated JPEG2000 marker segment length"))
    }
    let segment_len = jp2_read_u16_be(data, offset)
    if segment_len < 2 {
      return Err(UnsupportedTemplate("invalid JPEG2000 marker segment length"))
    }
    if marker == 0xFF51 {
      seen_siz = true
      let siz = match parse_siz_segment(data, offset, segment_len) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      parsed_siz = Some(siz)
    } else if marker == 0xFF52 {
      has_cod = true
      let cod = match parse_cod_segment(data, offset, segment_len) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      parsed_cod = Some(cod)
    } else if marker == 0xFF5C {
      has_qcd = true
    }
    offset += segment_len
  }
  if !seen_siz {
    return Err(UnsupportedTemplate("JPEG2000 codestream missing SIZ marker"))
  }
  let siz = match parsed_siz {
    Some(v) => v
    None =>
      return Err(UnsupportedTemplate("failed to parse JPEG2000 SIZ marker"))
  }
  let tile_parts = match parsed_tile_parts {
    Some(v) => v
    None =>
      return Err(UnsupportedTemplate("JPEG2000 codestream missing SOT marker"))
  }
  Ok({
    codestream_start: start,
    siz,
    has_cod,
    has_qcd,
    has_sod: tile_parts.has_sod,
    num_tile_parts: tile_parts.num_tile_parts,
    has_eoc: tile_parts.has_eoc,
    cod_use_sop: match parsed_cod {
      Some(cod) => cod.use_sop
      None => false
    },
    cod_use_eph: match parsed_cod {
      Some(cod) => cod.use_eph
      None => false
    },
    first_packet_header_bit: tile_parts.first_packet_header_bit,
    first_packet_zero_bitplanes: tile_parts.first_packet_zero_bitplanes,
    first_packet_header_bytes: tile_parts.first_packet_header_bytes,
    cod_progression_order: match parsed_cod {
      Some(cod) => cod.progression_order
      None => 0
    },
    cod_num_layers: match parsed_cod {
      Some(cod) => cod.num_layers
      None => 0
    },
    cod_num_decomposition_levels: match parsed_cod {
      Some(cod) => cod.num_decomposition_levels
      None => 0
    },
    cod_wavelet_transform: match parsed_cod {
      Some(cod) => cod.wavelet_transform
      None => 0
    },
  })
}

///|
pub fn validate_jpeg2000_codestream(data : Bytes) -> Result[Unit, UnpackError] {
  match parse_jpeg2000_codestream_info(data) {
    Ok(_) => Ok(())
    Err(e) => Err(e)
  }
}

///|
test "validate_jpeg2000_codestream rejects non-j2k bytes" {
  match validate_jpeg2000_codestream(b"not-jpeg2000") {
    Err(_) => inspect(true, content="true")
    _ => fail("expected error")
  }
}

///|
test "parse_jpeg2000_codestream_info minimal raw codestream" {
  // SOC + main header(SIZ/COD/QCD) + one tile-part(SOT/SOD/payload) + EOC.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.siz.width, content="4")
      inspect(info.siz.height, content="3")
      inspect(info.siz.num_components, content="1")
      inspect(info.siz.bits_per_component, content="8")
      inspect(info.siz.signed_components, content="false")
      inspect(info.has_cod, content="true")
      inspect(info.has_qcd, content="true")
      inspect(info.has_sod, content="true")
      inspect(info.num_tile_parts, content="1")
      inspect(info.has_eoc, content="true")
      inspect(info.cod_use_sop, content="false")
      inspect(info.cod_use_eph, content="false")
      inspect(info.first_packet_header_bit, content="0")
      inspect(info.first_packet_zero_bitplanes, content="0")
      inspect(info.first_packet_header_bytes, content="1")
      inspect(info.cod_progression_order, content="0")
      inspect(info.cod_num_layers, content="1")
      inspect(info.cod_num_decomposition_levels, content="0")
      inspect(info.cod_wavelet_transform, content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_jpeg2000_codestream_info minimal jp2 boxed stream" {
  // jp2 signature box + jp2c box containing the same minimal codestream.
  let codestream = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  let jp2 = b"\x00\x00\x00\x0CjP  \x0D\x0A\x87\x0A"
  let box_len = codestream.length() + 8
  let l0 = ((box_len >> 24) & 0xFF).to_byte()
  let l1 = ((box_len >> 16) & 0xFF).to_byte()
  let l2 = ((box_len >> 8) & 0xFF).to_byte()
  let l3 = (box_len & 0xFF).to_byte()
  let arr : Array[Byte] = []
  for b in jp2 {
    arr.push(b)
  }
  arr.push(l0)
  arr.push(l1)
  arr.push(l2)
  arr.push(l3)
  arr.push(b'j')
  arr.push(b'p')
  arr.push(b'2')
  arr.push(b'c')
  for b in codestream {
    arr.push(b)
  }
  let boxed = Bytes::from_array(arr)
  match parse_jpeg2000_codestream_info(boxed) {
    Ok(info) => {
      inspect(info.siz.width, content="4")
      inspect(info.siz.height, content="3")
      inspect(info.codestream_start > 0, content="true")
      inspect(info.has_eoc, content="true")
      inspect(info.first_packet_header_bit, content="0")
      inspect(info.first_packet_zero_bitplanes, content="0")
      inspect(info.first_packet_header_bytes, content="1")
      inspect(info.cod_num_layers, content="1")
    }
    Err(e) =>
      match e {
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info with SOP marker in packet data" {
  // COD with Scod SOP flag set; first packet in tile payload starts with SOP.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x02\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x15\x00\x01\xFF\x93\xFF\x91\x00\x04\x00\x00\x80\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.cod_use_sop, content="true")
      inspect(info.first_packet_header_bit, content="1")
      inspect(info.first_packet_zero_bitplanes, content="0")
      inspect(info.first_packet_header_bytes >= 7, content="true")
      inspect(info.has_sod, content="true")
      inspect(info.has_eoc, content="true")
      inspect(info.cod_num_layers, content="1")
    }
    Err(_) => fail("unexpected error")
  }
}
