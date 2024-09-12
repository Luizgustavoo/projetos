import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/providers/company_provider.dart';

class CompanyRepository {
  final CompanyApiClient apiClient = CompanyApiClient();

  gettAll(String token, int id) async {
    List<Company> list = <Company>[];

    var response = await apiClient.getAll(token, id);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Company.fromJson(e));
      });
    }

    return list;
  }

  gettAllAvailable(String token) async {
    List<Company> list = <Company>[];

    var response = await apiClient.getAllAvailable(token);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Company.fromJson(e));
      });
    }

    return list;
  }

  getAllExpirian(String token, int id) async {
    List<Company> list = <Company>[];

    var response = await apiClient.getAllExpirian(token, id);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Company.fromJson(e));
      });
    }

    return list;
  }

  gettAllCompany(String token) async {
    List<Company> list = <Company>[];

    var response = await apiClient.gettAllCompany(token);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Company.fromJson(e));
      });
    }

    return list;
  }

  insertCompany(String token, Company company, int userId) async {
    try {
      var response = await apiClient.insertCompany(token, company, userId);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updateCompany(String token, Company company, int userId) async {
    try {
      var response = await apiClient.updateCompany(token, company, userId);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  unlinkCompany(String token, Company company, String tela) async {
    try {
      var response = await apiClient.unlinkCompany(token, company, tela);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  linkCompany(String token, Company company) async {
    try {
      var response = await apiClient.linkCompany(token, company);

      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
