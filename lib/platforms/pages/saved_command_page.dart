import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/platforms/pages/buildin_command.dart';
import 'package:t_widgets/t_widgets.dart';

class SavedCommandPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SavedCommandPage> createState() => _SavedCommandPageState();

  static final store = AppUtils.instance.savedCommandStore;
  static bool existsCommand(String command) {
    return list.indexWhere((e) => e.command == command) != -1;
  }

  static List<FFmpegCustomCommand> get list => SavedCommandPage.store
      .getMapList('list')
      .map((e) => FFmpegCustomCommand.fromMap(e))
      .toList();

  static void saveNotExists(FFmpegCustomCommand command) {
    final res = list;
    final index = res.indexWhere((e) => e.command == command.command);
    if (index != -1) return;
    res.add(command);
    final mapList = res.map((e) => e.toMap()).toList();
    store.putAndWriteAll('list', mapList);
  }

  static void remove(String command) {
    final res = list;
    final index = res.indexWhere((e) => e.command == command);
    if (index == -1) return;
    res.removeAt(index);
    final mapList = res.map((e) => e.toMap()).toList();
    store.putAndWriteAll('list', mapList);
  }
}

class _SavedCommandPageState extends State<SavedCommandPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await SavedCommandPage.store.reload();
    if (!mounted) return;
    setState(() {});
  }

  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Commands')),
      body: StreamBuilder(
        stream: SavedCommandPage.store.stream.put,
        builder: (context, asyncSnapshot) {
          final list = SavedCommandPage.list;
          if (list.isEmpty) {
            return Center(child: Text('Saved Command Empty!'));
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = list[index];
              return _menuItem(
                item.title,
                command: item.command,
                description: item.description,
              );
            },
          );
        },
      ),
    );
  }

  ListTile _menuItem(
    String title, {
    required String command,
    String description = '',
  }) {
    return ListTile(
      tileColor: col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      leading: const Icon(Icons.copy_all_outlined),
      trailing: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: col.error,
          foregroundColor: col.onError,
        ),
        onPressed: () {
          SavedCommandPage.remove(command);
        },
        icon: Icon(Icons.delete_forever_outlined),
      ),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description.isNotEmpty) Text(description),
          if (command.isNotEmpty) Text(command),
        ],
      ),
      onTap: () {
        if (command.isEmpty) return;
        context.pop<String>(command);
      },
    );
  }
}
