import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projetos/app/routes/app_routes.dart';

class InitialController extends GetxController {
  final box = GetStorage('projeto');
  dynamic auth;

  @override
  void onInit() {
    auth = box.read('auth');
    super.onInit();
  }

  String verifyAuth() {
    if (auth != null) {
      return Routes.home;
    }
    return Routes.login;
  }
}
