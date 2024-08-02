import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/data/repositories/home_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';

class HomeController extends GetxController {
  final passwordController = TextEditingController();
  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;
  final changePasswordKey = GlobalKey<FormState>();
  final repository = Get.put(HomeRepository());

  Future<Map<String, dynamic>> updatePasswordUser(int? id) async {
    User user = User(
      id: id,
      password: passwordController.text,
    );

    final token = ServiceStorage.getToken();
    if (changePasswordKey.currentState!.validate()) {
      mensagem = await repository.updatePasswordUser("Bearer $token", user);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
    }
    return retorno;
  }

  void clearAllFields() {
    final textControllers = [passwordController];

    for (final controller in textControllers) {
      controller.clear();
    }
  }
}
