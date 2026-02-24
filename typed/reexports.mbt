///|
pub using @section1 {
  type Grib2SectionCodecError,
  type Grib2Section1Decoded,
  decode_section1_bytes,
  encode_section1_bytes,
}

///|
pub using @section2 {
  type Grib2Section2Decoded,
  decode_section2_bytes,
  encode_section2_bytes,
}

///|
pub using @section3 {
  type Grib2Section3Decoded,
  type Grib2Section3TemplateData,
  type Grib2GridTemplate30,
  type Grib2GridTemplate31,
  decode_section3_bytes,
  encode_section3_bytes,
  // Coordinate generation
  type CoordinateGrid,
  type ScanningMode,
  generate_latlon_coordinates,
  generate_rotated_latlon_coordinates,
  parse_scanning_mode,
}

///|
/// Generate coordinates from Section 3 template data.
/// Returns None for unsupported templates.
pub fn generate_coordinates_from_section3(
  template : @section3.Grib2Section3TemplateData,
) -> @section3.CoordinateGrid? {
  match template {
    @section3.GridTemplate30(grid) =>
      Some(@section3.generate_latlon_coordinates(grid))
    @section3.GridTemplate31(grid) =>
      Some(@section3.generate_rotated_latlon_coordinates(grid))
    @section3.GridTemplate332768(grid) =>
      Some(@section3.generate_latlon_coordinates(grid.base))
    _ => None
  }
}

///|
/// Extract template ID from Section 3 template data.
pub fn get_section3_template_id(
  template : @section3.Grib2Section3TemplateData,
) -> Int {
  match template {
    @section3.GridTemplate30(_) => 0
    @section3.GridTemplate31(_) => 1
    @section3.GridTemplate32(_) => 2
    @section3.GridTemplate33(_) => 3
    @section3.GridTemplate34(_) => 4
    @section3.GridTemplate35(_) => 5
    @section3.GridTemplate310(_) => 10
    @section3.GridTemplate312(_) => 12
    @section3.GridTemplate313(_) => 13
    @section3.GridTemplate320(_) => 20
    @section3.GridTemplate323(_) => 23
    @section3.GridTemplate330(_) => 30
    @section3.GridTemplate331(_) => 31
    @section3.GridTemplate333(_) => 33
    @section3.GridTemplate340(_) => 40
    @section3.GridTemplate341(_) => 41
    @section3.GridTemplate342(_) => 42
    @section3.GridTemplate343(_) => 43
    @section3.GridTemplate350(_) => 50
    @section3.GridTemplate351(_) => 51
    @section3.GridTemplate352(_) => 52
    @section3.GridTemplate353(_) => 53
    @section3.GridTemplate360(_) => 60
    @section3.GridTemplate361(_) => 61
    @section3.GridTemplate362(_) => 62
    @section3.GridTemplate363(_) => 63
    @section3.GridTemplate390(_) => 90
    @section3.GridTemplate3100(_) => 100
    @section3.GridTemplate3101(_) => 101
    @section3.GridTemplate3110(_) => 110
    @section3.GridTemplate3120(_) => 120
    @section3.GridTemplate3140(_) => 140
    @section3.GridTemplate3150(_) => 150
    @section3.GridTemplate3204(_) => 204
    @section3.GridTemplate31000(_) => 1000
    @section3.GridTemplate31100(_) => 1100
    @section3.GridTemplate31200(_) => 1200
    @section3.GridTemplate332768(_) => 32768
    @section3.GridTemplate332769(_) => 32769
    @section3.GridTemplateUnknown(id, _) => id
  }
}

///|
/// Section 3 grid info struct for JSON export.
pub(all) struct Section3GridInfo {
  template_id : Int
  ni : Int
  nj : Int
  la1 : Int
  lo1 : Int
  la2 : Int
  lo2 : Int
  di : Int
  dj : Int
  scan_mode : Int
  res_flags : Int
}

///|
/// Extract common grid info from Section 3 template data.
/// Returns -1 for unsupported templates.
pub fn get_section3_grid_info(
  template : @section3.Grib2Section3TemplateData,
) -> Section3GridInfo {
  match template {
    @section3.GridTemplate30(g) =>
      {
        template_id: 0,
        ni: g.ni,
        nj: g.nj,
        la1: g.la1,
        lo1: g.lo1,
        la2: g.la2,
        lo2: g.lo2,
        di: g.di,
        dj: g.dj,
        scan_mode: g.scanning_mode,
        res_flags: g.resolution_and_component_flags,
      }
    @section3.GridTemplate31(g) =>
      {
        template_id: 1,
        ni: g.base.ni,
        nj: g.base.nj,
        la1: g.base.la1,
        lo1: g.base.lo1,
        la2: g.base.la2,
        lo2: g.base.lo2,
        di: g.base.di,
        dj: g.base.dj,
        scan_mode: g.base.scanning_mode,
        res_flags: g.base.resolution_and_component_flags,
      }
    @section3.GridTemplate332768(g) =>
      {
        template_id: 32768,
        ni: g.base.ni,
        nj: g.base.nj,
        la1: g.base.la1,
        lo1: g.base.lo1,
        la2: g.base.la2,
        lo2: g.base.lo2,
        di: g.base.di,
        dj: g.base.dj,
        scan_mode: g.base.scanning_mode,
        res_flags: g.base.resolution_and_component_flags,
      }
    _ =>
      {
        template_id: get_section3_template_id(template),
        ni: -1,
        nj: -1,
        la1: -1,
        lo1: -1,
        la2: -1,
        lo2: -1,
        di: -1,
        dj: -1,
        scan_mode: -1,
        res_flags: -1,
      }
  }
}

///|
pub using @section4 {
  type Grib2Section4Decoded,
  type Grib2Section4TemplateData,
  type Grib2ProductTemplate40,
  type Grib2ProductTemplate41,
  type Grib2ProductTemplate45,
  type Grib2ProductTemplate48,
  type Grib2ProductTemplate411,
  decode_section4_bytes,
  encode_section4_bytes,
}

///|
/// Section 4 product info struct for JSON export.
pub(all) struct Section4ProductInfo {
  template_id : Int
  param_cat : Int
  param_num : Int
  gen_process : Int
  time_unit : Int
  forecast_time : Int
  first_surface_type : Int
  first_surface_scale : Int
  first_surface_value : Int
  second_surface_type : Int
  second_surface_scale : Int
  second_surface_value : Int
  ensemble_type : Int
  perturb_num : Int
  ensemble_members : Int
  prob_type : Int
}

///|
fn from_template40_base(
  base : @section4.Grib2ProductTemplate40,
  template_id : Int,
) -> Section4ProductInfo {
  {
    template_id,
    param_cat: base.parameter_category,
    param_num: base.parameter_number,
    gen_process: base.type_of_generating_process,
    time_unit: base.time_range_unit,
    forecast_time: base.forecast_time,
    first_surface_type: base.type_of_first_fixed_surface,
    first_surface_scale: base.scale_factor_of_first_fixed_surface,
    first_surface_value: base.scaled_value_of_first_fixed_surface,
    second_surface_type: base.type_of_second_fixed_surface,
    second_surface_scale: base.scale_factor_of_second_fixed_surface,
    second_surface_value: base.scaled_value_of_second_fixed_surface,
    ensemble_type: -1,
    perturb_num: -1,
    ensemble_members: -1,
    prob_type: -1,
  }
}

///|
/// Extract product info from Section 4 template data.
pub fn get_section4_product_info(
  template : @section4.Grib2Section4TemplateData,
) -> Section4ProductInfo {
  match template {
    @section4.ProductTemplate40(t) => from_template40_base(t, 0)
    @section4.ProductTemplate41(t) => {
      let info = from_template40_base(t.base, 1)
      {
        ..info,
        ensemble_type: t.type_of_ensemble_forecast,
        perturb_num: t.perturbation_number,
        ensemble_members: t.number_of_forecasts_in_ensemble,
      }
    }
    @section4.ProductTemplate42(t) => from_template40_base(t.base, 2)
    @section4.ProductTemplate43(t) => from_template40_base(t.base, 3)
    @section4.ProductTemplate44(t) => from_template40_base(t.base, 4)
    @section4.ProductTemplate45(t) => {
      let info = from_template40_base(t.base, 5)
      { ..info, prob_type: t.probability_type }
    }
    @section4.ProductTemplate46(t) => from_template40_base(t.base, 6)
    @section4.ProductTemplate47(t) => from_template40_base(t.base, 7)
    @section4.ProductTemplate48(t) => from_template40_base(t.base, 8)
    @section4.ProductTemplate49(t) => {
      let info = from_template40_base(t.base.base, 9)
      { ..info, prob_type: t.base.probability_type }
    }
    @section4.ProductTemplate410(t) => from_template40_base(t.base.base, 10)
    @section4.ProductTemplate411(t) => {
      let info = from_template40_base(t.base.base, 11)
      {
        ..info,
        ensemble_type: t.base.type_of_ensemble_forecast,
        perturb_num: t.base.perturbation_number,
        ensemble_members: t.base.number_of_forecasts_in_ensemble,
      }
    }
    @section4.ProductTemplate412(t) => from_template40_base(t.base.base, 12)
    @section4.ProductTemplateUnknown(id, _) =>
      {
        template_id: id,
        param_cat: -1,
        param_num: -1,
        gen_process: -1,
        time_unit: -1,
        forecast_time: -1,
        first_surface_type: -1,
        first_surface_scale: -1,
        first_surface_value: -1,
        second_surface_type: -1,
        second_surface_scale: -1,
        second_surface_value: -1,
        ensemble_type: -1,
        perturb_num: -1,
        ensemble_members: -1,
        prob_type: -1,
      }
    _ =>
      {
        template_id: -1,
        param_cat: -1,
        param_num: -1,
        gen_process: -1,
        time_unit: -1,
        forecast_time: -1,
        first_surface_type: -1,
        first_surface_scale: -1,
        first_surface_value: -1,
        second_surface_type: -1,
        second_surface_scale: -1,
        second_surface_value: -1,
        ensemble_type: -1,
        perturb_num: -1,
        ensemble_members: -1,
        prob_type: -1,
      }
  }
}

///|
pub using @section5 {
  type Grib2Section5Decoded,
  type Grib2Section5TemplateData,
  type Grib2DataRepresentationTemplate50,
  type Grib2DataRepresentationTemplate52,
  type Grib2DataRepresentationTemplate53,
  type Grib2DataRepresentationTemplate540,
  decode_section5_bytes,
  encode_section5_bytes,
}

///|
/// Section 5 data representation info struct for JSON export.
pub(all) struct Section5DataInfo {
  template_id : Int
  reference_value_ieee : Int
  binary_scale : Int
  decimal_scale : Int
  bits_per_value : Int
}

///|
/// Extract data representation info from Section 5 template data.
pub fn get_section5_data_info(
  template : @section5.Grib2Section5TemplateData,
) -> Section5DataInfo {
  match template {
    @section5.DataRepresentationTemplate50(t) =>
      {
        template_id: 0,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate51(t) =>
      {
        template_id: 1,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate52(t) =>
      {
        template_id: 2,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate53(t) =>
      {
        template_id: 3,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate540(t) =>
      {
        template_id: 40,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplate541(t) =>
      {
        template_id: 41,
        reference_value_ieee: t.reference_value_ieee,
        binary_scale: t.binary_scale_factor,
        decimal_scale: t.decimal_scale_factor,
        bits_per_value: t.bits_per_value,
      }
    @section5.DataRepresentationTemplateUnknown(id, _) =>
      {
        template_id: id,
        reference_value_ieee: -1,
        binary_scale: -1,
        decimal_scale: -1,
        bits_per_value: -1,
      }
    _ =>
      {
        template_id: -1,
        reference_value_ieee: -1,
        binary_scale: -1,
        decimal_scale: -1,
        bits_per_value: -1,
      }
  }
}

///|
pub using @section6 {
  type Grib2Section6Decoded,
  decode_section6_bytes,
  encode_section6_bytes,
}

///|
pub using @section7 {
  type Grib2Section7Decoded,
  decode_section7_bytes,
  encode_section7_bytes,
  // Data unpacking
  type BitReader,
  type UnpackedGridData,
  type UnpackError,
  ieee754_single_to_double,
  u16_to_i16,
  unpack_ieee,
  unpack_simple,
  // JPEG2000/PNG unpackers
  unpack_jpeg2000,
  unpack_jpeg2000_differencing,
  get_jpeg2000_raw_bytes,
  get_jpeg2000_params,
  unpack_png,
  get_png_raw_bytes,
  // Complex packing unpackers
  unpack_complex,
  unpack_complex_spatial,
}
