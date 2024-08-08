import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/controllers/report_controller.dart';
import 'package:projetos/app/data/models/user_model.dart';
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
          child: Column(
            children: [
              CustomReportCard(
                onTap: () async {
                  await controller.getReport(controller.selectedUserId.value!);
                  await controller
                      .generatePdf(controller.selectedUserId.value!);
                },
                title: 'RELATÓRIO CAPTADOR',
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Obx(() {
                      return DropdownButtonFormField<User>(
                        decoration: const InputDecoration(
                          hintText: 'CAPTADOR',
                        ),
                        value: controller.selectedUserId.value,
                        items: userController.listFundRaiser.map((User user) {
                          return DropdownMenuItem<User>(
                            value: user,
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
            ],
          ),
        ),
      ),
    );
  }
}
