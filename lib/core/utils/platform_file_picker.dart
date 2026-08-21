import 'package:file_picker/file_picker.dart' hide FileType;
import 'package:file_type_plus/file_type_plus.dart';
import 'package:media_editor/core/utils/result.dart';

class PlatformFilePicker {
  static Future<Result<List<String>, String>> pickFile() async {
    try {
      final list = <String>[];

      final res = await FilePicker.pickFiles(
        linuxOptions: .new(acceptLabel: 'Pick Media File'),
      );

      for (var f in res) {
        list.add(f.xFile.path);
      }

      return Ok(filterMediaFiles(list));
    } catch (e) {
      return Err(e.toString());
    }
  }

  static List<String> filterMediaFiles(List<String> rawFiles) {
    return rawFiles.where((e) {
      final ty = FileType.fromPath(e);
      return ty.isAny([FileType.audio, FileType.video]);
    }).toList();
  }
}
