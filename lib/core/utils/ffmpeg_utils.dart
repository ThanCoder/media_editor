// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';

class FileInfo {
  const FileInfo({
    required this.info,
    this.duration,
    this.bitrate,
    this.format,
  });
  final MediaInformation info;
  final Duration? duration;
  final String? bitrate;
  final String? format;
}

class FfmpegUtils {
  static Future<FileInfo?> getInfo(String path) async {
    final completer = Completer<FileInfo?>();
    await FFprobeKit.getMediaInformationAsync(
      path,
      onComplete: (session) {
        final info = session.getMediaInformation();
        if (info == null) {
          completer.complete(null);
          return;
        }
        final dur = info.duration;
        if (dur != null) {
          final duration = Duration(seconds: double.parse(dur).toInt());
          completer.complete(FileInfo(info: info, duration: duration));
          return;
        }
        completer.complete(FileInfo(info: info));
      },
    );
    return completer.future;
  }
}
