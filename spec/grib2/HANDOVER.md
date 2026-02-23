# GRIB2 MBT Handover Notes

This file is the minimal context needed to continue work without drift.

## Current Point

- Latest checkpoint commit: `a073ab7`
- Package split status:
  - typed codec moved to `typed/` package
  - typed package is now purpose-foldered:
    - `typed/section1/` (Section1 + shared binary helpers)
    - `typed/section2/` (Section2 model/decode/encode/dispatch)
    - `typed/section3/` (Section3 model/decode/encode/dispatch)
    - `typed/section4/` (Section4 model/decode/encode/dispatch)
    - `typed/section5/` (Section5 model/decode/encode/dispatch)
    - `typed/section6/` (Section6 model/decode/encode/dispatch)
    - `typed/section7/` (Section7 model/decode/encode/dispatch)
    - `typed/reexports.mbt` (facade re-export)
  - root package keeps bridge wrappers in `grib2_typed_sections_bridge.mbt`
  - typed tests moved to section files:
    - `typed/section1/grib2_typed_sections_section1_test.mbt`
    - `typed/section2/grib2_typed_sections_section2_test.mbt`
    - `typed/section3/grib2_typed_sections_section3_test.mbt`
    - `typed/section4/grib2_typed_sections_section4_test_helpers.mbt`
    - `typed/section4/grib2_typed_sections_section4_test_*.mbt`
  - Section 4 types/encode files are split by template ranges (`*_040_463`, `*_467_499`, `*_4100_41101`)
  - Section 4 decode files are further split by template bands:
    - `*_040_420`, `*_430_448`, `*_449_463`
    - `*_467_479`, `*_480_489`, `*_490_499`
    - `*_4100_4129`, `*_4130_4149`, `*_4150_41101`
  - Section 4 tests follow the same template-band split (`grib2_typed_sections_section4_test_*.mbt`)
- Completed in Section 4 typed decode/encode:
  - Template 4.110
  - Template 4.111
  - Template 4.112
  - Template 4.113
  - Template 4.114
  - Template 4.115
  - Template 4.116
  - Template 4.117
  - Template 4.118
  - Template 4.119
  - Template 4.120
  - Template 4.121
  - Template 4.122
  - Template 4.123
  - Template 4.124
  - Template 4.125
  - Template 4.126
  - Template 4.127
  - Template 4.128
  - Template 4.129
  - Template 4.130
  - Template 4.131
  - Template 4.132
  - Template 4.133
  - Template 4.134
  - Template 4.135
  - Template 4.136
  - Template 4.137
  - Template 4.138
  - Template 4.139
  - Template 4.140
  - Template 4.141
  - Template 4.142
  - Template 4.143
  - Template 4.144
  - Template 4.145
  - Template 4.146
  - Template 4.147
  - Template 4.148
  - Template 4.149
  - Template 4.150
  - Template 4.151
  - Template 4.152
  - Template 4.153
  - Template 4.154
  - Template 4.155
  - Template 4.254
  - Template 4.1000
  - Template 4.1001
  - Template 4.1002
  - Template 4.1100
  - Template 4.1101
- Completed in Section 5 typed decode/encode:
  - Template 5.0
  - Template 5.1
  - Template 5.2
  - Template 5.3
  - Template 5.4
  - Template 5.40
  - Template 5.41
  - Template 5.42
  - Template 5.50
  - Template 5.51
  - Template 5.53
  - Template 5.61
  - Template 5.200
- Completed in Section 7 typed decode/encode:
  - Template 7.0
  - Template 7.1
  - Template 7.2
  - Template 7.3
  - Template 7.4
  - Template 7.40
  - Template 7.41
  - Template 7.42
  - Template 7.50
  - Template 7.51
  - Template 7.53
- Completed in Section 6 typed decode/encode foundation:
  - bitmap indicator + raw bitmap roundtrip
- Completed in Section 2 typed decode/encode foundation:
  - Template 2.1
- Completed in Core Sections validation:
  - Section 0 parse/rebuild + strict invariant coverage
  - Section 8 magic/tail + strict invariant coverage
- Completed in CLI compatibility expansion:
  - Added inventory parity for `-Sec5`, `-Sec6`, `-Sec_len`, `-n`, `-range`, `-var`, `-lev`, `-ftime`, `-grid`, `-pdt`, `-process`, `-ens`, `-prob`, `-disc`, `-center`, `-subcenter`, `-packing`, `-bitmap`, `-nxny`, `-npts`
  - Extended snapshot generator and parser tests to compare the above options against committed `wgrib2` outputs
  - Added `spec/grib2/WGRIB2_OPTION_MATRIX.md` and `spec/grib2/wgrib2_options_v3.1.3.tsv` for option inventory tracking
- Completed in Code Tables:
  - Table 0.0 discipline decoder (known/unknown split)
  - Table 1.0 master table version decoder (known/unknown split)
  - Tables 1.1-1.6 Section1 decoders (known/unknown split)
  - Table 3.0 grid definition source decoder (known/unknown split)
  - Table 3.1 grid definition template decoder (known/unknown split)
  - Table 3.2 shape of reference system decoder (known/unknown split)
  - Tables 3.3-3.4 flag decoders (resolution/scanning mode)
  - Tables 3.5-3.11 decoders (projection/spectral/diamond/list)
  - Table 4.0 product definition template decoder (known/unknown split)
  - Table 4.1 parameter category-by-discipline decoder (known/unknown split)
  - Table 4.2 parameter-number decoder foundation (known/unknown split)
  - Table 4.2-0-0 temperature parameter decoder (known/unknown split)
  - Table 4.2-0-1 moisture parameter decoder (known/unknown split)
  - Table 4.2-0-2 momentum parameter decoder (known/unknown split)
  - Table 4.2-0-3 mass parameter decoder (known/unknown split)
  - Table 4.2-0-4 shortwave radiation parameter decoder (known/unknown split)
  - Table 4.2-0-5 longwave radiation parameter decoder (known/unknown split)
  - Table 4.2-0-6 cloud parameter decoder (known/unknown split)
  - Table 4.2-0-7 thermodynamic stability parameter decoder (known/unknown split)
  - Table 4.2-0-13 aerosol parameter decoder (known/unknown split)
  - Table 4.2-0-14 trace gases parameter decoder (known/unknown split)
  - Table 4.2-0-15 radar parameter decoder (known/unknown split)
  - Table 4.2-0-16 forecast radar imagery parameter decoder (known/unknown split)
  - Table 4.2-0-17 electrodynamics parameter decoder (known/unknown split)
  - Table 4.2-0-18 nuclear/radiology parameter decoder (known/unknown split)
  - Table 4.2-0-19 physical atmospheric properties parameter decoder (known/unknown split)
  - Table 4.2-0-190 meteorological ASCII parameter decoder (known/unknown split)
  - Table 4.2-0-191 miscellaneous parameter decoder (known/unknown split)
  - Table 4.2-0-192 covariance parameter decoder (known/unknown split)
  - Table 4.2-1-0 hydrology basic parameter decoder (known/unknown split)
  - Table 4.2-1-1 hydrology probabilities parameter decoder (known/unknown split)
  - Table 4.2-1-2 inland water and sediment properties parameter decoder (known/unknown split)
  - Table 4.2-2-0 vegetation/biomass parameter decoder (known/unknown split)
  - Table 4.2-2-1 agricultural special products parameter decoder (known/unknown split)
  - Table 4.2-2-3 soil parameter decoder (known/unknown split)
  - Table 4.2-2-4 fire weather parameter decoder (known/unknown split)
  - Table 4.2-2-5 glaciers and inland ice parameter decoder (known/unknown split)
  - Table 4.2-2-6 urban areas parameter decoder (known/unknown split)
  - Table 4.2-2-7 thermodynamic properties parameter decoder (known/unknown split)
  - Table 4.2-3-0 image format parameter decoder (known/unknown split)
  - Table 4.2-3-1 quantitative parameter decoder (known/unknown split)
  - Table 4.2-3-2 cloud properties parameter decoder (known/unknown split)
  - Table 4.2-3-3 flight rules conditions parameter decoder (known/unknown split)
  - Table 4.2-3-4 volcanic ash parameter decoder (known/unknown split)
  - Table 4.2-3-5 sea surface temperature parameter decoder (known/unknown split)
  - Table 4.2-3-6 solar radiation parameter decoder (known/unknown split)
  - Table 4.2-3-192 forecast satellite imagery parameter decoder (known/unknown split)
  - Table 4.2-4-0 space weather temperature parameter decoder (known/unknown split)
  - Table 4.2-4-1 space weather momentum parameter decoder (known/unknown split)
  - Table 4.2-4-2 space weather charged particle parameter decoder (known/unknown split)
  - Table 4.2-4-3 space weather electric/magnetic fields parameter decoder (known/unknown split)
  - Table 4.2-4-4 space weather energetic particles parameter decoder (known/unknown split)
  - Table 4.2-4-5 space weather waves parameter decoder (known/unknown split)
  - Table 4.2-4-6 space weather solar electromagnetic emissions parameter decoder (known/unknown split)
  - Table 4.2-4-7 space weather terrestrial electromagnetic emissions parameter decoder (known/unknown split)
  - Table 4.2-4-8 space weather imagery parameter decoder (known/unknown split)
  - Table 4.2-4-9 space weather ion-neutral coupling parameter decoder (known/unknown split)
  - Table 4.2-4-10 space weather indices parameter decoder (known/unknown split)
  - Table 4.2-10-0 oceanographic waves parameter decoder (known/unknown split)
  - Table 4.2-10-1 oceanographic currents parameter decoder (known/unknown split)
  - Table 4.2-10-2 oceanographic ice parameter decoder (known/unknown split)
  - Table 4.2-10-3 oceanographic surface properties parameter decoder (known/unknown split)
  - Table 4.2-10-4 oceanographic subsurface properties parameter decoder (known/unknown split)
  - Table 4.2-10-191 oceanographic miscellaneous parameter decoder (known/unknown split)
  - Table 4.2-20-0 health and socioeconomic impacts health indicators parameter decoder (known/unknown split)
  - Table 4.2-20-1 health and socioeconomic impacts epidemiology parameter decoder (known/unknown split)
  - Table 4.2-20-2 health and socioeconomic impacts socioeconomic indicators parameter decoder (known/unknown split)
  - Table 4.2-20-3 renewable energy sector parameter decoder (known/unknown split)
  - Table 4.2-20-4 meteorological and hydrological hazard indices parameter decoder (known/unknown split)
  - Table 4.2-20-5 environmental hazard indices parameter decoder (known/unknown split)
  - Table 4.2-191-0 computational parameters stochastic parameterizations parameter decoder (known/unknown split)
  - Code Table 4.3 type of generating process decoder (known/unknown split)
  - Code Table 4.4 indicator of unit of time range decoder (known/unknown split)
  - Code Table 4.5 fixed surface types and units decoder (known/unknown split)
  - Code Table 4.6 type of ensemble forecast decoder (known/unknown split)
  - Code Table 4.7 derived forecast decoder (known/unknown split)
  - Code Table 4.8 clustering method decoder (known/unknown split)
  - Code Table 4.9 probability type decoder (known/unknown split)
  - Code Table 4.10 type of statistical processing decoder (known/unknown split)
  - Code Table 4.11 type of time intervals decoder (known/unknown split)
  - Code Table 4.12 operating mode decoder (known/unknown split)
  - Code Table 4.13 quality control indicator decoder (known/unknown split)
  - Code Table 4.14 clutter filter indicator decoder (known/unknown split)
  - Code Table 4.15 type of spatial processing decoder (known/unknown split)
  - Code Table 4.16 quality value associated with parameter decoder (known/unknown split)
  - Code Table 4.91 type of interval decoder (known/unknown split)
  - Code Table 4.100 type of reference dataset decoder (known/unknown split)
  - Code Table 4.101 type of relationship to reference dataset decoder (known/unknown split)
  - Code Table 4.102 statistical processing of reference period decoder (known/unknown split)
  - Code Table 4.103 spatial vicinity type decoder (known/unknown split)
  - Code Table 4.104 spatial and temporal vicinity processing decoder (known/unknown split)
  - Code Table 4.105 spatial and temporal vicinity missing data decoder (known/unknown split)
  - Code Table 4.106 radar data quality flags decoder (known/unknown split)
  - Code Table 4.120 verification scores decoder (known/unknown split)
  - Code Table 4.121 type of reference dataset for verification decoder (known/unknown split)
  - Code Table 4.122 type of additional arguments for verification score decoder (known/unknown split)
  - Code Table 4.201 precipitation type decoder (known/unknown split)
  - Code Table 4.202 precipitable water category decoder (known/unknown split)
  - Code Table 4.203 cloud type decoder (known/unknown split)
  - Code Table 4.204 thunderstorm coverage decoder (known/unknown split)
  - Code Table 4.205 presence of aerosol decoder (known/unknown split)
  - Code Table 4.206 volcanic ash decoder (known/unknown split)
  - Code Table 4.207 icing decoder (known/unknown split)
  - Code Table 4.208 turbulence decoder (known/unknown split)
  - Code Table 4.209 planetary boundary-layer regime decoder (known/unknown split)
  - Code Table 4.210 contrail intensity decoder (known/unknown split)
  - Code Table 4.211 contrail engine type decoder (known/unknown split)
  - Code Table 4.212 land use decoder (known/unknown split)
  - Code Table 4.213 soil type decoder (known/unknown split)
  - Code Table 4.214 environmental factor qualifier decoder (known/unknown split)
  - Code Table 4.215 remotely-sensed snow coverage decoder (known/unknown split)
  - Code Table 4.216 elevation of snow covered terrain decoder (known/unknown split)
  - Code Table 4.217 cloud mask type decoder (known/unknown split)
  - Code Table 4.218 pixel scene type decoder (known/unknown split)
  - Code Table 4.219 cloud top height quality indicator decoder (known/unknown split)
  - Code Table 4.220 horizontal dimension processed decoder (known/unknown split)
  - Code Table 4.221 treatment of missing data decoder (known/unknown split)
  - Code Table 4.222 categorical result decoder (known/unknown split)
  - Code Table 4.223 fire detection indicator decoder (known/unknown split)
  - Code Table 4.224 categorical outlook decoder (known/unknown split)
  - Code Table 4.225 weather decoder (known/unknown split)
  - Code Table 4.227 icing scenario decoder (known/unknown split)
  - Code Table 4.228 icing severity decoder (known/unknown split)
  - Code Table 4.230 atmospheric chemical or physical constituent type decoder (known/unknown split)
  - Code Table 4.233 aerosol type decoder (known/unknown split)
  - Code Table 4.234 canopy cover fraction decoder (known/unknown split)
  - Code Table 4.236 soil texture fraction decoder (known/unknown split)
  - Code Table 4.238 source or sink decoder (known/unknown split)
  - Code Table 4.239 wetland type decoder (known/unknown split)
  - Code Table 4.240 type of distribution function decoder (known/unknown split)
  - Code Table 4.241 coverage attributes decoder (known/unknown split)
  - Code Table 4.242 tile classification decoder (known/unknown split)
  - Code Table 4.243 tile class decoder (known/unknown split)
  - Code Table 4.244 quality indicator decoder (known/unknown split)
  - Code Table 4.246 thunderstorm intensity index decoder (known/unknown split)
  - Code Table 4.247 precipitation intensity decoder (known/unknown split)
  - Code Table 4.248 method used to derive data value for a given local time decoder (known/unknown split)
  - Code Table 4.249 character of precipitation decoder (known/unknown split)
  - Code Table 4.250 drainage direction decoder (known/unknown split)
  - Code Table 4.251 wave direction and frequency formulae decoder (known/unknown split)
  - Code Table 4.252 tile classes and groupings decoder (known/unknown split)
  - Code Table 4.253 hazard index decoder (known/unknown split)
  - Code Table 4.333 transport dispersion model decoder (known/unknown split)
  - Code Table 4.335 emission scenario origin decoder (known/unknown split)
  - Code Table 4.336 NWP model decoder (known/unknown split)
- Next target: proceed to Section 5 related tables.

## Read First

- `AGENTS.md`
- `spec/grib2/WORK_CHECKLIST.md`
- `spec/grib2/IMPLEMENTATION_CHECKLIST.md`
- `grib2_typed_sections.mbt`
- `grib2_typed_sections_bridge.mbt`
- `typed/section2/grib2_typed_sections_section2_types.mbt`
- `typed/section2/grib2_typed_sections_section2_decode.mbt`
- `typed/section2/grib2_typed_sections_section2_encode.mbt`
- `typed/section2/grib2_typed_sections_section2_dispatch.mbt`
- `typed/section2/grib2_typed_sections_section2_test.mbt`
- `grib2_decode.mbt`
- `tests/native/grib2_decode_test.mbt`
- `tests/native/grib2_parser_test.mbt`
- `tests/native/grib2_writer_fast_test.mbt`
- `typed/section4/grib2_typed_sections_section4_dispatch.mbt`
- `typed/section4/grib2_typed_sections_section4_decode_*.mbt`
- `typed/section4/grib2_typed_sections_section4_encode_*.mbt`
- `typed/section4/grib2_typed_sections_section4_types_*.mbt`
- `typed/section4/grib2_typed_sections_section4_test_helpers.mbt`
- `typed/section4/grib2_typed_sections_section4_test_*.mbt`
- `typed/section5/grib2_typed_sections_section5_types.mbt`
- `typed/section5/grib2_typed_sections_section5_decode.mbt`
- `typed/section5/grib2_typed_sections_section5_encode.mbt`
- `typed/section5/grib2_typed_sections_section5_dispatch.mbt`
- `typed/section5/grib2_typed_sections_section5_test.mbt`
- `typed/section6/grib2_typed_sections_section6_types.mbt`
- `typed/section6/grib2_typed_sections_section6_decode.mbt`
- `typed/section6/grib2_typed_sections_section6_encode.mbt`
- `typed/section6/grib2_typed_sections_section6_dispatch.mbt`
- `typed/section6/grib2_typed_sections_section6_test.mbt`
- `typed/section7/grib2_typed_sections_section7_types.mbt`
- `typed/section7/grib2_typed_sections_section7_decode.mbt`
- `typed/section7/grib2_typed_sections_section7_encode.mbt`
- `typed/section7/grib2_typed_sections_section7_dispatch.mbt`
- `typed/section7/grib2_typed_sections_section7_test.mbt`

## Implementation Rules

- Keep roundtrip safety: `decode -> encode` must preserve data.
- Keep unknown/raw bytes (`reserved_tail`, unknown templates) intact.
- Do not depend on `wgrib2` in tests/CI. Use committed snapshots only.
- Follow checklist order to avoid planning drift.

## Per-Template Work Pattern (Section 4)

1. Add typed struct(s) in matching `typed/section4/grib2_typed_sections_section4_types_*.mbt`.
2. Add decode function(s) in matching `typed/section4/grib2_typed_sections_section4_decode_*.mbt`.
3. Add encode function(s) in matching `typed/section4/grib2_typed_sections_section4_encode_*.mbt`.
4. Wire template number dispatch in `typed/section4/grib2_typed_sections_section4_dispatch.mbt`.
5. Add roundtrip tests in matching `typed/section4/grib2_typed_sections_section4_test_*.mbt` and keep shared samples in `typed/section4/grib2_typed_sections_section4_test_helpers.mbt`.
6. Update checklist progress.

## Multi-Agent Parallel Plan

- Use 1 coordinator + N workers.
- Split by non-overlapping template ranges (example):
  - Worker A: Section4 sub-tables (`grib2_table4-2-0-0` and onward)
  - Worker B: section6/section7 regression + bridge cross-check
  - Worker C: checklist/docs integration and cross-check
- Each worker does full per-template flow for their range:
  - struct/decode/encode/dispatch/test
  - focused validation (`moon test ... --filter '*template4*'`, `moon check --target native`)
- To reduce merge conflicts, workers should not edit checklist/handover files.
- Coordinator integrates worker branches in template-number order, then updates:
  - `spec/grib2/IMPLEMENTATION_CHECKLIST.md`
  - `spec/grib2/WORK_CHECKLIST.md`
  - `spec/grib2/HANDOVER.md`
- After integration, coordinator runs final validation:
  - `moon check --target native`
  - `moon check --target wasm`
  - `moon info --target native && moon fmt`

## Fast Validation Commands

Use focused tests first for speed:

```sh
moon test typed/section4 --target native --filter '*template411*'
moon test typed/section4 --target wasm --filter '*template411*'
moon test typed/section3 --target native --filter '*unknown section3*'
moon test typed/section2 --target native
moon test typed/section2 --target wasm
moon check --target native
moon check --target wasm
moon info --target native && moon fmt
```

Native regression tests are now split by purpose:

- `tests/native/grib2_writer_fast_test.mbt`: normal development loop
- `tests/native/grib2_writer_roundtrip_test.mbt`: slow full-fixture roundtrip
  - run this at final verification only
- `tests/native/grib2_parser_test.mbt`, `tests/native/grib2_decode_test.mbt`, `tests/native/grib2_io_adapter_test.mbt`
  - run per file as needed (sectioned execution)

Recommended native validation order:

```sh
moon test tests/native/grib2_parser_test.mbt --target native
moon test tests/native/grib2_decode_test.mbt --target native
moon test tests/native/grib2_writer_fast_test.mbt --target native
moon test tests/native/grib2_io_adapter_test.mbt --target native
# final only
moon test tests/native/grib2_writer_roundtrip_test.mbt --target native
```

When a larger chunk is done, run broader tests.

## Ready-To-Use Resume Prompt

```text
Continue grib2_mbt from commit a073ab7.
Goal: keep implementing IMPLEMENTATION_CHECKLIST from the first incomplete item.
Section 4 is done through 4.1101, and Section 5.0-5.4, 5.40-5.42, 5.50-5.53, 5.61, 5.200 is done.
Section 7 templates are fully done (7.0-7.4, 7.40-7.42, 7.50-7.53).
Section 6 typed foundation is done.
Section 2 typed foundation (Template 2.1) is done.
Core sections (`grib2_sect0`, `grib2_sect8`) are done with parser/strict-writer invariants tests.
Code Table 0.0 is done.
Code Table 1.0 is done.
Code Tables 1.1-1.6 are done.
Code Table 3.0 is done.
Code Table 3.1 is done.
Code Table 3.2 is done.
Code Tables 3.3-3.4 are done.
Code Tables 3.5-3.11 are done.
Code Table 4.0 is done.
Code Table 4.1 is done.
Code Table 4.2 foundation is done.
Code Table 4.2-0-0 is done.
Code Table 4.2-0-1 is done.
Code Table 4.2-0-2 is done.
Code Table 4.2-0-3 is done.
Code Table 4.2-0-4 is done.
Code Table 4.2-0-5 is done.
Code Table 4.2-0-6 is done.
Code Table 4.2-0-7 is done.
Code Table 4.2-0-13 is done.
Code Table 4.2-0-14 is done.
Code Table 4.2-0-15 is done.
Code Table 4.2-0-16 is done.
Code Table 4.2-0-17 is done.
Code Table 4.2-0-18 is done.
Code Table 4.2-0-19 is done.
Code Table 4.2-0-190 is done.
Code Table 4.2-0-191 is done.
Code Table 4.2-0-192 is done.
Code Table 4.2-1-0 is done.
Code Table 4.2-1-1 is done.
Code Table 4.2-1-2 is done.
Code Table 4.2-2-0 is done.
Code Table 4.2-2-1 is done.
Code Table 4.2-2-3 is done.
Code Table 4.2-2-4 is done.
Code Table 4.2-2-5 is done.
Code Table 4.2-2-6 is done.
Code Table 4.2-2-7 is done.
Code Table 4.2-3-0 is done.
Code Table 4.2-3-1 is done.
Code Table 4.2-3-2 is done.
Code Table 4.2-3-3 is done.
Code Table 4.2-3-4 is done.
Code Table 4.2-3-5 is done.
Code Table 4.2-3-6 is done.
Code Table 4.2-3-192 is done.
Code Table 4.2-4-0 is done.
Code Table 4.2-4-1 is done.
Code Table 4.2-4-2 is done.
Code Table 4.2-4-3 is done.
Code Table 4.2-4-4 is done.
Code Table 4.2-4-5 is done.
Code Table 4.2-4-6 is done.
Code Table 4.2-4-7 is done.
Code Table 4.2-4-8 is done.
Code Table 4.2-4-9 is done.
Code Table 4.2-4-10 is done.
Code Table 4.2-10-0 is done.
Code Table 4.2-10-1 is done.
Code Table 4.2-10-2 is done.
Code Table 4.2-10-3 is done.
Code Table 4.2-10-4 is done.
Code Table 4.2-10-191 is done.
Code Table 4.2-20-0 is done.
Code Table 4.2-20-1 is done.
Code Table 4.2-20-2 is done.
Code Table 4.2-20-3 is done.
Code Table 4.2-20-4 is done.
Code Table 4.2-20-5 is done.
Code Table 4.2-191-0 is done.
Code Table 4.3 is done.
Code Table 4.4 is done.
Code Table 4.5 is done.
Code Table 4.6 is done.
Code Table 4.7 is done.
Code Table 4.8 is done.
Code Table 4.9 is done.
Code Table 4.10 is done.
Code Table 4.11 is done.
Code Table 4.12 is done.
Code Table 4.13 is done.
Code Table 4.14 is done.
Code Table 4.15 is done.
Code Table 4.16 is done.
Code Table 4.91 is done.
Code Table 4.100 is done.
Code Table 4.101 is done.
Code Table 4.102 is done.
Code Table 4.103 is done.
Code Table 4.104 is done.
Code Table 4.105 is done.
Code Table 4.106 is done.
Code Table 4.120 is done.
Code Table 4.121 is done.
Code Table 4.122 is done.
Code Table 4.201 is done.
Code Table 4.202 is done.
Code Table 4.203 is done.
Code Table 4.204 is done.
Code Table 4.205 is done.
Code Table 4.206 is done.
Code Table 4.207 is done.
Code Table 4.208 is done.
Code Table 4.209 is done.
Code Table 4.210 is done.
Code Table 4.211 is done.
Code Table 4.212 is done.
Code Table 4.213 is done.
Code Table 4.214 is done.
Code Table 4.215 is done.
Code Table 4.216 is done.
Code Table 4.217 is done.
Code Table 4.218 is done.
Code Table 4.219 is done.
Code Table 4.220 is done.
Code Table 4.221 is done.
Code Table 4.222 is done.
Code Table 4.223 is done.
Code Table 4.224 is done.
Code Table 4.225 is done.
Code Table 4.227 is done.
Code Table 4.228 is done.
Code Table 4.230 is done.
Code Table 4.233 is done.
Code Table 4.234 is done.
Code Table 4.236 is done.
Code Table 4.238 is done.
Code Table 4.239 is done.
Code Table 4.240 is done.
Code Table 4.241 is done.
Code Table 4.242 is done.
Code Table 4.243 is done.
Code Table 4.244 is done.
Code Table 4.246 is done.
Code Table 4.247 is done.
Code Table 4.248 is done.
Code Table 4.249 is done.
Code Table 4.250 is done.
Code Table 4.251 is done.
Code Table 4.252 is done.
Code Table 4.253 is done.
Code Table 4.333 is done.
Code Table 4.335 is done.
Code Table 4.336 is done.
So continue from Section 5 related tables.
For code tables:
- add known/unknown split decoders and display mappings
- keep unknown code values roundtrip-safe and non-throwing
- update spec/grib2/WORK_CHECKLIST.md and IMPLEMENTATION_CHECKLIST.md
Constraints:
- no runtime/test dependency on wgrib2
- preserve unknown/reserved bytes for roundtrip safety
- prefer focused tests during implementation, then run check/info/fmt
```
