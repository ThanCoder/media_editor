import 'package:material_ui/material_ui.dart';
import 'package:media_editor/platforms/pages/more/app_about_dialog.dart';
import 'package:media_editor/ui/components/scrollable_columm.dart';
import 'package:media_editor/ui/theme/theme_provider.dart';

import 'dev_pages/dev_home_page.dart';
import 'version_manager.dart';

class MorePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Apps")),
      body: ScrollableColumn(
        padding: .symmetric(vertical: 10, horizontal: 15),
        children: [
          MaterialThemeProviderChooser(),
          VersionManager(
            githubUrl: 'https://github.com/ThanCoder/media_editor',
          ),
          // CacheManagerListTile(
          //   cacheDirPath: AppUtil.instance.getPlatformCachePath(),
          // ),

          DevHomePage.buttonWidget,

          AppAboutDialogListTile(descText: 'ငွေကြေးစီမံရေး Application.'),
        ],
      ),
    );
  }
}
