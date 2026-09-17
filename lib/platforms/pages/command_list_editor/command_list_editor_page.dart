import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/core/utils/ffmpeg_utils.dart';
import 'package:media_editor/keys.dart';
import 'package:media_editor/platforms/chooser/video_chooser.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/prompt_alert_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/block_type.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_list_editor_code_view_page.dart';
import 'package:media_editor/platforms/pages/command_list_editor/dialog/slider_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/workspace/edit_trim_workspace.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_list_editor_template.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_plate.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_plate_view.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_plate_workspace_manager.dart';
import 'package:media_editor/platforms/pages/ffmpeg_process_page.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'types/command_block.dart';
import 'command_block_widget.dart';

class CommandListEditorPage extends StatefulWidget {
  const CommandListEditorPage({super.key, this.template});
  final CommandListEditorTemplate? template;

  @override
  State<CommandListEditorPage> createState() => _CommandListEditorPageState();
}

class _CommandListEditorPageState extends State<CommandListEditorPage> {
  List<CommandBlock> blocks = [];
  ColorScheme get col => Theme.of(context).colorScheme;
  final config = AppUtils.instance.config;
  String? title;

  @override
  void initState() {
    final template = widget.template;
    if (template != null) {
      blocks = template.blocks;
      title = template.title;
    }
    super.initState();
  }

  bool get isCanRun {
    if (blocks.isEmpty) return false;
    final types = blocks.map((e) => e.type);

    final hasInput = types.contains(BlockType.input);
    final hasOutput =
        blocks.last.type == .output && blocks.last.source.isNotEmpty;

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
    // final command = blocks.fold(
    //   "",
    //   (previousValue, element) => '$previousValue \n${element.command}',
    // );
    context.pushMaterialPageRoute(
      builder: (mainCtx) => CommandListEditorCodeViewPage(blocks: blocks),
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

  void wantToSaveProject() async {
    context.pop<CommandListEditorTemplate>(
      .new(
        title: 'Recent',
        desc: 'Recent Template',
        blocks: blocks,
        date: .now(),
      ),
    );
  }

  void chooseVideoFile(CommandBlock block, int index) async {
    final path = await chooseMediaFileFromPlatform(
      context,
      dialogTitle: 'Pick Video',
      type: .video,
    );
    if (path == null) return;
    blocks[index] = block.copyWith(source: path, command: '-i "$path"');
    if (!mounted) return;
    setState(() {});
  }

  void chooseAudioFile(CommandBlock block, int index) async {
    final path = await chooseMediaFileFromPlatform(
      context,
      dialogTitle: 'Pick Audio',
      type: .audio,
    );
    if (path == null) return;
    blocks[index] = block.copyWith(source: path, command: '-i "$path"');
    if (!mounted) return;
    setState(() {});
  }

  void editOutputName(CommandBlock block, int index) async {
    final name = await showPromptAlertDialog(
      context,
      block.source.emptyOr('filename'),
    );
    if (name == null) return;
    blocks[index] = block.copyWith(
      command: '"${AppUtils.instance.getPlatfromDownloadPath(name)}"',
      source: name,
    );
    if (!mounted) return;
    setState(() {});
  }

  void editVolume(CommandBlock block, int index) async {
    if (block.id == 'volume') {
      final value = await showDialog<double>(
        context: context,
        builder: (context) => SliderDialog(
          max: 3,
          value: double.tryParse(block.source) ?? 1,
          title: 'Volume',
          valueWidget: (value) => Text('Value: ${value.toStringAsFixed(2)}'),
        ),
      );
      if (value == null) return;
      blocks[index] = block.copyWith(
        command: '-af volume=$value',
        source: value.toString(),
      );
    }

    if (!mounted) return;
    setState(() {});
  }

  void editTrim(CommandBlock block, int index) async {
    await EditTrimWorkspace(
      context: context,
      blocks: blocks,
      block: block,
      index: index,
    ).run();
    if (!mounted) return;
    setState(() {});
  }

  void editMeta(CommandBlock block, int index) async {
    final name = await showPromptAlertDialog(
      context,
      block.source,
      confirmText: 'Change',
    );
    if (name == null) return;
    if (block.id == 'Metadata-Title') {
      blocks[index] = block.copyWith(
        source: name,
        command: '-metadata title="$name"',
      );
    }
    if (block.id == 'Metadata-Artist') {
      blocks[index] = block.copyWith(
        source: name,
        command: '-metadata artist="$name"',
      );
    }
    if (block.id == 'Metadata-Album') {
      blocks[index] = block.copyWith(
        source: name,
        command: '-metadata album="$name"',
      );
    }
    if (block.id == 'Metadata-Genre') {
      blocks[index] = block.copyWith(
        source: name,
        command: '-metadata genre="$name"',
      );
    }
    if (block.id == 'Metadata-Year') {
      blocks[index] = block.copyWith(
        source: name,
        command: '-metadata date="$name"',
      );
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        wantToSaveProject();
      },
      child: _layout(),
    );
  }

  double _panelWidth = 230;
  LayoutBuilder _layout() {
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
      title: Text(title ?? 'FFmpeg Blocks'),
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
        IconButton(
          onPressed: () {
            launchUrlString(ffmpegDocUrl);
          },
          icon: const Icon(Icons.info_outline_rounded),
          tooltip: 'Read Doc',
        ),
      ],
    );
  }

  Widget blockPlate({bool isWrap = false}) {
    return CommandPlateView(onTap: onPlateClicked);
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
          title: 'Command',
          confirmText: 'Update',
          barrierDismissible: false,
        );
        if (res == null) return;
        blocks[index] = block.copyWith(command: res);
        setState(() {});
      },
      actions: [
        // input
        if (block.type == .input && block.source.isNotEmpty)
          IconButton(
            onPressed: () => showBlockInfo(block),
            tooltip: 'Info',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.info_outline),
          ),
        if (block.type == .input)
          IconButton(
            onPressed: () => chooseVideoFile(block, index),
            tooltip: 'Choose Video',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.video_file_outlined),
          ),
        if (block.type == .input)
          IconButton(
            onPressed: () => chooseAudioFile(block, index),
            tooltip: 'Choose Audio',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.audio_file_outlined),
          ),
        // volume
        if (block.type == .volume && block.id == 'volume')
          IconButton(
            onPressed: () => editVolume(block, index),
            tooltip: 'Change Volume',
            visualDensity: VisualDensity.compact,
            icon: Icon(block.type.iconData),
          ),
        if (block.type == .trim)
          IconButton(
            onPressed: () => editTrim(block, index),
            tooltip: 'Trim',
            visualDensity: VisualDensity.compact,
            icon: Icon(block.type.iconData),
          ),
        if (block.type == .metadata)
          IconButton(
            onPressed: () => editMeta(block, index),
            tooltip: 'Change Metadata',
            visualDensity: VisualDensity.compact,
            icon: Icon(block.type.iconData),
          ),
        // output
        if (block.type == .output && block.id == 'output')
          IconButton(
            onPressed: () => editOutputName(block, index),
            tooltip: 'Edit Name',
            visualDensity: VisualDensity.compact,
            icon: Icon(block.type.iconData),
          ),
      ],
    );
  }
}
