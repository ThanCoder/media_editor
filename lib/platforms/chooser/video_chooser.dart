import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/platforms/chooser/android_video_chooser_page.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

String? _initialDirectory;

Future<String?> chooseVideoFromPlatform(BuildContext context) async {
  if (Platform.isAndroid) {
    final pkg = ThanPkgAndroid.getInstance.storagePermissionHandler;
    if (!await pkg.isStoragePermissionGranted()) {
      await pkg.requestStoragePermission();
      return null;
    }
    if (!context.mounted) return null;
    return await context.pushMaterialPageRoute(
      builder: (mainCtx) =>
          AndroidVideoChooserPage(cachePath: AppUtils.instance.getCachePath()),
    );
  }

  // linux
  final res = await FilePicker.pickFile(
    dialogTitle: 'Choose video File',
    initialDirectory: _initialDirectory,
    type: .video,
  );
  if (res == null) return null;
  _initialDirectory = res.path!.pathBuf.parentPath;

  return res.path;
}
