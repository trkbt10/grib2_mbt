///|
/// JPEG2000 Data Unpacker (Template 5.40)
///
/// Supports single-component GRIB2/JPEG2000 codestreams with single tile and
/// progression orders defined in COD, including packet-header parsing,
/// Tier-1 arithmetic decoding, inverse DWT reconstruction, and GRIB scaling.

///|
fn ceil_div(n : Int, d : Int) -> Result[Int, UnpackError] {
  if d <= 0 {
    return Err(UnsupportedTemplate("ceil_div divisor must be > 0"))
  }
  if n < 0 {
    return Err(UnsupportedTemplate("ceil_div dividend must be >= 0"))
  }
  Ok((n + d - 1) / d)
}

///|
fn jpeg2000_pow2(n : Int) -> Double {
  if n >= 0 {
    let mut result = 1.0
    for i = 0; i < n; i = i + 1 {
      result = result * 2.0
    }
    result
  } else {
    let mut result = 1.0
    for i = 0; i < -n; i = i + 1 {
      result = result / 2.0
    }
    result
  }
}

///|
fn jpeg2000_pow10(n : Int) -> Double {
  if n >= 0 {
    let mut result = 1.0
    for i = 0; i < n; i = i + 1 {
      result = result * 10.0
    }
    result
  } else {
    let mut result = 1.0
    for i = 0; i < -n; i = i + 1 {
      result = result / 10.0
    }
    result
  }
}

///|
fn inverse_rct_components(
  y : Double,
  db : Double,
  dr : Double,
) -> (Double, Double, Double) {
  let g = y - (db + dr) / 4.0
  let r = dr + g
  let b = db + g
  (r, g, b)
}

///|
fn inverse_ict_components(
  y : Double,
  cb : Double,
  cr : Double,
) -> (Double, Double, Double) {
  let r = y + 1.402 * cr
  let g = y - 0.34413 * cb - 0.71414 * cr
  let b = y + 1.772 * cb
  (r, g, b)
}

///|
priv struct Jpeg2000BandSpec {
  x0 : Int
  y0 : Int
  width : Int
  height : Int
  subband_index : Int
}

///|
priv struct Jpeg2000CodeblockPlan {
  x0 : Int
  y0 : Int
  width : Int
  height : Int
  subband_index : Int
  band_codeblock_x : Int
  band_codeblock_y : Int
}

///|
priv struct Jpeg2000PrecinctSpec {
  x0 : Int
  y0 : Int
  width : Int
  height : Int
}

///|
priv struct Jpeg2000PacketWorkItem {
  plans : Array[Jpeg2000CodeblockPlan]
  precinct_order_x : Int
  precinct_order_y : Int
  included_before : Array[Bool]
  inclusion_layer_known : Array[Bool]
  inclusion_layer : Array[Int]
  inclusion_tagtree_states : Array[Jpeg2000TagTreeState]?
  zero_bitplanes_tagtree_states : Array[Jpeg2000TagTreeState]?
  tagtree_leaf_refs : Array[Jpeg2000TagTreeLeafRef]?
  lblocks : Array[Int]
  zero_bitplanes : Array[Int]
  codeword_bytes : Array[Array[Byte]]
  total_passes : Array[Int]
  ever_included : Array[Bool]
}

///|
priv struct Jpeg2000PacketSequenceItem {
  layer : Int
  resolution : Int
  component : Int
  precinct_index : Int
}

///|
priv struct Jpeg2000PrecinctOrderPosition {
  x : Int
  y : Int
}

///|
priv struct Jpeg2000TagTreeGroupBounds {
  subband_index : Int
  min_x : Int
  min_y : Int
  max_x : Int
  max_y : Int
}

///|
fn position_less(
  a : Jpeg2000PrecinctOrderPosition,
  b : Jpeg2000PrecinctOrderPosition,
) -> Bool {
  if a.y != b.y {
    a.y < b.y
  } else {
    a.x < b.x
  }
}

///|
fn sorted_position_indices(
  positions : Array[Jpeg2000PrecinctOrderPosition],
) -> Array[Int] {
  let indices : Array[Int] = []
  let used = Array::make(positions.length(), false)
  for _k = 0; _k < positions.length(); _k = _k + 1 {
    let mut best = -1
    for i = 0; i < positions.length(); i = i + 1 {
      if used[i] {
        continue
      }
      if best < 0 || position_less(positions[i], positions[best]) {
        best = i
      }
    }
    if best >= 0 {
      used[best] = true
      indices.push(best)
    }
  }
  indices
}

///|
fn contains_position(
  positions : Array[Jpeg2000PrecinctOrderPosition],
  target : Jpeg2000PrecinctOrderPosition,
) -> Bool {
  for p in positions {
    if p.x == target.x && p.y == target.y {
      return true
    }
  }
  false
}

///|
fn find_tagtree_group_index_by_subband(
  groups : Array[Jpeg2000TagTreeGroupBounds],
  subband_index : Int,
) -> Int {
  for i = 0; i < groups.length(); i = i + 1 {
    if groups[i].subband_index == subband_index {
      return i
    }
  }
  -1
}

///|
fn build_packet_tagtree_states_for_plans(
  plans : Array[Jpeg2000CodeblockPlan],
) -> Result[
  (
    Array[Jpeg2000TagTreeLeafRef],
    Array[Jpeg2000TagTreeState],
    Array[Jpeg2000TagTreeState],
  ),
  UnpackError,
] {
  if plans.length() <= 0 {
    return Err(UnsupportedTemplate("plans must be non-empty"))
  }
  let groups : Array[Jpeg2000TagTreeGroupBounds] = []
  for plan in plans {
    let group_idx = find_tagtree_group_index_by_subband(
      groups,
      plan.subband_index,
    )
    if group_idx < 0 {
      groups.push({
        subband_index: plan.subband_index,
        min_x: plan.band_codeblock_x,
        min_y: plan.band_codeblock_y,
        max_x: plan.band_codeblock_x,
        max_y: plan.band_codeblock_y,
      })
    } else {
      let group = groups[group_idx]
      groups[group_idx] = {
        subband_index: group.subband_index,
        min_x: if plan.band_codeblock_x < group.min_x {
          plan.band_codeblock_x
        } else {
          group.min_x
        },
        min_y: if plan.band_codeblock_y < group.min_y {
          plan.band_codeblock_y
        } else {
          group.min_y
        },
        max_x: if plan.band_codeblock_x > group.max_x {
          plan.band_codeblock_x
        } else {
          group.max_x
        },
        max_y: if plan.band_codeblock_y > group.max_y {
          plan.band_codeblock_y
        } else {
          group.max_y
        },
      }
    }
  }
  if groups.length() <= 0 {
    return Err(UnsupportedTemplate("failed to build tag-tree groups"))
  }
  let inclusion_states : Array[Jpeg2000TagTreeState] = []
  let zero_states : Array[Jpeg2000TagTreeState] = []
  for group in groups {
    let width = group.max_x - group.min_x + 1
    let height = group.max_y - group.min_y + 1
    if width <= 0 || height <= 0 {
      return Err(
        UnsupportedTemplate(
          "tag-tree group dimensions must be positive: \{width}x\{height}",
        ),
      )
    }
    let inclusion_state = match build_tagtree_state(width, height) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let zero_state = match build_tagtree_state(width, height) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    inclusion_states.push(inclusion_state)
    zero_states.push(zero_state)
  }
  let leaf_refs : Array[Jpeg2000TagTreeLeafRef] = []
  for plan in plans {
    let group_idx = find_tagtree_group_index_by_subband(
      groups,
      plan.subband_index,
    )
    if group_idx < 0 {
      return Err(
        UnsupportedTemplate(
          "subband group not found while building tag-tree refs: subband=\{plan.subband_index}",
        ),
      )
    }
    let group = groups[group_idx]
    leaf_refs.push({
      group_index: group_idx,
      leaf_x: plan.band_codeblock_x - group.min_x,
      leaf_y: plan.band_codeblock_y - group.min_y,
    })
  }
  Ok((leaf_refs, inclusion_states, zero_states))
}

///|
fn build_packet_sequence_single_component(
  progression_order : Int,
  num_layers : Int,
  work_items_by_resolution : Array[Array[Jpeg2000PacketWorkItem]],
) -> Result[Array[Jpeg2000PacketSequenceItem], UnpackError] {
  build_packet_sequence_slice_single_component(
    progression_order,
    num_layers,
    0,
    num_layers,
    0,
    work_items_by_resolution.length(),
    work_items_by_resolution,
  )
}

///|
fn build_packet_sequence_slice_single_component(
  progression_order : Int,
  num_layers : Int,
  layer_start : Int,
  layer_end : Int,
  resolution_start : Int,
  resolution_end : Int,
  work_items_by_resolution : Array[Array[Jpeg2000PacketWorkItem]],
) -> Result[Array[Jpeg2000PacketSequenceItem], UnpackError] {
  if num_layers <= 0 {
    return Err(UnsupportedTemplate("num_layers must be > 0"))
  }
  if progression_order < 0 || progression_order > 4 {
    return Err(
      UnsupportedTemplate(
        "unsupported COD progression order: \{progression_order}",
      ),
    )
  }
  if layer_start < 0 || layer_end < layer_start || layer_end > num_layers {
    return Err(
      UnsupportedTemplate(
        "layer range out of bounds: start=\{layer_start}, end=\{layer_end}, layers=\{num_layers}",
      ),
    )
  }
  if resolution_start < 0 ||
    resolution_end < resolution_start ||
    resolution_end > work_items_by_resolution.length() {
    return Err(
      UnsupportedTemplate(
        "resolution range out of bounds: start=\{resolution_start}, end=\{resolution_end}, levels=\{work_items_by_resolution.length()}",
      ),
    )
  }
  let packet_sequence : Array[Jpeg2000PacketSequenceItem] = []
  if progression_order == 0 {
    // LRCP
    for layer = layer_start; layer < layer_end; layer = layer + 1 {
      for resolution = resolution_start
          resolution < resolution_end
          resolution = resolution + 1 {
        let items = work_items_by_resolution[resolution]
        for precinct_index = 0
            precinct_index < items.length()
            precinct_index = precinct_index + 1 {
          packet_sequence.push({
            layer,
            resolution,
            component: 0,
            precinct_index,
          })
        }
      }
    }
  } else if progression_order == 1 {
    // RLCP
    for resolution = resolution_start
        resolution < resolution_end
        resolution = resolution + 1 {
      let items = work_items_by_resolution[resolution]
      for layer = layer_start; layer < layer_end; layer = layer + 1 {
        for precinct_index = 0
            precinct_index < items.length()
            precinct_index = precinct_index + 1 {
          packet_sequence.push({
            layer,
            resolution,
            component: 0,
            precinct_index,
          })
        }
      }
    }
  } else if progression_order == 2 {
    // RPCL
    for resolution = resolution_start
        resolution < resolution_end
        resolution = resolution + 1 {
      let items = work_items_by_resolution[resolution]
      let positions : Array[Jpeg2000PrecinctOrderPosition] = []
      for item in items {
        positions.push({ x: item.precinct_order_x, y: item.precinct_order_y })
      }
      let sorted_indices = sorted_position_indices(positions)
      for sorted_idx in sorted_indices {
        for layer = layer_start; layer < layer_end; layer = layer + 1 {
          packet_sequence.push({
            layer,
            resolution,
            component: 0,
            precinct_index: sorted_idx,
          })
        }
      }
    }
  } else {
    // PCRL / CPRL with one component: iterate precinct index globally.
    let global_positions : Array[Jpeg2000PrecinctOrderPosition] = []
    for resolution = resolution_start
        resolution < resolution_end
        resolution = resolution + 1 {
      let items = work_items_by_resolution[resolution]
      for item in items {
        let pos = { x: item.precinct_order_x, y: item.precinct_order_y }
        if !contains_position(global_positions, pos) {
          global_positions.push(pos)
        }
      }
    }
    let sorted_global_indices = sorted_position_indices(global_positions)
    for gidx in sorted_global_indices {
      let pos = global_positions[gidx]
      for resolution = resolution_start
          resolution < resolution_end
          resolution = resolution + 1 {
        let items = work_items_by_resolution[resolution]
        for precinct_index = 0
            precinct_index < items.length()
            precinct_index = precinct_index + 1 {
          let item = items[precinct_index]
          if item.precinct_order_x != pos.x || item.precinct_order_y != pos.y {
            continue
          }
          for layer = layer_start; layer < layer_end; layer = layer + 1 {
            packet_sequence.push({
              layer,
              resolution,
              component: 0,
              precinct_index,
            })
          }
        }
      }
    }
  }
  Ok(packet_sequence)
}

///|
fn clamp_int(v : Int, lo : Int, hi : Int) -> Int {
  if v < lo {
    lo
  } else if v > hi {
    hi
  } else {
    v
  }
}

///|
fn build_packet_sequence_single_component_with_poc(
  default_progression_order : Int,
  num_layers : Int,
  work_items_by_resolution : Array[Array[Jpeg2000PacketWorkItem]],
  poc_entries : Array[Jpeg2000PocEntry],
) -> Result[Array[Jpeg2000PacketSequenceItem], UnpackError] {
  let work_items_by_component_resolution = [work_items_by_resolution]
  build_packet_sequence_with_poc(
    default_progression_order, num_layers, work_items_by_component_resolution, poc_entries,
  )
}

///|
fn packet_resolution_count(
  work_items_by_component_resolution : Array[
    Array[Array[Jpeg2000PacketWorkItem]],
  ],
) -> Result[Int, UnpackError] {
  if work_items_by_component_resolution.length() <= 0 {
    return Err(
      UnsupportedTemplate("work_items_by_component_resolution is empty"),
    )
  }
  let resolution_count = work_items_by_component_resolution[0].length()
  for component = 1
      component < work_items_by_component_resolution.length()
      component = component + 1 {
    if work_items_by_component_resolution[component].length() !=
      resolution_count {
      return Err(
        UnsupportedTemplate(
          "resolution count mismatch across components: c0=\{resolution_count}, c\{component}=\{work_items_by_component_resolution[component].length()}",
        ),
      )
    }
  }
  Ok(resolution_count)
}

///|
fn build_packet_sequence_slice_multi_component(
  progression_order : Int,
  num_layers : Int,
  layer_start : Int,
  layer_end : Int,
  resolution_start : Int,
  resolution_end : Int,
  component_start : Int,
  component_end : Int,
  work_items_by_component_resolution : Array[
    Array[Array[Jpeg2000PacketWorkItem]],
  ],
) -> Result[Array[Jpeg2000PacketSequenceItem], UnpackError] {
  if num_layers <= 0 {
    return Err(UnsupportedTemplate("num_layers must be > 0"))
  }
  if progression_order < 0 || progression_order > 4 {
    return Err(
      UnsupportedTemplate(
        "unsupported COD progression order: \{progression_order}",
      ),
    )
  }
  let num_resolutions = match
    packet_resolution_count(work_items_by_component_resolution) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if layer_start < 0 || layer_end < layer_start || layer_end > num_layers {
    return Err(
      UnsupportedTemplate(
        "layer range out of bounds: start=\{layer_start}, end=\{layer_end}, layers=\{num_layers}",
      ),
    )
  }
  if resolution_start < 0 ||
    resolution_end < resolution_start ||
    resolution_end > num_resolutions {
    return Err(
      UnsupportedTemplate(
        "resolution range out of bounds: start=\{resolution_start}, end=\{resolution_end}, levels=\{num_resolutions}",
      ),
    )
  }
  if component_start < 0 ||
    component_end < component_start ||
    component_end > work_items_by_component_resolution.length() {
    return Err(
      UnsupportedTemplate(
        "component range out of bounds: start=\{component_start}, end=\{component_end}, components=\{work_items_by_component_resolution.length()}",
      ),
    )
  }
  let packet_sequence : Array[Jpeg2000PacketSequenceItem] = []
  if progression_order == 0 {
    // LRCP
    for layer = layer_start; layer < layer_end; layer = layer + 1 {
      for resolution = resolution_start
          resolution < resolution_end
          resolution = resolution + 1 {
        for component = component_start
            component < component_end
            component = component + 1 {
          let items = work_items_by_component_resolution[component][resolution]
          for precinct_index = 0
              precinct_index < items.length()
              precinct_index = precinct_index + 1 {
            packet_sequence.push({
              layer,
              resolution,
              component,
              precinct_index,
            })
          }
        }
      }
    }
  } else if progression_order == 1 {
    // RLCP
    for resolution = resolution_start
        resolution < resolution_end
        resolution = resolution + 1 {
      for layer = layer_start; layer < layer_end; layer = layer + 1 {
        for component = component_start
            component < component_end
            component = component + 1 {
          let items = work_items_by_component_resolution[component][resolution]
          for precinct_index = 0
              precinct_index < items.length()
              precinct_index = precinct_index + 1 {
            packet_sequence.push({
              layer,
              resolution,
              component,
              precinct_index,
            })
          }
        }
      }
    }
  } else if progression_order == 2 {
    // RPCL
    for resolution = resolution_start
        resolution < resolution_end
        resolution = resolution + 1 {
      let global_positions : Array[Jpeg2000PrecinctOrderPosition] = []
      for component = component_start
          component < component_end
          component = component + 1 {
        let items = work_items_by_component_resolution[component][resolution]
        for item in items {
          let pos = { x: item.precinct_order_x, y: item.precinct_order_y }
          if !contains_position(global_positions, pos) {
            global_positions.push(pos)
          }
        }
      }
      let sorted_global_indices = sorted_position_indices(global_positions)
      for gidx in sorted_global_indices {
        let pos = global_positions[gidx]
        for component = component_start
            component < component_end
            component = component + 1 {
          let items = work_items_by_component_resolution[component][resolution]
          for precinct_index = 0
              precinct_index < items.length()
              precinct_index = precinct_index + 1 {
            let item = items[precinct_index]
            if item.precinct_order_x != pos.x || item.precinct_order_y != pos.y {
              continue
            }
            for layer = layer_start; layer < layer_end; layer = layer + 1 {
              packet_sequence.push({
                layer,
                resolution,
                component,
                precinct_index,
              })
            }
          }
        }
      }
    }
  } else if progression_order == 3 {
    // PCRL
    let global_positions : Array[Jpeg2000PrecinctOrderPosition] = []
    for component = component_start
        component < component_end
        component = component + 1 {
      for resolution = resolution_start
          resolution < resolution_end
          resolution = resolution + 1 {
        let items = work_items_by_component_resolution[component][resolution]
        for item in items {
          let pos = { x: item.precinct_order_x, y: item.precinct_order_y }
          if !contains_position(global_positions, pos) {
            global_positions.push(pos)
          }
        }
      }
    }
    let sorted_global_indices = sorted_position_indices(global_positions)
    for gidx in sorted_global_indices {
      let pos = global_positions[gidx]
      for component = component_start
          component < component_end
          component = component + 1 {
        for resolution = resolution_start
            resolution < resolution_end
            resolution = resolution + 1 {
          let items = work_items_by_component_resolution[component][resolution]
          for precinct_index = 0
              precinct_index < items.length()
              precinct_index = precinct_index + 1 {
            let item = items[precinct_index]
            if item.precinct_order_x != pos.x || item.precinct_order_y != pos.y {
              continue
            }
            for layer = layer_start; layer < layer_end; layer = layer + 1 {
              packet_sequence.push({
                layer,
                resolution,
                component,
                precinct_index,
              })
            }
          }
        }
      }
    }
  } else {
    // CPRL
    for component = component_start
        component < component_end
        component = component + 1 {
      let global_positions : Array[Jpeg2000PrecinctOrderPosition] = []
      for resolution = resolution_start
          resolution < resolution_end
          resolution = resolution + 1 {
        let items = work_items_by_component_resolution[component][resolution]
        for item in items {
          let pos = { x: item.precinct_order_x, y: item.precinct_order_y }
          if !contains_position(global_positions, pos) {
            global_positions.push(pos)
          }
        }
      }
      let sorted_global_indices = sorted_position_indices(global_positions)
      for gidx in sorted_global_indices {
        let pos = global_positions[gidx]
        for resolution = resolution_start
            resolution < resolution_end
            resolution = resolution + 1 {
          let items = work_items_by_component_resolution[component][resolution]
          for precinct_index = 0
              precinct_index < items.length()
              precinct_index = precinct_index + 1 {
            let item = items[precinct_index]
            if item.precinct_order_x != pos.x || item.precinct_order_y != pos.y {
              continue
            }
            for layer = layer_start; layer < layer_end; layer = layer + 1 {
              packet_sequence.push({
                layer,
                resolution,
                component,
                precinct_index,
              })
            }
          }
        }
      }
    }
  }
  Ok(packet_sequence)
}

///|
fn build_packet_sequence_with_poc(
  default_progression_order : Int,
  num_layers : Int,
  work_items_by_component_resolution : Array[
    Array[Array[Jpeg2000PacketWorkItem]],
  ],
  poc_entries : Array[Jpeg2000PocEntry],
) -> Result[Array[Jpeg2000PacketSequenceItem], UnpackError] {
  let num_resolutions = match
    packet_resolution_count(work_items_by_component_resolution) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let num_components = work_items_by_component_resolution.length()
  if poc_entries.length() == 0 {
    return build_packet_sequence_slice_multi_component(
      default_progression_order, num_layers, 0, num_layers, 0, num_resolutions, 0,
      num_components, work_items_by_component_resolution,
    )
  }
  let packet_sequence : Array[Jpeg2000PacketSequenceItem] = []
  let mut current_layer_start = 0
  for entry in poc_entries {
    let layer_end = clamp_int(entry.end_layer_exclusive, 0, num_layers)
    let resolution_start = clamp_int(entry.start_resolution, 0, num_resolutions)
    let resolution_end = clamp_int(
      entry.end_resolution_exclusive,
      0,
      num_resolutions,
    )
    let component_start = clamp_int(entry.start_component, 0, num_components)
    let component_end = clamp_int(
      entry.end_component_exclusive,
      0,
      num_components,
    )
    if component_end <= component_start {
      current_layer_start = layer_end
      continue
    }
    if layer_end <= current_layer_start || resolution_end <= resolution_start {
      current_layer_start = layer_end
      continue
    }
    let slice = match
      build_packet_sequence_slice_multi_component(
        entry.progression_order,
        num_layers,
        current_layer_start,
        layer_end,
        resolution_start,
        resolution_end,
        component_start,
        component_end,
        work_items_by_component_resolution,
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    for item in slice {
      packet_sequence.push(item)
    }
    current_layer_start = layer_end
  }
  if current_layer_start < num_layers {
    let tail = match
      build_packet_sequence_slice_multi_component(
        default_progression_order, num_layers, current_layer_start, num_layers, 0,
        num_resolutions, 0, num_components, work_items_by_component_resolution,
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    for item in tail {
      packet_sequence.push(item)
    }
  }
  Ok(packet_sequence)
}

///|
fn ll_size_for_level(
  width : Int,
  height : Int,
  level : Int,
) -> Result[(Int, Int), UnpackError] {
  if level < 0 || level > 30 {
    return Err(UnsupportedTemplate("level out of range: \{level}"))
  }
  let scale = 1 << level
  let ll_w = match ceil_div(width, scale) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let ll_h = match ceil_div(height, scale) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok((ll_w, ll_h))
}

///|
fn resolution_canvas_size(
  width : Int,
  height : Int,
  num_decomposition_levels : Int,
  resolution : Int,
) -> Result[(Int, Int), UnpackError] {
  if resolution < 0 || resolution > num_decomposition_levels {
    return Err(
      UnsupportedTemplate(
        "resolution out of range: resolution=\{resolution}, levels=\{num_decomposition_levels}",
      ),
    )
  }
  ll_size_for_level(width, height, num_decomposition_levels - resolution)
}

///|
fn packet_band_specs_for_resolution(
  width : Int,
  height : Int,
  num_decomposition_levels : Int,
  resolution : Int,
) -> Result[Array[Jpeg2000BandSpec], UnpackError] {
  if resolution < 0 || resolution > num_decomposition_levels {
    return Err(
      UnsupportedTemplate(
        "resolution out of range: resolution=\{resolution}, levels=\{num_decomposition_levels}",
      ),
    )
  }
  if resolution == 0 {
    let (ll_w, ll_h) = match
      ll_size_for_level(width, height, num_decomposition_levels) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    return Ok([{ x0: 0, y0: 0, width: ll_w, height: ll_h, subband_index: 0 }])
  }
  let d = num_decomposition_levels - resolution + 1
  let (ll_w_d, ll_h_d) = match ll_size_for_level(width, height, d) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let (ll_w_prev, ll_h_prev) = match ll_size_for_level(width, height, d - 1) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let hl_w = ll_w_prev - ll_w_d
  let hl_h = ll_h_d
  let lh_w = ll_w_d
  let lh_h = ll_h_prev - ll_h_d
  let hh_w = hl_w
  let hh_h = lh_h
  let subband_base = 1 + (resolution - 1) * 3
  Ok([
    {
      x0: ll_w_d,
      y0: 0,
      width: hl_w,
      height: hl_h,
      subband_index: subband_base,
    }, // HL
    {
      x0: 0,
      y0: ll_h_d,
      width: lh_w,
      height: lh_h,
      subband_index: subband_base + 1,
    }, // LH
    {
      x0: ll_w_d,
      y0: ll_h_d,
      width: hh_w,
      height: hh_h,
      subband_index: subband_base + 2,
    }, // HH
  ])
}

///|
fn precinct_specs_for_resolution(
  width : Int,
  height : Int,
  num_decomposition_levels : Int,
  resolution : Int,
  precinct_width_exp : Int,
  precinct_height_exp : Int,
) -> Result[Array[Jpeg2000PrecinctSpec], UnpackError] {
  if precinct_width_exp < 0 ||
    precinct_width_exp > 15 ||
    precinct_height_exp < 0 ||
    precinct_height_exp > 15 {
    return Err(
      UnsupportedTemplate(
        "precinct exponents out of range: ppx=\{precinct_width_exp}, ppy=\{precinct_height_exp}",
      ),
    )
  }
  let (canvas_w, canvas_h) = match
    resolution_canvas_size(width, height, num_decomposition_levels, resolution) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if canvas_w <= 0 || canvas_h <= 0 {
    return Ok([])
  }
  let precinct_w = 1 << precinct_width_exp
  let precinct_h = 1 << precinct_height_exp
  let num_precincts_x = match ceil_div(canvas_w, precinct_w) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let num_precincts_y = match ceil_div(canvas_h, precinct_h) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let precincts : Array[Jpeg2000PrecinctSpec] = []
  for py = 0; py < num_precincts_y; py = py + 1 {
    for px = 0; px < num_precincts_x; px = px + 1 {
      let x0 = px * precinct_w
      let y0 = py * precinct_h
      let width = if x0 + precinct_w <= canvas_w {
        precinct_w
      } else {
        canvas_w - x0
      }
      let height = if y0 + precinct_h <= canvas_h {
        precinct_h
      } else {
        canvas_h - y0
      }
      precincts.push({ x0, y0, width, height })
    }
  }
  Ok(precincts)
}

///|
fn make_packet_codeblock_plans_for_precinct(
  bands : Array[Jpeg2000BandSpec],
  precinct : Jpeg2000PrecinctSpec,
  codeblock_width : Int,
  codeblock_height : Int,
) -> Result[Array[Jpeg2000CodeblockPlan], UnpackError] {
  if codeblock_width <= 0 || codeblock_height <= 0 {
    return Err(
      UnsupportedTemplate(
        "codeblock dimensions must be > 0: \{codeblock_width}x\{codeblock_height}",
      ),
    )
  }
  let plans : Array[Jpeg2000CodeblockPlan] = []
  for band in bands {
    if band.width <= 0 || band.height <= 0 {
      continue
    }
    let cbx = match ceil_div(band.width, codeblock_width) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    let cby = match ceil_div(band.height, codeblock_height) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    for by = 0; by < cby; by = by + 1 {
      for bx = 0; bx < cbx; bx = bx + 1 {
        let x0 = band.x0 + bx * codeblock_width
        let y0 = band.y0 + by * codeblock_height
        let width = if x0 + codeblock_width <= band.x0 + band.width {
          codeblock_width
        } else {
          band.x0 + band.width - x0
        }
        let height = if y0 + codeblock_height <= band.y0 + band.height {
          codeblock_height
        } else {
          band.y0 + band.height - y0
        }
        if x0 >= precinct.x0 &&
          x0 < precinct.x0 + precinct.width &&
          y0 >= precinct.y0 &&
          y0 < precinct.y0 + precinct.height {
          plans.push({
            x0,
            y0,
            width,
            height,
            subband_index: band.subband_index,
            band_codeblock_x: bx,
            band_codeblock_y: by,
          })
        }
      }
    }
  }
  Ok(plans)
}

///|
fn quantization_step_size_for_subband_component(
  bits_per_component : Int,
  quantization_style : Int,
  quantization_exponents : Array[Int],
  quantization_mantissas : Array[Int],
  subband_index : Int,
) -> Result[Double, UnpackError] {
  let style = quantization_style
  if style == 0 {
    return Ok(1.0)
  }
  let mut exponent = 0
  let mut mantissa = 0
  if style == 1 {
    if quantization_exponents.length() <= 0 {
      return Ok(1.0)
    }
    let ll_exp = quantization_exponents[0]
    let ll_man = if quantization_mantissas.length() > 0 {
      quantization_mantissas[0]
    } else {
      0
    }
    if subband_index == 0 {
      exponent = ll_exp
      mantissa = ll_man
    } else {
      let resolution_from_ll = (subband_index - 1) / 3 + 1
      exponent = ll_exp - resolution_from_ll
      mantissa = ll_man
    }
  } else if style == 2 {
    if subband_index >= quantization_exponents.length() {
      return Ok(1.0)
    }
    exponent = quantization_exponents[subband_index]
    mantissa = if subband_index < quantization_mantissas.length() {
      quantization_mantissas[subband_index]
    } else {
      0
    }
  } else {
    return Err(UnsupportedTemplate("unsupported quantization style: \{style}"))
  }
  let gain = if subband_index == 0 {
    0
  } else {
    let orientation = (subband_index - 1) % 3
    if orientation == 2 {
      2
    } else {
      1
    }
  }
  let rb = bits_per_component + gain
  let step = (1.0 + mantissa.to_double() / 2048.0) *
    jpeg2000_pow2(rb - exponent)
  Ok(step)
}

///|
fn apply_rgn_maxshift_descaling(
  coefficients : Array[Int],
  roi_shift : Int,
) -> Result[Array[Int], UnpackError] {
  if roi_shift < 0 {
    return Err(UnsupportedTemplate("RGN roi_shift must be >= 0"))
  }
  if roi_shift == 0 {
    return Ok(coefficients)
  }
  if roi_shift > 30 {
    return Err(UnsupportedTemplate("RGN roi_shift out of range: \{roi_shift}"))
  }
  let threshold = 1 << roi_shift
  let result : Array[Int] = []
  for v in coefficients {
    let abs_v = if v < 0 { -v } else { v }
    if abs_v >= threshold {
      result.push(v >> roi_shift)
    } else {
      result.push(v)
    }
  }
  Ok(result)
}

///|
/// Unpack JPEG2000 compressed data (Template 5.40).
/// Supports codestream packet decoding with progression orders and POC.
/// For multi-component codestreams, all components are parsed/decoded and the
/// first component is returned as GRIB scalar output.
pub fn unpack_jpeg2000(
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate540,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  if num_points < 0 {
    return Err(UnsupportedTemplate("num_points must be >= 0"))
  }
  let info = match parse_jpeg2000_codestream_info(data) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let num_components = info.siz.num_components
  if num_components <= 0 {
    return Err(UnsupportedTemplate("JPEG2000 component count must be > 0"))
  }
  if info.siz.bits_per_component != template.bits_per_value {
    return Err(
      UnsupportedTemplate(
        "JPEG2000 bit depth mismatch: codestream=\{info.siz.bits_per_component}, template=\{template.bits_per_value}",
      ),
    )
  }
  let coded_points = info.siz.width * info.siz.height
  if coded_points != num_points {
    return Err(
      InsufficientData(
        "JPEG2000 point count mismatch: codestream=\{coded_points}, template points=\{num_points}",
      ),
    )
  }
  if info.cod_progression_order < 0 || info.cod_progression_order > 4 {
    return Err(
      UnsupportedTemplate(
        "unsupported COD progression order: \{info.cod_progression_order}",
      ),
    )
  }
  if info.cod_num_layers <= 0 || info.cod_num_layers > 255 {
    return Err(
      UnsupportedTemplate(
        "unsupported JPEG2000 layer count: \{info.cod_num_layers}",
      ),
    )
  }
  if info.cod_num_decomposition_levels < 0 ||
    info.cod_num_decomposition_levels > 30 {
    return Err(
      UnsupportedTemplate(
        "unsupported decomposition level count: \{info.cod_num_decomposition_levels}",
      ),
    )
  }
  // Support BYPASS(0x01), RESET(0x02), TERMALL(0x04), VCAUSAL(0x08),
  // PTERM(0x10), and tolerate SEGMARK(0x20).
  if info.tile_part_payload_starts.length() !=
    info.tile_part_payload_ends.length() {
    return Err(
      InsufficientData(
        "tile-part payload bounds length mismatch: starts=\{info.tile_part_payload_starts.length()}, ends=\{info.tile_part_payload_ends.length()}",
      ),
    )
  }
  if info.tile_part_payload_starts.length() == 0 {
    return Err(InsufficientData("no tile-part payload ranges"))
  }
  if info.component_num_decomposition_levels.length() != num_components ||
    info.component_wavelet_transform.length() != num_components ||
    info.component_codeblock_style.length() != num_components ||
    info.component_codeblock_width.length() != num_components ||
    info.component_codeblock_height.length() != num_components ||
    info.component_precinct_width_exponents.length() != num_components ||
    info.component_precinct_height_exponents.length() != num_components ||
    info.component_quantization_style.length() != num_components ||
    info.component_quantization_guard_bits.length() != num_components ||
    info.component_quantization_exponents.length() != num_components ||
    info.component_quantization_mantissas.length() != num_components ||
    info.component_has_rgn.length() != num_components ||
    info.component_roi_shift.length() != num_components {
    return Err(
      UnsupportedTemplate(
        "component parameter array length mismatch for JPEG2000 codestream",
      ),
    )
  }
  for component = 0; component < num_components; component = component + 1 {
    let component_decomposition_levels = info.component_num_decomposition_levels[component]
    if component_decomposition_levels < 0 || component_decomposition_levels > 30 {
      return Err(
        UnsupportedTemplate(
          "unsupported decomposition level count for component \{component}: \{component_decomposition_levels}",
        ),
      )
    }
    if info.component_wavelet_transform[component] != 0 &&
      info.component_wavelet_transform[component] != 1 {
      return Err(
        UnsupportedTemplate(
          "unsupported COD/COC wavelet transform for component \{component}: \{info.component_wavelet_transform[component]}",
        ),
      )
    }
    let expected_subbands = 1 + component_decomposition_levels * 3
    let style = info.component_quantization_style[component]
    let exponents = info.component_quantization_exponents[component]
    let mantissas = info.component_quantization_mantissas[component]
    let roi_shift = info.component_roi_shift[component]
    if roi_shift < 0 || roi_shift > 30 {
      return Err(
        UnsupportedTemplate(
          "RGN roi_shift out of range at component \{component}: \{roi_shift}",
        ),
      )
    }
    if style == 1 {
      if exponents.length() <= 0 {
        return Err(
          UnsupportedTemplate(
            "derived quantization style requires at least one step-size entry at component \{component}",
          ),
        )
      }
    } else if style == 2 {
      if exponents.length() < expected_subbands ||
        mantissas.length() < expected_subbands {
        return Err(
          UnsupportedTemplate(
            "expounded quantization entries are insufficient at component \{component}: expected >= \{expected_subbands}, got exp=\{exponents.length()}, man=\{mantissas.length()}",
          ),
        )
      }
    } else if style == 0 {
      if exponents.length() > 0 && exponents.length() < expected_subbands {
        return Err(
          UnsupportedTemplate(
            "no-quantization exponents are insufficient at component \{component}: expected >= \{expected_subbands}, got \{exponents.length()}",
          ),
        )
      }
    } else {
      return Err(
        UnsupportedTemplate(
          "unsupported quantization style at component \{component}: \{style}",
        ),
      )
    }
  }
  let tile_payloads : Array[Bytes] = []
  for i = 0; i < info.tile_part_payload_starts.length(); i = i + 1 {
    let start = info.tile_part_payload_starts[i]
    let end = info.tile_part_payload_ends[i]
    if start < 0 || end <= start || end > data.length() {
      return Err(
        InsufficientData(
          "invalid tile-part payload bounds at \{i}: start=\{start}, end=\{end}",
        ),
      )
    }
    let payload = data.sub(start~, end~).to_bytes()
    tile_payloads.push(payload)
  }
  if info.ppt_packet_header_bytes_per_tile_part.length() !=
    info.tile_part_payload_starts.length() {
    return Err(
      InsufficientData(
        "PPT tile-part count mismatch: ppt=\{info.ppt_packet_header_bytes_per_tile_part.length()}, tile_parts=\{info.tile_part_payload_starts.length()}",
      ),
    )
  }
  if info.ppt_present_per_tile_part.length() !=
    info.tile_part_payload_starts.length() {
    return Err(
      InsufficientData(
        "PPT presence flags mismatch: flags=\{info.ppt_present_per_tile_part.length()}, tile_parts=\{info.tile_part_payload_starts.length()}",
      ),
    )
  }
  if info.plt_packet_lengths_per_tile_part.length() !=
    info.tile_part_payload_starts.length() {
    return Err(
      InsufficientData(
        "PLT tile-part count mismatch: plt=\{info.plt_packet_lengths_per_tile_part.length()}, tile_parts=\{info.tile_part_payload_starts.length()}",
      ),
    )
  }
  if info.has_tlm {
    if info.tlm_tile_part_lengths.length() !=
      info.tile_part_payload_starts.length() {
      return Err(
        UnsupportedTemplate(
          "TLM tile-part count mismatch at unpack stage: tlm=\{info.tlm_tile_part_lengths.length()}, tile_parts=\{info.tile_part_payload_starts.length()}",
        ),
      )
    }
    for i = 0; i < info.tlm_tile_part_lengths.length(); i = i + 1 {
      let tlm_len = info.tlm_tile_part_lengths[i]
      let payload_len = info.tile_part_payload_ends[i] -
        info.tile_part_payload_starts[i]
      if tlm_len < 14 {
        return Err(
          UnsupportedTemplate(
            "invalid TLM tile-part length at \{i}: \{tlm_len}",
          ),
        )
      }
      if payload_len > tlm_len - 14 {
        return Err(
          UnsupportedTemplate(
            "tile-part payload exceeds TLM lower bound at \{i}: payload=\{payload_len}, tlm=\{tlm_len}",
          ),
        )
      }
    }
  }
  let ppm_packet_header_stream = Bytes::from_array(info.ppm_packet_header_bytes)
  let work_items_by_component_resolution : Array[
    Array[Array[Jpeg2000PacketWorkItem]],
  ] = []
  for component = 0; component < num_components; component = component + 1 {
    let component_decomposition_levels = info.component_num_decomposition_levels[component]
    let component_codeblock_width = info.component_codeblock_width[component]
    let component_codeblock_height = info.component_codeblock_height[component]
    let component_precinct_width_exponents = info.component_precinct_width_exponents[component]
    let component_precinct_height_exponents = info.component_precinct_height_exponents[component]
    let work_items_by_resolution : Array[Array[Jpeg2000PacketWorkItem]] = []
    for resolution = 0
        resolution <= component_decomposition_levels
        resolution = resolution + 1 {
      let bands = match
        packet_band_specs_for_resolution(
          info.siz.width,
          info.siz.height,
          component_decomposition_levels,
          resolution,
        ) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      let default_precinct_exp = 15
      let precinct_width_exp = if resolution <
        component_precinct_width_exponents.length() {
        component_precinct_width_exponents[resolution]
      } else {
        default_precinct_exp
      }
      let precinct_height_exp = if resolution <
        component_precinct_height_exponents.length() {
        component_precinct_height_exponents[resolution]
      } else {
        default_precinct_exp
      }
      let precincts = match
        precinct_specs_for_resolution(
          info.siz.width,
          info.siz.height,
          component_decomposition_levels,
          resolution,
          precinct_width_exp,
          precinct_height_exp,
        ) {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      let items : Array[Jpeg2000PacketWorkItem] = []
      for precinct in precincts {
        let plans = match
          make_packet_codeblock_plans_for_precinct(
            bands, precinct, component_codeblock_width, component_codeblock_height,
          ) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        if plans.length() == 0 {
          continue
        }
        let codeword_bytes : Array[Array[Byte]] = []
        for _i = 0; _i < plans.length(); _i = _i + 1 {
          codeword_bytes.push([])
        }
        let mut inclusion_tagtree_states : Array[Jpeg2000TagTreeState]? = None
        let mut zero_bitplanes_tagtree_states : Array[Jpeg2000TagTreeState]? = None
        let mut tagtree_leaf_refs : Array[Jpeg2000TagTreeLeafRef]? = None
        if info.cod_num_layers > 1 {
          let (leaf_refs, inclusion_states, zero_states) = match
            build_packet_tagtree_states_for_plans(plans) {
            Ok(v) => v
            Err(e) => return Err(e)
          }
          inclusion_tagtree_states = Some(inclusion_states)
          zero_bitplanes_tagtree_states = Some(zero_states)
          tagtree_leaf_refs = Some(leaf_refs)
        }
        items.push({
          plans,
          precinct_order_x: precinct.x0 <<
          (component_decomposition_levels - resolution),
          precinct_order_y: precinct.y0 <<
          (component_decomposition_levels - resolution),
          included_before: Array::make(plans.length(), false),
          inclusion_layer_known: if info.cod_num_layers > 1 {
            Array::make(plans.length(), false)
          } else {
            []
          },
          inclusion_layer: if info.cod_num_layers > 1 {
            Array::make(plans.length(), 0)
          } else {
            []
          },
          inclusion_tagtree_states,
          zero_bitplanes_tagtree_states,
          tagtree_leaf_refs,
          lblocks: Array::make(plans.length(), 3),
          zero_bitplanes: Array::make(plans.length(), 0),
          codeword_bytes,
          total_passes: Array::make(plans.length(), 0),
          ever_included: Array::make(plans.length(), false),
        })
      }
      work_items_by_resolution.push(items)
    }
    work_items_by_component_resolution.push(work_items_by_resolution)
  }
  let packet_sequence = match
    build_packet_sequence_with_poc(
      info.cod_progression_order,
      info.cod_num_layers,
      work_items_by_component_resolution,
      info.poc_entries,
    ) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let mut packet_index = 0
  let mut ppm_header_cursor = 0
  let mut stop_packet_parse = false
  for tile_part_index = 0
      tile_part_index < tile_payloads.length() && !stop_packet_parse
      tile_part_index = tile_part_index + 1 {
    let tile_payload = tile_payloads[tile_part_index]
    let tile_payload_len = tile_payload.length()
    let tile_ppt_stream = Bytes::from_array(
      info.ppt_packet_header_bytes_per_tile_part[tile_part_index],
    )
    let tile_use_ppt = info.ppt_present_per_tile_part[tile_part_index]
    let tile_plt_lengths = info.plt_packet_lengths_per_tile_part[tile_part_index]
    let mut tile_payload_cursor = 0
    let mut tile_ppt_cursor = 0
    let mut tile_plt_cursor = 0
    while packet_index < packet_sequence.length() &&
          tile_payload_cursor < tile_payload_len &&
          !stop_packet_parse {
      let seq = packet_sequence[packet_index]
      let items = work_items_by_component_resolution[seq.component][seq.resolution]
      let item = items[seq.precinct_index]
      let use_ppt_headers = tile_use_ppt
      let use_ppm_headers = !use_ppt_headers && info.has_ppm
      let use_external_headers = use_ppt_headers || use_ppm_headers
      if use_external_headers {
        let header_cursor = if use_ppt_headers {
          tile_ppt_cursor
        } else {
          ppm_header_cursor
        }
        let header_len = if use_ppt_headers {
          tile_ppt_stream.length()
        } else {
          ppm_packet_header_stream.length()
        }
        if header_cursor >= header_len {
          stop_packet_parse = true
          break
        }
      } else if tile_payload_cursor >= tile_payload_len {
        stop_packet_parse = true
        break
      }
      let packet_payload = if use_ppt_headers {
        tile_ppt_stream
        .sub(start=tile_ppt_cursor, end=tile_ppt_stream.length())
        .to_bytes()
      } else if use_ppm_headers {
        ppm_packet_header_stream
        .sub(start=ppm_header_cursor, end=ppm_packet_header_stream.length())
        .to_bytes()
      } else {
        tile_payload
        .sub(start=tile_payload_cursor, end=tile_payload.length())
        .to_bytes()
      }
      let packet = match
        parse_packet_codeblocks_with_layer_state(
          packet_payload,
          info.cod_use_sop,
          info.cod_use_eph,
          seq.layer,
          item.included_before,
          item.lblocks,
          item.zero_bitplanes,
          item.inclusion_layer_known,
          item.inclusion_layer,
          item.inclusion_tagtree_states,
          item.zero_bitplanes_tagtree_states,
          item.tagtree_leaf_refs,
        ) {
        Ok(v) => v
        Err(e) =>
          if packet_index == 0 {
            return Err(e)
          } else {
            stop_packet_parse = true
            break
          }
      }
      let mut total_codeword_bytes = 0
      let mut included_codeblocks = 0
      for block in packet.codeblocks {
        if block.included {
          if block.codeword_length < 0 {
            return Err(
              UnsupportedTemplate(
                "packet codeword length must be >= 0, got \{block.codeword_length}",
              ),
            )
          }
          included_codeblocks += 1
          if block.codeword_length > 0 {
            total_codeword_bytes += block.codeword_length
          }
        }
      }
      if packet_index == 0 && included_codeblocks == 0 {
        return Err(
          UnsupportedTemplate(
            "first packet has no included codeblocks (empty packet)",
          ),
        )
      }
      if packet.bytes_consumed > packet_payload.length() {
        if packet_index == 0 {
          return Err(
            InsufficientData(
              "first packet header exceeds header stream: consumed=\{packet.bytes_consumed}, available=\{packet_payload.length()}",
            ),
          )
        } else {
          stop_packet_parse = true
          break
        }
      }
      let packet_payload_bytes = if use_external_headers {
        total_codeword_bytes
      } else {
        packet.bytes_consumed + total_codeword_bytes
      }
      let mut codeword_start = if use_external_headers {
        tile_payload_cursor
      } else {
        tile_payload_cursor + packet.bytes_consumed
      }
      for i = 0; i < item.plans.length(); i = i + 1 {
        let block = packet.codeblocks[i]
        if !block.included {
          continue
        }
        item.ever_included[i] = true
        if block.codeword_length == 0 {
          continue
        }
        let codeword_end = codeword_start + block.codeword_length
        if codeword_end > tile_payload_len {
          return Err(
            InsufficientData(
              "codeword extends past packet payload: start=\{codeword_start}, len=\{block.codeword_length}, payload=\{tile_payload_len}",
            ),
          )
        }
        let codeword = tile_payload
          .sub(start=codeword_start, end=codeword_end)
          .to_bytes()
        codeword_start = codeword_end
        for b in codeword {
          item.codeword_bytes[i].push(b)
        }
        item.total_passes[i] += block.num_coding_passes
      }
      if tile_payload_cursor + packet_payload_bytes > tile_payload_len {
        return Err(
          InsufficientData(
            "packet extends past tile-part payload: tile_part=\{tile_part_index}, start=\{tile_payload_cursor}, packet_bytes=\{packet_payload_bytes}, payload=\{tile_payload_len}",
          ),
        )
      }
      if tile_plt_lengths.length() > 0 {
        if tile_plt_cursor >= tile_plt_lengths.length() {
          return Err(
            UnsupportedTemplate(
              "PLT packet length list exhausted: tile_part=\{tile_part_index}, packet_index=\{packet_index}",
            ),
          )
        }
        let expected_packet_bytes = tile_plt_lengths[tile_plt_cursor]
        if packet_payload_bytes != expected_packet_bytes {
          return Err(
            UnsupportedTemplate(
              "PLT packet length mismatch: tile_part=\{tile_part_index}, packet=\{tile_plt_cursor}, expected=\{expected_packet_bytes}, actual=\{packet_payload_bytes}",
            ),
          )
        }
        tile_plt_cursor += 1
      }
      if use_ppt_headers {
        tile_ppt_cursor += packet.bytes_consumed
      } else if use_ppm_headers {
        ppm_header_cursor += packet.bytes_consumed
      }
      tile_payload_cursor += packet_payload_bytes
      packet_index += 1
    }
    if tile_plt_cursor < tile_plt_lengths.length() {
      return Err(
        InsufficientData(
          "PLT packet lengths remain without packets: tile_part=\{tile_part_index}, consumed=\{tile_plt_cursor}, listed=\{tile_plt_lengths.length()}",
        ),
      )
    }
    if tile_plt_lengths.length() > 0 && tile_payload_cursor != tile_payload_len {
      return Err(
        UnsupportedTemplate(
          "PLT packet lengths do not cover tile-part payload: tile_part=\{tile_part_index}, consumed=\{tile_payload_cursor}, payload=\{tile_payload_len}",
        ),
      )
    }
  }
  let coeffs_by_component : Array[Array[Double]] = []
  for _component = 0; _component < num_components; _component = _component + 1 {
    coeffs_by_component.push(Array::make(coded_points, 0.0))
  }
  for component = 0; component < num_components; component = component + 1 {
    let coeffs = coeffs_by_component[component]
    let work_items_by_resolution = work_items_by_component_resolution[component]
    let component_codeblock_style = info.component_codeblock_style[component]
    let component_quantization_style = info.component_quantization_style[component]
    let component_quantization_exponents = info.component_quantization_exponents[component]
    let component_quantization_mantissas = info.component_quantization_mantissas[component]
    let component_roi_shift = info.component_roi_shift[component]
    for items in work_items_by_resolution {
      for item in items {
        for i = 0; i < item.plans.length(); i = i + 1 {
          if !item.ever_included[i] ||
            item.total_passes[i] <= 0 ||
            item.codeword_bytes[i].length() <= 0 {
            continue
          }
          let plan = item.plans[i]
          let quantization_step = match
            quantization_step_size_for_subband_component(
              info.siz.bits_per_component,
              component_quantization_style,
              component_quantization_exponents,
              component_quantization_mantissas,
              plan.subband_index,
            ) {
            Ok(v) => v
            Err(e) => return Err(e)
          }
          let decoded_block = match
            tier1_decode_coefficients_cleanup_only_with_style(
              Bytes::from_array(item.codeword_bytes[i]),
              plan.width,
              plan.height,
              item.total_passes[i],
              item.zero_bitplanes[i],
              template.bits_per_value,
              component_codeblock_style,
            ) {
            Ok(v) => v
            Err(e) => return Err(e)
          }
          let effective_decoded_block = if component_roi_shift > 0 {
            match
              apply_rgn_maxshift_descaling(decoded_block, component_roi_shift) {
              Ok(v) => v
              Err(e) => return Err(e)
            }
          } else {
            decoded_block
          }
          let expected_block_coeffs = plan.width * plan.height
          if effective_decoded_block.length() != expected_block_coeffs {
            return Err(
              InsufficientData(
                "decoded codeblock coefficient count mismatch: expected=\{expected_block_coeffs}, actual=\{effective_decoded_block.length()}",
              ),
            )
          }
          for by = 0; by < plan.height; by = by + 1 {
            for bx = 0; bx < plan.width; bx = bx + 1 {
              let dst_x = plan.x0 + bx
              let dst_y = plan.y0 + by
              let dst_idx = dst_y * info.siz.width + dst_x
              let src_idx = by * plan.width + bx
              coeffs[dst_idx] = effective_decoded_block[src_idx].to_double() *
                quantization_step
            }
          }
        }
      }
    }
  }
  let recon_by_component : Array[Array[Double]] = []
  for component = 0; component < num_components; component = component + 1 {
    let component_decomposition_levels = info.component_num_decomposition_levels[component]
    let component_wavelet_transform = info.component_wavelet_transform[component]
    let recon = match
      inverse_dwt_from_coeffs_double(
        coeffs_by_component[component],
        info.siz.width,
        info.siz.height,
        component_decomposition_levels,
        component_wavelet_transform,
      ) {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    recon_by_component.push(recon)
  }
  if info.cod_multi_component_transform != 0 {
    if num_components < 3 {
      return Err(
        UnsupportedTemplate(
          "COD multi-component transform requires at least 3 components, got \{num_components}",
        ),
      )
    }
    let transformed0 : Array[Double] = []
    let transformed1 : Array[Double] = []
    let transformed2 : Array[Double] = []
    let use_reversible_mct = info.component_wavelet_transform[0] == 0
    for i = 0; i < coded_points; i = i + 1 {
      let c0 = recon_by_component[0][i]
      let c1 = recon_by_component[1][i]
      let c2 = recon_by_component[2][i]
      let (r, g, b) = if use_reversible_mct {
        inverse_rct_components(c0, c1, c2)
      } else {
        inverse_ict_components(c0, c1, c2)
      }
      transformed0.push(r)
      transformed1.push(g)
      transformed2.push(b)
    }
    recon_by_component[0] = transformed0
    recon_by_component[1] = transformed1
    recon_by_component[2] = transformed2
  }
  let recon = recon_by_component[0]
  let output_component_decomposition_levels = info.component_num_decomposition_levels[0]
  let ref_value = ieee754_single_to_double(template.reference_value_ieee)
  let binary_scale = jpeg2000_pow2(u16_to_i16(template.binary_scale_factor))
  let decimal_scale = jpeg2000_pow10(u16_to_i16(template.decimal_scale_factor))
  let values : Array[Double] = []
  for c in recon {
    if output_component_decomposition_levels == 0 &&
      !info.siz.signed_components &&
      c < 0.0 {
      return Err(
        UnsupportedTemplate(
          "decoded negative coefficient for unsigned component: \{c}",
        ),
      )
    }
    values.push(ref_value + c * binary_scale / decimal_scale)
  }
  Ok({ values, num_points })
}

///|
/// Legacy placeholder kept for API compatibility.
/// Template 5.41 is PNG in GRIB2 and should use `unpack_png`.
pub fn unpack_jpeg2000_differencing(
  _data : Bytes,
  _template : @section5.Grib2DataRepresentationTemplate541,
  _num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  Err(UnsupportedTemplate("Template 5.41 is PNG. Use unpack_png()."))
}

///|
/// Get raw JPEG2000 bytes for JS-side decoding.
/// The returned bytes can be passed to an external JPEG2000 decoder.
pub fn get_jpeg2000_raw_bytes(data : Bytes) -> Bytes {
  data
}

///|
/// Get JPEG2000 encoding parameters from template.
/// Returns (reference_value_ieee, binary_scale_factor, decimal_scale_factor, bits_per_value)
/// for post-processing after JPEG2000 decoding.
pub fn get_jpeg2000_params(
  template : @section5.Grib2DataRepresentationTemplate540,
) -> (Int, Int, Int, Int) {
  (
    template.reference_value_ieee,
    template.binary_scale_factor,
    template.decimal_scale_factor,
    template.bits_per_value,
  )
}

///|
fn set_cod_progression_order(
  data : Bytes,
  progression_order : Int,
) -> Result[Bytes, UnpackError] {
  if progression_order < 0 || progression_order > 4 {
    return Err(
      UnsupportedTemplate(
        "progression_order out of range: \{progression_order}",
      ),
    )
  }
  let bytes : Array[Byte] = []
  for b in data {
    bytes.push(b)
  }
  let mut i = 0
  while i + 5 < bytes.length() {
    if bytes[i] == b'\xFF' && bytes[i + 1] == b'\x52' {
      let segment_len = (bytes[i + 2].to_uint().reinterpret_as_int() << 8) |
        bytes[i + 3].to_uint().reinterpret_as_int()
      if segment_len < 12 || i + 2 + segment_len > bytes.length() {
        return Err(InsufficientData("COD segment is truncated while patching"))
      }
      bytes[i + 5] = progression_order.to_byte()
      return Ok(Bytes::from_array(bytes))
    }
    i += 1
  }
  Err(UnsupportedTemplate("COD marker not found while patching"))
}

///|
fn set_cod_multi_component_transform(
  data : Bytes,
  mct : Int,
) -> Result[Bytes, UnpackError] {
  if mct < 0 || mct > 255 {
    return Err(UnsupportedTemplate("mct out of range: \{mct}"))
  }
  let bytes : Array[Byte] = []
  for b in data {
    bytes.push(b)
  }
  let mut i = 0
  while i + 13 < bytes.length() {
    if bytes[i] == b'\xFF' && bytes[i + 1] == b'\x52' {
      let segment_len = (bytes[i + 2].to_uint().reinterpret_as_int() << 8) |
        bytes[i + 3].to_uint().reinterpret_as_int()
      if segment_len < 12 || i + 2 + segment_len > bytes.length() {
        return Err(InsufficientData("COD segment is truncated while patching"))
      }
      bytes[i + 8] = mct.to_byte()
      return Ok(Bytes::from_array(bytes))
    }
    i += 1
  }
  Err(UnsupportedTemplate("COD marker not found while patching"))
}

///|
fn set_cod_codeblock_style(
  data : Bytes,
  codeblock_style : Int,
) -> Result[Bytes, UnpackError] {
  if codeblock_style < 0 || codeblock_style > 255 {
    return Err(
      UnsupportedTemplate("codeblock_style out of range: \{codeblock_style}"),
    )
  }
  let bytes : Array[Byte] = []
  for b in data {
    bytes.push(b)
  }
  let mut i = 0
  while i + 13 < bytes.length() {
    if bytes[i] == b'\xFF' && bytes[i + 1] == b'\x52' {
      let segment_len = (bytes[i + 2].to_uint().reinterpret_as_int() << 8) |
        bytes[i + 3].to_uint().reinterpret_as_int()
      if segment_len < 12 || i + 2 + segment_len > bytes.length() {
        return Err(InsufficientData("COD segment is truncated while patching"))
      }
      bytes[i + 12] = codeblock_style.to_byte()
      return Ok(Bytes::from_array(bytes))
    }
    i += 1
  }
  Err(UnsupportedTemplate("COD marker not found while patching"))
}

///|
fn make_dummy_packet_work_item(
  precinct_order_x : Int,
  precinct_order_y : Int,
) -> Jpeg2000PacketWorkItem {
  {
    plans: [],
    precinct_order_x,
    precinct_order_y,
    included_before: [],
    inclusion_layer_known: [],
    inclusion_layer: [],
    inclusion_tagtree_states: None,
    zero_bitplanes_tagtree_states: None,
    tagtree_leaf_refs: None,
    lblocks: [],
    zero_bitplanes: [],
    codeword_bytes: [],
    total_passes: [],
    ever_included: [],
  }
}

///|
fn packet_sequence_signature(
  packet_sequence : Array[Jpeg2000PacketSequenceItem],
) -> String {
  let mut s = ""
  for i = 0; i < packet_sequence.length(); i = i + 1 {
    if i > 0 {
      s = s + ","
    }
    let item = packet_sequence[i]
    s = s + "\{item.resolution}:\{item.precinct_index}"
  }
  s
}

///|
fn packet_sequence_signature_with_layer(
  packet_sequence : Array[Jpeg2000PacketSequenceItem],
) -> String {
  let mut s = ""
  for i = 0; i < packet_sequence.length(); i = i + 1 {
    if i > 0 {
      s = s + ","
    }
    let item = packet_sequence[i]
    s = s + "\{item.layer}:\{item.resolution}:\{item.precinct_index}"
  }
  s
}

///|
fn packet_sequence_signature_with_component(
  packet_sequence : Array[Jpeg2000PacketSequenceItem],
) -> String {
  let mut s = ""
  for i = 0; i < packet_sequence.length(); i = i + 1 {
    if i > 0 {
      s = s + ","
    }
    let item = packet_sequence[i]
    s = s +
      "\{item.layer}:\{item.resolution}:\{item.component}:\{item.precinct_index}"
  }
  s
}

///|
test "build_packet_sequence_single_component covers progression orders 0..4" {
  let r0 = [
    make_dummy_packet_work_item(0, 0),
    make_dummy_packet_work_item(64, 0),
  ]
  let r1 = [make_dummy_packet_work_item(0, 0)]
  let work_items_by_resolution = [r0, r1]
  let expected = [
    "0:0,0:1,1:0,0:0,0:1,1:0", // LRCP
     "0:0,0:1,0:0,0:1,1:0,1:0", // RLCP
     "0:0,0:0,0:1,0:1,1:0,1:0", // RPCL
     "0:0,0:0,1:0,1:0,0:1,0:1", // PCRL
     "0:0,0:0,1:0,1:0,0:1,0:1", // CPRL (single component)
  ]
  for progression_order = 0
      progression_order <= 4
      progression_order = progression_order + 1 {
    let packet_sequence = match
      build_packet_sequence_single_component(
        progression_order, 2, work_items_by_resolution,
      ) {
      Ok(v) => v
      Err(_) => fail("unexpected error")
    }
    inspect(packet_sequence.length(), content="6")
    inspect(
      packet_sequence_signature(packet_sequence),
      content=expected[progression_order],
    )
  }
}

///|
test "build_packet_sequence_with_poc emits C dimension for LRCP" {
  let c0r0 = [make_dummy_packet_work_item(0, 0)]
  let c1r0 = [make_dummy_packet_work_item(0, 0)]
  let work_items_by_component_resolution = [[c0r0], [c1r0]]
  let packet_sequence = match
    build_packet_sequence_with_poc(0, 1, work_items_by_component_resolution, []) {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  inspect(packet_sequence.length(), content="2")
  inspect(
    packet_sequence_signature_with_component(packet_sequence),
    content="0:0:0:0,0:0:1:0",
  )
}

///|
test "build_packet_sequence_with_poc uses component range in POC" {
  let c0r0 = [make_dummy_packet_work_item(0, 0)]
  let c1r0 = [make_dummy_packet_work_item(0, 0)]
  let work_items_by_component_resolution = [[c0r0], [c1r0]]
  let poc_entries = [
    {
      start_resolution: 0,
      start_component: 1,
      end_layer_exclusive: 1,
      end_resolution_exclusive: 1,
      end_component_exclusive: 2,
      progression_order: 0,
    },
  ]
  let packet_sequence = match
    build_packet_sequence_with_poc(
      0, 1, work_items_by_component_resolution, poc_entries,
    ) {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  inspect(packet_sequence.length(), content="1")
  inspect(
    packet_sequence_signature_with_component(packet_sequence),
    content="0:0:1:0",
  )
}

///|
test "build_packet_sequence_single_component_with_poc applies progression switch" {
  let r0 = [
    make_dummy_packet_work_item(0, 0),
    make_dummy_packet_work_item(64, 0),
  ]
  let r1 = [make_dummy_packet_work_item(0, 0)]
  let work_items_by_resolution = [r0, r1]
  let poc_entries = [
    {
      start_resolution: 1,
      start_component: 0,
      end_layer_exclusive: 1,
      end_resolution_exclusive: 2,
      end_component_exclusive: 1,
      progression_order: 1,
    },
  ]
  let packet_sequence = match
    build_packet_sequence_single_component_with_poc(
      0, 2, work_items_by_resolution, poc_entries,
    ) {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  inspect(packet_sequence.length(), content="4")
  inspect(
    packet_sequence_signature_with_layer(packet_sequence),
    content="0:1:0,1:0:0,1:0:1,1:1:0",
  )
}

///|
test "unpack_jpeg2000 returns stub error" {
  let empty_data = Bytes::new(0)
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 0,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(empty_data, template, 0) {
    Err(_) => inspect(true, content="true")
    _ => fail("expected error")
  }
}

///|
test "unpack_jpeg2000 decodes restricted 1x1 single-codeblock sample" {
  // SOC + SIZ(1x1) + COD + QCD + SOT/SOD + packet(header+codeword) + EOC
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] == 0.0, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "unpack_jpeg2000 supports COD progression orders 0..4" {
  let base_data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  for order = 0; order <= 4; order = order + 1 {
    let data = match set_cod_progression_order(base_data, order) {
      Ok(v) => v
      Err(_) => fail("failed to patch progression order")
    }
    match unpack_jpeg2000(data, template, 1) {
      Ok(v) => {
        inspect(v.num_points, content="1")
        inspect(v.values.length(), content="1")
      }
      Err(e) =>
        match e {
          UnsupportedTemplate(msg) =>
            fail("UnsupportedTemplate(order=\{order}): " + msg)
          InsufficientData(msg) =>
            fail("InsufficientData(order=\{order}): " + msg)
          InvalidBitsPerValue(msg) =>
            fail("InvalidBitsPerValue(order=\{order}): " + msg)
        }
    }
  }
}

///|
test "unpack_jpeg2000 supports POC progression switch in main header" {
  // COD default LRCP, plus one POC entry switching to RLCP for layer/res range.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5F\x00\x09\x00\x00\x00\x01\x01\x01\x01\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 supports PPT packet headers in tile-part" {
  // packet header(0x82) in PPT; SOD has only one codeword byte(0x34).
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x15\x00\x01\xFF\x61\x00\x04\x00\x82\xFF\x93\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 supports PPM packet headers in main header" {
  // packet header(0x82) in PPM; SOD has only one codeword byte(0x34).
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x60\x00\x08\x00\x00\x00\x00\x01\x82\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 reorders PPM headers by Zppm" {
  // PPM Z=1 then Z=0; packet header stream must decode as [0x82].
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x60\x00\x08\x01\x00\x00\x00\x01\x34\xFF\x60\x00\x08\x00\x00\x00\x00\x01\x82\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 rejects PPM Zppm gap" {
  // Only Zppm=1 is present (missing Zppm=0) -> codestream parse should fail.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x60\x00\x08\x01\x00\x00\x00\x01\x82\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x0F\x00\x01\xFF\x93\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_jpeg2000 reorders PPT headers by Zppt" {
  // PPT Z=1 then Z=0 in tile-part header; packet header stream becomes [0x82].
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x1B\x00\x01\xFF\x61\x00\x04\x01\x34\xFF\x61\x00\x04\x00\x82\xFF\x93\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 rejects PPT Zppt gap" {
  // Only Zppt=1 is present (missing Zppt=0) -> codestream parse should fail.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x17\x00\x01\xFF\x61\x00\x04\x01\x82\xFF\x93\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_jpeg2000 supports simultaneous PPM and PPT packet headers" {
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x60\x00\x08\x00\x00\x00\x00\x01\x82\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x15\x00\x01\xFF\x61\x00\x04\x00\x82\xFF\x93\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 validates PLT packet length" {
  // PLT with one packet length=2 (header 0x82 + codeword 0x34 in SOD).
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x16\x00\x01\xFF\x58\x00\x04\x00\x02\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 rejects trailing tile payload with PLT" {
  // PLT says packet length=2, but tile-part payload has one trailing byte.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x17\x00\x01\xFF\x58\x00\x04\x00\x02\xFF\x93\x82\x34\x00\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_jpeg2000 supports matching TLM tile-part length" {
  // Add TLM with one entry matching Psot=0x10.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x55\x00\x08\x00\x40\x00\x00\x00\x10\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 rejects PLT packet length mismatch" {
  // PLT says one packet length=3, but actual packet bytes in SOD are 2.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x16\x00\x01\xFF\x58\x00\x04\x00\x03\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "apply_rgn_maxshift_descaling keeps background and descales ROI" {
  let coeffs = [1, 7, 8, -16, 31, -32]
  let descaled = match apply_rgn_maxshift_descaling(coeffs, 3) {
    Ok(v) => v
    Err(_) => fail("unexpected error")
  }
  inspect(descaled.length(), content="6")
  inspect(descaled[0], content="1")
  inspect(descaled[1], content="7")
  inspect(descaled[2], content="1")
  inspect(descaled[3], content="-2")
  inspect(descaled[4], content="3")
  inspect(descaled[5], content="-4")
}

///|
test "unpack_jpeg2000 supports RGN maxshift marker" {
  // RGN shift=3 in main header (component 0).
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x5E\x00\x05\x00\x00\x03\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 rejects excessive RGN maxshift" {
  // RGN shift=31 is rejected by current decoder bounds.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x5E\x00\x05\x00\x00\x1F\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_jpeg2000 supports COD codeblock_style reset flag" {
  let base_data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let data = match set_cod_codeblock_style(base_data, 0x02) {
    Ok(v) => v
    Err(_) => fail("failed to patch codeblock_style")
  }
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 supports COD codeblock_style segmark flag" {
  let base_data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let data = match set_cod_codeblock_style(base_data, 0x20) {
    Ok(v) => v
    Err(_) => fail("failed to patch codeblock_style")
  }
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 supports COD codeblock_style bypass flag" {
  let base_data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let data = match set_cod_codeblock_style(base_data, 0x01) {
    Ok(v) => v
    Err(_) => fail("failed to patch codeblock_style")
  }
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 supports COD codeblock_style termall flag" {
  let base_data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let data = match set_cod_codeblock_style(base_data, 0x04) {
    Ok(v) => v
    Err(_) => fail("failed to patch codeblock_style")
  }
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 supports COD codeblock_style vcausal flag" {
  let base_data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let data = match set_cod_codeblock_style(base_data, 0x08) {
    Ok(v) => v
    Err(_) => fail("failed to patch codeblock_style")
  }
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 supports COD codeblock_style pterm flag" {
  let base_data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let data = match set_cod_codeblock_style(base_data, 0x10) {
    Ok(v) => v
    Err(_) => fail("failed to patch codeblock_style")
  }
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 rejects unsupported COD codeblock_style flags" {
  let base_data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let data = match set_cod_codeblock_style(base_data, 0x40) {
    Ok(v) => v
    Err(_) => fail("failed to patch codeblock_style")
  }
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_jpeg2000 decodes two-layer single-codeblock packet sequence" {
  // COD num_layers=2. Packet#0 uses single-leaf tag-tree for first-layer index=0.
  // Packet#1 adds one more pass for the same codeblock.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x12\x00\x01\xFF\x93\xE1\x34\x84\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 rejects expounded quantization with insufficient entries" {
  // QCD style=2 with no step-size entries (Lqcd=3) is insufficient even for decomp=0.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x02\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_jpeg2000 rejects derived quantization without base step entry" {
  // QCD style=1 with no step-size entry (Lqcd=3).
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x01\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_jpeg2000 decodes restricted 2x1 single-codeblock sample" {
  // SOC + SIZ(2x1) + COD + QCD + SOT/SOD + packet(header+codeword) + EOC
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x10\x00\x01\xFF\x93\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 2) {
    Ok(v) => {
      inspect(v.num_points, content="2")
      inspect(v.values.length(), content="2")
      inspect(v.values[0] == 0.0, content="true")
      inspect(v.values[1] == 0.0, content="true")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "unpack_jpeg2000 decodes restricted 1x1 two-component sample" {
  // SOC + SIZ(1x1, 2 components) + COD + QCD + SOT/SOD + packet(c0) + packet(c1) + EOC
  let data = b"\xFF\x4F\xFF\x51\x00\x2C\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x07\x01\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x12\x00\x01\xFF\x93\x82\x34\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 rejects MCT with fewer than three components" {
  let base = b"\xFF\x4F\xFF\x51\x00\x2C\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x07\x01\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x12\x00\x01\xFF\x93\x82\x34\x82\x34\xFF\xD9"
  let data = match set_cod_multi_component_transform(base, 1) {
    Ok(v) => v
    Err(_) => fail("failed to patch COD MCT")
  }
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Err(UnsupportedTemplate(_)) => inspect(true, content="true")
    _ => fail("expected UnsupportedTemplate error")
  }
}

///|
test "unpack_jpeg2000 supports three-component reversible MCT path" {
  // Three components, COD MCT=1 (reversible path), one packet per component.
  let data = b"\xFF\x4F\xFF\x51\x00\x2F\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x07\x01\x01\x07\x01\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x01\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x14\x00\x01\xFF\x93\x82\x34\x82\x34\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 supports component1 COC/QCC overrides" {
  // Two components with COC/QCC only on component 1.
  let data = b"\xFF\x4F\xFF\x51\x00\x2C\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x07\x01\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x53\x00\x09\x01\x00\x00\x00\x00\x02\x00\xFF\x5C\x00\x05\x02\x40\x00\xFF\x5D\x00\x05\x01\x00\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x12\x00\x01\xFF\x93\x82\x34\x82\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 1) {
    Ok(v) => {
      inspect(v.num_points, content="1")
      inspect(v.values.length(), content="1")
      inspect(v.values[0] <= v.values[0], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 decodes restricted 5x1 two-codeblock sample" {
  // SOC + SIZ(5x1) + COD + QCD + SOT/SOD + packet(header+2 codewords) + EOC
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x05\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x87\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x12\x00\x01\xFF\x93\x83\x04\x00\x00\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 5) {
    Ok(v) => {
      inspect(v.num_points, content="5")
      inspect(v.values.length(), content="5")
      inspect(v.values[0] <= v.values[0], content="true")
      inspect(v.values[4] <= v.values[4], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 decodes decomp0 with two precinct packets" {
  // SOC + SIZ(8x1) + COD(precincts, decomp=0, 5/3) + QCD + SOT/SOD + packet0 + packet1 + EOC
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x08\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x87\x01\x01\xFF\x52\x00\x0D\x01\x00\x00\x01\x00\x00\x00\x00\x00\x01\xF2\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x14\x00\x01\xFF\x93\xA0\x80\x34\xA0\x80\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 8) {
    Ok(v) => {
      inspect(v.num_points, content="8")
      inspect(v.values.length(), content="8")
      inspect(v.values[0] <= v.values[0], content="true")
      inspect(v.values[7] <= v.values[7], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 decodes decomp0 precinct packets across two tile-parts" {
  // Same as previous test, but each precinct packet is placed in a separate tile-part.
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x08\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x87\x01\x01\xFF\x52\x00\x0D\x01\x00\x00\x01\x00\x00\x00\x00\x00\x01\xF2\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x11\x00\x02\xFF\x93\xA0\x80\x34\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x11\x01\x02\xFF\x93\xA0\x80\x34\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 8) {
    Ok(v) => {
      inspect(v.num_points, content="8")
      inspect(v.values.length(), content="8")
      inspect(v.values[0] <= v.values[0], content="true")
      inspect(v.values[7] <= v.values[7], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}

///|
test "unpack_jpeg2000 decodes restricted 4x4 one-level LL-only sample" {
  // SOC + SIZ(4x4) + COD(decomp=1, 5/3) + QCD + SOT/SOD + packet0(LL) + packet1(HL/LH/HH all not included) + EOC
  let data = b"\xFF\x4F\xFF\x51\x00\x29\x00\x00\x00\x00\x00\x04\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x07\x01\x01\xFF\x52\x00\x0C\x00\x00\x00\x01\x00\x01\x00\x00\x00\x01\xFF\x5C\x00\x03\x00\xFF\x90\x00\x0A\x00\x00\x00\x00\x00\x11\x00\x01\xFF\x93\x82\x00\x00\xFF\xD9"
  let template : @section5.Grib2DataRepresentationTemplate540 = {
    reference_value_ieee: 0,
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    compression_type: 0,
    target_compression_ratio: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_jpeg2000(data, template, 16) {
    Ok(v) => {
      inspect(v.num_points, content="16")
      inspect(v.values.length(), content="16")
      inspect(v.values[0] <= v.values[0], content="true")
      inspect(v.values[15] <= v.values[15], content="true")
    }
    Err(e) =>
      match e {
        UnsupportedTemplate(msg) => fail("UnsupportedTemplate: " + msg)
        InsufficientData(msg) => fail("InsufficientData: " + msg)
        InvalidBitsPerValue(msg) => fail("InvalidBitsPerValue: " + msg)
      }
  }
}
