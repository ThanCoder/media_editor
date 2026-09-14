import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/keys.dart';
import 'package:media_editor/platforms/desktop/desktop_app.dart';
import 'package:media_editor/platforms/mobile/mobile_home_screen.dart';
import 'package:t_widgets/t_widgets.dart';

class PlatformApp extends StatefulWidget {
  const PlatformApp({super.key});

  @override
  State<PlatformApp> createState() => _PlatformAppState();
}

class _PlatformAppState extends State<PlatformApp> {
  final config = AppUtils.instance.config;
  BoxConstraints? constraints;
  Timer? _saveTimer;
  void saveSize() {
    if (constraints == null) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(Duration(seconds: 3), () {
      config
          .put(appDesktopWidthKey, constraints?.maxWidth)
          .put(appDesktopHeightKey, constraints?.maxHeight)
          .writeAll();
      debugPrint('[_PlatformAppState:saveSize] save window size');
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: config.stream.put.where((e) => e.key == appThemeKey),
      builder: (context, asyncSnapshot) {
        return TMaterialThemeProvider(
          getTheme: () => .fromName(config.getString(appThemeKey)),
          onChanged: (type) {
            config.putAndWriteAll(appThemeKey, type.name);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              this.constraints = constraints;
              saveSize();

              if (maxWidth > 400) {
                return DesktopApp();
              }
              return MobileHomeScreen();
            },
          ),
        );
      },
    );
  }
}
