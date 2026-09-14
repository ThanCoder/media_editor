import 'package:flutter/material.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_block.dart';

class CommandBlockWidget extends StatelessWidget {
  const CommandBlockWidget({
    super.key,
    required this.block,
    this.onRemove,
    this.onEdit,
    this.showInfoBtn = false,
    this.onInfoClicked,
  });
  final CommandBlock block;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;
  final bool showInfoBtn;
  final VoidCallback? onInfoClicked;

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
                // info
                if (showInfoBtn)
                  IconButton(
                    onPressed: onInfoClicked,
                    tooltip: 'Info',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.info_outline),
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
