import 'package:get/get.dart';
import 'package:projetos/app/data/models/city_state_model.dart';
import 'package:projetos/app/data/repositories/city_state_repository.dart';

class CityStateController extends GetxController {
  final repository = Get.put(CityStateRepository());

  RxList<CityState> listCities = RxList<CityState>([]);
  RxList<CityState> filteredCities = RxList<CityState>([]); // Lista filtrada
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getCities();
    super.onInit();
  }

  Future<void> getCities() async {
    isLoading.value = true;
    try {
      listCities.value = await repository.getCities();
      filteredCities.value = listCities; // Inicialmente, todas as cidades
    } catch (e) {
      listCities.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  // Método para filtrar as cidades com base no texto digitado
  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities.value = listCities;
    } else {
      filteredCities.value = listCities
          .where((city) =>
              city.cidadeEstado!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
