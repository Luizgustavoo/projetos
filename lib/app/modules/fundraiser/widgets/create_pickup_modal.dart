import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';

class CreatePickupModal extends GetView<FundRaiserController> {
  const CreatePickupModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'CPF/CNPJ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a idade';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'CONTATO',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o parentesco';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'DATA DE INÍCIO',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a escolaridade';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'CADASTRAR',
                    style:
                        TextStyle(fontFamily: 'Poppins', color: Colors.white),
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
                            fontFamily: 'Poppins', color: Color(0xFFEBAE1F)),
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
