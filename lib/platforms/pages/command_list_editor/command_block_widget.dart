import 'package:flutter/material.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_block.dart';

class CommandBlockWidget extends StatelessWidget {
  const CommandBlockWidget({
    super.key,
    required this.block,
    this.onRemove,
    this.onEdit,
    this.actions = const [],
  });

  final CommandBlock block;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    final typeColor = block.type.color;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      color: typeColor.withValues(alpha: .12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: typeColor.withValues(alpha: .35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(block.type.iconData, size: 20, color: typeColor),
                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    block.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: typeColor,
                    ),
                  ),
                ),

                ...actions,

                IconButton(
                  onPressed: onRemove,
                  tooltip: 'Remove',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.close, color: col.onSurfaceVariant),
                ),

                IconButton(
                  onPressed: onEdit,
                  tooltip: 'Edit',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.edit_document, color: col.onSurfaceVariant),
                ),
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
                  border: Border.all(color: typeColor.withValues(alpha: .15)),
                ),
                child: SelectableText(
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
                style: TextStyle(fontSize: 11, color: col.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
