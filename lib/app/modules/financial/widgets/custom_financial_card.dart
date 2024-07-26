import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/financial_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';

class CustomFinancialCard extends StatelessWidget {
  final Bill bill;
  final FinancialController controller;

  const CustomFinancialCard(
      {super.key, required this.bill, required this.controller});

  double calculateCommission(int capturedValue, double percentage) {
    return capturedValue * (percentage / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF3DB),
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          bill.nome!.toUpperCase(),
          style: const TextStyle(fontFamily: 'Poppinss'),
        ),
        children: bill.fundraisings!.map((e) {
          int capturedValue =
              e.capturedValue != null ? e.capturedValue!.toInt() : 0;
          double percentage =
              double.tryParse(bill.porcentagem.toString()) ?? 0.0;
          double commission = calculateCommission(capturedValue, percentage);

          return ListTile(
            title: Text(
              e.company!.nome!.toUpperCase(),
              style: const TextStyle(fontFamily: 'Poppinss'),
            ),
            trailing: e.fundRaiserComission != null &&
                    e.fundRaiserComission!.status! == 'a_receber'
                ? IconButton(
                    onPressed: () async {
                      Map<String, dynamic> retorno = await controller
                          .updateFinancial(e.fundRaiserComission!.id!);

                      if (retorno['success'] == true) {
                        Get.back();
                        Get.snackbar('Sucesso!', retorno['message'].join('\n'),
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.BOTTOM);
                      } else {
                        Get.snackbar('Falha!', retorno['message'].join('\n'),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    icon: const Icon(
                      Icons.payments_rounded,
                      color: Colors.green,
                    ))
                : const SizedBox(),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VALOR CAPTADO: R\$${controller.formatValue(capturedValue.toString())}',
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                Text(
                  'COMISSÃO: R\$${controller.formatValue(commission.toInt())}',
                  style: const TextStyle(fontFamily: 'Poppins'),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
