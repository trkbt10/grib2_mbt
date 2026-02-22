///|
// This file is intentionally kept as a thin index.
// Typed section codec implementation is purpose-split in subpackages:
// - typed/reexports.mbt (facade package)
// - typed/section1/* (Section1 model + shared binary helpers + Section1 tests)
// - typed/section3/* (Section3 model/decode/encode/dispatch + tests)
// - typed/section4/* (Section4 model/decode/encode/dispatch + tests)
// Root package keeps context-bridge wrappers:
// - grib2_typed_sections_bridge.mbt
