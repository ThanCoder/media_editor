import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/core/utils/ffmpeg_utils.dart';
import 'package:media_editor/keys.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/prompt_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/snack_alert.dart';
import 'package:media_editor/platforms/pages/command_list_editor/block_type.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_plate.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_plate_view.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_plate_workspace_manager.dart';
import 'package:media_editor/platforms/pages/ffmpeg_process_page.dart';
import 'package:t_widgets/t_widgets.dart';

import 'command_block.dart';
import 'command_block_widget.dart';

class CommandListEditorPage extends StatefulWidget {
  const CommandListEditorPage({super.key});

  @override
  State<CommandListEditorPage> createState() => _CommandListEditorPageState();
}

class _CommandListEditorPageState extends State<CommandListEditorPage> {
  List<CommandBlock> blocks = [];
  ColorScheme get col => Theme.of(context).colorScheme;
  final config = AppUtils.instance.config;

  @override
  void initState() {
    blocks = config
        .getMapList(commandListEditorPageBlockListKey)
        .map((e) => CommandBlock.fromMap(e))
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    saveRecentBlock();
    super.dispose();
  }

  void saveRecentBlock() {
    final mapList = blocks.map((e) => e.toMap()).toList();
    config.putAndWriteAll(commandListEditorPageBlockListKey, mapList);
  }

  bool get isCanRun {
    if (blocks.isEmpty) return false;
    final types = blocks.map((e) => e.type);

    final hasInput = types.contains(BlockType.input);
    final hasOutput = blocks.last.type == .output;

    return hasInput && hasOutput;
  }

  void showBlockInfo(CommandBlock block) async {
    final info = await FfmpegUtils.getInfo(block.source);
    if (info == null) {
      if (!mounted) return;
      showErrorDialog(
        context,
        'Failed to get the duration from the input file!.',
      );
      return;
    }
    if (!mounted) return;
    final strBuff = StringBuffer();
    strBuff.writeln('Name: ${info.name}');
    strBuff.writeln('size: ${info.sizeLabel}');
    strBuff.writeln('bitrate: ${info.bitrate}');
    strBuff.writeln('format: ${info.format}');
    strBuff.writeln('duration: ${info.duration?.formatTimeLable()}');
    for (var st in info.info.streams) {
      strBuff.writeln('type: ${st.type}');
      strBuff.writeln('codec: ${st.codec}');
    }
    // strBuff.writeln(info.info.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        scrollable: true,
        title: Text('Info'),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(strBuff.toString()),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void onPlateClicked(CommandPlate plate, CommandPlateItem item) async {
    await CommandPlateWorkspaceManager(
      context: context,
      plate: plate,
      item: item,
      blocks: blocks,
    ).run();

    setState(() {});
  }

  void showCodeView() {
    final command = blocks.fold(
      "",
      (previousValue, element) => '$previousValue \n${element.command}',
    );
    context.pushMaterialPageRoute(
      builder: (mainCtx) => _CommandViewPage(command: command),
    );
  }

  void runProcess() {
    final command = blocks.fold(
      "",
      (previousValue, element) => '$previousValue ${element.command}',
    );
    context.pushMaterialPageRoute(
      builder: (mainCtx) => FfmpegProcessPage(command: command),
    );
  }

  double _panelWidth = 230;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        return Scaffold(
          appBar: _appbar(),
          drawer: isWide ? null : Drawer(child: SafeArea(child: blockPlate())),

          body: !isWide
              ? listWidget
              : Row(
                  children: [
                    SizedBox(width: _panelWidth, child: blockPlate()),
                    MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      child: GestureDetector(
                        behavior: .translucent,
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _panelWidth = (_panelWidth + details.delta.dx)
                                .clamp(180, 400);
                          });
                        },
                        child: SizedBox(
                          width: 10,
                          child: VerticalDivider(
                            width: 1,
                            color: col.outlineVariant,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: listWidget),
                  ],
                ),
        );
      },
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: const Text('FFmpeg Blocks'),
      actions: [
        IconButton(
          onPressed: !isCanRun ? null : runProcess,
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
    return CommandPlateView(isWrap: isWrap, onTap: onPlateClicked);
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

  Widget _item(CommandBlock block, int index) {
    return CommandBlockWidget(
      key: ValueKey(block),
      block: block,
      onRemove: () {
        blocks.removeAt(index);
        setState(() {});
      },
      onEdit: () async {
        final res = await showPromptAlertDialog(
          context,
          block.command,
          maxLines: null,
        );
        if (res == null) return;
        blocks[index] = block.copyWith(command: res);
        setState(() {});
      },
      showInfoBtn: block.type == .input,
      onInfoClicked: () => showBlockInfo(block),
    );
  }
}

class _CommandViewPage extends StatelessWidget {
  const new({required this.command});
  final String command;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Command View'),
        actions: [
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: command));
              if (!context.mounted) return;
              showSnackbar(context, 'Copid');
            },
            icon: Icon(Icons.copy_all_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(command),
        ),
      ),
    );
  }
}
