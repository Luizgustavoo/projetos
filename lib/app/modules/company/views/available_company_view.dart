import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/modules/company/widgets/custom_my_company_card.dart';

class AvailableCompanyView extends GetView<CompanyController> {
  const AvailableCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMPRESAS DISPONÍVEIS'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Obx(() {
              return Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      itemCount: controller.listAvailableCompany.length,
                      itemBuilder: (context, index) {
                        Company company =
                            controller.listAvailableCompany[index];
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              showDialog(context, company, controller);
                            }
                            return false;
                          },
                          background: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange,
                            ),
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'VINCULAR',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.check_rounded,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: CustomCompanyCard(
                            name: company.nome,
                            phone: company.telefone,
                            contactName: company.nomePessoa,
                            responsible: company.responsavel,
                            color: Colors.green.shade100,
                          ),
                        );
                      }));
            }),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  void showDialog(context, Company company, CompanyController controller) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: Text(
        textAlign: TextAlign.center,
        "Deseja vincular a empresa ${company.nome} à você?",
        style: const TextStyle(
          fontFamily: 'Poppinss',
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> retorno =
                await controller.linkCompany(company.id!);

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
    );
  }
}
