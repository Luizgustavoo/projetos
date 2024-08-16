import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/repositories/company_repository.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CompanyController extends GetxController {
  RxList<Company> listAvailableCompany = RxList<Company>([]);
  var listExpirianCompany = <Company>[].obs;
  var listAllCompany = <Company>[].obs;
  var isLoading = true.obs;
  var listCompany = <Company>[].obs;
  var filteredAllCompanies = <Company>[].obs;
  var filteredMyCompanies = <Company>[].obs;

  var paidOutCheckboxValue = false.obs;
  var showPaymentDateField = false.obs;

  Company? selectedCompany;
  var selectedBillId = 0.obs;
  var selectedUserId = 0.obs;

  final companyKey = GlobalKey<FormState>();

  final nameCompanyController = TextEditingController();
  final cnpjController = TextEditingController();
  final responsibleCompanyController = TextEditingController();
  final contactController = TextEditingController();
  final peopleContactController = TextEditingController();
  final searchControllerAllCompany = TextEditingController();
  final searchControllerMyCompany = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final rolePeopleController = TextEditingController();
  final cityController = TextEditingController();
  final selectedState = ''.obs;
  final selectedCompanyDonation = ''.obs;

  final repository = Get.put(CompanyRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  @override
  void onInit() {
    super.onInit();
    searchControllerAllCompany.addListener(onSearchChanged);
    searchControllerMyCompany.addListener(onMySearchChanged);
  }

  // @override
  // void onClose() {
  //   searchControllerAllCompany.removeListener(onSearchChanged);
  //   searchControllerMyCompany.removeListener(onMySearchChanged);
  //   searchControllerAllCompany.dispose();
  //   searchControllerMyCompany.dispose();
  //   super.onClose();
  // }

  Future<void> getCompanies(int id) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listCompany.value = await repository.gettAll("Bearer $token", id);
      filteredMyCompanies.value = listCompany;
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

  Future<void> getExpirianCompanies(int id) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listExpirianCompany.value =
          await repository.getAllExpirian("Bearer $token", id);
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
      filteredAllCompanies.value = listAllCompany;
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertCompany() async {
    final token = ServiceStorage.getToken();
    Company company = Company(
      nome: nameCompanyController.text,
      cnpj: cnpjController.text,
      responsavel: responsibleCompanyController.text,
      telefone: contactController.text,
      nomePessoa: peopleContactController.text,
      endereco: streetController.text,
      numero: numberController.text,
      bairro: neighborhoodController.text,
      cidade: cityController.text,
      estado: selectedState.value,
      tipoCaptacao: selectedCompanyDonation.value,
      cargoContato: rolePeopleController.text,
    );
    if (companyKey.currentState!.validate()) {
      mensagem = await repository.insertCompany(
          "Bearer $token", company, selectedUserId.value);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      if (Get.currentRoute == Routes.mycompany) {
        int idd =
            ServiceStorage.getUserType() == 1 ? 0 : ServiceStorage.getUserId();
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
      endereco: streetController.text,
      numero: numberController.text,
      bairro: neighborhoodController.text,
      cidade: cityController.text,
      estado: selectedState.value,
      tipoCaptacao: selectedCompanyDonation.value,
      cargoContato: rolePeopleController.text,
    );
    final token = ServiceStorage.getToken();
    if (companyKey.currentState!.validate()) {
      mensagem = await repository.updateCompany(
          "Bearer $token", company, selectedUserId.value);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      if (Get.currentRoute == Routes.mycompany) {
        int idd =
            ServiceStorage.getUserType() == 1 ? 0 : ServiceStorage.getUserId();
        getCompanies(idd);
      } else {
        getAllCompanies();
      }
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
    if (ServiceStorage.getUserType() == 1) {
      getAllCompanies();
    } else {
      int idd =
          ServiceStorage.getUserType() == 1 ? 0 : ServiceStorage.getUserId();
      getCompanies(idd);
    }
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

  void onSearchChanged() {
    filterAllCompanies(searchControllerAllCompany.text);
  }

  void onMySearchChanged() {
    filterMyCompanies(searchControllerMyCompany.text);
  }

  void filterAllCompanies(String query) {
    if (query.isEmpty) {
      filteredAllCompanies.value = listAllCompany;
    } else {
      filteredAllCompanies.value = listAllCompany
          .where((company) =>
              company.nome!.toUpperCase().contains(query.toUpperCase()))
          .toList();
    }
  }

  void filterMyCompanies(String query) {
    if (query.isEmpty) {
      filteredMyCompanies.value = listCompany;
    } else {
      filteredMyCompanies.value = listCompany
          .where((company) =>
              company.nome!.toUpperCase().contains(query.toUpperCase()))
          .toList();
    }
  }

  void fillInFields() {
    nameCompanyController.text = selectedCompany!.nome ?? "";
    cnpjController.text = selectedCompany!.cnpj ?? "";
    responsibleCompanyController.text = selectedCompany!.responsavel ?? "";
    contactController.text = selectedCompany!.telefone ?? "";
    peopleContactController.text = selectedCompany!.nomePessoa ?? "";
    streetController.text = selectedCompany!.endereco ?? "";
    numberController.text = selectedCompany!.numero ?? "";
    neighborhoodController.text = selectedCompany!.bairro ?? "";
    rolePeopleController.text = selectedCompany!.cargoContato ?? "";
    cityController.text = selectedCompany!.cidade ?? "";
    selectedState.value = selectedCompany!.estado ?? "";
    selectedCompanyDonation.value = selectedCompany!.tipoCaptacao ?? "";
  }

  void clearAllFields() {
    final textControllers = [
      nameCompanyController,
      cnpjController,
      responsibleCompanyController,
      contactController,
      peopleContactController,
      streetController,
      numberController,
      neighborhoodController,
      cityController,
      rolePeopleController,
    ];
    selectedState.value = '';
    selectedCompanyDonation.value = '';

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
