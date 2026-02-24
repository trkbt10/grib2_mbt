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
  has_coc_for_component0 : Bool
  has_poc : Bool
  poc_entries : Array[Jpeg2000PocEntry]
  has_qcd : Bool
  has_rgn : Bool
  has_ppm : Bool
  ppm_packet_header_bytes : Array[Byte]
  has_tlm : Bool
  tlm_tile_part_lengths : Array[Int]
  has_sod : Bool
  num_tile_parts : Int
  has_ppt : Bool
  ppt_packet_header_bytes_per_tile_part : Array[Array[Byte]]
  ppt_present_per_tile_part : Array[Bool]
  has_plt : Bool
  plt_packet_lengths_per_tile_part : Array[Array[Int]]
  has_eoc : Bool
  cod_use_precincts : Bool
  cod_use_sop : Bool
  cod_use_eph : Bool
  first_packet_header_bit : Int
  first_packet_zero_bitplanes : Int
  first_packet_header_bytes : Int
  cod_progression_order : Int
  cod_num_layers : Int
  cod_multi_component_transform : Int
  cod_num_decomposition_levels : Int
  cod_wavelet_transform : Int
  cod_codeblock_style : Int
  cod_codeblock_width : Int
  cod_codeblock_height : Int
  cod_precinct_width_exponents : Array[Int]
  cod_precinct_height_exponents : Array[Int]
  quantization_style : Int
  quantization_guard_bits : Int
  quantization_exponents : Array[Int]
  quantization_mantissas : Array[Int]
  roi_shift : Int
  component_has_coc : Array[Bool]
  component_num_decomposition_levels : Array[Int]
  component_wavelet_transform : Array[Int]
  component_codeblock_style : Array[Int]
  component_codeblock_width : Array[Int]
  component_codeblock_height : Array[Int]
  component_precinct_width_exponents : Array[Array[Int]]
  component_precinct_height_exponents : Array[Array[Int]]
  component_has_qcc : Array[Bool]
  component_quantization_style : Array[Int]
  component_quantization_guard_bits : Array[Int]
  component_quantization_exponents : Array[Array[Int]]
  component_quantization_mantissas : Array[Array[Int]]
  component_has_rgn : Array[Bool]
  component_roi_shift : Array[Int]
  has_qcc_for_component0 : Bool
  tile_part_payload_starts : Array[Int]
  tile_part_payload_ends : Array[Int]
}

///|
priv struct Jpeg2000CodInfo {
  progression_order : Int
  num_layers : Int
  multiple_component_transform : Int
  num_decomposition_levels : Int
  wavelet_transform : Int
  use_precincts : Bool
  use_sop : Bool
  use_eph : Bool
  codeblock_style : Int
  codeblock_width : Int
  codeblock_height : Int
  precinct_width_exponents : Array[Int]
  precinct_height_exponents : Array[Int]
}

///|
priv struct Jpeg2000CocInfo {
  num_decomposition_levels : Int
  wavelet_transform : Int
  use_precincts : Bool
  codeblock_style : Int
  codeblock_width : Int
  codeblock_height : Int
  precinct_width_exponents : Array[Int]
  precinct_height_exponents : Array[Int]
}

///|
priv struct Jpeg2000PocEntry {
  start_resolution : Int
  start_component : Int
  end_layer_exclusive : Int
  end_resolution_exclusive : Int
  end_component_exclusive : Int
  progression_order : Int
}

///|
priv struct Jpeg2000QuantizationInfo {
  style : Int
  guard_bits : Int
  exponents : Array[Int]
  mantissas : Array[Int]
}

///|
priv struct Jpeg2000IndexedPacketHeaderBytes {
  index : Int
  bytes : Array[Byte]
}

///|
priv struct TilePartsInfo {
  num_tile_parts : Int
  has_sod : Bool
  has_ppt : Bool
  has_plt : Bool
  has_eoc : Bool
  first_packet_header_bit : Int
  first_packet_zero_bitplanes : Int
  first_packet_header_bytes : Int
  tile_part_lengths : Array[Int]
  ppt_packet_header_bytes_per_tile_part : Array[Array[Byte]]
  ppt_present_per_tile_part : Array[Bool]
  plt_packet_lengths_per_tile_part : Array[Array[Int]]
  payload_starts : Array[Int]
  tile_ends : Array[Int]
}

///|
fn reorder_indexed_packet_header_bytes(
  segments : Array[Jpeg2000IndexedPacketHeaderBytes],
  marker_name : String,
) -> Result[Array[Byte], UnpackError] {
  if segments.length() == 0 {
    return Ok([])
  }
  let ordered : Array[Array[Byte]] = Array::make(256, [])
  let present : Array[Bool] = Array::make(256, false)
  let mut max_index = -1
  for segment in segments {
    if segment.index < 0 || segment.index > 255 {
      return Err(
        UnsupportedTemplate(
          "\{marker_name} index out of range: \{segment.index}",
        ),
      )
    }
    if present[segment.index] {
      return Err(
        UnsupportedTemplate("duplicate \{marker_name} index: \{segment.index}"),
      )
    }
    present[segment.index] = true
    ordered[segment.index] = segment.bytes
    if segment.index > max_index {
      max_index = segment.index
    }
  }
  for i = 0; i <= max_index; i = i + 1 {
    if !present[i] {
      return Err(
        UnsupportedTemplate("\{marker_name} index sequence has gap at \{i}"),
      )
    }
  }
  let result : Array[Byte] = []
  for i = 0; i <= max_index; i = i + 1 {
    for b in ordered[i] {
      result.push(b)
    }
  }
  Ok(result)
}

///|
fn parse_quantization_parameters(
  sqx : Int,
  step_data : Bytes,
) -> Result[Jpeg2000QuantizationInfo, UnpackError] {
  let style = sqx & 0x1F
  let guard_bits = (sqx >> 5) & 0x07
  let exponents : Array[Int] = []
  let mantissas : Array[Int] = []
  if style == 0 {
    for i = 0; i < step_data.length(); i = i + 1 {
      let sp = step_data[i].to_uint().reinterpret_as_int()
      exponents.push((sp >> 3) & 0x1F)
      mantissas.push(0)
    }
  } else if style == 1 || style == 2 {
    if step_data.length() % 2 != 0 {
      return Err(
        UnsupportedTemplate(
          "quantization step data length must be even for style \{style}",
        ),
      )
    }
    if style == 1 && step_data.length() > 2 {
      return Err(
        UnsupportedTemplate(
          "derived quantization style must have at most one step-size entry",
        ),
      )
    }
    let mut i = 0
    while i + 1 < step_data.length() {
      let word = (step_data[i].to_uint().reinterpret_as_int() << 8) |
        step_data[i + 1].to_uint().reinterpret_as_int()
      exponents.push((word >> 11) & 0x1F)
      mantissas.push(word & 0x07FF)
      i += 2
    }
  } else {
    return Err(UnsupportedTemplate("unsupported quantization style: \{style}"))
  }
  Ok({ style, guard_bits, exponents, mantissas })
}

///|
fn parse_qcd_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
) -> Result[Jpeg2000QuantizationInfo, UnpackError] {
  if segment_len < 3 {
    return Err(UnsupportedTemplate("QCD segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("QCD segment is truncated"))
  }
  let sqcd = data[payload_start + 2].to_uint().reinterpret_as_int()
  let step_data = data
    .sub(start=payload_start + 3, end=payload_start + segment_len)
    .to_bytes()
  parse_quantization_parameters(sqcd, step_data)
}

///|
fn parse_qcc_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
  num_components : Int,
) -> Result[(Int, Jpeg2000QuantizationInfo), UnpackError] {
  let cqcc_len = if num_components < 257 { 1 } else { 2 }
  if segment_len < 3 + cqcc_len {
    return Err(UnsupportedTemplate("QCC segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("QCC segment is truncated"))
  }
  let component = if cqcc_len == 1 {
    data[payload_start + 2].to_uint().reinterpret_as_int()
  } else {
    jp2_read_u16_be(data, payload_start + 2)
  }
  let sqcc_offset = payload_start + 2 + cqcc_len
  let sqcc = data[sqcc_offset].to_uint().reinterpret_as_int()
  let step_data = data
    .sub(start=sqcc_offset + 1, end=payload_start + segment_len)
    .to_bytes()
  let quant = match parse_quantization_parameters(sqcc, step_data) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok((component, quant))
}

///|
fn parse_rgn_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
  num_components : Int,
) -> Result[(Int, Int), UnpackError] {
  let crgn_len = if num_components < 257 { 1 } else { 2 }
  let expected_len = 4 + crgn_len
  if segment_len < expected_len {
    return Err(UnsupportedTemplate("RGN segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("RGN segment is truncated"))
  }
  if segment_len != expected_len {
    return Err(
      UnsupportedTemplate(
        "RGN segment length mismatch: expected \{expected_len}, got \{segment_len}",
      ),
    )
  }
  let component = if crgn_len == 1 {
    data[payload_start + 2].to_uint().reinterpret_as_int()
  } else {
    jp2_read_u16_be(data, payload_start + 2)
  }
  let srgn_offset = payload_start + 2 + crgn_len
  let srgn = data[srgn_offset].to_uint().reinterpret_as_int()
  if srgn != 0 {
    return Err(UnsupportedTemplate("unsupported RGN style: \{srgn}"))
  }
  let roi_shift = data[srgn_offset + 1].to_uint().reinterpret_as_int()
  Ok((component, roi_shift))
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
  let multiple_component_transform = data[payload_start + 6]
    .to_uint()
    .reinterpret_as_int()
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
  if multiple_component_transform < 0 || multiple_component_transform > 1 {
    return Err(
      UnsupportedTemplate(
        "unsupported COD multi-component transform: \{multiple_component_transform}",
      ),
    )
  }
  if codeblock_width_raw > 10 || codeblock_height_raw > 10 {
    return Err(UnsupportedTemplate("COD codeblock raw size out of range"))
  }
  if (codeblock_style & 0xC0) != 0 {
    return Err(UnsupportedTemplate("COD codeblock style has reserved bits set"))
  }
  let codeblock_width = 1 << (codeblock_width_raw + 2)
  let codeblock_height = 1 << (codeblock_height_raw + 2)
  let precinct_width_exponents : Array[Int] = []
  let precinct_height_exponents : Array[Int] = []
  if use_precincts {
    for i = 0; i < num_decomposition_levels + 1; i = i + 1 {
      let sp = data[payload_start + 12 + i].to_uint().reinterpret_as_int()
      let ppx = sp & 0x0F
      let ppy = (sp >> 4) & 0x0F
      precinct_width_exponents.push(ppx)
      precinct_height_exponents.push(ppy)
    }
  } else {
    for _i = 0; _i < num_decomposition_levels + 1; _i = _i + 1 {
      // Default precinct size 2^15 when Scod precinct flag is not set.
      precinct_width_exponents.push(15)
      precinct_height_exponents.push(15)
    }
  }
  Ok({
    progression_order,
    num_layers,
    multiple_component_transform,
    num_decomposition_levels,
    wavelet_transform,
    use_precincts,
    use_sop,
    use_eph,
    codeblock_style,
    codeblock_width,
    codeblock_height,
    precinct_width_exponents,
    precinct_height_exponents,
  })
}

///|
fn parse_coc_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
  num_components : Int,
) -> Result[(Int, Jpeg2000CocInfo), UnpackError] {
  let ccoc_len = if num_components < 257 { 1 } else { 2 }
  if segment_len < 8 + ccoc_len {
    return Err(UnsupportedTemplate("COC segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("COC segment is truncated"))
  }
  let component = if ccoc_len == 1 {
    data[payload_start + 2].to_uint().reinterpret_as_int()
  } else {
    jp2_read_u16_be(data, payload_start + 2)
  }
  let scoc_offset = payload_start + 2 + ccoc_len
  let scoc = data[scoc_offset].to_uint().reinterpret_as_int()
  let num_decomposition_levels = data[scoc_offset + 1]
    .to_uint()
    .reinterpret_as_int()
  let codeblock_width_raw = data[scoc_offset + 2].to_uint().reinterpret_as_int()
  let codeblock_height_raw = data[scoc_offset + 3]
    .to_uint()
    .reinterpret_as_int()
  let codeblock_style = data[scoc_offset + 4].to_uint().reinterpret_as_int()
  let wavelet_transform = data[scoc_offset + 5].to_uint().reinterpret_as_int()
  if codeblock_width_raw > 10 || codeblock_height_raw > 10 {
    return Err(UnsupportedTemplate("COC codeblock raw size out of range"))
  }
  if (codeblock_style & 0xC0) != 0 {
    return Err(UnsupportedTemplate("COC codeblock style has reserved bits set"))
  }
  let use_precincts = (scoc & 0x01) != 0
  let expected_len = if use_precincts {
    8 + ccoc_len + num_decomposition_levels + 1
  } else {
    8 + ccoc_len
  }
  if segment_len != expected_len {
    return Err(
      UnsupportedTemplate(
        "COC segment length mismatch: expected \{expected_len}, got \{segment_len}",
      ),
    )
  }
  let precinct_width_exponents : Array[Int] = []
  let precinct_height_exponents : Array[Int] = []
  if use_precincts {
    for i = 0; i < num_decomposition_levels + 1; i = i + 1 {
      let sp = data[scoc_offset + 6 + i].to_uint().reinterpret_as_int()
      precinct_width_exponents.push(sp & 0x0F)
      precinct_height_exponents.push((sp >> 4) & 0x0F)
    }
  } else {
    for _i = 0; _i < num_decomposition_levels + 1; _i = _i + 1 {
      precinct_width_exponents.push(15)
      precinct_height_exponents.push(15)
    }
  }
  Ok(
    (
      component,
      {
        num_decomposition_levels,
        wavelet_transform,
        use_precincts,
        codeblock_style,
        codeblock_width: 1 << (codeblock_width_raw + 2),
        codeblock_height: 1 << (codeblock_height_raw + 2),
        precinct_width_exponents,
        precinct_height_exponents,
      },
    ),
  )
}

///|
fn parse_poc_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
  num_components : Int,
) -> Result[Array[Jpeg2000PocEntry], UnpackError] {
  if segment_len < 2 {
    return Err(UnsupportedTemplate("POC segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("POC segment is truncated"))
  }
  let component_field_len = if num_components < 257 { 1 } else { 2 }
  let entry_len = 1 + component_field_len + 2 + 1 + component_field_len + 1
  let payload_len = segment_len - 2
  if payload_len <= 0 || payload_len % entry_len != 0 {
    return Err(
      UnsupportedTemplate(
        "invalid POC segment length: payload=\{payload_len}, entry_len=\{entry_len}",
      ),
    )
  }
  let entries : Array[Jpeg2000PocEntry] = []
  let mut p = payload_start + 2
  while p + entry_len <= payload_start + segment_len {
    let rs = data[p].to_uint().reinterpret_as_int()
    p += 1
    let cs = if component_field_len == 1 {
      let v = data[p].to_uint().reinterpret_as_int()
      p += 1
      v
    } else {
      let v = jp2_read_u16_be(data, p)
      p += 2
      v
    }
    let lye = jp2_read_u16_be(data, p)
    p += 2
    let re = data[p].to_uint().reinterpret_as_int()
    p += 1
    let ce = if component_field_len == 1 {
      let v = data[p].to_uint().reinterpret_as_int()
      p += 1
      v
    } else {
      let v = jp2_read_u16_be(data, p)
      p += 2
      v
    }
    let ppoc = data[p].to_uint().reinterpret_as_int()
    p += 1
    if ppoc < 0 || ppoc > 4 {
      return Err(
        UnsupportedTemplate("POC progression order out of range: \{ppoc}"),
      )
    }
    entries.push({
      start_resolution: rs,
      start_component: cs,
      end_layer_exclusive: lye,
      end_resolution_exclusive: re,
      end_component_exclusive: ce,
      progression_order: ppoc,
    })
  }
  Ok(entries)
}

///|
fn parse_tlm_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
) -> Result[Array[Int], UnpackError] {
  if segment_len < 4 {
    return Err(UnsupportedTemplate("TLM segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("TLM segment is truncated"))
  }
  let stlm = data[payload_start + 3].to_uint().reinterpret_as_int()
  let tile_index_size_code = (stlm >> 4) & 0x03
  let tile_index_size = if tile_index_size_code == 0 {
    0
  } else if tile_index_size_code == 1 {
    1
  } else if tile_index_size_code == 2 {
    2
  } else {
    return Err(
      UnsupportedTemplate(
        "unsupported TLM tile index size code: \{tile_index_size_code}",
      ),
    )
  }
  let tile_part_length_size_flag = (stlm >> 6) & 0x01
  let tile_part_length_size = if tile_part_length_size_flag == 0 {
    2
  } else {
    4
  }
  let entry_len = tile_index_size + tile_part_length_size
  let payload_len = segment_len - 4
  if payload_len <= 0 || entry_len <= 0 || payload_len % entry_len != 0 {
    return Err(
      UnsupportedTemplate(
        "invalid TLM payload length: payload=\{payload_len}, entry_len=\{entry_len}",
      ),
    )
  }
  let lengths : Array[Int] = []
  let mut p = payload_start + 4
  while p + entry_len <= payload_start + segment_len {
    if tile_index_size == 1 {
      p += 1
    } else if tile_index_size == 2 {
      p += 2
    }
    let tile_part_len = if tile_part_length_size == 2 {
      jp2_read_u16_be(data, p)
    } else {
      jp2_read_u32_be(data, p)
    }
    p += tile_part_length_size
    if tile_part_len <= 0 {
      return Err(
        UnsupportedTemplate("invalid TLM tile-part length: \{tile_part_len}"),
      )
    }
    lengths.push(tile_part_len)
  }
  Ok(lengths)
}

///|
fn parse_plt_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
) -> Result[Array[Int], UnpackError] {
  if segment_len < 3 {
    return Err(UnsupportedTemplate("PLT segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("PLT segment is truncated"))
  }
  let lengths : Array[Int] = []
  let mut p = payload_start + 3 // skip Zplt
  let mut current_len = 0
  while p < payload_start + segment_len {
    let v = data[p].to_uint().reinterpret_as_int()
    p += 1
    let low7 = v & 0x7F
    if current_len > 0x0FFFFFFF {
      return Err(UnsupportedTemplate("PLT packet length overflow"))
    }
    current_len = (current_len << 7) | low7
    if (v & 0x80) == 0 {
      lengths.push(current_len)
      current_len = 0
    }
  }
  if current_len != 0 {
    return Err(InsufficientData("PLT packet length is truncated"))
  }
  Ok(lengths)
}

///|
fn parse_ppt_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
) -> Result[Jpeg2000IndexedPacketHeaderBytes, UnpackError] {
  if segment_len < 3 {
    return Err(UnsupportedTemplate("PPT segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("PPT segment is truncated"))
  }
  let zppt = data[payload_start + 2].to_uint().reinterpret_as_int()
  let bytes : Array[Byte] = []
  for
    b in data
    .sub(start=payload_start + 3, end=payload_start + segment_len)
    .to_bytes() {
    bytes.push(b)
  }
  Ok({ index: zppt, bytes })
}

///|
fn parse_ppm_segment(
  data : Bytes,
  payload_start : Int,
  segment_len : Int,
) -> Result[Jpeg2000IndexedPacketHeaderBytes, UnpackError] {
  if segment_len < 7 {
    return Err(UnsupportedTemplate("PPM segment is too short"))
  }
  if payload_start + segment_len > data.length() {
    return Err(InsufficientData("PPM segment is truncated"))
  }
  let zppm = data[payload_start + 2].to_uint().reinterpret_as_int()
  let bytes : Array[Byte] = []
  let mut p = payload_start + 3 // skip Zppm
  let end = payload_start + segment_len
  while p < end {
    if p + 4 > end {
      return Err(InsufficientData("PPM Nppm field is truncated"))
    }
    let nppm = jp2_read_u32_be(data, p)
    p += 4
    if nppm < 0 {
      return Err(UnsupportedTemplate("invalid PPM Nppm value: \{nppm}"))
    }
    if p + nppm > end {
      return Err(InsufficientData("PPM packet header data is truncated"))
    }
    for b in data.sub(start=p, end=p + nppm).to_bytes() {
      bytes.push(b)
    }
    p += nppm
  }
  Ok({ index: zppm, bytes })
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
  let mut first_box = true
  let mut seen_signature = false
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
    if first_box {
      if tbox != b"jP  " {
        return Err(UnsupportedTemplate("invalid JP2 signature box type"))
      }
      if box_header_len != 8 || box_len != 12 {
        return Err(UnsupportedTemplate("invalid JP2 signature box length"))
      }
      let signature = data.sub(start=offset + 8, end=offset + 12).to_bytes()
      if signature != b"\x0D\x0A\x87\x0A" {
        return Err(UnsupportedTemplate("invalid JP2 signature box payload"))
      }
      seen_signature = true
    }
    if tbox == b"jp2c" {
      if !seen_signature {
        return Err(UnsupportedTemplate("JP2 stream missing signature box"))
      }
      return Ok(offset + box_header_len)
    }
    offset += box_len
    first_box = false
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
  use_eph : Bool,
) -> Result[TilePartsInfo, UnpackError] {
  let mut offset = first_sot_offset
  let mut num_tile_parts = 0
  let mut seen_sod = false
  let mut seen_ppt = false
  let mut seen_plt = false
  let mut seen_eoc = false
  let mut first_packet_header_bit = -1
  let mut first_packet_zero_bitplanes = -1
  let mut first_packet_header_bytes = -1
  let tile_part_lengths : Array[Int] = []
  let ppt_packet_header_bytes_per_tile_part : Array[Array[Byte]] = []
  let ppt_present_per_tile_part : Array[Bool] = []
  let plt_packet_lengths_per_tile_part : Array[Array[Int]] = []
  let payload_starts : Array[Int] = []
  let tile_ends : Array[Int] = []
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
    let (
      payload_start,
      tile_has_ppt,
      tile_ppt_packet_header_bytes,
      tile_has_plt,
      tile_plt_packet_lengths,
    ) = match find_tile_part_payload_start(data, offset + 12, tile_end) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let packet_probe = match
      probe_first_packet_header(
        data.sub(start=payload_start, end=tile_end).to_bytes(),
        use_sop,
        use_eph,
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    if first_packet_header_bit < 0 {
      first_packet_header_bit = packet_probe.first_inclusion_bit
      first_packet_zero_bitplanes = packet_probe.zero_bitplanes
      first_packet_header_bytes = packet_probe.bytes_consumed
    }
    if tile_has_ppt {
      seen_ppt = true
    }
    if tile_has_plt {
      seen_plt = true
    }
    tile_part_lengths.push(psot)
    ppt_packet_header_bytes_per_tile_part.push(tile_ppt_packet_header_bytes)
    ppt_present_per_tile_part.push(tile_has_ppt)
    plt_packet_lengths_per_tile_part.push(tile_plt_packet_lengths)
    payload_starts.push(payload_start)
    tile_ends.push(tile_end)
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
    has_ppt: seen_ppt,
    has_plt: seen_plt,
    has_eoc: seen_eoc,
    first_packet_header_bit,
    first_packet_zero_bitplanes,
    first_packet_header_bytes,
    tile_part_lengths,
    ppt_packet_header_bytes_per_tile_part,
    ppt_present_per_tile_part,
    plt_packet_lengths_per_tile_part,
    payload_starts,
    tile_ends,
  })
}

///|
fn find_tile_part_payload_start(
  data : Bytes,
  header_start : Int,
  tile_end : Int,
) -> Result[(Int, Bool, Array[Byte], Bool, Array[Int]), UnpackError] {
  let mut p = header_start
  let mut has_ppt = false
  let ppt_segments : Array[Jpeg2000IndexedPacketHeaderBytes] = []
  let mut tile_seen_sod = false
  let mut has_plt = false
  let plt_packet_lengths : Array[Int] = []
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
    if marker == 0xFF61 {
      let segment = match parse_ppt_segment(data, p, segment_len) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      has_ppt = true
      ppt_segments.push(segment)
    } else if marker == 0xFF58 {
      let lengths = match parse_plt_segment(data, p, segment_len) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      has_plt = true
      for len in lengths {
        plt_packet_lengths.push(len)
      }
    }
    p += segment_len
  }
  if !tile_seen_sod {
    return Err(UnsupportedTemplate("tile-part missing SOD marker"))
  }
  let ppt_packet_header_bytes = match
    reorder_indexed_packet_header_bytes(ppt_segments, "PPT/Zppt") {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok((p, has_ppt, ppt_packet_header_bytes, has_plt, plt_packet_lengths))
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
  let mut has_coc_for_component0 = false
  let mut has_poc = false
  let mut has_qcd = false
  let mut has_rgn = false
  let mut has_ppm = false
  let ppm_packet_header_bytes : Array[Byte] = []
  let ppm_segments : Array[Jpeg2000IndexedPacketHeaderBytes] = []
  let mut has_tlm = false
  let tlm_tile_part_lengths : Array[Int] = []
  let mut has_qcc_for_component0 = false
  let mut parsed_tile_parts : TilePartsInfo? = None
  let mut parsed_cod : Jpeg2000CodInfo? = None
  let mut parsed_qcd : Jpeg2000QuantizationInfo? = None
  let mut parsed_qcc_by_component : Array[Jpeg2000QuantizationInfo?] = []
  let mut parsed_coc_by_component : Array[Jpeg2000CocInfo?] = []
  let mut parsed_rgn_roi_shift_by_component : Array[Int] = []
  let mut parsed_has_rgn_by_component : Array[Bool] = []
  let poc_entries : Array[Jpeg2000PocEntry] = []
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
        parse_tile_parts(data, marker_offset, cod.use_sop, cod.use_eph) {
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
      parsed_qcc_by_component = Array::make(siz.num_components, None)
      parsed_coc_by_component = Array::make(siz.num_components, None)
      parsed_rgn_roi_shift_by_component = Array::make(siz.num_components, 0)
      parsed_has_rgn_by_component = Array::make(siz.num_components, false)
      parsed_siz = Some(siz)
    } else if marker == 0xFF52 {
      has_cod = true
      let cod = match parse_cod_segment(data, offset, segment_len) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      parsed_cod = Some(cod)
    } else if marker == 0xFF53 {
      let siz = match parsed_siz {
        Some(v) => v
        None =>
          return Err(
            UnsupportedTemplate("COC marker requires SIZ to appear first"),
          )
      }
      let (component, coc) = match
        parse_coc_segment(data, offset, segment_len, siz.num_components) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      if component < 0 || component >= siz.num_components {
        return Err(
          UnsupportedTemplate(
            "COC component index out of range: \{component}/\{siz.num_components}",
          ),
        )
      }
      if component == 0 {
        has_coc_for_component0 = true
      }
      if component < parsed_coc_by_component.length() {
        parsed_coc_by_component[component] = Some(coc)
      }
    } else if marker == 0xFF5F {
      let siz = match parsed_siz {
        Some(v) => v
        None =>
          return Err(
            UnsupportedTemplate("POC marker requires SIZ to appear first"),
          )
      }
      let parsed_entries = match
        parse_poc_segment(data, offset, segment_len, siz.num_components) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      if parsed_entries.length() <= 0 {
        return Err(UnsupportedTemplate("POC marker has no entries"))
      }
      for entry in parsed_entries {
        poc_entries.push(entry)
      }
      has_poc = true
    } else if marker == 0xFF5E {
      let siz = match parsed_siz {
        Some(v) => v
        None =>
          return Err(
            UnsupportedTemplate("RGN marker requires SIZ to appear first"),
          )
      }
      let (component, roi_shift) = match
        parse_rgn_segment(data, offset, segment_len, siz.num_components) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      if component < 0 || component >= siz.num_components {
        return Err(
          UnsupportedTemplate(
            "RGN component index out of range: \{component}/\{siz.num_components}",
          ),
        )
      }
      if component < parsed_rgn_roi_shift_by_component.length() {
        parsed_rgn_roi_shift_by_component[component] = roi_shift
      }
      if component < parsed_has_rgn_by_component.length() {
        parsed_has_rgn_by_component[component] = true
      }
      has_rgn = true
    } else if marker == 0xFF60 {
      let segment = match parse_ppm_segment(data, offset, segment_len) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      ppm_segments.push(segment)
      has_ppm = true
    } else if marker == 0xFF55 {
      let lengths = match parse_tlm_segment(data, offset, segment_len) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      for len in lengths {
        tlm_tile_part_lengths.push(len)
      }
      has_tlm = true
    } else if marker == 0xFF5C {
      has_qcd = true
      let qcd = match parse_qcd_segment(data, offset, segment_len) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      parsed_qcd = Some(qcd)
    } else if marker == 0xFF5D {
      let siz = match parsed_siz {
        Some(v) => v
        None =>
          return Err(
            UnsupportedTemplate("QCC marker requires SIZ to appear first"),
          )
      }
      let (component, qcc) = match
        parse_qcc_segment(data, offset, segment_len, siz.num_components) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      if component < 0 || component >= siz.num_components {
        return Err(
          UnsupportedTemplate(
            "QCC component index out of range: \{component}/\{siz.num_components}",
          ),
        )
      }
      if component == 0 {
        has_qcc_for_component0 = true
      }
      if component < parsed_qcc_by_component.length() {
        parsed_qcc_by_component[component] = Some(qcc)
      }
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
  if has_tlm {
    if tlm_tile_part_lengths.length() != tile_parts.tile_part_lengths.length() {
      return Err(
        UnsupportedTemplate(
          "TLM tile-part count mismatch: tlm=\{tlm_tile_part_lengths.length()}, parsed=\{tile_parts.tile_part_lengths.length()}",
        ),
      )
    }
    for i = 0; i < tlm_tile_part_lengths.length(); i = i + 1 {
      if tlm_tile_part_lengths[i] != tile_parts.tile_part_lengths[i] {
        return Err(
          UnsupportedTemplate(
            "TLM tile-part length mismatch at \{i}: tlm=\{tlm_tile_part_lengths[i]}, parsed=\{tile_parts.tile_part_lengths[i]}",
          ),
        )
      }
    }
  }
  if has_ppm {
    let ordered_ppm_bytes = match
      reorder_indexed_packet_header_bytes(ppm_segments, "PPM/Zppm") {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    for b in ordered_ppm_bytes {
      ppm_packet_header_bytes.push(b)
    }
  }
  let base_quant = match parsed_qcd {
    Some(v) => v
    None => { style: 0, guard_bits: 0, exponents: [], mantissas: [] }
  }
  let base_cod = match parsed_cod {
    Some(v) => v
    None =>
      {
        progression_order: 0,
        num_layers: 0,
        multiple_component_transform: 0,
        num_decomposition_levels: 0,
        wavelet_transform: 0,
        use_precincts: false,
        use_sop: false,
        use_eph: false,
        codeblock_style: 0,
        codeblock_width: 0,
        codeblock_height: 0,
        precinct_width_exponents: [],
        precinct_height_exponents: [],
      }
  }
  let component_has_coc : Array[Bool] = []
  let component_num_decomposition_levels : Array[Int] = []
  let component_wavelet_transform : Array[Int] = []
  let component_use_precincts : Array[Bool] = []
  let component_codeblock_style : Array[Int] = []
  let component_codeblock_width : Array[Int] = []
  let component_codeblock_height : Array[Int] = []
  let component_precinct_width_exponents : Array[Array[Int]] = []
  let component_precinct_height_exponents : Array[Array[Int]] = []
  let component_has_qcc : Array[Bool] = []
  let component_quantization_style : Array[Int] = []
  let component_quantization_guard_bits : Array[Int] = []
  let component_quantization_exponents : Array[Array[Int]] = []
  let component_quantization_mantissas : Array[Array[Int]] = []
  let component_has_rgn : Array[Bool] = []
  let component_roi_shift : Array[Int] = []
  for component = 0; component < siz.num_components; component = component + 1 {
    let component_coc = if component < parsed_coc_by_component.length() {
      parsed_coc_by_component[component]
    } else {
      None
    }
    let effective_component_cod = match component_coc {
      Some(coc) =>
        {
          progression_order: base_cod.progression_order,
          num_layers: base_cod.num_layers,
          multiple_component_transform: base_cod.multiple_component_transform,
          num_decomposition_levels: coc.num_decomposition_levels,
          wavelet_transform: coc.wavelet_transform,
          use_precincts: coc.use_precincts,
          use_sop: base_cod.use_sop,
          use_eph: base_cod.use_eph,
          codeblock_style: coc.codeblock_style,
          codeblock_width: coc.codeblock_width,
          codeblock_height: coc.codeblock_height,
          precinct_width_exponents: coc.precinct_width_exponents,
          precinct_height_exponents: coc.precinct_height_exponents,
        }
      None => base_cod
    }
    if effective_component_cod.wavelet_transform != 0 &&
      effective_component_cod.wavelet_transform != 1 {
      return Err(
        UnsupportedTemplate(
          "unsupported COC wavelet transform at component \{component}: \{effective_component_cod.wavelet_transform}",
        ),
      )
    }
    component_has_coc.push(
      match component_coc {
        Some(_) => true
        None => false
      },
    )
    component_num_decomposition_levels.push(
      effective_component_cod.num_decomposition_levels,
    )
    component_wavelet_transform.push(effective_component_cod.wavelet_transform)
    component_use_precincts.push(effective_component_cod.use_precincts)
    component_codeblock_style.push(effective_component_cod.codeblock_style)
    component_codeblock_width.push(effective_component_cod.codeblock_width)
    component_codeblock_height.push(effective_component_cod.codeblock_height)
    component_precinct_width_exponents.push(
      effective_component_cod.precinct_width_exponents,
    )
    component_precinct_height_exponents.push(
      effective_component_cod.precinct_height_exponents,
    )

    let component_qcc = if component < parsed_qcc_by_component.length() {
      parsed_qcc_by_component[component]
    } else {
      None
    }
    let effective_component_quant = match component_qcc {
      Some(q) => q
      None => base_quant
    }
    component_has_qcc.push(
      match component_qcc {
        Some(_) => true
        None => false
      },
    )
    component_quantization_style.push(effective_component_quant.style)
    component_quantization_guard_bits.push(effective_component_quant.guard_bits)
    component_quantization_exponents.push(effective_component_quant.exponents)
    component_quantization_mantissas.push(effective_component_quant.mantissas)
    component_has_rgn.push(
      if component < parsed_has_rgn_by_component.length() {
        parsed_has_rgn_by_component[component]
      } else {
        false
      },
    )
    component_roi_shift.push(
      if component < parsed_rgn_roi_shift_by_component.length() {
        parsed_rgn_roi_shift_by_component[component]
      } else {
        0
      },
    )
  }
  has_coc_for_component0 = component_has_coc[0]
  has_qcc_for_component0 = component_has_qcc[0]
  let quant = {
    style: component_quantization_style[0],
    guard_bits: component_quantization_guard_bits[0],
    exponents: component_quantization_exponents[0],
    mantissas: component_quantization_mantissas[0],
  }
  Ok({
    codestream_start: start,
    siz,
    has_cod,
    has_coc_for_component0,
    has_poc,
    poc_entries,
    has_qcd,
    has_rgn,
    has_ppm,
    ppm_packet_header_bytes,
    has_tlm,
    tlm_tile_part_lengths,
    has_sod: tile_parts.has_sod,
    num_tile_parts: tile_parts.num_tile_parts,
    has_ppt: tile_parts.has_ppt,
    ppt_packet_header_bytes_per_tile_part: tile_parts.ppt_packet_header_bytes_per_tile_part,
    ppt_present_per_tile_part: tile_parts.ppt_present_per_tile_part,
    has_plt: tile_parts.has_plt,
    plt_packet_lengths_per_tile_part: tile_parts.plt_packet_lengths_per_tile_part,
    has_eoc: tile_parts.has_eoc,
    cod_use_precincts: component_use_precincts[0],
    cod_use_sop: base_cod.use_sop,
    cod_use_eph: base_cod.use_eph,
    first_packet_header_bit: tile_parts.first_packet_header_bit,
    first_packet_zero_bitplanes: tile_parts.first_packet_zero_bitplanes,
    first_packet_header_bytes: tile_parts.first_packet_header_bytes,
    cod_progression_order: base_cod.progression_order,
    cod_num_layers: base_cod.num_layers,
    cod_multi_component_transform: base_cod.multiple_component_transform,
    cod_num_decomposition_levels: component_num_decomposition_levels[0],
    cod_wavelet_transform: component_wavelet_transform[0],
    cod_codeblock_style: component_codeblock_style[0],
    cod_codeblock_width: component_codeblock_width[0],
    cod_codeblock_height: component_codeblock_height[0],
    cod_precinct_width_exponents: component_precinct_width_exponents[0],
    cod_precinct_height_exponents: component_precinct_height_exponents[0],
    quantization_style: quant.style,
    quantization_guard_bits: quant.guard_bits,
    quantization_exponents: quant.exponents,
    quantization_mantissas: quant.mantissas,
    roi_shift: component_roi_shift[0],
    component_has_coc,
    component_num_decomposition_levels,
    component_wavelet_transform,
    component_codeblock_style,
    component_codeblock_width,
    component_codeblock_height,
    component_precinct_width_exponents,
    component_precinct_height_exponents,
    component_has_qcc,
    component_quantization_style,
    component_quantization_guard_bits,
    component_quantization_exponents,
    component_quantization_mantissas,
    component_has_rgn,
    component_roi_shift,
    has_qcc_for_component0,
    tile_part_payload_starts: tile_parts.payload_starts,
    tile_part_payload_ends: tile_parts.tile_ends,
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
      inspect(info.cod_multi_component_transform, content="0")
      inspect(info.cod_num_decomposition_levels, content="0")
      inspect(info.cod_wavelet_transform, content="0")
      inspect(info.cod_codeblock_style, content="0")
      inspect(info.cod_codeblock_width, content="4")
      inspect(info.cod_codeblock_height, content="4")
      inspect(info.quantization_style, content="0")
      inspect(info.quantization_guard_bits, content="0")
      inspect(info.has_coc_for_component0, content="false")
      inspect(info.has_poc, content="false")
      inspect(info.poc_entries.length(), content="0")
      inspect(info.has_qcc_for_component0, content="false")
      inspect(info.has_rgn, content="false")
      inspect(info.roi_shift, content="0")
      inspect(info.has_ppm, content="false")
      inspect(info.ppm_packet_header_bytes.length(), content="0")
      inspect(info.has_tlm, content="false")
      inspect(info.tlm_tile_part_lengths.length(), content="0")
      inspect(info.has_ppt, content="false")
      inspect(info.ppt_packet_header_bytes_per_tile_part.length(), content="1")
      inspect(
        info.ppt_packet_header_bytes_per_tile_part[0].length(),
        content="0",
      )
      inspect(info.has_plt, content="false")
      inspect(info.plt_packet_lengths_per_tile_part.length(), content="1")
      inspect(info.plt_packet_lengths_per_tile_part[0].length(), content="0")
      inspect(info.component_has_coc.length(), content="1")
      inspect(info.component_has_coc[0], content="false")
      inspect(info.component_has_qcc[0], content="false")
      inspect(info.component_has_rgn[0], content="false")
      inspect(info.component_roi_shift[0], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_jpeg2000_codestream_info parses and validates TLM" {
  // Add TLM with one 4-byte tile-part length entry matching Psot=15.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x55\x00\x08\x00\x40\x00\x00\x00\x0F\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_tlm, content="true")
      inspect(info.tlm_tile_part_lengths.length(), content="1")
      inspect(info.tlm_tile_part_lengths[0], content="15")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info parses PPM packet headers" {
  // PPM with one Nppm=1 byte payload.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x60\x00\x08\x00\x00\x00\x00\x01\x80\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_ppm, content="true")
      inspect(info.ppm_packet_header_bytes.length(), content="1")
      inspect(
        info.ppm_packet_header_bytes[0].to_uint().reinterpret_as_int(),
        content="128",
      )
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info reorders PPM by Zppm" {
  // PPM Z=1 then Z=0 in stream order; parser must reorder to [0x11, 0x22].
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x60\x00\x08\x01\x00\x00\x00\x01\x22\xFF\x60\x00\x08\x00\x00\x00\x00\x01\x11\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_ppm, content="true")
      inspect(info.ppm_packet_header_bytes.length(), content="2")
      inspect(
        info.ppm_packet_header_bytes[0].to_uint().reinterpret_as_int(),
        content="17",
      )
      inspect(
        info.ppm_packet_header_bytes[1].to_uint().reinterpret_as_int(),
        content="34",
      )
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info rejects duplicate PPM Zppm index" {
  // Two PPM segments with same Zppm=0 should fail.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x60\x00\x08\x00\x00\x00\x00\x01\x22\xFF\x60\x00\x08\x00\x00\x00\x00\x01\x11\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate")
  }
}

///|
test "parse_jpeg2000_codestream_info parses PPT packet headers" {
  // PPT(Z=0, one header byte 0x80) in tile-part header.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x15\x00\x01\xFF\x61\x00\x04\x00\x80\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_ppt, content="true")
      inspect(info.ppt_packet_header_bytes_per_tile_part.length(), content="1")
      inspect(
        info.ppt_packet_header_bytes_per_tile_part[0].length(),
        content="1",
      )
      inspect(
        info.ppt_packet_header_bytes_per_tile_part[0][0]
        .to_uint()
        .reinterpret_as_int(),
        content="128",
      )
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info reorders PPT by Zppt in tile-part" {
  // PPT Z=1 then Z=0 in tile-part header; parser must reorder to [0x11, 0x22].
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x1B\x00\x01\xFF\x61\x00\x04\x01\x22\xFF\x61\x00\x04\x00\x11\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_ppt, content="true")
      inspect(info.ppt_packet_header_bytes_per_tile_part.length(), content="1")
      inspect(
        info.ppt_packet_header_bytes_per_tile_part[0].length(),
        content="2",
      )
      inspect(
        info.ppt_packet_header_bytes_per_tile_part[0][0]
        .to_uint()
        .reinterpret_as_int(),
        content="17",
      )
      inspect(
        info.ppt_packet_header_bytes_per_tile_part[0][1]
        .to_uint()
        .reinterpret_as_int(),
        content="34",
      )
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info rejects duplicate PPT Zppt index" {
  // Two PPT segments with same Zppt=0 should fail.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x1B\x00\x01\xFF\x61\x00\x04\x00\x22\xFF\x61\x00\x04\x00\x11\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate")
  }
}

///|
test "parse_jpeg2000_codestream_info rejects mismatched TLM tile-part length" {
  // TLM says Psot=16 while SOT has Psot=15.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x55\x00\x08\x00\x40\x00\x00\x00\x10\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate")
  }
}

///|
test "parse_jpeg2000_codestream_info parses PLT in tile-part header" {
  // One PLT packet length entry (1 byte), followed by SOD payload byte.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x15\x00\x01\xFF\x58\x00\x04\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_plt, content="true")
      inspect(info.plt_packet_lengths_per_tile_part.length(), content="1")
      inspect(info.plt_packet_lengths_per_tile_part[0].length(), content="1")
      inspect(info.plt_packet_lengths_per_tile_part[0][0], content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info parses RGN maxshift marker" {
  // RGN component0 style=0 shift=3.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x5E\x00\x05\x00\x00\x03\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_rgn, content="true")
      inspect(info.roi_shift, content="3")
      inspect(info.component_has_rgn.length(), content="1")
      inspect(info.component_has_rgn[0], content="true")
      inspect(info.component_roi_shift[0], content="3")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info rejects unsupported RGN style" {
  // RGN style=1 is unsupported in current implementation.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x5E\x00\x05\x00\x01\x03\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate")
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
      inspect(info.has_coc_for_component0, content="false")
      inspect(info.has_poc, content="false")
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
test "parse_jpeg2000_codestream_info parses POC entry" {
  // POC entry: RS=0, CS=0, LYE=1, RE=1, CE=1, P=1 (RLCP).
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5F\x00\x09\x00\x00\x00\x01\x01\x01\x01\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_poc, content="true")
      inspect(info.poc_entries.length(), content="1")
      inspect(info.poc_entries[0].start_resolution, content="0")
      inspect(info.poc_entries[0].start_component, content="0")
      inspect(info.poc_entries[0].end_layer_exclusive, content="1")
      inspect(info.poc_entries[0].end_resolution_exclusive, content="1")
      inspect(info.poc_entries[0].end_component_exclusive, content="1")
      inspect(info.poc_entries[0].progression_order, content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info reads COD MCT flag" {
  let data = b"\xFF\x4F\xFF\x51\x00\x2F\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x07\x01\x01\x07\x01\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x01\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => inspect(info.cod_multi_component_transform, content="1")
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
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

///|
test "parse_jpeg2000_codestream_info with EPH marker in packet data" {
  // COD with Scod EPH flag set; first packet uses inclusion=0 and EPH marker.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x04\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x11\x00\x01\xFF\x93\x00\xFF\x92\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.cod_use_sop, content="false")
      inspect(info.cod_use_eph, content="true")
      inspect(info.first_packet_header_bit, content="0")
      inspect(info.first_packet_header_bytes, content="3")
      inspect(info.has_sod, content="true")
      inspect(info.has_eoc, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_jpeg2000_codestream_info with explicit precinct exponents" {
  // COD with precinct flag and one SPcod byte (decomp=0): PPx=2, PPy=15.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0D\x01\x00\x00\x01\x00\x00\x00\x00\x00\x01\xF2\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.cod_use_precincts, content="true")
      inspect(info.cod_precinct_width_exponents.length(), content="1")
      inspect(info.cod_precinct_height_exponents.length(), content="1")
      inspect(info.cod_precinct_width_exponents[0], content="2")
      inspect(info.cod_precinct_height_exponents[0], content="15")
      inspect(info.has_sod, content="true")
      inspect(info.has_eoc, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_jpeg2000_codestream_info with two tile-parts" {
  // 2x1 codestream split into two tile-parts, each with one SOD payload.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x02\xFF\x93\x82\x34\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x01\x02\xFF\x93\x82\x34\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.num_tile_parts, content="2")
      inspect(info.tile_part_payload_starts.length(), content="2")
      inspect(info.tile_part_payload_ends.length(), content="2")
      inspect(
        info.tile_part_payload_starts[0] < info.tile_part_payload_ends[0],
        content="true",
      )
      inspect(
        info.tile_part_payload_starts[1] < info.tile_part_payload_ends[1],
        content="true",
      )
      inspect(info.has_sod, content="true")
      inspect(info.has_eoc, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_jpeg2000_codestream_info reads QCD style 2 step sizes" {
  // QCD: Lqcd=5, Sqcd=2 (scalar expounded), SPqcd=(exp=8, mant=0).
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x05\x02\x40\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.quantization_style, content="2")
      inspect(info.quantization_guard_bits, content="0")
      inspect(info.quantization_exponents.length(), content="1")
      inspect(info.quantization_mantissas.length(), content="1")
      inspect(info.quantization_exponents[0], content="8")
      inspect(info.quantization_mantissas[0], content="0")
      inspect(info.has_qcc_for_component0, content="false")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info applies QCC override for component 0" {
  // QCD style=2 followed by QCC(component=0, style=0) override.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x05\x02\x40\x00\xFF\x5D\x00\x04\x00\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.quantization_style, content="0")
      inspect(info.has_coc_for_component0, content="false")
      inspect(info.has_qcc_for_component0, content="true")
      inspect(info.quantization_exponents.length(), content="0")
      inspect(info.quantization_mantissas.length(), content="0")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info applies COC override for component 0" {
  // COD decomp=0, then COC(component0) overrides decomp=1 and 5/3.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x53\x00\x09\x00\x00\x01\x00\x00\x00\x01\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.has_coc_for_component0, content="true")
      inspect(info.cod_num_decomposition_levels, content="1")
      inspect(info.cod_wavelet_transform, content="1")
      inspect(info.cod_precinct_width_exponents.length(), content="2")
      inspect(info.cod_precinct_height_exponents.length(), content="2")
      inspect(info.cod_precinct_width_exponents[0], content="15")
      inspect(info.cod_precinct_height_exponents[1], content="15")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info tracks COC/QCC overrides for component 1" {
  // Two components: COC/QCC override only component 1.
  let data = b"\xFF\x4F\xFF\x51\x00\x2C\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x07\x01\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x53\x00\x09\x01\x00\x00\x00\x00\x02\x00\xFF\x5C\x00\x05\x02\x40\x00\xFF\x5D\x00\x05\x01\x00\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  match parse_jpeg2000_codestream_info(data) {
    Ok(info) => {
      inspect(info.siz.num_components, content="2")
      inspect(info.has_coc_for_component0, content="false")
      inspect(info.has_qcc_for_component0, content="false")
      inspect(info.component_has_coc.length(), content="2")
      inspect(info.component_has_coc[0], content="false")
      inspect(info.component_has_coc[1], content="true")
      inspect(info.component_has_qcc[0], content="false")
      inspect(info.component_has_qcc[1], content="true")
      inspect(info.component_codeblock_style[0], content="0")
      inspect(info.component_codeblock_style[1], content="2")
      inspect(info.component_quantization_style[0], content="2")
      inspect(info.component_quantization_style[1], content="0")
      inspect(info.component_quantization_exponents[0].length(), content="1")
      inspect(info.component_quantization_exponents[1].length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "parse_jpeg2000_codestream_info rejects invalid JP2 signature payload" {
  // jP box payload must be 0D 0A 87 0A; use invalid all-zero payload.
  let codestream = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x00\xFF\xD9"
  let box_len = codestream.length() + 8
  let l0 = ((box_len >> 24) & 0xFF).to_byte()
  let l1 = ((box_len >> 16) & 0xFF).to_byte()
  let l2 = ((box_len >> 8) & 0xFF).to_byte()
  let l3 = (box_len & 0xFF).to_byte()
  let arr : Array[Byte] = []
  for b in b"\x00\x00\x00\x0CjP  \x00\x00\x00\x00" {
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
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}
