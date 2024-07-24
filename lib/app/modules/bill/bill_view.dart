import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';

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
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_rounded)),
                          title: Text('NOME: '.toUpperCase()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ANO: '.toUpperCase()),
                              Text('STATUS: '.toUpperCase()),
                              Text('VALOR CAPTADO: '.toUpperCase()),
                              Text('VALOR APROVADO: '.toUpperCase()),
                            ],
                          ),
                        ),
                      );
                    })),
            const SizedBox(height: 10),
          ],
        )));
  }
}
