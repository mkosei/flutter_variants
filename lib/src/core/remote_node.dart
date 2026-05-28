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
