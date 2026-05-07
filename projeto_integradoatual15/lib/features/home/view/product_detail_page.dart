import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:projeto_integrado/core/theme_provider.dart';
import 'package:projeto_integrado/data/models/product_model.dart';
import 'package:projeto_integrado/services/notification_service.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha Técnica'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C1F1F),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.subtitle,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            if (product.description.isNotEmpty) ...[
              const Text(
                'Descrição',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9C1818),
                ),
              ),
              const SizedBox(height: 12),
              ...product.description
                  .split('\n\n')
                  .map(
                    (paragraph) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        paragraph,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 16),
            ],
            if (product.specs.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Especificações Técnicas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C1818),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...product.specs.map(
                      (spec) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(
                                spec,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openPdf(context),
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text('Baixar Ficha Técnica'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C1818),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(156, 24, 24, 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromRGBO(156, 24, 24, 0.3),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ℹ️ Informação',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9C1818),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque em "Baixar Ficha Técnica" para salvar o PDF diretamente no diretório de downloads do dispositivo. '
                    'O arquivo estará disponível no app Arquivos/Downloads.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPdf(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Iniciando download da ficha técnica...'),
        duration: Duration(seconds: 2),
      ),
    );

    final pdfUrl = product.effectivePdfUrl;
    if (pdfUrl.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('PDF não disponível para este produto.')),
      );
      return;
    }

    if (pdfUrl.startsWith('assets/')) {
      final file = await _downloadAssetPdf(context, pdfUrl);
      if (file != null && await file.exists()) {
        final opened = await launchUrl(Uri.file(file.path));
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              opened
                  ? 'Ficha técnica aberta. Se não abrir, veja em: ${file.path}'
                  : 'Download concluído: ${file.path}',
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    final launched = await launchUrl(
      Uri.parse(pdfUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir a ficha técnica.'),
        ),
      );
    }
  }

  Future<File?> _downloadAssetPdf(
    BuildContext context,
    String assetPath,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      final fileName = assetPath.split('/').last;

      // Usa flutter_file_dialog para apresentar um diálogo de salvar
      final savePath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          fileName: fileName,
          mimeTypesFilter: ['application/pdf'],
          sourceFilePath: await _getTempFilePath(bytes, fileName),
        ),
      );

      if (savePath == null || savePath.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Download cancelado'),
            duration: Duration(seconds: 2),
          ),
        );
        return null;
      }

      final file = File(savePath);
      await file.writeAsBytes(bytes, flush: true);

      if (await file.exists()) {
        await NotificationService().showDownloadNotification(
          fileName: fileName,
          filePath: file.path,
        );

        messenger.showSnackBar(
          SnackBar(
            content: Text('✓ Ficha técnica salva em: ${file.path}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
        return file;
      }
      return null;
    } catch (e) {
      // Fallback para download automático se o diálogo falhar
      try {
        final byteData = await rootBundle.load(assetPath);
        final bytes = byteData.buffer.asUint8List();
        final fileName = assetPath.split('/').last;
        final downloadDir = await _getDownloadDirectory();
        final file = File('${downloadDir.path}/$fileName');

        await file.create(recursive: true);
        await file.writeAsBytes(bytes, flush: true);

        if (await file.exists()) {
          await NotificationService().showDownloadNotification(
            fileName: fileName,
            filePath: file.path,
          );

          messenger.showSnackBar(
            SnackBar(
              content: Text('✓ Ficha técnica salva em: ${file.path}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
          return file;
        }
      } catch (fallbackError) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: ${fallbackError.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return null;
    }
  }

  Future<String> _getTempFilePath(List<int> bytes, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile.path;
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final androidPublicDir = Directory('/storage/emulated/0/Download');
      if (await androidPublicDir.exists()) {
        return androidPublicDir;
      }

      try {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final rootPath = externalDir.path.split('/Android').first;
          final downloadDir = Directory('$rootPath/Download');
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          return downloadDir;
        }
      } catch (_) {
        // Ignora falha e tenta outras pastas.
      }

      try {
        final downloadDirs = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );
        if (downloadDirs != null && downloadDirs.isNotEmpty) {
          final downloadDir = downloadDirs.first;
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          return downloadDir;
        }
      } catch (_) {
        // Ignora falha e usa documentos.
      }
    }

    return await getApplicationDocumentsDirectory();
  }
}
