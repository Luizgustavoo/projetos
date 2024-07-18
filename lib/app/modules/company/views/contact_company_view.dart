import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/modules/company/widgets/custom_contact_company_card.dart';

class ContactCompanyView extends GetView<ContactController> {
  const ContactCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('COLIBRI IND. MÓVEIS LTDA'),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Contatos',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  itemCount: controller.listContactCompany.length,
                  itemBuilder: (context, index) {
                    ContactCompany contactCompany =
                        controller.listContactCompany[index];
                    String dateContact = contactCompany.dateContact != null
                        ? controller.formatApiDate(contactCompany.dateContact!)
                        : '';
                    return CustomContactCompanyCard(
                        dateContact: dateContact,
                        contactCompany: contactCompany);
                  },
                ),
              ),
            ),
          ],
        )));
  }
}
