// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}
