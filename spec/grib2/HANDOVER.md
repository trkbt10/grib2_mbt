# GRIB2 MBT Handover Notes

This file is the minimal context needed to continue work without drift.

## Current Point

- Latest checkpoint commit: `b65ffeb`
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
- Next target: start from Template 5.0 in checklist order.

## Read First

- `AGENTS.md`
- `spec/grib2/WORK_CHECKLIST.md`
- `spec/grib2/IMPLEMENTATION_CHECKLIST.md`
- `grib2_typed_sections.mbt`
- `grib2_typed_sections_test.mbt`

## Implementation Rules

- Keep roundtrip safety: `decode -> encode` must preserve data.
- Keep unknown/raw bytes (`reserved_tail`, unknown templates) intact.
- Do not depend on `wgrib2` in tests/CI. Use committed snapshots only.
- Follow checklist order to avoid planning drift.

## Per-Template Work Pattern (Section 4)

1. Add typed struct(s) in `grib2_typed_sections.mbt`.
2. Add decode function(s).
3. Add encode function(s).
4. Wire template number dispatch in Section 4 decode/encode.
5. Add roundtrip tests in `grib2_typed_sections_test.mbt`.
6. Update checklist progress.

## Multi-Agent Parallel Plan

- Use 1 coordinator + N workers.
- Split by non-overlapping template ranges (example):
  - Worker A: Section 5 templates (5.0-5.4)
  - Worker B: Section 5 templates (5.40-5.53, 5.61, 5.200)
  - Worker C: Section 7 typed templates
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
moon test grib2_typed_sections_test.mbt --target native --filter '*template411*'
moon test grib2_typed_sections_test.mbt --target wasm --filter '*template411*'
moon check --target native
moon check --target wasm
moon info --target native && moon fmt
```

When a larger chunk is done, run broader tests.

## Ready-To-Use Resume Prompt

```text
Continue grib2_mbt from commit b65ffeb.
Goal: keep implementing IMPLEMENTATION_CHECKLIST typed decode+encode from the first incomplete item.
Section 4 is done through 4.1101, so start at 5.0.
For each template:
- add struct/decode/encode/dispatch in grib2_typed_sections.mbt
- add roundtrip tests in grib2_typed_sections_test.mbt
- update spec/grib2/WORK_CHECKLIST.md and IMPLEMENTATION_CHECKLIST.md
Constraints:
- no runtime/test dependency on wgrib2
- preserve unknown/reserved bytes for roundtrip safety
- prefer focused tests during implementation, then run check/info/fmt
```
