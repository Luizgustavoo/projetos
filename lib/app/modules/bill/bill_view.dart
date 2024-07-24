import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/modules/bill/widgets/create_bill_modal.dart';

class BillView extends GetView<BillController> {
  const BillView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROJETOS'),
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
                  controller.listAllBills.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    itemCount: controller.listAllBills.length,
                    itemBuilder: (context, index) {
                      final Bill bill = controller.listAllBills[index];
                      return Card(
                        color: bill.status == 'aberto'
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        elevation: 2,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_rounded)),
                          title: Text('NOME: ${bill.nome}'.toUpperCase()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ANO: ${bill.ano}'.toUpperCase()),
                              Text('STATUS: ${bill.status}'.toUpperCase()),
                              Text(
                                'VALOR APROVADO: ${controller.formatValue(double.parse(bill.valorAprovado.toString()))}'
                                    .toUpperCase(),
                              ),
                              Text('VALOR CAPTADO: '.toUpperCase()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: Text('NÃO HÁ EMPRESAS PARA MOSTRAR'),
                  ),
                );
              }
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        elevation: 2,
        backgroundColor: Colors.orange,
        onPressed: () {
          //controller.clearAllFields();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => const CreateBillModal(),
          );
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
