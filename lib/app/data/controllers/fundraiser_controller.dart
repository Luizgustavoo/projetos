import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/fundraiser_model.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/data/repositories/fundraiser_repository.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';

class FundRaiserController extends GetxController {
  RxList<User> listFundRaiser = RxList<User>([]);
  RxList<FundRaising> listPendingFundRising = RxList<FundRaising>([]);
  RxBool isLoading = true.obs;
  var paidOutCheckboxValue = false.obs;
  var showPaymentDateField = false.obs;

  final dateFundController = TextEditingController();
  final valueFundController = TextEditingController();
  final fundRaisingKey = GlobalKey<FormState>();

  final nameRaiserController = TextEditingController();
  final cpfCnpjRaiserController = TextEditingController();
  final phoneRaiserController = TextEditingController();
  final startDateRaiserController = TextEditingController();
  final emailRaiserController = TextEditingController();
  final passwordRaiserController = TextEditingController();
  final fundRaiserKey = GlobalKey<FormState>();

  final pendingFundRaisingKey = GlobalKey<FormState>();
  final datePendingFundController = TextEditingController();
  final pendingValueFundController = TextEditingController();
  final paymentDateController = TextEditingController();

  final repository = Get.put(FundRaiserRepository());

  User? selectedUser;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  @override
  void onInit() {
    getAllPendingFundRising();
    super.onInit();
  }

  Future<void> getFundRaisers() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listFundRaiser.value =
          await repository.gettAllFundRaiser("Bearer $token");
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getAllPendingFundRising() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      var pendingFundRaisings =
          await repository.getAllPendingFundRising("Bearer $token");
      listPendingFundRising.value = pendingFundRaisings;
    } catch (e) {
      Exception('Exception: $e');
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertFundRaiser() async {
    final token = ServiceStorage.getToken();
    User user = User(
        name: nameRaiserController.text,
        email: emailRaiserController.text,
        password: passwordRaiserController.text,
        startDate: startDateRaiserController.text,
        cpfCnpj: cpfCnpjRaiserController.text,
        contact: phoneRaiserController.text);

    if (fundRaiserKey.currentState!.validate()) {
      mensagem = await repository.insertFundRaiser("Bearer $token", user);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getFundRaisers();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> insertFundRaising(
      int companyId, int billId) async {
    final token = ServiceStorage.getToken();
    final companyController = Get.put(CompanyController());

    String valueString =
        valueFundController.text.replaceAll(RegExp(r'[^0-9,]'), '');

    if (valueString.contains(',')) {
      valueString = valueString.replaceAll(RegExp(r'(?<=,\d*)0+$'), '');
    }

    valueString = valueString.replaceAll(',', '.');

    double? predictedValue = double.tryParse(valueString);

    if (predictedValue == null) {
      return {'success': false, 'message': 'Valor previsto inválido'};
    }

    FundRaiser fundRaiser = FundRaiser(
        predictedValue: predictedValue,
        expectedDate: dateFundController.text,
        companyId: companyId);

    if (fundRaisingKey.currentState!.validate()) {
      mensagem = await repository.insertFundRaising(
          "Bearer $token", fundRaiser, billId);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      int idd = ServiceStorage.getUserType() == 1 ? 0 : ServiceStorage.getUserId();
      companyController.getCompanies(idd);
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateFundRaiser(int? id) async {
    User user = User(
        id: id,
        name: nameRaiserController.text,
        email: emailRaiserController.text,
        password: passwordRaiserController.text,
        startDate: startDateRaiserController.text,
        cpfCnpj: cpfCnpjRaiserController.text,
        contact: phoneRaiserController.text);

    final token = ServiceStorage.getToken();
    if (fundRaiserKey.currentState!.validate()) {
      mensagem = await repository.updateFundRaise("Bearer $token", user);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getFundRaisers();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updatePendingFundRaising(int? id) async {
    String valueString =
        pendingValueFundController.text.replaceAll(RegExp(r'[^0-9,]'), '');

    if (valueString.contains(',')) {
      valueString = valueString.replaceAll(RegExp(r'(?<=,\d*)0+$'), '');
    }

    valueString = valueString.replaceAll(',', '.');

    double? capturedValue = double.tryParse(valueString);

    if (capturedValue == null) {
      return {'success': false, 'message': 'Valor previsto inválido'};
    }
    FundRaising fundRaising = FundRaising(
        id: id,
        dateOfCapture: datePendingFundController.text,
        capturedValue: capturedValue,
        pago: paidOutCheckboxValue.value ? 'sim' : 'nao',
        payDay: paymentDateController.text);

    final token = ServiceStorage.getToken();
    if (pendingFundRaisingKey.currentState!.validate()) {
      mensagem = await repository.updatePendingFundRaising(
          "Bearer $token", fundRaising);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAllPendingFundRising();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteFundRaiser(int? id) async {
    User user = User(
      id: id,
    );
    final token = ServiceStorage.getToken();
    mensagem = await repository.deleteFundRaiser("Bearer $token", user);
    retorno = {'success': mensagem['success'], 'message': mensagem['message']};
    getFundRaisers();
    return retorno;
  }

  void clearAllFields() {
    final textControllers = [
      dateFundController,
      valueFundController,
      cpfCnpjRaiserController,
      phoneRaiserController,
      startDateRaiserController,
      emailRaiserController,
      passwordRaiserController,
      datePendingFundController,
      pendingValueFundController,
      paymentDateController
    ];
    paidOutCheckboxValue.value = false;
    showPaymentDateField.value = false;
    for (final controller in textControllers) {
      controller.clear();
    }
  }

  void fillInFields() {
    nameRaiserController.text = selectedUser!.name.toString();
    cpfCnpjRaiserController.text = selectedUser!.cpfCnpj.toString();
    phoneRaiserController.text = selectedUser!.contact.toString();
    if (selectedUser!.startDate != null &&
        selectedUser!.startDate!.isNotEmpty) {
      try {
        DateTime date =
            DateFormat('yyyy-MM-dd').parse(selectedUser!.startDate!);
        startDateRaiserController.text = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        startDateRaiserController.clear();
      }
    } else {
      startDateRaiserController.clear();
    }

    emailRaiserController.text = selectedUser!.email.toString();
  }

  void onDateChanged(String value) {
    startDateRaiserController.value = startDateRaiserController.value.copyWith(
      text: FormattedInputers.formatDate(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatDate(value).length),
    );
  }

  void onFundRaiserDateChanged(String value) {
    dateFundController.value = dateFundController.value.copyWith(
      text: FormattedInputers.formatDate(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatDate(value).length),
    );
  }

  void onPendingDateChanged(String value) {
    datePendingFundController.value = datePendingFundController.value.copyWith(
      text: FormattedInputers.formatDate(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatDate(value).length),
    );
  }

  void onPaymentDateChanged(String value) {
    paymentDateController.value = paymentDateController.value.copyWith(
      text: FormattedInputers.formatDate(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatDate(value).length),
    );
  }

  void onCnpjChanged(String value) {
    cpfCnpjRaiserController.value = cpfCnpjRaiserController.value.copyWith(
      text: FormattedInputers.formatCpfCnpj(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatCpfCnpj(value).length),
    );
  }

  void onContactChanged(String value) {
    phoneRaiserController.value = phoneRaiserController.value.copyWith(
      text: FormattedInputers.formatContact(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatContact(value).length),
    );
  }

  void onValueChanged(String value) {
    valueFundController.value = valueFundController.value.copyWith(
      text: FormattedInputers.formatValue(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatValue(value).length),
    );
  }

  void onPendingValueChanged(String value) {
    pendingValueFundController.value =
        pendingValueFundController.value.copyWith(
      text: FormattedInputers.formatValue(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatValue(value).length),
    );
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(parsedDate);
  }

  String formatValue(dynamic value) {
    if (value is String) {
      value = double.tryParse(value) ?? 0.0;
    }
    final NumberFormat formatter =
        NumberFormat.currency(symbol: '', decimalDigits: 2, locale: 'pt_BR');
    return formatter.format(value);
  }
}
