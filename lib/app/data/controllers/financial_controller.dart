import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/repositories/financial_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';

class FinancialController extends GetxController {
  RxList<Bill> listWallet = RxList<Bill>([]);
  RxBool isLoading = true.obs;
  final repository = Get.put(FinancialRepository());

  var sumToReceive = 0.0.obs;
  var sumReceived = 0.0.obs;

  Future<void> getWallet(int id) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listWallet.value = await repository.getAll("Bearer $token", id);
      update();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getWalletBalance(int id) async {
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
}
