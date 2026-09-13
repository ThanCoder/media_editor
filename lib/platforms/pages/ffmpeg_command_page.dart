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
import 'package:media_editor/platforms/pages/command_editor_page.dart';
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
  final commandResultCon = TextEditingController();
  final commandResultNoti = ValueNotifier('');
  final commandFocus = FocusNode();
  final nameFocus = FocusNode();

  @override
  dispose() {
    nameCon.dispose();
    commandCon.dispose();
    commandResultCon.dispose();
    commandFocus.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  void clearFocus() {
    nameFocus.unfocus();
    commandFocus.unfocus();
  }

  void chooseVideoFile() async {
    try {
      inputPath = await chooseMediaFileFromPlatform(
        context,
        dialogTitle: 'Choose Video File',
        type: .video,
      );
      if (inputPath == null) return;
      nameCon.text = inputPath!.getName(withExt: false);
      commandChanged('');
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  void chooseAudioFile() async {
    try {
      inputPath = await chooseMediaFileFromPlatform(
        context,
        dialogTitle: 'Choose Audio File',
        type: .audio,
      );
      if (inputPath == null) return;
      nameCon.text = inputPath!.getName(withExt: false);
      commandChanged('');
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  Future<void> process() async {
    final command = commandResultCon.text;
    if (command.isEmpty) return;
    context.pushMaterialPageRoute(
      builder: (mainCtx) => FfmpegProcessPage(command: command),
    );
  }

  Future<void> goFavCommand() async {
    final res = await context.pushMaterialPageRoute<String>(
      builder: (mainCtx) => CustomCommandPage(),
    );
    if (res == null) return;
    commandCon.text = '${commandCon.text} $res';
    commandChanged(res);
    setState(() {});
  }

  void commandChanged(String val) {
    commandResultCon.text = commandResult;
    commandResultNoti.value = val;
  }

  void editCommandWithEditor() async {
    final res = await context.pushMaterialPageRoute<String>(
      builder: (mainCtx) => CommandEditorPage(text: commandResultCon.text),
    );
    if (res == null) return;
    commandResultCon.text = res;
    if (!mounted) return;
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
              style: IconButton.styleFrom(
                backgroundColor: col.errorContainer,
                foregroundColor: col.onErrorContainer,
              ),
              onPressed: () {
                setState(() {
                  inputPath = null;
                });
              },
              icon: Icon(Icons.clear_all_outlined),
            ),
          SizedBox(width: 10),
        ],
      ),
      body: inputPath == null
          ? chooseMediaFileWidget
          : SingleChildScrollView(
              child: Column(
                children: [
                  InfoWidget(path: inputPath),
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
            focusNode: nameFocus,
            label: Text('Output Name'),
            maxLines: 1,
            onChanged: commandChanged,
            onTapOutside: (event) {
              clearFocus();
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
          focusNode: commandFocus,
          label: Text('FFMpeg Command'),
          maxLines: null,
          onChanged: commandChanged,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear_all_outlined),
            onPressed: () {
              commandCon.clear();
              commandChanged('');
            },
          ),
          onTapOutside: (event) {
            clearFocus();
          },
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
          Row(
            children: [
              Text(
                'FFMpeg Result',
                style: TextStyle(
                  fontWeight: .w600,
                  fontSize: 18,
                  color: col.onSurface,
                ),
              ),
              Spacer(),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: col.primary,
                  foregroundColor: col.onPrimary,
                ),
                onPressed: editCommandWithEditor,
                icon: Icon(Icons.edit_document),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: commandResultNoti,
            builder: (context, value, child) {
              return Text(
                commandResultCon.text,
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
                  onPressed: chooseVideoFile,
                  icon: const Icon(Icons.video_file_outlined),
                  label: const Text('Choose Video File'),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: chooseAudioFile,
                  icon: const Icon(Icons.audio_file_outlined),
                  label: const Text('Choose Audio File'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
