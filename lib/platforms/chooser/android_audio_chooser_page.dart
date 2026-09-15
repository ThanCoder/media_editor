import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

class AndroidAudioChooserPage extends StatefulWidget {
  const new({super.key, required this.cachePath});
  final String cachePath;

  @override
  State<AndroidAudioChooserPage> createState() =>
      _AndroidAudioChooserPageState();
}

class _AndroidAudioChooserPageState extends State<AndroidAudioChooserPage> {
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
    list = await pkg.fetchAudio();
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
      appBar: AppBar(title: Text('Pick Audio')),
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
          sliver: SliverList.separated(
            itemCount: resList.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
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
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: .circular(15),
          color: col.surfaceContainer,
        ),
        child: Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          spacing: 5,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.audio_file, size: 40),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 5,
                children: [
                  Text(
                    file.name.onlyName,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                  Wrap(
                    spacing: 4,
                    children: [
                      _wrapItem(file.name.extName.upper),
                      _wrapItem(file.duration.formatTimeLable()),
                      _wrapItem(file.dateModified.formatTimeAgo()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wrapItem(String text) {
    if (text.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      padding: .symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color: col.primary,
        borderRadius: .circular(15),
      ),
      child: Text(text, style: TextStyle(color: col.onPrimary)),
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
