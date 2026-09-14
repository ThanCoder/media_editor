import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class DurationSliderDialog extends StatefulWidget {
  const new({
    super.key,
    required this.max,
    required this.value,
    required this.title,
  });
  final double max;
  final double value;
  final String title;

  @override
  State<DurationSliderDialog> createState() => _DurationSliderDialogState();
}

class _DurationSliderDialogState extends State<DurationSliderDialog> {
  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  late double value;
  String getDurationLable(int sec) {
    if (sec == 0) return '0';
    return Duration(seconds: sec).formatClockLabel();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      contentPadding: .symmetric(vertical: 5, horizontal: 2),
      title: Text(widget.title),
      content: Column(
        spacing: 5,
        crossAxisAlignment: .start,
        children: [
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Duration: ${getDurationLable(widget.max.toInt())}',
              style: TextStyle(fontWeight: .w600),
            ),
          ),
          Slider.adaptive(
            min: 0,
            max: widget.max,
            value: value,
            onChanged: (value) {
              setState(() {
                this.value = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('Value: ${getDurationLable(value.toInt())}')],
            ),
          ),
        ],
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
            context.pop<double>(value);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
