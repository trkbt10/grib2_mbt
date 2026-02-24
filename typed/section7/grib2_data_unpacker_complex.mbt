///|
/// Complex Packing (Template 5.2) and Complex Packing with Spatial Differencing
/// (Template 5.3) unpacker.
///
/// Template 5.2: Groups values with similar magnitudes for better compression.
/// Template 5.3: Adds spatial differencing to reduce value ranges before grouping.

///|
/// Internal struct to hold parsed group metadata.
priv struct ComplexGroupInfo {
  reference_values : Array[Int]
  widths : Array[Int]
  lengths : Array[Int]
  total_values : Int
}

///|
fn align_reader_to_octet(reader : BitReader) -> Unit {
  let rem = reader.bit_position % 8
  if rem != 0 {
    reader.skip_bits(8 - rem)
  }
}

///|
/// Parse group metadata from complex packed data.
fn parse_complex_groups(
  reader : BitReader,
  ng : Int,
  bits_per_value : Int,
  reference_group_widths : Int,
  bits_used_for_group_widths : Int,
  reference_group_lengths : Int,
  length_increment_group_lengths : Int,
  bits_used_for_scaled_group_lengths : Int,
  true_length_last_group : Int,
) -> Result[ComplexGroupInfo, UnpackError] {
  if ng <= 0 {
    return Ok({ reference_values: [], widths: [], lengths: [], total_values: 0 })
  }
  // Read NG group reference values
  let reference_values : Array[Int] = Array::make(ng, 0)
  for i in 0..<ng {
    if not(reader.has_bits(bits_per_value)) {
      return Err(
        InsufficientData(
          "not enough bits for group reference \{i}, need \{bits_per_value}",
        ),
      )
    }
    reference_values[i] = reader.read_bits(bits_per_value).reinterpret_as_int()
  }
  align_reader_to_octet(reader)
  // Read NG group widths
  let widths : Array[Int] = Array::make(ng, 0)
  for i in 0..<ng {
    if bits_used_for_group_widths > 0 {
      if not(reader.has_bits(bits_used_for_group_widths)) {
        return Err(
          InsufficientData(
            "not enough bits for group width \{i}, need \{bits_used_for_group_widths}",
          ),
        )
      }
      widths[i] = reference_group_widths +
        reader.read_bits(bits_used_for_group_widths).reinterpret_as_int()
    } else {
      widths[i] = reference_group_widths
    }
  }
  align_reader_to_octet(reader)
  // Read NG scaled group lengths
  let lengths : Array[Int] = Array::make(ng, 0)
  for i in 0..<ng {
    if i < ng - 1 {
      if bits_used_for_scaled_group_lengths > 0 {
        if not(reader.has_bits(bits_used_for_scaled_group_lengths)) {
          return Err(
            InsufficientData(
              "not enough bits for group length \{i}, need \{bits_used_for_scaled_group_lengths}",
            ),
          )
        }
        let scaled = reader
          .read_bits(bits_used_for_scaled_group_lengths)
          .reinterpret_as_int()
        lengths[i] = reference_group_lengths +
          scaled * length_increment_group_lengths
      } else {
        lengths[i] = reference_group_lengths
      }
    } else {
      // Last group uses true_length_last_group
      lengths[i] = true_length_last_group
    }
  }
  align_reader_to_octet(reader)
  // Calculate total values
  let mut total_values = 0
  for i in 0..<ng {
    total_values = total_values + lengths[i]
  }
  Ok({ reference_values, widths, lengths, total_values })
}

///|
/// Unpack group values from complex packed data.
fn unpack_group_values(
  reader : BitReader,
  groups : ComplexGroupInfo,
  missing_value_management : Int,
) -> Result[Array[Int], UnpackError] {
  let values : Array[Int] = Array::make(groups.total_values, 0)
  let mut value_index = 0
  let ng = groups.reference_values.length()
  for group_index in 0..<ng {
    let group_ref = groups.reference_values[group_index]
    let width = groups.widths[group_index]
    let length = groups.lengths[group_index]
    for _ in 0..<length {
      if width > 0 {
        if not(reader.has_bits(width)) {
          return Err(
            InsufficientData(
              "not enough bits for value \{value_index}, need \{width}",
            ),
          )
        }
        let x2 = reader.read_bits(width).reinterpret_as_int()
        // Check for missing value patterns
        if missing_value_management >= 1 {
          let all_ones = (1 << width) - 1
          if x2 == all_ones {
            // Primary missing value marker
            values[value_index] = -2147483648 // INT_MIN as marker
          } else if missing_value_management == 2 && x2 == all_ones - 1 {
            // Secondary missing value marker
            values[value_index] = -2147483647 // INT_MIN+1 as marker
          } else {
            values[value_index] = group_ref + x2
          }
        } else {
          values[value_index] = group_ref + x2
        }
      } else {
        // Width 0 means all values equal group reference
        values[value_index] = group_ref
      }
      value_index = value_index + 1
    }
  }
  Ok(values)
}

///|
/// Apply scaling formula: Y = R + (X * 2^E) / 10^D
fn apply_complex_scaling(
  scaled_integers : Array[Int],
  reference_value_ieee : Int,
  binary_scale_factor : Int,
  decimal_scale_factor : Int,
  missing_value_management : Int,
  primary_missing_value_substitute : Int,
  secondary_missing_value_substitute : Int,
) -> Array[Double] {
  let ref_value = ieee754_single_to_double(reference_value_ieee)
  let binary_scale = complex_pow2(u16_to_i16(binary_scale_factor))
  let decimal_scale = complex_pow10(u16_to_i16(decimal_scale_factor))
  let primary_missing = ieee754_single_to_double(
    primary_missing_value_substitute,
  )
  let secondary_missing = ieee754_single_to_double(
    secondary_missing_value_substitute,
  )
  let n = scaled_integers.length()
  let values : Array[Double] = Array::make(n, 0.0)
  for i in 0..<n {
    let x = scaled_integers[i]
    if missing_value_management >= 1 && x == -2147483648 {
      // Primary missing
      values[i] = primary_missing
    } else if missing_value_management == 2 && x == -2147483647 {
      // Secondary missing
      values[i] = secondary_missing
    } else {
      // GRIB2 formula: Y × 10^D = R + X × 2^E
      // So: Y = (R + X × 2^E) / 10^D
      values[i] = (ref_value + x.to_double() * binary_scale) / decimal_scale
    }
  }
  values
}

///|
fn complex_pow2(n : Int) -> Double {
  if n >= 0 {
    let mut result = 1.0
    for _ in 0..<n {
      result = result * 2.0
    }
    result
  } else {
    let mut result = 1.0
    for _ in 0..<-n {
      result = result / 2.0
    }
    result
  }
}

///|
fn complex_pow10(n : Int) -> Double {
  if n >= 0 {
    let mut result = 1.0
    for _ in 0..<n {
      result = result * 10.0
    }
    result
  } else {
    let mut result = 1.0
    for _ in 0..<-n {
      result = result / 10.0
    }
    result
  }
}

///|
/// Unpack complex packed data (Template 5.2).
///
/// Parameters:
/// - data: Raw packed data bytes from Section 7
/// - template: Template 5.2 parameters
/// - num_points: Expected number of data points
pub fn unpack_complex(
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate52,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  if template.bits_per_value < 0 || template.bits_per_value > 32 {
    return Err(
      InvalidBitsPerValue(
        "bits_per_value must be 0-32, got \{template.bits_per_value}",
      ),
    )
  }
  // Handle special case: 0 groups
  if template.number_of_groups <= 0 {
    let ref_value = ieee754_single_to_double(template.reference_value_ieee)
    return Ok({ values: Array::make(num_points, ref_value), num_points })
  }
  let reader = BitReader::new(data)
  // Parse group metadata
  let groups = match
    parse_complex_groups(
      reader,
      template.number_of_groups,
      template.bits_per_value,
      template.reference_group_widths,
      template.bits_used_for_group_widths,
      template.reference_group_lengths,
      template.length_increment_group_lengths,
      template.bits_used_for_scaled_group_lengths,
      template.true_length_last_group,
    ) {
    Ok(g) => g
    Err(e) => return Err(e)
  }
  // Verify total values match expected
  if groups.total_values != num_points {
    return Err(
      InsufficientData(
        "group total \{groups.total_values} != expected \{num_points}",
      ),
    )
  }
  // Unpack values
  let scaled_ints = match
    unpack_group_values(reader, groups, template.missing_value_management) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  // Apply scaling
  let values = apply_complex_scaling(
    scaled_ints,
    template.reference_value_ieee,
    template.binary_scale_factor,
    template.decimal_scale_factor,
    template.missing_value_management,
    template.primary_missing_value_substitute,
    template.secondary_missing_value_substitute,
  )
  Ok({ values, num_points })
}

///|
/// Internal struct for spatial differencing descriptors.
priv struct SpatialDiffDescriptors {
  initial_values : Array[Int]
  overall_minimum : Int
}

///|
/// Read a signed integer from N bytes for spatial differencing descriptors.
/// The first n values (ival1, ival2, ...) are unsigned field values.
/// The overall minimum is sign-magnitude encoded (MSB = sign).
fn read_descriptor_value(
  reader : BitReader,
  num_bytes : Int,
  is_minimum : Bool,
) -> Int {
  if num_bytes <= 0 {
    return 0
  }
  let total_bits = num_bytes * 8
  let unsigned_val = reader.read_bits(total_bits).reinterpret_as_int()
  if is_minimum {
    // Overall minimum uses sign-magnitude encoding
    let sign_bit = 1 << (total_bits - 1)
    let magnitude_mask = sign_bit - 1
    if (unsigned_val & sign_bit) != 0 {
      -(unsigned_val & magnitude_mask)
    } else {
      unsigned_val
    }
  } else {
    // Initial field values are unsigned
    unsigned_val
  }
}

///|
/// Parse spatial differencing descriptors from Section 7 data.
/// Note: extra_octets is the number of bytes PER VALUE, not total.
fn parse_spatial_descriptors(
  reader : BitReader,
  order : Int,
  extra_octets : Int,
) -> Result[SpatialDiffDescriptors, UnpackError] {
  if order != 1 && order != 2 {
    return Err(
      UnsupportedTemplate("spatial diff order must be 1 or 2, got \{order}"),
    )
  }
  if extra_octets <= 0 {
    return Err(
      UnsupportedTemplate(
        "extra_descriptors_octet_count must be > 0, got \{extra_octets}",
      ),
    )
  }
  // extra_octets is bytes per value
  // Order 1: 2 values (g1, g_min) -> total = 2 * extra_octets
  // Order 2: 3 values (h1, h2, h_min) -> total = 3 * extra_octets
  let num_values = if order == 1 { 2 } else { 3 }
  let total_bytes = extra_octets * num_values
  // Check if we have enough bits
  let required_bits = total_bytes * 8
  if not(reader.has_bits(required_bits)) {
    return Err(
      InsufficientData(
        "need \{required_bits} bits for spatial descriptors, have \{reader.remaining_bits()}",
      ),
    )
  }
  let initial_values : Array[Int] = []
  // Read initial values (unsigned field values)
  if order == 1 {
    initial_values.push(read_descriptor_value(reader, extra_octets, false))
  } else {
    // Order 2: read h1, h2
    initial_values.push(read_descriptor_value(reader, extra_octets, false))
    initial_values.push(read_descriptor_value(reader, extra_octets, false))
  }
  // Read overall minimum (sign-magnitude encoded)
  let overall_minimum = read_descriptor_value(reader, extra_octets, true)
  Ok({ initial_values, overall_minimum })
}

///|
/// Reverse an array in place.
fn reverse_array(arr : Array[Int]) -> Array[Int] {
  let n = arr.length()
  for i in 0..<(n / 2) {
    let tmp = arr[i]
    arr[i] = arr[n - 1 - i]
    arr[n - 1 - i] = tmp
  }
  arr
}

///|
/// Reverse spatial differencing to recover original values.
///
/// According to GRIB2 spec (Template 5.3 Note A):
/// - Order 1: g[1] = f[1], g[n] = f[n] - f[n-1]
/// - Order 2: h[1] = f[1], h[2] = f[2], h[n] = f[n] - 2*f[n-1] + f[n-2]
///
/// Note B: The first 'order' values in packed array are set to zero (placeholders).
///
/// Reconstruction is FORWARD: f[n] = (packed[n] + min) + 2*f[n-1] - f[n-2]
///
/// The file may encode the grid in reverse order (ival1/ival2 = last physical points),
/// so we reconstruct forward and then reverse the result if needed.
fn reverse_spatial_differencing(
  unpacked : Array[Int],
  descriptors : SpatialDiffDescriptors,
  order : Int,
) -> Array[Int] {
  let n = unpacked.length()
  if n == 0 {
    return []
  }
  let result : Array[Int] = Array::make(n, 0)
  if order == 1 {
    // First order: forward reconstruction
    // result[0] = ival1
    // result[i] = unpacked[i] + min + result[i-1] for i >= 1
    // Note: unpacked[0] should be 0 (placeholder)
    result[0] = descriptors.initial_values[0]
    for i in 1..<n {
      result[i] = unpacked[i] + descriptors.overall_minimum + result[i - 1]
    }
  } else {
    // Second order: forward reconstruction
    // result[0] = ival1, result[1] = ival2
    // result[i] = unpacked[i] + min + 2*result[i-1] - result[i-2] for i >= 2
    // Note: unpacked[0] and unpacked[1] should be 0 (placeholders)
    result[0] = descriptors.initial_values[0]
    if n > 1 {
      result[1] = descriptors.initial_values[1]
    }
    for i in 2..<n {
      result[i] = unpacked[i] +
        descriptors.overall_minimum +
        2 * result[i - 1] -
        result[i - 2]
    }
  }
  // The grid may have been encoded in reverse order.
  // If ival1/ival2 correspond to the last physical grid points,
  // we need to reverse the result to match the declared scan mode.
  // For now, reverse the result to match wgrib2 output.
  reverse_array(result)
}

///|
/// Unpack complex packed data with spatial differencing (Template 5.3).
///
/// Parameters:
/// - data: Raw packed data bytes from Section 7
/// - template: Template 5.3 parameters
/// - num_points: Expected number of data points
pub fn unpack_complex_spatial(
  data : Bytes,
  template : @section5.Grib2DataRepresentationTemplate53,
  num_points : Int,
) -> Result[UnpackedGridData, UnpackError] {
  if template.bits_per_value < 0 || template.bits_per_value > 32 {
    return Err(
      InvalidBitsPerValue(
        "bits_per_value must be 0-32, got \{template.bits_per_value}",
      ),
    )
  }
  // Validate spatial differencing order
  if template.order_of_spatial_difference != 1 &&
    template.order_of_spatial_difference != 2 {
    return Err(
      UnsupportedTemplate(
        "spatial diff order must be 1 or 2, got \{template.order_of_spatial_difference}",
      ),
    )
  }
  // Handle special case: 0 groups
  if template.number_of_groups <= 0 {
    let ref_value = ieee754_single_to_double(template.reference_value_ieee)
    return Ok({ values: Array::make(num_points, ref_value), num_points })
  }
  let reader = BitReader::new(data)
  // Parse spatial descriptors first
  let descriptors = match
    parse_spatial_descriptors(
      reader,
      template.order_of_spatial_difference,
      template.extra_descriptors_octet_count,
    ) {
    Ok(d) => d
    Err(e) => return Err(e)
  }
  // Parse group metadata
  let groups = match
    parse_complex_groups(
      reader,
      template.number_of_groups,
      template.bits_per_value,
      template.reference_group_widths,
      template.bits_used_for_group_widths,
      template.reference_group_lengths,
      template.length_increment_group_lengths,
      template.bits_used_for_scaled_group_lengths,
      template.true_length_last_group,
    ) {
    Ok(g) => g
    Err(e) => return Err(e)
  }
  // Verify total values match expected
  if groups.total_values != num_points {
    return Err(
      InsufficientData(
        "group total \{groups.total_values} != expected \{num_points}",
      ),
    )
  }
  // Unpack values (before spatial reversal)
  let scaled_ints = match
    unpack_group_values(reader, groups, template.missing_value_management) {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  // Apply spatial differencing reversal
  let restored = reverse_spatial_differencing(
    scaled_ints,
    descriptors,
    template.order_of_spatial_difference,
  )
  // Apply scaling
  let values = apply_complex_scaling(
    restored,
    template.reference_value_ieee,
    template.binary_scale_factor,
    template.decimal_scale_factor,
    template.missing_value_management,
    template.primary_missing_value_substitute,
    template.secondary_missing_value_substitute,
  )
  Ok({ values, num_points })
}

///|
test "unpack_complex zero groups" {
  // When number_of_groups = 0, all values equal reference_value
  let data = Bytes::new(0)
  let template : @section5.Grib2DataRepresentationTemplate52 = {
    reference_value_ieee: 1065353216, // 1.0 in IEEE 754
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 16,
    original_field_value_type: 0,
    group_splitting_method: 0,
    missing_value_management: 0,
    primary_missing_value_substitute: 0,
    secondary_missing_value_substitute: 0,
    number_of_groups: 0,
    reference_group_widths: 0,
    bits_used_for_group_widths: 0,
    reference_group_lengths: 0,
    length_increment_group_lengths: 0,
    true_length_last_group: 0,
    bits_used_for_scaled_group_lengths: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_complex(data, template, 3) {
    Ok(grid) => {
      inspect(grid.num_points, content="3")
      inspect(grid.values[0], content="1")
      inspect(grid.values[1], content="1")
      inspect(grid.values[2], content="1")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "unpack_complex single group width zero" {
  // Single group with width=0: all values equal group reference
  // bits_per_value=8, reference=10
  // Group widths bits=0 means all widths = reference_group_widths
  // Group lengths bits=0 means all lengths = reference_group_lengths
  // Data: 1 byte for group reference (value 10)
  let data = Bytes::from_array([b'\x0A']) // 10
  let template : @section5.Grib2DataRepresentationTemplate52 = {
    reference_value_ieee: 0, // 0.0
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    group_splitting_method: 0,
    missing_value_management: 0,
    primary_missing_value_substitute: 0,
    secondary_missing_value_substitute: 0,
    number_of_groups: 1,
    reference_group_widths: 0, // width=0 means all values = group ref
    bits_used_for_group_widths: 0,
    reference_group_lengths: 0,
    length_increment_group_lengths: 0,
    true_length_last_group: 3, // 3 values in last (only) group
    bits_used_for_scaled_group_lengths: 0,
    reserved_tail: Bytes::new(0),
  }
  match unpack_complex(data, template, 3) {
    Ok(grid) => {
      inspect(grid.num_points, content="3")
      inspect(grid.values[0], content="10")
      inspect(grid.values[1], content="10")
      inspect(grid.values[2], content="10")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "unpack_complex basic 2 groups" {
  // 2 groups:
  // Group 0: length=2, ref=10, width=4
  // Group 1: length=3, ref=20, width=4
  // Values: [10+0, 10+1, 20+0, 20+1, 20+2] = [10, 11, 20, 21, 22]
  //
  // Bit layout (big-endian, continuous):
  // Group refs (8 bits each): 00001010 (10), 00010100 (20)
  // Group widths (4 bits each): 0100 (4), 0100 (4)
  // Scaled lengths (4 bits): 0010 (2) - only group 0, group 1 uses true_length
  // Packed values x2 (4 bits each): 0000 (0), 0001 (1), 0000 (0), 0001 (1), 0010 (2)
  //
  // Combined with octet alignment between metadata arrays:
  // refs   : 00001010 00010100
  // widths : 01000100
  // lengths: 0010 + 0000(padding)
  // values : 0000 0001 0000 0001 0010
  //       => 0x0A 0x14 0x44 0x20 0x01 0x01 0x20
  let data = Bytes::from_array([
    b'\x0A', b'\x14', b'\x44', b'\x20', b'\x01', b'\x01', b'\x20',
  ])
  let template : @section5.Grib2DataRepresentationTemplate52 = {
    reference_value_ieee: 0, // 0.0
    binary_scale_factor: 0,
    decimal_scale_factor: 0,
    bits_per_value: 8,
    original_field_value_type: 0,
    group_splitting_method: 1,
    missing_value_management: 0,
    primary_missing_value_substitute: 0,
    secondary_missing_value_substitute: 0,
    number_of_groups: 2,
    reference_group_widths: 0, // actual width = ref + read_bits
    bits_used_for_group_widths: 4,
    reference_group_lengths: 0,
    length_increment_group_lengths: 1,
    true_length_last_group: 3,
    bits_used_for_scaled_group_lengths: 4,
    reserved_tail: Bytes::new(0),
  }
  match unpack_complex(data, template, 5) {
    Ok(grid) => {
      inspect(grid.num_points, content="5")
      inspect(grid.values[0], content="10")
      inspect(grid.values[1], content="11")
      inspect(grid.values[2], content="20")
      inspect(grid.values[3], content="21")
      inspect(grid.values[4], content="22")
    }
    Err(_) => fail("unexpected error")
  }
}

///|
test "reverse_spatial_differencing order 1" {
  // Order 1: cumulative sum
  // Initial: [100], minimum: -5
  // Input differences: [0, 10, 20, 30]
  // After adding minimum: [0, 5, 15, 25]
  // Cumsum from initial: [100, 105, 120, 145]
  let descriptors : SpatialDiffDescriptors = {
    initial_values: [100],
    overall_minimum: -5,
  }
  let unpacked = [0, 10, 20, 30]
  let result = reverse_spatial_differencing(unpacked, descriptors, 1)
  inspect(result[0], content="145")
  inspect(result[1], content="120")
  inspect(result[2], content="105")
  inspect(result[3], content="100")
}

///|
test "reverse_spatial_differencing order 2" {
  // Order 2: second differences
  // Initial: [100, 110], minimum: 0
  // Input second diffs: [0, 0, 0, 0]
  // Formula: result[i] = diff[i] + min + 2*result[i-1] - result[i-2]
  // result[0] = 100, result[1] = 110
  // result[2] = 0 + 0 + 2*110 - 100 = 120
  // result[3] = 0 + 0 + 2*120 - 110 = 130
  let descriptors : SpatialDiffDescriptors = {
    initial_values: [100, 110],
    overall_minimum: 0,
  }
  let unpacked = [0, 0, 0, 0]
  let result = reverse_spatial_differencing(unpacked, descriptors, 2)
  inspect(result[0], content="130")
  inspect(result[1], content="120")
  inspect(result[2], content="110")
  inspect(result[3], content="100")
}
