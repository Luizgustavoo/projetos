import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/fund_raiser_comission_model.dart';
import 'package:projetos/app/data/providers/financial_provider.dart';

class FinancialRepository {
  final FinancialApiClient apiClient = FinancialApiClient();

  getAll(String token, int id) async {
    List<Bill> list = <Bill>[];

    var response = await apiClient.getAll(token, id);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Bill.fromJson(e));
      });
    }

    return list;
  }

  getWalletBalance(String token, int id) async {
    var response = await apiClient.getFinancialBalance(token, id);

    if (response != null) {
      return response['data'];
    }

    return null;
  }

  updateFinancial(String token, FundRaiserComission fundRaiserComission) async {
    try {
      var response =
          await apiClient.updateFinancial(token, fundRaiserComission);

      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
