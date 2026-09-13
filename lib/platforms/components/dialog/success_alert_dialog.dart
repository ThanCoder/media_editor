import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

void showSuccessDialog(BuildContext context, String message, {String? title}) {
  showDialog(
    context: context,
    builder: (context) => SuccessAlertDialog(message: message, title: title),
  );
}

class SuccessAlertDialog extends StatelessWidget {
  const SuccessAlertDialog({super.key, required this.message, this.title});
  final String message;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;

    return AlertDialog.adaptive(
      scrollable: true,
      title: Text(title ?? 'Success', style: TextStyle(color: col.primary)),
      backgroundColor: col.surfaceContainer,
      content: SelectableText(
        message,
        style: TextStyle(color: col.onSurfaceVariant),
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: col.primary,
            foregroundColor: col.onPrimary,
          ),
          onPressed: () {
            context.pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
