import 'package:flutter/material.dart';
import 'package:media_editor/platforms/components/forms/input_text.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_list_editor_template.dart';
import 'package:t_widgets/t_widgets.dart';

class TemplateSaveDialog extends StatefulWidget {
  const new({super.key, required this.template});
  final CommandListEditorTemplate template;

  @override
  State<TemplateSaveDialog> createState() => _TemplateSaveDialogState();
}

class _TemplateSaveDialogState extends State<TemplateSaveDialog> {
  final titleCon = TextEditingController();
  final descCon = TextEditingController();
  @override
  void initState() {
    titleCon.text = widget.template.title;
    descCon.text = widget.template.desc;
    super.initState();
  }

  @override
  void dispose() {
    titleCon.dispose();
    descCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text('Save Template'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              InputText(
                controller: titleCon,
                label: Text('Title'),
                maxLines: 1,
              ),
              InputText(
                controller: descCon,
                label: Text('Description'),
                maxLines: null,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text('Close'),
        ),
        FilledButton(
          onPressed: () {
            context.pop<CommandListEditorTemplate>(
              widget.template.copyWith(
                title: titleCon.text,
                desc: descCon.text,
              ),
            );
          },
          child: Text('New'),
        ),
      ],
    );
  }
}
