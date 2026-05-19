///|
/// Flattened Section 4 product descriptor for JSON export. Ensemble-only and
/// probability-only fields collapse to -1 when the active template does not
/// carry them.
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
