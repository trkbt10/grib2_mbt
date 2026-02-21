# GRIB2 実装仕様書 (Parser / Reader / Writer)

## 1. ドキュメントの目的

本仕様書は、MoonBit で GRIB2 の実装を進めるための実装基準を定義する。

- 対象: `parser` / `reader` / `writer`
- 参照元: NOAA NCEP GRIB2 Documentation (ローカルミラー)
- 基準版: Version 36.0.0 (2025-11-17)  
  参照: `spec/grib2/markdown/pages/index.md`

この仕様書の目的は「全セクション・全テンプレート・全コード表を実装可能な構成」を固定し、段階的に完成度を上げること。

## 2. 参照資料 (Normative)

- 入口: `spec/grib2/markdown/index.md`
- Section 定義:
  - `spec/grib2/markdown/pages/grib2_sect0.md`
  - `spec/grib2/markdown/pages/grib2_sect1.md`
  - `spec/grib2/markdown/pages/grib2_sect2.md`
  - `spec/grib2/markdown/pages/grib2_sect3.md`
  - `spec/grib2/markdown/pages/grib2_sect4.md`
  - `spec/grib2/markdown/pages/grib2_sect5.md`
  - `spec/grib2/markdown/pages/grib2_sect6.md`
  - `spec/grib2/markdown/pages/grib2_sect7.md`
  - `spec/grib2/markdown/pages/grib2_sect8.md`
- テンプレート番号表:
  - `spec/grib2/markdown/pages/grib2_table3-1.md`
  - `spec/grib2/markdown/pages/grib2_table4-0.md`
  - `spec/grib2/markdown/pages/grib2_table5-0.md`
  - `spec/grib2/markdown/pages/grib2_table7-0.md`
- カタログ:
  - `spec/grib2/markdown/catalog.tsv`
  - `spec/grib2/markdown/index.md`

## 3. 実装対象の完全性定義

「完全実装」は以下を満たすこと。

- Section 0-8 を順序・長さ・意味を保持して読める/書ける
- Code Table 解決を含む構造化 reader が動作する
- Template dispatch が Section 3/4/5/7 で全定義 ID を受理する
- writer が parse 結果から同等メッセージを再構築できる
- 予約値/欠損値/ローカル値を情報損失なく保持できる

Catalog ベースの現行対象件数:

- Section: 9
- Identification Template: 3
- Template: 202
  - Section 2: 1 (MDL local template)
  - Section 3: 39
  - Section 4: 138
  - Section 5: 13
  - Section 7: 11
- Code Table: 179

## 4. バイナリ規約

- バイトオーダー: big-endian
- セクション構造:
  - Section 0 は固定長 16 octets
  - Section 1-7 は先頭 4 octets が section length
  - Section 8 は `"7777"` 固定
- 文字列識別子:
  - Section 0 octet 1-4 は `"GRIB"`
  - Section 8 octet 1-4 は `"7777"`
- section no:
  - 各 section の octet 5 が section 番号と一致
- 多数値フィールド:
  - signed/unsigned は template 定義に従う
  - スケール係数/値ペアは生値と復元値の両方を保持可能にする
- 不明値:
  - missing (例: 255, 65535) は enum で明示的に表現する
  - reserved/local use は decode failure にせず raw 値を保持する

## 5. 論理データモデル

### 5.1 Message 単位

- `Grib2Message`
- `section0: Section0`
- `section1: Section1`
- `submessages: Array<Grib2Submessage>`
- `section8: Section8`

### 5.2 Submessage 単位 (Section 2-7)

- `Grib2Submessage`
- `section2: Option<Section2>`
- `section3: Section3`
- `section4: Section4`
- `section5: Section5`
- `section6: Section6`
- `section7: Section7`

Section 2 は省略可能。Section 3-7 は 1 セットとして扱う。

### 5.3 Raw と Decoded の二層

- Raw 層:
  - バイト範囲、元 octet 値、未知フィールドを保存
- Decoded 層:
  - template/table 解決後の意味構造を保存

この二層で、未知 template でも reader と writer の可逆性を維持する。

## 6. Parser / Reader 仕様

### 6.1 解析フロー

1. Section 0 検証 (`GRIB`, edition=2, total length)
2. Section 1 読み取り
3. Section 8 まで順に section scanner で分割
4. Section 2-7 を submessage として束ねる
5. 各 section で table/template dispatch を実行

### 6.2 Section ごとの必須検証

- length 最小値チェック
- section number の整合性
- message 全体長との整合性
- Section 3 `number_of_data_points` と Section 5/6/7 の整合性チェック
- Section 6 indicator に応じた bitmap 長チェック

### 6.3 Template dispatch

- Section 3: `Table 3.1` で GDT ID を解決
- Section 4: `Table 4.0` で PDT ID を解決
- Section 5: `Table 5.0` で DRT ID を解決
- Section 7: `Table 7.0` で Data Template ID を解決
- 未知 ID は `UnknownTemplate(id, raw)` で保持し parse 継続

### 6.4 Code Table dispatch

- table 値は `Known(code, meaning)` または `Unknown(code)` を返す
- catalog にある 179 table を定義データとして保持
- `Table 4.2` 系は `(discipline, category, parameter_number)` の 3 段解決を行う

## 7. Writer 仕様

### 7.1 出力規則

- セクション順を固定: 0,1,(2),3,4,5,6,7,8
- 各 section length を再計算して書き込む
- Section 0 total length を最終再計算して上書き
- section no octet は必ず固定値を書き込む

### 7.2 可逆性方針

- Decoded を持つ場合:
  - 正規化 writer で再エンコード
- Unknown template / 未解釈領域を含む場合:
  - raw payload を優先して書き戻すモードを提供

### 7.3 Bitmap / Data 一致

- Section 6 indicator=0 の場合:
  - bitmap bit 数と data point 数の整合をチェック
- indicator=254 の場合:
  - 参照 bitmap の存在チェック
- indicator=255 の場合:
  - bitmap 不在として section length=6 を許容

## 8. Template 実装範囲

Catalog に基づく必須実装 ID 範囲:

- Section 3 template IDs (39):
  - `0-5, 10, 12-13, 20, 23, 30-31, 33, 40-43, 50-53, 60-63, 90, 100-101, 110, 120, 140, 150, 204, 1000, 1100, 1200, 32768-32769`
- Section 4 template IDs (138):
  - `0-15, 20, 30-35, 40-51, 53-63, 67-68, 70-73, 76-155, 254, 1000-1002, 1100-1101`
- Section 5 template IDs (13):
  - `0-4, 40-42, 50-51, 53, 61, 200`
- Section 7 template IDs (11):
  - `0-4, 40-42, 50-51, 53`
- Identification Template (Section 1):
  - `1.0, 1.1, 1.2`
- Local template (Section 2):
  - `MDL Template 2.1`

## 9. Code Table 実装範囲

Section 別の table 範囲:

- Section 0: `0`
- Section 1: `0-6`
- Section 3: `0-13, 15, 20-21, 25`
- Section 4 (main): `0-16, 91, 100-106, 120-122, 201-225, 227-228, 230, 233-234, 236, 238-244, 246-253, 333, 335-336`
- Section 4.2 サブテーブル: 63 本 (`4.2-x-y` 系)
- Section 5: `0-7, 25-26, 40`
- Section 6: `0`
- Section 7: `0`

## 10. パッケージ設計 (MoonBit)

推奨ディレクトリ:

- `grib2/core`
  - byte reader/writer
  - integer/bit utility
  - error type
- `grib2/sections`
  - section0..section8
  - scanner / assembler
- `grib2/templates`
  - `section1`, `section2`, `section3`, `section4`, `section5`, `section7`
  - template registry
- `grib2/tables`
  - code table 定義
  - lookup 関数
- `grib2/reader`
  - high-level decode API
- `grib2/writer`
  - high-level encode API
- `grib2/model`
  - public AST / normalized model

公開 API は最小化し、raw/decoded 双方を保持できる型を優先する。

## 11. エラーモデル

最低限の分類:

- `UnexpectedEof`
- `InvalidMagic`
- `InvalidSectionNumber`
- `InvalidSectionLength`
- `InvalidMessageLength`
- `TemplateNotSupported`
- `TableValueUnknown`
- `DataMismatch` (bitmap と datapoint 不一致など)

reader は `strict` と `lenient` を持たせる。

- strict: 規約違反で即失敗
- lenient: 可能な限り復旧し warning 付きで返却

## 12. テスト仕様

### 12.1 単体テスト

- section parser/writer の octet 単位テスト
- table lookup の境界値テスト
- template decode の固定サンプルテスト

### 12.2 結合テスト

- 実ファイル fixture を使った decode
- decode -> encode -> decode の roundtrip 同値性
- unknown template を含むメッセージの raw 可逆性

### 12.3 回帰テスト

- NOAA 更新時の catalog 差分検知
- snapshot (inspect) による構造比較

## 13. 継続運用フロー

1. NOAA ミラー更新
2. `bash spec/grib2/tools/build_markdown.sh`
3. `bash spec/grib2/tools/build_implementation_checklist.sh`
4. `catalog.tsv` 差分確認
5. template/table registry を更新
6. parser/writer テスト実行

## 14. 実装フェーズ

### Phase 1: 骨格

- section scanner
- section0/1/8
- submessage 分割

### Phase 2: コア展開

- section3/4/5/6/7
- template registry の枠組み
- table lookup 基盤

### Phase 3: 全 template 接続

- Section 3/4/5/7 template 全 ID の dispatch
- 未知 template fallback 実装

### Phase 4: writer 完成

- strict writer
- raw-preserving writer
- roundtrip 品質保証

### Phase 5: 完全性仕上げ

- checklist 完了
- 性能最適化
- API 安定化

## 15. 実装完了判定

以下を満たした時点を完了とする。

- `spec/grib2/IMPLEMENTATION_CHECKLIST.md` が全チェック完了
- 主要 fixture の roundtrip が安定通過
- NOAA version 更新に対する差分反映手順が確立
