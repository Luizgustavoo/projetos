import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/providers/wallet_provider.dart';

class WalletRepository {
  final WalletApiClient apiClient = WalletApiClient();

  gettAll(String token) async {
    List<Bill> list = <Bill>[];

    var response = await apiClient.getAll(token);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Bill.fromJson(e));
      });
    }

    return list;
  }
}
