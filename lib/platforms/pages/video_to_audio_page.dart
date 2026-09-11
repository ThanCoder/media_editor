import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/ffmpeg_command/audio_bitrate_command.dart';
import 'package:media_editor/core/ffmpeg_command/audio_codec_command.dart';
import 'package:media_editor/core/ffmpeg_command/audio_meta_command.dart';
import 'package:media_editor/core/ffmpeg_command/audio_range_command.dart';
import 'package:media_editor/core/ffmpeg_command/fast_command/all_fast_command.dart';
import 'package:media_editor/core/ffmpeg_command/audio_volume_command.dart';
import 'package:media_editor/core/ffmpeg_command/cover/all_cover_command_x.dart';
import 'package:media_editor/core/ffmpeg_command/ffmpeg_command_builder.dart';
import 'package:media_editor/core/types/audio_format_config.dart';
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
  @override
  void initState() {
    albumController.text = 'Than Media';
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
      titleController.text = choosedPath!.onlyName;
      reqVideoInfo();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  Duration? videoDuration;
  void reqVideoInfo() async {
    try {
      await FFprobeKit.getMediaInformationAsync(
        choosedPath!,
        onComplete: (session) {
          final info = session.getMediaInformation();
          if (info == null) return;

          infoList.clear();
          final dur = info.duration;
          if (dur != null) {
            videoDuration = Duration(seconds: double.parse(dur).toInt());
            rangeStart = 0;
            rangeEnd = videoDuration!.inMilliseconds.toDouble();
            infoList.add("Duration: ${videoDuration!.formatTimeLable()}");
          }
          infoList.add("bitrate: ${info.bitrate}");
          infoList.add("format: ${info.format}");
          final size = info.size;
          if (size != null) {
            infoList.add("size: ${int.parse(size).fileSizeLabel()}");
          }

          for (var stream in info.streams) {
            infoList.add("Stream type: ${stream.type}, codec: ${stream.codec}");
            // print("Stream type: ${stream.type}, codec: ${stream.codec}");
          }
          if (!mounted) return;
          setState(() {});
        },
      );
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  String? choosedPath;
  //'/home/thancoder/Downloads/New Folder/ceo.hymusic - 7677545356397202696.mp4';
  final nameController = TextEditingController();

  AudioOutputFormat format = .m4a;
  List<String> infoList = [];

  int? audioBitrate;

  int? audioChannels;

  int? sampleRate;

  Duration? startTime;
  Duration? endTime;
  bool useMeta = true;
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final albumController = TextEditingController();

  bool useCoverArt = true;
  bool get supportedCoverArt => format.config.supportCoverArt;
  bool fastConvert = true;

  bool useVolume = false;
  double volume = 1.0;

  // range
  bool useRange = false;
  double rangeStart = 0;
  double rangeEnd = 0;

  Future<void> process() async {
    final inputPath = choosedPath!;

    final outputPath = AppUtils.instance.getPlatfromDownloadPath(
      '${nameController.text}.${format.extension}',
    );

    final builder = FfmpegCommandBuilder(
      input: inputPath,
      output: outputPath,
      commands: [
        if (fastConvert)
          format.fastCommand
        else ...[
          format.codecCommand,
          if (useRange && rangeEnd != 0)
            AudioRangeCommand(
              start: Duration(milliseconds: rangeStart.toInt()),
              end: Duration(milliseconds: rangeEnd.toInt()),
            ),

          if (audioBitrate != null) AudioBitrateCommand(audioBitrate!),

          if (useMeta)
            AudioMetadataCommand(
              title: titleController.text,
              artist: artistController.text,
              album: albumController.text,
            ),

          if (useCoverArt) ?format.coverCommand,

          if (useVolume) AudioVolumeCommand(volume),
        ],
      ],
    );
    // print('command: ${builder.command}');
    context.pushMaterialPageRoute(
      builder: (mainCtx) => FfmpegProcessPage(command: builder.command),
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
          : FloatingActionButton.extended(
              onPressed: process,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Convert'),
            ),
    );
  }

  Widget get _chooseVideoWidget {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Material(
          color: col.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: chooseVideo,
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: col.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.video_file_outlined,
                      size: 40,
                      color: col.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Choose a Video',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a video file to extract and convert its audio',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: col.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: chooseVideo,
                    icon: const Icon(Icons.folder_open_outlined),
                    label: const Text('Choose Video File'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _infoWidget {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: col.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.video_file_outlined, color: col.primary),
              const SizedBox(width: 8),
              Text(
                'Video Information',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: infoList
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: col.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoWidget,

        const SizedBox(height: 20),

        Text('Output', style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: col.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              InputText(
                controller: nameController,
                maxLines: 1,
                label: const Text('Audio Name'),
              ),

              const SizedBox(height: 20),

              _outputFormat(),
            ],
          ),
        ),

        ..._fastCommandWidget,
        // range
        ..._rangeWidget,

        // cover art
        ..._converArtWidget,
        ..._volumeWidget,
        ..._metaWidget,

        const SizedBox(height: 20),
        _saveInfoWidget(),
        const SizedBox(height: 90),
      ],
    );
  }

  List<Widget> get _volumeWidget {
    return [
      if (!fastConvert) const SizedBox(height: 10),
      if (!fastConvert)
        SwitchListTile.adaptive(
          shape: RoundedRectangleBorder(borderRadius: .circular(15)),
          tileColor: col.surfaceContainer,
          title: Text('Audio Volume'),
          value: useVolume,
          onChanged: (value) {
            setState(() {
              useVolume = value;
            });
          },
        ),
      if (!fastConvert && useVolume) const SizedBox(height: 8),
      if (!fastConvert && useVolume)
        Container(
          padding: .symmetric(vertical: 5, horizontal: 7),
          decoration: BoxDecoration(
            color: col.surfaceContainer,
            borderRadius: .circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        volume = 1.0;
                      });
                    },
                    icon: Icon(Icons.restart_alt_outlined),
                  ),
                ],
              ),
              Slider(
                min: 0.0,
                max: 3.0,
                value: volume,
                onChanged: (value) {
                  setState(() {
                    volume = value;
                  });
                },
              ),
              Row(
                children: [
                  Text('0%'),
                  Spacer(),
                  Text('${(volume * 100).toInt()}%'),
                  Spacer(),
                  Text('300%'),
                ],
              ),
            ],
          ),
        ),
    ];
  }

  List<Widget> get _rangeWidget {
    return [
      if (videoDuration != null && !fastConvert) const SizedBox(height: 10),
      if (videoDuration != null && !fastConvert)
        SwitchListTile.adaptive(
          shape: RoundedRectangleBorder(borderRadius: .circular(15)),
          tileColor: col.surfaceContainer,
          title: Text('Audio Range'),
          value: useRange,
          onChanged: (value) {
            setState(() {
              useRange = value;
            });
          },
        ),
      if (useRange && !fastConvert) ...[
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: col.surfaceContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              RangeSlider(
                min: 0,
                max: videoDuration!.inMilliseconds.toDouble(),
                values: RangeValues(rangeStart, rangeEnd),
                onChanged: (value) {
                  setState(() {
                    rangeStart = value.start;
                    rangeEnd = value.end;
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(rangeStart)),
                  Text(_formatDuration(rangeEnd)),
                ],
              ),
            ],
          ),
        ),
      ],
    ];
  }

  Widget _outputFormat() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.audio_file_outlined, color: col.primary),
            const SizedBox(width: 8),
            Text(
              'Output Format',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AudioOutputFormat.values.map(_formatTile).toList(),
        ),
      ],
    );
  }

  List<Widget> get _fastCommandWidget {
    return [
      const SizedBox(height: 10),
      // fast command
      SwitchListTile.adaptive(
        shape: RoundedRectangleBorder(borderRadius: .circular(15)),
        tileColor: col.surfaceContainer,
        title: Text('Fast Convert'),
        value: fastConvert,
        onChanged: (value) {
          setState(() {
            fastConvert = value;
          });
        },
      ),
    ];
  }

  List<Widget> get _converArtWidget {
    return [
      if (!fastConvert && supportedCoverArt) const SizedBox(height: 10),
      if (!fastConvert && supportedCoverArt)
        SwitchListTile.adaptive(
          shape: RoundedRectangleBorder(borderRadius: .circular(15)),
          tileColor: col.surfaceContainer,
          title: Text('Add Video Cover Art'),
          value: useCoverArt,
          onChanged: (value) {
            setState(() {
              useCoverArt = value;
            });
          },
        ),
    ];
  }

  List<Widget> get _metaWidget {
    return [
      if (!fastConvert) const SizedBox(height: 10),
      if (!fastConvert)
        SwitchListTile.adaptive(
          shape: RoundedRectangleBorder(borderRadius: .circular(15)),
          tileColor: col.surfaceContainer,
          title: Text('Use Meta'),
          value: useMeta,
          onChanged: (value) {
            setState(() {
              useMeta = value;
            });
          },
        ),
      if (useMeta && !fastConvert)
        Column(
          spacing: 8,
          children: [
            Text('Metadata'),
            SizedBox(height: 10),
            InputText(
              controller: titleController,
              label: Text('Title'),
              maxLines: 1,
            ),
            InputText(
              controller: artistController,
              label: Text('Artist'),
              maxLines: 1,
            ),
            InputText(
              controller: albumController,
              label: Text('Album'),
              maxLines: 1,
            ),
          ],
        ),
    ];
  }

  Widget _formatTile(AudioOutputFormat value) {
    final isSelected = format == value;

    return InkWell(
      onTap: () {
        setState(() {
          format = value;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? col.secondaryContainer : col.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? col.secondary : col.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: isSelected
                  ? col.onSecondaryContainer
                  : col.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              value.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? col.onSecondaryContainer : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _saveInfoWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: col.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: col.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'The audio will be saved as .${format.extension}',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: col.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(double milliseconds) {
    final duration = Duration(milliseconds: milliseconds.round());

    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');

    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    final hours = duration.inHours;

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }
}
