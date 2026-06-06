import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  runApp(const DemoApp());
}

enum VariantPreset {
  defaults('Default', 'assets/variants_default.json'),
  sale('Sale', 'assets/variants_sale.json'),
  holiday('Holiday', 'assets/variants_holiday.json');

  final String label;
  final String assetPath;

  const VariantPreset(this.label, this.assetPath);

  Uri get url => Uri.parse('asset://$assetPath');
}

VariantHostLoader _loaderFor(VariantPreset preset) {
  return (Uri _) async {
    final raw = await rootBundle.loadString(preset.assetPath);
    final decoded = jsonDecode(raw);
    final result = parseVariantValuesWithIssues(decoded);

    return VariantLoadResult(values: result.values, issues: result.issues);
  };
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  VariantPreset _preset = VariantPreset.defaults;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Variants Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: VariantHost(
        url: _preset.url,
        loader: _loaderFor(_preset),
        child: HomeScreen(
          activePreset: _preset,
          onPresetChanged: (next) => setState(() => _preset = next),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VariantPreset activePreset;
  final ValueChanged<VariantPreset> onPresetChanged;

  const HomeScreen({
    super.key,
    required this.activePreset,
    required this.onPresetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Variants Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<VariantPreset>(
                value: activePreset,
                onChanged: (next) {
                  if (next != null) {
                    onPresetChanged(next);
                  }
                },
                items: [
                  for (final preset in VariantPreset.values)
                    DropdownMenuItem(
                      value: preset,
                      child: Text(preset.label),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _HeroCard(),
            _SectionSpacing(),
            const _PromoBanner(),
            _SectionSpacing(),
            const _ProductSection(),
            _SectionSpacing(),
            _CtaButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: VariantEdgeInsets.of(
        context,
        id: 'home.hero.padding',
        fallback: const EdgeInsets.all(20),
      ),
      decoration: BoxDecoration(
        color: VariantColor.of(
          context,
          id: 'home.hero.background',
          fallback: const Color(0xFFEEF2FF),
        ),
        borderRadius: VariantBorderRadius.of(
          context,
          id: 'home.card.radius',
          fallback: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              final style = VariantTextStyle.of(
                context,
                id: 'home.hero.titleStyle',
                fallback: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              );

              return VariantText(
                id: 'home.hero.title',
                fallback: 'Welcome',
                style: style,
              );
            },
          ),
          const SizedBox(height: 8),
          const VariantText(
            id: 'home.hero.subtitle',
            fallback: 'Today\'s picks for you.',
          ),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return VariantVisibility(
      id: 'home.banner.visible',
      fallback: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: VariantColor.of(
            context,
            id: 'home.banner.background',
            fallback: const Color(0xFFFEF3C7),
          ),
          borderRadius: VariantBorderRadius.of(
            context,
            id: 'home.card.radius',
            fallback: BorderRadius.circular(12),
          ),
        ),
        child: const VariantText(
          id: 'home.banner.text',
          fallback: '',
        ),
      ),
    );
  }
}

class _ProductSection extends StatelessWidget {
  const _ProductSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VariantText(
          id: 'home.products.section_title',
          fallback: 'Recommended',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        const _ProductGrid(),
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _ProductCard(
            titleId: 'home.product.tee.title',
            priceId: 'home.product.tee.price',
            fallbackTitle: 'Tee',
            fallbackPrice: '\$0',
            color: Color(0xFFE0E7FF),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _ProductCard(
            titleId: 'home.product.cap.title',
            priceId: 'home.product.cap.price',
            fallbackTitle: 'Cap',
            fallbackPrice: '\$0',
            color: Color(0xFFFCE7F3),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _ProductCard(
            titleId: 'home.product.bag.title',
            priceId: 'home.product.bag.price',
            fallbackTitle: 'Bag',
            fallbackPrice: '\$0',
            color: Color(0xFFD1FAE5),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String titleId;
  final String priceId;
  final String fallbackTitle;
  final String fallbackPrice;
  final Color color;

  const _ProductCard({
    required this.titleId,
    required this.priceId,
    required this.fallbackTitle,
    required this.fallbackPrice,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: VariantBorderRadius.of(
          context,
          id: 'home.card.radius',
          fallback: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          VariantText(
            id: titleId,
            fallback: fallbackTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          VariantText(
            id: priceId,
            fallback: fallbackPrice,
            style: const TextStyle(color: Color(0xFF374151)),
          ),
        ],
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CtaButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return VariantButtonLabel(
      id: 'home.cta.label',
      fallback: 'Browse all',
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: VariantColor.of(
          context,
          id: 'home.cta.background',
          fallback: const Color(0xFF4F46E5),
        ),
        foregroundColor: Colors.white,
        padding: VariantEdgeInsets.of(
          context,
          id: 'home.cta.padding',
          fallback: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: VariantBorderRadius.of(
            context,
            id: 'home.card.radius',
            fallback: BorderRadius.circular(12),
          ),
        ),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}

class _SectionSpacing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: VariantSpacing.of(
        context,
        id: 'home.section.spacing',
        fallback: 16,
      ),
    );
  }
}
