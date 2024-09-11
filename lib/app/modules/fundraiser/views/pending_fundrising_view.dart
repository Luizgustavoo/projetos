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
                  controller.listPendingFundRising.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    itemCount: controller.listPendingFundRising.length,
                    itemBuilder: (context, index) {
                      FundRaising fundRaising =
                          controller.listPendingFundRising[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (DismissDirection direction) async {
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
                          predictedValue: controller.formatValue(double.parse(
                              fundRaising.predictedValue.toString())),
                          predictedDate: controller
                              .formatDate(fundRaising.expectedDate.toString()),
                          status: fundRaising.status,
                          fundRaiser: fundRaising.user!.name,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: Text('NÃO HÁ EMPRESAS CAPTAÇÕES PENDENTES'),
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

    controller.datePendingFundController.text =
        controller.formatDate(fundRaising.expectedDate.toString());

    controller.pendingValueFundController.text =
        "R\$ ${controller.formatValue(double.parse(fundRaising.predictedValue.toString()))}";

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
                    'CONFIRMAR ARRECADAÇÃO',
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppinss'),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fundRaising.empresa!.toUpperCase(),
                    style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fundRaising.bill!.nome!.toUpperCase(),
                    style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "PREVISÃO: ${controller.formatDate(fundRaising.expectedDate.toString())} - R\$ ${controller.formatValue(double.parse(fundRaising.predictedValue.toString()))}",
                    style:
                        const TextStyle(fontSize: 13, fontFamily: 'Poppinss'),
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
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'DATA CAPTAÇÃO', counterText: ''),
                    onChanged: (value) {
                      controller.onPendingDateChanged(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
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
                    children: [
                      const Text(
                        'COMISSÃO PAGA?: ',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      Obx(() => Switch(
                            activeColor: Colors.orange.shade700,
                            inactiveThumbColor: Colors.orange.shade500,
                            inactiveTrackColor: Colors.orange.shade100,
                            value: controller.paidOutCheckboxValue.value,
                            onChanged: (value) {
                              controller.paidOutCheckboxValue.value = value;
                              controller.showPaymentDateField.value =
                                  value; // Atualiza a visibilidade do campo de data
                            },
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.showPaymentDateField.value) {
                      return TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller.paymentDateController,
                        decoration: const InputDecoration(
                          labelText: 'DATA DO PAGAMENTO',
                        ),
                        onChanged: (value) {
                          controller.onPaymentDateChanged(value);
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
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
