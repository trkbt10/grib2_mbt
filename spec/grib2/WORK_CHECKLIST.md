# GRIB2 Implementation Work Checklist

This checklist is the execution control board for the GRIB2 parser/reader/writer project.

## Rules

- Keep this file updated in every implementation PR.
- Only mark `[x]` when code + tests + docs are aligned.
- For compatibility checks, use committed snapshots only (no `wgrib2` in CI).

## Phase 0: Groundwork

- [x] NOAA GRIB2 docs mirrored under `spec/grib2/_upstream` (ignored in git)
- [x] HTML -> Markdown conversion tooling added (`spec/grib2/tools/build_markdown.sh`)
- [x] Generated implementation spec draft (`spec/grib2/GRIB2_IMPLEMENTATION_SPEC.md`)
- [x] Strategy doc for architecture/roundtrip/CLI/WASM (`spec/grib2/IMPLEMENTATION_STRATEGY.md`)
- [x] Fixture set prepared (`fixtures/grib2_jma`, `fixtures/grib2_noaa`)
- [x] `wgrib2` snapshot generator added (`tools/update_wgrib2_snapshots.sh`)
- [x] Snapshot fixtures committed (`fixtures/wgrib2_snapshots`)

## Phase 1: Core Parser Vertical Slice

- [x] Define raw model types: file/message/section/submessage context
- [x] Implement Section0 + section-frame scanner
- [x] Implement submessage grouping (Section2 optional, 3-7 required)
- [x] Add parse error model (EOF/magic/length/section-order)
- [x] Add raw-preserving writer (`parse -> rebuild` byte equality)
- [x] Add fixture-based parser tests (JMA + NOAA)

## Phase 2: Inventory/CLI Baseline

- [x] Add CLI option parser compatible with first target options
- [x] Implement baseline output path for `wgrib2 <file>` / `-s`
- [x] Implement baseline output path for `-Sec0`, `-Sec3`, `-Sec4`, `-var -lev`
- [x] Snapshot tests: compare CLI output to committed golden files
- [x] Ensure tests do not execute `wgrib2`

## Phase 3: Decode Expansion

- [x] Section 3 template dispatch foundation
- [x] Section 4 template dispatch foundation
- [x] Section 5 template dispatch foundation
- [x] Table lookup foundation (known/unknown split)
- [x] Context fields for var/lev/time extraction
- [x] CLI output parity improvements for all baseline options

## Phase 4: Writer/Editing

- [x] Editing API on context model
- [x] Strict writer mode with invariant checks
- [x] Unknown template raw-preserving behavior tests
- [x] Roundtrip regression suite for all fixtures

## Phase 5: WASM/JS Readiness

- [x] Core parser/writer package has no host I/O dependency
- [x] I/O adapter abstraction for native/js/wasm
- [x] Browser/JS integration sample
- [x] WASM target test pass

## Phase 6: Typed Section Codec (Start)

- [x] Section 1 typed decode/encode foundation
- [x] Section 3 typed decode/encode foundation (Template 3.0 + unknown raw)
- [x] Section 4 typed decode/encode foundation (Template 4.0 + unknown raw)
- [x] Expand typed templates from checklist order (3.x / 4.x / 5.x)
- [x] Start Section 7 typed decode/encode foundation (Template 7.0 + unknown raw)
- [x] Bridge typed section codec into strict writer path

## Current Focus

- [x] Phase 1 vertical slice completion
- [x] Phase 2 CLI baseline compatibility
- [x] Phase 3 decode expansion
- [x] Phase 4 writer/editing API
- [x] Phase 5 wasm/js readiness
- [ ] Phase 6 typed section expansion
