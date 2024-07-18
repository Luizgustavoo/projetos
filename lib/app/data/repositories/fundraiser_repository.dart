import 'package:projetos/app/data/models/fundraiser_model.dart';
import 'package:projetos/app/data/providers/fundraiser_provider.dart';

class FundRaiserRepository {
  final FundRaiserApiClient apiClient = FundRaiserApiClient();

  insertFundRaiser(String token, FundRaiser fundRaiser) async {
    try {
      var response = await apiClient.insertFundRaiser(token, fundRaiser);

      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
