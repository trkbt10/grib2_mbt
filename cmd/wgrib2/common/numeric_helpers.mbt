///|
/// `abs_double`: numeric helper that returns the absolute value of a
/// `Double`. MoonBit's stdlib historically lacked a shared `abs()` so the
/// CLI keeps a local copy here rather than pulling in `@math` just for this.
pub fn abs_double(v : Double) -> Double {
  if v < 0.0 {
    -v
  } else {
    v
  }
}
