# Discussion Notes

このリポジトリの方向性・パフォーマンス・市場ポジショニングに関する討論ログ。実装ドキュメントではなく、設計判断と戦略の備忘

## 実用性の評価

**Q: 実際このライブラリ実用性ありそう？**

「特定の層には実用性あり、ただし戦う相手が強い」

### 強み

- **Flutter-typed slot widget** — `VariantText` / `VariantImage` / `VariantEdgeInsets` のように型付きwidgetで埋め込める。Firebase Remote Config (RC) は文字列key-valueなので、widget化レイヤーを毎回自前で書くことになる。
- **Self-hostable / no vendor lock-in** — 静的JSON置くだけ。
- **constrained-by-design** — server-driven UIの怖さを意図的に切り捨てている。
- **fallback込みのAPI契約** — 全widgetがfallback必須。型レベルで強制される。

### 弱み

- Firebase RC: 無料、targeting、percentage rollout、AB test、分析統合がある。
- adminツールがない（JSON手編集）。
- targeting / segmentation がない。
- analytics統合がない。
- AB test assignment がない。

### 実用シーン

- 個人開発・小規模スタートアップ
- 既に自前CDN/静的ホスティングがある組織
- Google依存を避けたい / 中国市場
- 内部ツール、業務アプリ
- ヘッドレスCMSと組み合わせた軽量config

### 実用シーンじゃない

- 既にFirebase使ってる
- AB testを真面目にやりたい
- 大規模・コンプライアンス要件あり

### 結論

「Firebase RCの代替」を狙うと負ける。「**Flutter-nativeで型安全に、self-hostで、constrained-by-designで副作用なく差し替えたい層**」に絞れば刺さるニッチはある。

---

## Firebase RCとのレイヤー関係

**Q: 「RCはconfig配信のbackend」の意味は？**

```
[サーバー] → [配信レイヤー] → [Flutter widget層]
            ↑ RCはここ        ↑ flutter_variantsはここ
```

RCの仕事は「値を端末に届ける部分」だけ:

- サーバー側で値を保存・編集する場所（コンソール）
- クライアントへの配信（fetch API）
- 配信時のtargeting / percentage rollout
- 「`home_title` というkeyに対して `"Welcome"` を返す」

RCがやらないこと:

- 文字列を `Text` widgetにする
- 値がなかったらfallbackを出す
- `"#FF3366"` を `Color` にパースする
- `{"left": 8, "top": 4}` を `EdgeInsets` にする
- 不正な値で落ちないよう型check

`flutter_variants` の `VariantText` / `VariantColor` / `VariantEdgeInsets` は、その「**最後の1cm**」を型安全な形で提供している。

**つまり競合ではなく別レイヤーの担当。** `VariantHost.loader` をRCを叩くcustom loaderに差し替えれば、配信はRC、widget化は `flutter_variants` という組み合わせも成立する。

---

## 長期vision vs Firebase RC

**長期予定**:
1. コンソールからシミュレータでデザイン見ながらJSON編集
2. ホスティング管理
3. 反応の数値化

### 1. シミュレータプレビュー付きコンソール

**RCには無い、最大の差別化候補。**

RCコンソールはkey-valueエディタのみ。実機/シミュレータでアプリ起動しないと結果が見えない。

`flutter_variants` が可能なのは **slot単位で型を持っている** から:

- `home.cta.background` が `color` 型 → color picker
- `home.section.padding` が `edgeInsets` → ビジュアルなpadding editor

RCは型を知らないので原理的に作れない。**設計上RCには真似できない強み。**

### 2. ホスティング管理

RCはそもそも「Googleのインフラに乗る」=ホスティング。比較しづらい。

`flutter_variants` の「`variants.json` をgit管理 → PRレビュー → 静的にdeploy」のフローはRCには真似しづらい。

ただし「ホスティング管理UI」を作る場合の競合はVercel/Cloudflare Pages。差別化は難しい。**売りはホスティングそのものより「JSON編集 → preview → publish」のworkflow** になる。

### 3. 反応の数値化

RCの強い領域（Firebase Analytics + Firebase A/B Testing）。

`flutter_variants` で真っ向勝負するなら、**slot単位impression / interactionを計測するhook** を入れる必要がある。

逆に「slot impression callback」を入れて、analyticsレイヤーは差し替え可能（Mixpanel/Amplitude/PostHog/自前）にすれば、RCより **vendor-neutral** な数値化ができる。設計次第で勝てる領域。

---

## 他の強み（追加）

- **Pure Dart, no platform channels** — RCはplatform channel経由。`flutter_variants` は全Dart。binary軽い、init gymnasticsなし、web対応が自然。
- **Initが1行** — `VariantHost(url: ..., child: ...)` だけ。RCは `setDefaults` / `fetch` / `activate` のサイクル。
- **Testが楽** — `VariantScope` を `pumpWidget` するだけ。RCはplatform channel mockが必要。
- **GitOps相性** — `variants.json` がgit-friendly。diffが読める、PRレビュー可能、`production/staging` ディレクトリ分離。
- **Nestable scope** — `VariantScope` を入れ子可能。画面単位override、デバッグoverride、ストーリーブック的preview。RCはglobal singleton。
- **AI-friendly editing** — typeが分かっているのでコンソール側で「これはCTA label、最大20文字、`text` 型のみ」とAIに指示できる。
- **Snapshot / golden test可能** — slot出力をgolden testで固定可能。デザインregression検出。
- **Privacy / telemetry story** — RCはGoogleにfetch情報が行く。`flutter_variants` はユーザー指定URLだけ叩く。プライバシー文脈・規制業界で効く。

---

## 最終ポジショニング

長期vision（コンソール preview / hosting / 数値化）まで含めると、**RCと正面衝突するのは「数値化」だけ。**

preview consoleとtype-aware editorはRCに真似できない方向で、ここが本当の差別化軸。

> 「Figmaのデザイントークン編集UI + Vercelのdeploy体験 + Flutter widget層の型安全」が組み合わさったもの

というポジショニングなら、RCとは別カテゴリの製品になる。

**「RCを置き換える」より「RCにはできない、Flutter-firstでvisual-firstなvariant運用ツール」を目指すと、ニッチが明確になる。**
