import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/modules/fundraiser/widgets/create_pickup_modal.dart';

class FundRaiserView extends GetView<FundRaiserController> {
  const FundRaiserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CAPTADORES'),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFFFFF3DB),
                          margin: const EdgeInsets.all(5),
                          elevation: 2,
                          child: ListTile(
                            dense: true,
                            onTap: () {},
                            trailing: Icon(
                              Icons.search,
                              color: Colors.grey.shade500,
                            ),
                            title: const Text('NOME: NOME DO CAPTADOR'),
                            subtitle: const Text('TELEFONE: (43) 9 9999-9999'),
                          ),
                        );
                      })),
              const SizedBox(height: 15)
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 5),
          child: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => const CreatePickupModal(),
              );
            },
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
          ),
        ));
  }
}
