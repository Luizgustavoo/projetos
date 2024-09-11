import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ContactTimeLineView extends GetView<CompanyController> {
  const ContactTimeLineView({super.key});

  @override
  Widget build(BuildContext context) {
    final Company company = Get.arguments as Company;

    // Calcula o total doado
    double totalDoado = company.fundraisings!
        .where((fundRaising) => fundRaising.status == 'captado')
        .fold(0.0, (sum, fundRaising) => sum + fundRaising.capturedValue!);

    return Scaffold(
      appBar: AppBar(
        title: Text('CAPTAÇÕES ${company.nome!.toUpperCase()}'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: company.fundraisings!.isEmpty
            ? const Center(
                child: Text(
                  'NENHUMA CAPTAÇÃO PARA A EMPRESA SELECIONADA!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              )
            : ListView.builder(
                itemCount: company.fundraisings!.length,
                itemBuilder: (context, index) {
                  FundRaising fundRaising = company.fundraisings![index];

                  String dataCap = fundRaising.status == 'aguardando'
                      ? "DATA PREVISTA: ${FormattedInputers.formatApiDate(fundRaising.expectedDate.toString())}"
                      : "DATA CAPTAÇÃO: ${FormattedInputers.formatApiDate(fundRaising.dateOfCapture.toString())}";

                  dynamic valor = fundRaising.status == 'aguardando'
                      ? FormattedInputers.formatValuePTBR(
                          fundRaising.predictedValue.toString())
                      : FormattedInputers.formatValuePTBR(
                          fundRaising.capturedValue.toString());

                  return TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.0,
                    beforeLineStyle: const LineStyle(
                      color: Colors.orange,
                      thickness: 2,
                    ),
                    afterLineStyle: const LineStyle(
                      color: Colors.orange,
                      thickness: 2,
                    ),
                    indicatorStyle: IndicatorStyle(
                      width: 15,
                      color: Colors.orange.shade100,
                      indicatorXY: 0.5,
                      padding: const EdgeInsets.all(8),
                    ),
                    endChild: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: fundRaising.status == 'captado'
                            ? Colors.green.shade300
                            : Colors.red.shade300,
                      ),
                      constraints: const BoxConstraints(
                        minHeight: 120,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataCap,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppinss',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'VALOR: R\$ $valor',
                            style: const TextStyle(
                                fontSize: 15, fontFamily: 'Poppins'),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'CAPTADOR: ${fundRaising.user!.name!.toUpperCase()}',
                            style: const TextStyle(
                                fontSize: 15, fontFamily: 'Poppins'),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'PROJETO: ${fundRaising.bill!.nome!.toUpperCase()}',
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'TOTAL DOADO: R\$ ${FormattedInputers.formatValuePTBR(totalDoado.toString())}',
            style: const TextStyle(fontSize: 18, fontFamily: 'Poppinss'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
