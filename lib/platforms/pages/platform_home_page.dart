import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/platforms/pages/ffmpeg_command_page.dart';
import 'package:media_editor/platforms/pages/video_to_audio_page.dart';
import 'package:t_widgets/t_widgets.dart';

class PlatformHomePage extends StatefulWidget {
  const PlatformHomePage({super.key});

  @override
  State<PlatformHomePage> createState() => _PlatformHomePageState();
}

class _PlatformHomePageState extends State<PlatformHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppUtils.instance.appName
              .split('_')
              .map((e) => e.capitalize)
              .join(' '),
        ),
      ),
      body: _buttons(),
    );
  }

  Widget _buttons() {
    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: .center,
        crossAxisAlignment: .center,
        children: [
          FilledButton.icon(
            onPressed: () {
              context.pushMaterialPageRoute(
                builder: (mainCtx) => VideoToAudioPage(),
              );
            },
            icon: Icon(Icons.video_file_outlined),
            label: Text('Video To Audio'),
          ),
          FilledButton.icon(
            onPressed: () {
              context.pushMaterialPageRoute(
                builder: (mainCtx) => FfmpegCommandPage(),
              );
            },
            icon: Icon(Icons.video_file_outlined),
            label: Text('Custom Command'),
          ),
        ],
      ),
    );
  }
}
