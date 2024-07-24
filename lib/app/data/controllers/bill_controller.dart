import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/repositories/bill_repository.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';

class BillController extends GetxController {
  var listAllBills = <Bill>[].obs;
  var isLoading = true.obs;
  final repository = Get.put(BillRepository());

  final billKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final aprovedValueController = TextEditingController();
  final yearController = TextEditingController();
  final statusController = TextEditingController();
  final commentsController = TextEditingController();

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

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
        status: statusController.text,
        observacoes: commentsController.text,
        valorAprovado: FormattedInputers.convertToDouble(aprovedValueController.text),
      )
      );
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAllBills();
    }
    return retorno;
  }

  void onValueChanged(String value) {
    aprovedValueController.value = aprovedValueController.value.copyWith(
      text: FormattedInputers.formatValue(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatValue(value).length),
    );
  }
}
