import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/company/widgets/create_company_modal.dart';
import 'package:projetos/app/modules/company/widgets/custom_my_company_card.dart';
import 'package:projetos/app/routes/app_routes.dart';

class AllCompanyView extends GetView<CompanyController> {
  AllCompanyView({super.key});
  final billController = Get.put(BillController());
  final userController = Get.put(FundRaiserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOS PATROCINADORES'),
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
                  labelText: 'Pesquisar patrocinadores',
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
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (DismissDirection direction) async {
                          if (direction == DismissDirection.endToStart) {
                            showDeleteDialog(context, company);
                          } else if (direction == DismissDirection.startToEnd) {
                            showModal(context, company);
                          }
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
                        secondaryBackground: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'EXCLUIR',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.contacttimeline,
                                arguments: company);
                          },
                          child: CustomCompanyCard(
                            index: index + 1,
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
                      items:
                          billController.listAllBillsDropDown.map((Bill bill) {
                        return DropdownMenuItem<int>(
                          value: bill.id,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Tooltip(
                                    message: bill.nome!,
                                    child: Text(
                                      bill.nome!.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                                const Divider(thickness: 1),
                              ],
                            ),
                          ),
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
                    int? selectedValue;

                    // Verifica se há um captador associado à empresa e define o valor selecionado.
                    if (company.companyUser != null &&
                        company.companyUser!.isNotEmpty) {
                      selectedValue = company.companyUser!.first.id;
                    }

                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'CAPTADOR',
                      ),
                      value: selectedValue, // Usa o valor selecionado se houver
                      items: userController.listFundRaiser.map((User user) {
                        return DropdownMenuItem<int>(
                          value: user.id,
                          child: Text(
                            user.name!.toUpperCase(),
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                        );
                      }).toList(),
                      onChanged: selectedValue != null
                          ? null // Desabilita o dropdown se já houver um captador selecionado
                          : (value) {
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
                          int? companyUserId;
                          if (company.companyUser != null &&
                              company.companyUser!.isNotEmpty) {
                            companyUserId = company.companyUser!.first.id;
                          }
                          Map<String, dynamic> retorno =
                              await fundRaiserController.insertFundRaising(
                                  company.id!, controller.selectedBillId.value,
                                  companyUserId: companyUserId);

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

  Future<void> showDeleteDialog(BuildContext context, Company company) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tem certeza que deseja excluir?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Empresa: ${company.nome}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancelar',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> retorno = await controller
                              .unlinkCompany(company.id, 'excluir');

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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
