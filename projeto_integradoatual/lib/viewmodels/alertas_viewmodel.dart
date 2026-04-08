import 'package:flutter/material.dart';

class Alerta {
  final String titulo;
  final String descricao;

  Alerta({required this.titulo, required this.descricao});
}

class AlertasViewModel extends ChangeNotifier {
  final List<Alerta> alertas = [
    Alerta(
      titulo: "Falha na comunicação com o servidor principal",
      descricao: "Verifique a conexão de rede e tente novamente.",
    ),
    Alerta(
      titulo: "Conexão instável detectada",
      descricao: "Considere reiniciar o roteador ou verificar o cabo de rede.",
    ),
  ];

  final List<String> contatosImediatos = [
    "Elektro Silva Ltda",
    "Construtronics Almeida",
  ];
}
