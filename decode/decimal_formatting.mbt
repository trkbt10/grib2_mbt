///|
/// Render a value expressed as a tenth of an integer (e.g. 105 → "10.5"). Used
/// by the level formatter when the GRIB2 scale factor implies a single
/// fractional digit.
fn format_decimal_tenths(value_x10 : Int) -> String {
  if value_x10 % 10 == 0 {
    (value_x10 / 10).to_string()
  } else {
    (value_x10 / 10).to_string() + "." + (value_x10 % 10).to_string()
  }
}

///|
fn trim_trailing_zeroes(text : String) -> String {
  let mut end = text.length()
  while end > 0 && text[end - 1].to_int() == '0'.to_int() {
    end -= 1
  }
  text[:end].to_string()
}

///|
/// Render `value * 10^(-scale)` as a human-readable decimal, trimming
/// redundant zeros after the point and preserving the sign.
fn format_scaled_decimal(value : Int, scale : Int) -> String {
  let negative = value < 0
  let magnitude = if negative { -value } else { value }
  if scale <= 0 {
    let mut out = magnitude.to_string()
    for _ in 0..<-scale {
      out += "0"
    }
    if negative {
      "-" + out
    } else {
      out
    }
  } else {
    let digits = magnitude.to_string()
    let out = if digits.length() > scale {
      let split_at = digits.length() - scale
      let whole = digits[:split_at].to_string()
      let fraction = trim_trailing_zeroes(digits[split_at:].to_string())
      if fraction == "" {
        whole
      } else {
        whole + "." + fraction
      }
    } else {
      let zeros = "0".repeat(scale - digits.length())
      let fraction = trim_trailing_zeroes(zeros + digits)
      if fraction == "" {
        "0"
      } else {
        "0." + fraction
      }
    }
    if negative {
      "-" + out
    } else {
      out
    }
  }
}
