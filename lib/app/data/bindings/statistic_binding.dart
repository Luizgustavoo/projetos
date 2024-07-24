import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/statistic_controller.dart';

class StatisticBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticController>(() => StatisticController());
  }
}
