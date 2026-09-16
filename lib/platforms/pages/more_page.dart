import 'package:flutter/material.dart';
import 'package:media_editor/platforms/pages/dev_pages/dev_route_tile.dart';

import 'package:t_widgets/t_widgets.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More App')),
      body: Column(
        spacing: 8,
        children: [TMaterialThemeProviderChooser(), DevRouteTile()],
      ),
    );
  }
}
