// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/controllers/city_state_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/controllers/report_controller.dart';
import 'package:projetos/app/data/models/city_state_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/report/pdf_page_view.dart';
import 'package:projetos/app/modules/report/widgets/custom_report_card.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

class ReportView extends GetView<ReportController> {
  ReportView({super.key});
  final userController = Get.put(FundRaiserController());
  final cityStateController = Get.put(CityStateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RELATÓRIOS'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [
              CustomReportCard(
                title: 'DOAÇÕES POR EMPRESA',
                onTap: () async {
                  const url =
                      'https://captacao.casadobommeninodearapongas.org/doacoes/pdf';

                  if (Platform.isWindows) {
                    Uri pdfUri = Uri.parse(url);
                    if (await canLaunchUrl(pdfUri)) {
                      await launchUrl(pdfUri);
                    } else {
                      Get.snackbar(
                        'Erro',
                        'Não foi possível abrir o PDF no navegador.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                    return;
                  }

                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  try {
                    final response = await http.get(Uri.parse(url));
                    if (response.statusCode == 200) {
                      Get.back();
                      Get.to(() => const PdfViewerPage(pdfUrl: url));
                    } else {
                      Get.back();
                      Get.snackbar(
                        'Erro',
                        'Falha ao carregar o PDF. Tente novamente mais tarde.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } catch (e) {
                    Get.back();
                    Get.snackbar(
                      'Erro',
                      'Erro ao baixar o PDF. Verifique sua conexão com a internet.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
              CustomReportCard(
                onTap: () async {
                  if (controller.selectedCityState.value == null) {
                    Get.snackbar('ATENÇÃO', 'Selecione uma cidade',
                        backgroundColor: Colors.orange,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        colorText: Colors.white);
                  } else {
                    String pdfUrl =
                        'https://captacao.casadobommeninodearapongas.org/doacoes/pdf/${controller.selectedCityState.value!.cidade}/${controller.selectedCityState.value!.estado}';

                    if (Platform.isWindows) {
                      Uri pdfUri =
                          Uri.parse(pdfUrl); // Converte a String para Uri

                      if (await canLaunchUrl(pdfUri)) {
                        await launchUrl(pdfUri);
                      } else {
                        throw 'Houve um erro ao abrir a url: $pdfUrl';
                      }
                    } else {
                      Get.to(() => PdfViewerPage(pdfUrl: pdfUrl));
                    }
                  }
                },
                title: 'DOAÇÕES POR CIDADE',
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Obx(() {
                      return DropdownButtonFormField<CityState>(
                        decoration: const InputDecoration(
                          hintText: 'CAPTADOR',
                        ),
                        value: controller.selectedCityState.value == 0
                            ? null
                            : controller.selectedCityState.value,
                        items: [
                          const DropdownMenuItem<CityState>(
                            value: null,
                            child: Text(
                              'Selecione uma cidade',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),
                          ...cityStateController.listCitiesDonation
                              .map((CityState cityState) {
                            return DropdownMenuItem<CityState>(
                              value: cityState,
                              child: Tooltip(
                                message: cityState.cidade!,
                                child: Text(
                                  '${cityState.cidade!.toUpperCase()} - ${cityState.estado!.toUpperCase()}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          controller.selectedCityState.value =
                              value ?? CityState();
                        },
                        validator: (value) {
                          if (value == null || value.cidadeEstado == 0) {
                            return 'Por favor, selecione um captador';
                          }
                          return null;
                        },
                      );
                    }),
                  ],
                ),
              ),
              CustomReportCard(
                onTap: () async {
                  if (controller.selectedUserId.value == null) {
                    Get.snackbar('ATENÇÃO', 'Selecione um captador',
                        backgroundColor: Colors.orange,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        colorText: Colors.white);
                  } else {
                    await controller
                        .getReport(controller.selectedUserId.value!);

                    if (controller.listReport.isEmpty) {
                      Get.snackbar('ATENÇÃO',
                          'Este captador ainda não fez nenhum contato!',
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 3),
                          colorText: Colors.white);
                    } else {
                      await controller
                          .generatePdf(controller.selectedUserId.value!);
                    }
                  }
                },
                title: 'CAPTADOR',
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Obx(() {
                      return DropdownButtonFormField<User>(
                        decoration: const InputDecoration(
                          hintText: 'CAPTADOR',
                        ),
                        value: controller.selectedUserId.value == 0
                            ? null
                            : controller.selectedUserId.value,
                        items: [
                          const DropdownMenuItem<User>(
                            value: null,
                            child: Text(
                              'Selecione um captador',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),
                          ...userController.listFundRaiser.map((User user) {
                            return DropdownMenuItem<User>(
                              value: user,
                              child: Tooltip(
                                message: user.name!,
                                child: Text(
                                  user.name!.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          controller.selectedUserId.value = value ?? User();
                        },
                        validator: (value) {
                          if (value == null || value.id == 0) {
                            return 'Por favor, selecione um captador';
                          }
                          return null;
                        },
                      );
                    }),
                  ],
                ),
              ),
              CustomReportCard(
                title: 'RELATÓRIO GERAL',
                subtitle: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.startDateController,
                              decoration: const InputDecoration(
                                  labelText: 'Data Inicial',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 14)),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  // Formato da data YYYY-MM-DD
                                  controller.startDateController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Selecione a data inicial';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: controller.endDateController,
                              decoration: const InputDecoration(
                                  labelText: 'Data Final',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 14)),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  // Formato da data YYYY-MM-DD
                                  controller.endDateController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Selecione a data final';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Campo de seleção de captador
                      Obx(() {
                        return DropdownButtonFormField<User>(
                          decoration: const InputDecoration(
                              labelText: 'Selecione um captador',
                              labelStyle: TextStyle(fontFamily: 'Poppins')),
                          value: controller.selectedUserId.value == 0
                              ? null
                              : controller.selectedUserId.value,
                          items: userController.listFundRaiser.map((User user) {
                            return DropdownMenuItem<User>(
                              value: user,
                              child: Text(
                                user.name!.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.selectedUserId.value = value ?? User();
                          },
                          validator: (value) {
                            if (value == null || value.id == 0) {
                              return 'Por favor, selecione um captador';
                            }
                            return null;
                          },
                        );
                      }),
                      const SizedBox(height: 20),
                      // Botão de gerar relatório
                    ],
                  ),
                ),
                onTap: () async {
                  if (controller.formKey.currentState!.validate()) {
                    String startDate = controller.startDateController.text;
                    String endDate = controller.endDateController.text;
                    int captadorId = controller.selectedUserId.value!.id!;

                    String url =
                        'https://captacao.casadobommeninodearapongas.org/relatoriogeral/pdf/$captadorId/$startDate/$endDate';

                    if (Platform.isWindows) {
                      Uri pdfUri = Uri.parse(url);
                      if (await canLaunchUrl(pdfUri)) {
                        await launchUrl(pdfUri);
                      } else {
                        Get.snackbar(
                          'Erro',
                          'Não foi possível abrir o PDF no navegador.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      try {
                        final response = await http.get(Uri.parse(url));
                        Get.back();
                        if (response.statusCode == 200) {
                          Get.to(() => PdfViewerPage(pdfUrl: url));
                        } else {
                          Get.snackbar(
                            'Erro',
                            'Falha ao carregar o PDF. Tente novamente mais tarde.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } catch (e) {
                        Get.back();
                        Get.snackbar(
                          'Erro',
                          'Erro ao baixar o PDF. Verifique sua conexão com a internet.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
