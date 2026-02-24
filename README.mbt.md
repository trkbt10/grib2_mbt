# grib2_mbt

A wgrib2-compatible GRIB2 toolkit written in [MoonBit](https://www.moonbitlang.com/), providing both a feature-rich CLI and a WebAssembly library for JavaScript/TypeScript.

## Highlights

- **140+ wgrib2-compatible CLI options** for inventory, metadata, and data extraction
- **Pure WebAssembly** - runs natively in browsers and Node.js without C dependencies
- **Complete JPEG2000 decoder** - self-contained DWT + Tier-1/Tier-2 implementation (no external libs)
- **40+ grid templates** and **200+ product definition templates** supported
- **Correct sign-magnitude handling** for GRIB2 scale factors (a common source of bugs)

## Installation

### npm (JavaScript/TypeScript)

```bash
npm install @trkbt10/grib2-wasm
```

### Build from Source

```bash
moon build                    # Native CLI
./scripts/build-wasm.sh       # WebAssembly module
```

---

## CLI Usage

```bash
grib2_mbt <file.grib2> [options...]
```

### Inventory & Metadata

```bash
# Standard inventory (wgrib2 -s compatible)
grib2_mbt forecast.grib2 -s
# 1:0:d=2024120600:TMP:2 m above ground:anl:

# Extended inventory with timestamps
grib2_mbt forecast.grib2 -S
# 1:0:D=20241206000000:TMP:2 m above ground:anl:

# Variable and level information
grib2_mbt forecast.grib2 -var -lev
# 1:0:TMP:2 m above ground

# Full parameter name format
grib2_mbt forecast.grib2 -full_name
# 1:0:TMP.2 m above ground

# Reference and verification times
grib2_mbt forecast.grib2 -t -vt -ftime
# 1:0:d=2024120600:vt=2024120612:12 hour fcst

# Unix timestamps
grib2_mbt forecast.grib2 -unix_time
# 1:0:unix_rt=1733443200:unix_vt=1733486400
```

### Grid Information

```bash
# Grid description
grib2_mbt forecast.grib2 -grid
# 1:0:grid_template=0:winds(N/S):
#     lat-lon grid:(505 x 481) units 1e-06 input WE:SN output WE:SN res 48
#     lat 22.400000 to 47.600000 by 0.052632
#     lon 120.000000 to 150.105263 by 0.062500

# Grid dimensions
grib2_mbt forecast.grib2 -nxny -npts
# 1:0:(505 x 481):npts=242905

# Domain bounds
grib2_mbt forecast.grib2 -domain
# 1:0:N=47.600000:S=22.400000:W=120.000000:E=150.105263

# Grid definition template details
grib2_mbt forecast.grib2 -gdt
```

### Data Statistics & Values

```bash
# Statistics
grib2_mbt forecast.grib2 -stats
# 1:0:ndata=242905:undef=0:mean=277.815:min=241.010:max=303.310

# Min/max values
grib2_mbt forecast.grib2 -min -max
# 1:0:min=241.010:max=303.310

# Value at specific coordinates
grib2_mbt forecast.grib2 -lon 139.7 35.7
# 1:0:lon=139.687500,lat=35.684211,val=285.110

# Value at grid indices
grib2_mbt forecast.grib2 -ij 250 240
# 1:0:(250,240),val=283.450

# Coordinate conversion
grib2_mbt forecast.grib2 -ll2ij 139.7 35.7
# 1:0:lon=139.700000,lat=35.700000 -> (315,252)
```

### Section Details

```bash
# Section summaries
grib2_mbt forecast.grib2 -Sec0   # Indicator section
grib2_mbt forecast.grib2 -Sec3   # Grid definition
grib2_mbt forecast.grib2 -Sec4   # Product definition
grib2_mbt forecast.grib2 -Sec5   # Data representation
grib2_mbt forecast.grib2 -Sec6   # Bitmap

# Section lengths
grib2_mbt forecast.grib2 -Sec_len

# Hex dump of section
grib2_mbt forecast.grib2 -0xSec 4

# Raw byte access
grib2_mbt forecast.grib2 -get_byte 4 10 8
grib2_mbt forecast.grib2 -get_hex 4 10 8
grib2_mbt forecast.grib2 -get_int 5 12 4
```

### Code Tables

```bash
# Discipline
grib2_mbt forecast.grib2 -code_table_0.0
# 1:0:code table 0.0=0 Meteorological products

# Parameter info
grib2_mbt forecast.grib2 -code_table_4.1 -code_table_4.2
# 1:0:code table 4.1=0 Temperature:code table 4.2=0 Temperature

# Grid template
grib2_mbt forecast.grib2 -code_table_3.1
# 1:0:code table 3.1=0 Latitude/longitude

# Data representation
grib2_mbt forecast.grib2 -code_table_5.0
# 1:0:code table 5.0=0 Grid point data - simple packing

# Surface types
grib2_mbt forecast.grib2 -code_table_4.5a -code_table_4.5b
```

### Output Options

```bash
# Write GRIB2 subset
grib2_mbt forecast.grib2 -grib output.grib2

# Binary data (native float32)
grib2_mbt forecast.grib2 -bin output.bin

# Text output
grib2_mbt forecast.grib2 -text output.txt

# CSV format
grib2_mbt forecast.grib2 -csv output.csv

# Spreadsheet format
grib2_mbt forecast.grib2 -spread output.tsv
```

### GrADS / pywgrib2 Integration

```bash
# GrADS control file inventory
grib2_mbt forecast.grib2 -ctl_inv

# pywgrib2 metadata format
grib2_mbt forecast.grib2 -pyinv

# Ensemble info for GrADS
grib2_mbt forecast.grib2 -ctl_ens
```

### All Options

Run `grib2_mbt --help` for the full list of 140+ options including:

| Category | Options |
|----------|---------|
| **Inventory** | `-s`, `-S`, `-inv`, `-print`, `-misc`, `-Match_inv` |
| **Variables** | `-var`, `-lev`, `-full_name`, `-ext_name`, `-lev0` |
| **Time** | `-t`, `-T`, `-vt`, `-VT`, `-ftime`, `-unix_time`, `-verf` |
| **Grid** | `-grid`, `-gdt`, `-nxny`, `-npts`, `-domain`, `-cyclic` |
| **Data** | `-stats`, `-min`, `-max`, `-ij`, `-lon`, `-ll2ij` |
| **Sections** | `-Sec0`..`-Sec6`, `-Sec_len`, `-0xSec`, `-checksum` |
| **Code Tables** | `-code_table_X.Y` (40+ variants) |
| **Flags** | `-flag_table_3.3`..`-flag_table_3.10`, `-scan` |
| **Output** | `-grib`, `-bin`, `-text`, `-csv`, `-spread` |
| **Ensemble** | `-ens`, `-prob`, `-N_ens`, `-cluster` |
| **Packing** | `-packing`, `-bitmap`, `-scale`, `-precision` |

---

## JavaScript / TypeScript API

### Initialization

```typescript
import {
  init,
  initBrowser,
  parseGrib2,
  getRecordCount,
  getSection1,
  getSection3,
  getSection4,
  getSection5,
  getGridData,
  getLatitudes,
  getLongitudes
} from '@trkbt10/grib2-wasm';

// Node.js
await init();

// Browser
await initBrowser('/path/to/grib2.wasm');
```

### Parsing Files

```typescript
// Parse GRIB2 data
const response = await fetch('/forecast.grib2');
const buffer = await response.arrayBuffer();
const handle = parseGrib2(new Uint8Array(buffer));

// Get counts
const recordCount = getRecordCount(handle);    // Total records
const messageCount = getMessageCount(handle);  // GRIB messages
```

### Metadata Access

```typescript
// Section 1: Identification (per message, 0-indexed)
const s1 = getSection1(handle, 0);
console.log(s1.center);           // Originating center
console.log(s1.year, s1.month, s1.day, s1.hour);  // Reference time

// Section 3: Grid Definition (per record, 1-indexed)
const s3 = getSection3(handle, 1);
console.log(s3.template);         // Grid template number
console.log(s3.ni, s3.nj);        // Grid dimensions
console.log(s3.lat1Microdeg);     // First latitude (microdegrees)

// Section 4: Product Definition (per record, 1-indexed)
const s4 = getSection4(handle, 1);
console.log(s4.parameterCategory, s4.parameterNumber);  // Variable
console.log(s4.forecastTime);     // Forecast hour
console.log(s4.typeOfFirstFixedSurface);  // Level type

// Section 5: Data Representation (per record, 1-indexed)
const s5 = getSection5(handle, 1);
console.log(s5.template);         // Packing method
console.log(s5.bitsPerValue);     // Precision
```

### Data Extraction

```typescript
// Get decoded grid values (Float32Array)
const values = getGridData(handle, 1);
console.log(`Grid points: ${values.length}`);
console.log(`Range: ${Math.min(...values)} to ${Math.max(...values)}`);

// Get coordinates (Float32Array, degrees)
const lats = getLatitudes(handle, 1);
const lons = getLongitudes(handle, 1);

// Combine for visualization
for (let i = 0; i < values.length; i++) {
  if (!Number.isNaN(values[i])) {
    plotPoint(lons[i], lats[i], values[i]);
  }
}
```

### TypeScript Types

```typescript
interface Section1Data {
  center: number;
  subcenter: number;
  masterTableVersion: number;
  localTableVersion: number;
  significanceOfRefTime: number;
  year: number;
  month: number;
  day: number;
  hour: number;
  minute: number;
  second: number;
  productionStatus: number;
  typeOfData: number;
}

interface Section3Data {
  template: number;
  gridDefinitionSource: number;
  numberOfPoints: number;
  ni?: number;
  nj?: number;
  lat1Microdeg?: number;
  lon1Microdeg?: number;
  lat2Microdeg?: number;
  lon2Microdeg?: number;
  diMicrodeg?: number;
  djMicrodeg?: number;
  scanMode?: number;
  resolutionFlags?: number;
}

interface Section4Data {
  template: number;
  parameterCategory?: number;
  parameterNumber?: number;
  typeOfGeneratingProcess?: number;
  indicatorOfUnitOfTimeRange?: number;
  forecastTime?: number;
  typeOfFirstFixedSurface?: number;
  scaleFactorOfFirstFixedSurface?: number;
  scaledValueOfFirstFixedSurface?: number;
  // ... additional fields for ensemble, probability templates
}

interface Section5Data {
  template: number;
  numberOfPoints: number;
  referenceValue?: number;
  binaryScaleFactor?: number;
  decimalScaleFactor?: number;
  bitsPerValue?: number;
}
```

---

## Supported GRIB2 Features

### Grid Definition Templates (Section 3)

| Template | Description |
|----------|-------------|
| 0 | Latitude/Longitude |
| 1 | Rotated Latitude/Longitude |
| 2 | Stretched Latitude/Longitude |
| 3 | Rotated and Stretched Lat/Lon |
| 10 | Mercator |
| 20 | Polar Stereographic |
| 30 | Lambert Conformal |
| 40 | Gaussian Latitude/Longitude |
| 41-43 | Rotated/Stretched Gaussian |
| 50-53 | Spherical Harmonics |
| 90 | Space View Perspective |
| 100-101 | Triangular Grid (Icosahedral) |
| 110 | Equatorial Azimuthal Equidistant |

### Data Representation Templates (Section 5)

| Template | Description | Status |
|----------|-------------|--------|
| 0 | Simple Packing | Full |
| 2 | Complex Packing | Full |
| 3 | Complex Packing + Spatial Differencing | Full |
| 4 | IEEE Floating Point | Full |
| 40 | JPEG2000 | Full (native decoder) |
| 41 | PNG | Supported |
| 50-55 | Spectral Data | Defined |
| 61 | Simple + Logarithm | Defined |
| 200 | Run Length | Defined |

### Product Definition Templates (Section 4)

200+ templates supported including:

- **0-15**: Basic analysis/forecast
- **40-49**: Analysis products
- **60-67**: Ensemble products
- **70-79**: Derived ensemble products
- **80-89**: Probability products
- **100-129**: Percentile/quantile products
- **1000+**: JMA local extensions

---

## Tested Data Sources

| Source | Format | Status |
|--------|--------|--------|
| JMA MSM | Simple/Complex Packing | Verified |
| JMA GSM | Simple/Complex Packing | Verified |
| NCEP GFS | Multiple packing types | Verified |
| NCEP HRRR | JPEG2000 | Verified |
| ECMWF | JPEG2000, PNG | Verified |
| Reduced Gaussian | Complex grids | Verified |

---

## Building & Testing

```bash
# Build native CLI
moon build

# Build WebAssembly
./scripts/build-wasm.sh

# Run unit tests
moon test

# Run WASM smoke test
node scripts/smoke-test-wasm.mjs

# Run E2E tests (demo app)
cd npm/demo && npx playwright test

# Start demo server
make demo
```

---

## Project Structure

```
grib2_mbt/
├── cmd/main/              # CLI implementation (140+ options)
├── typed/                 # Type-safe section decoders
│   ├── section1/          # Identification
│   ├── section3/          # Grid definition (40+ templates)
│   ├── section4/          # Product definition (200+ templates)
│   ├── section5/          # Data representation
│   ├── section6/          # Bitmap
│   └── section7/          # Data + JPEG2000 decoder
├── npm/                   # JavaScript package
│   ├── index.js           # WASM wrapper
│   ├── index.d.ts         # TypeScript definitions
│   └── demo/              # Browser demo app
├── fixtures/              # Test GRIB2 files
├── grib2_decode.mbt       # Main decoder orchestration
├── grib2_inventory.mbt    # 179 inventory functions
├── grib2_wasm_exports.mbt # WASM API layer
└── scripts/               # Build tooling
```

---

## License

Apache-2.0

## Related Projects

- [wgrib2](https://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/) - NOAA reference implementation
- [eccodes](https://github.com/ecmwf/eccodes) - ECMWF GRIB/BUFR library
- [MoonBit](https://www.moonbitlang.com/) - The language this project is built with
