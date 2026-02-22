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
- [ ] Expand typed templates from checklist order (3.x / 4.x) (in progress: 3.1-3.23, 3.30, 3.31, 3.33, 3.40-3.43, 3.50-3.53, 3.60-3.63, 3.90, 3.100-3.101, 3.110, 3.120, 3.140, 3.150, 3.204, 3.1000, 3.1100, 3.1200, 3.32768-3.32769, 4.1-4.15, 4.20, 4.30, 4.31, 4.32, 4.33, 4.34, 4.35, 4.40, 4.41, 4.42, 4.43, 4.44, 4.45, 4.46, 4.47, 4.48, 4.49, 4.50, 4.51, 4.53, 4.54, 4.55, 4.56, 4.57, 4.58, 4.59, 4.60, 4.61, 4.62, 4.63, 4.67, 4.68, 4.70, 4.71, 4.72, 4.73, 4.76, 4.77, 4.78, 4.79, 4.80, 4.81, 4.82, 4.83, 4.84, 4.85, 4.86, 4.87, 4.88, 4.89, 4.90, 4.91, 4.92, 4.93, 4.94, 4.95, 4.96, 4.97, 4.98, 4.99, 4.100, 4.101, 4.102, 4.103, 4.104, 4.105, 4.106, 4.107, 4.108, 4.109, 4.110, 4.111, 4.112, 4.113, 4.114, 4.115, 4.116, 4.117, 4.118, 4.119, 4.120, 4.121, 4.122, 4.123, 4.124, 4.125, 4.126, 4.127, 4.128, 4.129, 4.130, 4.131, 4.132, 4.133, 4.134, 4.135, 4.136, 4.137, 4.138, 4.139, 4.140, 4.141, 4.142, 4.143, 4.144, 4.145, 4.146, 4.147, 4.148, 4.149, 4.150, 4.151, 4.152, 4.153, 4.154, 4.155, 4.254, 4.1000, 4.1001, 4.1002, 4.1100, 4.1101)
- [x] Bridge typed section codec into strict writer path

## Current Focus

- [x] Phase 1 vertical slice completion
- [x] Phase 2 CLI baseline compatibility
- [x] Phase 3 decode expansion
- [x] Phase 4 writer/editing API
- [x] Phase 5 wasm/js readiness
- [ ] Phase 6 typed section expansion
