import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/utils/service_storage.dart';

class ContactApiClient {
  final http.Client httpClient = http.Client();

  gettAll(String token, Company company) async {
    try {
      Uri contactCompanyUrl;
      String url =
          '$baseUrl/v1/contactcompany/${ServiceStorage.getUserId().toString()}/${company.id}';
      contactCompanyUrl = Uri.parse(url);
      var response = await httpClient.get(
        contactCompanyUrl,
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

  insertContactCompany(String token, ContactCompany contactCompany) async {
    try {
      Uri contactCompanyUrl;
      String url = '$baseUrl/v1/contactcompany';
      contactCompanyUrl = Uri.parse(url);
      var response = await httpClient.post(contactCompanyUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "date_contact": contactCompany.dateContact.toString(),
        "nome_pessoa": contactCompany.nomePessoa.toString(),
        "observacoes": contactCompany.observacoes.toString(),
        "user_id": ServiceStorage.getUserId().toString(),
        "company_id": contactCompany.companyId.toString(),
        "data_retorno": contactCompany.dataRetorno.toString(),
        "previsao_valor": contactCompany.previsaoValor.toString(),
        "mes_deposito": contactCompany.mesDeposito.toString()
      });
      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  updateContactCompany(String token, ContactCompany contactCompany) async {
    try {
      Uri contactCompanyUrl;
      String url = '$baseUrl/v1/contactcompany/${contactCompany.id.toString()}';
      contactCompanyUrl = Uri.parse(url);
      var response = await httpClient.put(contactCompanyUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "date_contact": contactCompany.dateContact.toString(),
        "nome_pessoa": contactCompany.nomePessoa.toString(),
        "observacoes": contactCompany.observacoes.toString(),
        "user_id": ServiceStorage.getUserId().toString(),
        "company_id": contactCompany.companyId.toString(),
        "data_retorno": contactCompany.dataRetorno.toString(),
        "previsao_valor": contactCompany.previsaoValor.toString(),
        "mes_deposito": contactCompany.mesDeposito.toString()
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  unlinkContactCompany(String token, ContactCompany contactCompany) async {
    try {
      Uri contactCompanyUrl;
      String url = '$baseUrl/v1/contactcompany/${contactCompany.id.toString()}';
      contactCompanyUrl = Uri.parse(url);
      var response = await httpClient.delete(
        contactCompanyUrl,
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
