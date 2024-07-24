import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/home_controller.dart';
import 'package:projetos/app/data/controllers/statistic_controller.dart';
import 'package:projetos/app/modules/home/widgets/custom_drawer.dart';
import 'package:projetos/app/modules/home/widgets/custom_home_card.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final companyController = Get.put(CompanyController());

  @override
  Widget build(BuildContext context) {
    final statisticController = Get.put(StatisticController());
    final RxBool isDrawerOpen = false.obs;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => isDrawerOpen.value = false,
          child: Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 15),
                child: Text(ServiceStorage.getUserName().toUpperCase()),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 15),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    isDrawerOpen.value = !isDrawerOpen.value;
                  },
                ),
              ),
              toolbarHeight: 200.0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, right: 15),
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset('assets/images/logo_drawer.png')),
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
                            Get.toNamed(Routes.pendingfundrising);
                          },
                        ),
                        HomeCard(
                          icon: Icons.factory_rounded,
                          title: 'MINHAS\nEMPRESAS',
                          onTap: () {
                            companyController.getAllCompanies();
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
                            Get.toNamed(Routes.fundraiser);
                          },
                        ),
                        HomeCard(
                          icon: Icons.post_add_rounded,
                          title: 'LISTAGEM\nPROJETOS',
                          onTap: () {
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
        Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: isDrawerOpen.value ? 0 : -250,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    isDrawerOpen.value = false;
                  }
                },
                child: CustomDrawer(
                  onClose: () {
                    isDrawerOpen.value = false;
                  },
                ),
              ),
            )),
      ],
    );
  }
}
