import 'package:flutter/widgets.dart';

class VariantScope extends InheritedWidget {
  final Map<String, Map<String, dynamic>> values;

  const VariantScope({super.key, required this.values, required super.child});

  static Map<String, dynamic>? maybeValueOf(BuildContext context, String id) {
    final scope = context.dependOnInheritedWidgetOfExactType<VariantScope>();
    return scope?.values[id];
  }

  @override
  bool updateShouldNotify(VariantScope oldWidget) {
    return values != oldWidget.values;
  }
}
