import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/data/models/user_model.dart';

class HomeApiClient {
  final http.Client httpClient = http.Client();

  updatePasswordUser(String token, User user) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/user/update-password/${user.id.toString()}';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.post(fundRaiserUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "password": user.password.toString(),
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
