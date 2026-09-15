import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:media_editor/core/utils/app_utils.dart';
import 'package:media_editor/keys.dart';
import 'package:media_editor/platforms/pages/command_list_editor/command_list_editor_page.dart';
import 'package:media_editor/platforms/pages/command_list_editor/dialog/template_save_dialog.dart';
import 'package:media_editor/platforms/pages/command_list_editor/template/template_data.dart';
import 'package:media_editor/platforms/pages/command_list_editor/types/command_list_editor_template.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

enum _ShowTemplateType { template, saved }

class CommandListEditorTemplatePage extends StatefulWidget {
  const CommandListEditorTemplatePage({super.key});

  @override
  State<CommandListEditorTemplatePage> createState() =>
      _CommandListEditorTemplatePageState();
  static final config = CFBStore();
  static Future<void> init() async {
    await config.open(
      AppUtils.instance.getPlatfromExternalConfigPath(
        'command-list-editor.template.cfb',
      ),
    );
  }

  static List<CommandListEditorTemplate> get list => config
      .getMapList('list')
      .map((e) => CommandListEditorTemplate.fromMap(e))
      .toList();
  static Future<void> add(CommandListEditorTemplate tem) async {
    final ls = list;
    ls.insert(0, tem);
    await config.putAndWriteAll('list', ls.map((e) => e.toMap()).toList());
  }

  static Future<void> remove(CommandListEditorTemplate tem) async {
    final ls = list;
    final index = ls.indexWhere((e) => e.id == tem.id);
    if (index == -1) return;
    ls.removeAt(index);
    await config.putAndWriteAll('list', ls.map((e) => e.toMap()).toList());
  }
}

class _CommandListEditorTemplatePageState
    extends State<CommandListEditorTemplatePage> {
  ColorScheme get col => Theme.of(context).colorScheme;
  final config = AppUtils.instance.config;

  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    if (Platform.isAndroid) {
      if (!await ThanPkgAndroid.getInstance.storagePermissionHandler
          .isStoragePermissionGranted()) {
        await ThanPkgAndroid.getInstance.storagePermissionHandler
            .requestStoragePermission();
        return;
      }
    }
    await CommandListEditorTemplatePage.init();
  }

  void newProject() async {
    goEditor();
  }

  void useTemplate(CommandListEditorTemplate template) {
    goEditor(template: template);
  }

  void goEditor({CommandListEditorTemplate? template}) async {
    final tem = await context.pushMaterialPageRoute<CommandListEditorTemplate>(
      builder: (mainCtx) => CommandListEditorPage(template: template),
    );
    if (tem == null) return;
    config.putAndWriteAll(commandEditorTemplateKey, tem.toMap());
  }

  void saveTemplate(CommandListEditorTemplate template) async {
    final tem = await showDialog<CommandListEditorTemplate>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TemplateSaveDialog(template: template),
    );
    if (tem == null) return;
    CommandListEditorTemplatePage.add(tem);
  }

  _ShowTemplateType current = .template;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor Templates'),
        actions: [
          FilledButton.icon(
            label: Text('Refresh Storage'),
            onPressed: init,
            icon: Icon(Icons.refresh_outlined),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // New project
          SliverToBoxAdapter(child: _newProject()),
          SliverToBoxAdapter(child: _recentTemplate()),
          SliverToBoxAdapter(child: _header()),
          _list(),
        ],
      ),
    );
  }

  Padding _header() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SegmentedButton<_ShowTemplateType>(
            selected: {current},
            onSelectionChanged: (p0) {
              current = p0.first;
              setState(() {});
            },
            segments: [
              .new(value: .template, label: Text('Template')),
              .new(value: .saved, label: Text('Saved')),
            ],
          ),
          // Text(
          //   'Templates',
          //   style: Theme.of(context).textTheme.titleMedium
          //       ?.copyWith(fontWeight: FontWeight.w600),
          // ),
        ],
      ),
    );
  }

  Widget _list() {
    return StreamBuilder(
      stream: CommandListEditorTemplatePage.config.stream.put,
      builder: (context, asyncSnapshot) {
        List<CommandListEditorTemplate> list = builtInTemplates;
        if (current == .saved) {
          list = CommandListEditorTemplatePage.list;
        }
        return SliverList.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => _TemplateCard(
            template: list[index],
            useTemplate: useTemplate,
            leftButton: current == .saved
                ? FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: col.errorContainer,
                      foregroundColor: col.onErrorContainer,
                    ),
                    onPressed: () {
                      CommandListEditorTemplatePage.remove(list[index]);
                    },
                    child: Text('Remove'),
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _newProject() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: newProject,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: col.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.add, color: col.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Project',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Start with an empty command list.'),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentTemplate() {
    return StreamBuilder(
      stream: config.stream.put.where((e) => e.key == commandEditorTemplateKey),
      builder: (context, asyncSnapshot) {
        final map = config.getMap(commandEditorTemplateKey);
        if (map.isEmpty) {
          return SizedBox.shrink();
        }
        final tem = CommandListEditorTemplate.fromMap(map);
        if (tem.blocks.isEmpty) {
          return SizedBox.shrink();
        }
        return _TemplateCard(
          template: tem,
          useTemplate: useTemplate,
          leftButton: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: col.secondaryContainer,
              foregroundColor: col.onSecondaryContainer,
            ),
            onPressed: () => saveTemplate(tem),
            child: Text('Save'),
          ),
        );
      },
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.useTemplate,
    this.leftButton,
  });

  final CommandListEditorTemplate template;
  final void Function(CommandListEditorTemplate template) useTemplate;
  final Widget? leftButton;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 10, 16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.layers_outlined,
                color: colorScheme.onSecondaryContainer,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    template.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.account_tree_outlined,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${template.blocks.length} blocks',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            ?leftButton,
            if (leftButton != null) SizedBox(width: 10),

            FilledButton(
              onPressed: () => useTemplate(template),
              child: const Text('Use'),
            ),
          ],
        ),
      ),
    );
  }
}
