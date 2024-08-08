// pdf_view_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/models/material_model.dart';

class PdfViewPage extends StatelessWidget {
  final String pdfUrl;

  PdfViewPage({super.key, required this.pdfUrl});
  final materialModel = Get.arguments as MaterialModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(materialModel.descricao!),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (double progress) => Center(
          child: Text('$progress %'),
        ),
        errorWidget: (dynamic error) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}
