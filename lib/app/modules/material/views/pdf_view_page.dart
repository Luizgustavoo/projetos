// pdf_view_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewPage extends StatelessWidget {
  final String pdfUrl;

  const PdfViewPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar PDF'),
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
