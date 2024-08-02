import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projetos/app/data/bindings/initial_binding.dart';
import 'package:projetos/app/routes/app_pages.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/theme/app_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

void main() async {
  await GetStorage.init('projeto');
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 920),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.setResizable(false);
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Projetos',
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      initialRoute: Routes.initial,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
    );
  }
}
