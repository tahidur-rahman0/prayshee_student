import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:online_training_template/app/const/const.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdf;

  const PDFViewerPage({
    Key? key,
    required this.pdf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pdfUrl = '${ServerConstant.baseUrl}/$pdf';

    return Scaffold(
      appBar: AppBar(title: const Text("Prayashee Read")),
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }
}
