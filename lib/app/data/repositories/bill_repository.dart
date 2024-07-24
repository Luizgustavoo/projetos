import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/providers/bill_provider.dart';

class BillRepository {
  final BillApiClient apiClient = BillApiClient();

  gettAll(String token) async {
    List<Bill> list = <Bill>[];

    var response = await apiClient.gettAll(token);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Bill.fromJson(e));
      });
    }

    return list;
  }

  insertBill(String token, Bill bill) async {
    try {
      var response = await apiClient.insertBill(
          token,bill);
      return response;
    } catch (e) {
      Exception(e);
    }
  }


}
