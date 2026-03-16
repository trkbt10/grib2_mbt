#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: $0 <fixture.grib2> [record_range_like_1:19]" >&2
  exit 2
fi

FIXTURE="$1"
REC_RANGE="${2:-1:19}"
WGRIB2_BIN="${WGRIB2_BIN:-wgrib2}"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [[ ! -f "$FIXTURE" ]]; then
  echo "fixture not found: $FIXTURE" >&2
  exit 2
fi

if ! command -v "$WGRIB2_BIN" >/dev/null 2>&1; then
  echo "wgrib2 not found: $WGRIB2_BIN" >&2
  exit 2
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

W_STATS="$TMP_DIR/w_stats.txt"
M_STATS_RAW="$TMP_DIR/m_stats_raw.txt"
M_STATS="$TMP_DIR/m_stats.txt"

"$WGRIB2_BIN" "$FIXTURE" -stats > "$W_STATS"
moon run cmd/main -- "$FIXTURE" -stats > "$M_STATS_RAW" 2>/dev/null || true
rg '^[0-9]+:' "$M_STATS_RAW" > "$M_STATS" || true

echo "== stats compare: $FIXTURE =="
awk -F: '
  FNR==NR {
    rec=$1+0
    wline[rec]=$0
    for (i=1; i<=NF; i++) {
      if ($i ~ /^mean=/) wmean[rec]=substr($i,6)
      if ($i ~ /^cos_wt_mean=/) wcos[rec]=substr($i,13)
      if ($i ~ /^stats=error$/) werr[rec]=1
    }
    next
  }
  {
    rec=$1+0
    mline[rec]=$0
    for (i=1; i<=NF; i++) {
      if ($i ~ /^mean=/) mmean[rec]=substr($i,6)
      if ($i ~ /^cos_wt_mean=/) mcos[rec]=substr($i,13)
      if ($i ~ /^stats=error$/) merr[rec]=1
    }
  }
  END {
    split("'"$REC_RANGE"'", a, ":")
    s=a[1]+0
    e=a[2]+0
    printf("rec\twgrib2\tmoon\t|mean_diff|\t|cos_diff|\n")
    for (r=s; r<=e; r++) {
      ws = (r in werr) ? "error" : ((r in wmean) ? "ok" : "na")
      ms = (r in merr) ? "error" : ((r in mmean) ? "ok" : "na")
      cosd = "NA"
      if ((r in wcos) && (r in mcos)) {
        cd = (mcos[r]+0) - (wcos[r]+0)
        if (cd < 0) cd = -cd
        cosd = sprintf("%.9g", cd)
      }
      if ((r in wmean) && (r in mmean)) {
        d = (mmean[r]+0) - (wmean[r]+0)
        if (d < 0) d = -d
        printf("%d\t%s\t%s\t%.9g\t%s\n", r, ws, ms, d, cosd)
      } else {
        printf("%d\t%s\t%s\tNA\t%s\n", r, ws, ms, cosd)
      }
    }
  }
' "$W_STATS" "$M_STATS"

echo
echo "== -bin compare by record: $FIXTURE =="
s="${REC_RANGE%%:*}"
e="${REC_RANGE##*:}"
printf "rec\tcmp\tdiff_bytes(first cmp -l count)\n"
for ((r=s; r<=e; r++)); do
  W_BIN="$TMP_DIR/w_${r}.bin"
  M_BIN="$TMP_DIR/m_${r}.bin"
  "$WGRIB2_BIN" "$FIXTURE" -for_n "${r}:${r}" -bin "$W_BIN" >/dev/null 2>&1 || true
  moon run cmd/main -- "$FIXTURE" -for_n "${r}:${r}" -bin "$M_BIN" >/dev/null 2>&1 || true
  if [[ ! -f "$W_BIN" || ! -f "$M_BIN" ]]; then
    printf "%d\tERR\tNA\n" "$r"
    continue
  fi
  if cmp -s "$W_BIN" "$M_BIN"; then
    printf "%d\tOK\t0\n" "$r"
  else
    diff_count="$( (cmp -l "$W_BIN" "$M_BIN" || true) | wc -l | tr -d ' ' )"
    printf "%d\tNG\t%s\n" "$r" "$diff_count"
  fi
done
