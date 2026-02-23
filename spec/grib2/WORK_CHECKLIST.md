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
- [x] Expand inventory output path for `-Sec5`, `-Sec6`, `-Sec_len`, `-n`, `-range`, `-var`, `-lev`, `-ftime`, `-grid`, `-pdt`, `-process`, `-ens`, `-prob`, `-disc`, `-center`, `-subcenter`, `-packing`, `-bitmap`, `-nxny`, `-npts`
- [x] Snapshot tests: compare CLI output to committed golden files
- [x] Ensure tests do not execute `wgrib2`

## Phase 3: Decode Expansion

- [x] Section 3 template dispatch foundation
- [x] Section 4 template dispatch foundation
- [x] Section 5 template dispatch foundation
- [x] Table lookup foundation (known/unknown split)
- [x] Code Table 0.0 discipline decode (known/unknown split)
- [x] Code Table 1.0 master table version decode (known/unknown split)
- [x] Code Tables 1.1-1.6 Section1 decode helpers (known/unknown split)
- [x] Code Table 3.0 grid definition source decode (known/unknown split)
- [x] Code Table 3.1 grid definition template decode (known/unknown split)
- [x] Code Table 3.2 reference system shape decode (known/unknown split)
- [x] Code Tables 3.3-3.4 flag decoding helpers (resolution/scanning mode)
- [x] Code Tables 3.5-3.11 Section3 helpers (projection/spectral/diamond/list)
- [x] Code Table 4.0 product definition template decode (known/unknown split)
- [x] Code Table 4.1 parameter category by discipline decode (known/unknown split)
- [x] Code Table 4.2 parameter number decode foundation (known/unknown split)
- [x] Table 4.2-0-0 temperature parameter decode (known/unknown split)
- [x] Table 4.2-0-1 moisture parameter decode (known/unknown split)
- [x] Table 4.2-0-2 momentum parameter decode (known/unknown split)
- [x] Table 4.2-0-3 mass parameter decode (known/unknown split)
- [x] Table 4.2-0-4 shortwave radiation parameter decode (known/unknown split)
- [x] Table 4.2-0-5 longwave radiation parameter decode (known/unknown split)
- [x] Table 4.2-0-6 cloud parameter decode (known/unknown split)
- [x] Table 4.2-0-7 thermodynamic stability parameter decode (known/unknown split)
- [x] Table 4.2-0-13 aerosol parameter decode (known/unknown split)
- [x] Table 4.2-0-14 trace gases parameter decode (known/unknown split)
- [x] Table 4.2-0-15 radar parameter decode (known/unknown split)
- [x] Table 4.2-0-16 forecast radar imagery parameter decode (known/unknown split)
- [x] Table 4.2-0-17 electrodynamics parameter decode (known/unknown split)
- [x] Table 4.2-0-18 nuclear/radiology parameter decode (known/unknown split)
- [x] Table 4.2-0-19 physical atmospheric properties parameter decode (known/unknown split)
- [x] Table 4.2-0-190 meteorological ASCII parameter decode (known/unknown split)
- [x] Table 4.2-0-191 miscellaneous parameter decode (known/unknown split)
- [x] Table 4.2-0-192 covariance parameter decode (known/unknown split)
- [x] Table 4.2-1-0 hydrology basic parameter decode (known/unknown split)
- [x] Table 4.2-1-1 hydrology probabilities parameter decode (known/unknown split)
- [x] Table 4.2-1-2 inland water and sediment properties parameter decode (known/unknown split)
- [x] Table 4.2-2-0 vegetation/biomass parameter decode (known/unknown split)
- [x] Table 4.2-2-1 agricultural special products parameter decode (known/unknown split)
- [x] Table 4.2-2-3 soil parameter decode (known/unknown split)
- [x] Table 4.2-2-4 fire weather parameter decode (known/unknown split)
- [x] Table 4.2-2-5 glaciers and inland ice parameter decode (known/unknown split)
- [x] Table 4.2-2-6 urban areas parameter decode (known/unknown split)
- [x] Table 4.2-2-7 thermodynamic properties parameter decode (known/unknown split)
- [x] Table 4.2-3-0 image format parameter decode (known/unknown split)
- [x] Table 4.2-3-1 quantitative parameter decode (known/unknown split)
- [x] Table 4.2-3-2 cloud properties parameter decode (known/unknown split)
- [x] Table 4.2-3-3 flight rules conditions parameter decode (known/unknown split)
- [x] Table 4.2-3-4 volcanic ash parameter decode (known/unknown split)
- [x] Table 4.2-3-5 sea surface temperature parameter decode (known/unknown split)
- [x] Table 4.2-3-6 solar radiation parameter decode (known/unknown split)
- [x] Table 4.2-3-192 forecast satellite imagery parameter decode (known/unknown split)
- [x] Table 4.2-4-0 space weather temperature parameter decode (known/unknown split)
- [x] Table 4.2-4-1 space weather momentum parameter decode (known/unknown split)
- [x] Table 4.2-4-2 space weather charged particle parameter decode (known/unknown split)
- [x] Table 4.2-4-3 space weather electric/magnetic fields parameter decode (known/unknown split)
- [x] Table 4.2-4-4 space weather energetic particles parameter decode (known/unknown split)
- [x] Table 4.2-4-5 space weather waves parameter decode (known/unknown split)
- [x] Table 4.2-4-6 space weather solar electromagnetic emissions parameter decode (known/unknown split)
- [x] Table 4.2-4-7 space weather terrestrial electromagnetic emissions parameter decode (known/unknown split)
- [x] Table 4.2-4-8 space weather imagery parameter decode (known/unknown split)
- [x] Table 4.2-4-9 space weather ion-neutral coupling parameter decode (known/unknown split)
- [x] Table 4.2-4-10 space weather indices parameter decode (known/unknown split)
- [x] Table 4.2-10-0 oceanographic waves parameter decode (known/unknown split)
- [x] Table 4.2-10-1 oceanographic currents parameter decode (known/unknown split)
- [x] Table 4.2-10-2 oceanographic ice parameter decode (known/unknown split)
- [x] Table 4.2-10-3 oceanographic surface properties parameter decode (known/unknown split)
- [x] Table 4.2-10-4 oceanographic subsurface properties parameter decode (known/unknown split)
- [x] Table 4.2-10-191 oceanographic miscellaneous parameter decode (known/unknown split)
- [x] Table 4.2-20-0 health and socioeconomic impacts health indicators parameter decode (known/unknown split)
- [x] Table 4.2-20-1 health and socioeconomic impacts epidemiology parameter decode (known/unknown split)
- [x] Table 4.2-20-2 health and socioeconomic impacts socioeconomic indicators parameter decode (known/unknown split)
- [x] Table 4.2-20-3 renewable energy sector parameter decode (known/unknown split)
- [x] Table 4.2-20-4 meteorological and hydrological hazard indices parameter decode (known/unknown split)
- [x] Table 4.2-20-5 environmental hazard indices parameter decode (known/unknown split)
- [x] Table 4.2-191-0 computational parameters stochastic parameterizations parameter decode (known/unknown split)
- [x] Code Table 4.3 type of generating process decode (known/unknown split)
- [x] Code Table 4.4 indicator of unit of time range decode (known/unknown split)
- [x] Code Table 4.5 fixed surface types and units decode (known/unknown split)
- [x] Code Table 4.6 type of ensemble forecast decode (known/unknown split)
- [x] Code Table 4.7 derived forecast decode (known/unknown split)
- [x] Code Table 4.8 clustering method decode (known/unknown split)
- [x] Code Table 4.9 probability type decode (known/unknown split)
- [x] Code Table 4.10 type of statistical processing decode (known/unknown split)
- [x] Code Table 4.11 type of time intervals decode (known/unknown split)
- [x] Code Table 4.12 operating mode decode (known/unknown split)
- [x] Code Table 4.13 quality control indicator decode (known/unknown split)
- [x] Code Table 4.14 clutter filter indicator decode (known/unknown split)
- [x] Code Table 4.15 type of spatial processing decode (known/unknown split)
- [x] Code Table 4.16 quality value associated with parameter decode (known/unknown split)
- [x] Code Table 4.91 type of interval decode (known/unknown split)
- [x] Code Table 4.100 type of reference dataset decode (known/unknown split)
- [x] Code Table 4.101 type of relationship to reference dataset decode (known/unknown split)
- [x] Code Table 4.102 statistical processing of reference period decode (known/unknown split)
- [x] Code Table 4.103 spatial vicinity type decode (known/unknown split)
- [x] Code Table 4.104 spatial and temporal vicinity processing decode (known/unknown split)
- [x] Code Table 4.105 spatial and temporal vicinity missing data decode (known/unknown split)
- [x] Code Table 4.106 radar data quality flags decode (known/unknown split)
- [x] Code Table 4.120 verification scores decode (known/unknown split)
- [x] Code Table 4.121 type of reference dataset for verification decode (known/unknown split)
- [x] Code Table 4.122 type of additional arguments for verification score decode (known/unknown split)
- [x] Code Table 4.201 precipitation type decode (known/unknown split)
- [x] Code Table 4.202 precipitable water category decode (known/unknown split)
- [x] Code Table 4.203 cloud type decode (known/unknown split)
- [x] Code Table 4.204 thunderstorm coverage decode (known/unknown split)
- [x] Code Table 4.205 presence of aerosol decode (known/unknown split)
- [x] Code Table 4.206 volcanic ash decode (known/unknown split)
- [x] Code Table 4.207 icing decode (known/unknown split)
- [x] Code Table 4.208 turbulence decode (known/unknown split)
- [x] Code Table 4.209 planetary boundary-layer regime decode (known/unknown split)
- [x] Code Table 4.210 contrail intensity decode (known/unknown split)
- [x] Code Table 4.211 contrail engine type decode (known/unknown split)
- [x] Code Table 4.212 land use decode (known/unknown split)
- [x] Code Table 4.213 soil type decode (known/unknown split)
- [x] Code Table 4.214 environmental factor qualifier decode (known/unknown split)
- [x] Code Table 4.215 remotely-sensed snow coverage decode (known/unknown split)
- [x] Code Table 4.216 elevation of snow covered terrain decode (known/unknown split)
- [x] Code Table 4.217 cloud mask type decode (known/unknown split)
- [x] Code Table 4.218 pixel scene type decode (known/unknown split)
- [x] Code Table 4.219 cloud top height quality indicator decode (known/unknown split)
- [x] Code Table 4.220 horizontal dimension processed decode (known/unknown split)
- [x] Code Table 4.221 treatment of missing data decode (known/unknown split)
- [x] Code Table 4.222 categorical result decode (known/unknown split)
- [x] Code Table 4.223 fire detection indicator decode (known/unknown split)
- [x] Code Table 4.224 categorical outlook decode (known/unknown split)
- [x] Code Table 4.225 weather decode (known/unknown split)
- [x] Code Table 4.227 icing scenario decode (known/unknown split)
- [x] Code Table 4.228 icing severity decode (known/unknown split)
- [x] Code Table 4.230 atmospheric chemical or physical constituent type decode (known/unknown split)
- [x] Code Table 4.233 aerosol type decode (known/unknown split)
- [x] Code Table 4.234 canopy cover fraction decode (known/unknown split)
- [x] Code Table 4.236 soil texture fraction decode (known/unknown split)
- [x] Code Table 4.238 source or sink decode (known/unknown split)
- [x] Code Table 4.239 wetland type decode (known/unknown split)
- [x] Code Table 4.240 type of distribution function decode (known/unknown split)
- [x] Code Table 4.241 coverage attributes decode (known/unknown split)
- [x] Code Table 4.242 tile classification decode (known/unknown split)
- [x] Code Table 4.243 tile class decode (known/unknown split)
- [x] Code Table 4.244 quality indicator decode (known/unknown split)
- [x] Code Table 4.246 thunderstorm intensity index decode (known/unknown split)
- [x] Code Table 4.247 precipitation intensity decode (known/unknown split)
- [x] Code Table 4.248 method to derive data value for local time decode (known/unknown split)
- [x] Code Table 4.249 character of precipitation decode (known/unknown split)
- [x] Code Table 4.250 drainage direction decode (known/unknown split)
- [x] Code Table 4.251 wave direction and frequency formulae decode (known/unknown split)
- [x] Code Table 4.252 tile classes and groupings decode (known/unknown split)
- [x] Code Table 4.253 hazard index decode (known/unknown split)
- [x] Code Table 4.333 transport dispersion model decode (known/unknown split)
- [x] Code Table 4.335 emission scenario origin decode (known/unknown split)
- [x] Code Table 4.336 NWP model decode (known/unknown split)
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
- [x] Start Section 6 typed decode/encode foundation (bitmap indicator + raw bitmap)
- [x] Start Section 2 typed decode/encode foundation (Template 2.1 + unknown raw)
- [x] Bridge typed section codec into strict writer path
- [x] Add explicit Section0/Section8 invariant coverage in parser + strict writer tests

## Current Focus

- [x] Phase 1 vertical slice completion
- [x] Phase 2 CLI baseline compatibility
- [x] Phase 3 decode expansion
- [x] Phase 4 writer/editing API
- [x] Phase 5 wasm/js readiness
- [ ] Phase 6 typed section expansion
