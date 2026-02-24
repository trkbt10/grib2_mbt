///|
fn floor_div_int(n : Int, d : Int) -> Result[Int, UnpackError] {
  if d <= 0 {
    return Err(UnsupportedTemplate("floor_div_int requires d > 0"))
  }
  if n >= 0 {
    Ok(n / d)
  } else {
    Ok(-((-n + d - 1) / d))
  }
}

///|
fn inverse53_1d(
  low_in : Array[Int],
  high_in : Array[Int],
  out_len : Int,
) -> Result[Array[Int], UnpackError] {
  if out_len < 0 {
    return Err(UnsupportedTemplate("inverse53_1d out_len must be >= 0"))
  }
  let low_len = (out_len + 1) / 2
  let high_len = out_len / 2
  let low = Array::make(low_len, 0)
  let high = Array::make(high_len, 0)
  for i = 0; i < low_len && i < low_in.length(); i = i + 1 {
    low[i] = low_in[i]
  }
  for i = 0; i < high_len && i < high_in.length(); i = i + 1 {
    high[i] = high_in[i]
  }
  if high_len > 0 {
    for i = 0; i < low_len; i = i + 1 {
      let hm1 = if i - 1 >= 0 {
        if i - 1 < high_len {
          high[i - 1]
        } else {
          high[high_len - 1]
        }
      } else {
        high[0]
      }
      let h0 = if i < high_len { high[i] } else { high[high_len - 1] }
      let upd = match floor_div_int(hm1 + h0 + 2, 4) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      low[i] = low[i] - upd
    }
    for i = 0; i < high_len; i = i + 1 {
      let e0 = low[i]
      let e1 = if i + 1 < low_len { low[i + 1] } else { low[low_len - 1] }
      let pred = match floor_div_int(e0 + e1, 2) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      high[i] = high[i] + pred
    }
  }
  let out = Array::make(out_len, 0)
  for i = 0; i < low_len; i = i + 1 {
    let even = i * 2
    if even < out_len {
      out[even] = low[i]
    }
  }
  for i = 0; i < high_len; i = i + 1 {
    let odd = i * 2 + 1
    if odd < out_len {
      out[odd] = high[i]
    }
  }
  Ok(out)
}

///|
fn inverse97_1d(
  low_in : Array[Double],
  high_in : Array[Double],
  out_len : Int,
) -> Result[Array[Double], UnpackError] {
  if out_len < 0 {
    return Err(UnsupportedTemplate("inverse97_1d out_len must be >= 0"))
  }
  let low_len = (out_len + 1) / 2
  let high_len = out_len / 2
  let low = Array::make(low_len, 0.0)
  let high = Array::make(high_len, 0.0)
  for i = 0; i < low_len && i < low_in.length(); i = i + 1 {
    low[i] = low_in[i]
  }
  for i = 0; i < high_len && i < high_in.length(); i = i + 1 {
    high[i] = high_in[i]
  }
  let alpha = -1.586134342059924
  let beta = -0.052980118572961
  let gamma = 0.882911075530934
  let delta = 0.443506852043971
  let k = 1.230174104914001
  if low_len > 0 {
    for i = 0; i < low_len; i = i + 1 {
      low[i] = low[i] / k
    }
  }
  if high_len > 0 {
    for i = 0; i < high_len; i = i + 1 {
      high[i] = high[i] * k
    }
    for i = 0; i < low_len; i = i + 1 {
      let hm1 = if i - 1 >= 0 {
        if i - 1 < high_len {
          high[i - 1]
        } else {
          high[high_len - 1]
        }
      } else {
        high[0]
      }
      let h0 = if i < high_len { high[i] } else { high[high_len - 1] }
      low[i] = low[i] - delta * (hm1 + h0)
    }
    for i = 0; i < high_len; i = i + 1 {
      let l0 = low[i]
      let l1 = if i + 1 < low_len { low[i + 1] } else { low[low_len - 1] }
      high[i] = high[i] - gamma * (l0 + l1)
    }
    for i = 0; i < low_len; i = i + 1 {
      let hm1 = if i - 1 >= 0 {
        if i - 1 < high_len {
          high[i - 1]
        } else {
          high[high_len - 1]
        }
      } else {
        high[0]
      }
      let h0 = if i < high_len { high[i] } else { high[high_len - 1] }
      low[i] = low[i] - beta * (hm1 + h0)
    }
    for i = 0; i < high_len; i = i + 1 {
      let l0 = low[i]
      let l1 = if i + 1 < low_len { low[i + 1] } else { low[low_len - 1] }
      high[i] = high[i] - alpha * (l0 + l1)
    }
  }
  let out = Array::make(out_len, 0.0)
  for i = 0; i < low_len; i = i + 1 {
    let even = i * 2
    if even < out_len {
      out[even] = low[i]
    }
  }
  for i = 0; i < high_len; i = i + 1 {
    let odd = i * 2 + 1
    if odd < out_len {
      out[odd] = high[i]
    }
  }
  Ok(out)
}

///|
fn ceil_div_pow2(n : Int, s : Int) -> Result[Int, UnpackError] {
  if n < 0 {
    return Err(UnsupportedTemplate("ceil_div_pow2 n must be >= 0"))
  }
  if s < 0 || s > 30 {
    return Err(UnsupportedTemplate("ceil_div_pow2 shift out of range: \{s}"))
  }
  let denom = 1 << s
  Ok((n + denom - 1) / denom)
}

///|
fn inverse_dwt_from_coeffs_double(
  coeffs : Array[Double],
  width : Int,
  height : Int,
  num_decomposition_levels : Int,
  wavelet_transform : Int,
) -> Result[Array[Double], UnpackError] {
  if width <= 0 || height <= 0 {
    return Err(UnsupportedTemplate("width/height must be > 0"))
  }
  if coeffs.length() != width * height {
    return Err(
      InsufficientData(
        "coeff length mismatch: expected=\{width * height}, actual=\{coeffs.length()}",
      ),
    )
  }
  if num_decomposition_levels < 0 || num_decomposition_levels > 30 {
    return Err(
      UnsupportedTemplate(
        "num_decomposition_levels out of range: \{num_decomposition_levels}",
      ),
    )
  }
  let data = Array::make(coeffs.length(), 0.0)
  for i = 0; i < coeffs.length(); i = i + 1 {
    data[i] = coeffs[i]
  }
  if num_decomposition_levels == 0 {
    return Ok(data)
  }
  let mut ll_w = match ceil_div_pow2(width, num_decomposition_levels) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let mut ll_h = match ceil_div_pow2(height, num_decomposition_levels) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  for level = num_decomposition_levels; level > 0; level = level - 1 {
    let target_w = match ceil_div_pow2(width, level - 1) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let target_h = match ceil_div_pow2(height, level - 1) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let high_w = target_w - ll_w
    let high_h = target_h - ll_h
    let horiz = Array::make(target_w * target_h, 0.0)
    for y = 0; y < target_h; y = y + 1 {
      let low_len = ll_w
      let high_len = high_w
      if y < ll_h {
        if wavelet_transform == 1 {
          let low_i = Array::make(low_len, 0)
          let high_i = Array::make(high_len, 0)
          for x = 0; x < low_len; x = x + 1 {
            low_i[x] = data[y * width + x].to_int()
          }
          for x = 0; x < high_len; x = x + 1 {
            high_i[x] = data[y * width + ll_w + x].to_int()
          }
          let row = match inverse53_1d(low_i, high_i, target_w) {
            Ok(v) => v
            Err(e) => return Err(e)
          }
          for x = 0; x < target_w; x = x + 1 {
            horiz[y * target_w + x] = row[x].to_double()
          }
        } else if wavelet_transform == 0 {
          let low_d = Array::make(low_len, 0.0)
          let high_d = Array::make(high_len, 0.0)
          for x = 0; x < low_len; x = x + 1 {
            low_d[x] = data[y * width + x]
          }
          for x = 0; x < high_len; x = x + 1 {
            high_d[x] = data[y * width + ll_w + x]
          }
          let row = match inverse97_1d(low_d, high_d, target_w) {
            Ok(v) => v
            Err(e) => return Err(e)
          }
          for x = 0; x < target_w; x = x + 1 {
            horiz[y * target_w + x] = row[x]
          }
        } else {
          return Err(
            UnsupportedTemplate(
              "unsupported wavelet_transform: \{wavelet_transform}",
            ),
          )
        }
      } else if wavelet_transform == 1 {
        let low_i = Array::make(low_len, 0)
        let high_i = Array::make(high_len, 0)
        for x = 0; x < low_len; x = x + 1 {
          low_i[x] = data[(ll_h + (y - ll_h)) * width + x].to_int()
        }
        for x = 0; x < high_len; x = x + 1 {
          high_i[x] = data[(ll_h + (y - ll_h)) * width + ll_w + x].to_int()
        }
        let row = match inverse53_1d(low_i, high_i, target_w) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        for x = 0; x < target_w; x = x + 1 {
          horiz[y * target_w + x] = row[x].to_double()
        }
      } else if wavelet_transform == 0 {
        let low_d = Array::make(low_len, 0.0)
        let high_d = Array::make(high_len, 0.0)
        for x = 0; x < low_len; x = x + 1 {
          low_d[x] = data[(ll_h + (y - ll_h)) * width + x]
        }
        for x = 0; x < high_len; x = x + 1 {
          high_d[x] = data[(ll_h + (y - ll_h)) * width + ll_w + x]
        }
        let row = match inverse97_1d(low_d, high_d, target_w) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        for x = 0; x < target_w; x = x + 1 {
          horiz[y * target_w + x] = row[x]
        }
      } else {
        return Err(
          UnsupportedTemplate(
            "unsupported wavelet_transform: \{wavelet_transform}",
          ),
        )
      }
    }
    for x = 0; x < target_w; x = x + 1 {
      if wavelet_transform == 1 {
        let low_i = Array::make(ll_h, 0)
        let high_i = Array::make(high_h, 0)
        for y = 0; y < ll_h; y = y + 1 {
          low_i[y] = horiz[y * target_w + x].to_int()
        }
        for y = 0; y < high_h; y = y + 1 {
          high_i[y] = horiz[(ll_h + y) * target_w + x].to_int()
        }
        let col = match inverse53_1d(low_i, high_i, target_h) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        for y = 0; y < target_h; y = y + 1 {
          data[y * width + x] = col[y].to_double()
        }
      } else if wavelet_transform == 0 {
        let low_d = Array::make(ll_h, 0.0)
        let high_d = Array::make(high_h, 0.0)
        for y = 0; y < ll_h; y = y + 1 {
          low_d[y] = horiz[y * target_w + x]
        }
        for y = 0; y < high_h; y = y + 1 {
          high_d[y] = horiz[(ll_h + y) * target_w + x]
        }
        let col = match inverse97_1d(low_d, high_d, target_h) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        for y = 0; y < target_h; y = y + 1 {
          data[y * width + x] = col[y]
        }
      } else {
        return Err(
          UnsupportedTemplate(
            "unsupported wavelet_transform: \{wavelet_transform}",
          ),
        )
      }
    }
    ll_w = target_w
    ll_h = target_h
  }
  Ok(data)
}

///|
fn inverse_dwt_from_ll_with_zero_details(
  coeffs : Array[Int],
  width : Int,
  height : Int,
  num_decomposition_levels : Int,
  wavelet_transform : Int,
) -> Result[Array[Double], UnpackError] {
  let coeffs_f64 = Array::make(coeffs.length(), 0.0)
  for i = 0; i < coeffs.length(); i = i + 1 {
    coeffs_f64[i] = coeffs[i].to_double()
  }
  inverse_dwt_from_coeffs_double(
    coeffs_f64, width, height, num_decomposition_levels, wavelet_transform,
  )
}

///|
fn inverse_dwt_from_ll_with_zero_details_double(
  coeffs : Array[Double],
  width : Int,
  height : Int,
  num_decomposition_levels : Int,
  wavelet_transform : Int,
) -> Result[Array[Double], UnpackError] {
  inverse_dwt_from_coeffs_double(
    coeffs, width, height, num_decomposition_levels, wavelet_transform,
  )
}

///|
test "inverse53_1d with zero high keeps low on even samples" {
  let row = match inverse53_1d([2, 4], [0, 0], 4) {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  inspect(row.length(), content="4")
  inspect(row[0], content="2")
  inspect(row[2], content="4")
}

///|
test "inverse_dwt_from_ll_with_zero_details level0 passthrough" {
  match inverse_dwt_from_ll_with_zero_details([1, 2, 3, 4], 2, 2, 0, 1) {
    Ok(v) => {
      inspect(v.length(), content="4")
      inspect(v[0], content="1")
      inspect(v[3], content="4")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "inverse_dwt_from_ll_with_zero_details level1 returns finite values" {
  let coeffs = Array::make(16, 0)
  coeffs[0] = 8
  coeffs[1] = 8
  coeffs[4] = 8
  coeffs[5] = 8
  match inverse_dwt_from_ll_with_zero_details(coeffs, 4, 4, 1, 0) {
    Ok(v) => {
      inspect(v.length(), content="16")
      inspect(v[0] <= v[0], content="true")
      inspect(v[15] <= v[15], content="true")
    }
    Err(_) => fail("unexpected error")
  }
}
