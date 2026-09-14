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
    final file = File(path);
    if (!file.existsSync()) return null;

    final completer = Completer<FileInfo?>();

    await FFprobeKit.getMediaInformationAsync(
      path,
      onComplete: (session) {
        final info = session.getMediaInformation();

        if (info == null) {
          completer.complete(null);
          return;
        }

        final durationText = info.duration;

        Duration? duration;

        if (durationText != null) {
          final seconds = double.tryParse(durationText);

          if (seconds != null) {
            duration = Duration(milliseconds: (seconds * 1000).round());
          }
        }

        final sizeLabel = file.fileSizeLabel();
        final name = file.name;

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
      },
    );

    return completer.future;
  }
}
