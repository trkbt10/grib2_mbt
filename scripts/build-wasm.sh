#!/bin/bash
set -euo pipefail

# GRIB2 WASM Build Script
# Builds MoonBit to WASM-GC and copies to npm directories

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Building WASM-GC (release)..."
cd "$PROJECT_ROOT"
moon build --target wasm-gc --release

# Source and destinations
WASM_SRC="$PROJECT_ROOT/_build/wasm-gc/release/build/grib2_mbt.wasm"
NPM_DEST="$PROJECT_ROOT/npm/grib2.wasm"
DEMO_DEST="$PROJECT_ROOT/npm/demo/public/grib2.wasm"

# Check if source exists
if [[ ! -f "$WASM_SRC" ]]; then
  echo "Error: WASM file not found at $WASM_SRC"
  exit 1
fi

# Create directories if needed
mkdir -p "$PROJECT_ROOT/npm"
mkdir -p "$PROJECT_ROOT/npm/demo/public"

# Copy WASM files
cp "$WASM_SRC" "$NPM_DEST"
cp "$WASM_SRC" "$DEMO_DEST"

# Regenerate TypeScript declarations for WASM exports.
node "$PROJECT_ROOT/scripts/generate-wasm-dts.mjs"

echo "Copied WASM to:"
echo "  - $NPM_DEST"
echo "  - $DEMO_DEST"

# Show file sizes
echo ""
echo "WASM file size: $(ls -lh "$NPM_DEST" | awk '{print $5}')"

echo ""
echo "Build complete!"
