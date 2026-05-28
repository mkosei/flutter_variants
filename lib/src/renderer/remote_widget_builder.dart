import 'package:flutter/widgets.dart';

import '../core/remote_node.dart';
import 'unknown_widget_fallback.dart';

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
