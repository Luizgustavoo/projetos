import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/report_controller.dart';

class ReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
