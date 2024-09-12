import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';
import 'package:projetos/app/routes/app_routes.dart';

class DetailBillView extends GetView<BillController> {
  DetailBillView({super.key});

  final RxBool deleted = false.obs;

  @override
  Widget build(BuildContext context) {
    final bill = Get.arguments as Bill;
    RxDouble totalCapturedValue = 0.0.obs;
    totalCapturedValue.value =
        (bill.fundraisings != null && bill.fundraisings!.isNotEmpty)
            ? bill.fundraisings!
                .fold(0.0, (sum, e) => sum + (e.capturedValue ?? 0.0))
            : 0.0;
    RxDouble totalValue = 0.0.obs;
    totalValue.value = double.tryParse(bill.valorAprovado) ?? 0.0;

    RxDouble finalValue = 0.0.obs;
    finalValue.value = totalValue.value - totalCapturedValue.value;

    RxList<FundRaising> fundraisings = <FundRaising>[].obs;

    fundraisings.value = bill.fundraisings!;

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
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'VALOR CAPTADO',
                                    style: TextStyle(
                                        fontFamily: 'Poppins', fontSize: 15),
                                  ),
                                  Obx(
                                    () => Text(
                                      'R\$${controller.formatValue(double.parse(totalCapturedValue.toString()))}',
                                      style: const TextStyle(
                                          fontFamily: 'Poppinss', fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'VALOR A CAPTAR',
                                    style: TextStyle(
                                        fontFamily: 'Poppins', fontSize: 15),
                                  ),
                                  Obx(
                                    () => Text(
                                      'R\$${controller.formatValue(double.parse(finalValue.toString()))}',
                                      style: const TextStyle(
                                          fontFamily: 'Poppinss',
                                          fontSize: 20,
                                          color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (bill.observacaoStatus != null) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .info, // Substitua pelo ícone que deseja usar
                                color: Color.fromARGB(
                                    255, 24, 114, 188), // Cor do ícone
                              ),
                              const SizedBox(
                                  width: 8.0), // Espaço entre o ícone e o texto
                              Expanded(
                                child: Text(
                                  bill.observacaoStatus ??
                                      "", // Garantia de que não será nulo
                                  style: const TextStyle(
                                    color: Color.fromARGB(
                                        255, 24, 114, 188), // Cor do texto
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]
                      ],
                    ),
                  ),
                ),
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
            Obx(() => Expanded(
                child: fundraisings.isNotEmpty
                    ? ListView.builder(
                        padding:
                            const EdgeInsets.only(top: 10, left: 16, right: 16),
                        itemCount: fundraisings.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          FundRaising fundRaising = fundraisings[index];

                          final status =
                              fundRaising.status == 'captado' ? true : false;
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (DismissDirection direction) async {
                              if (direction == DismissDirection.endToStart) {
                                deleted.value = false;
                                await showDeleteDialog(
                                    context, fundRaising, bill, controller);
                              }
                              return false;
                            },
                            background: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'EXCLUIR',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.delete_forever,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            child: Card(
                              elevation: 2,
                              color: status
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
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
                            ),
                          );
                        })
                    : const Center(
                        child: Text(
                          'NÃO HÁ EMPRESAS',
                          style:
                              TextStyle(fontFamily: 'Poppinss', fontSize: 20),
                        ),
                      )))
          ],
        )));
  }

  Future<bool?> showDeleteDialog(BuildContext context, FundRaising fundRaising,
      Bill bill, BillController billController) async {
    final controller = Get.put(FundRaiserController());
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
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
                    'Tem certeza que deseja excluir?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Empresa: ${fundRaising.company!.nome}',
                    style: const TextStyle(fontSize: 16),
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
                            Map<String, dynamic> retorno = await controller
                                .deleteFundRaising(fundRaising.id);
                            if (retorno['success'] == true) {
                              Get.snackbar(
                                  'Sucesso!', retorno['message'].join('\n'),
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                  snackPosition: SnackPosition.BOTTOM);

                              Get.find<BillController>().getAllBills();
                              Get.offAllNamed(Routes.home);
                            } else {
                              Get.snackbar(
                                  'Falha!', retorno['message'].join('\n'),
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                  snackPosition: SnackPosition.BOTTOM);
                              // Navigator.of(context).pop(false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Excluir',
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
    return null;
  }
}
