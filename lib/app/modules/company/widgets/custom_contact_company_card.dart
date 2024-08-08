import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/modules/company/widgets/contact_modal.dart';
import 'package:projetos/app/utils/formatter.dart';

class CustomContactCompanyCard extends StatelessWidget {
  const CustomContactCompanyCard({
    super.key,
    required this.dateContact,
    required this.contactCompany,
  });

  final String dateContact;
  final ContactCompany contactCompany;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          showDialog(context, contactCompany);
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
            child: Icon(
              Icons.delete_forever,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: Card(
        elevation: 2,
        color: Colors.grey.shade200,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(5),
        child: ExpansionTile(
          leading: IconButton(
              onPressed: () {
                final contactController = Get.put(ContactController());
                contactController.selectedContactCompany = contactCompany;
                contactController.fillInFields();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0)),
                  ),
                  builder: (BuildContext context) {
                    return ContactModal(
                      name: contactCompany.empresa,
                      contactCompany: contactCompany,
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit_rounded)),
          childrenPadding:
              const EdgeInsets.only(right: 15, left: 15, bottom: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            dateContact,
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contactCompany.nomePessoa!,
                style: const TextStyle(fontSize: 18, fontFamily: 'Poppinss'),
              ),
              const Divider(
                height: 5,
                thickness: 2,
              )
            ],
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RETORNO: ${FormattedInputers.formatApiDateReturn(contactCompany.dataRetorno!)}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 5),
                Text(
                  'MÊS DEPÓSITO: ${contactCompany.mesDeposito}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 5),
                Text(
                  'PREVISÃO VALOR: ${FormattedInputers.formatValue(contactCompany.previsaoValor!)}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 5),
                Text(
                  'OBSERVAÇÕES: ${contactCompany.observacoes!}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showDialog(context, ContactCompany contactCompany) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja desativar o contato ${contactCompany.nomePessoa}?",
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "CANCELAR",
            style: TextStyle(fontFamily: 'Poppinss'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final contactController = Get.put(ContactController());
            Map<String, dynamic> retorno =
                await contactController.unlinkContactCompany(contactCompany.id);

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
          child: const Text(
            "CONFIRMAR",
            style: TextStyle(fontFamily: 'Poppinss', color: Colors.white),
          ),
        ),
      ],
    );
  }
}
