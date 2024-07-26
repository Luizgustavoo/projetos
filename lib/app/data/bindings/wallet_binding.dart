import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/wallet_controller.dart';

class WalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(() => WalletController());
  }
}
