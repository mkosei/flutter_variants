import 'package:flutter/widgets.dart';

import '../parser/remote_parser.dart';
import 'remote_widget_builder.dart';

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
