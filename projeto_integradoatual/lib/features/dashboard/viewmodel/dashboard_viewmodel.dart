import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  int feedbacks = 118;
  int satisfacao = 25;
  int alertas = 2;

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
