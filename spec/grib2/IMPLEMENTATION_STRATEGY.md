# GRIB2 実装戦略 (wgrib2 互換 CLI / Roundtrip / WASM)

## 1. 要件整理

本プロジェクトの実装方針は以下。

- パースして終わりではなく、編集可能な中間表現 (`Context`) を構築する
- `Context` から再ビルドしてラウンドトリップを担保する
- 初期ターゲットは `wgrib2` 互換 CLI
- 検証は `wgrib2` 実行結果をスナップショット化して行い、CI では `wgrib2` 非依存
- 将来の WASM/JS 利用を前提に、ネイティブ依存を極力避ける

## 2. アーキテクチャ

### 2.1 3層構造

- `Raw` 層:
  - GRIB2 message/submessage の生バイトと section 範囲
  - 未知 template/未知 table 値もロスなく保持
- `Context` 層:
  - 取り回しやすい編集用中間表現
  - レコード単位メタ情報 (var, lev, timestamp, discipline, offsets)
  - Section/Template の解決結果
- `Writer` 層:
  - `Context` -> バイナリ再構築
  - strict mode / raw-preserving mode の両方を提供

### 2.2 Context の最小単位

- Message
- Submessage (Section 2-7)
- Record inventory view (`wgrib2 -s` 相当)

最初は「編集容易性」を優先し、レコード単位の list + index map を採用する。

## 3. ラウンドトリップ戦略

## 3.1 目標

- `parse -> context -> build -> parse` で情報欠損なし
- 未対応 template が含まれても raw-preserving mode で可逆

### 3.2 不変条件

- Section 順序: 0,1,(2),3,4,5,6,7,8
- 各 section length 再計算の整合
- Section 0 total length と実サイズ一致
- Section 6 bitmap indicator と Section 7 データ整合

## 4. wgrib2 互換 CLI 方針

初期互換ターゲット:

- default inventory (`wgrib2 file`)
- `-s`
- `-Sec0`
- `-Sec3`
- `-Sec4`
- `-var -lev`

補足:

- 出力フォーマットは line 単位で wgrib2 と同等を目指す
- 内部実装は独自 parser/formatter のみを使用する
- `wgrib2` は開発時の差分確認用途に限定

## 5. 検証戦略 (CI 非依存)

### 5.1 Snapshot 方式

- ローカルで `wgrib2` 実行結果を生成
- `fixtures/wgrib2_snapshots/` にコミット
- テストでは自実装 CLI 出力と snapshot を比較

### 5.2 更新運用

- `tools/update_wgrib2_snapshots.sh` で更新
- 差分レビューして意図しない変更を検出
- CI は snapshot 比較のみ実行

## 6. WASM/JS 対応方針

- Core parser/writer を MoonBit 純実装で構築
- OS/ネイティブ API 依存を禁止
- I/O は adapter 層で分離
- 固定幅整数・ビット演算は core utility に閉じ込める

## 7. 実装順序 (推奨)

1. Section scanner + message/submessage 分解
2. Inventory 生成 (`-s` 相当)
3. `-Sec0/-Sec3/-Sec4/-var -lev` formatter
4. Writer (raw-preserving)
5. 編集 API (`Context` mutate)
6. strict writer/validator 強化
