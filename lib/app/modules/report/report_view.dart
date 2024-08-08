import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/controllers/report_controller.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/modules/report/widgets/custom_report_card.dart';

class ReportView extends GetView<ReportController> {
  ReportView({super.key});
  final userController = Get.put(FundRaiserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('RELATÓRIOS'),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(children: [
            CustomReportCard(
              onTap: () async {
                await controller.getReport(controller.selectedUserId.value);
                // Exibe os dados do relatório
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ReportDetails(listReport: controller.listReport);
                  },
                );
              },
              title: 'RELATÓRIO CAPTADOR',
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Obx(() {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        hintText: 'CAPTADOR',
                      ),
                      value: controller.selectedUserId.value <= 0
                          ? null
                          : controller.selectedUserId.value,
                      items: userController.listFundRaiser.map((user) {
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
              ),
            )
          ]),
        )));
  }
}

class ReportDetails extends StatelessWidget {
  final RxList<ContactCompany> listReport;

  const ReportDetails({super.key, required this.listReport});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listReport.length,
      itemBuilder: (context, index) {
        final report = listReport[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'RELATÓRIO ${report.nomePessoa}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text('Empresa: ${report.empresa}'),
            Text('Contato: ${report.nomePessoa}'),
            Text('Retorno: ${report.dataRetorno}'),
            Text('Previsão Valor: ${report.previsaoValor}'),
            Text('Mês Depósito: ${report.mesDeposito}'),
            const SizedBox(height: 10),
            const Text('Observações:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(report.observacoes!),
            const Divider(),
          ],
        );
      },
    );
  }
}
