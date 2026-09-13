import 'package:flutter/material.dart';
import 'package:media_editor/platforms/components/dialog/prompt_alert_dialog.dart';

import 'block_type.dart';
import 'command_block.dart';

class CommandListEditorPage extends StatefulWidget {
  const CommandListEditorPage({super.key});

  @override
  State<CommandListEditorPage> createState() => _CommandListEditorPageState();
}

class _CommandListEditorPageState extends State<CommandListEditorPage> {
  final List<CommandBlock> blocks = [
    const CommandBlock(
      id: '1',
      type: BlockType.input,
      title: 'Input',
      command: '-i "input.mp4"',
      desc: 'Input media file',
    ),
    const CommandBlock(
      id: '2',
      type: BlockType.volume,
      title: 'Volume',
      command: '-af volume=2',
      desc: 'Change audio volume',
    ),
    const CommandBlock(
      id: '3',
      type: BlockType.encode,
      title: 'Encode',
      command: '-c:a aac',
      desc: 'Encode audio',
    ),
  ];
  ColorScheme get col => Theme.of(context).colorScheme;

  void showCodeView() {
    final data = blocks.fold(
      "",
      (previousValue, element) => '$previousValue \n\n${element.command}',
    );
    // showSuccessDialog(context, data);
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        scrollable: true,
        content: SingleChildScrollView(child: SelectableText(data)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;
          if (isWide) {
            return Row(
              children: [
                SizedBox(width: 230, child: blockPlate()),
                VerticalDivider(width: 1, color: col.outlineVariant),
                Expanded(child: listWidget),
              ],
            );
          }

          return Column(
            children: [
              SizedBox(height: 125, child: blockPlate(isWrap: true)),
              Divider(height: 1, color: col.outlineVariant),
              Expanded(child: listWidget),
            ],
          );
        },
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: const Text('FFmpeg Blocks'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.play_arrow),
          tooltip: 'Run',
        ),
        IconButton(
          onPressed: showCodeView,
          icon: const Icon(Icons.code),
          tooltip: 'View Command',
        ),
      ],
    );
  }

  Widget blockPlate({bool isWrap = false}) {
    final items = [
      (type: BlockType.input, title: 'Input', icon: Icons.input),
      (type: BlockType.trim, title: 'Trim', icon: Icons.content_cut),
      (type: BlockType.volume, title: 'Volume', icon: Icons.volume_up),
      (type: BlockType.metadata, title: 'Metadata', icon: Icons.info_outline),
      (type: BlockType.cover, title: 'Cover', icon: Icons.image_outlined),
      (type: BlockType.encode, title: 'Encode', icon: Icons.settings),
      (type: BlockType.output, title: 'Output', icon: Icons.output),
    ];

    if (isWrap) {
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          return plateItem(items[index]);
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        return plateItem(items[index]);
      },
    );
  }

  Widget plateItem(({BlockType type, String title, IconData icon}) data) {
    return Card(
      child: InkWell(
        onTap: () {
          // debugPrint('Add: ${data.type}');
          blocks.add(
            .new(
              id: 'uuid',
              type: data.type,
              title: data.title,
              command: '',
              desc: '',
            ),
          );
          setState(() {});
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data.icon, size: 20),
              const SizedBox(width: 8),
              Text(data.title),
            ],
          ),
        ),
      ),
    );
  }

  Widget get listWidget {
    return ReorderableListView.builder(
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final block = blocks[index];
        return _item(block, index);
      },
      onReorderItem: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex--;
          }

          final block = blocks.removeAt(oldIndex);
          blocks.insert(newIndex, block);
        });
      },
    );
  }

  Column _item(CommandBlock block, int index) {
    return Column(
      key: ValueKey(block),
      children: [
        CommandBlockWidget(
          block: block,
          onRemove: () {
            blocks.removeAt(index);
            setState(() {});
          },
          onEdit: () async {
            final res = await showPromptAlertDialog(context, block.command);
            if (res == null) return;
            blocks[index] = block.copyWith(command: res);
            setState(() {});
          },
        ),
        SizedBox(height: 1),
      ],
    );
  }
}

class CommandBlockWidget extends StatelessWidget {
  const CommandBlockWidget({
    super.key,
    required this.block,
    this.onRemove,
    this.onEdit,
  });
  final CommandBlock block;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      color: col.primaryContainer.withValues(alpha: .45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: col.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(block.type.iconData, size: 20, color: col.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    block.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: col.onPrimaryContainer,
                    ),
                  ),
                ),

                // Remove
                IconButton(
                  onPressed: onRemove,
                  tooltip: 'Remove',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                ),
                // Remove
                IconButton(
                  onPressed: onEdit,
                  tooltip: 'Edit',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.edit_document),
                ),

                // Drag handle
                const Icon(Icons.drag_handle, size: 20),
              ],
            ),

            if (block.command.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: col.surface.withValues(alpha: .65),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  block.command,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: col.onSurface,
                  ),
                ),
              ),
            ],

            if (block.desc.isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(
                block.desc,
                style: TextStyle(
                  fontSize: 11,
                  color: col.onPrimaryContainer.withValues(alpha: .7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
