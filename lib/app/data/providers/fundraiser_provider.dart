import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/data/models/fundraiser_model.dart';
import 'package:projetos/app/utils/service_storage.dart';

class FundRaiserApiClient {
  final http.Client httpClient = http.Client();
  insertFundRaiser(String token, FundRaiser fundRaiser) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/fundraising';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.post(fundRaiserUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "user_id": ServiceStorage.getUserId().toString(),
        "company_id": fundRaiser.companyId.toString(),
        "expected_date": fundRaiser.expectedDate.toString(),
        "predicted_value": fundRaiser.predictedValue.toString(),
        "status": 'aguardando',
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
