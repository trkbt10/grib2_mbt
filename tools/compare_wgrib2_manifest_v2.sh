#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

WGRIB2_BIN="${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2}"
MBT_CMD="${MBT_CMD:-moon run cmd/main --target native --}"
MANIFEST="${MANIFEST:-fixtures/wgrib2_snapshots/manifest_v2.tsv}"
TMP_DIR="${TMP_DIR:-$(mktemp -d)}"
KEEP_TMP="${KEEP_TMP:-0}"

if [[ ! -x "${WGRIB2_BIN}" ]]; then
  echo "error: wgrib2 not found or not executable: ${WGRIB2_BIN}" >&2
  exit 1
fi
if [[ ! -f "${MANIFEST}" ]]; then
  echo "error: manifest not found: ${MANIFEST}" >&2
  exit 1
fi

if [[ "${KEEP_TMP}" != "1" ]]; then
  trap 'rm -rf "${TMP_DIR}"' EXIT
fi

render_cmd() {
  local tmpl="$1"
  local fixture="$2"
  local out="$3"
  local tmp="$4"
  local cmd="${tmpl}"
  cmd="${cmd//\{WGRIB2\}/${WGRIB2_BIN}}"
  cmd="${cmd//\{MBT\}/${MBT_CMD}}"
  cmd="${cmd//\{fixture\}/${fixture}}"
  cmd="${cmd//\{out\}/${out}}"
  cmd="${cmd//\{tmp\}/${tmp}}"
  printf '%s' "${cmd}"
}

normalize_stats() {
  local src="$1"
  local out="$2"
  awk -F':' '
    function field_value(prefix,   i,a) {
      for (i = 1; i <= NF; i++) {
        if (index($i, prefix) == 1) {
          split($i, a, "=")
          return a[2]
        }
      }
      return ""
    }
    {
      ndata = field_value("ndata=")
      undef = field_value("undef=")
      meanv = field_value("mean=")
      minv = field_value("min=")
      maxv = field_value("max=")
      cosv = field_value("cos_wt_mean=")
      if (ndata != "" && undef != "" && meanv != "" && minv != "" && maxv != "") {
        if (cosv != "") {
          printf "%s\t%s\t%.15g\t%.15g\t%.15g\t%.15g\n", ndata, undef, meanv + 0, minv + 0, maxv + 0, cosv + 0
        } else {
          printf "%s\t%s\t%.15g\t%.15g\t%.15g\n", ndata, undef, meanv + 0, minv + 0, maxv + 0
        }
      }
    }
  ' "${src}" > "${out}"
}

compare_stats_files() {
  local w_txt="$1"
  local m_txt="$2"
  local tmp_dir="$3"
  local norm_w="${tmp_dir}/w.stats.norm"
  local norm_m="${tmp_dir}/m.stats.norm"
  local eps_abs="${STATS_EPS_ABS:-1e-4}"
  local eps_rel="${STATS_EPS_REL:-1e-7}"

  normalize_stats "${w_txt}" "${norm_w}"
  normalize_stats "${m_txt}" "${norm_m}"

  if [[ "$(wc -l < "${norm_w}")" != "$(wc -l < "${norm_m}")" ]]; then
    return 1
  fi

  paste "${norm_w}" "${norm_m}" | awk -F'\t' -v eps_abs="${eps_abs}" -v eps_rel="${eps_rel}" '
    function abs(x) { return x < 0 ? -x : x }
    function almost_eq(a, b, tol_abs, tol_rel,   scale, tol) {
      scale = abs(a)
      if (abs(b) > scale) scale = abs(b)
      if (scale < 1) scale = 1
      tol = tol_abs + tol_rel * scale
      return abs(a - b) <= tol
    }
    {
      if (NF == 10) {
        if ($1 != $6 || $2 != $7) exit 1
        if (!almost_eq($3 + 0, $8 + 0, eps_abs, eps_rel)) exit 1
        if (!almost_eq($4 + 0, $9 + 0, eps_abs, eps_rel)) exit 1
        if (!almost_eq($5 + 0, $10 + 0, eps_abs, eps_rel)) exit 1
      } else if (NF == 12) {
        if ($1 != $7 || $2 != $8) exit 1
        if (!almost_eq($3 + 0, $9 + 0, eps_abs, eps_rel)) exit 1
        if (!almost_eq($4 + 0, $10 + 0, eps_abs, eps_rel)) exit 1
        if (!almost_eq($5 + 0, $11 + 0, eps_abs, eps_rel)) exit 1
        if (!almost_eq($6 + 0, $12 + 0, eps_abs, eps_rel)) exit 1
      } else {
        exit 1
      }
    }
    END { exit 0 }
  '
}

run_case() {
  local case_id="$1"
  local fixture_path="$2"
  local prep="$3"
  local wcmd_t="$4"
  local mcmd_t="$5"
  local mode="$6"
  local case_dir="${TMP_DIR}/${case_id}"
  mkdir -p "${case_dir}"

  local out_w="${case_dir}/w.bin"
  local out_m="${case_dir}/m.bin"
  local txt_w="${case_dir}/w.txt"
  local txt_m="${case_dir}/m.txt"

  if [[ -n "${prep}" ]]; then
    local prep_cmd
    prep_cmd="$(render_cmd "${prep}" "${fixture_path}" "${out_w}" "${case_dir}")"
    bash -lc "${prep_cmd}" > /dev/null
  fi

  local wcmd
  local mcmd
  wcmd="$(render_cmd "${wcmd_t}" "${fixture_path}" "${out_w}" "${case_dir}")"
  mcmd="$(render_cmd "${mcmd_t}" "${fixture_path}" "${out_m}" "${case_dir}")"

  case "${mode}" in
    text_diff|stats_diff|sec5_diff)
      bash -lc "${wcmd}" > "${txt_w}"
      bash -lc "${mcmd}" > "${txt_m}"
      if [[ "${mode}" == "stats_diff" ]]; then
        compare_stats_files "${txt_w}" "${txt_m}" "${case_dir}"
      else
        diff -u "${txt_w}" "${txt_m}" > "${case_dir}/diff.txt"
      fi
      ;;
    binary_cmp)
      rm -f "${out_w}" "${out_m}"
      bash -lc "${wcmd}" > /dev/null
      bash -lc "${mcmd}" > /dev/null
      cmp -s "${out_w}" "${out_m}"
      ;;
    *)
      echo "error: unknown compare_mode: ${mode} (case=${case_id})" >&2
      return 2
      ;;
  esac
}

ok=0
ng=0

while IFS= read -r line; do
  case_id="$(printf '%s' "${line}" | cut -f1)"
  fixture_id="$(printf '%s' "${line}" | cut -f2)"
  fixture_path="$(printf '%s' "${line}" | cut -f3)"
  prep="$(printf '%s' "${line}" | cut -f4)"
  wgrib2_cmd="$(printf '%s' "${line}" | cut -f5)"
  mbt_cmd="$(printf '%s' "${line}" | cut -f6)"
  compare_mode="$(printf '%s' "${line}" | cut -f7)"
  expected_ref="$(printf '%s' "${line}" | cut -f8)"
  if run_case "${case_id}" "${fixture_path}" "${prep}" "${wgrib2_cmd}" "${mbt_cmd}" "${compare_mode}"; then
    echo "OK ${case_id}"
    ok=$((ok + 1))
  else
    echo "NG ${case_id} (mode=${compare_mode})"
    ng=$((ng + 1))
  fi
done < <(tail -n +2 "${MANIFEST}")

echo "SUMMARY OK=${ok} NG=${ng} TMP=${TMP_DIR}"
if [[ "${ng}" -ne 0 ]]; then
  exit 1
fi
