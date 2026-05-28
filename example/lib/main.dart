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
      'value': 'Rendered from a remote text slot',
    },
    'example.cta_label': {'type': 'text', 'value': 'Start now'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Variants Demo')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: RemoteVariantScope(
          values: variantValues,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RemoteText(
                id: 'example.variant_title',
                fallback: 'Default title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RemoteText(
                id: 'example.variant_body',
                fallback: 'Default body copy',
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: null,
                child: RemoteText(
                  id: 'example.cta_label',
                  fallback: 'Continue',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
