import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/financial_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/fundraiser/widgets/create_fundraiser_modal.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CustomFundRaiserCard extends StatelessWidget {
  const CustomFundRaiserCard(
      {super.key, this.fundRaiserName, this.fundRaiserPhone, this.user});

  final String? fundRaiserName;
  final String? fundRaiserPhone;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          if (user!.id.toString() == ServiceStorage.getUserId().toString()) {
            Get.snackbar(
              'Ação não permitida',
              'Você não pode excluir seu próprio usuário.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM,
            );
            return false;
          }
          showDialog(context, user!);
        }
        return false;
      },
      background: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'EXCLUIR',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.delete_forever,
                    size: 25,
                    color: Colors.white,
                  ),
                ],
              )),
        ),
      ),
      child: Card(
        color: const Color(0xFFFFF3DB),
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          leading: IconButton(
              onPressed: () {
                final financialController = Get.put(FinancialController());
                financialController.getWallet(user!.id!);
                financialController.getWalletBalance(user!.id!);
                Get.toNamed(Routes.financial, arguments: user);
              },
              icon: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.green,
              )),
          dense: true,
          trailing: IconButton(
              onPressed: () {
                final controller = Get.put(FundRaiserController());
                controller.selectedUser = user;
                controller.fillInFields();
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => CreateFundRaiserModal(
                    user: user!,
                  ),
                );
              },
              icon: const Icon(Icons.edit_rounded)),
          title: Text(
            fundRaiserName!.toUpperCase(),
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppinss'),
          ),
          subtitle: Text(
            fundRaiserPhone!,
            style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }

  void showDialog(context, User user) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja desativar o usuário ${user.name}?",
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final fundRaiser = Get.put(FundRaiserController());
            Map<String, dynamic> retorno =
                await fundRaiser.deleteFundRaiser(user.id);

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
          child: const Text(
            "CONFIRMAR",
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "CANCELAR",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
  }
}
