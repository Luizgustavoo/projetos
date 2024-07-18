import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/modules/company/widgets/custom_my_company_card.dart';

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
            const SizedBox(height: 15),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return CustomCompanyCard(
                        name: 'NOME: NOME DA INDUSTRIA',
                        phone: 'TELEFONE: (43)9 9999-9999',
                        responsible: 'CONTATO: NOME PESSOA CONTATO',
                        contactName: 'CAPTADOR: NOME DO CAP DA EMPRESA',
                        color: Colors.blue.shade100,
                      );
                    })),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
