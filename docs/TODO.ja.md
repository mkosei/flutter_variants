# TODO

日本語 | [English](TODO.md)

## v1.0.0までに作りたいAPI

1.0.0の目安は「pub.devに公開できるレベル」。安定した最小限のAPI surfaceを揃える。

primitive系（値だけ取得するシンプルAPI）:

- `VariantString.of(context, id: ..., fallback: ...)` — widgetではなく文字列だけ取りたい用途向け。
- `VariantBool.of(context, id: ..., fallback: ...)` — 汎用的な真偽値（`VariantVisibility` 以外の分岐用途）。
- `VariantNumber.of(context, id: ..., fallback: ...)` — spacing専用ではない汎用数値。

Flutter標準クラスのhelper:

- `VariantTextStyle.of` — `fontSize`、`fontWeight`、`color` あたりのサブセット。フル `TextStyle` ではない。

その他検討:

- `VariantButtonLabel` — callbackを差し替えずにボタン表示だけ変える例 or 専用widget。
- `VariantIcon` — 許可済みicon setからの選択。

## 次に追加したいAPI（v1.0.0以降検討）

- なし（候補が出たらここに追記）

## loaderの改善

- オフライン起動向けにlocal persistenceを追加する。
- privateなJSON endpointを使えるようにrequest header対応を追加する。

## パフォーマンス

- `VariantScope` 更新時に、関係ないwidgetまで再描画されすぎないか確認する。
- `VariantScope` を画面単位、feature単位、slot単位のどこで切るべきか検討する。
- 大きなJSONでもparseが重くなりすぎないようにbenchmarkを追加する。
- `parseVariantValues` のcopy処理が必要以上にメモリを使っていないか確認する。
- 画像URL差し替え時に不要な再fetchやちらつきが起きないか確認する。
- `VariantHost` のfetch、parse、scope更新にかかる時間をdebugで見られるようにする。
- 初回起動時はfallback表示を優先し、variant取得でUI threadを詰まらせない。
- キャッシュのstale dataの即時描画とbackground refreshの体感速度を確認する。
- 大量のslotを使う画面向けに、lookup回数やmap構造の見直しを検討する。

## schema validation

- 開発時だけ、存在しないkeyやtypoっぽいkeyを検出できるようにする。
- typeごとの小さなschema specを書く。
  - `text`
  - `image`
  - `color`
  - `spacing`
  - `bool`
  - `edgeInsets`
  - `borderRadius`
- schema versionを追加する。
  - `schemaVersion`
  - 互換性ルール
  - fallbackの挙動

## 開発体験

- 現在の値や不正なentryを確認できるdebug overlayを追加する。
- READMEとDOCUMENTに利用例を増やす。
  - ボタン文言
  - キャンペーンバナー
  - 画像差し替え
  - 表示/非表示切り替え
  - 色変更
- example用の `variants.json` を追加する。
- static fileを使った最小セルフホストsampleを追加する。

## safety rules

- callback、navigation、API call、auth、payment、business logicは必ずnative Flutter側に置く。
- サーバー定義のaction実行は追加しない。
- 任意の式評価は追加しない。
- Dart、JavaScript、scriptの実行は追加しない。
- variant valuesは見た目の差し替えだけに限定する。

## test

- `loadVariantValuesFromUrl` の成功時とinvalid JSON時のtestを追加する。
- `VariantHost` を使うexample app testを追加する。
- 不正なschemaでもwidgetがcrashしないことをregression testで守る（既存parserテストの補完）。

## package公開前の整備

- publish前に `pubspec.yaml` のdescriptionを直す。
- package topicsを追加する。
- README用のscreenshotまたは短いGIFを追加する。
- public APIを追加したらCHANGELOGを書く。
- 初回release前にexportしているAPI surfaceを見直す。

## 将来のtooling

- `variants.json` をvalidateするCLIを検討する。
- variant変更をローカルで試すpreview commandを検討する。
- static JSONを書き出す簡単なweb editorを検討する。
- CLI/web toolingはoptionalにして、Flutter SDK本体とは分ける。

## hosted product案

- セルフホストは無料で使える状態を維持し、READMEにも残す。
- 有料版で提供できそうなもの。
  - hosted JSON delivery
  - 値を編集するweb console
  - approval workflow
  - rollback
  - basic metrics
  - experiment reporting
- hosted productでもbusiness logicの差し替えはしない。
