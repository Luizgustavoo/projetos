import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
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
          children: [
            const SizedBox(height: 10),
            Obx(
              () => Expanded(
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
                      })),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
