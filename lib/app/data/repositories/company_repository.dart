import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/providers/company_provider.dart';

class CompanyRepository {
  final CompanyApiClient apiClient = CompanyApiClient();

  gettAll(String token) async {
    List<Company> list = <Company>[];

    var response = await apiClient.gettAll(token);

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

  getAllExpirian(String token) async {
    List<Company> list = <Company>[];

    var response = await apiClient.getAllExpirian(token);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Company.fromJson(e));
      });
    }

    return list;
  }

  insertCompany(String token, String nome, String cnpj, String responsavel,
      String telefone, String nomePessoa) async {
    try {
      var response = await apiClient.insertCompany(
          token, nome, cnpj, responsavel, telefone, nomePessoa);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updateCompany(String token, Company company) async {
    try {
      var response = await apiClient.updateCompany(token, company);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  unlinkCompany(String token, Company company) async {
    try {
      var response = await apiClient.unlinkCompany(token, company);

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
