import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/data/models/fundraiser_model.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/utils/service_storage.dart';

class FundRaiserApiClient {
  final http.Client httpClient = http.Client();

  gettAllFundRaiser(String token) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/user';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.get(
        fundRaiserUrl,
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

  Future<Map<String, dynamic>?> getAllPendingFundRising(String token) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/company/fundraising';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.get(
        fundRaiserUrl,
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
      Exception('Exception: $e');
    }
    return null;
  }

  insertFundRaiser(String token, User user) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/user';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.post(fundRaiserUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "name": user.name.toString(),
        "email": user.email.toString(),
        "password": user.password.toString(),
        "start_date": user.startDate.toString(),
        "usertype_id": user.usertypeId.toString(),
        "cpf_cnpj": user.cpfCnpj.toString(),
        "contact": user.contact.toString(),
        "status": "1",
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  updateFundRaise(String token, User user) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/user/${user.id.toString()}';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.put(fundRaiserUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "name": user.name.toString(),
        "email": user.email.toString(),
        "password": user.password.toString(),
        "start_date": user.startDate.toString(),
        "usertype_id": user.usertypeId.toString(),
        "cpf_cnpj": user.cpfCnpj.toString(),
        "contact": user.contact.toString(),
        "status": "1",
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  insertFundRaising(String token, FundRaiser fundRaiser, int billId,
      String payDay, int id, bool paid) async {
    try {
      String userId =
          id <= 0 ? ServiceStorage.getUserId().toString() : id.toString();
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/fundraising';
      fundRaiserUrl = Uri.parse(url);
      var requestBody = {
        "bills_id": billId.toString(),
        "user_id": userId,
        "company_id": fundRaiser.companyId.toString(),
        "expected_date": fundRaiser.expectedDate.toString(),
        "predicted_value": fundRaiser.predictedValue.toString(),
        "status": ServiceStorage.getUserType() == 1 ? 'captado' : 'aguardando',
        "pessoa_lancamento":
            ServiceStorage.getUserType() == 1 ? 'admin' : 'captador',
      };

      if (ServiceStorage.getUserType() == 1) {
        requestBody['pago'] = paid == true ? 'sim' : 'nao';
        requestBody['date_of_capture'] = fundRaiser.expectedDate.toString();
        requestBody['captured_value'] = fundRaiser.predictedValue.toString();

        if (paid == true) {
          requestBody['payday'] = payDay.toString();
        }
      }

      var response = await httpClient.post(fundRaiserUrl,
          headers: {
            "Accept": "application/json",
            "Authorization": token,
          },
          body: requestBody);
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  updatePendingFundRaising(String token, FundRaising fundRaising) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/fundraising/${fundRaising.id}';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.put(fundRaiserUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "date_of_capture": fundRaising.dateOfCapture.toString(),
        "captured_value": fundRaising.capturedValue.toString(),
        "pago": fundRaising.pago.toString(),
        "payday": fundRaising.payDay.toString()
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  deleteFundRaiser(String token, User user) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/user/${user.id.toString()}';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.delete(
        fundRaiserUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  deleteFundRaising(String token, FundRaising fundRaising) async {
    try {
      Uri fundRaiserUrl;
      String url = '$baseUrl/v1/fundraising/${fundRaising.id}';
      fundRaiserUrl = Uri.parse(url);
      var response = await httpClient.delete(
        fundRaiserUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
