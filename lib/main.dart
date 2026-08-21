import 'package:cfb_store/cfb_store.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/p_utils.dart';
import 'package:media_editor/platforms/platform_app.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FFmpegKitExtended.initialize();

  await PUtils.instance.init();

  await CFBStore.getInstance.open(
    PUtils.instance.getCachePath('main.config.cbf'),
  );
  await ThanPkgLinux.getInstance.window.setWindowSize(width: 600, height: 400);

  runApp(const PlatformApp());
}
