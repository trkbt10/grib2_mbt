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
