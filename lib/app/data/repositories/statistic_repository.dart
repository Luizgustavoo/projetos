import 'package:projetos/app/data/providers/statistic_provider.dart';

class StatisticRepository {
  final StatisticApiClient apiClient = StatisticApiClient();

  gettAll(String token) async {
    var response = await apiClient.gettAll(token);

    if (response != null) {
      return response['data'];
    }

    return null;
  }
}
