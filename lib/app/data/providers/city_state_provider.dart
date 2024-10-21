import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CityStateApiClient {
  final http.Client httpClient = http.Client();

  getCities() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri cityUrl;
      String url = '$baseUrl/v1/municipio';
      cityUrl = Uri.parse(url);
      var response = await httpClient.get(
        cityUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  getCitiesDonation() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri cityUrl;
      String url = '$baseUrl/v1/company/cities';
      cityUrl = Uri.parse(url);
      var response = await httpClient.get(
        cityUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }
}
