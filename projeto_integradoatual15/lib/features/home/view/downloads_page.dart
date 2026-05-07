import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:projeto_integrado/core/theme_provider.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  late Future<List<FileSystemEntity>> _downloadedFiles;

  @override
  void initState() {
    super.initState();
    _downloadedFiles = _getDownloadedFiles();
  }

  Future<List<FileSystemEntity>> _getDownloadedFiles() async {
    try {
      Directory downloadDir;
      if (Platform.isAndroid) {
        final androidDir = Directory('/storage/emulated/0/Download');
        if (await androidDir.exists()) {
          downloadDir = androidDir;
        } else {
          final externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            downloadDir = Directory('${externalDir.path}/Download');
            if (!await downloadDir.exists()) {
              await downloadDir.create(recursive: true);
            }
          } else {
            return [];
          }
        }
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }

      final files = downloadDir.listSync();
      return files
          .where((f) => f.path.endsWith('.pdf'))
          .toList()
        ..sort((a, b) => File(b.path).lastModifiedSync().compareTo(
              File(a.path).lastModifiedSync(),
            ));
    } catch (e) {
      return [];
    }
  }

  Future<void> _openFile(String filePath) async {
    final uri = Uri.file(filePath);
    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o arquivo')),
      );
    }
  }

  void _deleteFile(String filePath) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deletar arquivo?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              File(filePath).deleteSync();
              Navigator.pop(ctx);
              setState(() {
                _downloadedFiles = _getDownloadedFiles();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Arquivo deletado')),
              );
            },
            child: const Text(
              'Deletar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<List<FileSystemEntity>>(
        future: _downloadedFiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_done_rounded,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum arquivo baixado',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final file = File(snapshot.data![index].path);
              final fileName = file.path.split('/').last;
              final fileSize = _formatFileSize(file.lengthSync());
              final lastModified = file.lastModifiedSync();
              final formattedDate =
                  '${lastModified.day}/${lastModified.month}/${lastModified.year}';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Color(0xFF9C1818),
                    size: 32,
                  ),
                  title: Text(
                    fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '$fileSize • $formattedDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.open_in_new, size: 18),
                            SizedBox(width: 8),
                            Text('Abrir'),
                          ],
                        ),
                        onTap: () => _openFile(file.path),
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Deletar', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        onTap: () => _deleteFile(file.path),
                      ),
                    ],
                  ),
                  onTap: () => _openFile(file.path),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
