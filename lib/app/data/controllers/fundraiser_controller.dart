import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/fundraiser_model.dart';
import 'package:projetos/app/data/repositories/fundraiser_repository.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';

class FundRaiserController extends GetxController {
  final dateFundController = TextEditingController();
  final valueFundController = TextEditingController();

  final fundRaiserKey = GlobalKey<FormState>();

  final repository = Get.put(FundRaiserRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<Map<String, dynamic>> insertFundRaiser(int companyId) async {
    final token = ServiceStorage.getToken();
    final companyController = Get.put(CompanyController());

    String valueString =
        valueFundController.text.replaceAll(RegExp(r'[^0-9]'), '');

    int? predictedValue = int.tryParse(valueString);
    FundRaiser fundRaiser = FundRaiser(
        predictedValue: predictedValue,
        expectedDate: dateFundController.text,
        companyId: companyId);

    if (fundRaiserKey.currentState!.validate()) {
      mensagem = await repository.insertFundRaiser("Bearer $token", fundRaiser);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      companyController.getCompanies();
    }
    return retorno;
  }

  void clearAllFields() {
    final textControllers = [dateFundController, valueFundController];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  void onDateChanged(String value) {
    dateFundController.value = dateFundController.value.copyWith(
      text: FormattedInputers.formatDate(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatDate(value).length),
    );
  }

  void onValueChanged(String value) {
    valueFundController.value = valueFundController.value.copyWith(
      text: FormattedInputers.formatValue(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatValue(value).length),
    );
  }
}
