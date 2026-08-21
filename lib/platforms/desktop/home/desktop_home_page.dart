import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:file_type_plus/file_type_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_editor/core/utils/platform_file_picker.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  ColorScheme get col => Theme.of(context).colorScheme;

  void pickFile() async {
    final res = await PlatformFilePicker.pickFile();
    if (res.isErr) {
      if (!mounted) return;
      showErrorDialog(context, res.unwrapError());
      return;
    }

    paths.addAll(res.unwrap());
    setState(() {});
  }

  FileType get currentType {
    return FileType.fromPath(inputController.text);
  }

  List<String> paths = [];
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Editor'),
        actions: [
          if (paths.isNotEmpty)
            OutlinedButton.icon(
              icon: Icon(Icons.clear_all_outlined),
              label: Text('Clear All'),
              onPressed: () {
                paths.clear();
                inputController.text = '';
                setState(() {});
              },
            ),
        ],
      ),
      body: Padding(
        padding: .only(right: 10),
        child: CustomScrollView(
          slivers: [
            if (inputController.text.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: .symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: inputController,
                          maxLines: 1,
                          decoration: InputDecoration(labelText: 'Input'),
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          inputController.text = '';
                          setState(() {});
                        },
                        icon: Icon(Icons.clear_all_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            if (inputController.text.isNotEmpty)
              SliverToBoxAdapter(child: _ffmpegOptionWidgets),
            if (paths.isEmpty)
              SliverFillRemaining(
                child: Center(child: Text('Please Choose Files')),
              ),

            if (paths.isNotEmpty)
              SliverList.separated(
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemCount: paths.length,
                itemBuilder: (context, index) => pathItem(paths[index]),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        child: Icon(Icons.file_present_outlined),
      ),
    );
  }

  Widget get _ffmpegOptionWidgets {
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
        border: .all(color: col.onSurfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'FFmpeg Options',
            style: TextStyle(fontWeight: .w700, color: col.onSurface),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (currentType == .video)
                _ffmpegOption(
                  icon: Icons.video_file_outlined,
                  label: 'Video',
                  onPressed: () {},
                ),
              _ffmpegOption(
                icon: Icons.audio_file_outlined,
                label: 'Audio',
                onPressed: () {},
              ),
              // _ffmpegOption(
              //   icon: Icons.speed,
              //   label: 'Speed',
              //   onPressed: () {},
              // ),
              // _ffmpegOption(
              //   icon: Icons.volume_up,
              //   label: 'Audio',
              //   onPressed: () {},
              // ),
              // _ffmpegOption(
              //   icon: Icons.high_quality,
              //   label: 'Quality',
              //   onPressed: () {},
              // ),
              // _ffmpegOption(icon: Icons.crop, label: 'Crop', onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ffmpegOption({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: col.onSurface,
        side: BorderSide(color: col.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget pathItem(String path) {
    return ListTile(
      tileColor: inputController.text == path
          ? col.onPrimaryContainer.withValues(alpha: .45)
          : col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      leading: typeIcon(path),
      title: Text(path.getName(), maxLines: 1, overflow: .ellipsis),
      trailing: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: col.errorContainer,
          foregroundColor: col.onErrorContainer,
        ),
        onPressed: () {
          paths.remove(path);
          if (inputController.text == path) {
            inputController.text = '';
          }
          setState(() {});
        },
        icon: Icon(Icons.remove_circle_outline_outlined),
      ),
      subtitle: Text(
        path,
        overflow: .ellipsis,
        maxLines: 3,
        style: TextStyle(fontWeight: .w400, fontSize: 10),
      ),
      onTap: () {
        inputController.text = path;
        setState(() {});
      },
    );
  }

  Widget typeIcon(String path) {
    final ty = FileType.fromPath(path);
    if (ty == .audio) {
      return Icon(Icons.audio_file_outlined, size: 50);
    }
    if (ty == .video) {
      return Icon(Icons.video_file_outlined, size: 50);
    }
    return Icon(Icons.file_present_outlined, size: 50);
  }
}
