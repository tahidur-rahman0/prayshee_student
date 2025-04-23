import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:online_training_template/app/const/const.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFViewerPage extends StatefulWidget {
  final String pdf;

  const PDFViewerPage({
    Key? key,
    required this.pdf,
  }) : super(key: key);

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF();
  }

  Future<void> _downloadAndSavePDF() async {
    try {
      final String pdfUrl = '${ServerConstant.baseUrl}/${widget.pdf}';
      final response = await http.get(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = widget.pdf.split('/').last;
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prayashee Read")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath != null
              ? SfPdfViewer.file(
                  File(localPath!),
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                )
              : const Center(child: Text('Failed to load PDF')),
    );
  }
}
