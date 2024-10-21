import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/report_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerPage({super.key, required this.pdfUrl});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;
  int? totalPages = 0;
  int currentPage = 0;
  bool isReady = false;
  late PDFViewController pdfViewController;

  @override
  void initState() {
    super.initState();
    downloadPdf();
  }

  Future<void> downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/relatorio_doacoes_empresa.pdf');
        await file.writeAsBytes(bytes);
        setState(() {
          localPath = file.path;
        });
      }
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao baixar o PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        Get.find<ReportController>().clearFields();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('VISUALIZAR PDF'),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                if (localPath != null) {
                  Share.shareXFiles([XFile(localPath!)],
                      text: 'Relatório de Doações');
                } else {
                  Get.snackbar('Erro', 'PDF ainda não foi carregado.');
                }
              },
            ),
          ],
        ),
        body: localPath != null
            ? Stack(
                children: [
                  PDFView(
                    filePath: localPath!,
                    enableSwipe: true,
                    swipeHorizontal:
                        false, // Permitir navegação vertical entre páginas
                    autoSpacing: false,
                    pageFling: false,
                    onRender: (pages) {
                      setState(() {
                        totalPages = pages;
                        isReady = true;
                      });
                    },
                    onViewCreated: (PDFViewController vc) {
                      pdfViewController = vc;
                    },
                    onPageChanged: (int? page, int? total) {
                      setState(() {
                        currentPage = page ?? 0;
                      });
                    },
                  ),
                  if (!isReady)
                    const Center(child: CircularProgressIndicator()),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
