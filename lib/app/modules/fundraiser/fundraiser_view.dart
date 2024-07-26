import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/fundraiser/widgets/create_fundraiser_modal.dart';
import 'package:projetos/app/modules/fundraiser/widgets/custom_fundraiser_card.dart';
import 'package:projetos/app/routes/app_routes.dart';

class FundRaiserView extends GetView<FundRaiserController> {
  FundRaiserView({super.key});
  final companyController = Get.put(CompanyController());
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
                    controller.listFundRaiser.isNotEmpty) {
                  return Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          itemCount: controller.listFundRaiser.length,
                          itemBuilder: (context, index) {
                            User user = controller.listFundRaiser[index];
                            return InkWell(
                              onTap: () {
                                companyController.getCompanies(user.id!);
                                Get.toNamed(Routes.mycompany, arguments: user);
                              },
                              child: CustomFundRaiserCard(
                                user: user,
                                fundRaiserName: user.name,
                                fundRaiserPhone: user.contact,
                              ),
                            );
                          }));
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text('NÃO HÁ EMPRESAS CAPTAÇÕES PENDENTES'),
                    ),
                  );
                }
              }),
              const SizedBox(height: 15)
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 5),
          child: FloatingActionButton(
            mini: true,
            elevation: 2,
            backgroundColor: Colors.orange,
            onPressed: () {
              controller.clearAllFields();
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => const CreateFundRaiserModal(),
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
