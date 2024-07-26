import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/repositories/wallet_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';

class WalletController extends GetxController {
  RxList<Bill> listWallet = RxList<Bill>([]);
  RxBool isLoading = true.obs;
  final repository = Get.put(WalletRepository());
  Future<void> getWallet() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listWallet.value = await repository.gettAll("Bearer $token");
      update();
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
