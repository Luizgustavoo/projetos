import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projetos/app/data/models/city_state_model.dart';
import 'package:projetos/app/data/models/contact_company_model.dart';
import 'package:projetos/app/data/models/user_model.dart';
import 'package:projetos/app/data/repositories/report_repository.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:projetos/app/utils/service_storage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ReportController extends GetxController {
  RxList<ContactCompany> listReport = RxList<ContactCompany>([]);
  RxBool isLoading = true.obs;
  var selectedUserId = Rxn<User>();
  var selectedCityState = Rxn<CityState>();
  final repository = Get.put(ReportRepository());

  final endDateController = TextEditingController();
  final startDateController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  void clearFields() {
    selectedCityState.value = null;
    selectedUserId.value = null;
    startDateController.clear();
    endDateController.clear();
  }

  @override
  void onClose() {
    clearFields();
    super.onClose();
  }

  Future<void> getReport(User user) async {
    isLoading.value = true;
    try {
      final token = ServiceStorage.getToken();
      listReport.value =
          await repository.getAllReport("Bearer $token", user.id!);
      update();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> generatePdf(User user) async {
    final pdf = pw.Document();
    final String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    final int randomNum = Random().nextInt(100000);
    final ByteData imageData = await rootBundle.load('assets/images/bg.jpg');
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
          child: pw.Text('RELATÓRIO CAPTADOR: ${user.name!}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20, bottom: 10),
          child: pw.Text('DATA RELATÓRIO: $formattedDate',
              style: const pw.TextStyle(fontSize: 12, height: 10)),
        ),
        build: (context) => listReport.map((report) {
          return pw.Padding(
              padding: const pw.EdgeInsets.only(left: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 10),
                  pw.Text('EMPRESA: ${report.empresa}'),
                  pw.Text('CONTATO: ${report.nomePessoa}'),
                  pw.Text(
                      'CARGO CONTATO: ${report.cargoContato ?? 'NÃO PREENCHIDO'}'),
                  pw.Text(
                      'RETORNO: ${FormattedInputers.formatApiDate(report.dataRetorno!)}'),
                  pw.Text('PREVISÃO VALOR: ${report.previsaoValor}'),
                  pw.Text('MÊS DEPÓSITO: ${report.mesDeposito}'),
                  pw.Text(
                      'ULTIMA CAPTAÇÃO: ${FormattedInputers.formatApiDate(report.ultimaCaptacao ?? '')}'),
                  pw.SizedBox(height: 10),
                  pw.Text('OBSERVAÇÕES:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(report.observacoes!),
                  pw.Divider(),
                ],
              ));
        }).toList(),
      ),
    );

    final output = await pdf.save();
    await showShareDialog(
      Get.context!,
      'Relatório_Captador_$randomNum',
      output,
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
            if (!kIsWeb && defaultTargetPlatform != TargetPlatform.android)
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
}
