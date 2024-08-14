import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:projetos/app/data/base_url.dart';
import 'package:projetos/app/data/models/material_model.dart';

class MaterialApiClient {
  final http.Client httpClient = http.Client();

  getAll(String token) async {
    try {
      final String materialUrl = '$baseUrl/v1/material';
      var response = await httpClient.get(
        Uri.parse(materialUrl),
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

  insertMaterial(
    String token,
    String description,
    String fileType,
    String? pdfUrl,
    PlatformFile? selectedFile,
    String? videoLink,
  ) async {
    final String materialUrl = '$baseUrl/v1/material';
    var request = http.MultipartRequest('POST', Uri.parse(materialUrl));

    request.fields['descricao'] = description;
    request.fields['tipo'] = fileType;
    request.fields['status'] = '1';

    if (selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'arquivo_video', selectedFile.path!,
          contentType: MediaType('application', 'pdf')));
    } else if (videoLink != null) {
      request.fields['arquivo_video'] = videoLink;
    }

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    });

    var response = await request.send();
    var responseStream = await response.stream.bytesToString();
    var httpResponse = http.Response(responseStream, response.statusCode);
    if (httpResponse.statusCode != 201) {
      throw Exception('Falha ao registrar o material');
    } else {
      return json.decode(httpResponse.body);
    }
  }

  updateMaterial(
    String token,
    String description,
    String fileType,
    String? pdfUrl,
    PlatformFile? selectedFile,
    String? videoLink,
    int? id,
  ) async {
    try {
      String url = '$baseUrl/v1/material/update/${id.toString()}';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['descricao'] = description;
      request.fields['tipo'] = fileType;
      request.fields['status'] = '1';

      if (pdfUrl != null && selectedFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'arquivo_video',
          selectedFile.path!,
          contentType: MediaType('application', 'pdf'),
        ));
      } else if (videoLink != null) {
        request.fields['arquivo_video'] = videoLink;
      }

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      });

      var response = await request.send();
      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      if (httpResponse.statusCode != 201) {
        throw Exception('Failed to update material');
      } else {
        return json.decode(httpResponse.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  deleteMaterial(String token, MaterialModel materialModel) async {
    try {
      Uri materialUrl;
      String url = '$baseUrl/v1/material/delete/${materialModel.id}';
      materialUrl = Uri.parse(url);
      var response = await httpClient.post(
        materialUrl,
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

  // Future<String?> getPdfUrl(String token, int id) async {
  //   try {
  //     Uri materialUrl;
  //     String url = 'http://192.168.25.50:8001/storage/arquivos/';
  //     materialUrl = Uri.parse(url);
  //     var response = await httpClient.get(
  //       Uri.parse('$materialUrl/$id'),
  //       headers: {
  //         "Accept": "application/json",
  //         "Authorization": token,
  //       },
  //     );
  //     if (response.statusCode == 201) {
  //       final data = json.decode(response.body);
  //       // Supondo que o URL do PDF está no campo 'pdfUrl'
  //       return data['pdfUrl'];
  //     } else {
  //       throw Exception('Failed to get PDF URL');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to get PDF URL');
  //   }
  // }
}
