import 'dart:io';

class PUtils {
  static PUtils instance = PUtils._();
  PUtils._();
  factory PUtils() => instance;

  final Directory _cacheDir = Directory('/home/thancoder/.cache/media_editor/');

  Future<void> init() async {}

  Directory get cacheDir => _cacheDir;

  String getCachePath([String? name]) {
    if (!cacheDir.existsSync()) {
      cacheDir.createSync(recursive: true);
    }
    return '${cacheDir.path}/$name';
  }
}
