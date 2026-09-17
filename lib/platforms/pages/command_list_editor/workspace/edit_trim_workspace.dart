import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/ffmpeg_utils.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/dialog/slider_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/dialog/start_end_range_slider_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/workspace/i_workspace.dart';

class EditTrimWorkspace extends IWorkspace {
  new({
    required super.context,
    required super.blocks,
    required super.block,
    required super.index,
  });

  @override
  Future<void> run() async {
    final inputIndex = blocks.indexWhere((e) => e.type == .input);
    if (inputIndex == -1) {
      showErrorDialog(context, 'At least one input file is required!');
      return;
    }
    final info = await FfmpegUtils.getInfo(blocks[inputIndex].source);
    if (!context.mounted) return;
    if (info == null) {
      showErrorDialog(
        context,
        'Failed to get the duration from the input file.!',
      );
      return;
    }
    if (block.id == 'duration') {
      final value = await showDialog<double>(
        context: context,
        builder: (context) => SliderDialog(
          max: info.duration!.inSeconds.toDouble(),
          value: double.tryParse(block.source) ?? 0,
          title: 'Duration',
          headerWiget: Text('Duration: ${info.duration!.formatClockLabel()}'),
          valueWidget: (value) => Text(
            'Seconds: ${Duration(seconds: value.toInt()).formatClockLabel()}',
          ),
        ),
      );
      if (value == null) return;
      blocks[index] = block.copyWith(
        command: '-t $value',
        source: value.toString(),
      );
      if (!context.mounted) return;
      return;
    }
    if (block.id == 'start-time') {
      final value = await showDialog<double>(
        context: context,
        builder: (context) => SliderDialog(
          max: info.duration!.inSeconds.toDouble(),
          value: double.tryParse(block.source) ?? 0,
          title: 'Start Duration',
          headerWiget: Text('Duration: ${info.duration!.formatClockLabel()}'),
          valueWidget: (value) => Text(
            'Seconds: ${Duration(seconds: value.toInt()).formatClockLabel()}',
          ),
        ),
      );
      if (value == null) return;
      blocks[index] = block.copyWith(
        command: '-ss $value',
        source: value.toString(),
      );
      return;
    }
    if (block.id == 'End-Time') {
      final value = await showDialog<double>(
        context: context,
        builder: (context) => SliderDialog(
          max: info.duration!.inSeconds.toDouble(),
          value: double.tryParse(block.source) ?? 0,
          title: 'End Duration',
          headerWiget: Text('Duration: ${info.duration!.formatClockLabel()}'),
          valueWidget: (value) => Text(
            'Seconds: ${Duration(seconds: value.toInt()).formatClockLabel()}',
          ),
        ),
      );
      if (value == null) return;
      blocks[index] = block.copyWith(
        command: '-to $value',
        source: value.toString(),
      );
      if (!context.mounted) return;
    }
    if (block.id == 'start-end-time') {
      final dur = await _getDurationFromInput();
      if (dur == null) return;
      final end = dur.inSeconds.toDouble();
      if (!context.mounted) return;
      RangeValues values = RangeValues(0, end);
      if (block.source.isNotEmpty) {
        final parts = block.source.split('-');
        if (parts.length == 2) {
          values = .new(
            double.tryParse(parts.first) ?? 0,
            double.tryParse(parts.last) ?? end,
          );
        }
      }
      final range = await showDialog<RangeValues>(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            StartEndRangeSliderDialog(min: 0, max: end, values: values),
      );
      if (range == null) return;
      blocks[index] = block.copyWith(
        command: '-ss ${range.start} -to ${range.end}',
        source: '${range.start}-${range.end}',
      );
      return;
    }
  }

  Future<Duration?> _getDurationFromInput() async {
    final inputIndex = blocks.indexWhere((e) => e.type == .input);
    if (inputIndex == -1) {
      showErrorDialog(context, 'At least one input file is required!');
      return null;
    }
    final info = await FfmpegUtils.getInfo(blocks[inputIndex].source);
    if (info == null) {
      if (!context.mounted) return null;
      showErrorDialog(
        context,
        'Failed to get the duration from the input file.!',
      );
      return null;
    }
    return info.duration;
  }
}
