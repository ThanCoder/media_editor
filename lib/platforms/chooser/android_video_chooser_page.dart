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
  Map<String, List<MediaFile>> parentList = {};
  String currentParent = 'All';
  Future<void> init() async {
    list = await pkg.fetchVideos();
    list.sortDate();
    parentList.clear();

    for (var file in list) {
      parentList
          .putIfAbsent(file.path.pathBuf.parent.fileName, () => [])
          .add(file);
    }
    setState(() {});
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick Video')),
      body: RefreshIndicator.adaptive(onRefresh: init, child: body),
    );
  }

  Widget get body {
    var resList = list;
    if (currentParent == 'All') {
      resList = list;
    } else {
      resList = parentList[currentParent] ?? [];
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _chooserWidget),
        SliverPadding(
          padding: .symmetric(vertical: 10, horizontal: 12),
          sliver: SliverGrid.builder(
            itemCount: resList.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisExtent: 220,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) => _listItem(resList[index]),
          ),
        ),
      ],
    );
  }

  Widget get _chooserWidget {
    return Padding(
      padding: .symmetric(vertical: 8, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(15),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: .circular(15),
            padding: .symmetric(vertical: 8, horizontal: 10),
            dropdownColor: col.surfaceContainer,
            value: currentParent,
            items: [
              DropdownMenuItem<String>(value: 'All', child: Text('All')),
              ...parentList.entries.map(
                (e) => DropdownMenuItem<String>(
                  value: e.key,
                  child: Text('${e.key.capitalize} ${e.value.length}'),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                currentParent = value!;
              });
            },
          ),
        ),
      ),
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
            Text(
              file.name,
              maxLines: 2,
              overflow: .ellipsis,
              textAlign: .center,
              style: TextStyle(fontSize: 12),
            ),
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
