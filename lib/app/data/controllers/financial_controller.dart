import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/fund_raiser_comission_model.dart';
import 'package:projetos/app/data/repositories/financial_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';

class FinancialController extends GetxController {
  RxList<Bill> listFinancial = RxList<Bill>([]);
  RxBool isLoading = true.obs;
  final repository = Get.put(FinancialRepository());

  var sumToReceive = 0.0.obs;
  var sumReceived = 0.0.obs;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<void> getFinancial(int id) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listFinancial.value = await repository.getAll("Bearer $token", id);
      update();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getFinancialBalance(int id) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      final data = await repository.getWalletBalance("Bearer $token", id);

      if (data != null) {
        sumToReceive.value = (data['sum_to_receive'] as num).toDouble();
        sumReceived.value = (data['sum_received'] as num).toDouble();
      }
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  String formatValue(dynamic value) {
    if (value is String) {
      value = double.tryParse(value) ?? 0.0;
    }
    final NumberFormat formatter =
        NumberFormat.currency(symbol: '', decimalDigits: 2, locale: 'pt_BR');
    return formatter.format(value);
  }

  Future<Map<String, dynamic>> updateFinancial(int? id) async {
    FundRaiserComission company = FundRaiserComission(
      id: id,
    );
    final token = ServiceStorage.getToken();

    mensagem = await repository.updateFinancial("Bearer $token", company);
    retorno = {'success': mensagem['success'], 'message': mensagem['message']};
    getFinancial(id!);

    return retorno;
  }
}
