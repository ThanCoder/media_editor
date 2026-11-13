import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:media_editor/core/utils/app_util.dart';
import 'package:media_editor/platforms/platform_app.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtil.instance.init();

  if (Platform.isLinux) {
    await ThanPkgLinux.getInstance.window.setWindowSize(
      width: 400,
      height: 600,
    );
    await ThanPkgLinux.getInstance.window.setWindowTitle(
      AppUtil.instance.appName,
    );
  }

  runApp(const PlatformApp());
}
