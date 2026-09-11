// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:media_editor/platforms/components/forms/input_text.dart';
import 'package:media_editor/platforms/pages/buildin_command.dart';
import 'package:t_widgets/t_widgets.dart';

class BuildinCommandPage extends StatefulWidget {
  const new({super.key});

  @override
  State<BuildinCommandPage> createState() => _BuildinCommandPageState();
}

class _BuildinCommandPageState extends State<BuildinCommandPage> {
  ColorScheme get col => Theme.of(context).colorScheme;
  final searchCon = TextEditingController();
  final focusNode = FocusNode();

  List<FFmpegCustomCommand> list = [...buildInFFmpegCommands];

  @override
  void dispose() {
    searchCon.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fav Command')),
      body: CustomScrollView(slivers: [_filterWiget, _buildinCommandList]),
    );
  }

  Widget get _filterWiget {
    return SliverToBoxAdapter(
      child: Padding(
        padding: .symmetric(vertical: 10, horizontal: 12),
        child: InputText(
          controller: searchCon,
          focusNode: focusNode,
          maxLines: 1,
          hint: Text('Search Command && Title....'),
          suffixIcon: IconButton(
            onPressed: () {
              list = buildInFFmpegCommands;
              searchCon.text = '';
              focusNode.unfocus();
              setState(() {});
            },
            icon: Icon(Icons.clear_all_outlined),
          ),
          onChanged: (val) {
            if (val.isEmpty) {
              list = buildInFFmpegCommands;
            } else {
              final search = val.toLowerCase();
              list = buildInFFmpegCommands
                  .where(
                    (e) =>
                        e.title.toLowerCase().contains(search) ||
                        e.command.toLowerCase().contains(search),
                  )
                  .toList();
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget get _buildinCommandList {
    return SliverPadding(
      padding: .symmetric(vertical: 10, horizontal: 12),
      sliver: SliverList.separated(
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
      trailing: const Icon(Icons.copy_all_outlined),
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
