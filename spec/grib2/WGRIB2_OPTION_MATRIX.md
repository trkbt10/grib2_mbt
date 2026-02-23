# wgrib2 Option Matrix (v3.1.3)

This matrix tracks `wgrib2` CLI option compatibility in `grib2_mbt`.

## Source

- `wgrib2 -help all` from local binary (`v3.1.3`)
- Full extracted list: `spec/grib2/wgrib2_options_v3.1.3.tsv`

## Option Counts

- Total options listed by `wgrib2 -help all`: 390
- Category counts:
  - `inv`: 166
  - `inv>`: 6
  - `misc`: 98
  - `out`: 49
  - flow-control categories (`if`/`elif`/`else`/`endif`): 15
  - `init`: 56

## Implemented and Snapshot-Covered (Current)

All options below are compared with committed snapshots for all current fixtures.

| option | status | snapshot command name |
| --- | --- | --- |
| default (`wgrib2 <file>`) | implemented | `default` |
| `-s` | implemented | `s` |
| `-Sec0` | implemented | `Sec0` |
| `-Sec3` | implemented | `Sec3` |
| `-Sec4` | implemented | `Sec4` |
| `-Sec5` | implemented | `Sec5` |
| `-Sec6` | implemented | `Sec6` |
| `-Sec_len` | implemented | `Sec_len` |
| `-n` | implemented | `n` |
| `-range` | implemented | `range` |
| `-var` | implemented | `var` |
| `-lev` | implemented | `lev` |
| `-ftime` | implemented | `ftime` |
| `-grid` | implemented | `grid` |
| `-pdt` | implemented | `pdt` |
| `-process` | implemented | `process` |
| `-ens` | implemented | `ens` |
| `-prob` | implemented | `prob` |
| `-disc` | implemented | `disc` |
| `-center` | implemented | `center` |
| `-subcenter` | implemented | `subcenter` |
| `-packing` | implemented | `packing` |
| `-bitmap` | implemented | `bitmap` |
| `-nxny` | implemented | `nxny` |
| `-npts` | implemented | `npts` |
| `-var -lev` | implemented | `var_lev` |

## Planned Next Batch

- `-stats` (requires section7 data decode/unpack parity)
