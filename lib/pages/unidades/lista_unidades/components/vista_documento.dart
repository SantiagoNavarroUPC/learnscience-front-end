import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewPage extends StatefulWidget {
  final String filePath;

  const PDFViewPage({super.key, required this.filePath});

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  PdfController? pdfController;

  @override
  void initState() {
    super.initState();
    pdfController = PdfController(
      document: PdfDocument.openFile(widget.filePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visor de material educativo',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true, // Esto centra el título
      ),
      body: pdfController == null
          ? const Center(child: CircularProgressIndicator())
          : PdfView(
              controller: pdfController!,
              onDocumentLoaded: (info) {
                Get.snackbar(
                  'Documento Cargado',
                  'Número de páginas: ${info.pagesCount}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: gColorTheme1_900,
                  colorText: Colors.white,
                );
              },
            ),
    );
  }
}
