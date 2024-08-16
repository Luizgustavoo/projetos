// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projetos/app/data/controllers/bill_controller.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/controllers/contact_controller.dart';
import 'package:projetos/app/data/controllers/fundraiser_controller.dart';
import 'package:projetos/app/data/models/bill_model.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/modules/company/widgets/custom_my_company_card.dart';
import 'package:projetos/app/modules/company/widgets/create_company_modal.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class MyCompanyView extends GetView<CompanyController> {
  MyCompanyView({super.key});
  final billController = Get.put(BillController());
  @override
  Widget build(BuildContext context) {
    String titulo = "MINHAS EMPRESAS";

    if (Get.arguments != null && Get.arguments is User) {
      final User user = Get.arguments as User;
      titulo = "EMPRESAS DE ${user.name!.toUpperCase()}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: controller.searchControllerMyCompany,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar Empresas',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const Expanded(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Carregando...'),
                          SizedBox(height: 20.0),
                          CircularProgressIndicator(
                            value: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (controller.isLoading.value == false &&
                    controller.listCompany.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      itemCount: controller.filteredMyCompanies.length,
                      itemBuilder: (context, index) {
                        Company company = controller.filteredMyCompanies[index];
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              showDeleteDialog(context, company);
                            } else if (direction ==
                                DismissDirection.startToEnd) {
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
                              final contactController =
                                  Get.put(ContactController());
                              contactController.getContactCompanies(company);
                              Get.toNamed(Routes.contactcompany,
                                  arguments: company);
                            },
                            child: CustomCompanyCard(
                              name: company.nome ?? "",
                              responsible: company.responsavel ?? "",
                              phone: company.telefone ?? "",
                              contactName: company.nomePessoa ?? "",
                              city: company.cidade ?? "",
                              state: company.estado ?? "",
                              color: const Color(0xFFFFF3DB),
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
              },
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
      floatingActionButton: ServiceStorage.getUserType() == 1
          ? FloatingActionButton(
              mini: true,
              elevation: 2,
              backgroundColor: Colors.orange,
              onPressed: () async {
                final pdf = pw.Document();
                final User user = Get.arguments as User;
                final String formattedDate =
                    DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
                final int randomNum = Random().nextInt(100000);
                final ByteData imageData =
                    await rootBundle.load('assets/images/bg.jpg');
                final Uint8List bytes = imageData.buffer.asUint8List();
                final image = pw.MemoryImage(bytes);

                pdf.addPage(
                  pw.MultiPage(
                    pageTheme: pw.PageTheme(
                      margin: pw.EdgeInsets.zero,
                      buildBackground: (context) => pw.Positioned.fill(
                        child: pw.Image(image, fit: pw.BoxFit.cover),
                      ),
                    ),
                    header: (context) => pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 70, left: 20),
                      child: pw.Text(
                        'RELATÓRIO CAPTADOR: ${user.name!.toUpperCase()}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    footer: (context) => pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 20, bottom: 10),
                      child: pw.Text(
                        'DATA RELATÓRIO: $formattedDate',
                        style: const pw.TextStyle(fontSize: 12, height: 10),
                      ),
                    ),
                    build: (context) => [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            left: 20, right: 5, top: 8),
                        child: pw.TableHelper.fromTextArray(
                          cellPadding:
                              const pw.EdgeInsets.symmetric(horizontal: 10),
                          headers: [
                            'ID',
                            'EMPRESA',
                            'CNPJ',
                            'RESPONSÁVEL',
                            'TELEFONE',
                            'CONTATO'
                          ],
                          data: controller.filteredMyCompanies.map((company) {
                            return [
                              company.id.toString(),
                              company.nome ?? '',
                              company.cnpj ?? '',
                              company.responsavel ?? '',
                              company.telefone ?? '',
                              company.nomePessoa ?? '',
                            ];
                          }).toList(),
                          border: pw.TableBorder.all(),
                          headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                          cellStyle: const pw.TextStyle(fontSize: 10),
                          cellAlignment: pw.Alignment.centerLeft,
                          headerDecoration: const pw.BoxDecoration(
                            color: PdfColors.grey300,
                          ),
                          cellHeight: 25,
                          columnWidths: {
                            0: const pw.FixedColumnWidth(30),
                            1: const pw.FlexColumnWidth(85),
                            2: const pw.FixedColumnWidth(100),
                            3: const pw.FixedColumnWidth(100),
                            4: const pw.FixedColumnWidth(100),
                            5: const pw.FixedColumnWidth(70),
                          },
                        ),
                      ),
                    ],
                  ),
                );

                final output = await pdf.save();
                await showShareDialog(
                  Get.context!,
                  'Relatório_Captador_$randomNum',
                  output,
                );
              },
              child: const Icon(
                Icons.download_rounded,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
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

  Future<void> showShareDialog(
      BuildContext context, String fileName, List<int> pdfData) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Compartilhar Relatório'),
          titleTextStyle:
              const TextStyle(fontFamily: 'Poppinss', color: Colors.black),
          content:
              const Text('Como você gostaria de compartilhar o relatório?'),
          contentTextStyle:
              const TextStyle(fontFamily: 'Poppins', color: Colors.black),
          actions: [
            TextButton.icon(
              onPressed: () {
                Get.back();
                saveFile(pdfData, fileName);
              },
              label: const Text(
                'Salvar',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              icon: const Icon(
                Icons.save_alt_rounded,
                color: Colors.black,
              ),
            ),
            if (!kIsWeb && defaultTargetPlatform != TargetPlatform.windows)
              TextButton.icon(
                onPressed: () {
                  Get.back();
                  shareFileByWhatsApp(pdfData, fileName);
                },
                label: const Text(
                  'E-mail/Whatsapp',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                icon: const Icon(
                  Icons.email_rounded,
                  color: Colors.black,
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> saveFile(List<int> pdfData, String fileName) async {
    // Verifique se a permissão de armazenamento foi concedida
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      final result = await Permission.storage.request();
      if (!result.isGranted) {
        // Se a permissão não for concedida, mostre uma mensagem para o usuário
        Get.snackbar(
          'Permissão negada',
          'A permissão de armazenamento é necessária para salvar o arquivo.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    try {
      // Obtém o diretório para salvar o arquivo
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      // Verifica se o diretório existe e cria se necessário
      bool hasExisted = await directory.exists();
      if (!hasExisted) {
        await directory.create(recursive: true);
      }

      // Cria o arquivo
      final filePath =
          "${directory.path}${Platform.pathSeparator}$fileName.pdf";
      final file = File(filePath);
      if (!file.existsSync()) {
        await file.create();
      }

      // Escreve os dados do PDF no arquivo
      await file.writeAsBytes(pdfData);
      Get.snackbar(
        'Sucesso!',
        'Arquivo salvo com sucesso em $filePath',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro!',
        'Ocorreu um erro ao salvar o arquivo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> shareFileByWhatsApp(List<int> pdfData, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    final file = File('$path/$fileName.pdf');
    await file.writeAsBytes(pdfData);

    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Segue em anexo o relatório de empresas.',
      );
      Get.snackbar(
        'Sucesso',
        'Arquivo compartilhado com sucesso!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Ocorreu um erro ao compartilhar o arquivo.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
                        labelText: 'DATA PREVISTA', counterText: ''),
                    onChanged: (value) {
                      fundRaiserController.onFundRaiserDateChanged(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: fundRaiserController.valueFundController,
                    decoration: const InputDecoration(
                      labelText: 'VALOR PREVISTO',
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
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> retorno =
                              await controller.unlinkCompany(company.id);

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
                        child: const Text('Excluir'),
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
