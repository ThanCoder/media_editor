import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:media_editor/keys.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_list_editor_template.dart';
import 'package:t_client/t_client.dart';

class TemplateApi {
  static Future<List<CommandListEditorTemplate>> getList() async {
    final list = <CommandListEditorTemplate>[];
    final client = TClient();
    try {
      final res = await client.get(
        '$commandListEditorTemplateApiUrl?v=${DateTime.now().millisecondsSinceEpoch}',
      );
      if (res.isErr) {
        return list;
      }
      List<dynamic> json = jsonDecode(res.unwrap().body);
      return json.map((e) => CommandListEditorTemplate.fromMap(e)).toList();
    } catch (e) {
      debugPrint('[TemplateApi:getList]: $e');
    } finally {
      client.close();
    }
    return list;
  }
}
