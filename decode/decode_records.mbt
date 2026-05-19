///|
/// Walk every message/submessage in `context` and assemble a flat array of
/// `Grib2RecordMeta`. Each entry captures the wgrib2-relevant offsets, ID
/// strings, code-table lookups, and inferred fields that the inventory
/// renderer later projects into output columns. Fields that do not apply to
/// the current PDT/GDT/DRT are populated with -1 so the renderer can treat
/// "absent" uniformly.
///|
pub fn decode_records(context : @context.Grib2FileContext) -> Array[Grib2RecordMeta] {
  let records : Array[Grib2RecordMeta] = []
  let mut global_index = 1
  for message_index in 0..<context.messages.length() {
    let message = context.messages[message_index]
    let submessage_count = message.submessages.length()
    let record_time = format_ref_time_yyyymmddhh(message)
    let record_time_full = format_ref_time_yyyymmddhhmmss(message)
    let record_unix_rt = compute_ref_time_unix(message)
    let section1 = section_slice(message, message.section1)
    let section1_center = if section1.length() >= 9 {
      read_u16_be_from(section1, 5)
    } else {
      -1
    }
    let section1_subcenter = if section1.length() >= 11 {
      read_u16_be_from(section1, 7)
    } else {
      -1
    }
    let section1_master_tables_version = if section1.length() >= 10 {
      section1[9].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section1_local_tables_version = if section1.length() >= 11 {
      section1[10].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section1_significance_of_ref_time = if section1.length() >= 12 {
      section1[11].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section1_production_status = if section1.length() >= 20 {
      section1[19].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section1_data_type = if section1.length() >= 21 {
      section1[20].to_uint().reinterpret_as_int()
    } else {
      -1
    }
    let section0_reserved = "0x" +
      @core.hex_byte(message.raw[4]) +
      @core.hex_byte(message.raw[5])
    let mut previous_submessage_end = -1
    for submessage_index in 0..<submessage_count {
      let submessage = message.submessages[submessage_index]
      let record_id = format_record_id(
        context,
        message_index + 1,
        submessage_index + 1,
        submessage_count,
        global_index,
      )
      let section2_length = match submessage.section2 {
        Some(section2) => section2.length
        None => 0
      }
      let section3 = section_slice(message, submessage.section3)
      let section4 = section_slice(message, submessage.section4)
      let section5 = section_slice(message, submessage.section5)
      let section6 = section_slice(message, submessage.section6)
      let section3_template_id = if section3.length() >= 14 {
        read_u16_be_from(section3, 12)
      } else {
        -1
      }
      let section3_reused = if submessage_index == 0 {
        false
      } else {
        submessage.section3.start < previous_submessage_end
      }
      let section3_gdef_source = if section3.length() >= 6 {
        section3[5].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_npts = if section3.length() >= 10 {
        read_u32_be_from(section3, 6)
      } else {
        0
      }
      // Section 3 octet 11 (0-indexed 10): number of octets in optional list of
      // numbers defining number of points. Non-zero indicates a thinned/reduced
      // grid and selects how the trailing list is interpreted (code table 3.11).
      let section3_num_octets_per_optional_list = if section3.length() >= 11 {
        section3[10].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_interpretation_of_optional_list = if section3.length() >= 12 {
        section3[11].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_is_spectral = section3_template_id == 50 ||
        section3_template_id == 51 ||
        section3_template_id == 52 ||
        section3_template_id == 53
      let section3_spectral_representation_type = if section3_is_spectral &&
        section3.length() >= 27 {
        section3[26].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_spectral_representation_mode = if section3_is_spectral &&
        section3.length() >= 28 {
        section3[27].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_grid_point_position = if (
          section3_template_id == 100 || section3_template_id == 101
        ) &&
        section3.length() >= 32 {
        section3[31].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_vertical_coord_meaning = if section3_template_id == 1200 &&
        section3.length() >= 39 {
        section3[38].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_horizontal_line_type = if section3_template_id == 1100 &&
        section3.length() >= 60 {
        section3[59].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_vertical_dim_coord_def = if section3_template_id == 1000 &&
        section3.length() >= 64 {
        section3[63].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_ni = if section3_template_id == 0 && section3.length() >= 34 {
        read_u32_be_from(section3, 30)
      } else {
        -1
      }
      let section3_nj = if section3_template_id == 0 && section3.length() >= 38 {
        read_u32_be_from(section3, 34)
      } else {
        -1
      }
      let section3_resolution_flags = if section3_template_id == 0 &&
        section3.length() >= 55 {
        section3[54].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_lat1_microdeg = if section3_template_id == 0 &&
        section3.length() >= 50 {
        read_i32_sign_magnitude_from(section3, 46)
      } else {
        -1
      }
      let section3_lon1_microdeg = if section3_template_id == 0 &&
        section3.length() >= 54 {
        read_i32_sign_magnitude_from(section3, 50)
      } else {
        -1
      }
      let section3_lat2_microdeg = if section3_template_id == 0 &&
        section3.length() >= 59 {
        read_i32_sign_magnitude_from(section3, 55)
      } else {
        -1
      }
      let section3_lon2_microdeg = if section3_template_id == 0 &&
        section3.length() >= 63 {
        read_i32_sign_magnitude_from(section3, 59)
      } else {
        -1
      }
      let section3_di_microdeg = if section3_template_id == 0 &&
        section3.length() >= 67 {
        read_u32_be_from(section3, 63)
      } else {
        -1
      }
      let section3_dj_microdeg = if section3_template_id == 0 &&
        section3.length() >= 71 {
        read_u32_be_from(section3, 67)
      } else {
        -1
      }
      let section3_scanning_mode = if section3_template_id == 0 &&
        section3.length() >= 72 {
        section3[71].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Earth shape parameters from template payload (template 3.0 and similar)
      let section3_shape_of_earth = if section3.length() >= 15 {
        section3[14].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section3_scale_factor_radius = if section3.length() >= 16 {
        section3[15].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_scaled_value_radius = if section3.length() >= 20 {
        read_u32_be_from(section3, 16)
      } else {
        0
      }
      let section3_scale_factor_major = if section3.length() >= 21 {
        section3[20].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_scaled_value_major = if section3.length() >= 25 {
        read_u32_be_from(section3, 21)
      } else {
        0
      }
      let section3_scale_factor_minor = if section3.length() >= 26 {
        section3[25].to_uint().reinterpret_as_int()
      } else {
        0
      }
      let section3_scaled_value_minor = if section3.length() >= 30 {
        read_u32_be_from(section3, 26)
      } else {
        0
      }
      let section4_template_id = if section4.length() >= 9 {
        read_u16_be_from(section4, 7)
      } else {
        -1
      }
      let section4_num_coord = if section4.length() >= 7 {
        read_u16_be_from(section4, 5)
      } else {
        0
      }
      let section4_process_code = if section4.length() >= 12 {
        section4[11].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_background_process = if section4.length() >= 13 {
        section4[12].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_forecast_process = if section4.length() >= 14 {
        section4[13].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let category = if section4.length() >= 11 {
        section4[9].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let parameter = if section4.length() >= 11 {
        section4[10].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let time_unit = if section4.length() >= 18 {
        section4[17].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let forecast_time = if section4.length() >= 22 {
        read_u32_be_from(section4, 18)
      } else {
        -1
      }
      let l1t = if section4.length() >= 23 {
        section4[22].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let l1sf = if section4.length() >= 24 {
        section4[23].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let l1v = if section4.length() >= 28 {
        read_u32_be_from(section4, 24)
      } else {
        -1
      }
      let l2t = if section4.length() >= 29 {
        section4[28].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let l2sf = if section4.length() >= 30 {
        section4[29].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let l2v = if section4.length() >= 34 {
        read_u32_be_from(section4, 30)
      } else {
        -1
      }
      let section4_ens_type = if (
          section4_template_id == 1 ||
          section4_template_id == 11 ||
          section4_template_id == 2 ||
          section4_template_id == 12
        ) &&
        section4.length() >= 35 {
        section4[34].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_ens_perturbation_number = if (
          section4_template_id == 1 || section4_template_id == 11
        ) &&
        section4.length() >= 36 {
        section4[35].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_ens_member_count = if (
          section4_template_id == 1 || section4_template_id == 11
        ) &&
        section4.length() >= 37 {
        section4[36].to_uint().reinterpret_as_int()
      } else if (section4_template_id == 2 || section4_template_id == 12) &&
        section4.length() >= 36 {
        section4[35].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_prob_forecast_index = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 35 {
        section4[34].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_prob_total_forecasts = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 36 {
        section4[35].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_prob_type = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 37 {
        section4[36].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section4_prob_lower_scale_factor = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 38 {
        read_signed_byte_from(section4, 37)
      } else {
        0
      }
      let section4_prob_lower_value = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 42 {
        read_i32_sign_magnitude_from(section4, 38)
      } else {
        -1
      }
      let section4_prob_upper_scale_factor = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 43 {
        read_signed_byte_from(section4, 42)
      } else {
        0
      }
      let section4_prob_upper_value = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 47 {
        read_i32_sign_magnitude_from(section4, 43)
      } else {
        -1
      }
      // ---- Code-table extraction for less-common PDTs -------------------
      // PDTs 8/9/11/12/13/14 store the statistical processing code (table 4.10)
      // at section-4 octet 47 and the time-increment type (table 4.11) at
      // octet 48. PDT 10 inserts a 1-byte derivative type at octet 35 but
      // keeps the same statistical layout, so we cover all of these with one
      // offset. The values are 1-indexed; section4 is a 0-indexed BytesView,
      // therefore octet 47 → byte 46.
      let pdt_has_statistical_processing = section4_template_id == 8 ||
        section4_template_id == 9 ||
        section4_template_id == 10 ||
        section4_template_id == 11 ||
        section4_template_id == 12 ||
        section4_template_id == 13 ||
        section4_template_id == 14
      let section4_statistical_processing = if section4_template_id == 15 {
        // PDT 15: statistical processing at octet 35.
        if section4.length() >= 35 {
          section4[34].to_uint().reinterpret_as_int()
        } else {
          -1
        }
      } else if pdt_has_statistical_processing {
        if section4.length() >= 47 {
          section4[46].to_uint().reinterpret_as_int()
        } else {
          -1
        }
      } else {
        -1
      }
      let section4_time_increment_type = if pdt_has_statistical_processing &&
        section4.length() >= 48 {
        section4[47].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // PDT 15: Code Table 4.15 at octet 36 (statistical area indicator just
      // after the "statistical-processing" octet at 35).
      let section4_spatial_processing = if section4_template_id == 15 &&
        section4.length() >= 36 {
        section4[35].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // PDT 35 (and some derivatives) carry Code Table 4.16 at octet 14, but
      // wgrib2 v3.1.3 prints `code table 4.16=%d` only when section 4 actually
      // names a quality value. We follow wgrib2's policy of emitting the field
      // exclusively for PDT 35 (the canonical "quality" PDT) at octet 14.
      let section4_quality_value = if section4_template_id == 35 &&
        section4.length() >= 14 {
        section4[13].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Code Table 4.91 (Type of interval) sits at octet 37 of PDTs 5 and 9
      // (after the probability metadata) and at octet 15/16 of PDTs 80-84.
      let section4_interval_type = if (
          section4_template_id == 5 || section4_template_id == 9
        ) &&
        section4.length() >= 37 {
        section4[36].to_uint().reinterpret_as_int()
      } else if (
          section4_template_id == 80 ||
          section4_template_id == 81 ||
          section4_template_id == 82 ||
          section4_template_id == 84
        ) &&
        section4.length() >= 15 {
        section4[14].to_uint().reinterpret_as_int()
      } else if section4_template_id == 83 && section4.length() >= 16 {
        section4[15].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Code Table 4.230 (atmospheric chemical constituent type) – PDTs 40-43,
      // octets 12-13, 2-byte unsigned.
      let section4_chemical_constituent = if (
          section4_template_id == 40 ||
          section4_template_id == 41 ||
          section4_template_id == 42 ||
          section4_template_id == 43
        ) &&
        section4.length() >= 13 {
        read_u16_be_from(section4, 11)
      } else {
        -1
      }
      // Code Table 4.233 (aerosol type) – PDTs 44/45/46/47/48/49/50, octets 12-13.
      let section4_aerosol_type = if (
          section4_template_id == 44 ||
          section4_template_id == 45 ||
          section4_template_id == 46 ||
          section4_template_id == 47 ||
          section4_template_id == 48 ||
          section4_template_id == 49 ||
          section4_template_id == 50
        ) &&
        section4.length() >= 13 {
        read_u16_be_from(section4, 11)
      } else {
        -1
      }
      // Code Table 4.240 (distribution function) – PDTs 57/58/67/68, octets 18-19.
      let section4_distribution_function = if (
          section4_template_id == 57 ||
          section4_template_id == 58 ||
          section4_template_id == 67 ||
          section4_template_id == 68
        ) &&
        section4.length() >= 19 {
        read_u16_be_from(section4, 17)
      } else {
        -1
      }
      // Code Table 4.242 (tile classification) – PDTs 55/56 octet 12.
      let section4_tile_classification = if (
          section4_template_id == 55 || section4_template_id == 56
        ) &&
        section4.length() >= 12 {
        section4[11].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Code Table 4.241 (coverage attributes) – PDT 55 octet 17, PDT 56 octet 17.
      let section4_coverage_attributes = if (
          section4_template_id == 55 || section4_template_id == 56
        ) &&
        section4.length() >= 17 {
        section4[16].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section5_template_id = if section5.length() >= 11 {
        read_u16_be_from(section5, 9)
      } else {
        -1
      }
      let section5_num_defined_points = if section5.length() >= 9 {
        read_u32_be_from(section5, 5)
      } else {
        0
      }
      // Section 5 scaling parameters (for templates 50, 51, 52, 53, 540, 541, 542, etc.)
      // Bytes 12-15: Reference value (IEEE 754 float stored as 4-byte int)
      // Bytes 16-17: Binary scale factor (signed 16-bit)
      // Bytes 18-19: Decimal scale factor (signed 16-bit)
      // Byte 20: Number of bits per value
      let section5_reference_value_ieee = if section5.length() >= 15 {
        read_u32_be_from(section5, 11)
      } else {
        0
      }
      let section5_binary_scale_factor = if section5.length() >= 17 {
        read_i16_sign_magnitude_from(section5, 15)
      } else {
        0
      }
      let section5_decimal_scale_factor = if section5.length() >= 19 {
        read_i16_sign_magnitude_from(section5, 17)
      } else {
        0
      }
      let section5_bits_per_value = if section5.length() >= 20 {
        section5[19].to_uint().reinterpret_as_int()
      } else {
        0
      }
      // Code Table 5.1 (Type of original field values) at octet 21 for
      // templates 0/2/3/40/41/40000/40010. -1 means N/A for this packing.
      let section5_original_field_type = if (
          section5_template_id == 0 ||
          section5_template_id == 1 ||
          section5_template_id == 2 ||
          section5_template_id == 3 ||
          section5_template_id == 40 ||
          section5_template_id == 41 ||
          section5_template_id == 61 ||
          section5_template_id == 200
        ) &&
        section5.length() >= 21 {
        section5[20].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Code Table 5.4 (Group splitting method) at octet 22 of templates 2 and 3.
      let section5_group_split_method = if (
          section5_template_id == 2 || section5_template_id == 3
        ) &&
        section5.length() >= 22 {
        section5[21].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Code Table 5.5 (Missing value management) at octet 23 of templates 2 and 3.
      let section5_missing_value_management = if (
          section5_template_id == 2 || section5_template_id == 3
        ) &&
        section5.length() >= 23 {
        section5[22].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Code Table 5.6 (Spatial differencing order) at octet 48 of template 3.
      let section5_spatial_diff_order = if section5_template_id == 3 &&
        section5.length() >= 48 {
        section5[47].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      // Code Table 5.7 (IEEE precision) at octet 12 of template 4.
      let section5_ieee_precision = if section5_template_id == 4 &&
        section5.length() >= 12 {
        section5[11].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section6_bitmap_indicator = if section6.length() >= 6 {
        section6[5].to_uint().reinterpret_as_int()
      } else {
        -1
      }
      let section6_undef_points = if section6_bitmap_indicator == 0 {
        count_bitmap_undefined_points(section6, section3_npts)
      } else {
        0
      }
      let parameter_name = if category >= 0 && parameter >= 0 {
        decode_parameter_name(message.discipline, category, parameter)
      } else {
        NameUnknown("category/parameter unavailable")
      }
      let level_name = if section4.length() >= 34 {
        decode_level_name(l1t, l1sf, l1v, l2t, l2sf, l2v)
      } else {
        NameUnknown("level unavailable")
      }
      records.push({
        record_index: global_index,
        record_id,
        message_offset: message.offset,
        message_total_length: message.total_length,
        reference_time: record_time,
        reference_time_full: record_time_full,
        unix_rt: record_unix_rt,
        unix_vt: record_unix_rt, // TODO: add forecast time offset for actual verification time
        discipline: message.discipline,
        edition: message.edition,
        section1_center,
        section1_subcenter,
        section1_master_tables_version,
        section1_local_tables_version,
        section1_significance_of_ref_time,
        section1_production_status,
        section1_data_type,
        parameter_name,
        level_name,
        tail: format_tail(time_unit, forecast_time),
        section0_reserved,
        section3_template: decode_section3_template(section3_template_id),
        section4_template: decode_section4_template(section4_template_id),
        section5_template: decode_section5_template(section5_template_id),
        section1_length: message.section1.length,
        section2_length,
        section3_length: submessage.section3.length,
        section3_reused,
        section3_gdef_source,
        section3_npts,
        section3_num_octets_per_optional_list,
        section3_interpretation_of_optional_list,
        section3_spectral_representation_type,
        section3_spectral_representation_mode,
        section3_grid_point_position,
        section3_vertical_coord_meaning,
        section3_horizontal_line_type,
        section3_vertical_dim_coord_def,
        section3_ni,
        section3_nj,
        section3_resolution_flags,
        section3_lat1_microdeg,
        section3_lon1_microdeg,
        section3_lat2_microdeg,
        section3_lon2_microdeg,
        section3_di_microdeg,
        section3_dj_microdeg,
        section3_scanning_mode,
        section3_shape_of_earth,
        section3_scale_factor_radius,
        section3_scaled_value_radius,
        section3_scale_factor_major,
        section3_scaled_value_major,
        section3_scale_factor_minor,
        section3_scaled_value_minor,
        section4_length: submessage.section4.length,
        section4_num_coord,
        section4_parameter_category: category,
        section4_parameter_number: parameter,
        section4_time_unit: time_unit,
        section4_process_code,
        section4_ens_type,
        section4_ens_perturbation_number,
        section4_ens_member_count,
        section4_prob_forecast_index,
        section4_prob_total_forecasts,
        section4_prob_type,
        section4_prob_lower_scale_factor,
        section4_prob_lower_value,
        section4_prob_upper_scale_factor,
        section4_prob_upper_value,
        section4_first_surface_type: l1t,
        section4_second_surface_type: l2t,
        section4_background_process,
        section4_forecast_process,
        section4_statistical_processing,
        section4_time_increment_type,
        section4_spatial_processing,
        section4_quality_value,
        section4_interval_type,
        section4_chemical_constituent,
        section4_aerosol_type,
        section4_distribution_function,
        section4_coverage_attributes,
        section4_tile_classification,
        section5_length: submessage.section5.length,
        section5_num_defined_points,
        section5_reference_value_ieee,
        section5_binary_scale_factor,
        section5_decimal_scale_factor,
        section5_bits_per_value,
        section5_original_field_type,
        section5_group_split_method,
        section5_missing_value_management,
        section5_spatial_diff_order,
        section5_ieee_precision,
        section6_length: submessage.section6.length,
        section6_bitmap_indicator,
        section6_undef_points,
        section7_length: submessage.section7.length,
      })
      previous_submessage_end = submessage.section7.end_offset()
      global_index += 1
    }
  }
  records
}
