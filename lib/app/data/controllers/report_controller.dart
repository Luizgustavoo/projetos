import 'package:get/get.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/data/repositories/report_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';

class ReportController extends GetxController {
  RxList<ContactCompany> listReport = RxList<ContactCompany>([]);
  RxBool isLoading = true.obs;
  var selectedUserId = 0.obs;
  final repository = Get.put(ReportRepository());
  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<void> getReport(int id) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listReport.value = await repository.getAllReport("Bearer $token", id);
      update();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }
}
