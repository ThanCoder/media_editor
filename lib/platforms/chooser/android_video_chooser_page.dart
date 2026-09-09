import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

class AndroidVideoChooserPage extends StatefulWidget {
  const new({super.key, required this.cachePath});
  final String cachePath;

  @override
  State<AndroidVideoChooserPage> createState() =>
      _AndroidVideoChooserPageState();
}

class _AndroidVideoChooserPageState extends State<AndroidVideoChooserPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  final pkg = ThanPkgAndroid.getInstance.mediaSelector;

  List<MediaFile> list = [];
  Future<void> init() async {
    list = await pkg.fetchVideos();
    list.sortDate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick Video')),
      body: RefreshIndicator.adaptive(onRefresh: init, child: body),
    );
  }

  Widget get body {
    return GridView.builder(
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 220,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) => _listItem(list[index]),
    );
  }

  Widget _listItem(MediaFile file) {
    return InkWell(
      onTap: () {
        context.pop<String>(file.path);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: VideoThumbnail(file: file, cachePath: widget.cachePath),
            ),
            Text(file.name),
          ],
        ),
      ),
    );
  }
}

class VideoThumbnail extends StatelessWidget {
  new({super.key, required this.file, required this.cachePath});

  final MediaFile file;
  final String cachePath;

  final videoPkg = ThanPkgAndroid.getInstance.videoHandler;

  late final cacheFile = File(cachePath.join(file.name));

  // @override
  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: .circular(10), child: body);
  }

  Widget get body {
    if (cacheFile.existsSync()) {
      return Image.file(
        cacheFile,
        fit: .cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => Text('Err'),
      );
    }
    return FutureBuilder(
      future: videoPkg.saveThumbnail(file.path, cacheFile.path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return Image.file(
          cacheFile,
          fit: .cover,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => Text('Err'),
        );
      },
    );
  }
}

extension MediaFileExt on List<MediaFile> {
  void sortDate({bool newest = true}) {
    sort((a, b) {
      if (newest) {
        return b.dateAdded.compareTo(a.dateAdded);
      }
      return a.dateAdded.compareTo(b.dateAdded);
    });
  }
}
