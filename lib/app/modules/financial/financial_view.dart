import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/financial_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/financial/widgets/custom_financial_card.dart';
import 'package:projetos/app/utils/service_storage.dart';

class FinancialView extends GetView<FinancialController> {
  const FinancialView({super.key});

  double calculateCommission(int capturedValue, double percentage) {
    return capturedValue * (percentage / 100);
  }

  @override
  Widget build(BuildContext context) {
    String carteira = "CONTROLE FINANCEIRO";
    final User user = Get.arguments as User;
    if (Get.arguments != null && Get.arguments is User) {
      carteira = "FINANCEIRO: ${user.name!.toUpperCase()}";
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
                              ServiceStorage.getUserType() == 1
                                  ? 'PAGO'
                                  : 'RECEBIDO',
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
                              ServiceStorage.getUserType() == 1
                                  ? 'A PAGAR'
                                  : 'A RECEBER',
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
                    itemCount: controller.listFinancial.length,
                    padding:
                        const EdgeInsets.only(top: 10, left: 12, right: 12),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      Bill bill = controller.listFinancial[index];
                      return CustomFinancialCard(
                        bill: bill,
                        controller: controller,
                        id: user.id,
                        user: user,
                      );
                    }),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
