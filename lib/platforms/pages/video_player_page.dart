import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';

class VideoPlayerPage extends StatefulWidget {
  const new({super.key, required this.path});
  final String path;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  FFplaySurface? _surface;
  bool _hasVideo = false;
  int _videoWidth = 0;
  int _videoHeight = 0;
  double _playbackPosition = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPlayback());
  }

  @override
  void dispose() {
    if (FFplayKit.isPlaying()) {
      FFplayKit.pause();
    }
    FFplayKit.close();
    _surface?.release();
    super.dispose();
  }

  FFplaySession? session;

  Future<void> _startPlayback() async {
    // Create surface before starting playback
    _surface = await FFplaySurface.create();

    session = await FFplayKit.executeAsync('-i "${widget.path}"');

    // Listen for video dimensions
    session?.videoSizeStream.listen((size) {
      final (width, height) = size;
      if (mounted && width > 0 && height > 0) {
        setState(() {
          _videoWidth = width;
          _videoHeight = height;
          _hasVideo = true;
        });
      }
    });
    session?.setVolume(1);

    // Listen for position updates
    session?.positionStream.listen((position) {
      if (mounted) {
        setState(() => _playbackPosition = position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_hasVideo && _surface != null)
              SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: _videoWidth / _videoHeight,
                  child: _surface!.toWidget(),
                ),
              ),

            Row(
              children: [
                IconButton(
                  onPressed: () => FFplayKit.pause(),
                  icon: Icon(Icons.pause),
                ),
                IconButton(
                  onPressed: () => FFplayKit.resume(),
                  icon: Icon(Icons.play_arrow),
                ),
                Expanded(
                  child: Slider(
                    value:
                        _playbackPosition /
                        (FFplayKit.duration > 0 ? FFplayKit.duration : 1.0),
                    onChanged: (value) =>
                        FFplayKit.seek(value * FFplayKit.duration),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
