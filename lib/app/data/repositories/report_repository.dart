import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/data/providers/report_provider.dart';

class ReportRepository {
  final ReportApiClient apiClient = ReportApiClient();

  getAllReport(String token, int id) async {
    List<ContactCompany> list = <ContactCompany>[];

    var response = await apiClient.getAllReport(token, id);

    if (response != null) {
      response['data'].forEach((e) {
        list.add(ContactCompany.fromJson(e));
      });
    }

    return list;
  }
}
