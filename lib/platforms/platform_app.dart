import 'package:flutter/material.dart';
import 'package:media_editor/platforms/desktop/desktop_app.dart';
import 'package:media_editor/platforms/mobile/mobile_home_screen.dart';
import 'package:t_widgets/t_widgets.dart';

class PlatformApp extends StatelessWidget {
  const PlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TMaterialThemeProvider(
      getTheme: () => .light,
      onChanged: (type) {},
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          if (maxWidth > 400) {
            return DesktopApp();
          }
          return MobileHomeScreen();
        },
      ),
    );
  }
}
