import 'package:flutter/material.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Variants Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  static const variantValues = {
    'example.variant_title': {'type': 'text', 'value': 'Variant A'},
    'example.variant_body': {
      'type': 'text',
      'value': 'Rendered from a variant text slot',
    },
    'example.cta_label': {'type': 'text', 'value': 'Start now'},
    'example.cta_background': {'type': 'color', 'value': '#FF3366'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Variants Demo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: VariantScope(
          values: variantValues,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VariantText(
                id: 'example.variant_title',
                fallback: 'Default title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const VariantText(
                id: 'example.variant_body',
                fallback: 'Default body copy',
              ),
              const SizedBox(height: 24),
              Builder(
                builder: (context) {
                  final backgroundColor = VariantColor.of(
                    context,
                    id: 'example.cta_background',
                    fallback: Colors.indigo,
                  );

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: null,
                    child: const VariantText(
                      id: 'example.cta_label',
                      fallback: 'Continue',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
