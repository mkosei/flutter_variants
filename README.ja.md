# flutter_variants

日本語 | [English](README.md)

`flutter_variants` は、FlutterアプリのUIバリアントを安全に差し替えるためのSDKです。

テキスト、画像、色、余白、表示/非表示などの「見た目の値」だけを差し替えます。画面構造、ナビゲーション、ボタンの処理、API呼び出し、認証、決済、ビジネスロジックはFlutterアプリ側に残します。

これはserver-driven UI rendererではありません。Flutterアプリ向けの小さなvariant slot systemです。

## 最小例

```dart
VariantScope(
  values: {
    'home.title': {
      'type': 'text',
      'value': '新しいオンボーディングを試す',
    },
  },
  child: const VariantText(
    id: 'home.title',
    fallback: 'Welcome',
  ),
)
```

サーバーから値を配信する場合は、アプリ全体を `VariantHost` で包みます。

```dart
VariantHost(
  url: Uri.parse(
    'https://your-domain.com/apps/my_app/production/variants.json',
  ),
  child: const App(),
)
```

## ドキュメント

詳細は [DOCUMENT.ja.md](DOCUMENT.ja.md) を参照してください。

- 基本方針とslot設計
- APIリファレンス（`VariantScope` / `VariantText` / `VariantImage` /
  `VariantColor` / `VariantSpacing` / `VariantEdgeInsets` /
  `VariantBorderRadius` / `VariantString` / `VariantBool` / `VariantNumber` /
  `VariantVisibility`）
- `VariantHost` の設定（timeout、retry、refresh、cache、callback）
- セルフホストと `variants.json` のフォーマット

## コントリビュート

PR・issueは歓迎です。開発セットアップ、コード規約、守るべきルールは [CONTRIBUTING.ja.md](CONTRIBUTING.ja.md) を参照してください。

## exampleを実行する

```sh
cd example
flutter run
```

## testを実行する

```sh
flutter test
cd example
flutter test
```

FVMを使う場合は、Flutterコマンドの前に `fvm` を付けてください。

```sh
fvm flutter test
cd example
fvm flutter test
```
