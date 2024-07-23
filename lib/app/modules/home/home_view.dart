import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/home_controller.dart';
import 'package:projetos/app/modules/home/widgets/custom_home_card.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 90, left: 15),
              child: Text(ServiceStorage.getUserName().toUpperCase()),
            ),
            toolbarHeight: 130.0,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 90, left: 15),
              child: Image.asset('assets/images/logo_drawer.png'),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 90),
                child: IconButton(
                    onPressed: () {
                      if (ServiceStorage.existUser()) {
                        ServiceStorage.clearBox();
                        Get.offAllNamed('/login');
                      }
                    },
                    icon: const Icon(Icons.exit_to_app_rounded)),
              )
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
                SizedBox(height: MediaQuery.of(context).size.height * .06),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
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
                          Get.toNamed(Routes.mycompany);
                        },
                      ),
                      HomeCard(
                        icon: Icons.domain_add_rounded,
                        title: 'TODAS AS\nEMPRESAS',
                        onTap: () {
                          Get.toNamed(Routes.allcompany);
                        },
                      ),
                      HomeCard(
                        icon: Icons.pin_drop_rounded,
                        title: 'EMPRESAS\nDISPONÍVEIS',
                        onTap: () {
                          Get.toNamed(Routes.availablecompany);
                        },
                      ),
                      HomeCard(
                        icon: Icons.history_rounded,
                        title: 'EMPRESAS\nEXPIRANDO',
                        onTap: () {
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
                        icon: CupertinoIcons.chart_bar_alt_fill,
                        title: 'LISTAGEM\nRELATÓRIOS',
                        onTap: () {
                          Get.toNamed(Routes.report);
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
          top: MediaQuery.of(context).size.width * .22,
          left: MediaQuery.of(context).size.width * .04,
          right: MediaQuery.of(context).size.width * .04,
          child: Card(
            elevation: 5,
            color: Colors.orange,
            margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .16,
              child: const Padding(
                padding:
                    EdgeInsets.only(right: 16, left: 16, top: 12, bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '10',
                      style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'EMPRESAS',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
