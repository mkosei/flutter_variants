import '../core/remote_node.dart';

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
