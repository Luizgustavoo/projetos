import 'package:projetos/app/data/models/city_state_model.dart';
import 'package:projetos/app/data/providers/city_state_provider.dart';

class CityStateRepository {
  final CityStateApiClient apiClient = CityStateApiClient();

  getCities() async {
    List<CityState> list = <CityState>[];

    try {
      var response = await apiClient.getCities();

      if (response != null) {
        response['data'].forEach((e) {
          list.add(CityState.fromJson(e));
        });
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }

    return list;
  }

  getCitiesDonation() async {
    List<CityState> list = <CityState>[];

    try {
      var response = await apiClient.getCitiesDonation();

      if (response != null) {
        response['data'].forEach((e) {
          list.add(CityState.fromJson(e));
        });
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }

    return list;
  }
}
