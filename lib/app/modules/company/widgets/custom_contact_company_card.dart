import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/modules/company/widgets/contact_modal.dart';

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
    return Card(
      elevation: 2,
      color: Colors.grey.shade200,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ExpansionTile(
        leading: IconButton(
            onPressed: () {
              final contactController = Get.put(ContactController());
              contactController.selectedContactCompany = contactCompany;
              print(contactController.selectedContactCompany!.companyId);
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
        childrenPadding: const EdgeInsets.only(right: 15, left: 15, bottom: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          dateContact,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contactCompany.nomePessoa!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 5,
              thickness: 2,
            )
          ],
        ),
        children: [Text(contactCompany.observacoes!)],
      ),
    );
  }
}
