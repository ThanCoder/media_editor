import 'package:flutter/material.dart';
import 'package:media_editor/platforms/chooser/video_chooser.dart';
import 'package:media_editor/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/components/forms/input_text.dart';
import 'package:media_editor/platforms/pages/command_pages/custom_command_page.dart';
import 'package:t_widgets/t_widgets.dart';

class CommandEditorPage extends StatefulWidget {
  const new({super.key, required this.text});
  final String text;

  @override
  State<CommandEditorPage> createState() => _CommandEditorPageState();
}

class _CommandEditorPageState extends State<CommandEditorPage> {
  @override
  void initState() {
    controller.text = widget.text;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  final controller = TextEditingController();
  bool isChanged = false;
  double fontSize = 14;
  final focusNode = FocusNode();

  Future<void> goCustomCommand() async {
    final res = await context.pushMaterialPageRoute<String>(
      builder: (mainCtx) => CustomCommandPage(),
    );
    if (res == null) return;
    insertAtCursor(res);
    // commandChanged(res);
    setState(() {});
  }

  void chooseVideoFile() async {
    try {
      final inputPath = await chooseMediaFileFromPlatform(
        context,
        dialogTitle: 'Choose Video File',
        type: .video,
      );
      if (inputPath == null) return;
      insertAtCursor(inputPath);

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  void chooseAudioFile() async {
    try {
      final inputPath = await chooseMediaFileFromPlatform(
        context,
        dialogTitle: 'Choose Audio File',
        type: .audio,
      );
      if (inputPath == null) return;
      insertAtCursor(inputPath);
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  void insertAtCursor(String text) {
    final selection = controller.selection;

    final start = selection.start;
    final end = selection.end;

    if (start < 0 || end < 0) {
      controller.text += text;
      return;
    }

    final newText = controller.text.replaceRange(start, end, text);

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + text.length),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!isChanged) {
          context.pop();
          return;
        }
        final conf = await showConfirmDialog(
          context,
          'Want To Save?',
          confirmText: 'Save',
          closeText: 'No',
        );
        if (!conf) {
          if (!context.mounted) return;
          context.pop();
          return;
        }

        if (!context.mounted) return;
        context.pop<String>(controller.text);
      },
      child: Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(8.0), child: _body()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pop<String>(controller.text);
          },
          child: Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }

  AppBar _appbar() => AppBar(
    title: Text('Command Edtior'),
    actions: [
      IconButton(
        style: IconButton.styleFrom(
          backgroundColor: col.tertiary,
          foregroundColor: col.onTertiary,
        ),
        onPressed: () {
          setState(() {
            fontSize--;
          });
        },
        icon: Icon(Icons.zoom_out_outlined),
      ),
      SizedBox(width: 10),
      IconButton(
        style: IconButton.styleFrom(
          backgroundColor: col.tertiary,
          foregroundColor: col.onTertiary,
        ),
        onPressed: () {
          setState(() {
            fontSize++;
          });
        },
        icon: Icon(Icons.zoom_in_outlined),
      ),
      SizedBox(width: 10),
    ],
  );

  Column _body() {
    return Column(
      crossAxisAlignment: .start,
      spacing: 10,
      children: [
        InputText(
          controller: controller,
          maxLines: null,
          focusNode: focusNode,
          style: TextStyle(fontSize: fontSize),
          label: Text('Command'),
          onChanged: (val) {
            if (!isChanged) {
              setState(() {
                isChanged = true;
              });
            }
          },
          onTapOutside: (event) {
            focusNode.unfocus();
          },
        ),
        FilledButton.icon(
          onPressed: goCustomCommand,
          label: Text('Custom Commands'),
        ),
        FilledButton.icon(
          onPressed: chooseVideoFile,
          icon: const Icon(Icons.video_file_outlined),
          label: const Text('Choose Video File'),
        ),
        FilledButton.icon(
          onPressed: chooseAudioFile,
          icon: const Icon(Icons.audio_file_outlined),
          label: const Text('Choose Audio File'),
        ),
      ],
    );
  }
}
