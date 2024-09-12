// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/modules/bill/widgets/create_bill_modal.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CustomBillCard extends StatelessWidget {
  final String? name;
  final String? year;
  final String? value;
  final Color? color;
  final Bill? bill;

  const CustomBillCard(
      {super.key, this.name, this.year, this.value, this.color, this.bill});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: color,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ListTile(
        trailing: ServiceStorage.getUserType() == 1
            ? IconButton(
                onPressed: () {
                  final controller = Get.put(BillController());
                  controller.selectedBill = bill;
                  controller.fillInFields();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => CreateBillModal(bill: bill),
                  );
                },
                icon: const Icon(
                  Icons.edit_rounded,
                  color: Colors.black,
                ),
              )
            : const SizedBox(),
        dense: true,
        title: Text(
          'NOME: ${name!}'.toUpperCase(),
          style: const TextStyle(fontFamily: 'Poppinss'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ANO : ${year!}'.toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: bill!.status == 'aberto'
                        ? Colors.black
                        : Colors.white)),
            Text(
              'VALOR APROVADO: ${value!}',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color:
                      bill!.status == 'aberto' ? Colors.black : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
