#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 2 ]]; then
  echo "usage: $0 <fixture.grib2> <record_number>" >&2
  exit 2
fi

FIXTURE="$1"
REC="$2"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WGRIB2_BIN="${WGRIB2_BIN:-wgrib2}"
OPJ_DECOMPRESS_BIN="${OPJ_DECOMPRESS_BIN:-opj_decompress}"

if [[ ! -f "$FIXTURE" ]]; then
  echo "fixture not found: $FIXTURE" >&2
  exit 2
fi
if ! command -v "$WGRIB2_BIN" >/dev/null 2>&1; then
  echo "wgrib2 not found: $WGRIB2_BIN" >&2
  exit 2
fi
if ! command -v "$OPJ_DECOMPRESS_BIN" >/dev/null 2>&1; then
  echo "opj_decompress not found: $OPJ_DECOMPRESS_BIN" >&2
  exit 2
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found" >&2
  exit 2
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

SEC5_WRAP="$TMP_DIR/sec5_wrapped.bin"
SEC6_WRAP="$TMP_DIR/sec6_wrapped.bin"
SEC7_WRAP="$TMP_DIR/sec7_wrapped.bin"
J2K="$TMP_DIR/rec.j2k"
W_BIN="$TMP_DIR/w.bin"
M_BIN="$TMP_DIR/m.bin"

moon run cmd/main -- "$FIXTURE" -for_n "${REC}:${REC}" -write_sec 5 "$SEC5_WRAP" >/dev/null
moon run cmd/main -- "$FIXTURE" -for_n "${REC}:${REC}" -write_sec 6 "$SEC6_WRAP" >/dev/null
moon run cmd/main -- "$FIXTURE" -for_n "${REC}:${REC}" -write_sec 7 "$SEC7_WRAP" >/dev/null
moon run cmd/main -- "$FIXTURE" -for_n "${REC}:${REC}" -bin "$M_BIN" >/dev/null
"$WGRIB2_BIN" "$FIXTURE" -for_n "${REC}:${REC}" -bin "$W_BIN" >/dev/null 2>&1

SIZE="$(stat -f%z "$SEC7_WRAP")"
DATA_SIZE=$((SIZE - 13))
dd if="$SEC7_WRAP" of="$J2K" bs=1 skip=9 count="$DATA_SIZE" status=none

"$OPJ_DECOMPRESS_BIN" -i "$J2K" -o "$TMP_DIR/rec.pgx" >/dev/null 2>&1

python3 - <<'PY' "$TMP_DIR" "$REC"
import pathlib
import statistics
import struct
import sys

tmp = pathlib.Path(sys.argv[1])
rec = int(sys.argv[2])

def read_fortran_f32(path: pathlib.Path, be: bool) -> list[float]:
    b = path.read_bytes()
    if len(b) < 8:
        return []
    n = struct.unpack("<I", b[:4])[0]
    payload = b[4:4+n]
    fmt = ">f" if be else "<f"
    return [struct.unpack(fmt, payload[i:i+4])[0] for i in range(0, len(payload), 4)]

def read_pgx(path: pathlib.Path) -> list[int]:
    b = path.read_bytes()
    nl = b.index(b"\n")
    hdr = b[:nl].decode("ascii").split()
    # PG <endian> <sign><prec> width height
    endian = hdr[1]
    sign = hdr[2][0]
    raw = b[nl+1:]
    usable = (len(raw) // 2) * 2
    fmt = (">" if endian == "ML" else "<") + ("h" if sign == "-" else "H")
    return [struct.unpack(fmt, raw[i:i+2])[0] for i in range(0, usable, 2)]

def grib_signmag_u16(v: int) -> int:
    v &= 0xFFFF
    return -(v & 0x7FFF) if (v & 0x8000) else (v & 0x7FFF)

def read_sec5_params(path: pathlib.Path):
    b = path.read_bytes()
    if len(b) < 8:
        raise RuntimeError("sec5 wrapper too short")
    n = struct.unpack("<I", b[:4])[0]
    sec = b[4:4+n]
    if len(sec) < 23:
        raise RuntimeError("sec5 section too short")
    payload = sec[11:]  # template 5.x payload
    ref = struct.unpack(">f", payload[0:4])[0]
    e = grib_signmag_u16(struct.unpack(">H", payload[4:6])[0])
    d = grib_signmag_u16(struct.unpack(">H", payload[6:8])[0])
    bits = payload[8]
    return ref, e, d, bits

def unwrap_section(path: pathlib.Path) -> bytes:
    b = path.read_bytes()
    if len(b) < 8:
        return b""
    n = struct.unpack("<I", b[:4])[0]
    return b[4:4+n]

def expand_by_bitmap(sec6: bytes, defined_vals: list[float]) -> list[float]:
    if len(sec6) < 6:
        return defined_vals
    # section header: len(4), secnum(1), indicator(1), bitmap...
    indicator = sec6[5]
    if indicator == 255:
        return defined_vals
    if indicator != 0:
        return defined_vals
    bitmap = sec6[6:]
    miss = 9.999e20
    out = []
    src = 0
    for by in bitmap:
        for bit in range(7, -1, -1):
            defined = (by >> bit) & 1
            if defined:
                if src < len(defined_vals):
                    out.append(defined_vals[src])
                    src += 1
                else:
                    out.append(miss)
            else:
                out.append(miss)
    return out

def finite_values(xs):
    miss = 9.999e20
    out = []
    for v in xs:
        if v != v:
            continue
        if abs(v) > miss * 0.9:
            continue
        out.append(v)
    return out

pgx_files = sorted(tmp.glob("rec*.pgx"))
if not pgx_files:
    raise SystemExit("no PGX output found")
opj_int = read_pgx(pgx_files[0])
ref, e, d, bits = read_sec5_params(tmp / "sec5_wrapped.bin")
sec6 = unwrap_section(tmp / "sec6_wrapped.bin")
w = read_fortran_f32(tmp / "w.bin", be=False)
m = read_fortran_f32(tmp / "m.bin", be=False)

binary_scale = 2.0 ** e
decimal_scale = 10.0 ** d
opj_scaled = [((ref + v * binary_scale) / decimal_scale) for v in opj_int]
opj_full = expand_by_bitmap(sec6, opj_scaled)
opj_finite = finite_values(opj_scaled)
w_finite = finite_values(w)
m_finite = finite_values(m)

def stat_line(name, xs):
    if not xs:
        return f"{name}: n=0"
    return (
        f"{name}: n={len(xs)} mean={statistics.fmean(xs):.9g} "
        f"min={min(xs):.9g} max={max(xs):.9g}"
    )

print(f"record={rec}")
print(f"sec5: ref={ref:.9g} E={e} D={d} bits={bits}")
print(stat_line("openjpeg(sec5-scaled)", opj_finite))
print(stat_line("wgrib2-bin", w_finite))
print(stat_line("moon-bin", m_finite))
print(f"lens openjpeg_full={len(opj_full)} w={len(w)} moon={len(m)}")

full_n = min(len(opj_full), len(w), len(m))
if full_n > 0:
    miss = 9.999e20
    idx = [
        i for i in range(full_n)
        if abs(opj_full[i]) < miss * 0.9
        and abs(w[i]) < miss * 0.9
        and abs(m[i]) < miss * 0.9
    ]
    if idx:
        opj_w_full = statistics.fmean(abs(opj_full[i] - w[i]) for i in idx)
        opj_m_full = statistics.fmean(abs(opj_full[i] - m[i]) for i in idx)
        w_m_full = statistics.fmean(abs(w[i] - m[i]) for i in idx)
        print(f"aligned_finite_points={len(idx)}")
        print(f"aligned_mean_abs_diff openjpeg-wgrib2={opj_w_full:.9g}")
        print(f"aligned_mean_abs_diff openjpeg-moon={opj_m_full:.9g}")
        print(f"aligned_mean_abs_diff wgrib2-moon={w_m_full:.9g}")

common = min(len(opj_scaled), len(w), len(m))
if common > 0:
    # wgrib2 -bin generally outputs only defined points.
    # moon -bin is bitmap-expanded in this implementation; compare using
    # finite-only stream to align defined-point sequence.
    opj_defined = opj_finite
    w_defined = w_finite
    m_defined = m_finite
    n_ow = min(len(opj_defined), len(w_defined))
    n_om = min(len(opj_defined), len(m_defined))
    n_wm = min(len(w_defined), len(m_defined))
    if n_ow > 0 and n_om > 0 and n_wm > 0:
        opj_w = statistics.fmean(
            abs(opj_defined[i] - w_defined[i]) for i in range(n_ow)
        )
        opj_m = statistics.fmean(
            abs(opj_defined[i] - m_defined[i]) for i in range(n_om)
        )
        w_m = statistics.fmean(
            abs(w_defined[i] - m_defined[i]) for i in range(n_wm)
        )
        print(f"common_defined_points ow={n_ow} om={n_om} wm={n_wm}")
        print(f"mean_abs_diff openjpeg-wgrib2={opj_w:.9g}")
        print(f"mean_abs_diff openjpeg-moon={opj_m:.9g}")
        print(f"mean_abs_diff wgrib2-moon={w_m:.9g}")
        sow = min(n_ow, 20000)
        som = min(n_om, 20000)
        swm = min(n_wm, 20000)
        opj_w_sorted = statistics.fmean(
            abs(a - b)
            for a, b in zip(sorted(opj_defined[:sow]), sorted(w_defined[:sow]))
        )
        opj_m_sorted = statistics.fmean(
            abs(a - b)
            for a, b in zip(sorted(opj_defined[:som]), sorted(m_defined[:som]))
        )
        w_m_sorted = statistics.fmean(
            abs(a - b)
            for a, b in zip(sorted(w_defined[:swm]), sorted(m_defined[:swm]))
        )
        print(f"sorted_mean_abs_diff openjpeg-wgrib2={opj_w_sorted:.9g}")
        print(f"sorted_mean_abs_diff openjpeg-moon={opj_m_sorted:.9g}")
        print(f"sorted_mean_abs_diff wgrib2-moon={w_m_sorted:.9g}")
PY
