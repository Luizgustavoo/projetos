import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/repositories/company_repository.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CompanyController extends GetxController {
  // RxList<Company> listCompany = RxList<Company>([]);
  RxList<Company> listAvailableCompany = RxList<Company>([]);
  var listExpirianCompany = <Company>[].obs;
  var listAllCompany = <Company>[].obs;
  var isLoading = true.obs;
  var listCompany = <Company>[].obs;

  Company? selectedCompany;

  var selectedUserId = 0.obs;
  var selectedBillId = 0.obs;

  final companyKey = GlobalKey<FormState>();

  final nameCompanyController = TextEditingController();
  final cnpjController = TextEditingController();
  final responsibleCompanyController = TextEditingController();
  final contactController = TextEditingController();
  final peopleContactController = TextEditingController();

  final repository = Get.put(CompanyRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<void> getCompanies(int id) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listCompany.value = await repository.gettAll("Bearer $token", id);
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getAvailableCompanies() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listAvailableCompany.value =
          await repository.gettAllAvailable("Bearer $token");
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getExpirianCompanies() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listExpirianCompany.value =
          await repository.getAllExpirian("Bearer $token");
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getAllCompanies() async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listAllCompany.value = await repository.gettAllCompany("Bearer $token");
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertCompany() async {
    final token = ServiceStorage.getToken();
    if (companyKey.currentState!.validate()) {
      mensagem = await repository.insertCompany(
          "Bearer $token",
          nameCompanyController.text,
          cnpjController.text,
          responsibleCompanyController.text,
          contactController.text,
          peopleContactController.text,
          selectedUserId.value);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      if (Get.currentRoute == Routes.mycompany) {
        int idd = ServiceStorage.getUserType() == 1 ? 0 : ServiceStorage.getUserId();
        getCompanies(idd);
      } else {
        getAllCompanies();
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateCompany(int? id) async {
    Company company = Company(
      id: id,
      nome: nameCompanyController.text,
      cnpj: cnpjController.text,
      responsavel: responsibleCompanyController.text,
      telefone: contactController.text,
      nomePessoa: peopleContactController.text,
    );
    final token = ServiceStorage.getToken();
    if (companyKey.currentState!.validate()) {
      mensagem = await repository.updateCompany("Bearer $token", company);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      int idd = ServiceStorage.getUserType() == 1 ? 0 : ServiceStorage.getUserId();
      getCompanies(idd);
    }
    return retorno;
  }

  Future<Map<String, dynamic>> unlinkCompany(int? id) async {
    Company company = Company(
      id: id,
    );
    final token = ServiceStorage.getToken();
    mensagem = await repository.unlinkCompany("Bearer $token", company);
    retorno = {'success': mensagem['success'], 'message': mensagem['message']};
    int idd = ServiceStorage.getUserType() == 1 ? 0 : ServiceStorage.getUserId();
    getCompanies(idd);
    return retorno;
  }

  Future<Map<String, dynamic>> linkCompany(int? id) async {
    Company company = Company(
      id: id,
    );
    final token = ServiceStorage.getToken();
    mensagem = await repository.linkCompany("Bearer $token", company);
    retorno = {'success': mensagem['success'], 'message': mensagem['message']};
    getAvailableCompanies();
    return retorno;
  }

  void fillInFields() {
    nameCompanyController.text = selectedCompany!.nome.toString();
    cnpjController.text = selectedCompany!.cnpj.toString();
    responsibleCompanyController.text = selectedCompany!.responsavel.toString();
    contactController.text = selectedCompany!.telefone.toString();
    peopleContactController.text = selectedCompany!.nomePessoa.toString();
  }

  void clearAllFields() {
    final textControllers = [
      nameCompanyController,
      cnpjController,
      responsibleCompanyController,
      contactController,
      peopleContactController
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  void onCnpjChanged(String value) {
    cnpjController.value = cnpjController.value.copyWith(
      text: FormattedInputers.formatCpfCnpj(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatCpfCnpj(value).length),
    );
  }

  void onContactChanged(String value) {
    contactController.value = contactController.value.copyWith(
      text: FormattedInputers.formatContact(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatContact(value).length),
    );
  }
}
