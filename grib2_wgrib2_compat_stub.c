#include <math.h>
#include <moonbit.h>

#define GRIB2_MBT_WGRIB2_CONV (3.14159265 / 180.0)

MOONBIT_FFI_EXPORT
double grib2_mbt_wgrib2_cosine_weight_from_latitude(double latitude_deg) {
  return (double)cosf(((float)GRIB2_MBT_WGRIB2_CONV) * latitude_deg);
}
