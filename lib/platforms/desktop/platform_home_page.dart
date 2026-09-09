import 'package:flutter/material.dart';
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
      appBar: AppBar(title: Text('Desktop')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 12),
            sliver: SliverToBoxAdapter(child: _header()),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Wrap(
      children: [
        FilledButton(
          onPressed: () {
            context.pushMaterialPageRoute(
              builder: (mainCtx) => VideoToAudioPage(),
            );
          },
          child: Text('Video To Audio'),
        ),
      ],
    );
  }
}
