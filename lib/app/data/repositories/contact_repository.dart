import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/data/providers/contact_provider.dart';

class ContactRepository {
  final ContactApiClient apiClient = ContactApiClient();

  getAll(String token, Company company, {dynamic id}) async {
    List<ContactCompany> list = <ContactCompany>[];

    var response = await apiClient.gettAll(token, company, id: id);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(ContactCompany.fromJson(e));
      });
    }

    return list;
  }

  insertContactCompany(String token, ContactCompany contactCompany) async {
    try {
      var response =
          await apiClient.insertContactCompany(token, contactCompany);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updateContactCompany(String token, ContactCompany contactCompany) async {
    try {
      var response =
          await apiClient.updateContactCompany(token, contactCompany);

      return response;
    } catch (e) {
      Exception(e);
    }
  }

  unlinkContactCompany(String token, ContactCompany contactCompany) async {
    try {
      var response =
          await apiClient.unlinkContactCompany(token, contactCompany);

      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
