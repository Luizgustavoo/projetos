import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/utils/service_storage.dart';

class WalletApiClient {
  final http.Client httpClient = http.Client();

  getAll(String token, int id) async {
    try {
      String user_id = id <= 0? ServiceStorage.getUserId().toString() : id.toString();
      Uri statisticUrl;
      String url =
          '$baseUrl/v1/bills/my/${user_id}';
      statisticUrl = Uri.parse(url);
      var response = await httpClient.get(
        statisticUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 &&
          json.decode(response.body)['message'] == "Token has expired") {
        Get.defaultDialog(
          title: "Expirou",
          content: const Text(
              'O token de autenticação expirou, faça login novamente.'),
        );
        var box = GetStorage('projeto');
        box.erase();
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  getWalletBalance(String token) async {
    try {
      Uri statisticUrl;
      String url =
          '$baseUrl/v1/fundraisercomission/${ServiceStorage.getUserId().toString()}';
      statisticUrl = Uri.parse(url);
      var response = await httpClient.get(
        statisticUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 &&
          json.decode(response.body)['message'] == "Token has expired") {
        Get.defaultDialog(
          title: "Expirou",
          content: const Text(
              'O token de autenticação expirou, faça login novamente.'),
        );
        var box = GetStorage('projeto');
        box.erase();
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }
}
