import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/data/models/bill_model.dart';

class BillApiClient {
  final http.Client httpClient = http.Client();

  gettAll(String token) async {
    try {
      Uri companyUrl;

      String url = '$baseUrl/v1/bills';

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

  insertBill(String token, Bill bill) async {
    try {
      var companyUrl = Uri.parse('$baseUrl/v1/bills');

      var request = http.MultipartRequest('POST', companyUrl);

      request.fields.addAll({
        "nome": bill.nome.toString(),
        "ano": bill.ano.toString(),
        "status": bill.status.toString(),
        "valor_aprovado": bill.valorAprovado.toString(),
        "observacoes": bill.observacoes.toString(),
        "porcentagem_comissao": bill.porcentagem.toString()
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

  updateBill(String token, Bill bill) async {
    try {
      Uri billUrl;
      String url = '$baseUrl/v1/bills/${bill.id.toString()}';
      billUrl = Uri.parse(url);
      var response = await httpClient.put(billUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "nome": bill.nome.toString(),
        "ano": bill.ano.toString(),
        "status": bill.status.toString(),
        "valor_aprovado": bill.valorAprovado.toString(),
        "observacoes": bill.observacoes.toString(),
        "porcentagem_comissao": bill.porcentagem.toString()
      });
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  deleteBill(String token, Bill bill) async {
    try {
      Uri billUrl;
      String url = '$baseUrl/v1/bills/${bill.id.toString()}';
      billUrl = Uri.parse(url);
      var response = await httpClient.delete(
        billUrl,
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
