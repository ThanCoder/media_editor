import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class SliderDialog extends StatefulWidget {
  const new({
    super.key,
    required this.max,
    required this.value,
    required this.title,
    this.headerWiget,
    this.valueWidget,
  });
  final double max;
  final double value;
  final String title;
  final Widget? headerWiget;
  final Widget Function(double value)? valueWidget;

  @override
  State<SliderDialog> createState() => _SliderDialogState();
}

class _SliderDialogState extends State<SliderDialog> {
  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  late double value;

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
          if (widget.headerWiget != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.headerWiget,
              // Text(
              //   'Max: ${widget.max.toStringAsFixed(2)}',
              //   style: TextStyle(fontWeight: .w600),
              // ),
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
          if (widget.valueWidget != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  widget.valueWidget!(value),
                  // Text('Value: ${value.toStringAsFixed(2)}')
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
            context.pop<double>(value);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
