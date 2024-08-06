import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/data/repositories/material_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> youtube(String url) async {
    var youtube = url;
    var androidUrl = "https://www.youtube.com/watch?v=$youtube";
    var iosUrl = "https://wa.me/$youtube";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      Get.snackbar('Falha', 'Youtube não instalado!',
          backgroundColor: Colors.red.shade500,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
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
}
