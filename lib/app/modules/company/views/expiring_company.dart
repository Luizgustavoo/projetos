import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/modules/company/widgets/custom_my_company_card.dart';

class ExpiringCompanyView extends GetView<CompanyController> {
  const ExpiringCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMPRESAS EXPIRANDO'),
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
                    controller.listExpirianCompany.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      itemCount: controller.listExpirianCompany.length,
                      itemBuilder: (context, index) {
                        Company company = controller.listExpirianCompany[index];
                        return CustomCompanyCard(
                          name: company.nome,
                          phone: company.telefone,
                          contactName: company.nomePessoa,
                          responsible: company.responsavel,
                          color: Colors.red.shade100,
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
              },
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
