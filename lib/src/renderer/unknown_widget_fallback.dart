import 'package:flutter/widgets.dart';

class UnknownWidgetFallback extends StatelessWidget {
  final String type;

  const UnknownWidgetFallback({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Widget fallback = const SizedBox.shrink();

    assert(() {
      fallback = DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          border: Border.all(color: const Color(0xFFFFC107)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Unknown remote widget: $type'),
        ),
      );
      return true;
    }());

    return fallback;
  }
}
