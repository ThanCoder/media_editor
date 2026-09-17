import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/platforms/pages/audio_to_audio.dart';
import 'package:media_editor/platforms/pages/command_list_editor/template/command_list_editor_template_page.dart';
import 'package:media_editor/platforms/pages/command_pages/ffmpeg_command_page.dart';
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
      body: SingleChildScrollView(child: _body()),
    );
  }

  Widget _body() {
    // final col = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        spacing: 8,
        mainAxisAlignment: .center,
        children: [
          _actionCard(
            icon: Icons.video_file_outlined,
            title: 'Video To Audio',
            subtitle: 'Convert video files to audio',
            onTap: () {
              context.pushMaterialPageRoute(
                builder: (mainCtx) => VideoToAudioPage(),
              );
            },
          ),
          _actionCard(
            icon: Icons.audio_file_outlined,
            title: 'Audio To Audio',
            subtitle: 'Convert audio files to audio',
            onTap: () {
              context.pushMaterialPageRoute(
                builder: (mainCtx) => AudioToAudio(),
              );
            },
          ),

          _actionCard(
            icon: Icons.terminal_outlined,
            title: 'Custom Command',
            subtitle: 'Build your own FFmpeg command',
            onTap: () {
              context.pushMaterialPageRoute(
                builder: (mainCtx) => FfmpegCommandPage(),
              );
            },
          ),

          _actionCard(
            icon: Icons.account_tree_outlined,
            title: 'Block List Editor',
            subtitle: 'Create and manage command blocks',
            onTap: () {
              context.pushMaterialPageRoute(
                builder: (mainCtx) => CommandListEditorTemplatePage(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final col = Theme.of(context).colorScheme;

    return SizedBox(
      width: 420,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: col.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: col.onPrimaryContainer),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: col.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.chevron_right, color: col.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
