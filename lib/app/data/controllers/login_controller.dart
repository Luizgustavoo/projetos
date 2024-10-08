import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projetos/app/data/models/auth_model.dart';
import 'package:projetos/app/data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  var isPasswordVisible = false.obs;

  final repository = Get.find<AuthRepository>();
  final box = GetStorage('projeto');
  RxBool loading = false.obs;

  Auth? auth;
  RxBool showErrorSnackbar = false.obs;

  void login() async {
    if (loginKey.currentState!.validate()) {
      loading.value = true;

      auth = await repository.getLogin(
          emailController.text, passwordController.text);

      if (auth != null) {
        box.write('auth', auth?.toJson());
        Get.offAllNamed('/home');
      } else {
        showErrorSnackbar.value = true;
        showErrorMessage();
      }

      loading.value = false;
    }
  }

  void showErrorMessage() {
    if (showErrorSnackbar.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Erro de Autenticação',
          'Usuário ou senha inválidos',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        showErrorSnackbar.value = false;
      });
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
