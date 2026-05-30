# flutter_variants

日本語 | [English](README.md)

`flutter_variants` は、FlutterアプリのUIバリアントを安全に差し替えるためのSDKです。

テキスト、画像、色、余白、表示/非表示などの「見た目の値」だけを差し替えます。画面構造、ナビゲーション、ボタンの処理、API呼び出し、認証、決済、ビジネスロジックはFlutterアプリ側に残します。

これはserver-driven UI rendererではありません。Flutterアプリ向けの小さなvariant slot systemです。

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

## 例

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

## 現在のAPI

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

### `VariantVisibility`

`id` に対応するboolean値を読み、`child` と `replacement` を切り替えます。

```dart
VariantVisibility(
  id: 'home.banner.visible',
  fallback: true,
  child: const Banner(),
)
```

## なぜ画面全体のレンダリングではなくslotなのか

Full server-driven UIは、サーバー側で挙動まで変更できる仕組みに近づきやすくなります。このpackageはFlutter側のレイアウトとアプリロジックをnativeに保ちます。

目標:

```txt
Variant values change
-> Approved Flutter slots update
-> App behavior stays native
```

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

Flutterアプリ側では、アプリ全体を `VariantHost` で包みます。

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

本番アプリでは、timeoutやload失敗時のcallbackも指定できます。

```dart
VariantHost(
  url: Uri.parse('https://your-domain.com/apps/my_app/production/variants.json'),
  timeout: const Duration(seconds: 3),
  onLoadError: (error, stackTrace) {
    // 必要ならerrorを記録する。UIはlocal fallbackのまま動く。
  },
  child: const App(),
)
```

`VariantHost` はデフォルトでメモリキャッシュを使います。キャッシュ済みの値があれば即表示し、裏で最新の値を取得します。毎回local fallbackから始めたい場合は `cache: false` を指定します。

このSDKはvariant valuesを読むだけです。サーバー側でビジネスロジックやボタン処理を差し替える仕組みは持ちません。

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
