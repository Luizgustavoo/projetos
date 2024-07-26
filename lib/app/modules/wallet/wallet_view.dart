import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/wallet_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/wallet/widgets/custom_wallet_card.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  double calculateCommission(int capturedValue, double percentage) {
    return capturedValue * (percentage / 100);
  }

  @override
  Widget build(BuildContext context) {

    String carteira = "MINHA CARTEIRA";
    if (Get.arguments != null && Get.arguments is User) {
      final User user = Get.arguments as User;
      carteira = "CARTEIRA: ${user.name!.toUpperCase()}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(carteira),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        color: const Color(0xFFFFF3DB),
                        elevation: 2,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.zero,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'RECEBIDO',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.green.shade800),
                            ),
                            const SizedBox(height: 5),
                            Obx(
                              () => Text(
                                  'R\$${controller.formatValue(controller.sumReceived.toString())}',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.green.shade800,
                                      fontSize: 20)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        color: const Color(0xFFFFF3DB),
                        elevation: 2,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.zero,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'A RECEBER',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.red.shade800),
                            ),
                            const SizedBox(height: 5),
                            Obx(
                              () => Text(
                                  'R\$${controller.formatValue(controller.sumToReceive.toString())}',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.red.shade800,
                                      fontSize: 20)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'PROJETOS:',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            Obx(() => Expanded(
                  child: ListView.builder(
                    itemCount: controller.listWallet.length,
                    padding:
                        const EdgeInsets.only(top: 10, left: 12, right: 12),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      Bill bill = controller.listWallet[index];
                      return CustomWalletCard(
                          bill: bill, controller: controller);
                    }),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
