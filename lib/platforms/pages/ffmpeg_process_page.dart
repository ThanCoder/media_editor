// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_editor/platforms/pages/command_editor_page.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:media_editor/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/error_alert_dialog.dart';
import 'package:media_editor/platforms/components/dialog/success_alert_dialog.dart';

enum LogType { normal, error, success, cancel }

class PLog {
  final String message;
  final LogType type;
  const PLog({required this.message, this.type = .normal});
}

class FfmpegProcessPage extends StatefulWidget {
  const new({super.key, required this.command});
  final String command;

  @override
  State<FfmpegProcessPage> createState() => _FfmpegProcessPageState();
}

class _FfmpegProcessPageState extends State<FfmpegProcessPage> {
  @override
  void initState() {
    command = widget.command;
    init();
    super.initState();
  }

  @override
  void dispose() {
    FFmpegKitExtended.cancelAllSessions();
    con.close();
    super.dispose();
  }

  late String command;
  List<PLog> logList = [];
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
      logList.add(.new(message: 'command: $command\n\n', type: .cancel));
      con.add('');
      await FFmpegKit.executeAsync(
        command,
        onComplete: (session) {
          /* Complete Callback */
          final returnCode = session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            // print("Command success");
            logList.add(.new(message: "Command success", type: .success));
            con.add('');
            if (!mounted) return;
            showSuccessDialog(context, 'Command success');
            con.add('');
            scrollToEnd();
          } else if (ReturnCode.isCancel(returnCode)) {
            // print("Command cancelled");
            logList.add(.new(message: "Command cancelled", type: .cancel));
            con.add('');
            scrollToEnd();
          } else {
            // print("Command failed with state ${session.getState()}");
            logList.add(
              .new(
                message: "Command failed with state ${session.getState()}",
                type: .error,
              ),
            );
            final failStackTrace = session.getFailStackTrace();
            // print("Stack trace: $failStackTrace");
            logList.add(
              .new(message: "Stack trace: $failStackTrace", type: .error),
            );
            con.add('');
            scrollToEnd();

            if (!mounted) return;
            showErrorDialog(
              context,
              "Command failed with state ${session.getState()}",
            );
          }
        },
        onLog: (log) {
          // print("Log: ${log.message}");
          logList.add(.new(message: "Log: ${log.message}"));
          con.add('');
          scrollToEnd();
        },
        onStatistics: (statistics) {
          // print("Progress: ${statistics.time} ms, size: ${statistics.size}");
          logList.add(
            .new(
              message:
                  "Progress: ${statistics.time} ms, size: ${statistics.size}",
            ),
          );
          con.add('');
          scrollToEnd();
        },
      );
      if (!mounted) return;
      setState(() {
        working = false;
      });
      logList.add(.new(message: '\n\ncommand: $command', type: .cancel));
      con.add('');
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

  void editCommandWithEditor() async {
    final res = await context.pushMaterialPageRoute<String>(
      builder: (mainCtx) => CommandEditorPage(text: command),
    );
    if (res == null) return;
    command = res;
    logList.clear();
    con.add('');
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goBack();
      },
      child: Theme(
        data: .dark(),
        child: Scaffold(
          appBar: _appbar(context),
          body: CustomScrollView(
            controller: scrollCon,
            slivers: [
              // SliverPadding(
              //   padding: .symmetric(vertical: 10, horizontal: 15),
              //   sliver: SliverToBoxAdapter(child: _header),
              // ),
              SliverPadding(
                padding: .symmetric(vertical: 10, horizontal: 15),
                sliver: _result(),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      title: Text("FFMpeg Process"),
      bottom: !working
          ? null
          : PreferredSize(
              preferredSize: .fromHeight(5),
              child: LinearProgressIndicator(),
            ),
      actions: [
        if (!working)
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: col.tertiary,
              foregroundColor: col.onTertiary,
            ),
            onPressed: editCommandWithEditor,
            icon: Icon(Icons.edit_document),
          ),
        SizedBox(width: 10),
        // process work button
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
          )
        else
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: col.primary,
              foregroundColor: col.onPrimary,
            ),
            onPressed: init,
            icon: Icon(Icons.play_circle),
          ),
        SizedBox(width: 10),
        // log copy all
        if (logList.isNotEmpty)
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: col.surfaceBright,
              foregroundColor: col.onSurfaceVariant,
            ),
            onPressed: () {
              Clipboard.setData(.new(text: logList.join('\n')));
            },
            icon: Icon(Icons.copy_all_rounded),
          ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _result() {
    return StreamBuilder(
      stream: con.stream,
      builder: (context, asyncSnapshot) {
        if (logList.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Container(
                padding: .symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: col.surfaceContainer,
                  borderRadius: .circular(15),
                  border: .all(color: col.outlineVariant),
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      'Start Process',
                      style: TextStyle(color: col.onSurface),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: col.primary,
                        foregroundColor: col.onPrimary,
                      ),
                      onPressed: init,
                      icon: Icon(Icons.play_circle),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SliverList.builder(
          itemCount: logList.length,
          itemBuilder: (context, index) {
            final item = logList[index];
            Color? logColor;
            if (item.type == .cancel) {
              logColor = Colors.amberAccent;
            }
            if (item.type == .error) {
              logColor = Colors.red;
            }
            if (item.type == .success) {
              logColor = Colors.green;
            }
            return SelectableText(
              item.message,
              style: TextStyle(color: logColor),
            );
          },
        );
      },
    );
  }
}
