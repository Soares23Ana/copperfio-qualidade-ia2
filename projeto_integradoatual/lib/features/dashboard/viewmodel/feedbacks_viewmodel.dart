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

    await _service.criarFeedback(
      mensagem: mensagem,
      lote: lote,
      userId: userId,
      userEmpresa: userEmpresa,
      userName: userName,
      userEmail: userEmail,
      userType: userType,
      empresaId: userEmpresaId,
    );
  }
}
