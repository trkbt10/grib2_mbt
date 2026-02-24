# GRIB2 MoonBit Makefile

.PHONY: build build-wasm test smoke-test clean demo

# Default target
all: build-wasm smoke-test

# Build for native target
build:
	moon build

# Build WASM and copy to npm directories
build-wasm:
	./scripts/build-wasm.sh

# Run MoonBit tests
test:
	moon test

# Run WASM smoke test (checks exports)
smoke-test: build-wasm
	node ./scripts/smoke-test-wasm.mjs

# Clean build artifacts
clean:
	moon clean

# Start demo development server
demo: build-wasm
	cd npm/demo && npm run dev

# Format code
fmt:
	moon fmt

# Check without modifying
check:
	moon check

# Full CI pipeline
ci: build test smoke-test
	@echo "CI pipeline completed successfully"
