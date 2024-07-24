import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/user_model.dart';

class CreateBillModal extends GetView<BillController> {
  const CreateBillModal({super.key, this.company});

  final Company? company;

  @override
  Widget build(BuildContext context) {
    bool isUpdate = company != null;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.billKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    'CADASTRO DE PROJETO',
                    style: TextStyle(
                        fontFamily: 'Poppinss',
                        fontSize: 17,
                        color: Color(0xFFEBAE1F)),
                  ),
                ),
                const Divider(
                  endIndent: 110,
                  height: 5,
                  thickness: 2,
                  color: Colors.black,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'NOME DO PROJETO',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.yearController,
                  keyboardType: TextInputType.number,
                  maxLength: 18,
                  decoration:
                  const InputDecoration(labelText: 'ANO', counterText: ''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o ano';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.aprovedValueController,
                  decoration: const InputDecoration(
                    labelText: 'VALOR APROVADO',
                  ),
                  onChanged: (value) {
                    controller.onValueChanged(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'STATUS',
                  ),
                  items: ['aberto','fechado'].map((String valor) {
                    return DropdownMenuItem<String>(
                      value: valor,
                      child: Text(valor.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.statusController.text = value!;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione um usuário';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(

                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: controller.commentsController,
                  decoration: const InputDecoration(
                    labelText: 'OBSERVAÇÕES',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira as observações';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> retorno =  await controller.insertBill();

                        if (retorno['success'] == true) {
                          Get.back();
                          Get.snackbar(
                              'Sucesso!', retorno['message'].join('\n'),
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
                      child: Text(
                        isUpdate ? 'ATUALIZAR' : 'CADASTRAR',
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 120,
                      child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'CANCELAR',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFFEBAE1F)),
                          ),),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}