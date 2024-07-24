import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';
import 'package:projetos/app/modules/fundraiser/widgets/custom_pending_fundirising_card.dart';

class PendingFundRisingView extends GetView<FundRaiserController> {
  const PendingFundRisingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAPTAÇÕES PENDENTES'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(() {
              if (controller.isLoading.value) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Expanded(
                  child: controller.listAproveFundRising.isEmpty
                      ? const Center(
                          child: Text('NÃO HÁ EMPRESAS PARA MOSTRAR'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          itemCount: controller.listAproveFundRising.length,
                          itemBuilder: (context, index) {
                            FundRaising fundRaising =
                                controller.listAproveFundRising[index];
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  showModal(context, fundRaising, controller);
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
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'ATUALIZAR',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10),
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
                              child: CustomPendingFundRaiserCard(
                                companyName: fundRaising.empresa,
                                predictedValue: controller.formatValue(
                                    int.parse(
                                        fundRaising.predictedValue.toString())),
                                predictedDate: controller.formatDate(
                                    fundRaising.expectedDate.toString()),
                                status: fundRaising.status,
                                fundRaiser: fundRaising.user!.name,
                              ),
                            );
                          },
                        ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  void showModal(
      context, FundRaising fundRaising, FundRaiserController controller) {
    controller.clearAllFields();
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.pendingFundRaisingKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ARRECADAÇÕES',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fundRaising.empresa!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.datePendingFundController,
                    maxLength: 10,
                    decoration: const InputDecoration(
                        labelText: 'DATA CAPTAÇÃO', counterText: ''),
                    onChanged: (value) {
                      controller.onPendingDateChanged(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.pendingValueFundController,
                    decoration: const InputDecoration(
                      labelText: 'VALOR CAPTADO',
                    ),
                    onChanged: (value) {
                      controller.onPendingValueChanged(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> retorno = await controller
                              .updatePendingFundRaising(fundRaising.id);

                          if (retorno['success'] == true) {
                            Get.back();
                            Get.snackbar(
                                'Sucesso!', retorno['message'].join('\n'),
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar(
                                'Falha!', retorno['message'].join('\n'),
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
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
