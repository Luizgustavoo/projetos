import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
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
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              showDialog(context);
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
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.check_rounded,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: CustomCompanyCard(
                            name:
                                'NOME: ${controller.listAvailableCompany[index].nome}',
                            phone:
                                'TELEFONE: ${controller.listAvailableCompany[index].telefone}',
                            contact:
                                'CONTATO: ${controller.listAvailableCompany[index].nomePessoa}',
                            pickup: '',
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

  void showDialog(context) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: const Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja ........... ?",
        style: TextStyle(
          fontFamily: 'Poppinss',
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("CANCELAR"),
        ),
        ElevatedButton(
          onPressed: () async {
            // Get.snackbar(
            //   snackPosition: SnackPosition.BOTTOM,
            //   duration: const Duration(milliseconds: 1500),
            //   retorno['return'] == 0 ? 'Sucesso' : "Falha",
            //   retorno['message'],
            //   backgroundColor:
            //       retorno['return'] == 0 ? Colors.green : Colors.red,
            //   colorText: Colors.white,
            // );
          },
          child: const Text(
            "CONFIRMAR",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
