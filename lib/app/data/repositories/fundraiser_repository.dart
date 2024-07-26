import 'package:projetos/app/data/models/fundraiser_model.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/data/providers/fundraiser_provider.dart';

class FundRaiserRepository {
  final FundRaiserApiClient apiClient = FundRaiserApiClient();

  gettAllFundRaiser(String token) async {
    List<User> list = <User>[];

    var response = await apiClient.gettAllFundRaiser(token);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(User.fromJson(e));
      });
    }

    return list;
  }

  getAllPendingFundRising(String token) async {
    List<FundRaising> list = <FundRaising>[];

    var response = await apiClient.getAllPendingFundRising(token);
    print(response['data']);
    if (response != null) {
      response['data'].forEach((e) {
        list.add(FundRaising.fromJson(e));
      });
    }

    return list;
  }

  insertFundRaiser(String token, User user) async {
    try {
      var response = await apiClient.insertFundRaiser(token, user);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  insertFundRaising(String token, FundRaiser fundRaiser, int billId) async {
    try {
      var response =
          await apiClient.insertFundRaising(token, fundRaiser, billId);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updateFundRaise(String token, User user) async {
    try {
      var response = await apiClient.updateFundRaise(token, user);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updatePendingFundRaising(String token, FundRaising fundRaising) async {
    try {
      var response =
          await apiClient.updatePendingFundRaising(token, fundRaising);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  deleteFundRaiser(String token, User user) async {
    try {
      var response = await apiClient.deleteFundRaiser(token, user);

      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
