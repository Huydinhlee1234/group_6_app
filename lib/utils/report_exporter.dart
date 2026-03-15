import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';

class ReportExporter {
  // 1. HÀM XUẤT PDF
  static Future<void> exportPdf(Map<String, dynamic> bmiStats, Map<String, int> classStats, String reportTitle, String notes) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Text(reportTitle.toUpperCase(), style: pw.TextStyle(font: fontBold, fontSize: 20))),
              if (notes.isNotEmpty) ...[
                pw.SizedBox(height: 10),
                pw.Text('Ghi chú: $notes', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey700)),
              ],
              pw.SizedBox(height: 30),

              pw.Text('1. Thống kê chỉ số BMI', style: pw.TextStyle(font: fontBold, fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Tổng số SV hoàn thành: ${bmiStats['total']}', style: pw.TextStyle(font: font)),
              pw.Text('Bình thường: ${bmiStats['normal']} SV (${bmiStats['normalPercent'].toStringAsFixed(1)}%)', style: pw.TextStyle(font: font)),
              pw.Text('Thiếu cân: ${bmiStats['underweight']} SV (${bmiStats['underweightPercent'].toStringAsFixed(1)}%)', style: pw.TextStyle(font: font)),
              pw.Text('Thừa cân: ${bmiStats['overweight']} SV (${bmiStats['overweightPercent'].toStringAsFixed(1)}%)', style: pw.TextStyle(font: font)),
              pw.Text('Béo phì: ${bmiStats['obese']} SV (${bmiStats['obesePercent'].toStringAsFixed(1)}%)', style: pw.TextStyle(font: font)),
              pw.SizedBox(height: 20),

              pw.Text('2. Hoàn thành theo lớp', style: pw.TextStyle(font: fontBold, fontSize: 16)),
              pw.SizedBox(height: 10),
              ...classStats.entries.map((e) => pw.Text('Lớp ${e.key}: ${e.value} Sinh viên', style: pw.TextStyle(font: font))),
            ],
          );
        },
      ),
    );

    // ✨ FIX LỖI: Sửa lại Regex lọc tên file để GIỮ NGUYÊN TIẾNG VIỆT
    final safeFileName = reportTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '').replaceAll(' ', '_');

    // Lưu và chia sẻ PDF
    await Printing.sharePdf(bytes: await pdf.save(), filename: '${safeFileName}_Report.pdf');
  }

  // 2. HÀM XUẤT EXCEL
  static Future<void> exportExcel(Map<String, dynamic> bmiStats, Map<String, int> classStats, String reportTitle, String notes) async {
    var excel = Excel.createExcel();

    // Sheet 1: Thống kê BMI
    Sheet sheetBmi = excel['Thống kê BMI'];
    sheetBmi.appendRow([TextCellValue(reportTitle.toUpperCase())]);
    if (notes.isNotEmpty) sheetBmi.appendRow([TextCellValue('Ghi chú: $notes')]);
    sheetBmi.appendRow([TextCellValue('')]); // Dòng trống

    sheetBmi.appendRow([TextCellValue('Phân loại'), TextCellValue('Số lượng'), TextCellValue('Tỷ lệ (%)')]);
    sheetBmi.appendRow([TextCellValue('Thiếu cân'), IntCellValue(bmiStats['underweight']), DoubleCellValue(bmiStats['underweightPercent'])]);
    sheetBmi.appendRow([TextCellValue('Bình thường'), IntCellValue(bmiStats['normal']), DoubleCellValue(bmiStats['normalPercent'])]);
    sheetBmi.appendRow([TextCellValue('Thừa cân'), IntCellValue(bmiStats['overweight']), DoubleCellValue(bmiStats['overweightPercent'])]);
    sheetBmi.appendRow([TextCellValue('Béo phì'), IntCellValue(bmiStats['obese']), DoubleCellValue(bmiStats['obesePercent'])]);

    // Sheet 2: Thống kê Lớp
    Sheet sheetClass = excel['Hoàn thành theo lớp'];
    sheetClass.appendRow([TextCellValue('Lớp'), TextCellValue('Số SV hoàn thành')]);
    classStats.forEach((className, count) {
      sheetClass.appendRow([TextCellValue(className), IntCellValue(count)]);
    });

    if (excel.getDefaultSheet() == 'Sheet1') {
      excel.delete('Sheet1');
    }

    var fileBytes = excel.save();
    if (fileBytes != null) {
      // Tên file an toàn giữ nguyên tiếng Việt
      final safeFileName = reportTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '').replaceAll(' ', '_');

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${safeFileName}_Report.xlsx');

      await file.writeAsBytes(fileBytes);

      // Chia sẻ file Excel
      await Share.shareXFiles([XFile(file.path)], text: 'Báo cáo: $reportTitle');
    }
  }
}