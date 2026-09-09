import 'dart:async';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_editor/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/success_alert_dialog.dart';
import 'package:t_widgets/t_widgets.dart';

class FfmpegProcessPage extends StatefulWidget {
  const new({super.key, required this.command});
  final String command;

  @override
  State<FfmpegProcessPage> createState() => _FfmpegProcessPageState();
}

class _FfmpegProcessPageState extends State<FfmpegProcessPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    FFmpegKitExtended.cancelAllSessions();
    con.close();
    super.dispose();
  }

  List<String> logList = [];
  final con = StreamController.broadcast();
  final scrollCon = ScrollController();
  ColorScheme get col => Theme.of(context).colorScheme;

  bool working = false;

  void init() async {
    try {
      setState(() {
        working = true;
      });
      logList.clear();
      logList.add('command: ${widget.command}');
      con.add('');
      await FFmpegKit.executeAsync(
        widget.command,
        onComplete: (session) {
          /* Complete Callback */
          final returnCode = session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            // print("Command success");
            logList.add("Command success");
            if (!mounted) return;
            showSuccessDialog(context, 'Command success');
            con.add('');
            scrollToEnd();
          } else if (ReturnCode.isCancel(returnCode)) {
            // print("Command cancelled");
            logList.add("Command cancelled");
            con.add('');
            scrollToEnd();
          } else {
            // print("Command failed with state ${session.getState()}");
            logList.add("Command failed with state ${session.getState()}");
            final failStackTrace = session.getFailStackTrace();
            // print("Stack trace: $failStackTrace");
            logList.add("Stack trace: $failStackTrace");
            con.add('');
            scrollToEnd();
          }
        },
        onLog: (log) {
          // print("Log: ${log.message}");
          logList.add("Log: ${log.message}");
          con.add('');
          scrollToEnd();
        },
        onStatistics: (statistics) {
          // print("Progress: ${statistics.time} ms, size: ${statistics.size}");
          logList.add(
            "Progress: ${statistics.time} ms, size: ${statistics.size}",
          );
          con.add('');
          scrollToEnd();
        },
      );
      if (!mounted) return;
      setState(() {
        working = false;
      });
      scrollToEnd();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        working = false;
      });
      showErrorDialog(context, e.toString());
    }
  }

  void scrollToEnd() {
    if (!scrollCon.hasClients) return;
    scrollCon.animateTo(
      scrollCon.position.maxScrollExtent,
      duration: Duration(milliseconds: 800),
      curve: Curves.linear,
    );
  }

  void goBack() async {
    if (!working) {
      context.pop();
      return;
    }
    final confirm = await showConfirmDialog(
      context,
      'Want To Cancel!',
      closeText: 'No',
      confirmText: 'Cancel',
    );
    if (!confirm) return;
    FFmpegKitExtended.cancelAllSessions();
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("FFMpeg Process"),
          bottom: !working
              ? null
              : PreferredSize(
                  preferredSize: .fromHeight(5),
                  child: LinearProgressIndicator(),
                ),
          actions: [
            if (working)
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: col.errorContainer,
                  foregroundColor: col.onErrorContainer,
                ),
                onPressed: () async {
                  final confirm = await showConfirmDialog(
                    context,
                    'Want To Cancel!',
                    closeText: 'No',
                    confirmText: 'Cancel',
                  );
                  if (!confirm) return;
                  FFmpegKitExtended.cancelAllSessions();
                },
                icon: Icon(Icons.stop_circle_outlined),
              ),
            if (logList.isNotEmpty)
              IconButton(
                onPressed: () {
                  Clipboard.setData(.new(text: logList.join('\n')));
                },
                icon: Icon(Icons.copy_all_rounded),
              ),
          ],
        ),
        body: CustomScrollView(
          controller: scrollCon,
          slivers: [
            SliverPadding(
              padding: .symmetric(vertical: 10, horizontal: 15),
              sliver: SliverToBoxAdapter(child: _header),
            ),
            SliverPadding(
              padding: .symmetric(vertical: 10, horizontal: 15),
              sliver: StreamBuilder(
                stream: con.stream,
                builder: (context, asyncSnapshot) {
                  return SliverList.builder(
                    itemCount: logList.length,
                    itemBuilder: (context, index) {
                      final item = logList[index];
                      return SelectableText(item);
                    },
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget get _header {
    return SizedBox();
  }
}
