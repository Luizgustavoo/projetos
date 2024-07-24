import 'package:get/get.dart';
import 'package:projetos/app/data/repositories/statistic_repository.dart';
import 'package:projetos/app/utils/service_storage.dart';

class StatisticController extends GetxController {
  RxBool isLoading = true.obs;

  RxInt expiredCompanies = 0.obs;
  RxInt availableCompanies = 0.obs;
  RxInt totalCompanies = 0.obs;

  final repository = Get.put(StatisticRepository());

  @override
  void onInit() {
    getStatistics();
    super.onInit();
  }

  Future<void> getStatistics() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      final data = await repository.gettAll("Bearer $token");

      if (data != null) {
        expiredCompanies.value = data['expired_companies'];
        availableCompanies.value = data['available_companies'];
        totalCompanies.value = data['total_companies'];
      }
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }
}
