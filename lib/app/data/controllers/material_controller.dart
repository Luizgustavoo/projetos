import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/data/repositories/material_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';

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
    return retorno;
  }
}
