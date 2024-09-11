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

  gettAll(String token, int id) async {
    try {
      String userId =
          id <= 0 ? ServiceStorage.getUserId().toString() : id.toString();
      Uri companyUrl;
      String url = '$baseUrl/v1/company/mycompanies/$userId';
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

  getAllExpirian(String token, int id) async {
    try {
      String userId =
          id <= 0 ? ServiceStorage.getUserId().toString() : id.toString();
      Uri companyUrl;
      String url = '$baseUrl/v1/company/expirian/$userId';
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

  gettAllCompany(String token) async {
    try {
      Uri companyUrl;
      String url = '$baseUrl/v1/company/';
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

  insertCompany(String token, Company company, int userId) async {
    try {
      var companyUrl = Uri.parse('$baseUrl/v1/company');

      var request = http.MultipartRequest('POST', companyUrl);

      request.fields.addAll({
        "nome": company.nome.toString(),
        "cnpj": company.cnpj.toString(),
        "responsavel": company.responsavel.toString(),
        "telefone": company.telefone.toString(),
        "nome_pessoa": company.nomePessoa.toString(),
        "user_id": ServiceStorage.getUserType() == 1
            ? userId.toString()
            : ServiceStorage.getUserId().toString(),
        "status": "1",
        "endereco": company.endereco.toString(),
        "numero": company.numero.toString(),
        "cidade": company.cidade.toString(),
        "estado": company.estado.toString(),
        "bairro": company.bairro.toString(),
        "tipo_captacao": company.tipoCaptacao.toString(),
        "cargo_contato": company.cargoContato.toString(),
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);
      return json.decode(httpResponse.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  updateCompany(String token, Company company, int userId) async {
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
        "user_id": ServiceStorage.getUserType() == 1
            ? userId.toString()
            : ServiceStorage.getUserId().toString(),
        "status": "1",
        "endereco": company.endereco.toString(),
        "numero": company.numero.toString(),
        "cidade": company.cidade.toString(),
        "estado": company.estado.toString(),
        "bairro": company.bairro.toString(),
        "tipo_captacao": company.tipoCaptacao.toString(),
        "cargo_contato": company.cargoContato.toString(),
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  unlinkCompany(String token, Company company, String tela) async {
    try {
      Uri companyUrl;
      String url =
          '$baseUrl/v1/company/desvincular/${ServiceStorage.getUserId().toString()}/${company.id.toString()}';
      companyUrl = Uri.parse(url);
      var response = await httpClient.post(companyUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "tipo_usuario": ServiceStorage.getUserType().toString(),
        "tela": tela
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  linkCompany(String token, Company company) async {
    try {
      Uri companyUrl;
      String url =
          '$baseUrl/v1/company/vincular/${ServiceStorage.getUserId().toString()}/${company.id.toString()}';
      companyUrl = Uri.parse(url);
      var response = await httpClient.post(
        companyUrl,
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
