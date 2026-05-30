# flutter_variants — 開発者ガイド

日本語 | [English](DOCUMENT.md)

`flutter_variants` の開発者向けドキュメントです。

## 目次

- [基本方針](#基本方針)
- [なぜ画面全体のレンダリングではなくslotなのか](#なぜ画面全体のレンダリングではなくslotなのか)
- [クイックスタート](#クイックスタート)
- [APIリファレンス](#apiリファレンス)
  - [`VariantScope`](#variantscope)
  - [`VariantText`](#varianttext)
  - [`VariantImage`](#variantimage)
  - [`VariantColor`](#variantcolor)
  - [`VariantSpacing`](#variantspacing)
  - [`VariantEdgeInsets`](#variantedgeinsets)
  - [`VariantBorderRadius`](#variantborderradius)
  - [`VariantVisibility`](#variantvisibility)
- [`VariantHost`](#varianthost)
- [セルフホスト](#セルフホスト)

## 基本方針

variant dataで変更できるもの:

- 文言
- CTAラベル
- 画像参照
- 色
- 余白
- 表示/非表示

variant dataで変更できないもの:

- 任意コードの実行
- ボタンの処理
- ナビゲーション
- API呼び出し
- 認証/決済/ビジネスロジック

Flutterコードが挙動を所有し、variant valuesは承認済みのslotに値を入れるだけです。

## なぜ画面全体のレンダリングではなくslotなのか

Full server-driven UIは、サーバー側で挙動まで変更できる仕組みに近づきやすくなります。このpackageはFlutter側のレイアウトとアプリロジックをnativeに保ちます。

目標:

```txt
Variant values change
-> Approved Flutter slots update
-> App behavior stays native
```

## クイックスタート

```dart
VariantScope(
  values: {
    'home.title': {
      'type': 'text',
      'value': '新しいオンボーディングを試す',
    },
    'home.cta.label': {
      'type': 'text',
      'value': '今すぐ始める',
    },
  },
  child: Column(
    children: [
      const VariantText(
        id: 'home.title',
        fallback: 'Welcome',
      ),
      ElevatedButton(
        onPressed: onContinue,
        child: const VariantText(
          id: 'home.cta.label',
          fallback: 'Continue',
        ),
      ),
    ],
  ),
)
```

サーバーは `home.title` と `home.cta.label` を変更できます。`onContinue` は変更できません。

## APIリファレンス

### `VariantScope`

配下のwidgetにvariant valuesを提供します。

```dart
VariantScope(
  values: {
    'slot.id': {
      'type': 'text',
      'value': 'Variant value',
    },
  },
  child: child,
)
```

### `VariantText`

`id` に対応するテキスト値を読みます。値がない、または不正な場合はローカルfallbackを表示します。

```dart
const VariantText(
  id: 'home.hero.title',
  fallback: 'Welcome',
)
```

### `VariantImage`

`id` に対応する画像URLを読みます。値がない、または不正な場合はローカルfallback画像を表示します。

```dart
VariantImage(
  id: 'home.hero.image',
  fallback: const AssetImage('assets/default_hero.png'),
)
```

### `VariantColor`

`id` に対応する色を読みます。

```dart
VariantColor.of(
  context,
  id: 'home.cta.background',
  fallback: const Color(0xFF3366FF),
)
```

対応形式:

- `#RRGGBB`
- `#AARRGGBB`

### `VariantSpacing`

`id` に対応する余白値を読みます。

```dart
VariantSpacing.of(
  context,
  id: 'home.section.spacing',
  fallback: 24,
  min: 0,
  max: 64,
)
```

### `VariantEdgeInsets`

`id` に対応する `EdgeInsets` 値を読みます。

```dart
VariantEdgeInsets.of(
  context,
  id: 'home.section.padding',
  fallback: const EdgeInsets.all(16),
)
```

サポートする形式:

- `value: 12` → `EdgeInsets.all(12)`
- `value: { "left": 8, "top": 4, "right": 8, "bottom": 12 }` → 個別指定。欠けたフィールドや不正な値は `0` になります。

### `VariantBorderRadius`

`id` に対応する `BorderRadius` 値を読みます。

```dart
VariantBorderRadius.of(
  context,
  id: 'home.card.radius',
  fallback: BorderRadius.circular(8),
)
```

サポートする形式:

- `value: 16` → `BorderRadius.circular(16)`
- `value: { "topLeft": 12, "topRight": 12, "bottomLeft": 0, "bottomRight": 4 }` → 個別指定。欠けたフィールドや不正な値は `0` になります。

### `VariantVisibility`

`id` に対応するboolean値を読み、`child` と `replacement` を切り替えます。

```dart
VariantVisibility(
  id: 'home.banner.visible',
  fallback: true,
  child: const Banner(),
)
```

## `VariantHost`

サーバーからvariant valuesを読み込むには、アプリ全体を `VariantHost` で包みます。

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  runApp(
    VariantHost(
      url: Uri.parse(
        'https://your-domain.com/apps/my_app/production/variants.json',
      ),
      child: const App(),
    ),
  );
}
```

不正なentryは無視されます。slotの値がない場合や不正な場合は、各widgetのfallbackが使われます。

### timeoutとcallback

```dart
VariantHost(
  url: Uri.parse('https://your-domain.com/apps/my_app/production/variants.json'),
  timeout: const Duration(seconds: 3),
  onLoadError: (error, stackTrace) {
    // 必要ならerrorを記録する。UIはlocal fallbackのまま動く。
  },
  onInvalidEntry: (issue) {}, // 任意: 不正なentryを検知したい場合に使う。
  child: const App(),
)
```

### retryとrefresh

一時的なネットワーク失敗に強くしたいときや、アプリ起動中にサーバー側の変更を取り込みたいときは、retryとrefresh intervalを指定します。

```dart
VariantHost(
  url: Uri.parse('https://your-domain.com/apps/my_app/production/variants.json'),
  maxRetries: 2, // 任意: 失敗時に指数backoffで再試行する。
  retryBackoff: const Duration(milliseconds: 300), // 任意: 初回backoff。試行ごとに2倍になる。
  refreshInterval: const Duration(minutes: 5), // 任意: 定期的に再取得する。
  child: const App(),
)
```

`onLoadError` は最後のretryも失敗したときだけ呼ばれます。refreshはloadに失敗しても止まらないので、サーバーが復旧すれば次回のintervalで自動的に値が取り込まれます。

### キャッシュ

`VariantHost` はデフォルトでメモリキャッシュを使います。キャッシュ済みの値があれば即表示し、裏で最新の値を取得します。毎回local fallbackから始めたい場合は `cache: false` を指定します。

このSDKはvariant valuesを読むだけです。サーバー側でビジネスロジックやボタン処理を差し替える仕組みは持ちません。

## セルフホスト

`flutter_variants` は専用のホスティングサービスを必要としません。

variant values はただのJSONなので、Cloudflare Pages、Netlify、Vercel、S3、自前バックエンド、任意の静的ホスティングに置けます。

例:

```json
{
  "home.title": {
    "type": "text",
    "value": "新しいオンボーディングを試す"
  },
  "home.cta.label": {
    "type": "text",
    "value": "今すぐ始める"
  },
  "home.cta.background": {
    "type": "color",
    "value": "#FF3366"
  },
  "home.banner.visible": {
    "type": "bool",
    "value": true
  },
  "home.section.spacing": {
    "type": "spacing",
    "value": 32
  }
}
```

配置例:

```txt
public/
  apps/
    my_app/
      production/
        variants.json
      staging/
        variants.json
```

URL例:

```txt
https://your-domain.com/apps/my_app/production/variants.json
```
