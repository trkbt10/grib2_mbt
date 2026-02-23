# GRIB2 データデコード技術ノート

## 1. Simple Packing (Template 5.0) のスケール係数

### 問題

GRIB2 の Simple Packing では、以下の式でデータを復元する：

```
Y = R + (X × 2^E) / 10^D
```

- Y: 復元値
- R: reference_value (IEEE 754 単精度浮動小数点)
- X: パック済み整数値
- E: binary_scale_factor (符号付き 16 ビット)
- D: decimal_scale_factor (符号付き 16 ビット)

### 重要: 符号表現は Sign-Magnitude

**GRIB2 のスケール係数は Two's Complement ではなく Sign-Magnitude 表現を使用する。**

```
┌─────────┬─────────────────┐
│ Bit 15  │ Bits 14-0       │
│ (符号)  │ (絶対値)        │
├─────────┼─────────────────┤
│ 0       │ 正の値          │
│ 1       │ 負の値          │
└─────────┴─────────────────┘
```

例:
- `0x0005` (5) → +5
- `0x8005` (32773) → -5 (Sign-Magnitude)
- `0x8005` を Two's Complement として解釈すると -32763 となり **誤り**

### 実装 (MoonBit)

```moonbit
/// Convert GRIB2 scale factor to signed integer.
/// GRIB2 uses sign-magnitude encoding (NOT two's complement).
pub fn u16_to_i16(raw : Int) -> Int {
  let v = raw & 0xFFFF
  let sign_bit = v & 0x8000
  let magnitude = v & 0x7FFF
  if sign_bit != 0 {
    -magnitude
  } else {
    magnitude
  }
}
```

### 症状と診断

**症状**: 全グリッド値が同一（reference_value と同じ）になる

**原因**: `binary_scale_factor = 0x8005` を Two's Complement として解釈すると `-32763`。
`2^(-32763) ≈ 0` となり、全値が `R + 0 = R` になる。

**診断方法**:
1. Section 5 の生バイトをダンプ
2. binary_scale_factor の raw 値を確認
3. MSB が 1 の場合、Sign-Magnitude として解釈されているか確認

---

## 2. グリッドデータの座標系と Canvas 描画

### GRIB2 のデータ配列順序

GRIB2 Template 3.0 (Latitude/Longitude) では:

- `lat1`, `lon1`: 最初のグリッド点の座標
- `lat2`, `lon2`: 最後のグリッド点の座標
- データ配列: `j=0` から `j=nj-1` の順（スキャンモードによる）

**JMA MSM/GSM の場合**:
- `lat1 = 47.6°N` (北)、`lat2 = 22.4°N` (南)
- データは **北から南** に格納される
- `j=0` が最北端、`j=nj-1` が最南端

### Canvas 座標系

HTML Canvas の座標系:
- `y=0` が **上端**
- `y=height-1` が下端

### 正しいマッピング

GRIB2 と Canvas は同じ方向（上が北）なので、**Y 軸の反転は不要**:

```typescript
// 正しい実装（反転なし）
for (let j = 0; j < nj; j++) {
  for (let i = 0; i < ni; i++) {
    const srcIdx = j * ni + i;
    const dstIdx = (j * ni + i) * 4;  // Canvas も同じ順序
    // ...
  }
}
```

### 誤りパターン

```typescript
// 誤り: 不要な Y 反転
const dstIdx = ((nj - 1 - j) * ni + i) * 4;
```

これを行うと、北海道が下、沖縄が上に表示される。

### 検証方法

500hPa 気温データで検証:
- 高緯度（北）は低温（例: 231K）
- 低緯度（南）は高温（例: 268K）

```typescript
// 行平均を計算
const firstRowAvg = values.slice(0, ni).reduce(...);      // j=0
const lastRowAvg = values.slice((nj-1)*ni).reduce(...);   // j=nj-1

// j=0 が寒ければ、j=0 は北（正しい）
console.log(firstRowAvg < lastRowAvg ? 'j=0 is NORTH' : 'j=0 is SOUTH');
```

---

## 3. IEEE 754 単精度浮動小数点の変換

GRIB2 の reference_value は IEEE 754 単精度 (32-bit) で格納される。

### ビットレイアウト

```
┌───────┬──────────┬─────────────────────────┐
│ Sign  │ Exponent │ Mantissa                │
│ 1 bit │ 8 bits   │ 23 bits                 │
└───────┴──────────┴─────────────────────────┘
```

### 実装

```moonbit
pub fn ieee754_single_to_double(bits : Int) -> Double {
  let sign = (bits >> 31) & 1
  let exponent = (bits >> 23) & 0xFF
  let mantissa = bits & 0x7FFFFF

  if exponent == 0 && mantissa == 0 {
    // Zero
    if sign == 1 { -0.0 } else { 0.0 }
  } else if exponent == 0xFF {
    // Infinity or NaN
    if mantissa == 0 {
      if sign == 1 { -1.0/0.0 } else { 1.0/0.0 }
    } else {
      0.0 / 0.0  // NaN
    }
  } else if exponent == 0 {
    // Denormalized
    let frac = mantissa.to_double() / 8388608.0
    let value = frac * pow2(-126)
    if sign == 1 { -value } else { value }
  } else {
    // Normalized
    let frac = 1.0 + mantissa.to_double() / 8388608.0
    let value = frac * pow2(exponent - 127)
    if sign == 1 { -value } else { value }
  }
}
```

---

## 4. ビットストリームリーダー

Simple Packing では、各値が `bits_per_value` ビットでパックされる（例: 12 ビット）。

### 実装のポイント

- **Big-endian** ビット順序
- バイト境界をまたぐ読み取りに対応
- 符号なし整数として読み取り、後でスケーリング

```moonbit
pub fn BitReader::read_bits(self : BitReader, count : Int) -> UInt {
  let mut result = 0U
  let mut remaining = count
  while remaining > 0 {
    let byte_index = self.bit_position / 8
    let bit_offset = self.bit_position % 8
    let bits_in_byte = 8 - bit_offset
    let bits_to_read = min(remaining, bits_in_byte)
    let mask = (1 << bits_to_read) - 1
    let byte_val = self.data[byte_index].to_int()
    let shift = bits_in_byte - bits_to_read
    let bits = (byte_val >> shift) & mask
    result = (result << bits_to_read) | bits
    self.bit_position += bits_to_read
    remaining -= bits_to_read
  }
  result
}
```

---

## 5. JMA MSM/GSM グリッド仕様

### MSM (メソスケールモデル)

- 領域: 日本域
- 格子数: 241 × 253
- 解像度: 約 5km (0.0625° × 0.05°)
- 座標範囲: 22.4°N - 47.6°N, 120°E - 150°E

### GSM (全球モデル)

- 領域: 全球
- 格子数: 720 × 361
- 解像度: 0.5° × 0.5°
- 座標範囲: 90°S - 90°N, 0°E - 359.5°E

---

## 参考資料

- [WMO GRIB2 Manual](https://library.wmo.int/doc_num.php?explnum_id=10722)
- [NCEP GRIB2 Documentation](https://www.nco.ncep.noaa.gov/pmb/docs/grib2/grib2_doc/)
- `spec/grib2/markdown/pages/grib2_sect5.md` - Section 5 Template 定義
