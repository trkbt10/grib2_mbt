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
fn probe_first_packet_header(
  payload : Bytes,
  use_sop : Bool,
) -> Result[PacketHeaderProbe, UnpackError] {
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
  let first_inclusion_bit = match reader.read_bit() {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let zero_bitplanes = if first_inclusion_bit == 1 {
    match reader.read_unary_ones(31) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
  } else {
    0
  }
  let bytes_consumed = start + reader.byte_aligned_offset()
  Ok({ first_inclusion_bit, zero_bitplanes, bytes_consumed })
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
  let payload = b"\xFF\x91\x00\x04\x00\x00\xE0"
  match probe_first_packet_header(payload, true) {
    Ok(v) => {
      inspect(v.first_inclusion_bit, content="1")
      inspect(v.zero_bitplanes, content="2")
      inspect(v.bytes_consumed >= 7, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}
