#!/usr/bin/env bash
set -euo pipefail

lock_dir="${MOON_SERIAL_LOCK_DIR:-.moon-serial.lock}"
wait_seconds="${MOON_SERIAL_WAIT_SECONDS:-0.2}"

while ! mkdir "${lock_dir}" 2>/dev/null; do
  sleep "${wait_seconds}"
done

cleanup() {
  rmdir "${lock_dir}" 2>/dev/null || true
}

trap cleanup EXIT INT TERM

moon "$@"
