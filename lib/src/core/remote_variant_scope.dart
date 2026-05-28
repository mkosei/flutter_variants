import 'package:flutter/widgets.dart';

class RemoteVariantScope extends InheritedWidget {
  final Map<String, Map<String, dynamic>> values;

  const RemoteVariantScope({
    super.key,
    required this.values,
    required super.child,
  });

  static Map<String, dynamic>? maybeValueOf(BuildContext context, String id) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<RemoteVariantScope>();
    return scope?.values[id];
  }

  @override
  bool updateShouldNotify(RemoteVariantScope oldWidget) {
    return values != oldWidget.values;
  }
}
