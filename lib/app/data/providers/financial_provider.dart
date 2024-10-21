import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/data/models/fund_raiser_comission_model.dart';
import 'package:projetos/app/utils/service_storage.dart';

class FinancialApiClient {
  final http.Client httpClient = http.Client();

  getAll(String token, int id) async {
    try {
      String userId =
          id <= 0 ? ServiceStorage.getUserId().toString() : id.toString();
      Uri financialUrl;
      String url = '$baseUrl/v1/bills/my/$userId';
      financialUrl = Uri.parse(url);
      var response = await httpClient.get(
        financialUrl,
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

  getFinancialBalance(String token, int id) async {
    try {
      Uri financialUrl;

      String userId =
          id <= 0 ? ServiceStorage.getUserId().toString() : id.toString();

      String url = '$baseUrl/v1/fundraisercomission/$userId';
      financialUrl = Uri.parse(url);
      var response = await httpClient.get(
        financialUrl,
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

  updateFinancial(String token, FundRaiserComission fundRaiserComission) async {
    try {
      Uri financialUrl;
      String url =
          '$baseUrl/v1/fundraisercomission/${fundRaiserComission.id.toString()}';
      financialUrl = Uri.parse(url);
      var response = await httpClient.put(financialUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "pago": "sim",
        "payday": fundRaiserComission.payday,
        "observacoes": fundRaiserComission.observacoes
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
