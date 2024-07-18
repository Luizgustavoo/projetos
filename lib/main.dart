import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projetos/app/data/bindings/initial_binding.dart';
import 'package:projetos/app/routes/app_pages.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/theme/app_theme.dart';

void main() async {
  await GetStorage.init('projeto');
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
