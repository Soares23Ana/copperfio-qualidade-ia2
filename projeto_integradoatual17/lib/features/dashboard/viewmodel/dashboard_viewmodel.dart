import 'package:flutter/material.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  int feedbacks = 0;
  int satisfacao = 25;
  int alertas = 0;
  int chamados = 0;

  Future<void> loadData() async {
    try {
      final userData = await _authService.getCurrentUserData();
      final empresaId = userData?['empresaId'] as String? ?? 'copperfio';

      feedbacks = await _firestoreService.getFeedbacksCount(empresaId);
      alertas = await _firestoreService.getUnreadFeedbacksCount(empresaId);
      chamados = await _firestoreService.getChamadosCount(empresaId);

      notifyListeners();
    } catch (e) {
      // Em caso de erro, manter valores padrão ou logar
      debugPrint('Erro ao carregar dados do dashboard: $e');
    }
  }

  double satisfacaoTrend = 75.0;

  Map<String, int> problemasPorLote = {
    "CASE1": 10,
    "CASE2": 20,
    "CASE3": 5,
    "CASE4": 15,
  };

  Map<String, double> distribuicaoSentimento = {
    "Positivo": 50,
    "Neutro": 15,
    "Negativo": 35,
  };

  Map<String, double> valorPorProduto = {
    "Produto A": 30,
    "Produto B": 25,
    "Produto C": 20,
    "Produto D": 25,
  };

  Map<String, double> regioes = {
    "Região A": 60,
    "Região B": 40,
  };
}
