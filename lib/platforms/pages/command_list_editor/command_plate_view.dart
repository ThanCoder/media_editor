import 'package:flutter/material.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_plate.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_plate_data.dart';

class CommandPlateView extends StatefulWidget {
  const new({super.key, this.onTap});
  final void Function(CommandPlate plate, CommandPlateItem item)? onTap;

  static final expansionMap = <String, bool>{};
  static double lastScrollPos = 0.0;

  @override
  State<CommandPlateView> createState() => _CommandPlateViewState();
}

class _CommandPlateViewState extends State<CommandPlateView> {
  final controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !controller.hasClients) return;

      final pos = CommandPlateView.lastScrollPos.clamp(
        0.0,
        controller.position.maxScrollExtent,
      );

      if (pos > 0) {
        controller.animateTo(
          pos,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    });
    controller.addListener(() {
      if (controller.hasClients) {
        CommandPlateView.lastScrollPos = controller.position.pixels;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = commandPlateData;
    return ListView.separated(
      controller: controller,
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
                onTap: () => widget.onTap?.call(item, e),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
