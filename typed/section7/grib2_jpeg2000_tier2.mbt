///|
priv struct Jpeg2000PacketBitReader {
  data : Bytes
  mut byte_pos : Int
  mut bit_pos : Int
  mut skip_next_msb : Bool
}

///|
fn Jpeg2000PacketBitReader::new(data : Bytes) -> Jpeg2000PacketBitReader {
  { data, byte_pos: 0, bit_pos: 0, skip_next_msb: false }
}

///|
fn Jpeg2000PacketBitReader::byte_aligned_offset(
  self : Jpeg2000PacketBitReader,
) -> Int {
  if self.bit_pos == 0 {
    self.byte_pos
  } else {
    self.byte_pos + 1
  }
}

///|
fn Jpeg2000PacketBitReader::read_bit(
  self : Jpeg2000PacketBitReader,
) -> Result[Int, UnpackError] {
  if self.byte_pos >= self.data.length() {
    return Err(InsufficientData("packet header bitstream is truncated"))
  }
  if self.skip_next_msb && self.bit_pos == 0 {
    self.bit_pos = 1
    self.skip_next_msb = false
    if self.bit_pos >= 8 {
      self.bit_pos = 0
      self.byte_pos += 1
      if self.byte_pos >= self.data.length() {
        return Err(InsufficientData("packet header bitstream is truncated"))
      }
    }
  }
  let b = self.data[self.byte_pos].to_uint().reinterpret_as_int()
  let bit = (b >> (7 - self.bit_pos)) & 1
  self.bit_pos += 1
  if self.bit_pos == 8 {
    let prev = self.data[self.byte_pos].to_uint().reinterpret_as_int()
    self.bit_pos = 0
    self.byte_pos += 1
    if prev == 0xFF {
      self.skip_next_msb = true
    }
  }
  Ok(bit)
}

///|
fn Jpeg2000PacketBitReader::read_bits(
  self : Jpeg2000PacketBitReader,
  n : Int,
) -> Result[Int, UnpackError] {
  if n < 0 || n > 31 {
    return Err(UnsupportedTemplate("read_bits n out of range: \{n}"))
  }
  let mut v = 0
  for _i = 0; _i < n; _i = _i + 1 {
    let bit = match self.read_bit() {
      Ok(x) => x
      Err(e) => return Err(e)
    }
    v = (v << 1) | bit
  }
  Ok(v)
}

///|
fn Jpeg2000PacketBitReader::read_unary_ones(
  self : Jpeg2000PacketBitReader,
  max_count : Int,
) -> Result[Int, UnpackError] {
  let mut count = 0
  while count < max_count {
    let bit = match self.read_bit() {
      Ok(x) => x
      Err(e) => return Err(e)
    }
    if bit == 0 {
      return Ok(count)
    }
    count += 1
  }
  Err(UnsupportedTemplate("unary code exceeds max_count=\{max_count}"))
}

///|
fn decode_num_coding_passes(
  reader : Jpeg2000PacketBitReader,
) -> Result[Int, UnpackError] {
  let b0 = match reader.read_bit() {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if b0 == 0 {
    return Ok(1)
  }
  let b1 = match reader.read_bit() {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if b1 == 0 {
    return Ok(2)
  }
  let two = match reader.read_bits(2) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if two <= 2 {
    return Ok(3 + two)
  }
  let v5 = match reader.read_bits(5) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if v5 <= 30 {
    return Ok(6 + v5)
  }
  let v7 = match reader.read_bits(7) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if v7 <= 126 {
    return Ok(37 + v7)
  }
  let v8 = match reader.read_bits(8) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok(164 + v8)
}

///|
priv struct PacketHeaderProbe {
  first_inclusion_bit : Int
  zero_bitplanes : Int
  bytes_consumed : Int
}

///|
priv struct SingleCodeblockPacketHeader {
  included : Bool
  zero_bitplanes : Int
  num_coding_passes : Int
  lblock_increment : Int
  lblock : Int
  codeword_length : Int
  bytes_consumed : Int
}

///|
priv struct CodeblockPacketHeader {
  included : Bool
  zero_bitplanes : Int
  num_coding_passes : Int
  lblock_increment : Int
  lblock : Int
  codeword_length : Int
}

///|
priv struct MultiCodeblockPacketHeader {
  codeblocks : Array[CodeblockPacketHeader]
  bytes_consumed : Int
}

///|
priv struct Jpeg2000TagTreeState {
  width : Int
  height : Int
  level_widths : Array[Int]
  level_heights : Array[Int]
  level_offsets : Array[Int]
  values : Array[Int]
  known : Array[Bool]
}

///|
priv struct Jpeg2000TagTreeLeafRef {
  group_index : Int
  leaf_x : Int
  leaf_y : Int
}

///|
fn build_tagtree_state(
  width : Int,
  height : Int,
) -> Result[Jpeg2000TagTreeState, UnpackError] {
  if width <= 0 || height <= 0 {
    return Err(UnsupportedTemplate("tag-tree width/height must be > 0"))
  }
  let level_widths : Array[Int] = []
  let level_heights : Array[Int] = []
  let mut w = width
  let mut h = height
  while true {
    level_widths.push(w)
    level_heights.push(h)
    if w == 1 && h == 1 {
      break
    }
    w = (w + 1) / 2
    h = (h + 1) / 2
  }
  let level_offsets : Array[Int] = []
  let mut total_nodes = 0
  for i = 0; i < level_widths.length(); i = i + 1 {
    level_offsets.push(total_nodes)
    total_nodes += level_widths[i] * level_heights[i]
  }
  Ok({
    width,
    height,
    level_widths,
    level_heights,
    level_offsets,
    values: Array::make(total_nodes, 0),
    known: Array::make(total_nodes, false),
  })
}

///|
fn tagtree_node_index(
  state : Jpeg2000TagTreeState,
  level : Int,
  x : Int,
  y : Int,
) -> Result[Int, UnpackError] {
  if level < 0 || level >= state.level_widths.length() {
    return Err(UnsupportedTemplate("tag-tree level out of range: \{level}"))
  }
  if x < 0 ||
    y < 0 ||
    x >= state.level_widths[level] ||
    y >= state.level_heights[level] {
    return Err(
      UnsupportedTemplate(
        "tag-tree coordinate out of range: level=\{level}, x=\{x}, y=\{y}",
      ),
    )
  }
  Ok(state.level_offsets[level] + y * state.level_widths[level] + x)
}

///|
fn tagtree_decode_leq(
  state : Jpeg2000TagTreeState,
  reader : Jpeg2000PacketBitReader,
  leaf_x : Int,
  leaf_y : Int,
  threshold : Int,
) -> Result[Bool, UnpackError] {
  if threshold < 0 {
    return Err(UnsupportedTemplate("tag-tree threshold must be >= 0"))
  }
  if leaf_x < 0 || leaf_y < 0 || leaf_x >= state.width || leaf_y >= state.height {
    return Err(
      UnsupportedTemplate(
        "tag-tree leaf coordinate out of range: x=\{leaf_x}, y=\{leaf_y}",
      ),
    )
  }
  let level_count = state.level_widths.length()
  let path_x = Array::make(level_count, 0)
  let path_y = Array::make(level_count, 0)
  path_x[0] = leaf_x
  path_y[0] = leaf_y
  for level = 1; level < level_count; level = level + 1 {
    path_x[level] = path_x[level - 1] / 2
    path_y[level] = path_y[level - 1] / 2
  }
  let mut min_value = 0
  for level = level_count - 1; level >= 0; level = level - 1 {
    let node_idx = match
      tagtree_node_index(state, level, path_x[level], path_y[level]) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    if state.values[node_idx] < min_value {
      state.values[node_idx] = min_value
    }
    while state.values[node_idx] <= threshold && !state.known[node_idx] {
      let bit = match reader.read_bit() {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      if bit == 0 {
        state.values[node_idx] += 1
      } else {
        state.known[node_idx] = true
      }
    }
    min_value = state.values[node_idx]
  }
  let leaf_idx = match tagtree_node_index(state, 0, leaf_x, leaf_y) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok(state.values[leaf_idx] <= threshold)
}

///|
fn tagtree_decode_value(
  state : Jpeg2000TagTreeState,
  reader : Jpeg2000PacketBitReader,
  leaf_x : Int,
  leaf_y : Int,
  max_threshold : Int,
) -> Result[Int, UnpackError] {
  if max_threshold < 0 {
    return Err(UnsupportedTemplate("max_threshold must be >= 0"))
  }
  for threshold = 0; threshold <= max_threshold; threshold = threshold + 1 {
    let leq = match
      tagtree_decode_leq(state, reader, leaf_x, leaf_y, threshold) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    if leq {
      return Ok(threshold)
    }
  }
  Err(
    UnsupportedTemplate("tag-tree value exceeds max_threshold=\{max_threshold}"),
  )
}

///|
fn tagtree_decode_value_with_leaf_refs(
  states : Array[Jpeg2000TagTreeState],
  leaf_refs : Array[Jpeg2000TagTreeLeafRef],
  codeblock_index : Int,
  reader : Jpeg2000PacketBitReader,
  max_threshold : Int,
) -> Result[Int, UnpackError] {
  if codeblock_index < 0 || codeblock_index >= leaf_refs.length() {
    return Err(
      UnsupportedTemplate(
        "tag-tree leaf-ref index out of range: index=\{codeblock_index}, len=\{leaf_refs.length()}",
      ),
    )
  }
  let leaf_ref = leaf_refs[codeblock_index]
  if leaf_ref.group_index < 0 || leaf_ref.group_index >= states.length() {
    return Err(
      UnsupportedTemplate(
        "tag-tree group index out of range: group=\{leaf_ref.group_index}, groups=\{states.length()}",
      ),
    )
  }
  let state = states[leaf_ref.group_index]
  tagtree_decode_value(
    state,
    reader,
    leaf_ref.leaf_x,
    leaf_ref.leaf_y,
    max_threshold,
  )
}

///|
fn floor_log2_positive(v : Int) -> Result[Int, UnpackError] {
  if v <= 0 {
    return Err(UnsupportedTemplate("floor_log2 requires positive input"))
  }
  let mut n = v
  let mut bits = -1
  while n > 0 {
    bits += 1
    n = n / 2
  }
  Ok(bits)
}

///|
fn parse_first_packet_codeblocks_count(
  payload : Bytes,
  use_sop : Bool,
  use_eph : Bool,
  num_codeblocks : Int,
) -> Result[MultiCodeblockPacketHeader, UnpackError] {
  if num_codeblocks <= 0 {
    return Err(
      UnsupportedTemplate("num_codeblocks must be > 0, got \{num_codeblocks}"),
    )
  }
  let included_before = Array::make(num_codeblocks, false)
  let lblocks = Array::make(num_codeblocks, 3)
  let zero_bitplanes = Array::make(num_codeblocks, 0)
  parse_packet_codeblocks_with_state(
    payload, use_sop, use_eph, included_before, lblocks, zero_bitplanes,
  )
}

///|
fn parse_packet_codeblocks_with_state(
  payload : Bytes,
  use_sop : Bool,
  use_eph : Bool,
  included_before : Array[Bool],
  lblocks : Array[Int],
  zero_bitplanes : Array[Int],
) -> Result[MultiCodeblockPacketHeader, UnpackError] {
  let inclusion_layer_known : Array[Bool] = []
  let inclusion_layer : Array[Int] = []
  parse_packet_codeblocks_with_layer_state(
    payload,
    use_sop,
    use_eph,
    0,
    included_before,
    lblocks,
    zero_bitplanes,
    inclusion_layer_known,
    inclusion_layer,
    None,
    None,
    None,
  )
}

///|
fn parse_packet_codeblocks_with_layer_state(
  payload : Bytes,
  use_sop : Bool,
  use_eph : Bool,
  layer_index : Int,
  included_before : Array[Bool],
  lblocks : Array[Int],
  zero_bitplanes : Array[Int],
  inclusion_layer_known : Array[Bool],
  inclusion_layer : Array[Int],
  inclusion_tagtree_states : Array[Jpeg2000TagTreeState]?,
  zero_bitplanes_tagtree_states : Array[Jpeg2000TagTreeState]?,
  tagtree_leaf_refs : Array[Jpeg2000TagTreeLeafRef]?,
) -> Result[MultiCodeblockPacketHeader, UnpackError] {
  if layer_index < 0 {
    return Err(UnsupportedTemplate("layer_index must be >= 0"))
  }
  if included_before.length() <= 0 {
    return Err(UnsupportedTemplate("state arrays must be non-empty"))
  }
  if lblocks.length() != included_before.length() ||
    zero_bitplanes.length() != included_before.length() {
    return Err(
      UnsupportedTemplate(
        "state arrays length mismatch: included=\{included_before.length()}, lblocks=\{lblocks.length()}, zero_bitplanes=\{zero_bitplanes.length()}",
      ),
    )
  }
  let use_layer_state = inclusion_layer_known.length() ==
    included_before.length() &&
    inclusion_layer.length() == included_before.length()
  let mut use_tagtree = false
  if use_layer_state {
    use_tagtree = match inclusion_tagtree_states {
      Some(inclusion_states) =>
        match zero_bitplanes_tagtree_states {
          Some(zero_states) =>
            match tagtree_leaf_refs {
              Some(leaf_refs) =>
                inclusion_states.length() > 0 &&
                zero_states.length() > 0 &&
                leaf_refs.length() == included_before.length()
              None => false
            }
          None => false
        }
      None => false
    }
  }
  let mut start = 0
  if use_sop {
    if payload.length() < 6 {
      return Err(InsufficientData("SOP marker segment is truncated"))
    }
    if !(payload[0] == b'\xFF' && payload[1] == b'\x91') {
      return Err(
        UnsupportedTemplate("COD requires SOP but no SOP marker found"),
      )
    }
    let lsop = (payload[2].to_uint().reinterpret_as_int() << 8) |
      payload[3].to_uint().reinterpret_as_int()
    if lsop != 4 {
      return Err(UnsupportedTemplate("invalid SOP segment length: \{lsop}"))
    }
    start = 6
  }
  if start >= payload.length() {
    return Err(InsufficientData("packet header payload is empty"))
  }
  let data = payload.sub(start~).to_bytes()
  let reader = Jpeg2000PacketBitReader::new(data)
  let codeblocks : Array[CodeblockPacketHeader] = []
  for i = 0; i < included_before.length(); i = i + 1 {
    if lblocks[i] < 3 {
      lblocks[i] = 3
    }
    let first_inclusion_bit = match reader.read_bit() {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    if first_inclusion_bit == 0 {
      codeblocks.push({
        included: false,
        zero_bitplanes: 0,
        num_coding_passes: 0,
        lblock_increment: 0,
        lblock: 3,
        codeword_length: 0,
      })
      continue
    }
    let mut zero_bitplanes_i = zero_bitplanes[i]
    if !included_before[i] {
      if use_layer_state {
        if !inclusion_layer_known[i] {
          let first_layer = if use_tagtree {
            let states = match inclusion_tagtree_states {
              Some(v) => v
              None =>
                return Err(
                  UnsupportedTemplate("inclusion tag-tree states are required"),
                )
            }
            let leaf_refs = match tagtree_leaf_refs {
              Some(v) => v
              None =>
                return Err(
                  UnsupportedTemplate("tag-tree leaf refs are required"),
                )
            }
            match
              tagtree_decode_value_with_leaf_refs(
                states, leaf_refs, i, reader, 31,
              ) {
              Ok(v) => v
              Err(e) => return Err(e)
            }
          } else {
            match reader.read_unary_ones(31) {
              Ok(v) => v
              Err(e) => return Err(e)
            }
          }
          inclusion_layer[i] = first_layer
          inclusion_layer_known[i] = true
        }
        if layer_index < inclusion_layer[i] {
          codeblocks.push({
            included: false,
            zero_bitplanes: zero_bitplanes_i,
            num_coding_passes: 0,
            lblock_increment: 0,
            lblock: lblocks[i],
            codeword_length: 0,
          })
          continue
        }
      }
      zero_bitplanes_i = if use_tagtree {
        let states = match zero_bitplanes_tagtree_states {
          Some(v) => v
          None =>
            return Err(
              UnsupportedTemplate("zero-bitplanes tag-tree states are required"),
            )
        }
        let leaf_refs = match tagtree_leaf_refs {
          Some(v) => v
          None =>
            return Err(UnsupportedTemplate("tag-tree leaf refs are required"))
        }
        match
          tagtree_decode_value_with_leaf_refs(states, leaf_refs, i, reader, 31) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      } else {
        match reader.read_unary_ones(31) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      }
    }
    let num_coding_passes = match decode_num_coding_passes(reader) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let lblock_increment = match reader.read_unary_ones(31) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    lblocks[i] = lblocks[i] + lblock_increment
    let lblock = lblocks[i]
    let passes_log2 = match floor_log2_positive(num_coding_passes) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let length_bits = lblock + passes_log2
    let codeword_length = match reader.read_bits(length_bits) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    included_before[i] = true
    zero_bitplanes[i] = zero_bitplanes_i
    codeblocks.push({
      included: true,
      zero_bitplanes: zero_bitplanes_i,
      num_coding_passes,
      lblock_increment,
      lblock,
      codeword_length,
    })
  }
  let mut bytes_consumed = start + reader.byte_aligned_offset()
  if use_eph {
    if bytes_consumed + 2 > payload.length() {
      return Err(InsufficientData("EPH marker segment is truncated"))
    }
    if !(payload[bytes_consumed] == b'\xFF' &&
      payload[bytes_consumed + 1] == b'\x92') {
      return Err(
        UnsupportedTemplate("COD requires EPH but no EPH marker found"),
      )
    }
    bytes_consumed += 2
  }
  Ok({ codeblocks, bytes_consumed })
}

///|
fn parse_first_packet_codeblocks(
  payload : Bytes,
  use_sop : Bool,
  use_eph : Bool,
  num_codeblocks_x : Int,
  num_codeblocks_y : Int,
) -> Result[MultiCodeblockPacketHeader, UnpackError] {
  if num_codeblocks_x <= 0 || num_codeblocks_y <= 0 {
    return Err(
      UnsupportedTemplate(
        "num_codeblocks_x/num_codeblocks_y must be > 0, got \{num_codeblocks_x}x\{num_codeblocks_y}",
      ),
    )
  }
  parse_first_packet_codeblocks_count(
    payload,
    use_sop,
    use_eph,
    num_codeblocks_x * num_codeblocks_y,
  )
}

///|
fn parse_first_packet_single_codeblock(
  payload : Bytes,
  use_sop : Bool,
  use_eph : Bool,
) -> Result[SingleCodeblockPacketHeader, UnpackError] {
  let parsed = match
    parse_first_packet_codeblocks(payload, use_sop, use_eph, 1, 1) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let header = parsed.codeblocks[0]
  Ok({
    included: header.included,
    zero_bitplanes: header.zero_bitplanes,
    num_coding_passes: header.num_coding_passes,
    lblock_increment: header.lblock_increment,
    lblock: header.lblock,
    codeword_length: header.codeword_length,
    bytes_consumed: parsed.bytes_consumed,
  })
}

///|
fn probe_first_packet_header(
  payload : Bytes,
  use_sop : Bool,
  use_eph : Bool,
) -> Result[PacketHeaderProbe, UnpackError] {
  let header = match
    parse_first_packet_single_codeblock(payload, use_sop, use_eph) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok({
    first_inclusion_bit: if header.included {
      1
    } else {
      0
    },
    zero_bitplanes: header.zero_bitplanes,
    bytes_consumed: header.bytes_consumed,
  })
}

///|
test "jpeg2000 packet reader bit-stuffing after 0xFF" {
  // first byte all ones, next byte msb should be skipped.
  let reader = Jpeg2000PacketBitReader::new(b"\xFF\x7F")
  let mut ones = 0
  for _i = 0; _i < 8; _i = _i + 1 {
    match reader.read_bit() {
      Ok(v) => ones += v
      Err(_) => fail("unexpected error")
    }
  }
  inspect(ones, content="8")
  // next bit reads bit 6 of 0x7F, i.e. 1
  match reader.read_bit() {
    Ok(v) => inspect(v, content="1")
    Err(_) => fail("unexpected error")
  }
}

///|
test "decode_num_coding_passes common short codes" {
  // 0 -> 1 pass
  let r1 = Jpeg2000PacketBitReader::new(b"\x00")
  match decode_num_coding_passes(r1) {
    Ok(v) => inspect(v, content="1")
    Err(_) => fail("unexpected error")
  }
  // 10 -> 2 passes
  let r2 = Jpeg2000PacketBitReader::new(b"\x80")
  match decode_num_coding_passes(r2) {
    Ok(v) => inspect(v, content="2")
    Err(_) => fail("unexpected error")
  }
  // 1100 -> 3 passes
  let r3 = Jpeg2000PacketBitReader::new(b"\xC0")
  match decode_num_coding_passes(r3) {
    Ok(v) => inspect(v, content="3")
    Err(_) => fail("unexpected error")
  }
}

///|
test "probe_first_packet_header with sop and unary zero-bitplanes" {
  let payload = b"\xFF\x91\x00\x04\x00\x00\xEC\x50"
  match probe_first_packet_header(payload, true, false) {
    Ok(v) => {
      inspect(v.first_inclusion_bit, content="1")
      inspect(v.zero_bitplanes, content="2")
      inspect(v.bytes_consumed >= 8, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_first_packet_single_codeblock parses coding passes and length" {
  // bits: inclusion=1, zero=2(110), passes=3(1100), lblock_inc=0, len(4 bits)=10(1010)
  let payload = b"\xEC\x50"
  match parse_first_packet_single_codeblock(payload, false, false) {
    Ok(v) => {
      inspect(v.included, content="true")
      inspect(v.zero_bitplanes, content="2")
      inspect(v.num_coding_passes, content="3")
      inspect(v.lblock_increment, content="0")
      inspect(v.lblock, content="3")
      inspect(v.codeword_length, content="10")
      inspect(v.bytes_consumed, content="2")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_first_packet_single_codeblock accepts EPH marker" {
  let payload = b"\xEC\x50\xFF\x92"
  match parse_first_packet_single_codeblock(payload, false, true) {
    Ok(v) => {
      inspect(v.codeword_length, content="10")
      inspect(v.bytes_consumed, content="4")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_first_packet_single_codeblock parses two-pass header" {
  // bits: inclusion=1, zero=0, passes=2(10), lblock_inc=0, len(4 bits)=1(0001)
  let payload = b"\xA0\x80\x34"
  match parse_first_packet_single_codeblock(payload, false, false) {
    Ok(v) => {
      inspect(v.included, content="true")
      inspect(v.zero_bitplanes, content="0")
      inspect(v.num_coding_passes, content="2")
      inspect(v.lblock, content="3")
      inspect(v.codeword_length, content="1")
      inspect(v.bytes_consumed, content="2")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_first_packet_codeblocks parses two codeblocks" {
  // cb0: inclusion=1, zero=0, passes=1, lblock_inc=0, len=1 (7 bits)
  // cb1: inclusion=1, zero=0, passes=1, lblock_inc=0, len=1 (7 bits)
  // concatenated header bits => 0x83 0x04
  let payload = b"\x83\x04\x34\x34"
  match parse_first_packet_codeblocks(payload, false, false, 2, 1) {
    Ok(v) => {
      inspect(v.codeblocks.length(), content="2")
      inspect(v.codeblocks[0].included, content="true")
      inspect(v.codeblocks[0].num_coding_passes, content="1")
      inspect(v.codeblocks[0].codeword_length, content="1")
      inspect(v.codeblocks[1].included, content="true")
      inspect(v.codeblocks[1].num_coding_passes, content="1")
      inspect(v.codeblocks[1].codeword_length, content="1")
      inspect(v.bytes_consumed, content="2")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_first_packet_codeblocks_count parses three excluded blocks" {
  let payload = b"\x00"
  match parse_first_packet_codeblocks_count(payload, false, false, 3) {
    Ok(v) => {
      inspect(v.codeblocks.length(), content="3")
      inspect(v.codeblocks[0].included, content="false")
      inspect(v.codeblocks[1].included, content="false")
      inspect(v.codeblocks[2].included, content="false")
      inspect(v.bytes_consumed, content="1")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_first_packet_single_codeblock inclusion0 with EPH marker" {
  let payload = b"\x00\xFF\x92"
  match parse_first_packet_single_codeblock(payload, false, true) {
    Ok(v) => {
      inspect(v.included, content="false")
      inspect(v.bytes_consumed, content="3")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_packet_codeblocks_with_layer_state defers first inclusion by layer" {
  let included_before = [false]
  let lblocks = [3]
  let zero_bitplanes = [0]
  let inclusion_layer_known = [false]
  let inclusion_layer = [0]
  let inclusion_tagtree_states = match build_tagtree_state(1, 1) {
    Ok(v) => Some(v)
    Err(_) => fail("unexpected error")
  }
  let zero_bitplanes_tagtree_states = match build_tagtree_state(1, 1) {
    Ok(v) => Some(v)
    Err(_) => fail("unexpected error")
  }
  let inclusion_tagtree_states = match inclusion_tagtree_states {
    Some(v) => Some([v])
    None => None
  }
  let zero_bitplanes_tagtree_states = match zero_bitplanes_tagtree_states {
    Some(v) => Some([v])
    None => None
  }
  let tagtree_leaf_refs = Some([{ group_index: 0, leaf_x: 0, leaf_y: 0 }])
  // layer=0: inclusion bit=1, first-layer(tag-tree)=1 => not included yet.
  match
    parse_packet_codeblocks_with_layer_state(
      b"\xA0", false, false, 0, included_before, lblocks, zero_bitplanes, inclusion_layer_known,
      inclusion_layer, inclusion_tagtree_states, zero_bitplanes_tagtree_states, tagtree_leaf_refs,
    ) {
    Ok(v) => {
      inspect(v.codeblocks.length(), content="1")
      inspect(v.codeblocks[0].included, content="false")
      inspect(inclusion_layer_known[0], content="true")
      inspect(inclusion_layer[0], content="1")
    }
    Err(_) => fail("unexpected error")
  }
  // layer=1: same codeblock can now be included.
  match
    parse_packet_codeblocks_with_layer_state(
      b"\xC2\x34", false, false, 1, included_before, lblocks, zero_bitplanes, inclusion_layer_known,
      inclusion_layer, inclusion_tagtree_states, zero_bitplanes_tagtree_states, tagtree_leaf_refs,
    ) {
    Ok(v) => {
      inspect(v.codeblocks.length(), content="1")
      inspect(v.codeblocks[0].included, content="true")
      inspect(v.codeblocks[0].num_coding_passes, content="1")
      inspect(v.codeblocks[0].codeword_length, content="1")
      inspect(zero_bitplanes[0], content="0")
      inspect(included_before[0], content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "parse_packet_codeblocks_with_layer_state supports per-group tagtree refs" {
  let included_before = [false, false]
  let lblocks = [3, 3]
  let zero_bitplanes = [0, 0]
  let inclusion_layer_known = [false, false]
  let inclusion_layer = [0, 0]
  let inclusion_tagtree_states = match
    (build_tagtree_state(1, 1), build_tagtree_state(1, 1)) {
    (Ok(a), Ok(b)) => Some([a, b])
    _ => fail("unexpected error")
  }
  let zero_bitplanes_tagtree_states = match
    (build_tagtree_state(1, 1), build_tagtree_state(1, 1)) {
    (Ok(a), Ok(b)) => Some([a, b])
    _ => fail("unexpected error")
  }
  let tagtree_leaf_refs = Some([
    { group_index: 0, leaf_x: 0, leaf_y: 0 },
    { group_index: 1, leaf_x: 0, leaf_y: 0 },
  ])
  // block0: inclusion=1, first-layer=1 => deferred at layer=0.
  // block1: inclusion=1, first-layer=0, zbp=0, passes=1, lblock_inc=0, len=2.
  // Bits: 101 1110001 (padded) -> 0xBC,0x40
  match
    parse_packet_codeblocks_with_layer_state(
      b"\xBC\x40", false, false, 0, included_before, lblocks, zero_bitplanes, inclusion_layer_known,
      inclusion_layer, inclusion_tagtree_states, zero_bitplanes_tagtree_states, tagtree_leaf_refs,
    ) {
    Ok(v) => {
      inspect(v.codeblocks.length(), content="2")
      inspect(v.codeblocks[0].included, content="false")
      inspect(v.codeblocks[1].included, content="true")
      inspect(v.codeblocks[1].num_coding_passes, content="1")
      inspect(v.codeblocks[1].codeword_length, content="2")
      inspect(inclusion_layer_known[0], content="true")
      inspect(inclusion_layer[0], content="1")
      inspect(inclusion_layer_known[1], content="true")
      inspect(inclusion_layer[1], content="0")
      inspect(zero_bitplanes[1], content="0")
      inspect(included_before[0], content="false")
      inspect(included_before[1], content="true")
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
test "tagtree_decode_leq decodes two-leaf threshold sequence" {
  // root=0, leaf0=0, leaf1=2 -> bits: root(1) leaf0(1) leaf1@t0(0) leaf1@t1(0) leaf1@t2(1)
  let reader = Jpeg2000PacketBitReader::new(b"\xC8")
  let state = match build_tagtree_state(2, 1) {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  match tagtree_decode_leq(state, reader, 0, 0, 0) {
    Ok(v) => inspect(v, content="true")
    Err(_) => fail("unexpected error")
  }
  match tagtree_decode_leq(state, reader, 1, 0, 0) {
    Ok(v) => inspect(v, content="false")
    Err(_) => fail("unexpected error")
  }
  match tagtree_decode_leq(state, reader, 1, 0, 1) {
    Ok(v) => inspect(v, content="false")
    Err(_) => fail("unexpected error")
  }
  match tagtree_decode_leq(state, reader, 1, 0, 2) {
    Ok(v) => inspect(v, content="true")
    Err(_) => fail("unexpected error")
  }
}

///|
test "tagtree_decode_value returns exact leaf value" {
  // single leaf with value=3 -> bits for thresholds 0..3 : 0,0,0,1
  let reader = Jpeg2000PacketBitReader::new(b"\x10")
  let state = match build_tagtree_state(1, 1) {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  match tagtree_decode_value(state, reader, 0, 0, 31) {
    Ok(v) => inspect(v, content="3")
    Err(_) => fail("unexpected error")
  }
}
