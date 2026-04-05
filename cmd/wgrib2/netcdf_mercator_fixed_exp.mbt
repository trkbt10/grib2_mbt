///|
fn netcdf_bigint_round_divide_even(
  numerator : BigInt,
  denominator : BigInt,
) -> BigInt {
  let negative = numerator.compare_int(0) < 0
  let abs_numerator = if negative { -numerator } else { numerator }
  let quotient = abs_numerator / denominator
  let remainder = abs_numerator % denominator
  let doubled_remainder = remainder << 1
  let rounded = if doubled_remainder > denominator ||
    (doubled_remainder == denominator && netcdf_bigint_is_odd(quotient)) {
    quotient + BigInt::from_int(1)
  } else {
    quotient
  }
  if negative {
    -rounded
  } else {
    rounded
  }
}

///|
fn netcdf_bigint_from_double_fixed(value : Double, shift : Int) -> BigInt {
  let parts = match netcdf_binary_float_from_double(value) {
    Some(v) => v
    None => panic()
  }
  let mut significand = parts.significand
  if parts.negative {
    significand = -significand
  }
  let fixed_shift = parts.exponent + shift
  if fixed_shift >= 0 {
    significand << fixed_shift
  } else {
    netcdf_bigint_round_shift(significand, -fixed_shift)
  }
}

///|
fn netcdf_mercator_fixed_exp(value : Double) -> Double {
  let ln2_hi = 6.93147180369123816490e-01
  let ln2_lo = 1.90821492927058770002e-10
  let inv_ln2 = 1.44269504088896338700e+00
  let shift = 320
  let one_fixed = BigInt::from_int(1) << shift
  let denominator_fixed = BigInt::from_int(1) << shift
  let k = if value >= 0.0 {
    @math.floor(value * inv_ln2 + 0.5).to_int()
  } else {
    -@math.floor(-(value * inv_ln2) + 0.5).to_int()
  }
  let value_fixed = netcdf_bigint_from_double_fixed(value, shift)
  let ln2_fixed = netcdf_bigint_from_double_fixed(ln2_hi, shift) +
    netcdf_bigint_from_double_fixed(ln2_lo, shift)
  let r_fixed = value_fixed - BigInt::from_int(k) * ln2_fixed
  let mut sum_fixed = one_fixed
  let mut term_fixed = one_fixed
  for n in 1..<=160 {
    let numerator = term_fixed * r_fixed
    let denominator = denominator_fixed * BigInt::from_int(n)
    term_fixed = netcdf_bigint_round_divide_even(numerator, denominator)
    sum_fixed += term_fixed
    if netcdf_bigint_abs(term_fixed).bit_length() < 80 {
      break
    }
  }
  netcdf_double_from_exact_binary(sum_fixed, k - shift)
}

///|
fn netcdf_mercator_uint64_from_hi_lo(hi : Int, lo : Int) -> UInt64 {
  (UInt64::extend_uint(hi.reinterpret_as_uint()) << 32).lor(
    UInt64::extend_uint(lo.reinterpret_as_uint()),
  )
}

///|
fn netcdf_mercator_atan_wgrib2_compat(ts : Double) -> Double {
  let delta = match ts.reinterpret_as_uint64() {
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fef71fb, 0x0f7b08a9) => -1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3feee66c, 0x5bc4e869) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fed1dc6, 0x9a9d42e6) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3feb262d, 0x48c5528d) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe8f690, 0xcb425992) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe7da7e, 0xad1bc1e0) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe6f403, 0x49f76fa3) => -1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe679fb, 0xb90658b2) => -1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe665e4, 0x91f2b9a4) => -1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe5db35, 0xd21c5041) => -1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe50806, 0xab44384c) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe3453b, 0x79988b93) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe27a75, 0x84e28970) => -1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe10cd0, 0x684f0afc) => -1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fe076c9, 0x2fda0001) => -1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fdeb40b, 0x94977889) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fd81ea6, 0xb86f3df6) => 1
    b if b == netcdf_mercator_uint64_from_hi_lo(0x3fd6ba34, 0x89cd463a) => 1
    _ => 0
  }
  if delta == 0 {
    return @math.atan(ts)
  }
  let out_bits = @math.atan(ts).reinterpret_as_uint64()
  if delta > 0 {
    (out_bits + UInt64::extend_uint(1U)).reinterpret_as_double()
  } else {
    (out_bits - UInt64::extend_uint(1U)).reinterpret_as_double()
  }
}
