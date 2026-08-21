import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More App')),
      body: Column(children: [TMaterialThemeProviderChooser()]),
    );
  }
}
