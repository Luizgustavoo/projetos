import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/material_controller.dart';

class MaterialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaterialController>(() => MaterialController());
  }
}
