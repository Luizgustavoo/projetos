import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/company/widgets/create_my_company_modal.dart';
import 'package:projetos/app/modules/company/widgets/custom_my_company_card.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';

class AllCompanyView extends GetView<CompanyController> {
  AllCompanyView({super.key});
  final billController = Get.put(BillController());
  final userController = Get.put(FundRaiserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODAS EMPRESAS'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: controller.searchControllerAllCompany,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar Empresas',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
              } else if (!controller.isLoading.value &&
                  controller.filteredAllCompanies.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    itemCount: controller.filteredAllCompanies.length,
                    itemBuilder: (context, index) {
                      Company company = controller.filteredAllCompanies[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: ServiceStorage.getUserType() == 1
                            ? DismissDirection.none
                            : DismissDirection.startToEnd,
                        confirmDismiss: (DismissDirection direction) async {
                          showModal(context, company);
                          return false;
                        },
                        background: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_rounded,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'CAPTAÇÃO',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.contacttimeline,
                                arguments: company);
                          },
                          child: CustomCompanyCard(
                            name: company.nome ?? "",
                            responsible: company.responsavel ?? "",
                            phone: company.telefone ?? "",
                            contactName: company.nomePessoa ?? "",
                            city: company.cidade ?? "",
                            state: company.estado ?? "",
                            company: company,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: Text('NÃO HÁ EMPRESAS PARA MOSTRAR'),
                  ),
                );
              }
            }),
            const SizedBox(height: 10)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        elevation: 2,
        backgroundColor: Colors.orange,
        onPressed: () {
          controller.clearAllFields();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => CreateCompanyModal(),
          );
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  void showModal(context, Company company) {
    final fundRaiserController = Get.put(FundRaiserController());
    fundRaiserController.clearAllFields();
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: fundRaiserController.fundRaisingKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'CAPTAÇÕES',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    company.nome!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: fundRaiserController.dateFundController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'DATA CAPTADA', counterText: ''),
                    onChanged: (value) {
                      fundRaiserController.onFundRaiserDateChanged(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: fundRaiserController.valueFundController,
                    decoration: const InputDecoration(
                      labelText: 'VALOR CAPTADO',
                    ),
                    onChanged: (value) {
                      fundRaiserController.onValueChanged(value);
                    },
                  ),
                  const SizedBox(height: 15),
                  Obx(() {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'PROJETOS',
                      ),
                      items: billController.listAllBills.map((Bill bill) {
                        return DropdownMenuItem<int>(
                          value: bill.id,
                          child: Text(bill.nome!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedBillId.value = value!;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um projeto';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 15),
                  Obx(() {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'CAPTADOR',
                      ),
                      items: userController.listFundRaiser.map((User user) {
                        return DropdownMenuItem<int>(
                          value: user.id,
                          child: Text(
                            user.name!,
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedUserId.value = value!;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um captador';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'COMISSÃO PAGA?: ',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      Obx(() => Switch(
                            activeColor: Colors.orange.shade700,
                            inactiveThumbColor: Colors.orange.shade500,
                            inactiveTrackColor: Colors.orange.shade100,
                            value:
                                fundRaiserController.paidOutCheckboxValue.value,
                            onChanged: (value) {
                              fundRaiserController.paidOutCheckboxValue.value =
                                  value;
                              fundRaiserController.showPaymentDateField.value =
                                  value;
                            },
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (fundRaiserController.showPaymentDateField.value) {
                      return TextFormField(
                        keyboardType: TextInputType.number,
                        controller: fundRaiserController.paymentDateController,
                        maxLength: 10,
                        decoration: const InputDecoration(
                            labelText: 'DATA DO PAGAMENTO', counterText: ''),
                        onChanged: (value) {
                          fundRaiserController.onPaymentDateChanged(value);
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> retorno =
                              await fundRaiserController.insertFundRaising(
                                  company.id!, controller.selectedBillId.value);

                          if (retorno['success'] == true) {
                            Get.back();
                            Get.snackbar(
                                'Sucesso!', retorno['message'].join('\n'),
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar(
                                'Falha!', retorno['message'].join('\n'),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        child: const Text(
                          "CONFIRMAR",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("CANCELAR"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
