// ignore_for_file: unrelated_type_equality_checks

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
                  if (controller.selectedUserId.value == null) {
                    Get.snackbar('ATENÇÃO', 'Selecione um captador',
                        backgroundColor: Colors.orange,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        colorText: Colors.white);
                  } else {
                    await controller
                        .getReport(controller.selectedUserId.value!);

                    if (controller.listReport.isEmpty) {
                      Get.snackbar('ATENÇÃO',
                          'Este captador ainda não fez nenhum contato!',
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 3),
                          colorText: Colors.white);
                    } else {
                      await controller
                          .generatePdf(controller.selectedUserId.value!);
                    }
                  }
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
                        value: controller.selectedUserId.value == 0
                            ? null
                            : controller.selectedUserId.value,
                        items: [
                          const DropdownMenuItem<User>(
                            value: null,
                            child: Text(
                              'Selecione um captador',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),
                          ...userController.listFundRaiser.map((User user) {
                            return DropdownMenuItem<User>(
                              value: user,
                              child: Tooltip(
                                message: user.name!,
                                child: Text(
                                  user.name!.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          controller.selectedUserId.value = value ?? User();
                        },
                        validator: (value) {
                          if (value == null || value.id == 0) {
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
