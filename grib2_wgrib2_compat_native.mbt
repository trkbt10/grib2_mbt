///|
extern "c" fn native_wgrib2_cosine_weight_from_latitude(
  latitude_deg : Double,
) -> Double = "grib2_mbt_wgrib2_cosine_weight_from_latitude"

///|
fn wgrib2_compatible_cosine_weight_from_latitude(
  latitude_deg : Double,
) -> Double {
  native_wgrib2_cosine_weight_from_latitude(latitude_deg)
}
