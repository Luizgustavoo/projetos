import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/modules/company/widgets/custom_my_company_card.dart';
import 'package:projetos/app/modules/company/widgets/create_my_company_modal.dart';
import 'package:projetos/app/routes/app_routes.dart';

class MyCompanyView extends GetView<CompanyController> {
  const MyCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MINHAS EMPRESAS'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (controller.listCompany.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text('NÃO HÁ EMPRESAS PARA MOSTRAR'),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      itemCount: controller.listCompany.length,
                      itemBuilder: (context, index) {
                        Company company = controller.listCompany[index];
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              showDialog(context, company);
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              showModal(context, company);
                            }
                            return false;
                          },
                          background: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_rounded,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'CAPTAÇÃO',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          secondaryBackground: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'EXCLUIR',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.delete_forever,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              final contactController =
                                  Get.put(ContactController());
                              contactController.getContactCompanies(company);
                              Get.toNamed(Routes.contactcompany);
                            },
                            child: CustomCompanyCard(
                              name: company.nome,
                              phone: company.telefone,
                              contactName: company.nomePessoa,
                              responsible: company.responsavel,
                              color: const Color(0xFFFFF3DB),
                              company: company,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        elevation: 2,
        backgroundColor: Colors.orange,
        onPressed: () {
          controller.clearAllFields();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => const CreateCompanyModal(),
          );
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  void showModal(context, Company company) {
    final fundRaiserController = Get.put(FundRaiserController());
    fundRaiserController.clearAllFields();
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: fundRaiserController.fundRaisingKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'CAPTAÇÕES',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    company.nome!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: fundRaiserController.dateFundController,
                    maxLength: 10,
                    decoration: const InputDecoration(
                        labelText: 'DATA PREVISTA', counterText: ''),
                    onChanged: (value) {
                      fundRaiserController.onFundRaiserDateChanged(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fundRaiserController.valueFundController,
                    decoration: const InputDecoration(
                      labelText: 'VALOR PREVISTO',
                    ),
                    onChanged: (value) {
                      fundRaiserController.onValueChanged(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> retorno =
                              await fundRaiserController
                                  .insertFundRaising(company.id!);

                          if (retorno['success'] == true) {
                            Get.back();
                            Get.snackbar(
                                'Sucesso!', retorno['message'].join('\n'),
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar(
                                'Falha!', retorno['message'].join('\n'),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        child: const Text(
                          "CONFIRMAR",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("CANCELAR"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDialog(context, Company company) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja desativar a empresa ${company.nome}?",
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> retorno =
                await controller.unlinkCompany(company.id);

            if (retorno['success'] == true) {
              Get.back();
              Get.snackbar('Sucesso!', retorno['message'].join('\n'),
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
          child: const Text(
            "CONFIRMAR",
            style: TextStyle(fontFamily: 'Poppinss', color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "CANCELAR",
            style: TextStyle(fontFamily: 'Poppinss'),
          ),
        ),
      ],
    );
  }
}
