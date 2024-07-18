import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CompanyApiClient {
  final http.Client httpClient = http.Client();

  gettAll(String token) async {
    try {
      Uri companyUrl;
      String url =
          '$baseUrl/v1/company/mycompanies/${ServiceStorage.getUserId().toString()}';
      companyUrl = Uri.parse(url);
      var response = await httpClient.get(
        companyUrl,
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

  getAllAvailable(String token) async {
    try {
      Uri companyUrl;
      String url = '$baseUrl/v1/company/available';
      companyUrl = Uri.parse(url);
      var response = await httpClient.get(
        companyUrl,
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

  insertCompany(String token, String nome, String cnpj, String responsavel,
      String telefone, String nomePessoa) async {
    try {
      var companyUrl = Uri.parse('$baseUrl/v1/company');

      var request = http.MultipartRequest('POST', companyUrl);

      request.fields.addAll({
        "nome": nome,
        "cnpj": cnpj,
        "responsavel": responsavel,
        "telefone": telefone,
        "nome_pessoa": nomePessoa,
        "user_id": ServiceStorage.getUserId().toString(),
        "status": "1"
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);
      // print(json.decode(httpResponse.body));

      return json.decode(httpResponse.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  updateCompany(String token, Company company) async {
    try {
      Uri companyUrl;
      String url = '$baseUrl/v1/company/${company.id.toString()}';
      companyUrl = Uri.parse(url);
      var response = await httpClient.put(companyUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "nome": company.nome.toString(),
        "cnpj": company.cnpj.toString(),
        "responsavel": company.responsavel.toString(),
        "telefone": company.telefone.toString(),
        "nome_pessoa": company.nomePessoa.toString(),
        "user_id": ServiceStorage.getUserId().toString(),
        "status": "1"
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  unlinkCompany(String token, Company company) async {
    try {
      Uri companyUrl;
      String url =
          '$baseUrl/v1/company/desvincular/${ServiceStorage.getUserId().toString()}/${company.id.toString()}';
      companyUrl = Uri.parse(url);
      var response = await httpClient.post(
        companyUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
