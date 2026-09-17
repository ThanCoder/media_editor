import 'package:flutter/material.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_block.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_plate.dart';

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
    // if (plate.type == .input) {
    //   await _doInput();
    //   return;
    // }
    // // output
    // if (plate.type == .output) {
    //   await _doOutpt();
    //   return;
    // }

    // if (plate.type == .trim) {
    //   await _doTrim();
    //   return;
    // }
    _addBlockItemAutoPosition(item);
  }

  void _addBlockItemAutoPosition(CommandPlateItem itm) {
    // check output block
    if (blocks.isNotEmpty) {
      // output
      final outputIndex = blocks.indexWhere((e) => e.type == .output);
      if (outputIndex != -1) {
        blocks.insert(
          outputIndex,
          .new(
            id: itm.id,
            type: plate.type,
            title: itm.title,
            command: itm.command,
            desc: itm.desc,
            source: item.source,
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
        source: item.source,
      ),
    );
  }

  // Future<void> _doInput() async {
  //   final inputIndex = blocks.indexWhere((e) => e.type == .input);
  //   if (item.id == 'Input-Video-File') {
  //     final path = await chooseVideoFromPlatform(context);
  //     if (path == null) return;
  //     final bl = CommandBlock(
  //       id: 'Input-Video-File',
  //       type: plate.type,
  //       title: item.title,
  //       command: '-i "$path"',
  //       source: path,
  //       desc: item.desc,
  //     );
  //     if (inputIndex != -1) {
  //       blocks.insert(inputIndex + 1, bl);
  //     } else {
  //       blocks.insert(0, bl);
  //     }

  //     return;
  //   }
  //   if (item.id == 'Input-Audio-File') {
  //     final path = await chooseMediaFileFromPlatform(context, type: .audio);
  //     if (path == null) return;
  //     final bl = CommandBlock(
  //       id: 'Input-Video-File',
  //       type: plate.type,
  //       title: item.title,
  //       command: '-i "$path"',
  //       desc: item.desc,
  //       source: path,
  //     );
  //     if (inputIndex != -1) {
  //       blocks.insert(inputIndex + 1, bl);
  //     } else {
  //       blocks.insert(0, bl);
  //     }
  //     return;
  //   }
  // }

  // Future<void> _doOutpt() async {
  //   if (item.id == 'output') {
  //     final outpath = AppUtils.instance.getPlatfromDownloadPath();
  //     final name = await showPromptAlertDialog(context, 'filename');
  //     if (name == null) return;
  //     blocks.add(
  //       .new(
  //         id: item.id,
  //         type: plate.type,
  //         title: item.title,
  //         command: '"${outpath.join(name)}"',
  //         source: outpath.join(name),
  //         desc: item.desc,
  //       ),
  //     );

  //     return;
  //   }
  //   _addBlockItemAutoPosition(
  //     .new(
  //       id: item.id,
  //       title: item.title,
  //       desc: item.desc,
  //       command: item.command,
  //     ),
  //   );
  // }

  // Future<void> _doTrim() async {
  //   if (item.id == 'start-end-time') {
  //     final dur = await _getDurationFromInput();
  //     if (dur == null) return;
  //     final end = dur.inSeconds.toDouble();
  //     if (!context.mounted) return;
  //     final range = await showDialog<RangeValues>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) =>
  //           StartEndRangeSliderDialog(min: 0, max: end, values: .new(0, end)),
  //     );
  //     if (range == null) return;
  //     _addBlockItemAutoPosition(
  //       .new(
  //         id: item.id,
  //         title: item.title,
  //         desc: item.desc,
  //         command: '-ss ${range.start} -to ${range.end}',
  //       ),
  //     );
  //     return;
  //   }

  //   if (item.id == 'start-time') {
  //     final dur = await _getDurationFromInput();
  //     if (dur == null) return;
  //     final end = dur.inSeconds.toDouble();
  //     if (!context.mounted) return;
  //     final value = await showDialog<double>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) =>
  //           DurationSliderDialog(max: end, value: 0, title: 'Start Position'),
  //     );
  //     if (value == null) return;
  //     _addBlockItemAutoPosition(
  //       .new(
  //         id: item.id,
  //         title: item.title,
  //         desc: item.desc,
  //         command: '-ss $value',
  //         source: value.toString(),
  //       ),
  //     );
  //     return;
  //   }
  //   if (item.id == 'duration') {
  //     final dur = await _getDurationFromInput();
  //     if (dur == null) return;
  //     final end = dur.inSeconds.toDouble();
  //     if (!context.mounted) return;
  //     final value = await showDialog<double>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => DurationSliderDialog(
  //         max: end,
  //         value: 0,
  //         title: 'Duration Position',
  //       ),
  //     );
  //     if (value == null) return;
  //     _addBlockItemAutoPosition(
  //       .new(
  //         id: item.id,
  //         title: item.title,
  //         desc: item.desc,
  //         command: '-t $value',
  //         source: value.toString(),
  //       ),
  //     );
  //     return;
  //   }

  //   if (item.id == 'End-Time') {
  //     final dur = await _getDurationFromInput();
  //     if (dur == null) return;
  //     final end = dur.inSeconds.toDouble();
  //     if (!context.mounted) return;
  //     final value = await showDialog<double>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) =>
  //           DurationSliderDialog(max: end, value: 0, title: 'End Position'),
  //     );
  //     if (value == null) return;
  //     _addBlockItemAutoPosition(
  //       .new(
  //         id: item.id,
  //         title: item.title,
  //         desc: item.desc,
  //         command: '-to $value',
  //         source: value.toString(),
  //       ),
  //     );
  //     return;
  //   }

  //   _addBlockItemAutoPosition(
  //     .new(
  //       id: item.id,
  //       title: item.title,
  //       desc: item.desc,
  //       command: item.command,
  //     ),
  //   );
  // }
}
