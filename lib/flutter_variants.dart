import 'package:flutter/widgets.dart';

class RemoteNode {
  final String type;
  final Map<String, dynamic> props;
  final List<RemoteNode> children;

  const RemoteNode({
    required this.type,
    required this.props,
    this.children = const [],
  });
}

Widget buildRemoteWidget(RemoteNode node) {
  switch (node.type) {
    case 'text':
      return Text(node.props['value'] as String? ?? '');
    case 'column':
      return Column(
        children: node.children.map(buildRemoteWidget).toList(),
      );
    default:
      return UnknownWidgetFallback(type: node.type);
  }
}

RemoteNode parseRemoteNode(Map<String, dynamic> schema) {
  final childrenJson = schema['children'];

  return RemoteNode(
    type: schema['type'] as String? ?? '',
    props: schema,
    children: childrenJson is List
        ? childrenJson
            .whereType<Map<String, dynamic>>()
            .map(parseRemoteNode)
            .toList()
        : const [],
  );
}

class RemoteRenderer extends StatelessWidget {
  final Map<String, dynamic> schema;

  const RemoteRenderer({
    super.key,
    required this.schema,
  });

  @override
  Widget build(BuildContext context) {
    final node = parseRemoteNode(schema);
    return buildRemoteWidget(node);
  }
}

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
