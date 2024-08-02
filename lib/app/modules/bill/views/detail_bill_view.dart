import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';

class DetailBillView extends GetView<BillController> {
  const DetailBillView({super.key});

  @override
  Widget build(BuildContext context) {
    final bill = Get.arguments as Bill;
    double totalCapturedValue =
        bill.fundraisings!.fold(0.0, (sum, e) => sum + e.capturedValue);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            bill.nome!.toString(),
            overflow: TextOverflow.ellipsis,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child: Card(
                    elevation: 2,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'VALOR CAPTADO',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                        ),
                        Text(
                          'R\$${controller.formatValue(double.parse(totalCapturedValue.toString()))}',
                          style: const TextStyle(
                              fontFamily: 'Poppinss', fontSize: 26),
                        ),
                      ],
                    )),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    'EMPRESAS:',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
                child: bill.fundraisings!.isNotEmpty
                    ? ListView.builder(
                        padding:
                            const EdgeInsets.only(top: 10, left: 16, right: 16),
                        itemCount: bill.fundraisings!.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          FundRaising fundRaising = bill.fundraisings![index];
                          final status =
                              fundRaising.status == 'captado' ? true : false;
                          return Card(
                            elevation: 2,
                            color:
                                status ? Colors.greenAccent : Colors.redAccent,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(5),
                            child: ListTile(
                              title: Text(
                                'EMPRESA: ${fundRaising.company!.nome}',
                                style: TextStyle(
                                    fontFamily: 'Poppinss',
                                    color:
                                        status ? Colors.black : Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CAPTADOR: ${fundRaising.user!.name!.toUpperCase()}',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: status
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Text(
                                    status
                                        ? 'VALOR CAPTADO: R\$${controller.formatValue(double.parse(fundRaising.capturedValue.toString()))}'
                                        : 'VALOR PREVISTO: R\$${controller.formatValue(double.parse(fundRaising.predictedValue.toString()))}',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: status
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : const Center(
                        child: Text(
                          'NÃO HÁ EMPRESAS',
                          style:
                              TextStyle(fontFamily: 'Poppinss', fontSize: 20),
                        ),
                      ))
          ],
        )));
  }
}
