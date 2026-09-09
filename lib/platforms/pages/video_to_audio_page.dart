import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/types/audio_output_format.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/platforms/chooser/video_chooser.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/components/forms/input_text.dart';
import 'package:media_editor/platforms/pages/ffmpeg_process_page.dart';
import 'package:t_widgets/t_widgets.dart';

class VideoToAudioPage extends StatefulWidget {
  const VideoToAudioPage({super.key});

  @override
  State<VideoToAudioPage> createState() => _VideoToAudioPageState();
}

class _VideoToAudioPageState extends State<VideoToAudioPage> {
  String? choosedPath;
  //'/home/thancoder/Downloads/New Folder/ceo.hymusic - 7677545356397202696.mp4';
  final nameController = TextEditingController();

  AudioOutputFormat format = .m4a;
  List<String> infoList = [];

  @override
  void initState() {
    if (choosedPath != null) {
      nameController.text = choosedPath!.onlyName;
      reqVideoInfo();
    }

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void chooseVideo() async {
    try {
      choosedPath = await chooseVideoFromPlatform(context);
      if (choosedPath == null) return;
      nameController.text = choosedPath!.onlyName;
      reqVideoInfo();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  void reqVideoInfo() async {
    try {
      await FFprobeKit.getMediaInformationAsync(
        choosedPath!,
        onComplete: (session) {
          final info = session.getMediaInformation();
          if (info != null) {
            infoList.clear();
            final dur = info.duration;
            if (dur != null) {
              infoList.add(
                "Duration: ${Duration(seconds: double.parse(dur).toInt()).formatTimeLable()}",
              );
            }
            infoList.add("bitrate: ${info.bitrate}");
            infoList.add("format: ${info.format}");
            final size = info.size;
            if (size != null) {
              infoList.add("size: ${int.parse(size).fileSizeLabel()}");
            }

            for (var stream in info.streams) {
              infoList.add(
                "Stream type: ${stream.type}, codec: ${stream.codec}",
              );
              // print("Stream type: ${stream.type}, codec: ${stream.codec}");
            }
            if (!mounted) return;
            setState(() {});
          }
        },
      );
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  Future<void> process() async {
    final inputPath = choosedPath!;

    final outputPath = AppUtils.instance.getPlatfromDownloadPath(
      '${nameController.text}.${format.extension}',
    );

    final commands = <String>[
      '-i',
      '"$inputPath"',

      // Video stream မလိုတော့ဘူး
      // '-vn',

      // // Audio codec
      // '-c:a',
      // format.codec,

      // Audio stream
      '-map',
      '0:a:0',

      // Video stream ကို cover art အဖြစ်ယူ
      '-map',
      '0:v:0',

      // Audio
      '-c:a',
      'aac',

      // Cover image
      '-c:v',
      'mjpeg',

      // Video ကို normal video မဟုတ်ဘဲ artwork လို့သတ်မှတ်
      '-disposition:v:0',
      'attached_pic',

      // overwrite output
      '-y',

      '"$outputPath"',
    ];



    context.pushMaterialPageRoute(
      builder: (mainCtx) => FfmpegProcessPage(command: commands.join(' ')),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video To Audio'),
        actions: [
          if (choosedPath != null)
            IconButton(
              onPressed: () {
                setState(() {
                  choosedPath = null;
                });
              },
              icon: Icon(Icons.clear_all_outlined),
            ),
        ],
      ),
      body: choosedPath == null
          ? _chooseVideoWidget
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: .symmetric(vertical: 10, horizontal: 12),
                  sliver: SliverToBoxAdapter(child: _body()),
                ),
              ],
            ),
      floatingActionButton: choosedPath == null
          ? null
          : FloatingActionButton(
              onPressed: process,
              child: Icon(Icons.play_circle_outline_outlined),
            ),
    );
  }

  Widget get _chooseVideoWidget {
    return Center(
      child: FilledButton(
        onPressed: chooseVideo,
        child: Text('Choose Video File'),
      ),
    );
  }

  Widget get _infoWidget {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: infoList
          .map(
            (e) => Container(
              padding: .symmetric(vertical: 4, horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: .circular(15),
                color: col.surfaceContainer,
              ),
              child: Text(e),
            ),
          )
          .toList(),
    );
  }

  Widget _body() {
    return Column(
      spacing: 8,
      children: [
        // info
        _infoWidget,
        InputText(
          controller: nameController,
          maxLines: 1,
          label: Text('Audio Name'),
        ),
        Text('Other Output Format'),
        RadioGroup<AudioOutputFormat>(
          groupValue: format,
          onChanged: (value) {
            setState(() {
              format = value!;
            });
          },
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: AudioOutputFormat.values
                .map(
                  (e) => Row(
                    mainAxisSize: .min,
                    children: [
                      Radio.adaptive(value: e),
                      Text(e.label),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
