# GRIB2 WASM ブラウザデモ

## 概要

`npm/demo/` ディレクトリには、GRIB2 WASM モジュールをブラウザで動作確認するためのデモアプリケーションが含まれている。Vite + TypeScript で構築され、Canvas API を使用してグリッドデータを可視化する。

## 必要環境

- Node.js 18+
- Chrome 119+ (WebAssembly GC + js-string builtins 必須)
- MoonBit toolchain (`moon build --target wasm-gc`)

## セットアップ

```bash
# 1. WASM モジュールをビルド
moon build --target wasm-gc

# 2. デモディレクトリへ移動
cd npm/demo

# 3. 依存関係インストール
npm install

# 4. 開発サーバー起動
npm run dev
```

http://localhost:5173/ でデモが起動する。

## 機能

### Fixture ローダー

- **Load MSM**: JMA MSM（メソスケールモデル）日本域データ
  - 解像度: 5km (241×253 グリッド)
  - 予報時間: FH00-15, FH18-33, FH36-39
- **Load GSM**: JMA GSM（全球モデル）データ
  - 解像度: 0.5° (720×361 グリッド)

### パラメータ選択

- 気圧面別の気象要素（TMP, HGT, UGRD, VGRD 等）を選択可能
- 自動的に 500hPa TMP を初期選択

### 時系列機能

- タイムラインスライダーで予報時間を選択
- 再生ボタンでアニメーション表示
- 移動平均スライダーで時間方向のスムージング

### 動画出力

- MediaRecorder API による WebM 録画
- 時系列アニメーションを動画として保存

## アーキテクチャ

```
npm/demo/src/
├── main.ts              # エントリポイント、UI イベント処理
├── grib2-browser.ts     # WASM API の ESM ラッパー
├── canvas-renderer.ts   # Canvas 描画（グリッド→ピクセル変換）
├── colormap.ts          # 温度カラーマップ（青→白→赤）
├── time-series.ts       # 時系列データ管理、移動平均
├── video-recorder.ts    # MediaRecorder ラッパー
└── types.ts             # 共通型定義
```

## テスト

```bash
# ユニットテスト (Vitest)
npm test

# E2E テスト (Playwright)
npx playwright test
```

E2E テストは実際のブラウザで WASM 初期化・データパース・Canvas 描画を検証する。

## 制限事項

- WebAssembly GC が必要なため、Chrome 119+ または同等の WasmGC 対応ブラウザが必須
- Firefox/Safari は 2024年12月時点で未対応
