import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:projetos/app/data/base_url.dart';

class MaterialApiClient {
  final http.Client httpClient = http.Client();

  final String materialUrl = '$baseUrl/v1/material';

  getAll(String token) async {
    try {
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
    var request = http.MultipartRequest('POST', Uri.parse(materialUrl));
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    });

    request.fields['descricao'] = description;
    request.fields['tipo'] = fileType;
    request.fields['status'] = '1';

    if (selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'arquivo_video', selectedFile.path!));
    } else if (videoLink != null) {
      request.fields['arquivo_video'] = videoLink;
    }

    var response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to register material');
    } else {
      return response;
    }
  }
}
