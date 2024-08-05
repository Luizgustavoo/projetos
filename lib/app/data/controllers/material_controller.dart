import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/data/repositories/material_repository.dart';
import 'package:projetos/app/modules/material/views/pdf_view_page.dart';
import 'package:projetos/app/utils/service_storage.dart';
import 'package:http/http.dart' as http;

class MaterialController extends GetxController {
  final repository = Get.put(MaterialRepository());
  RxList<MaterialModel> listMaterial = RxList<MaterialModel>([]);
  RxBool isLoading = true.obs;
  final descriptionController = TextEditingController();
  final materialKey = GlobalKey<FormState>();
  final TextEditingController linkController = TextEditingController();
  final RxString selectedFileType = 'arquivo'.obs;
  final RxString pdfUrl = ''.obs;
  PlatformFile? selectedFile;

  MaterialModel? selectedMaterial;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;
  @override
  void onInit() {
    getAllMaterial();
    super.onInit();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    linkController.dispose();
    super.onClose();
  }

  Future<void> getAllMaterial() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listMaterial.value = await repository.getAll("Bearer $token");
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      selectedFile = result.files.first;
      pdfUrl.value = selectedFile!.name;
      Get.snackbar('Sucesso', 'PDF selecionado com sucesso!');
    } else {
      Get.snackbar('Erro', 'Nenhum arquivo selecionado.');
    }
  }

  insertMaterial() async {
    final token = ServiceStorage.getToken();
    if (!materialKey.currentState!.validate()) {
      return;
    }

    if (selectedFileType.value == 'arquivo' && selectedFile == null) {
      Get.snackbar('Erro', 'Nenhum arquivo PDF selecionado.');
      return;
    }

    String? videoLink;
    String? pdfUrl;

    if (selectedFileType.value == 'arquivo' && selectedFile != null) {
      pdfUrl = selectedFile!.path;
    } else {
      videoLink = linkController.text;
    }

    mensagem = await repository.insertMaterial(
      token,
      descriptionController.text,
      selectedFileType.value,
      pdfUrl,
      selectedFile,
      videoLink,
    );

    retorno = {'success': mensagem['success'], 'message': mensagem['message']};
    getAllMaterial();
    return retorno;
  }

  updateMaterial(int? id) async {
    final token = ServiceStorage.getToken();
    if (!materialKey.currentState!.validate()) {
      return;
    }

    if (selectedFileType.value == 'arquivo' && selectedFile == null) {
      Get.snackbar('Erro', 'Nenhum arquivo PDF selecionado.');
      return;
    }

    String? videoLink;
    String? pdfUrl;

    if (selectedFileType.value == 'arquivo' && selectedFile != null) {
      pdfUrl = selectedFile!.path;
    } else {
      videoLink = linkController.text;
    }

    mensagem = await repository.updateMaterial(
        token,
        descriptionController.text,
        selectedFileType.value,
        pdfUrl,
        selectedFile,
        videoLink,
        id);

    retorno = {'success': mensagem['success'], 'message': mensagem['message']};
    getAllMaterial();
    return retorno;
  }

  Future<Map<String, dynamic>> deleteMaterial(int? id) async {
    MaterialModel materialModel = MaterialModel(
      id: id,
    );
    final token = ServiceStorage.getToken();
    mensagem = await repository.deleteMaterial("Bearer $token", materialModel);
    retorno = {'success': mensagem['success'], 'message': mensagem['message']};

    getAllMaterial();
    return retorno;
  }

  void clearAllFields() {
    descriptionController.clear();
    linkController.clear();
    selectedFile = null;
    selectedFileType.value = 'arquivo';
    pdfUrl.value = '';
  }

  void fillAllFields() {
    descriptionController.text = selectedMaterial?.descricao.toString() ?? '';
    selectedFileType.value = selectedMaterial?.tipo.toString() ?? 'arquivo';

    if (selectedMaterial?.arquivoVideo.toString() != null) {
      if (selectedMaterial!.arquivoVideo!.contains('http')) {
        linkController.text = selectedMaterial!.arquivoVideo!;
      } else {
        pdfUrl.value = selectedMaterial!.arquivoVideo!;
        selectedFile = PlatformFile(
          name: selectedMaterial!.arquivoVideo!.split('/').last,
          size: 2,
        );
      }
    } else {
      linkController.clear();
      pdfUrl.value = '';
      selectedFile = null;
    }
  }

  void openPdf(String pdfUrl) async {
    final token = ServiceStorage.getToken();
    final url = 'http://192.168.25.50:8001/storage/arquivos/$pdfUrl';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 30)); // Timeout de 30 segundos

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = pdfUrl.split('/').last;
        final file = File('${directory.path}/$fileName');

        // Escrever o arquivo no disco
        await file.writeAsBytes(response.bodyBytes);

        // Navegar para a página de visualização de PDF
        Get.to(() => PdfViewPage(pdfUrl: file.path));
      } else {
        Get.snackbar('Erro',
            'Não foi possível abrir o PDF. Código de status: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Get.snackbar('Erro', 'A conexão com o servidor expirou.');
    } on SocketException catch (_) {
      Get.snackbar('Erro', 'Problema de rede. Verifique sua conexão.');
    } catch (e) {
      print('Erro ao abrir o PDF: $e');
      Get.snackbar('Erro', 'Não foi possível abrir o PDF.');
    }
  }
}
