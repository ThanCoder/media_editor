import 'package:material_ui/material_ui.dart';
import 'package:media_editor/core/utils/app_util.dart';

class MobileHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  @override
  void initState() {
    super.initState();
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppUtil.instance.appName),
        actions: [
          // if (TPlatform.isDesktop)
          //   IconButton(
          //     onPressed: con.fetchList,
          //     icon: Icon(Icons.refresh_outlined),
          //   ),
        ],
      ),
      body: Placeholder(),
    );
  }
}
