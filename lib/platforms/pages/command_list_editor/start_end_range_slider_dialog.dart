import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class StartEndRangeSliderDialog extends StatefulWidget {
  const new({
    super.key,
    required this.min,
    required this.max,
    required this.values,
  });
  final double min;
  final double max;
  final RangeValues values;

  @override
  State<StartEndRangeSliderDialog> createState() => _StartEndRangeSliderDialogState();
}

class _StartEndRangeSliderDialogState extends State<StartEndRangeSliderDialog> {
  @override
  void initState() {
    values = widget.values;
    super.initState();
  }

  late RangeValues values;

  String getDurationLable(int sec) {
    if (sec == 0) return '0';
    return Duration(seconds: sec).formatClockLabel();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      contentPadding: .symmetric(vertical: 5, horizontal: 2),
      title: Text('RangeSlider'),
      content: Column(
        spacing: 10,
        children: [
          RangeSlider(
            min: widget.min,
            max: widget.max,
            values: values,
            onChanged: (value) {
              setState(() {
                values = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Start: ${getDurationLable(values.start.toInt())}'),
                Spacer(),
                Text('End: ${getDurationLable(values.end.toInt())}'),
              ],
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
            context.pop<RangeValues>(values);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
