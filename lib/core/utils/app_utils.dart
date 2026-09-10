import 'dart:io';
import 'dart:isolate';

import 'package:cfb_store/cfb_store.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

class AppUtils {
  static AppUtils instance = AppUtils._();
  AppUtils._();
  factory AppUtils() => instance;

  final config = CFBStore();
  late Directory _cacheDir;
  late Directory _configDir;
  late Directory _downloadDir;
  late Directory _androidEmulatedStorageConfigDir;
  late String packageName;
  late String versionName;
  late String appName;

  Directory get cacheDir => _cacheDir;

  Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    packageName = info.packageName;
    versionName = info.version;
    appName = info.appName;
    _cacheDir = await getApplicationCacheDirectory();
    _configDir = await getApplicationSupportDirectory();
    if (Platform.isAndroid) {
      _downloadDir = Directory(
        ThanPkgAndroid.getInstance.pathHandler.getDownloadPath().join(appName),
      );
    } else {
      final downloadDir = await getDownloadsDirectory();
      if (downloadDir != null) {
        _downloadDir = Directory(downloadDir.join(appName));
      }
    }

    // android
    if (Platform.isAndroid) {
      final pkg = ThanPkgAndroid.getInstance.pathHandler;
      _androidEmulatedStorageConfigDir = Directory(
        pkg.getDeviceStoragePath().join('.${info.packageName}'),
      );
    }
  }

  String getCachePath([String? name]) {
    if (!_cacheDir.existsSync()) {
      _cacheDir.createSync(recursive: true);
    }
    if (name == null) return _cacheDir.path;

    return _cacheDir.path.join(name);
  }

  String getConfigPath([String? name]) {
    if (!_configDir.existsSync()) {
      _configDir.createSync(recursive: true);
    }
    if (name == null) return _configDir.path;

    return _configDir.path.join(name);
  }

  String getAndroidExternalConfigPath([String? name]) {
    if (!_androidEmulatedStorageConfigDir.existsSync()) {
      _androidEmulatedStorageConfigDir.createSync(recursive: true);
    }
    if (name == null) return _androidEmulatedStorageConfigDir.path;

    return _androidEmulatedStorageConfigDir.path.join(name);
  }

  String getPlatfromExternalConfigPath([String? name]) {
    if (Platform.isAndroid) {
      return getAndroidExternalConfigPath(name);
    }
    return getConfigPath(name);
  }

  String getPlatfromDownloadPath([String? name]) {
    if (!_downloadDir.existsSync()) {
      _downloadDir.createSync(recursive: true);
    }
    if (name == null) return _downloadDir.path;

    return _downloadDir.path.join(name);
  }

  /// ### Return -> [(count,size)]
  Future<(int, int)> getFolderInfo(Directory dir) async {
    if (!dir.existsSync()) return (0, 0);
    return await Isolate.run<(int, int)>(() {
      try {
        int size = 0;
        int count = 0;
        for (var entry in dir.listSync(recursive: true)) {
          if (entry.isFile) {
            size += entry.size;
          }
          count++;
        }
        return (count, size);
      } catch (e) {
        debugPrint('[AppUtils:deleteDir]: $e');
        return (0, 0);
      }
    });
  }

  Future<bool> deleteFolder(Directory dir) async {
    if (!dir.existsSync()) return false;
    return await Isolate.run(() {
      try {
        for (var file in dir.listSync()) {
          file.deleteSync(recursive: true);
        }
        return true;
      } catch (e) {
        debugPrint('[AppUtils:deleteDir]: $e');
        return false;
      }
    });
  }

  Future<void> copyText(String text) async {
    await Clipboard.setData(.new(text: text));
  }
}
