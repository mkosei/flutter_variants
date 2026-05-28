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

  static const schema = {
    'type': 'column',
    'children': [
      {
        'type': 'text',
        'value': 'Variant A',
      },
      {
        'type': 'text',
        'value': 'Rendered from remote schema',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Variants Demo'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: RemoteRenderer(schema: schema),
      ),
    );
  }
}
