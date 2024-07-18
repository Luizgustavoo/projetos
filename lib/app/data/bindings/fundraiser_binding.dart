import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/repositories/fundraiser_repository.dart';

class FundRaiserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FundRaiserController>(() => FundRaiserController());
    Get.lazyPut<FundRaiserRepository>(() => FundRaiserRepository());
  }
}
