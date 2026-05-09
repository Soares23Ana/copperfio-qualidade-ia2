import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrado/core/theme_provider.dart';

class FeedbackDetailPage extends StatelessWidget {
  final Map<String, dynamic> feedbackData;

  const FeedbackDetailPage({super.key, required this.feedbackData});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[700];
    
    final mensagem = feedbackData['mensagem'] as String? ?? '';
    final lote = feedbackData['lote'] as String? ?? '';
    final userEmpresa =
        feedbackData['userEmpresa'] as String? ??
        feedbackData['empresaId'] as String? ??
        '';
    final userName =
        feedbackData['userName'] as String? ??
        feedbackData['userEmail'] as String? ??
        'Cliente';
    final userEmail = feedbackData['userEmail'] as String? ?? '';
    final status = feedbackData['status'] as String? ?? 'novo';
    final userType = feedbackData['userType'] as String? ?? 'cliente';
    final atendimentoMood = feedbackData['atendimentoMood'] as String? ?? '';
    final generalRating = feedbackData['generalRating'] as int? ?? 0;
    final tags = (feedbackData['tags'] as List<dynamic>?)?.cast<String>() ?? [];
    final photoUrl = feedbackData['photoUrl'] as String? ?? '';
    final Timestamp? createdAt = feedbackData['data'] as Timestamp?;
    final dateLabel = createdAt != null
        ? DateTime.fromMillisecondsSinceEpoch(
            createdAt.millisecondsSinceEpoch,
          ).toLocal().toString()
        : 'Data não disponível';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detalhes do Feedback',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  lote.isNotEmpty ? 'Lote: $lote' : 'Feedback do cliente',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (userEmpresa.isNotEmpty) ...[
                          _detailRow('Empresa', userEmpresa, isDark),
                          const SizedBox(height: 8),
                        ],
                        _detailRow('Cliente', userName, isDark),
                        if (userEmail.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _detailRow('Email', userEmail, isDark),
                        ],
                        const SizedBox(height: 8),
                        _detailRow('Tipo de usuário', userType, isDark),
                        const SizedBox(height: 8),
                        _detailRow('Status', status.toUpperCase(), isDark),
                        const SizedBox(height: 8),
                        _detailRow('Enviado em', dateLabel, isDark),
                        const SizedBox(height: 16),
                        Text(
                          'Resumo da avaliação',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _detailRow(
                          'Avaliação geral',
                          generalRating > 0 ? '$generalRating estrelas' : '-',
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _detailRow(
                          'Atendimento',
                          atendimentoMood.isNotEmpty ? atendimentoMood : '-',
                          isDark,
                        ),
                        if (tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _detailRow('Tags', tags.join(', '), isDark),
                        ],
                        const SizedBox(height: 16),
                        Text(
                          'Mensagem detalhada',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mensagem,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: secondaryText,
                          ),
                        ),
                        if (photoUrl.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Foto enviada',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return SizedBox(
                                  height: 180,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            errorBuilder: (context, error, stackTrace) => SizedBox(
                              height: 180,
                              child: Center(
                                child: Text(
                                  'Não foi possível carregar a imagem',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final labelColor = isDark ? Colors.grey[300] : Colors.black87;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }
}
