# GRIB2 MBT Handover Notes

This file is the minimal context needed to continue work without drift.

## Current Point

- Latest checkpoint commit: `a073ab7`
- Package split status:
  - typed codec moved to `typed/` package
  - typed package is now purpose-foldered:
    - `typed/section1/` (Section1 + shared binary helpers)
    - `typed/section3/` (Section3 model/decode/encode/dispatch)
    - `typed/section4/` (Section4 model/decode/encode/dispatch)
    - `typed/section5/` (Section5 model/decode/encode/dispatch)
    - `typed/section7/` (Section7 model/decode/encode/dispatch)
    - `typed/reexports.mbt` (facade re-export)
  - root package keeps bridge wrappers in `grib2_typed_sections_bridge.mbt`
  - typed tests moved to section files:
    - `typed/section1/grib2_typed_sections_section1_test.mbt`
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
- Next target: start Section 6 typed decode/encode foundation.

## Read First

- `AGENTS.md`
- `spec/grib2/WORK_CHECKLIST.md`
- `spec/grib2/IMPLEMENTATION_CHECKLIST.md`
- `grib2_typed_sections.mbt`
- `grib2_typed_sections_bridge.mbt`
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
  - Worker A: Section 6 typed foundation (indicator/raw model)
  - Worker B: section7 regression/bridge cross-check
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
Goal: keep implementing IMPLEMENTATION_CHECKLIST typed decode+encode from the first incomplete item.
Section 4 is done through 4.1101, and Section 5.0-5.4, 5.40-5.42, 5.50-5.53, 5.61, 5.200 is done.
Section 7 templates are fully done (7.0-7.4, 7.40-7.42, 7.50-7.53).
So continue from Section 6 typed decode/encode foundation.
For Section 6:
- add struct/decode/encode/dispatch in typed/section6/grib2_typed_sections_section6_*.mbt
- add roundtrip tests in typed/section6/grib2_typed_sections_section6_test.mbt
- update spec/grib2/WORK_CHECKLIST.md and IMPLEMENTATION_CHECKLIST.md
Constraints:
- no runtime/test dependency on wgrib2
- preserve unknown/reserved bytes for roundtrip safety
- prefer focused tests during implementation, then run check/info/fmt
```
