# flutter_variants へのコントリビュート

日本語 | [English](CONTRIBUTING.md)

`flutter_variants` に興味を持ってくれてありがとうございます。このガイドはコード、ドキュメント、フィードバックでの貢献方法を説明します。

## プロジェクトの目的

`flutter_variants` は、JSON URLから安全に・型安全にUI variantを配信するFlutter SDKです。意図的に範囲を狭く保っています。

- variant dataは見た目（テキスト、色、画像、余白、レイアウト値、表示/非表示）だけを変えられる
- variant dataで挙動（callback、ナビゲーション、API呼び出し、認証、決済、ビジネスロジック）を変えてはいけない
- 値が無い or 不正なときは必ずローカルfallbackで描画する

初めての方は [`AGENTS.md`](AGENTS.md) を最初に読んでください。設計思想と守るべき境界を説明しています。利用者向けのAPIリファレンスは [`DOCUMENT.md`](DOCUMENT.md)、現在のロードマップは [`docs/TODO.md`](docs/TODO.md) にあります。

## 貢献の仕方

- **issue報告** — バグ、わかりにくいドキュメント、足りない例
- **ドキュメント改善** — README、DOCUMENT、コードコメント、例
- **テスト追加** — 不正なJSON、エッジケース、欠けたslotのregression test
- **API実装** — `docs/TODO.md` から選ぶ。特に「v1.0.0までに作りたいAPI」セクションが入りやすい
- **ユースケース共有** — どう使っているか、どう使いたいかをdiscussionで共有してください。実ユースケースが設計判断を導きます

## 開発セットアップ

```sh
git clone https://github.com/mkosei/flutter_variants.git
cd flutter_variants

# FVM（推奨）でFlutterをインストール
fvm install
fvm flutter pub get

# パッケージのテストを実行
fvm flutter test

# example appを実行
cd example
fvm flutter pub get
fvm flutter run
```

example appは起動時に `example/assets/variants.json` を読み込みます。編集してhot-restartすると、variantの変更が反映されます。

## 絶対に守るルール

この制約がこのpackageの存在意義です。これを破るPRはマージできません。

- **リモートでのロジック実行は無し** — variant dataが何かをコード実行することは絶対にしない（Dart、JavaScript、式評価、scriptすべて）
- **サーバー定義の挙動は無し** — callback、ナビゲーション、API呼び出し、認証、決済、権限、ビジネスロジックはFlutter app側にとどめる
- **variant dataは見た目だけ** — サーバーが「何が**起きるか**」を決める必要がある機能は、このpackageに属しません（「何が**見えるか**」だけが対象）
- **public widget / value reader にはfallback必須** — データ欠落や不正でcrashするのは禁止

迷ったら保守的に。制約こそがこのpackageの価値です。

## コード規約

- **APIの形** — 新しいvalue readerは既存パターンに従う：`VariantXxx.of(context, id: ..., fallback: ...)` または `VariantXxx(id: ..., fallback: ..., ...)`。`fallback` は常にrequired
- **JSON の型contract** — 各variant entryは `type` と `value` を持つ。新typeを足すなら、JSON形式を `DOCUMENT.md` のAPI隣に記載
- **新dependencyは事前相談** — runtimeはpure Dart + Flutter。依存追加は先にdiscussionで
- **platform channel不可** — packageは全Flutterターゲットでnative codeなしで動かす
- **SDK初期化シーケンス不可** — `VariantHost` だけがsetup。`await VariantSdk.initialize()` 的なものは足さない
- **テスト必須** — 新public APIとbug fixには、happy path、欠落path、不正値pathの3つをカバー
- **コメントは控えめ** — コードから読み取れない *なぜ* だけを書く。*何をしているか* の説明は不要

## プルリクエスト

- `main` からbranchを切る。PRは小さく、1つの関心にフォーカス
- commit messageは `type(scope?): summary` 形式（例: `feat: add VariantNumber`、`docs: clarify VariantHost retry semantics`、`test: cover stale load results`）
- `fvm flutter test` と `cd example && fvm flutter test` の両方が通ること
- 利用者向けAPI変更なら `DOCUMENT.md`（できれば `DOCUMENT.ja.md` も）を更新
- 大きめの変更はコード書き始める前にissueでdiscussion推奨

## 入りやすい貢献

`docs/TODO.md` から選ぶのが基本。小さめのstarter task：

- `DOCUMENT.md` に利用例を追加（ボタン文言、キャンペーンバナー、画像差し替え、色変更など）
- `example/assets/variants.json` にvariantシナリオを追加
- `loadVariantValuesFromUrl` のsuccess / invalid JSON testを追加
- v1.0.0残りAPIの実装（`VariantTextStyle.of`、`VariantButtonLabel`、`VariantIcon`）

合うかどうか不安なら、コード書く前にdiscussion / issueで聞いてください。

## バグ報告

以下を含めてissueを立ててください：

- 期待した動作と実際に起きたことの簡潔な説明
- 最小再現コード（Flutterの短いsnippet + 該当する `variants.json`）
- flutter / dartバージョン（`flutter --version`）

## 質問

GitHub Discussion か `question` ラベル付きissueで。半端なAPI / 設計のアイデアでも歓迎です。
