import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/modules/company/widgets/create_my_company_modal.dart';
import 'package:projetos/app/modules/company/widgets/custom_my_company_card.dart';
import 'package:projetos/app/routes/app_routes.dart';

class AllCompanyView extends GetView<CompanyController> {
  const AllCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODAS EMPRESAS'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Obx(() {
              if (controller.isLoading.value) {
                return const Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Carregando...'),
                        SizedBox(height: 20.0),
                        CircularProgressIndicator(
                          value: 5,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (!controller.isLoading.value &&
                  controller.listCompany.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    itemCount: controller.listAllCompany.length,
                    itemBuilder: (context, index) {
                      Company company = controller.listAllCompany[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.contacttimeline,
                              arguments: company);
                        },
                        child: CustomCompanyCard(
                          name: company.nome,
                          responsible: company.responsavel,
                          phone: company.telefone,
                          contactName: company.nomePessoa,
                          company: company,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: Text('NÃO HÁ EMPRESAS PARA MOSTRAR'),
                  ),
                );
              }
            }),
            const SizedBox(height: 10)
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
}
