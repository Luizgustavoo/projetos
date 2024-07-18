// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/modules/company/widgets/contact_modal.dart';
import 'package:projetos/app/modules/company/widgets/create_my_company_modal.dart';
import 'package:projetos/app/routes/app_routes.dart';

class CustomCompanyCard extends StatelessWidget {
  final String? name;
  final String? phone;
  final String? contact;
  final String? pickup;
  final Color? color;
  final Company? company;

  const CustomCompanyCard(
      {super.key,
      this.name,
      this.phone,
      this.contact,
      this.pickup,
      this.color,
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
        onTap: () {
          final contactController = Get.put(ContactController());
          contactController.getContactCompanies(company!);
          Get.toNamed(Routes.contactcompany);
        },
        trailing: IconButton(
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
                Get.currentRoute == Routes.expiringcompany
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
        title: Text(name!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phone!),
            Text(contact!),
            Text(pickup!),
          ],
        ),
      ),
    );
  }
}
