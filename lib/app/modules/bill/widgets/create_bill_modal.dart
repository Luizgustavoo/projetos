import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/services.dart';

class CreateBillModal extends GetView<BillController> {
  const CreateBillModal({super.key, this.bill});

  final Bill? bill;

  @override
  Widget build(BuildContext context) {
    bool isUpdate = bill != null;
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
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: controller.commentsController,
                  decoration: const InputDecoration(
                    labelText: 'DESCRIÇÃO',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira as descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.yearController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
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
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: controller.aprovedValueController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'VALOR APROVADO'),
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
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: controller.percentageValueController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          PercentageInputFormatter(),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'PORCENTAGEM',
                        ),
                        onChanged: (value) {
                          controller.onPercentageChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o valor';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Obx(() {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'STATUS',
                    ),
                    value: controller.status.value.isEmpty
                        ? null
                        : controller.status.value,
                    items: ['aberto', 'fechado'].map((String valor) {
                      return DropdownMenuItem<String>(
                        value: valor,
                        child: Text(valor.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.status.value = value!;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione um status';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: controller.commentsStatusController,
                  decoration: const InputDecoration(
                    labelText: 'OBSERVAÇÕES',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'CANCELAR',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Color(0xFFEBAE1F)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => Services.isLoadingCRUD.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                Map<String, dynamic> retorno = isUpdate
                                    ? await controller.updateBill(bill!.id)
                                    : await controller.insertBill();

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
                              child: Text(
                                isUpdate ? 'ATUALIZAR' : 'CADASTRAR',
                                style: const TextStyle(
                                    fontFamily: 'Poppins', color: Colors.white),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class PercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = FormattedInputers.formatPercentage(newValue.text);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
