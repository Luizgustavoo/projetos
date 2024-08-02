import 'package:file_picker/file_picker.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/data/providers/material_provider.dart';

class MaterialRepository {
  final MaterialApiClient apiClient = MaterialApiClient();

  getAll(String token) async {
    List<MaterialModel> list = <MaterialModel>[];

    var response = await apiClient.getAll(token);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(MaterialModel.fromJson(e));
      });
    }

    return list;
  }

  insertMaterial(
    String token,
    String description,
    String fileType,
    String? pdfUrl,
    PlatformFile? selectedFile,
    String? videoLink,
  ) async {
    try {
      await apiClient.insertMaterial(
          token, description, fileType, pdfUrl, selectedFile, videoLink);
    } catch (e) {
      print(e);
    }
  }
}