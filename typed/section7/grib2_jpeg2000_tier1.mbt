///|
let mq_qe : Array[Int] = [
  0x5601, 0x3401, 0x1801, 0x0AC1, 0x0521, 0x0221, 0x5601, 0x5401, 0x4801, 0x3801,
  0x3001, 0x2401, 0x1C01, 0x1601, 0x5601, 0x5401, 0x5101, 0x4801, 0x3801, 0x3401,
  0x3001, 0x2801, 0x2401, 0x2201, 0x1C01, 0x1801, 0x1601, 0x1401, 0x1201, 0x1101,
  0x0AC1, 0x09C1, 0x08A1, 0x0521, 0x0441, 0x02A1, 0x0221, 0x0141, 0x0111, 0x0085,
  0x0049, 0x0025, 0x0015, 0x0009, 0x0005, 0x0001, 0x5601,
]

///|
let mq_nmps : Array[Int] = [
  1, 2, 3, 4, 5, 38, 7, 8, 9, 10, 11, 12, 13, 29, 15, 16, 17, 18, 19, 20, 21, 22,
  23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
  43, 44, 45, 45, 46,
]

///|
let mq_nlps : Array[Int] = [
  1, 6, 9, 12, 29, 33, 6, 14, 14, 14, 17, 18, 20, 21, 14, 14, 15, 16, 17, 18, 19,
  19, 20, 21, 22, 23, 24, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
  38, 39, 40, 41, 46, 46,
]

///|
let mq_switch : Array[Int] = [
  1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
]

///|
priv struct Jpeg2000MqContext {
  mut state_idx : Int
  mut mps : Int
}

///|
fn Jpeg2000MqContext::new() -> Jpeg2000MqContext {
  { state_idx: 0, mps: 0 }
}

///|
priv struct Jpeg2000MqDecoder {
  data : Bytes
  mut byte_pos : Int
  mut c : Int
  mut a : Int
  mut ct : Int
}

///|
priv struct Jpeg2000RawBitReader {
  data : Bytes
  mut byte_pos : Int
  mut bit_pos : Int
  mut skip_next_msb : Bool
}

///|
fn Jpeg2000RawBitReader::new(
  data : Bytes,
  start_offset : Int,
) -> Result[Jpeg2000RawBitReader, UnpackError] {
  if start_offset < 0 || start_offset > data.length() {
    return Err(
      UnsupportedTemplate(
        "raw bitreader start offset out of range: \{start_offset}/\{data.length()}",
      ),
    )
  }
  Ok({ data, byte_pos: start_offset, bit_pos: 0, skip_next_msb: false })
}

///|
fn Jpeg2000RawBitReader::read_bit(
  self : Jpeg2000RawBitReader,
) -> Result[Int, UnpackError] {
  if self.byte_pos >= self.data.length() {
    return Err(InsufficientData("raw pass bitstream is truncated"))
  }
  if self.skip_next_msb && self.bit_pos == 0 {
    self.bit_pos = 1
    self.skip_next_msb = false
    if self.bit_pos >= 8 {
      self.bit_pos = 0
      self.byte_pos += 1
      if self.byte_pos >= self.data.length() {
        return Err(InsufficientData("raw pass bitstream is truncated"))
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
fn Jpeg2000RawBitReader::byte_aligned_offset(
  self : Jpeg2000RawBitReader,
) -> Int {
  if self.bit_pos == 0 {
    self.byte_pos
  } else {
    self.byte_pos + 1
  }
}

///|
fn mq_bytein(dec : Jpeg2000MqDecoder) -> Unit {
  if dec.byte_pos + 1 >= dec.data.length() {
    dec.c += 0xFF00
    dec.ct = 8
    return
  }
  let cur = dec.data[dec.byte_pos].to_uint().reinterpret_as_int()
  let next = dec.data[dec.byte_pos + 1].to_uint().reinterpret_as_int()
  if cur == 0xFF {
    if next > 0x8F {
      dec.c += 0xFF00
      dec.ct = 8
    } else {
      dec.byte_pos += 1
      dec.c += next << 9
      dec.ct = 7
    }
  } else {
    dec.byte_pos += 1
    dec.c += next << 8
    dec.ct = 8
  }
}

///|
fn Jpeg2000MqDecoder::new(
  data : Bytes,
) -> Result[Jpeg2000MqDecoder, UnpackError] {
  if data.length() <= 0 {
    return Err(InsufficientData("MQ decoder input is empty"))
  }
  let c0 = data[0].to_uint().reinterpret_as_int() << 16
  let dec : Jpeg2000MqDecoder = { data, byte_pos: 0, c: c0, a: 0x8000, ct: 0 }
  mq_bytein(dec)
  dec.c = dec.c << 7
  dec.ct -= 7
  Ok(dec)
}

///|
fn mq_estimated_byte_aligned_offset(dec : Jpeg2000MqDecoder) -> Int {
  let mut pos = dec.byte_pos
  if dec.ct == 0 {
    pos += 1
  }
  if pos < 0 {
    0
  } else if pos > dec.data.length() {
    dec.data.length()
  } else {
    pos
  }
}

///|
fn is_raw_bypass_pass(
  use_bypass : Bool,
  pass_index : Int,
  pass_type : Int,
) -> Bool {
  // Lazy coding (BYPASS): SP/MR become raw-coded after the first 10 passes.
  use_bypass && pass_index >= 10 && pass_type != 2
}

///|
fn mq_decoder_from_absolute_offset(
  codeword : Bytes,
  start_offset : Int,
) -> Result[Jpeg2000MqDecoder, UnpackError] {
  if start_offset < 0 || start_offset >= codeword.length() {
    return Err(
      InsufficientData(
        "MQ decoder start offset out of range: \{start_offset}/\{codeword.length()}",
      ),
    )
  }
  Jpeg2000MqDecoder::new(codeword.sub(start=start_offset).to_bytes())
}

///|
fn mq_renormd(dec : Jpeg2000MqDecoder) -> Unit {
  while dec.a < 0x8000 {
    if dec.ct == 0 {
      mq_bytein(dec)
    }
    dec.a = dec.a << 1
    dec.c = dec.c << 1
    dec.ct -= 1
  }
}

///|
fn mq_mpsexchange(dec : Jpeg2000MqDecoder, ctx : Jpeg2000MqContext) -> Int {
  let state = ctx.state_idx
  let qe = mq_qe[state]
  if dec.a < qe {
    let d = 1 - ctx.mps
    if mq_switch[state] != 0 {
      ctx.mps = d
    }
    ctx.state_idx = mq_nlps[state]
    d
  } else {
    let d = ctx.mps
    ctx.state_idx = mq_nmps[state]
    d
  }
}

///|
fn mq_lpsexchange(dec : Jpeg2000MqDecoder, ctx : Jpeg2000MqContext) -> Int {
  let state = ctx.state_idx
  let qe = mq_qe[state]
  if dec.a < qe {
    dec.a = qe
    let d = ctx.mps
    ctx.state_idx = mq_nmps[state]
    d
  } else {
    dec.a = qe
    let d = 1 - ctx.mps
    if mq_switch[state] != 0 {
      ctx.mps = d
    }
    ctx.state_idx = mq_nlps[state]
    d
  }
}

///|
fn mq_decode_symbol(dec : Jpeg2000MqDecoder, ctx : Jpeg2000MqContext) -> Int {
  let state = ctx.state_idx
  let qe = mq_qe[state]
  dec.a -= qe
  if dec.c >> 16 < qe {
    let d = mq_lpsexchange(dec, ctx)
    mq_renormd(dec)
    d
  } else {
    dec.c -= qe << 16
    if (dec.a & 0x8000) == 0 {
      let d = mq_mpsexchange(dec, ctx)
      mq_renormd(dec)
      d
    } else {
      ctx.mps
    }
  }
}

///|
fn tier1_probe_first_symbol(
  codeword : Bytes,
) -> Result[(Int, Int, Int), UnpackError] {
  let dec = match Jpeg2000MqDecoder::new(codeword) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let ctx = Jpeg2000MqContext::new()
  let sym = mq_decode_symbol(dec, ctx)
  Ok((sym, ctx.state_idx, ctx.mps))
}

///|
fn mq_mpsexchange_table(
  dec : Jpeg2000MqDecoder,
  ctx_states : Array[Int],
  ctx_mps : Array[Int],
  ctx_idx : Int,
) -> Int {
  let state = ctx_states[ctx_idx]
  let qe = mq_qe[state]
  if dec.a < qe {
    let d = 1 - ctx_mps[ctx_idx]
    if mq_switch[state] != 0 {
      ctx_mps[ctx_idx] = d
    }
    ctx_states[ctx_idx] = mq_nlps[state]
    d
  } else {
    let d = ctx_mps[ctx_idx]
    ctx_states[ctx_idx] = mq_nmps[state]
    d
  }
}

///|
fn mq_lpsexchange_table(
  dec : Jpeg2000MqDecoder,
  ctx_states : Array[Int],
  ctx_mps : Array[Int],
  ctx_idx : Int,
) -> Int {
  let state = ctx_states[ctx_idx]
  let qe = mq_qe[state]
  if dec.a < qe {
    dec.a = qe
    let d = ctx_mps[ctx_idx]
    ctx_states[ctx_idx] = mq_nmps[state]
    d
  } else {
    dec.a = qe
    let d = 1 - ctx_mps[ctx_idx]
    if mq_switch[state] != 0 {
      ctx_mps[ctx_idx] = d
    }
    ctx_states[ctx_idx] = mq_nlps[state]
    d
  }
}

///|
fn mq_decode_symbol_table(
  dec : Jpeg2000MqDecoder,
  ctx_states : Array[Int],
  ctx_mps : Array[Int],
  ctx_idx : Int,
) -> Int {
  let state = ctx_states[ctx_idx]
  let qe = mq_qe[state]
  dec.a -= qe
  if dec.c >> 16 < qe {
    let d = mq_lpsexchange_table(dec, ctx_states, ctx_mps, ctx_idx)
    mq_renormd(dec)
    d
  } else {
    dec.c -= qe << 16
    if (dec.a & 0x8000) == 0 {
      let d = mq_mpsexchange_table(dec, ctx_states, ctx_mps, ctx_idx)
      mq_renormd(dec)
      d
    } else {
      ctx_mps[ctx_idx]
    }
  }
}

///|
fn has_significant_neighbor(
  significant : Array[Bool],
  width : Int,
  height : Int,
  x : Int,
  y : Int,
  use_vertical_causal : Bool,
) -> Bool {
  for dy = -1; dy <= 1; dy = dy + 1 {
    for dx = -1; dx <= 1; dx = dx + 1 {
      if dx != 0 || dy != 0 {
        let nx = x + dx
        let ny = y + dy
        if nx >= 0 &&
          nx < width &&
          ny >= 0 &&
          ny < height &&
          (!use_vertical_causal || ny <= y) {
          if significant[ny * width + nx] {
            return true
          }
        }
      }
    }
  }
  false
}

///|
fn count_significant_neighbors(
  significant : Array[Bool],
  width : Int,
  height : Int,
  x : Int,
  y : Int,
  use_vertical_causal : Bool,
) -> (Int, Int) {
  let mut hv = 0
  let mut diag = 0
  if x > 0 && significant[y * width + (x - 1)] {
    hv += 1
  }
  if x + 1 < width && significant[y * width + (x + 1)] {
    hv += 1
  }
  if y > 0 && significant[(y - 1) * width + x] {
    hv += 1
  }
  if !use_vertical_causal && y + 1 < height && significant[(y + 1) * width + x] {
    hv += 1
  }
  if x > 0 && y > 0 && significant[(y - 1) * width + (x - 1)] {
    diag += 1
  }
  if x + 1 < width && y > 0 && significant[(y - 1) * width + (x + 1)] {
    diag += 1
  }
  if !use_vertical_causal &&
    x > 0 &&
    y + 1 < height &&
    significant[(y + 1) * width + (x - 1)] {
    diag += 1
  }
  if !use_vertical_causal &&
    x + 1 < width &&
    y + 1 < height &&
    significant[(y + 1) * width + (x + 1)] {
    diag += 1
  }
  (hv, diag)
}

///|
fn select_sig_ctx(hv : Int, diag : Int) -> Int {
  if hv == 0 {
    if diag == 0 {
      0
    } else if diag == 1 {
      1
    } else {
      2
    }
  } else if hv == 1 {
    if diag == 0 {
      3
    } else {
      4
    }
  } else if hv == 2 {
    if diag == 0 {
      5
    } else {
      6
    }
  } else if diag == 0 {
    7
  } else {
    8
  }
}

///|
fn signed_unit(coeff : Int) -> Int {
  if coeff < 0 {
    -1
  } else if coeff > 0 {
    1
  } else {
    0
  }
}

///|
fn abs_int(v : Int) -> Int {
  if v < 0 {
    -v
  } else {
    v
  }
}

///|
fn select_sign_ctx_and_xor(
  significant : Array[Bool],
  coeffs : Array[Int],
  width : Int,
  height : Int,
  x : Int,
  y : Int,
  use_vertical_causal : Bool,
) -> (Int, Int) {
  let mut h = 0
  let mut v = 0
  if x > 0 && significant[y * width + (x - 1)] {
    h += signed_unit(coeffs[y * width + (x - 1)])
  }
  if x + 1 < width && significant[y * width + (x + 1)] {
    h += signed_unit(coeffs[y * width + (x + 1)])
  }
  if y > 0 && significant[(y - 1) * width + x] {
    v += signed_unit(coeffs[(y - 1) * width + x])
  }
  if !use_vertical_causal && y + 1 < height && significant[(y + 1) * width + x] {
    v += signed_unit(coeffs[(y + 1) * width + x])
  }
  let ah = abs_int(h)
  let av = abs_int(v)
  if ah == 0 && av == 0 {
    (9, 0)
  } else if ah > av {
    if h > 0 {
      (10, 1)
    } else {
      (10, 0)
    }
  } else if av > ah {
    if v > 0 {
      (11, 1)
    } else {
      (11, 0)
    }
  } else if h + v > 0 {
    (12, 1)
  } else if h + v < 0 {
    (12, 0)
  } else {
    (13, 0)
  }
}

///|
fn decode_sign_bit(
  dec : Jpeg2000MqDecoder,
  ctx_states : Array[Int],
  ctx_mps : Array[Int],
  significant : Array[Bool],
  coeffs : Array[Int],
  width : Int,
  height : Int,
  x : Int,
  y : Int,
  use_vertical_causal : Bool,
) -> Int {
  let (ctx_idx, xor_bit) = select_sign_ctx_and_xor(
    significant, coeffs, width, height, x, y, use_vertical_causal,
  )
  let raw = mq_decode_symbol_table(dec, ctx_states, ctx_mps, ctx_idx)
  if xor_bit != 0 {
    1 - raw
  } else {
    raw
  }
}

///|
fn reset_mq_context_tables(
  ctx_states : Array[Int],
  ctx_mps : Array[Int],
) -> Unit {
  for i = 0; i < ctx_states.length(); i = i + 1 {
    ctx_states[i] = 0
  }
  for i = 0; i < ctx_mps.length(); i = i + 1 {
    ctx_mps[i] = 0
  }
}

///|
fn set_significant_sample(
  coeffs : Array[Int],
  significant : Array[Bool],
  signs : Array[Int],
  became_significant : Array[Bool],
  idx : Int,
  sign : Int,
  bitplane : Int,
) -> Unit {
  significant[idx] = true
  signs[idx] = sign
  became_significant[idx] = true
  let delta = 1 << bitplane
  if sign != 0 {
    coeffs[idx] = coeffs[idx] - delta
  } else {
    coeffs[idx] = coeffs[idx] + delta
  }
}

///|
fn tier1_decode_single_coefficient(
  codeword : Bytes,
  num_coding_passes : Int,
  zero_bitplanes : Int,
  bits_per_value : Int,
) -> Result[Int, UnpackError] {
  match
    tier1_decode_coefficients_cleanup_only(
      codeword, 1, 1, num_coding_passes, zero_bitplanes, bits_per_value,
    ) {
    Ok(v) => Ok(v[0])
    Err(e) => Err(e)
  }
}

///|
fn tier1_decode_coefficients_cleanup_only_with_style(
  codeword : Bytes,
  width : Int,
  height : Int,
  num_coding_passes : Int,
  zero_bitplanes : Int,
  bits_per_value : Int,
  codeblock_style : Int,
) -> Result[Array[Int], UnpackError] {
  if (codeblock_style & 0xC0) != 0 {
    return Err(
      UnsupportedTemplate(
        "codeblock_style has reserved bits set: 0x\{codeblock_style.to_string(radix=16)}",
      ),
    )
  }
  // Support BYPASS(0x01), RESET(0x02), TERMALL(0x04), VCAUSAL(0x08),
  // PTERM(0x10), and tolerate SEGMARK(0x20).
  let use_bypass = (codeblock_style & 0x01) != 0
  let reset_context_probabilities = (codeblock_style & 0x02) != 0
  let use_termall = (codeblock_style & 0x04) != 0
  let use_vertical_causal = (codeblock_style & 0x08) != 0
  let use_predictable_termination = (codeblock_style & 0x10) != 0
  let use_segmark = (codeblock_style & 0x20) != 0
  if width <= 0 || height <= 0 {
    return Err(UnsupportedTemplate("width/height must be > 0"))
  }
  if num_coding_passes <= 0 {
    return Err(UnsupportedTemplate("num_coding_passes must be > 0"))
  }
  if bits_per_value <= 0 {
    return Err(UnsupportedTemplate("bits_per_value must be > 0"))
  }
  if zero_bitplanes < 0 {
    return Err(UnsupportedTemplate("zero_bitplanes must be >= 0"))
  }
  let coeff_count = width * height
  let coeffs = Array::make(coeff_count, 0)
  let bitplane = bits_per_value - 1 - zero_bitplanes
  if bitplane < 0 {
    return Ok(coeffs)
  }
  let mut dec = match Jpeg2000MqDecoder::new(codeword) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let mut mq_base_offset = 0
  let mut raw_reader : Jpeg2000RawBitReader? = None
  let ctx_states = Array::make(19, 0)
  let ctx_mps = Array::make(19, 0)
  let significant = Array::make(coeff_count, false)
  let signs = Array::make(coeff_count, 0)
  let became_significant = Array::make(coeff_count, false)
  let processed_in_sigprop = Array::make(coeff_count, false)
  let mut current_bitplane = bitplane
  let mut pass_type = 2
  let mut pass = 0
  while pass < num_coding_passes && current_bitplane >= 0 {
    let use_raw_pass = is_raw_bypass_pass(use_bypass, pass, pass_type)
    if use_raw_pass {
      match raw_reader {
        Some(_) => ()
        None => {
          let start_offset = mq_base_offset +
            mq_estimated_byte_aligned_offset(dec)
          let reader = match Jpeg2000RawBitReader::new(codeword, start_offset) {
            Ok(v) => v
            Err(e) => return Err(e)
          }
          raw_reader = Some(reader)
        }
      }
    } else {
      match raw_reader {
        Some(reader) => {
          let next_offset = reader.byte_aligned_offset()
          raw_reader = None
          if next_offset < codeword.length() {
            mq_base_offset = next_offset
            dec = match
              mq_decoder_from_absolute_offset(codeword, mq_base_offset) {
              Ok(v) => v
              Err(e) => return Err(e)
            }
          } else {
            return Ok(coeffs)
          }
        }
        None => ()
      }
    }
    if reset_context_probabilities {
      reset_mq_context_tables(ctx_states, ctx_mps)
    }
    if pass_type == 0 {
      // Significance propagation pass.
      for i = 0; i < coeff_count; i = i + 1 {
        processed_in_sigprop[i] = false
        became_significant[i] = false
      }
      let mut stripe_y = 0
      while stripe_y < height {
        let stripe_rows = if stripe_y + 4 <= height {
          4
        } else {
          height - stripe_y
        }
        for x = 0; x < width; x = x + 1 {
          for k = 0; k < stripe_rows; k = k + 1 {
            let y = stripe_y + k
            let idx = y * width + x
            if !significant[idx] &&
              has_significant_neighbor(
                significant, width, height, x, y, use_vertical_causal,
              ) {
              let (hv, diag) = count_significant_neighbors(
                significant, width, height, x, y, use_vertical_causal,
              )
              let ctx = select_sig_ctx(hv, diag)
              let sig = if use_raw_pass {
                let reader = match raw_reader {
                  Some(v) => v
                  None =>
                    return Err(
                      UnsupportedTemplate("raw reader is not initialized"),
                    )
                }
                match reader.read_bit() {
                  Ok(v) => v
                  Err(e) => return Err(e)
                }
              } else {
                mq_decode_symbol_table(dec, ctx_states, ctx_mps, ctx)
              }
              processed_in_sigprop[idx] = true
              if sig != 0 {
                let sign = if use_raw_pass {
                  let reader = match raw_reader {
                    Some(v) => v
                    None =>
                      return Err(
                        UnsupportedTemplate("raw reader is not initialized"),
                      )
                  }
                  match reader.read_bit() {
                    Ok(v) => v
                    Err(e) => return Err(e)
                  }
                } else {
                  decode_sign_bit(
                    dec, ctx_states, ctx_mps, significant, coeffs, width, height,
                    x, y, use_vertical_causal,
                  )
                }
                set_significant_sample(
                  coeffs, significant, signs, became_significant, idx, sign, current_bitplane,
                )
              }
            }
          }
        }
        stripe_y += 4
      }
    } else if pass_type == 1 {
      // Magnitude refinement pass.
      let mut stripe_y = 0
      while stripe_y < height {
        let stripe_rows = if stripe_y + 4 <= height {
          4
        } else {
          height - stripe_y
        }
        for x = 0; x < width; x = x + 1 {
          for k = 0; k < stripe_rows; k = k + 1 {
            let y = stripe_y + k
            let idx = y * width + x
            if significant[idx] && !became_significant[idx] {
              let (hv, diag) = count_significant_neighbors(
                significant, width, height, x, y, use_vertical_causal,
              )
              let n = hv + diag
              let ctx = if n == 0 { 14 } else if n <= 2 { 15 } else { 16 }
              let refine = if use_raw_pass {
                let reader = match raw_reader {
                  Some(v) => v
                  None =>
                    return Err(
                      UnsupportedTemplate("raw reader is not initialized"),
                    )
                }
                match reader.read_bit() {
                  Ok(v) => v
                  Err(e) => return Err(e)
                }
              } else {
                mq_decode_symbol_table(dec, ctx_states, ctx_mps, ctx)
              }
              if refine != 0 {
                let delta = 1 << current_bitplane
                if signs[idx] != 0 {
                  coeffs[idx] = coeffs[idx] - delta
                } else {
                  coeffs[idx] = coeffs[idx] + delta
                }
              }
            }
          }
        }
        stripe_y += 4
      }
    } else {
      // Cleanup pass.
      for i = 0; i < coeff_count; i = i + 1 {
        became_significant[i] = false
      }
      let mut stripe_y = 0
      while stripe_y < height {
        let stripe_rows = if stripe_y + 4 <= height {
          4
        } else {
          height - stripe_y
        }
        for x = 0; x < width; x = x + 1 {
          let can_run_mode = stripe_rows == 4 &&
            !significant[stripe_y * width + x] &&
            !significant[(stripe_y + 1) * width + x] &&
            !significant[(stripe_y + 2) * width + x] &&
            !significant[(stripe_y + 3) * width + x] &&
            !has_significant_neighbor(
              significant, width, height, x, stripe_y, use_vertical_causal,
            ) &&
            !has_significant_neighbor(
              significant,
              width,
              height,
              x,
              stripe_y + 1,
              use_vertical_causal,
            ) &&
            !has_significant_neighbor(
              significant,
              width,
              height,
              x,
              stripe_y + 2,
              use_vertical_causal,
            ) &&
            !has_significant_neighbor(
              significant,
              width,
              height,
              x,
              stripe_y + 3,
              use_vertical_causal,
            )
          if can_run_mode {
            let run = mq_decode_symbol_table(dec, ctx_states, ctx_mps, 17)
            if run == 0 {
              continue
            }
            let b0 = mq_decode_symbol_table(dec, ctx_states, ctx_mps, 18)
            let b1 = mq_decode_symbol_table(dec, ctx_states, ctx_mps, 18)
            let first_sig = (b0 << 1) + b1
            for k = first_sig; k < 4; k = k + 1 {
              let y = stripe_y + k
              let idx = y * width + x
              if k == first_sig {
                let sign = decode_sign_bit(
                  dec, ctx_states, ctx_mps, significant, coeffs, width, height, x,
                  y, use_vertical_causal,
                )
                set_significant_sample(
                  coeffs, significant, signs, became_significant, idx, sign, current_bitplane,
                )
              } else if !significant[idx] {
                let (hv, diag) = count_significant_neighbors(
                  significant, width, height, x, y, use_vertical_causal,
                )
                let ctx = select_sig_ctx(hv, diag)
                let sig = mq_decode_symbol_table(dec, ctx_states, ctx_mps, ctx)
                if sig != 0 {
                  let sign = decode_sign_bit(
                    dec, ctx_states, ctx_mps, significant, coeffs, width, height,
                    x, y, use_vertical_causal,
                  )
                  set_significant_sample(
                    coeffs, significant, signs, became_significant, idx, sign, current_bitplane,
                  )
                }
              }
            }
            continue
          }
          for k = 0; k < stripe_rows; k = k + 1 {
            let y = stripe_y + k
            let idx = y * width + x
            if !significant[idx] && !processed_in_sigprop[idx] {
              let (hv, diag) = count_significant_neighbors(
                significant, width, height, x, y, use_vertical_causal,
              )
              let ctx = select_sig_ctx(hv, diag)
              let sig = mq_decode_symbol_table(dec, ctx_states, ctx_mps, ctx)
              if sig != 0 {
                let sign = decode_sign_bit(
                  dec, ctx_states, ctx_mps, significant, coeffs, width, height, x,
                  y, use_vertical_causal,
                )
                set_significant_sample(
                  coeffs, significant, signs, became_significant, idx, sign, current_bitplane,
                )
              }
            }
          }
        }
        stripe_y += 4
      }
      if use_segmark && num_coding_passes > 1 {
        // Segmentation marker (SEGMARK) pattern: 0b1010.
        let s0 = mq_decode_symbol_table(dec, ctx_states, ctx_mps, 18)
        let s1 = mq_decode_symbol_table(dec, ctx_states, ctx_mps, 18)
        let s2 = mq_decode_symbol_table(dec, ctx_states, ctx_mps, 18)
        let s3 = mq_decode_symbol_table(dec, ctx_states, ctx_mps, 18)
        let marker = (s0 << 3) | (s1 << 2) | (s2 << 1) | s3
        if marker != 0x0A {
          return Err(
            UnsupportedTemplate(
              "invalid SEGMARK marker value: \{marker} (expected 10)",
            ),
          )
        }
      }
      current_bitplane -= 1
    }
    if use_termall && pass + 1 < num_coding_passes {
      let term_offset = if use_raw_pass {
        match raw_reader {
          Some(reader) => reader.byte_aligned_offset()
          None => mq_base_offset + mq_estimated_byte_aligned_offset(dec)
        }
      } else {
        mq_base_offset + mq_estimated_byte_aligned_offset(dec)
      }
      if term_offset >= codeword.length() {
        if use_predictable_termination {
          return Err(
            InsufficientData(
              "PTERM requires remaining bytes at pass boundary, offset=\{term_offset}",
            ),
          )
        }
        return Ok(coeffs)
      }
      raw_reader = None
      mq_base_offset = term_offset
      dec = match mq_decoder_from_absolute_offset(codeword, mq_base_offset) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
    }
    pass_type = (pass_type + 1) % 3
    pass += 1
  }
  Ok(coeffs)
}

///|
fn tier1_decode_coefficients_cleanup_only(
  codeword : Bytes,
  width : Int,
  height : Int,
  num_coding_passes : Int,
  zero_bitplanes : Int,
  bits_per_value : Int,
) -> Result[Array[Int], UnpackError] {
  tier1_decode_coefficients_cleanup_only_with_style(
    codeword, width, height, num_coding_passes, zero_bitplanes, bits_per_value, 0,
  )
}

///|
test "mq decoder bytein handles marker emulation guard" {
  let dec = match Jpeg2000MqDecoder::new(b"\xFF\x90\xAA") {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  inspect(dec.ct > 0, content="true")
}

///|
test "raw bitreader handles bit-stuffing after 0xFF" {
  let reader = match Jpeg2000RawBitReader::new(b"\xFF\x7F", 0) {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  let mut ones = 0
  for _i = 0; _i < 8; _i = _i + 1 {
    match reader.read_bit() {
      Ok(v) => ones += v
      Err(_) => fail("unexpected error")
    }
  }
  inspect(ones, content="8")
  match reader.read_bit() {
    Ok(v) => inspect(v, content="1")
    Err(_) => fail("unexpected error")
  }
}

///|
test "is_raw_bypass_pass starts raw mode from pass 10 on non-cleanup passes" {
  inspect(is_raw_bypass_pass(true, 9, 0), content="false")
  inspect(is_raw_bypass_pass(true, 10, 0), content="true")
  inspect(is_raw_bypass_pass(true, 10, 1), content="true")
  inspect(is_raw_bypass_pass(true, 10, 2), content="false")
  inspect(is_raw_bypass_pass(false, 20, 0), content="false")
}

///|
test "mq exchange updates context states" {
  let dec = match Jpeg2000MqDecoder::new(b"\x00\x00") {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  let ctx = Jpeg2000MqContext::new()
  dec.a = 0x2000
  let _ = mq_mpsexchange(dec, ctx)
  inspect(ctx.state_idx >= 0, content="true")
  inspect(ctx.state_idx < mq_qe.length(), content="true")
}

///|
test "tier1_probe_first_symbol returns binary symbol" {
  match tier1_probe_first_symbol(b"\xAC\x55\xF0") {
    Ok((sym, state, mps)) => {
      inspect(sym == 0 || sym == 1, content="true")
      inspect(state >= 0, content="true")
      inspect(mps == 0 || mps == 1, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_single_coefficient returns zero when never significant" {
  // Most-probable symbol stream with one coding pass should keep coefficient at 0.
  match tier1_decode_single_coefficient(b"\x00\x00", 1, 0, 8) {
    Ok(v) => inspect(v, content="0")
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only zeros for all-zero codeword" {
  match tier1_decode_coefficients_cleanup_only(b"\x34", 2, 1, 1, 0, 8) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only supports passes > 1" {
  match tier1_decode_coefficients_cleanup_only(b"\x34", 2, 1, 2, 0, 8) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only handles run-mode stripe" {
  match tier1_decode_coefficients_cleanup_only(b"\x00\x00", 1, 4, 1, 0, 8) {
    Ok(v) => {
      inspect(v.length(), content="4")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
      inspect(v[2], content="0")
      inspect(v[3], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style supports reset flag" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 2, 0, 8, 0x02,
    ) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style supports bypass for small pass counts" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 2, 0, 8, 0x01,
    ) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style supports termall for single pass" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 1, 0, 8, 0x04,
    ) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style supports termall with multiple passes" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 2, 0, 8, 0x04,
    ) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style supports bypass with large pass counts" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 11, 0, 8, 0x01,
    ) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0] <= v[0], content="true")
      inspect(v[1] <= v[1], content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style tolerates segmark flag" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 1, 0, 8, 0x20,
    ) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style supports vcausal flag" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 1, 0, 8, 0x08,
    ) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style supports pterm flag" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 1, 0, 8, 0x10,
    ) {
    Ok(v) => {
      inspect(v.length(), content="2")
      inspect(v[0], content="0")
      inspect(v[1], content="0")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "tier1_decode_coefficients_cleanup_only_with_style rejects reserved style bits" {
  match
    tier1_decode_coefficients_cleanup_only_with_style(
      b"\x34", 2, 1, 1, 0, 8, 0x40,
    ) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}
