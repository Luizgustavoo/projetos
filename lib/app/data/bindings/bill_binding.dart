import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';

class BillBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillController>(() => BillController());
  }
}
