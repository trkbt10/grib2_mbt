#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPEC_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEFAULT_UPSTREAM_DIR="${SPEC_DIR}/_upstream/www.nco.ncep.noaa.gov/pmb/docs/grib2/grib2_doc"

UPSTREAM_DIR="${1:-${DEFAULT_UPSTREAM_DIR}}"
OUT_DIR="${2:-${SPEC_DIR}/markdown}"
PAGES_DIR="${OUT_DIR}/pages"
CATALOG_PATH="${OUT_DIR}/catalog.tsv"
INDEX_PATH="${OUT_DIR}/index.md"
TMP_DIR=""

require_tool() {
  local name="$1"
  if ! command -v "${name}" >/dev/null 2>&1; then
    echo "error: required tool not found: ${name}" >&2
    exit 1
  fi
}

normalize_stem() {
  local base
  base="$(basename "$1")"
  if [[ "${base}" == *.shtml.html ]]; then
    echo "${base%.shtml.html}"
    return
  fi
  if [[ "${base}" == *.html ]]; then
    echo "${base%.html}"
    return
  fi
  echo "${base}"
}

classify_page() {
  local stem="$1"
  if [[ "${stem}" == "index" ]]; then
    printf 'index\t-\t-\n'
    return
  fi
  if [[ "${stem}" =~ ^grib2_sect([0-9]+)$ ]]; then
    printf 'section\t%s\t-\n' "${BASH_REMATCH[1]}"
    return
  fi
  if [[ "${stem}" =~ ^grib2_table([0-9]+)-(.+)$ ]]; then
    printf 'table\t%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    return
  fi
  if [[ "${stem}" =~ ^grib2_temp([0-9]+)-(.+)$ ]]; then
    printf 'template\t%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    return
  fi
  if [[ "${stem}" =~ ^grib2_mdl_temp([0-9]+)-(.+)$ ]]; then
    printf 'template\t%s\tmdl-%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    return
  fi
  if [[ "${stem}" =~ ^grib2_idt([0-9]+)-(.+)$ ]]; then
    printf 'identification-template\t%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    return
  fi
  printf 'other\t-\t-\n'
}

extract_fragment_html() {
  local src="$1"
  local fragment_file="$2"
  local full_file="$3"

  htmlq '.content_centered' < "${src}" > "${fragment_file}" 2>/dev/null || true
  if [[ -s "${fragment_file}" ]]; then
    return
  fi
  htmlq 'body' < "${src}" > "${full_file}" 2>/dev/null || true
  if [[ -s "${full_file}" ]]; then
    cp "${full_file}" "${fragment_file}"
  fi
}

sanitize_fragment_html() {
  local src_html="$1"
  local out_html="$2"

  perl -0777 -pe '
    s/<!--.*?-->//sg;
    s#</?span\b[^>]*>##gi;
    s#</?center\b[^>]*>##gi;
    s/\s(?:style|align|valign|width|height|bgcolor|cellpadding|cellspacing|border|data-[\w-]+)="[^"]*"//gi;
    s#<br\s*/?>#<br />#gi;
  ' "${src_html}" > "${out_html}"
}

convert_one_page() {
  local src="$1"
  local out_md="$2"
  local tmp_dir="$3"
  local fragment_html="${tmp_dir}/fragment.html"
  local full_html="${tmp_dir}/full.html"
  local sanitized_html="${tmp_dir}/sanitized.html"
  local raw_md="${tmp_dir}/raw.md"

  : > "${fragment_html}"
  : > "${full_html}"
  extract_fragment_html "${src}" "${fragment_html}" "${full_html}"

  if [[ ! -s "${fragment_html}" ]]; then
    echo "warning: no extractable content in ${src}; skipping" >&2
    return 1
  fi

  sanitize_fragment_html "${fragment_html}" "${sanitized_html}"
  pandoc -f html -t gfm --wrap=none "${sanitized_html}" > "${raw_md}"

  sed -E \
    -e '/^<div class="content_centered">$/d' \
    -e '/^<\/div>$/d' \
    -e 's#<span[^>]*>##g' \
    -e 's#</span>##g' \
    -e 's#<center>##g' \
    -e 's#</center>##g' \
    -e 's/ (style|align|valign|width|height|bgcolor|cellpadding|cellspacing|border|data-[A-Za-z0-9_-]+)="[^"]*"//g' \
    -e 's/\.shtml\.html/\.md/g' \
    -e 's/\(index\.html/\(index.md/g' \
    -e 's/[[:space:]]+$//' \
    "${raw_md}" > "${out_md}"
}

write_index_kind_section() {
  local kind="$1"
  local catalog="$2"
  echo "## ${kind}"
  local has_rows="0"
  while IFS=$'\t' read -r stem row_kind section detail title source_file; do
    if [[ "${row_kind}" != "${kind}" ]]; then
      continue
    fi
    has_rows="1"
    echo "- [${stem}](pages/${stem}.md) | section=${section} | detail=${detail} | title=${title} | source=${source_file}"
  done < <(tail -n +2 "${catalog}")
  if [[ "${has_rows}" == "0" ]]; then
    echo "- (none)"
  fi
  echo
}

main() {
  require_tool pandoc
  require_tool htmlq
  require_tool sed
  require_tool awk

  if [[ ! -d "${UPSTREAM_DIR}" ]]; then
    echo "error: upstream directory not found: ${UPSTREAM_DIR}" >&2
    exit 1
  fi

  mkdir -p "${OUT_DIR}"
  rm -rf "${PAGES_DIR}"
  mkdir -p "${PAGES_DIR}"

  printf 'stem\tkind\tsection\tdetail\ttitle\tsource_file\n' > "${CATALOG_PATH}"

  local converted="0"
  TMP_DIR="$(mktemp -d)"
  trap 'if [[ -n "${TMP_DIR}" ]]; then rm -rf "${TMP_DIR}"; fi' EXIT

  while IFS= read -r src_file; do
    local stem out_md title kind section detail clean_title
    stem="$(normalize_stem "${src_file}")"
    out_md="${PAGES_DIR}/${stem}.md"

    if ! convert_one_page "${src_file}" "${out_md}" "${TMP_DIR}"; then
      continue
    fi

    title="$(htmlq -t title < "${src_file}" 2>/dev/null || true)"
    clean_title="$(printf '%s' "${title}" | tr '\n' ' ' | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//')"
    clean_title="${clean_title//$'\t'/ }"

    IFS=$'\t' read -r kind section detail <<< "$(classify_page "${stem}")"
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
      "${stem}" "${kind}" "${section}" "${detail}" "${clean_title}" "$(basename "${src_file}")" \
      >> "${CATALOG_PATH}"

    converted="$((converted + 1))"
  done < <(find "${UPSTREAM_DIR}" -maxdepth 1 -type f \( -name 'index.html' -o -name 'grib2_*.shtml.html' \) | sort)

  {
    echo "# GRIB2 Upstream Markdown Index"
    echo
    echo "- Generated at (UTC): $(date -u '+%Y-%m-%d %H:%M:%S')"
    echo "- Upstream source dir: \`${UPSTREAM_DIR}\`"
    echo "- Output dir: \`${OUT_DIR}\`"
    echo "- Converted pages: ${converted}"
    echo
    echo "## Catalog"
    echo
    echo "- TSV: \`catalog.tsv\`"
    echo "- Markdown pages: \`pages/*.md\`"
    echo
    write_index_kind_section "index" "${CATALOG_PATH}"
    write_index_kind_section "section" "${CATALOG_PATH}"
    write_index_kind_section "table" "${CATALOG_PATH}"
    write_index_kind_section "template" "${CATALOG_PATH}"
    write_index_kind_section "identification-template" "${CATALOG_PATH}"
    write_index_kind_section "other" "${CATALOG_PATH}"
  } > "${INDEX_PATH}"

  echo "done: converted ${converted} pages"
  echo "done: wrote ${CATALOG_PATH}"
  echo "done: wrote ${INDEX_PATH}"
}

main "$@"
