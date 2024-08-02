import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/data/providers/home_provider.dart';

class HomeRepository {
  final HomeApiClient apiClient = HomeApiClient();

  updatePasswordUser(String token, User user) async {
    try {
      var response = await apiClient.updatePasswordUser(token, user);

      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
