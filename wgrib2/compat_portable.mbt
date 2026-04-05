///|
fn wgrib2_compatible_cosine_weight_from_latitude(
  latitude_deg : Double,
) -> Double {
  let conv = Float::from_double(3.14159265 / 180.0)
  @math.cosf(conv * Float::from_double(latitude_deg)).to_double()
}
