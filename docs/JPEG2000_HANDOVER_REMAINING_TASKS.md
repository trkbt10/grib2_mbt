# JPEG2000 Handover: Remaining Tasks (typed/section7)

This document summarizes what is already implemented in `typed/section7` and what remains to reach the requested "full JPEG2000 support" level.

## Scope

- Package: `typed/section7`
- Main files:
  - `typed/section7/grib2_jpeg2000_codestream.mbt`
  - `typed/section7/grib2_data_unpacker_jpeg2000.mbt`
  - `typed/section7/grib2_jpeg2000_tier1.mbt`
  - `typed/section7/grib2_jpeg2000_tier2.mbt`
  - `typed/section7/grib2_jpeg2000_dwt.mbt`

## Implemented So Far (high level)

- Packet progression orders + POC handling (LRCP/RLCP/RPCL/PCRL/CPRL).
- Multi-component decode path including MCT (RCT/ICT path selection).
- Tier-1 codeblock style handling for BYPASS/RESET/TERMALL/VCAUSAL/PTERM/SEGMARK in current decoder design.
- SOP/EPH parsing in packet headers.
- PPM/PPT/PLT/TLM parsing and stronger validation.
  - PPM/PPT reordering by `Zppm/Zppt` + duplicate/gap rejection.
  - PLT packet-length validation against packet consumption.
  - TLM lower-bound consistency checks in unpack path.
- RGN (ROI maxshift style=0) parsing and decode-side descaling path.
- JP2 signature + `jp2c` extraction flow with base validation.

## Remaining Tasks (priority)

1. Multi-tile full support (not just tile-part continuity)
- Ensure true multi-tile reconstruction and tile-wise header delta behavior are fully spec-compliant.
- Add tests where distinct tiles use different COD/COC/QCD/QCC/POC combinations.

2. Tier-1 full-spec corner coverage
- Validate full conformance of BYPASS/RESET/TERMALL/VCAUSAL/PTERM/SEGMARK for edge pass boundaries.
- Add stress vectors for mixed pass types, termination boundaries, and malformed segment transitions.

3. Tier-2 packet-header full transition coverage
- Exhaustively cover inclusion/lblock/pass-length state transitions, including deep tag-tree and multi-layer corner cases.
- Add malformed-header robustness tests for all transition branches.

4. DWT bit-exact parity against reference decoders
- Improve 5/3 and 9/7 boundary behavior verification to reference parity targets.
- Add more boundary-heavy fixtures (odd sizes, asymmetric dimensions, high decomposition levels).

5. Bit depth / signedness / guard bits finalization
- Expand high-bit-depth (>8-bit) and signed/unsigned coverage with guard-bit-sensitive fixtures.
- Validate no regression in scaling to GRIB values for mixed quantization styles.

6. ROI/RGN completion
- Current implementation supports `RGN style=0` path only.
- Complete remaining ROI cases and strengthen tests with realistic ROI-heavy codestream fixtures.

7. JP2 container strict validation completion
- Extend beyond signature+`jp2c` extraction to stronger box-level consistency checks.

8. Auxiliary marker completion (full robustness)
- SOP/EPH/PPM/PPT/PLT/TLM are partially-to-mostly handled; finish remaining strict checks for spec-level completeness.

9. Error resilience hardening
- Add fuzz-like malformed codestream suites for safe-failure guarantees and strict boundary checks.

10. Reference decoder bit-exact verification harness (critical)
- Build automated diff framework against OpenJPEG/ecCodes outputs.
- Add CI-friendly fixtures and expected-diff policy.

## Suggested Execution Order

1. Build reference diff harness first (Task 10).
2. Close multi-tile + Tier-2 transition gaps (Tasks 1, 3).
3. Finish Tier-1 edge conformance + ROI completion (Tasks 2, 6).
4. Tighten DWT parity + bit-depth/guard-bit coverage (Tasks 4, 5).
5. Finalize JP2 strictness + resilience hardening (Tasks 7, 8, 9).

## Minimum Verification Checklist per PR

- `moon test typed/section7/grib2_jpeg2000_codestream.mbt`
- `moon test typed/section7/grib2_data_unpacker_jpeg2000.mbt`
- `moon test typed/section7`
- `moon info && moon fmt`

