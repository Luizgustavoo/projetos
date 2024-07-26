import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/repositories/wallet_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';

class WalletController extends GetxController {
  RxList<Bill> listWallet = RxList<Bill>([]);
  RxBool isLoading = true.obs;
  final repository = Get.put(WalletRepository());

  var sumToReceive = 0.0.obs;
  var sumReceived = 0.0.obs;

  Future<void> getWallet() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listWallet.value = await repository.getAll("Bearer $token");
      update();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getWalletBalance() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      final data = await repository.getWalletBalance("Bearer $token");

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
