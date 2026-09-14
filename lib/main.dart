import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/keys.dart';
import 'package:media_editor/platforms/platform_app.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FFmpegKitExtended.initialize();

  await AppUtils.instance.init();

  await CFBStore.getInstance.open(
    AppUtils.instance.getCachePath('main.config.cbf'),
  );
  if (Platform.isLinux) {
    final cf = AppUtils.instance.config;
    await ThanPkgLinux.getInstance.window.setWindowSize(
      width: cf.getDouble(appDesktopWidthKey, 600.0).toInt(),
      height: cf.getDouble(appDesktopHeightKey, 400.0).toInt(),
    );
  }

  runApp(const PlatformApp());
}
