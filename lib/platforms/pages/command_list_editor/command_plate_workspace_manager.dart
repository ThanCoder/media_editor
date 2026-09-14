// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';

import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/core/utils/ffmpeg_utils.dart';
import 'package:media_editor/platforms/chooser/video_chooser.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/prompt_alert_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/duration_slider_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/start_end_range_slider_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_block.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_plate.dart';

class CommandPlateWorkspaceManager {
  final BuildContext context;
  final CommandPlate plate;
  final CommandPlateItem item;
  final List<CommandBlock> blocks;
  const CommandPlateWorkspaceManager({
    required this.context,
    required this.plate,
    required this.item,
    required this.blocks,
  });

  Future<void> run() async {
    // input
    if (plate.type == .input) {
      await _doInput();
      return;
    }
    // output
    if (plate.type == .output) {
      await _doOutpt();
      return;
    }

    if (plate.type == .trim) {
      await _doTrim();
      return;
    }
    _addBlockItemAutoPosition(item);
  }

  void _addBlockItemAutoPosition(CommandPlateItem itm) {
    // check output block
    if (blocks.isNotEmpty) {
      final outputIndex = blocks.indexWhere((e) => e.type == .output);
      if (outputIndex != -1) {
        // final outputBlock = blocks[outputIndex];
        blocks.insert(
          outputIndex,
          .new(
            id: itm.id,
            type: plate.type,
            title: itm.title,
            command: itm.command,
            desc: itm.desc,
          ),
        );

        return;
      }
    }

    blocks.add(
      .new(
        id: itm.id,
        type: plate.type,
        title: itm.title,
        command: itm.command,
        desc: itm.desc,
      ),
    );
  }

  Future<void> _doInput() async {
    if (item.id == 'Input-Video-File') {
      final path = await chooseVideoFromPlatform(context);
      if (path == null) return;
      blocks.add(
        .new(
          id: 'Input-Video-File',
          type: plate.type,
          title: item.title,
          command: '-i "$path"',
          source: path,
          desc: item.desc,
        ),
      );

      return;
    }
    if (item.id == 'Input-Audio-File') {
      final path = await chooseMediaFileFromPlatform(context, type: .audio);
      if (path == null) return;
      blocks.add(
        .new(
          id: 'Input-Video-File',
          type: plate.type,
          title: item.title,
          command: '-i "$path"',
          desc: item.desc,
        ),
      );
      return;
    }
  }

  Future<void> _doOutpt() async {
    if (item.id == 'Output-File') {
      final outpath = AppUtils.instance.getPlatfromDownloadPath();
      final name = await showPromptAlertDialog(context, 'filename');
      if (name == null) return;
      blocks.add(
        .new(
          id: item.id,
          type: plate.type,
          title: item.title,
          command: '"${outpath.join(name)}"',
          source: outpath.join(name),
          desc: item.desc,
        ),
      );

      return;
    }
  }

  Future<void> _doTrim() async {
    if (item.id == 'start-end-time') {
      final dur = await _getDurationFromInput();
      if (dur == null) {
        if (!context.mounted) return;
        showErrorDialog(context, 'Input File မှာ Duration မရှိပါ!');
        return;
      }
      final end = dur.inSeconds.toDouble();
      if (!context.mounted) return;
      final range = await showDialog<RangeValues>(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            StartEndRangeSliderDialog(min: 0, max: end, values: .new(0, end)),
      );
      if (range == null) return;
      _addBlockItemAutoPosition(
        .new(
          id: item.id,
          title: item.title,
          desc: item.desc,
          command: '-ss ${range.start} -to ${range.end}',
        ),
      );
      return;
    }

    if (item.id == 'start-time') {
      final dur = await _getDurationFromInput();
      if (dur == null) {
        if (!context.mounted) return;
        showErrorDialog(context, 'Input File မှာ Duration မရှိပါ!');
        return;
      }
      final end = dur.inSeconds.toDouble();
      if (!context.mounted) return;
      final value = await showDialog<double>(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            DurationSliderDialog(max: end, value: 0, title: 'Start Position'),
      );
      if (value == null) return;
      _addBlockItemAutoPosition(
        .new(
          id: item.id,
          title: item.title,
          desc: item.desc,
          command: '-ss $value',
        ),
      );
      return;
    }
    if (item.id == 'duration') {
      final dur = await _getDurationFromInput();
      if (dur == null) {
        if (!context.mounted) return;
        showErrorDialog(context, 'Input File မှာ Duration မရှိပါ!');
        return;
      }
      final end = dur.inSeconds.toDouble();
      if (!context.mounted) return;
      final value = await showDialog<double>(
        context: context,
        barrierDismissible: false,
        builder: (context) => DurationSliderDialog(
          max: end,
          value: 0,
          title: 'Duration Position',
        ),
      );
      if (value == null) return;
      _addBlockItemAutoPosition(
        .new(
          id: item.id,
          title: item.title,
          desc: item.desc,
          command: '-t $value',
        ),
      );
      return;
    }

    if (item.id == 'End-Time') {
      final dur = await _getDurationFromInput();
      if (dur == null) {
        if (!context.mounted) return;
        showErrorDialog(context, 'Input File မှာ Duration မရှိပါ!');
        return;
      }
      final end = dur.inSeconds.toDouble();
      if (!context.mounted) return;
      final value = await showDialog<double>(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            DurationSliderDialog(max: end, value: 0, title: 'End Position'),
      );
      if (value == null) return;
      _addBlockItemAutoPosition(
        .new(
          id: item.id,
          title: item.title,
          desc: item.desc,
          command: '-to $value',
        ),
      );
      return;
    }

    _addBlockItemAutoPosition(
      .new(
        id: item.id,
        title: item.title,
        desc: item.desc,
        command: item.command,
      ),
    );
  }

  Future<Duration?> _getDurationFromInput() async {
    final inputIndex = blocks.indexWhere((e) => e.type == .input);
    if (inputIndex == -1) {
      showErrorDialog(context, 'အနည်းဆုံး Input File တစ်ခုရှိရမယ်!');
      return null;
    }
    final info = await FfmpegUtils.getInfo(blocks[inputIndex].source);
    if (info == null) {
      if (!context.mounted) return null;
      showErrorDialog(
        context,
        'Input File ကနေ Duration ထုတ်လို့မရဖြစ်နေပါတယ်!',
      );
      return null;
    }
    return info.duration;
  }
}
