# GRIB2 Spec Workspace

This directory contains helper tooling to convert downloaded NOAA GRIB2 HTML pages into local Markdown documents for spec writing.

## Directory Layout

- `_upstream/`: mirrored source files downloaded via `wget --mirror`
- `tools/build_markdown.sh`: HTML -> Markdown conversion script
- `tools/build_implementation_checklist.sh`: catalog -> implementation checklist generator
- `GRIB2_IMPLEMENTATION_SPEC.md`: parser/reader/writer implementation specification
- `IMPLEMENTATION_STRATEGY.md`: architecture strategy for roundtrip, wgrib2-compatible CLI, and WASM constraints
- `WORK_CHECKLIST.md`: living checklist to track implementation progress and prevent plan drift
- `IMPLEMENTATION_CHECKLIST.md`: generated checklist for full coverage tracking
- `JS_WASM_INTEGRATION_SAMPLE.md`: callback-based I/O adapter usage sample for Node/browser/WASM
- `markdown/`: generated Markdown pages and catalog (created by script)

## Requirements

- `pandoc`
- `htmlq`

## Usage

Run from repository root:

```bash
bash spec/grib2/tools/build_markdown.sh
bash spec/grib2/tools/build_implementation_checklist.sh
```

Optional arguments:

```bash
bash spec/grib2/tools/build_markdown.sh <upstream_dir> <out_dir>
```

Defaults:

- `upstream_dir`: `spec/grib2/_upstream/www.nco.ncep.noaa.gov/pmb/docs/grib2/grib2_doc`
- `out_dir`: `spec/grib2/markdown`

## Generated Outputs

- `spec/grib2/markdown/pages/*.md`: converted page-level Markdown
- `spec/grib2/markdown/catalog.tsv`: page catalog with type and numbering metadata
- `spec/grib2/markdown/index.md`: human-readable index for navigation
- `spec/grib2/IMPLEMENTATION_CHECKLIST.md`: implementation checklist from catalog

## Notes

- The converter extracts `.content_centered` first (for `index.html` style pages), then falls back to full `body` for classic GRIB table/template pages.
- Decorative HTML (`span/style/center` etc.) is stripped before Markdown conversion to improve readability.
- Internal links like `*.shtml.html` are normalized to `*.md` for local navigation.
