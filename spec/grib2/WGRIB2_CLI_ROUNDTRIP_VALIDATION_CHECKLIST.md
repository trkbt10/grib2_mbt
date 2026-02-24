# wgrib2互換CLI ラウンドトリップ検証チェックリスト

このドキュメントは、`grib2_mbt` の `wgrib2` 互換 CLI について、
実データでの比較と roundtrip 安全性を一連で検証するための手順書兼タスク管理表です。

## 対象

- 対象CLI: `moon run cmd/main -- <grib2-file> [option]`
- 比較元: `wgrib2`
- フィクスチャ:
  - `fixtures/grib2_jma/Z__C_RJTD_20241206000000_GSM_GPV_Rgl_FD0000_grib2.bin`
  - `fixtures/grib2_noaa/gfs.t00z.pgrb2b.1p00.f000.grib2`
  - `fixtures/grib2_noaa/gfswave.t00z.atlocn.0p16.f000.grib2`
- スナップショット:
  - `fixtures/wgrib2_snapshots/`
  - `fixtures/wgrib2_snapshots/manifest.tsv`

## 受け入れ条件

- 互換対象オプションの snapshot 比較が全件一致する。
- `parse -> rebuild_raw` および `parse -> rebuild_strict` が全fixtureでバイト一致する。
- 差分が出た場合は、原因/修正/再検証結果が本ドキュメント末尾の記録欄に残る。

## 実行手順チェックリスト

### 0. 事前確認

- [ ] `moon` と `wgrib2` のバージョンを記録する

```bash
moon version
${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2} -version
```

- [ ] 互換オプションの現状を確認する

```bash
sed -n '1,220p' spec/grib2/WGRIB2_OPTION_MATRIX.md
```

### 1. スナップショット再生成（ローカルのみ）

- [ ] `wgrib2` 出力のスナップショットを再生成する

```bash
WGRIB2_BIN=${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2} \
  bash tools/update_wgrib2_snapshots.sh
```

- [ ] `manifest.tsv` と生成ファイル数を確認する

```bash
wc -l fixtures/wgrib2_snapshots/manifest.tsv
find fixtures/wgrib2_snapshots -type f | sort
```

### 2. 既存テストでの互換性検証

- [ ] parser snapshot 比較テスト（native）

```bash
moon test tests/native/grib2_parser_test.mbt --target native
```

- [ ] roundtrip 回帰テスト（native, slow）

```bash
moon test tests/native/grib2_writer_roundtrip_test.mbt --target native
```

- [ ] 補助検証（必要に応じて）

```bash
moon test tests/native/grib2_writer_fast_test.mbt --target native
moon check --target native
moon check --target wasm
```

### 3. 実データでの `wgrib2` vs `grib2_mbt` 直接比較

- [ ] 以下スクリプトで全fixture・全コマンドの差分確認を実行する

```bash
#!/usr/bin/env bash
set -euo pipefail

WGRIB2_BIN="${WGRIB2_BIN:-/opt/homebrew/bin/wgrib2}"
TMP_DIR="${TMP_DIR:-/tmp/grib2_cli_compare}"
mkdir -p "${TMP_DIR}"

run_wgrib2() {
  local file="$1"
  local cmd="$2"
  case "${cmd}" in
    default) "${WGRIB2_BIN}" "${file}" ;;
    s) "${WGRIB2_BIN}" "${file}" -s ;;
    Sec0|Sec3|Sec4|Sec5|Sec6|Sec_len|n|range|var|lev|ftime|grid|pdt|process|ens|prob|disc|center|subcenter|packing|bitmap|nxny|npts)
      "${WGRIB2_BIN}" "${file}" "-${cmd}" ;;
    var_lev) "${WGRIB2_BIN}" "${file}" -var -lev ;;
    *) echo "unknown command: ${cmd}" >&2; return 1 ;;
  esac
}

run_mbt() {
  local file="$1"
  local cmd="$2"
  case "${cmd}" in
    default|s) moon run cmd/main -- "${file}" ;;
    Sec0|Sec3|Sec4|Sec5|Sec6|Sec_len|n|range|var|lev|ftime|grid|pdt|process|ens|prob|disc|center|subcenter|packing|bitmap|nxny|npts)
      moon run cmd/main -- "${file}" "-${cmd}" ;;
    var_lev) moon run cmd/main -- "${file}" -var -lev ;;
    *) echo "unknown command: ${cmd}" >&2; return 1 ;;
  esac
}

tail -n +2 fixtures/wgrib2_snapshots/manifest.tsv | \
while IFS=$'\t' read -r fixture_id fixture_path cmd snapshot_path; do
  out_w="${TMP_DIR}/${fixture_id}_${cmd}_wgrib2.txt"
  out_m="${TMP_DIR}/${fixture_id}_${cmd}_mbt.txt"
  run_wgrib2 "${fixture_path}" "${cmd}" > "${out_w}"
  run_mbt "${fixture_path}" "${cmd}" > "${out_m}"
  if ! diff -u "${out_w}" "${out_m}" > "${TMP_DIR}/${fixture_id}_${cmd}.diff"; then
    echo "NG ${fixture_id} ${cmd}: ${TMP_DIR}/${fixture_id}_${cmd}.diff"
    exit 1
  fi
  echo "OK ${fixture_id} ${cmd}"
done

echo "ALL OK"
```

### 4. roundtrip と CLI互換の合成判定

- [ ] 手順2（roundtripテスト）と手順3（CLI直接比較）が両方OKであることを確認する
- [ ] どちらかNGの場合は、次の順で切り分ける
  1. parser/decode差分か（`tests/native/grib2_parser_test.mbt`）
  2. writer/roundtrip差分か（`tests/native/grib2_writer_roundtrip_test.mbt`）
  3. CLI整形差分か（`grib2_inventory.mbt` と option parser）

## タスク管理表

| ID | タスク | 完了条件 | 状態 | 担当 | 証跡 |
| --- | --- | --- | --- | --- | --- |
| RT-01 | 互換対象オプション一覧の固定 | `WGRIB2_OPTION_MATRIX.md` 更新済み | [ ] |  |  |
| RT-02 | snapshot再生成 | `tools/update_wgrib2_snapshots.sh` 実行成功 | [ ] |  |  |
| RT-03 | parser snapshot比較 | `grib2_parser_test` 成功 | [ ] |  |  |
| RT-04 | roundtrip回帰 | `grib2_writer_roundtrip_test` 成功 | [ ] |  |  |
| RT-05 | 実データ直接比較 | 全 `fixture_id x command` で `OK` | [ ] |  |  |
| RT-06 | 差分修正 | NG項目が0件になる | [ ] |  |  |
| RT-07 | 最終検証 | `moon check --target native/wasm` 成功 | [ ] |  |  |
| RT-08 | 引き継ぎ反映 | `HANDOVER.md` と本書に記録反映 | [ ] |  |  |

## 実行ログ記録欄

### yyyy-mm-dd HH:MM

- 実行者:
- ブランチ:
- 実行コマンド:
- 結果サマリ:
- 差分/障害:
- 対応内容:
- 再実行結果:

