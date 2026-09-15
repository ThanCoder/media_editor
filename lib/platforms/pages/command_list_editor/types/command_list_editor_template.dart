// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';

import 'package:media_editor/platforms/pages/command_list_editor/types/command_block.dart';

class CommandListEditorTemplate {
  const CommandListEditorTemplate({
    this.id = '',
    required this.title,
    required this.desc,
    required this.blocks,
    required this.date,
  });

  final String id;
  final String title;
  final String desc;
  final List<CommandBlock> blocks;
  final DateTime date;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'desc': desc,
      'blocks': blocks.map((x) => x.toMap()).toList(),
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory CommandListEditorTemplate.fromMap(Map<String, dynamic> map) {
    return CommandListEditorTemplate(
      id: map.getString(['id']),
      title: map['title'] as String,
      desc: map['desc'] as String,
      blocks: map
          .getMapList(['blocks'])
          .map((e) => CommandBlock.fromMap(e))
          .toList(),

      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  CommandListEditorTemplate copyWith({
    String? id,
    String? title,
    String? desc,
    List<CommandBlock>? blocks,
    DateTime? date,
  }) {
    return CommandListEditorTemplate(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      blocks: blocks ?? this.blocks,
      date: date ?? this.date,
    );
  }
}
