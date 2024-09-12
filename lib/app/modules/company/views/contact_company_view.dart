import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/modules/company/widgets/contact_modal.dart';
import 'package:projetos/app/modules/company/widgets/custom_contact_company_card.dart';
import 'package:projetos/app/utils/service_storage.dart';

class ContactCompanyView extends GetView<ContactController> {
  ContactCompanyView({super.key});

  final company = Get.arguments as Company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(company.nome!.toUpperCase()),
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
                'CONTATOS',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const Divider(
              height: 0,
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            Obx(
              () => controller.isLoading.value
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : controller.listContactCompany.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              'NÃO HÁ NENHUM CONTATO NESSA EMPRESA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            itemCount: controller.listContactCompany.length,
                            itemBuilder: (context, index) {
                              ContactCompany contactCompany =
                                  controller.listContactCompany[index];
                              String dateContact =
                                  contactCompany.dateContact != null
                                      ? controller.formatApiDate(
                                          contactCompany.dateContact!)
                                      : '';
                              return CustomContactCompanyCard(
                                  dateContact: dateContact,
                                  contactCompany: contactCompany);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: ServiceStorage.getUserType() == 1
          ? const SizedBox()
          : FloatingActionButton(
              mini: true,
              elevation: 2,
              backgroundColor: Colors.orange,
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
                      name: company.nome,
                      company: company,
                    );
                  },
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
