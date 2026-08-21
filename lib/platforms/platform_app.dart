import 'package:flutter/material.dart';
import 'package:media_editor/platforms/desktop/desktop_app.dart';
import 'package:t_widgets/t_widgets.dart';

class PlatformApp extends StatelessWidget {
  const PlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TMaterialThemeProvider(
      getTheme: () => .light,
      onChanged: (type) {},
      child: DesktopApp(),
    );
  }
}
