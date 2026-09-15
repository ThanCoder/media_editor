import 'package:media_editor/platforms/pages/command_list_editor/block_type.dart';

class CommandPlate {
  const CommandPlate({
    required this.title,
    required this.type,
    required this.children,
  });
  final String title;
  final BlockType type;
  final List<CommandPlateItem> children;
}

class CommandPlateItem {
  const CommandPlateItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.command,
    this.source=''
  });

  final String id;
  final String title;
  final String desc;
  final String command;
  final String source;
}
