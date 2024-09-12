import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/city_state_controller.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/company/widgets/contact_modal.dart';
import 'package:projetos/app/utils/service_storage.dart';
import 'package:projetos/app/utils/services.dart';
import 'package:searchfield/searchfield.dart';

class CreateCompanyModal extends GetView<CompanyController> {
  CreateCompanyModal({super.key, this.company});
  final userController = Get.put(FundRaiserController());
  final Company? company;
  final cityController = Get.put(CityStateController());

  @override
  Widget build(BuildContext context) {
    bool isUpdate = company != null;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: controller.companyKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  ServiceStorage.getUserType() == 1
                      ? 'CADASTRO DE PATROCINADOR'
                      : 'CADASTRO DE CLIENTE',
                  style: const TextStyle(
                    fontFamily: 'Poppinss',
                    fontSize: 17,
                    color: Color(0xFFEBAE1F),
                  ),
                ),
              ),
              const Divider(
                endIndent: 110,
                height: 5,
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller.nameCompanyController,
                decoration: const InputDecoration(
                  labelText: 'NOME DO PATROCINADOR',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.cnpjController,
                keyboardType: TextInputType.number,
                maxLength: 18,
                decoration:
                    const InputDecoration(labelText: 'CNPJ', counterText: ''),
                onChanged: (value) {
                  controller.onCnpjChanged(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o cnpj';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.responsibleCompanyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'RESPONSÁVEL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o responsável';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.contactController,
                maxLength: 15,
                decoration: const InputDecoration(
                    labelText: 'TELEFONE', counterText: ''),
                onChanged: (value) {
                  controller.onContactChanged(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.peopleContactController,
                decoration: const InputDecoration(
                  labelText: 'PESSOA CONTATO',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o contato da pessoa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.rolePeopleController,
                decoration: const InputDecoration(
                  labelText: 'CARGO PESSOA CONTATO',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.streetController,
                      decoration: const InputDecoration(
                        labelText: 'RUA',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: controller.numberController,
                      decoration: const InputDecoration(
                        labelText: 'Nº',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.neighborhoodController,
                decoration: const InputDecoration(
                  labelText: 'BAIRRO',
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return SearchField(
                  controller: controller.cityController,
                  suggestions: cityController.listCities.map((city) {
                    return SearchFieldListItem(city.cidadeEstado!);
                  }).toList(),
                  suggestionState: Suggestion.expand,
                  textInputAction: TextInputAction.next,
                  marginColor: Colors.grey,
                  searchStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                  searchInputDecoration: const InputDecoration(
                    labelText: 'CIDADE',
                  ),
                  itemHeight: 50,
                  onSuggestionTap: (suggestion) {
                    controller.cityController.text = suggestion.searchKey;
                  },
                );
              }),
              const SizedBox(height: 15),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'DOAÇÃO PATROCINADOR',
                  ),
                  value: controller.selectedCompanyDonation.value.isEmpty
                      ? null
                      : controller.selectedCompanyDonation.value,
                  items: [
                    'MENSAL',
                    'TRIMESTRAL',
                    'SEMESTRAL',
                    'ANUAL',
                  ].map((String donation) {
                    return DropdownMenuItem<String>(
                      value: donation,
                      child: Text(donation.toUpperCase(),
                          style: const TextStyle(fontFamily: 'Poppins')),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCompanyDonation.value = value!;
                  },
                );
              }),
              const SizedBox(height: 15),
              if (ServiceStorage.getUserType() == 1) ...[
                Obx(() {
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'CAPTADOR',
                    ),
                    value: controller.selectedUserId.value <= 0
                        ? null
                        : controller.selectedUserId.value,
                    items: userController.listFundRaiser.map((User user) {
                      return DropdownMenuItem<int>(
                        value: user.id,
                        child: Text(
                          user.name!,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedUserId.value = value!;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione um captador';
                      }
                      return null;
                    },
                  );
                }),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Services.isLoadingCRUD.value
                            ? const CircularProgressIndicator()
                            : TextButton(
                                onPressed: () async {
                                  Map<String, dynamic> retorno =
                                      await controller.insertCompany();

                                  if (retorno['success'] == true) {
                                    Get.put(ContactController());
                                    // print(retorno['data']);
                                    Company companyData = Company(
                                      id: retorno['data']['id'],
                                      nome: retorno['data']['nome'],
                                    );
                                    Get.back();
                                    Get.snackbar(
                                      'Sucesso!',
                                      retorno['message'].join('\n'),
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                      snackPosition: SnackPosition.BOTTOM,
                                    );

                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    Get.bottomSheet(
                                      backgroundColor: Colors.white,
                                      ContactModal(
                                        name: companyData.nome,
                                        company: companyData,
                                      ),
                                      isScrollControlled: true,
                                    );
                                  } else {
                                    Get.snackbar(
                                      'Falha!',
                                      retorno['message'].join('\n'),
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                                child: const Text(
                                  'NOVO CONTATO',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFEBAE1F),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'CANCELAR',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFFEBAE1F),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => Services.isLoadingCRUD.value
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  Map<String, dynamic> retorno = isUpdate
                                      ? await controller
                                          .updateCompany(company!.id)
                                      : await controller.insertCompany();

                                  if (retorno['success'] == true) {
                                    Get.back();
                                    Get.snackbar(
                                      'Sucesso!',
                                      retorno['message'].join('\n'),
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    Get.snackbar(
                                      'Falha!',
                                      retorno['message'].join('\n'),
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                                child: Text(
                                  isUpdate ? 'ATUALIZAR' : 'CADASTRAR',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
