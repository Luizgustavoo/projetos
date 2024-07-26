import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/controllers/home_controller.dart';
import 'package:projetos/app/data/controllers/statistic_controller.dart';
import 'package:projetos/app/data/controllers/financial_controller.dart';
import 'package:projetos/app/modules/home/widgets/custom_home_card.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final companyController = Get.put(CompanyController());
  final billsController = Get.put(BillController());
  final fundRaiserController = Get.put(FundRaiserController());
  final walletController = Get.put(FinancialController());
  @override
  Widget build(BuildContext context) {
    final statisticController = Get.put(StatisticController());
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 50, left: 15),
              child: Text(ServiceStorage.getUserName().toUpperCase()),
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
                  onSelected: (String value) {
                    switch (value) {
                      case 'Perfil':
                        // Get.toNamed(Routes.profile);
                        break;
                      case 'Sair':
                        ServiceStorage.clearBox();
                        Get.offAllNamed(Routes.login);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Perfil', 'Sair'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
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
                      HomeCard(
                        icon: Icons.price_check_rounded,
                        title: 'CAPTAÇÕES\nPENDENTES',
                        onTap: () {
                          fundRaiserController.getAllPendingFundRising();
                          Get.toNamed(Routes.pendingfundrising);
                        },
                      ),
                      HomeCard(
                        icon: Icons.factory_rounded,
                        title: 'MINHAS\nEMPRESAS',
                        onTap: () {
                          companyController.getCompanies();
                          Get.toNamed(Routes.mycompany);
                        },
                      ),
                      HomeCard(
                        icon: Icons.domain_add_rounded,
                        title: 'TODAS AS\nEMPRESAS',
                        onTap: () {
                          companyController.getAllCompanies();
                          Get.toNamed(Routes.allcompany);
                        },
                      ),
                      HomeCard(
                        icon: Icons.pin_drop_rounded,
                        title: 'EMPRESAS\nDISPONÍVEIS',
                        onTap: () {
                          companyController.getAvailableCompanies();
                          Get.toNamed(Routes.availablecompany);
                        },
                      ),
                      HomeCard(
                        icon: Icons.history_rounded,
                        title: 'EMPRESAS\nEXPIRANDO',
                        onTap: () {
                          companyController.getExpirianCompanies();
                          Get.toNamed(Routes.expiringcompany);
                        },
                      ),
                      HomeCard(
                        icon: CupertinoIcons.group_solid,
                        title: 'LISTAGEM\nCAPTADORES',
                        onTap: () {
                          fundRaiserController.getFundRaisers();
                          Get.toNamed(Routes.fundraiser);
                        },
                      ),
                      HomeCard(
                        icon: Icons.post_add_rounded,
                        title: 'LISTAGEM\nPROJETOS',
                        onTap: () {
                          billsController.getAllBills();
                          Get.toNamed(Routes.bill);
                        },
                      ),
                      HomeCard(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'MINHA\nCARTEIRA',
                        onTap: () {
                          walletController.getWallet(0);
                          walletController.getWalletBalance();
                          Get.toNamed(Routes.financial);
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
          top: MediaQuery.of(context).size.width * .35,
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
                    const Text(
                      'EMPRESAS',
                      style: TextStyle(
                          fontSize: 18,
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
                                    fontSize: 38,
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
                                    fontSize: 38,
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
                                    fontSize: 38,
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
}
