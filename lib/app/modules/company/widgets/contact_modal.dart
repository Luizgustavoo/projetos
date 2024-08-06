// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';

class ContactModal extends GetView<ContactController> {
  final String? name;
  final Company? company;
  final ContactCompany? contactCompany;

  const ContactModal({super.key, this.name, this.company, this.contactCompany});

  @override
  Widget build(BuildContext context) {
    bool isUpdate = contactCompany != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: controller.contactKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'CONTATO EMPRESA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                name!,
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
                controller: controller.dateContactController,
                decoration: InputDecoration(
                  labelText: 'Data e Hora:',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      final dateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      controller.dateContactController.text =
                          DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.nameContactController,
                decoration: const InputDecoration(
                  labelText: 'NOME CONTATO',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Campo Data Retorno
              TextFormField(
                controller: controller.dateReturnController,
                decoration: InputDecoration(
                  labelText: 'DATA DE RETORNO:',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    controller.dateReturnController.text =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.predictedValueController,
                decoration: const InputDecoration(
                  labelText: 'PREVISÃO DE VALOR',
                ),
                onChanged: (value) {
                  controller.onPendingValueChanged(value);
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a previsão de valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Dropdown Mês de Depósito
              DropdownButtonFormField<String>(
                value: controller.selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'MÊS DE DEPÓSITO',
                ),
                items: [
                  'JANEIRO',
                  'FEVEREIRO',
                  'MARÇO',
                  'ABRIL',
                  'MAIO',
                  'JUNHO',
                  'JULHO',
                  'AGOSTO',
                  'SETEMBRO',
                  'OUTUBRO',
                  'NOVEMBRO',
                  'DEZEMBRO'
                ].map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (newValue) {
                  controller.selectedMonth = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione o mês de depósito';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.obsContactController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'OBSERVAÇÕES',
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("CANCELAR"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> retorno = isUpdate
                          ? await controller.updateContactCompany(
                              contactCompany!.companyId, contactCompany!.id)
                          : await controller.insertContactCompany(company!.id!);

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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
