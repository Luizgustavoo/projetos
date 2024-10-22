import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/financial_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CustomFinancialCard extends StatelessWidget {
  final Bill bill;
  final FinancialController controller;
  final int? id;
  final User? user;

  const CustomFinancialCard({
    super.key,
    required this.bill,
    required this.controller,
    this.id,
    this.user,
  });

  double calculateCommission(double capturedValue, double percentage) {
    return capturedValue * (percentage / 100);
  }

  @override
  Widget build(BuildContext context) {
    double totalCommission = bill.fundraisings!.fold(0.0, (sum, e) {
      double capturedValue =
          e.capturedValue != null ? e.capturedValue!.toDouble() : 0.0;
      double percentage = double.tryParse(bill.porcentagem.toString()) ?? 0.0;
      return sum + calculateCommission(capturedValue, percentage);
    });

    // Calcular o total pago e a pagar
    double totalPago = bill.fundraisings!.fold(0.0, (sum, e) {
      if (e.fundRaiserComission != null &&
          e.fundRaiserComission!.payday != null) {
        double capturedValue =
            e.capturedValue != null ? e.capturedValue!.toDouble() : 0.0;
        double percentage = double.tryParse(bill.porcentagem.toString()) ?? 0.0;
        return sum + calculateCommission(capturedValue, percentage);
      }
      return sum;
    });

    double totalAPagar = bill.fundraisings!.fold(0.0, (sum, e) {
      if (e.fundRaiserComission == null ||
          e.fundRaiserComission!.payday == null) {
        double capturedValue =
            e.capturedValue != null ? e.capturedValue!.toDouble() : 0.0;
        double percentage = double.tryParse(bill.porcentagem.toString()) ?? 0.0;
        return sum + calculateCommission(capturedValue, percentage);
      }
      return sum;
    });

    return Card(
      color: bill.status == 'aberto'
          ? const Color(0xFFFFF3DB)
          : Colors.red.shade100,
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ExpansionTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${bill.nome} - '.toUpperCase(),
                  style: const TextStyle(
                      fontFamily: 'Poppinss',
                      color: Colors.black54,
                      fontSize: 16),
                ),
                TextSpan(
                  text: 'SITUAÇÃO: ${bill.status}'.toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color:
                          bill.status == 'aberto' ? Colors.green : Colors.red),
                ),
              ]),
            ),
            const SizedBox(height: 5),
            Text(
              'TOTAL COMISSÃO: R\$${controller.formatValue(totalCommission.toStringAsFixed(2))}',
              style: const TextStyle(
                  fontFamily: 'Poppinss', fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 5),
            Text(
              ServiceStorage.getUserType() == 1
                  ? 'TOTAL PAGO: R\$${controller.formatValue(totalPago.toStringAsFixed(2))}'
                  : 'TOTAL RECEBIDO: R\$${controller.formatValue(totalPago.toStringAsFixed(2))}',
              style: const TextStyle(
                  fontFamily: 'Poppinss', fontSize: 14, color: Colors.green),
            ),
            Text(
              ServiceStorage.getUserType() == 1
                  ? 'TOTAL A PAGAR: R\$${controller.formatValue(totalAPagar.toStringAsFixed(2))}'
                  : 'TOTAL A RECEBER: R\$${controller.formatValue(totalAPagar.toStringAsFixed(2))}',
              style: const TextStyle(
                  fontFamily: 'Poppinss', fontSize: 14, color: Colors.red),
            ),
          ],
        ),
        children: bill.fundraisings!.map((e) {
          double capturedValue =
              e.capturedValue != null ? e.capturedValue!.toDouble() : 0.0;
          double percentage =
              double.tryParse(bill.porcentagem.toString()) ?? 0.0;
          double commission = calculateCommission(capturedValue, percentage);

          String pagoAreceber = e.fundRaiserComission != null &&
                  e.fundRaiserComission!.payday != null
              ? "(PAGO)"
              : "(A PAGAR)";

          return ListTile(
            title: Row(
              children: [
                SizedBox(
                  width: Get.width * 0.60,
                  child: Text(
                    e.company!.nome!.toUpperCase(),
                    style:
                        const TextStyle(fontFamily: 'Poppinss', fontSize: 13),
                  ),
                ),
                e.fundRaiserComission!.observacoes != null
                    ? IconButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'OBSERVAÇÕES',
                            titleStyle: const TextStyle(
                                fontFamily: 'Poppinss', fontSize: 15),
                            content: Text(
                              e.fundRaiserComission!.observacoes!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontFamily: 'Poppins', color: Colors.black),
                            ),
                            confirm: ElevatedButton(
                              onPressed: () {
                                Get.back(); // Fecha o diálogo
                              },
                              child: const Text(
                                'FECHAR',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.info,
                          size: 20,
                          color: Colors.blue,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            trailing: e.fundRaiserComission != null &&
                    e.fundRaiserComission!.status! == 'a_receber' &&
                    ServiceStorage.getUserType() == 1
                ? IconButton(
                    tooltip: 'Pagar',
                    onPressed: () async {
                      showUpdateBalanceDialog(context, e);
                    },
                    icon: const Icon(
                      FontAwesomeIcons.wallet,
                      color: Colors.green,
                    ))
                : const SizedBox.shrink(),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VALOR CAPTADO: R\$${controller.formatValue(capturedValue.toStringAsFixed(2))}',
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                Text(
                  'COMISSÃO: R\$${controller.formatValue(commission.toStringAsFixed(2))} - $pagoAreceber',
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                Text(
                  'DATA DE PAGAMENTO: ${e.fundRaiserComission != null && e.fundRaiserComission!.payday != null ? FormattedInputers.formatApiDate(e.fundRaiserComission!.payday.toString()) : "DATA INDISPONÍVEL"}',
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> showUpdateBalanceDialog(
      BuildContext context, FundRaising fundRaising) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        double commission = calculateCommission(
            fundRaising.capturedValue != null
                ? fundRaising.capturedValue!.toDouble()
                : 0,
            double.tryParse(bill.porcentagem.toString()) ?? 0.0);

        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Pagamento',
                    style: TextStyle(
                      fontFamily: 'Poppinss',
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    'Deseja pagar a comissão de R\$${controller.formatValue(commission.toString())}?',
                    style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.datePaymentController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'DATA PAGAMENTO', counterText: ''),
                    onChanged: (value) {
                      controller.onContactDateChanged(value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data de retorno';
                      }
                      // Validação da data no formato DD/MM/YYYY
                      return controller.validateDate(value)
                          ? null
                          : 'Data inválida. Por favor, insira no formato DD/MM/AAAA';
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.observationController,
                    maxLines: 5,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'OBSERVAÇÃO', counterText: ''),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancelar',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white)),
                      ),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> retorno =
                                await controller.updateFinancial(
                                    fundRaising.fundRaiserComission!.id!);

                            if (retorno['success'] == true) {
                              //começa

                              Get.back();
                              Get.back();
                              // Get.toNamed(Routes.financial, arguments: user);

                              //termina
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'PAGAR',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
