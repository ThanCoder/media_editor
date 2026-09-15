import 'package:flutter/material.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_plate.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_plate_data.dart';

class CommandPlateView extends StatelessWidget {
  const new({super.key, this.isWrap = false, this.onTap});
  final bool isWrap;
  final void Function(CommandPlate plate, CommandPlateItem item)? onTap;

  static final expansionMap = <String, bool>{};

  @override
  Widget build(BuildContext context) {
    final list = commandPlateData;
    return ListView.separated(
      scrollDirection: isWrap ? .horizontal : .vertical,
      padding: const EdgeInsets.all(8),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(width: 4),
      itemBuilder: (context, index) {
        return plateItem(list[index]);
      },
    );
  }

  Widget plateItem(CommandPlate item) {
    return Builder(
      builder: (context) {
        final col = Theme.of(context).colorScheme;
        return ExpansionTile(
          initiallyExpanded: CommandPlateView.expansionMap[item.title] ?? false,
          onExpansionChanged: (value) {
            CommandPlateView.expansionMap[item.title] = value;
          },
          leading: Icon(item.type.iconData, color: col.primary),
          title: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          shape: const Border(),
          collapsedShape: const Border(),
          childrenPadding: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 8,
          ),
          children: item.children.map((e) {
            return Card(
              margin: const EdgeInsets.only(bottom: 6),
              elevation: 0,
              color: col.surfaceContainerHigh,
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                title: Text(
                  e.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),

                    Text(e.desc, style: TextStyle(color: col.onSurfaceVariant)),

                    if (e.command.isNotEmpty) ...[
                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: col.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          e.command,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: col.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: Icon(Icons.add_circle_outline, color: col.primary),
                onTap: () => onTap?.call(item, e),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
