import 'package:flutter/widgets.dart';

class RemoteNode {
  final String type;
  final Map<String, dynamic> props;
  final List<RemoteNode> children;

  RemoteNode({
    required this.type,
    required this.props,
    this.children = const [],
  });
}

Widget buildRemoteWidget(RemoteNode node) {
  switch(node.type) {
    case 'text':
      return Text(node.props['value'] ?? '');
    case 'column':
      return Column(
        children: node.children.map(buildRemoteWidget).toList(),
      );

    default:
      return const SizedBox.shrink();
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