import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/user_model.dart';

class CreateFundRaiserModal extends GetView<FundRaiserController> {
  const CreateFundRaiserModal({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    bool isUpdate = user != null;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.fundRaiserKey,
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
                    'CADASTRO DE CAPTADOR',
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.nameRaiserController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'NOME COMPLETO',
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
                  controller: controller.cpfCnpjRaiserController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  decoration: const InputDecoration(
                      labelText: 'CPF/CNPJ', counterText: ''),
                  onChanged: (value) {
                    controller.onCnpjChanged(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o cpf ou o cnpj';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.phoneRaiserController,
                  keyboardType: TextInputType.number,
                  maxLength: 15,
                  decoration: const InputDecoration(
                      labelText: 'TELEFONE', counterText: ''),
                  onChanged: (value) {
                    controller.onContactChanged(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o telefone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.startDateRaiserController,
                  decoration: const InputDecoration(
                    labelText: 'DATA DE INÍCIO',
                  ),
                  onChanged: (value) {
                    controller.onDateChanged(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a data de inicio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.emailRaiserController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-MAIL',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o e-mail';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  controller: controller.passwordRaiserController,
                  decoration: const InputDecoration(
                    labelText: 'SENHA',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> retorno = isUpdate
                            ? await controller.updateFundRaiser(user!.id)
                            : await controller.insertFundRaiser();

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
                          )),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
