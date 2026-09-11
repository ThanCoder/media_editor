import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';

class InfoWidget extends StatefulWidget {
  const new({super.key, this.path});
  final String? path;

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  @override
  void initState() {
    if (widget.path != null) {
      reqVideoInfo();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InfoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      if (widget.path != null) {
        reqVideoInfo();
      }
    }
  }

  List<String> infoList = [];
  void reqVideoInfo() async {
    try {
      await FFprobeKit.getMediaInformationAsync(
        widget.path!,
        onComplete: (session) {
          final info = session.getMediaInformation();
          if (info == null) return;

          infoList.clear();
          final dur = info.duration;
          if (dur != null) {
            final videoDuration = Duration(seconds: double.parse(dur).toInt());
            // rangeStart = 0;
            // rangeEnd = videoDuration!.inMilliseconds.toDouble();
            infoList.add("Duration: ${videoDuration.formatTimeLable()}");
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

  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    if (widget.path == null) {
      return SizedBox.shrink();
    }
    return _infoWidget;
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
              Icon(Icons.file_present_outlined, color: col.primary),
              const SizedBox(width: 8),
              Text(
                'Media Information',
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
}
