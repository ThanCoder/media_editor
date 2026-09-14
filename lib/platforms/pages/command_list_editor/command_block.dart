import 'package:dart_core_extensions/dart_core_extensions.dart';

import 'block_type.dart';

class CommandBlock {
  const CommandBlock({
    required this.id,
    required this.type,
    required this.title,
    required this.command,
    required this.desc,
    this.source = '',
  });

  final String id;
  final BlockType type;
  final String title;
  final String command;
  final String desc;
  final String source;

  CommandBlock copyWith({
    String? id,
    BlockType? type,
    String? title,
    String? command,
    String? desc,
    String? source,
  }) {
    return CommandBlock(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      command: command ?? this.command,
      desc: desc ?? this.desc,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'title': title,
      'command': command,
      'desc': desc,
      'source': source,
    };
  }

  factory CommandBlock.fromMap(Map<String, dynamic> map) {
    return CommandBlock(
      id: map['id'] as String,
      type: .fromVal(map.getString(['type'])),
      title: map['title'] as String,
      command: map['command'] as String,
      desc: map['desc'] as String,
      source: map['source'] as String,
    );
  }
}
