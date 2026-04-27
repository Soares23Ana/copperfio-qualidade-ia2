import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackDetailPage extends StatelessWidget {
  final Map<String, dynamic> feedbackData;

  const FeedbackDetailPage({super.key, required this.feedbackData});

  @override
  Widget build(BuildContext context) {
    final mensagem = feedbackData['mensagem'] as String? ?? '';
    final lote = feedbackData['lote'] as String? ?? '';
    final userEmpresa = feedbackData['userEmpresa'] as String? ??
        feedbackData['empresaId'] as String? ?? '';
    final userName = feedbackData['userName'] as String? ??
        feedbackData['userEmail'] as String? ??
        'Cliente';
    final userEmail = feedbackData['userEmail'] as String? ?? '';
    final status = feedbackData['status'] as String? ?? 'novo';
    final userType = feedbackData['userType'] as String? ?? 'cliente';
    final Timestamp? createdAt = feedbackData['data'] as Timestamp?;
    final dateLabel = createdAt != null
        ? DateTime.fromMillisecondsSinceEpoch(
            createdAt.millisecondsSinceEpoch,
          ).toLocal().toString()
        : 'Data não disponível';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detalhes do Feedback',
          style: TextStyle(color: Colors.white),
        ),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
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
                          _detailRow('Empresa', userEmpresa),
                          const SizedBox(height: 8),
                        ],
                        _detailRow('Cliente', userName),
                        if (userEmail.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _detailRow('Email', userEmail),
                        ],
                        const SizedBox(height: 8),
                        _detailRow('Tipo de usuário', userType),
                        const SizedBox(height: 8),
                        _detailRow('Status', status.toUpperCase()),
                        const SizedBox(height: 8),
                        _detailRow('Enviado em', dateLabel),
                        const SizedBox(height: 16),
                        const Text(
                          'Mensagem',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mensagem,
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
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

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }
}
