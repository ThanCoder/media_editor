// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart'
    show FileSizeLabelExtension, FileSystemEntityCoreExtensions;
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';

class FileInfo {
  const FileInfo({
    required this.name,
    required this.sizeLabel,
    required this.info,
    this.duration,
    this.bitrate,
    this.format,
  });
  final String name;
  final String sizeLabel;
  final MediaInformation info;
  final Duration? duration;
  final String? bitrate;
  final String? format;
}

class FfmpegUtils {
  static Future<FileInfo?> getInfo(String path) async {
    final f = File(path);
    if (!f.existsSync()) return null;

    final completer = Completer<FileInfo?>();
    await FFprobeKit.getMediaInformationAsync(
      path,
      onComplete: (session) {
        final info = session.getMediaInformation();
        if (info == null) {
          completer.complete(null);
          return;
        }
        final sizeLabel = f.fileSizeLabel();
        final name = f.name;
        final dur = info.duration;
        if (dur != null) {
          final duration = Duration(seconds: double.parse(dur).toInt());
          completer.complete(
            FileInfo(
              info: info,
              duration: duration,
              sizeLabel: sizeLabel,
              name: name,
              bitrate: info.bitrate,
              format: info.format,
            ),
          );
          return;
        }
        completer.complete(
          FileInfo(
            name: name,
            info: info,
            sizeLabel: sizeLabel,
            bitrate: info.bitrate,
            format: info.format,
          ),
        );
      },
    );
    return completer.future;
  }
}
