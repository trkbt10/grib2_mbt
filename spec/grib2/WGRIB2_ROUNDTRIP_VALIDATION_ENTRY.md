# wgrib2 互換 CLI ラウンドトリップ検証 - タスクエントリ

## 目的

`grib2_mbt` の wgrib2 互換 CLI について、オプションごとに出力一致とroundtrip安全性を検証する。

---

## 修了条件

| 条件 | 検証方法 |
|------|----------|
| CLI 出力一致 | `wgrib2 <file> -<option>` と `grib2_mbt <file> -<option>` の diff が 0 行 |
| Roundtrip 成功 | `parse -> rebuild_raw -> バイト一致` かつ `parse -> rebuild_strict -> バイト一致` |

---

## 検証手順（1オプションあたり）

### Step 1: CLI 出力比較

```bash
# wgrib2 出力
/opt/homebrew/bin/wgrib2 fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2 -Sec0 > /tmp/wgrib2.txt

# grib2_mbt 出力
moon run cmd/main -- fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2 -Sec0 2>&1 | grep -v "^Warning\|^─\|│\|╭\|╰" > /tmp/mbt.txt

# 比較
diff /tmp/wgrib2.txt /tmp/mbt.txt && echo "MATCH" || echo "DIFF"
```

### Step 2: Roundtrip テスト

軽量ファイル(642KB)で実行:

```bash
moon test tests/native/grib2_single_roundtrip_test.mbt --target native
```

テストコード (`tests/native/grib2_single_roundtrip_test.mbt`):
```moonbit
test "single file roundtrip: gfswave small" {
  let path = "fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2"
  match verify_roundtrip(path) {
    Ok(_) => inspect("ok", content="ok")
    Err(error) => fail(error)
  }
}
```

---

## 対象オプション

`WGRIB2_OPTION_MATRIX.md` で管理。現時点の対象:

| オプション | CLI出力 | Roundtrip |
|------------|---------|-----------|
| default | [x] | [x] |
| `-s` | [x] | [x] |
| `-Sec0` | [x] | [x] |
| `-Sec3` | [x] | [x] |
| `-Sec4` | [x] | [x] |
| `-Sec5` | [x] | [x] |
| `-Sec6` | [x] | [x] |
| `-Sec_len` | [x] | [x] |
| `-n` | [x] | [x] |
| `-range` | [x] | [x] |
| `-var` | [x] | [x] |
| `-lev` | [x] | [x] |
| `-ftime` | [x] | [x] |
| `-grid` | [x] | [x] |
| `-pdt` | [x] | [x] |
| `-process` | [x] | [x] |
| `-ens` | [x] | [x] |
| `-prob` | [x] | [x] |
| `-disc` | [x] | [x] |
| `-center` | [x] | [x] |
| `-subcenter` | [x] | [x] |
| `-packing` | [x] | [x] |
| `-bitmap` | [x] | [x] |
| `-nxny` | [x] | [x] |
| `-npts` | [x] | [x] |

---

## 未実装オプション (142個)

wgrib2 inv カテゴリ 166個のうち、24個が実装済み。残り142個の内訳:

### 優先度 高 - 時刻系 (15個)

基本的なインベントリ機能として需要が高い。

| オプション | 説明 | 状態 |
|------------|------|------|
| `-t` | reference time YYYYMMDDHH | [x] |
| `-T` | reference time YYYYMMDDHHMMSS | [x] |
| `-vt` | verf time (YYYYMMDDHH) | [x] |
| `-VT` | verf time (YYYYMMDDHHMMSS) | [x] |
| `-start_ft` | forecast start time | [ ] |
| `-start_FT` | forecast start time (full) | [ ] |
| `-end_ft` | forecast end time | [ ] |
| `-end_FT` | forecast end time (full) | [ ] |
| `-MM` | reference time MM | [x] |
| `-YY` | reference time YYYY | [x] |
| `-RT` | type of reference Time | [ ] |
| `-S` | simple inventory with minutes/seconds | [ ] |
| `-unix_time` | print unix timestamp | [ ] |
| `-verf` | inventory using verification time | [ ] |
| `-Match_inv` | match inventory with D=YYYYMMDDHHmmss | [ ] |

### 優先度 中 - code_table系 (49個)

コードテーブル値の詳細表示。IMPLEMENTATION_CHECKLIST.md の Code Tables 実装と連動。

| カテゴリ | 数 | 例 |
|----------|----|----|
| Section 0 | 1 | `-code_table_0.0` |
| Section 1 | 7 | `-code_table_1.0` ~ `-code_table_1.6` |
| Section 3 | 10 | `-code_table_3.0`, `-code_table_3.1` など |
| Section 4 | 25 | `-code_table_4.0` ~ `-code_table_4.242` |
| Section 5 | 6 | `-code_table_5.0` ~ `-code_table_5.7` |

### 優先度 中 - flag_table系 (5個)

| オプション | 説明 | 状態 |
|------------|------|------|
| `-flag_table_3.3` | resolution and component flags | [ ] |
| `-flag_table_3.4` | scanning mode | [ ] |
| `-flag_table_3.5` | projection center | [ ] |
| `-flag_table_3.9` | numbering order of diamonds | [ ] |
| `-flag_table_3.10` | scanning mode for one diamond | [ ] |

### 優先度 低 - データアクセス系 (8個)

Section 7 のデータデコードが必要。

| オプション | 説明 | 状態 |
|------------|------|------|
| `-max` | print maximum value | [ ] |
| `-min` | print minimum value | [ ] |
| `-stats` | statistical summary | [ ] |
| `-ij` | value at grid(X,Y) | [ ] |
| `-ijlat` | lat,lon,value at grid(X,Y) | [ ] |
| `-ilat` | lat,lon,value at Xth grid point | [ ] |
| `-lon` | value at nearest lon/lat | [ ] |
| `-nlons` | number of longitudes per latitude | [ ] |

### 優先度 低 - JMA専用 (3個)

| オプション | 説明 | 状態 |
|------------|------|------|
| `-JMA` | inventory for JMA locally defined PDT | [ ] |
| `-JMA_Nb` | value of JMA Nb | [ ] |
| `-JMA_Nr` | value of JMA Nr | [ ] |

### 優先度 低 - その他 (62個)

特殊用途、GrADS互換、低レベルアクセスなど。

---

## 関連ドキュメント

| ドキュメント | 役割 |
|-------------|------|
| `wgrib2_options_v3.1.3.tsv` | wgrib2 全390オプション一覧 |
| `WGRIB2_OPTION_MATRIX.md` | 対象オプションの実装状況 |
| `WGRIB2_CLI_ROUNDTRIP_VALIDATION_CHECKLIST.md` | 詳細手順・実行ログ |

---

## 実行ログ

### 2026-02-24 -Sec0 検証

- ファイル: `gfswave.t00z.atlocn.0p16.f000.grib2` (642KB)
- CLI出力比較: MATCH
- Roundtrip: OK (1秒以内)

### 2026-02-24 -Sec3 検証

- ファイル: `gfswave.t00z.atlocn.0p16.f000.grib2` (642KB)
- CLI出力比較: MATCH
- Roundtrip: OK
