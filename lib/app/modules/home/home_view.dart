import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/home_controller.dart';
import 'package:projetos/app/data/controllers/statistic_controller.dart';
import 'package:projetos/app/data/controllers/financial_controller.dart';
import 'package:projetos/app/modules/home/widgets/custom_home_card.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final companyController = Get.put(CompanyController());
  final billsController = Get.put(BillController());
  final walletController = Get.put(FinancialController());
  final statisticController = Get.put(StatisticController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: ServiceStorage.getUserType() == 1
                ? const Color(0xFF1d1d1d)
                : const Color.fromARGB(255, 170, 170, 170),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 50, left: 15),
              child: Text(
                ServiceStorage.getUserName().toUpperCase(),
                style: TextStyle(
                    fontSize: kIsWeb ||
                            defaultTargetPlatform == TargetPlatform.windows
                        ? 28
                        : 16),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 50, left: 15),
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/logo_drawer.png')),
            ),
            toolbarHeight: 200.0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50, right: 15),
                child: PopupMenuButton<String>(
                  tooltip: 'Mostrar menu',
                  onSelected: (String value) {
                    switch (value) {
                      case 'Alterar senha':
                        controller.clearAllFields();
                        showChangePasswordDialog(context, controller);
                        break;
                      case 'Sair':
                        ServiceStorage.clearBox();
                        Get.offAllNamed(Routes.login);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Alterar senha', 'Sair'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ],
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .09),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      if (ServiceStorage.getUserType() == 1) ...[
                        HomeCard(
                          icon: CupertinoIcons.group_solid,
                          title: 'LISTAGEM\nCAPTADORES',
                          onTap: () {
                            Get.toNamed(Routes.fundraiser);
                          },
                        ),
                        HomeCard(
                          icon: Icons.domain_add_rounded,
                          title: 'TODOS OS\nPATROCINADORES',
                          onTap: () {
                            companyController.searchControllerAllCompany.text =
                                '';
                            companyController.getAllCompanies();
                            Get.toNamed(Routes.allcompany);
                          },
                        ),
                        HomeCard(
                          icon: Icons.price_check_rounded,
                          title: 'CAPTAÇÕES\nPENDENTES',
                          onTap: () {
                            Get.toNamed(Routes.pendingfundrising);
                          },
                        ),
                        HomeCard(
                          icon: CupertinoIcons.chart_bar_alt_fill,
                          title: '\nRELATÓRIOS',
                          onTap: () {
                            Get.toNamed(Routes.report);
                          },
                        ),
                      ],
                      if (ServiceStorage.getUserType() != 1) ...[
                        HomeCard(
                          icon: Icons.factory_rounded,
                          color: Colors.black,
                          title: 'CONTROLE\nCLIENTES',
                          onTap: () {
                            companyController.searchControllerMyCompany.text =
                                '';
                            companyController.getCompanies(0);
                            Get.toNamed(Routes.mycompany);
                          },
                        ),
                        HomeCard(
                          icon: Icons.history_rounded,
                          title: 'CLIENTES\nEXPIRANDO',
                          onTap: () {
                            companyController.getExpirianCompanies(0);
                            Get.toNamed(Routes.expiringcompany);
                          },
                        ),
                        HomeCard(
                          icon: Icons.attach_money_rounded,
                          title: 'CONTROLE\nFINANCEIRO',
                          onTap: () {
                            walletController
                                .getFinancial(ServiceStorage.getUserId());
                            walletController.getFinancialBalance(
                                ServiceStorage.getUserId());
                            Get.toNamed(Routes.financial);
                          },
                        ),
                      ],
                      HomeCard(
                        icon: Icons.pin_drop_rounded,
                        title: ServiceStorage.getUserType() == 1
                            ? 'PATROCINADORES\nDISPONÍVEIS'
                            : 'CLIENTES\nDISPONÍVEIS',
                        onTap: () {
                          companyController.getAvailableCompanies();
                          Get.toNamed(Routes.availablecompany);
                        },
                      ),
                      HomeCard(
                        icon: Icons.phone_android_rounded,
                        title: 'MATERIAIS\nDIVULGAÇÃO',
                        onTap: () {
                          Get.toNamed(Routes.material);
                        },
                      ),
                      HomeCard(
                        icon: Icons.post_add_rounded,
                        title: 'CONTROLE\nPROJETOS',
                        onTap: () {
                          billsController.getAllBills();
                          Get.toNamed(Routes.bill);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: kIsWeb || defaultTargetPlatform == TargetPlatform.windows
              ? MediaQuery.of(context).size.width * .09
              : MediaQuery.of(context).size.width * .35,
          left: MediaQuery.of(context).size.width * .04,
          right: MediaQuery.of(context).size.width * .04,
          child: Card(
            elevation: 5,
            color: const Color(0xFFEBAE1F),
            margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .16,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ServiceStorage.getUserType() == 1
                          ? 'PATROCINADORES'
                          : 'CLIENTES',
                      style: TextStyle(
                          fontSize: kIsWeb ||
                                  defaultTargetPlatform ==
                                      TargetPlatform.windows
                              ? 25
                              : 18,
                          color: Colors.white,
                          fontFamily: 'Poppinss'),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Obx(
                                () => Text(
                                  '${statisticController.availableCompanies}',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Poppinss',
                                  ),
                                ),
                              ),
                              const Text(
                                'DISPONÍVEIS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Obx(
                                () => Text(
                                  '${statisticController.expiredCompanies}',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Poppinss',
                                  ),
                                ),
                              ),
                              const Text(
                                'EXPIRANDO',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Obx(
                                () => Text(
                                  '${statisticController.totalCompanies}',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Poppinss',
                                  ),
                                ),
                              ),
                              const Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showChangePasswordDialog(
      BuildContext context, HomeController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alterar Senha'),
          titleTextStyle: const TextStyle(
              fontFamily: 'Poppinss', fontSize: 18, color: Colors.black),
          content: Form(
            key: controller.changePasswordKey,
            child: TextFormField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              child: const Text(
                'CONFIRMAR',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
              onPressed: () async {
                Map<String, dynamic> retorno = await controller
                    .updatePasswordUser(ServiceStorage.getUserId());

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
            ),
          ],
        );
      },
    );
  }
}
