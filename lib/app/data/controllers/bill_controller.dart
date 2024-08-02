import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/repositories/bill_repository.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';

class BillController extends GetxController {
  var listAllBills = <Bill>[].obs;
  var isLoading = true.obs;

  final repository = Get.put(BillRepository());

  final billKey = GlobalKey<FormState>();

  Bill? selectedBill;

  var status = ''.obs;

  final nameController = TextEditingController();
  final aprovedValueController = TextEditingController();
  final percentageValueController = TextEditingController();
  final yearController = TextEditingController();
  final commentsController = TextEditingController();

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  @override
  void onInit() {
    getAllBills();
    super.onInit();
  }

  Future<void> getAllBills() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listAllBills.value = await repository.gettAll("Bearer $token");
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertBill() async {
    final token = ServiceStorage.getToken();
    if (billKey.currentState!.validate()) {
      mensagem = await repository.insertBill(
          "Bearer $token",
          Bill(
            nome: nameController.text,
            ano: int.parse(yearController.text),
            status: status.value.toString(),
            observacoes: commentsController.text,
            valorAprovado:
                FormattedInputers.convertToDouble(aprovedValueController.text),
            porcentagem: FormattedInputers.convertPercentageToDouble(
                percentageValueController.text),
          ));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAllBills();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateBill(int? id) async {
    Bill bill = Bill(
      id: id,
      nome: nameController.text,
      ano: int.parse(yearController.text),
      status: status.value.toString(),
      observacoes: commentsController.text,
      valorAprovado:
          FormattedInputers.convertToDouble(aprovedValueController.text),
      porcentagem: FormattedInputers.convertPercentageToDouble(
          percentageValueController.text),
    );
    final token = ServiceStorage.getToken();
    if (billKey.currentState!.validate()) {
      mensagem = await repository.updateBill("Bearer $token", bill);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAllBills();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteBill(int? id) async {
    Bill bill = Bill(
      id: id,
    );
    final token = ServiceStorage.getToken();
    mensagem = await repository.deleteBill("Bearer $token", bill);
    retorno = {'success': mensagem['success'], 'message': mensagem['message']};
    getAllBills();
    return retorno;
  }

  void fillInFields() {
    if (selectedBill != null) {
      nameController.text = selectedBill!.nome.toString();
      aprovedValueController.text = formatValue(selectedBill!.valorAprovado);
      percentageValueController.text =
          FormattedInputers.formatPercentageSend(selectedBill!.porcentagem);
      yearController.text = selectedBill!.ano.toString();
      status.value = selectedBill!.status.toString();
      commentsController.text = selectedBill!.observacoes.toString();
    }
  }

  void clearAllFields() {
    final textControllers = [
      nameController,
      aprovedValueController,
      yearController,
      commentsController,
      percentageValueController
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  void onValueChanged(String value) {
    aprovedValueController.value = aprovedValueController.value.copyWith(
      text: FormattedInputers.formatValue(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatValue(value).length),
    );
  }

  void onPercentageChanged(String value) {
    final formattedValue = FormattedInputers.formatPercentage(value);
    percentageValueController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
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
