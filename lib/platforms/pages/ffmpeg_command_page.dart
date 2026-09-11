import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/ffmpeg_command/ffmpeg_command_builder.dart';
import 'package:media_editor/core/ffmpeg_command/i_command.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/platforms/chooser/video_chooser.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/prompt_alert_dialog.dart';
import 'package:media_editor/platforms/components/forms/input_text.dart';
import 'package:media_editor/platforms/components/info_widget.dart';
import 'package:media_editor/platforms/pages/buildin_command_page.dart';
import 'package:media_editor/platforms/pages/custom_command_page.dart';
import 'package:media_editor/platforms/pages/ffmpeg_process_page.dart';
import 'package:media_editor/platforms/pages/saved_command_page.dart';
import 'package:t_widgets/t_widgets.dart';

class FfmpegCommandPage extends StatefulWidget {
  const new({super.key});

  @override
  State<FfmpegCommandPage> createState() => _FfmpegCommandPageState();
}

class _FfmpegCommandPageState extends State<FfmpegCommandPage> {
  ColorScheme get col => Theme.of(context).colorScheme;
  String? inputPath;

  final nameCon = TextEditingController();
  final commandCon = TextEditingController();
  final commandResultNoti = ValueNotifier('');

  @override
  dispose() {
    super.dispose();
    nameCon.dispose();
    commandCon.dispose();
  }

  void chooseMediaFile() async {
    try {
      inputPath = await chooseMediaFileFromPlatform(context);
      if (inputPath == null) return;
      nameCon.text = inputPath!.getName();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  Future<void> process() async {
    final outputPath = AppUtils.instance.getPlatfromDownloadPath(nameCon.text);

    final builder = FfmpegCommandBuilder(
      input: inputPath!,
      output: outputPath,
      commands: [CustomCommand(commandCon.text)],
    );
    // print('command: ${builder.command}');
    context.pushMaterialPageRoute(
      builder: (mainCtx) => FfmpegProcessPage(command: builder.command),
    );
  }

  Future<void> goFavCommand() async {
    final res = await context.pushMaterialPageRoute<String>(
      builder: (mainCtx) => CustomCommandPage(),
    );
    if (res == null) return;
    commandCon.text = '${commandCon.text} $res';
    setState(() {});
  }

  String get commandResult {
    final outputPath = AppUtils.instance.getPlatfromDownloadPath(nameCon.text);

    final builder = FfmpegCommandBuilder(
      input: inputPath!,
      output: outputPath,
      commands: [CustomCommand(commandCon.text)],
    );
    return builder.command;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Command'),
        actions: [
          if (inputPath != null)
            IconButton(
              onPressed: () {
                setState(() {
                  inputPath = null;
                });
              },
              icon: Icon(Icons.clear_all_outlined),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InfoWidget(path: inputPath),
            if (inputPath == null) chooseMediaFileWidget,
            if (inputPath != null) _commandWidgets,
          ],
        ),
      ),
      floatingActionButton: inputPath == null
          ? null
          : FloatingActionButton(
              onPressed: process,
              child: Icon(Icons.play_circle_fill_outlined),
            ),
    );
  }

  Widget get _commandWidgets {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          InputText(
            controller: nameCon,
            label: Text('Output Name'),
            maxLines: 1,
            onChanged: (val) {
              commandResultNoti.value = val;
            },
          ),
          SizedBox(height: 10),
          _commandWidget(),
          SizedBox(height: 20),
          _commandResultWidget(),
        ],
      ),
    );
  }

  Widget _commandWidget() {
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        InputText(
          controller: commandCon,
          label: Text('FFMpeg Command'),
          maxLines: null,
          onChanged: (val) {
            commandResultNoti.value = val;
          },
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear_all_outlined),
            onPressed: () {
              commandCon.clear();
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: commandResultNoti,
          builder: (context, value, child) {
            return Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _saveCommandBtn(),
                FilledButton.icon(
                  onPressed: goFavCommand,
                  label: Text('Custom Commands'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _saveCommandBtn() {
    return StreamBuilder(
      stream: SavedCommandPage.store.stream.put,
      builder: (context, asyncSnapshot) {
        if (commandCon.text.isEmpty ||
            SavedCommandPage.existsCommand(commandCon.text.trim())) {
          return SizedBox.shrink();
        }
        return FilledButton.icon(
          onPressed: () async {
            final text = await showPromptAlertDialog(
              context,
              'Untitled',
              title: 'Command Title',
              confirmText: 'Save Command',
            );
            if (text == null) return;
            // print(text);

            SavedCommandPage.saveNotExists(
              .new(title: text, command: commandCon.text.trim()),
            );
          },
          label: Text('Save Command'),
        );
      },
    );
  }

  Container _commandResultWidget() {
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: .start,
        children: [
          Text(
            'FFMpeg Result',
            style: TextStyle(
              fontWeight: .w600,
              fontSize: 18,
              color: col.onSurface,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: commandResultNoti,
            builder: (context, value, child) {
              return SelectableText(
                commandResult,
                style: TextStyle(
                  color: col.onSurfaceVariant,
                  fontWeight: .w400,
                  fontSize: 13,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget get chooseMediaFileWidget {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Material(
          color: col.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: col.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.file_present_outlined,
                    size: 40,
                    color: col.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose a Media File',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a media file to extract and convert its',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: col.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: chooseMediaFile,
                  icon: const Icon(Icons.folder_open_outlined),
                  label: const Text('Choose Media File'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
