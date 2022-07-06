import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart';

class PdfApi {
  static Future<File> generatepdf(var pdfchaptertext) async {
    if(kDebugMode) {
      print('Enter in to generatepdf function');
    }
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (context) => pw.Container(
        padding: const pw.EdgeInsets.fromLTRB(16, 60, 16, 0),
        child: pdfchaptertext == null ? pw.Text('Text') : pw.Text(
          pdfchaptertext,
        ),
      ),
    ));

    return saveDocument(name: 'my pdf.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required var pdf,
  }) async {

    if(kDebugMode) {
      print('Enter in to saveDocument function');
    }

    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    if(kDebugMode) {
      print('pdf Successfully saved');
    }
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

class PdfParagraphApi {
  static Future<File> generatepdf(var pdfchaptertext, var chaptername, var dateTime) async {
    final ByteData bytes = await rootBundle.load('assets/images/launcher_icon.jpg');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final pdf = pw.Document();

    pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            buildCustomHeadline(chaptername),
            PdfParagraphApiMultiChapter.buildLink(),
            pw.Paragraph(text: pdfchaptertext),
          ],
            footer: (context) {
              final text = 'Page ${context.pageNumber} of ${context.pagesCount}';
              return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                        height: 40,
                        width: 40,
                        child: pw.ClipRRect(
                            child: pw.Image(
                                pw.MemoryImage(
                                  byteList,
                                ),
                                fit: pw.BoxFit.cover
                            )
                        )
                    ),
                    pw.Text(
                        text,
                        style: const pw.TextStyle(color: PdfColors.blue)
                    )
                  ]
              );
            }
    ));

    return PdfApi.saveDocument(name: '$chaptername $dateTime.pdf', pdf: pdf);
  }
  static pw.Widget buildCustomHeadline(String chaptername) => pw.Header(
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
                chaptername.toString(),
                style: pw.TextStyle(
                  fontSize: 36,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                )
            ),
            pw.PdfLogo(
              color: PdfColors.white,
            ),
          ]
      ),
      padding: const pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: const pw.BoxDecoration(color: PdfColors.blue)
  );
}


class PdfParagraphApiMultiChapter {
  static Future<File> generatepdf(var pdfchaptertext, var bookname, var dateTime,) async {
    final ByteData bytes = await rootBundle.load('assets/images/launcher_icon.jpg');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final pdf = pw.Document();
    pdf.addPage(
        pw.MultiPage(
            build: (context) => [
              buildCustomHeadline(bookname),
              buildLink(),
              pw.Paragraph(text: pdfchaptertext),
            ],
          footer: (context) {
              final text = 'Page ${context.pageNumber} of ${context.pagesCount}';
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                  height: 40,
                  width: 40,
                  child: pw.ClipRRect(
                      child: pw.Image(
                          pw.MemoryImage(
                            byteList,
                          ),
                          fit: pw.BoxFit.cover
                      )
                  )
              ),
                  pw.Text(
                    text,
                    style: const pw.TextStyle(color: PdfColors.blue)
                  )
                ]
              );
          }
        )
    );

    return PdfApi.saveDocument(name: 'Briefify-$bookname-$dateTime.pdf', pdf: pdf);
  }
  static pw.Widget buildCustomHeadline(String bookname) => pw.Header(
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
            bookname.toString(),
            style: pw.TextStyle(
              fontSize: 36,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            )
        ),
        pw.PdfLogo(
          color: PdfColors.white,
        ),
      ]
    ),
    padding: const pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
    decoration: const pw.BoxDecoration(color: PdfColors.blue)
  );

  static pw.UrlLink buildLink() => pw.UrlLink(
destination: 'https://play.google.com/store/apps/details?id=com.briefify.knowledge&hl=en&gl=US',
    child: pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Text(
        'Go To Briefify App',
        style: const pw.TextStyle(
          decoration: pw.TextDecoration.underline,
          color: PdfColors.blue,
        ),
      ),
    )
  );
}