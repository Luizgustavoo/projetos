// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/modules/company/widgets/contact_modal.dart';
import 'package:projetos/app/modules/company/widgets/create_my_company_modal.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CustomCompanyCard extends StatelessWidget {
  final String? name;
  final String? phone;
  final String? responsible;
  final String? contactName;
  final Color? color;
  final Company? company;
  final String? state;
  final String? city;

  const CustomCompanyCard(
      {super.key,
      this.name,
      this.phone,
      this.responsible,
      this.contactName,
      this.color,
      this.state,
      this.city,
      this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: color,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ListTile(
        trailing: Get.currentRoute == Routes.availablecompany ||
                Get.currentRoute == Routes.expiringcompany
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  final controller = Get.put(CompanyController());
                  controller.selectedCompany = company;
                  controller.fillInFields();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => CreateCompanyModal(
                      company: company,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_rounded),
              ),
        leading: Get.currentRoute == Routes.allcompany ||
                Get.currentRoute == Routes.expiringcompany ||
                Get.currentRoute == Routes.availablecompany ||
                ServiceStorage.getUserType() == 1
            ? const Icon(
                Icons.business_rounded,
                size: 35,
              )
            : IconButton(
                onPressed: () {
                  final contactController = Get.put(ContactController());
                  contactController.clearAllFields();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    builder: (BuildContext context) {
                      return ContactModal(
                        name: name,
                        company: company,
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.contacts_rounded,
                  color: Colors.grey.shade500,
                )),
        dense: true,
        title: Text(
          'EMPRESA: ${name!}'.toUpperCase(),
          style: const TextStyle(fontFamily: 'Poppinss'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RESPONSÁVEL : ${responsible!}'.toUpperCase(),
                style: const TextStyle(fontFamily: 'Poppins')),
            Text(
              'TELEFONE: ${phone!}'.toUpperCase(),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            Text(
              'NOME DO CONTATO: ${contactName!}'.toUpperCase(),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            Text(
              'CIDADE: ${city!}'.toUpperCase(),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            Text(
              'ESTADO: ${state!}'.toUpperCase(),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }
}
