import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  runApp(const DemoApp());
}

Future<VariantLoadResult> _loadFromAsset(Uri url) async {
  final raw = await rootBundle.loadString('assets/variants.json');
  final decoded = jsonDecode(raw);
  final result = parseVariantValuesWithIssues(decoded);

  return VariantLoadResult(values: result.values, issues: result.issues);
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VariantHost(
      url: Uri.parse('asset://variants.json'),
      loader: _loadFromAsset,
      child: MaterialApp(
        title: 'Flutter Variants Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const DemoHomePage(),
      ),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Variants Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _HeroCard(),
            _SectionSpacing(),
            const _Banner(),
            _SectionSpacing(),
            const _CtaButton(),
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
          fallback: const Color(0xFFEEEEFF),
        ),
        borderRadius: VariantBorderRadius.of(
          context,
          id: 'home.card.radius',
          fallback: BorderRadius.circular(8),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VariantText(
            id: 'home.hero.title',
            fallback: 'Default title',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          VariantText(
            id: 'home.hero.subtitle',
            fallback: 'Default body copy',
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

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
            fallback: const Color(0xFFFFF3E0),
          ),
          borderRadius: VariantBorderRadius.of(
            context,
            id: 'home.card.radius',
            fallback: BorderRadius.circular(8),
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

class _CtaButton extends StatelessWidget {
  const _CtaButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: VariantColor.of(
          context,
          id: 'home.cta.background',
          fallback: Colors.indigo,
        ),
        foregroundColor: Colors.white,
        padding: VariantEdgeInsets.of(
          context,
          id: 'home.cta.padding',
          fallback: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: VariantBorderRadius.of(
            context,
            id: 'home.card.radius',
            fallback: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: () {},
      child: const VariantText(
        id: 'home.cta.label',
        fallback: 'Continue',
      ),
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
