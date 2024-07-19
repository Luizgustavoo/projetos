import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
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
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    itemCount: controller.listExpirianCompany.length,
                    itemBuilder: (context, index) {
                      return CustomCompanyCard(
                        name:
                            'EMPRESA: ${controller.listExpirianCompany[index].nome}',
                        phone:
                            'TELEFONE: ${controller.listExpirianCompany[index].telefone}',
                        responsible:
                            'RESPONSÁVEL DA EMPRESA: ${controller.listExpirianCompany[index].responsavel}',
                        contactName:
                            'NOME DO CONTATO: ${controller.listExpirianCompany[index].nomePessoa}',
                        color: Colors.red.shade100,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
