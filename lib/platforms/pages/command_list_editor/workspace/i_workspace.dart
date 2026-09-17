import 'package:flutter/material.dart';

import 'package:media_editor/platforms/pages/command_list_editor/types/command_block.dart';

abstract class IWorkspace {
  final BuildContext context;
  final List<CommandBlock> blocks;
  final CommandBlock block;
  final int index;
  const IWorkspace({
    required this.context,
    required this.blocks,
    required this.block,
    required this.index,
  });

  Future<void> run();
}
