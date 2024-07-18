import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/data/repositories/contact_repository.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class ContactController extends GetxController {
  RxList<ContactCompany> listContactCompany = RxList<ContactCompany>([]);
  final dateContactController = TextEditingController(
      text: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()));
  final nameContactController = TextEditingController();
  final obsContactController = TextEditingController();

  final contactKey = GlobalKey<FormState>();
  RxBool isLoading = true.obs;

  ContactCompany? selectedContactCompany;

  final repository = Get.put(ContactRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<void> getContactCompanies({Company? company}) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listContactCompany.value =
          await repository.gettAll("Bearer $token", company!);
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertContactCompany(int companyId) async {
    final token = ServiceStorage.getToken();
    final companyController = Get.put(CompanyController());
    ContactCompany contactCompany = ContactCompany(
      companyId: companyId,
      nomePessoa: nameContactController.text,
      dateContact: dateContactController.text,
      observacoes: obsContactController.text,
    );

    if (contactKey.currentState!.validate()) {
      mensagem = await repository.insertContactCompany(
          "Bearer $token", contactCompany);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      companyController.getCompanies();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateContactCompany(int? companyId) async {
    ContactCompany contactCompany = ContactCompany(
      companyId: companyId,
      nomePessoa: nameContactController.text,
      dateContact: dateContactController.text,
      observacoes: obsContactController.text,
    );

    final token = ServiceStorage.getToken();
    if (contactKey.currentState!.validate()) {
      mensagem = await repository.updateContactCompany(
          "Bearer $token", contactCompany);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getContactCompanies();
    }
    return retorno;
  }

  void clearAllFields() {
    final textControllers = [nameContactController, obsContactController];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  void fillInFields() {
    if (selectedContactCompany!.dateContact != null &&
        selectedContactCompany!.dateContact!.isNotEmpty) {
      try {
        DateTime date = DateFormat('yyyy-MM-ddTHH:mm:ss')
            .parse(selectedContactCompany!.dateContact!);
        dateContactController.text =
            DateFormat('dd/MM/yyyy HH:mm').format(date);
      } catch (e) {
        dateContactController.clear();
      }
    } else {
      dateContactController.clear();
    }
    nameContactController.text = selectedContactCompany!.nomePessoa.toString();
    obsContactController.text = selectedContactCompany!.observacoes.toString();
  }

  String formatApiDate(String apiDate) {
    initializeTimeZones();

    final location = tz.getLocation('America/Sao_Paulo');

    DateTime date = DateTime.parse(apiDate);

    final tz.TZDateTime localDate = tz.TZDateTime.from(date, location);

    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm\'h\'');
    return formatter.format(localDate);
  }

  void onDateChanged(String value) {
    dateContactController.value = dateContactController.value.copyWith(
      text: FormattedInputers.formatDate(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatDate(value).length),
    );
  }
}
