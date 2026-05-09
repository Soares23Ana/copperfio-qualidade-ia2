import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_integrado/services/auth_service.dart';
import 'package:projeto_integrado/services/firestore_service.dart';

class FeedbacksViewModel extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  final AuthService _authService = AuthService();

  Stream<QuerySnapshot<Map<String, dynamic>>> feedbacksStream() async* {
    final userData = await _authService.getCurrentUserData();
    final empresaId = userData?['empresaId'] as String? ?? 'copperfio';
    yield* _service.getFeedbacks(empresaId);
  }

  Future<void> enviarFeedback({
    required String mensagem,
    required String lote,
    required List<int> itemScores,
    required int generalRating,
    required String atendimentoMood,
    required List<String> tags,
    File? photoFile,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) {
      throw Exception('Usuário não autenticado');
    }

    final userData = await _authService.getCurrentUserData();
    final userName = userData?['nome'] as String?;
    final userEmail = userData?['email'] as String?;
    final userType = userData?['tipo'] as String?;
    final userEmpresa =
        userData?['empresa'] as String? ?? userData?['empresaId'] as String?;

    final userEmpresaId = userData?['empresaId'] as String? ?? 'copperfio';

    final averageScore = itemScores.isEmpty
        ? 0.0
        : itemScores.reduce((a, b) => a + b) / itemScores.length;

    String? photoUrl;
    if (photoFile != null) {
      photoUrl = await _service.uploadFeedbackImage(photoFile, userId);
    }

    await _service.criarFeedback(
      mensagem: mensagem,
      lote: lote,
      item1: itemScores[0],
      item2: itemScores[1],
      item3: itemScores[2],
      item4: itemScores[3],
      item5: itemScores[4],
      item6: itemScores[5],
      item7: itemScores[6],
      item8: itemScores[7],
      notaMedia: averageScore,
      generalRating: generalRating,
      atendimentoMood: atendimentoMood,
      tags: tags,
      photoUrl: photoUrl,
      userId: userId,
      userEmpresa: userEmpresa,
      userName: userName,
      userEmail: userEmail,
      userType: userType,
      empresaId: userEmpresaId,
    );
  }

  // Deletar feedback
  Future<void> deletarFeedback(String feedbackId) async {
    try {
      await _service.deletarFeedback(feedbackId);
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao deletar feedback: $e');
    }
  }

  // Marcar feedback como lido
  Future<void> marcarComoLido(String feedbackId) async {
    try {
      await _service.marcarFeedbackComoLido(feedbackId);
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao marcar como lido: $e');
    }
  }
}
