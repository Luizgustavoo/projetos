import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/user_model.dart';

class CreateCompanyModal extends GetView<CompanyController> {
  const CreateCompanyModal({super.key, this.company});

  final Company? company;

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
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    'CADASTRO DE EMPRESA',
                    style: TextStyle(
                        fontFamily: 'Poppinss',
                        fontSize: 17,
                        color: Color(0xFFEBAE1F)),
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
                    labelText: 'NOME DA EMPRESA',
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
                    labelText: 'RESPONSÁVEL EMPRESA',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a empresa';
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
                const SizedBox(height: 15),
                Obx(() {
                  final userController = Get.put(FundRaiserController());
                  if (userController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'CAPTADOR',
                      ),
                      items: userController.listFundRaiser.map((User user) {
                        return DropdownMenuItem<int>(
                          value: user.id,
                          child: Text(user.name!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedUserId.value = value!;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um usuário';
                        }
                        return null;
                      },
                    );
                  }
                }),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> retorno = isUpdate
                            ? await controller.updateCompany(company!.id)
                            : await controller.insertCompany();

                        if (retorno['success'] == true) {
                          Get.back();
                          Get.snackbar(
                              'Sucesso!', retorno['message'].join('\n'),
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM);
                        } else {
                          Get.snackbar('Falha!', retorno['message'].join('\n'),
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: Text(
                        isUpdate ? 'ATUALIZAR' : 'CADASTRAR',
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 120,
                      child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'CANCELAR',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFFEBAE1F)),
                          )),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
