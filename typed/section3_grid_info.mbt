///|
/// Flattened Section 3 grid descriptor for JSON export. The variant-based
/// `Grib2Section3TemplateData` is rich but unfriendly for cross-language
/// serializers, so we project it into a uniform record where unsupported
/// dimensions report -1.
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
    @section3.GridTemplate310(g) =>
      {
        template_id: 10,
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
    @section3.GridTemplate340(g) =>
      {
        template_id: 40,
        ni: -1,
        nj: g.nj,
        la1: g.la1,
        lo1: g.lo1,
        la2: g.la2,
        lo2: g.lo2,
        di: g.di,
        dj: -1,
        scan_mode: g.scanning_mode,
        res_flags: g.resolution_and_component_flags,
      }
    @section3.GridTemplate341(g) =>
      {
        template_id: 41,
        ni: -1,
        nj: g.base.nj,
        la1: g.base.la1,
        lo1: g.base.lo1,
        la2: g.base.la2,
        lo2: g.base.lo2,
        di: g.base.di,
        dj: -1,
        scan_mode: g.base.scanning_mode,
        res_flags: g.base.resolution_and_component_flags,
      }
    @section3.GridTemplate342(g) =>
      {
        template_id: 42,
        ni: -1,
        nj: g.base.nj,
        la1: g.base.la1,
        lo1: g.base.lo1,
        la2: g.base.la2,
        lo2: g.base.lo2,
        di: g.base.di,
        dj: -1,
        scan_mode: g.base.scanning_mode,
        res_flags: g.base.resolution_and_component_flags,
      }
    @section3.GridTemplate343(g) =>
      {
        template_id: 43,
        ni: -1,
        nj: g.base.nj,
        la1: g.base.la1,
        lo1: g.base.lo1,
        la2: g.base.la2,
        lo2: g.base.lo2,
        di: g.base.di,
        dj: -1,
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
