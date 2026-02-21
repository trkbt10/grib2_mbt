#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPEC_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CATALOG_PATH="${1:-${SPEC_DIR}/markdown/catalog.tsv}"
OUT_PATH="${2:-${SPEC_DIR}/IMPLEMENTATION_CHECKLIST.md}"

if [[ ! -f "${CATALOG_PATH}" ]]; then
  echo "error: catalog not found: ${CATALOG_PATH}" >&2
  exit 1
fi

{
  echo "# GRIB2 Implementation Checklist"
  echo
  echo "- Source catalog: \`${CATALOG_PATH}\`"
  echo "- Generated at (UTC): $(date -u '+%Y-%m-%d %H:%M:%S')"
  echo "- Rule: check item when parser+writer roundtrip and regression tests are complete."
  echo

  echo "## Core Sections"
  for sec in 0 1 2 3 4 5 6 7 8; do
    stem="grib2_sect${sec}"
    title="$(awk -F'\t' -v s="${stem}" 'NR>1 && $1==s {print $5}' "${CATALOG_PATH}")"
    if [[ -n "${title}" ]]; then
      echo "- [ ] ${stem} | ${title}"
    else
      echo "- [ ] ${stem}"
    fi
  done
  echo

  echo "## Identification Templates (Section 1)"
  awk -F'\t' '
    NR>1 && $2=="identification-template" {
      printf "- [ ] %s | Template 1.%s | %s\n", $1, $4, $5
    }
  ' "${CATALOG_PATH}" | sort -V
  echo

  echo "## Local Use Templates (Section 2)"
  awk -F'\t' '
    NR>1 && $2=="template" && $3=="2" {
      printf "- [ ] %s | Template 2.%s | %s\n", $1, $4, $5
    }
  ' "${CATALOG_PATH}" | sort -V
  echo

  echo "## Grid Definition Templates (Section 3)"
  awk -F'\t' '
    NR>1 && $2=="template" && $3=="3" {
      printf "- [ ] %s | Template 3.%s | %s\n", $1, $4, $5
    }
  ' "${CATALOG_PATH}" | sort -V
  echo

  echo "## Product Definition Templates (Section 4)"
  awk -F'\t' '
    NR>1 && $2=="template" && $3=="4" {
      printf "- [ ] %s | Template 4.%s | %s\n", $1, $4, $5
    }
  ' "${CATALOG_PATH}" | sort -V
  echo

  echo "## Data Representation Templates (Section 5)"
  awk -F'\t' '
    NR>1 && $2=="template" && $3=="5" {
      printf "- [ ] %s | Template 5.%s | %s\n", $1, $4, $5
    }
  ' "${CATALOG_PATH}" | sort -V
  echo

  echo "## Data Templates (Section 7)"
  awk -F'\t' '
    NR>1 && $2=="template" && $3=="7" {
      printf "- [ ] %s | Template 7.%s | %s\n", $1, $4, $5
    }
  ' "${CATALOG_PATH}" | sort -V
  echo

  echo "## Code Tables"
  for sec in 0 1 3 4 5 6 7; do
    echo "### Section ${sec} related tables"
    awk -F'\t' -v sec="${sec}" '
      NR>1 && $2=="table" && $3==sec {
        printf "- [ ] %s | %s\n", $1, $5
      }
    ' "${CATALOG_PATH}" | sort -V
    echo
  done
} > "${OUT_PATH}"

echo "done: wrote ${OUT_PATH}"
