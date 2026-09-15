import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_editor/platforms/components/dialog/snack_alert.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_block.dart';

class CommandListEditorCodeViewPage extends StatelessWidget {
  const new({super.key, required this.blocks});

  final List<CommandBlock> blocks;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _appbar(context),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: col.surfaceContainerHighest.withValues(alpha: .45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: col.outlineVariant),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < blocks.length; i++)
                  _CodeLine(number: i + 1, block: blocks[i], colorScheme: col),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      title: const Text('Command View'),
      actions: [
        IconButton(
          onPressed: () async {
            final command = blocks.map((e) => e.command).join('\n');

            await Clipboard.setData(ClipboardData(text: command));

            if (!context.mounted) return;

            showSnackbar(context, 'Copied');
          },
          tooltip: 'Copy',
          icon: const Icon(Icons.copy_all_outlined),
        ),
      ],
    );
  }
}

class _CodeLine extends StatelessWidget {
  const _CodeLine({
    required this.number,
    required this.block,
    required this.colorScheme,
  });

  final int number;
  final CommandBlock block;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final color = block.type.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$number',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: colorScheme.onSurfaceVariant.withValues(alpha: .5),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Container(
            width: 3,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            block.command,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: color,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
