import 'package:flutter/material.dart';

class FeedbackItem {
  final String cliente;
  final String comentario;
  final double nota;

  FeedbackItem({required this.cliente, required this.comentario, required this.nota});
}

class FeedbacksViewModel extends ChangeNotifier {
  final List<FeedbackItem> feedbacks = [
    FeedbackItem(
      cliente: "Eliene São João Lda",
      comentario: "Produto entregue dentro do prazo e sem erros. Qualidade acima da expectativa.",
      nota: 3.7,
    ),
    FeedbackItem(
      cliente: "Silas Oliveira",
      comentario: "Excelente atendimento, produto conforme solicitado e qualidade excepcional.",
      nota: 4.5,
    ),
    FeedbackItem(
      cliente: "Andressa Ferreira",
      comentario: "Produto ok, mas embalagem podia ser melhor.",
      nota: 3.0,
    ),
    FeedbackItem(
      cliente: "Carmélia Santos",
      comentario: "Entrega dentro do prazo e sem falhas. Compramos novamente desta fornecedora.",
      nota: 3.8,
    ),
    FeedbackItem(
      cliente: "Gilson Muniz",
      comentario: "Muito bom desempenho e menos necessidade. Recomendamos!",
      nota: 4.2,
    ),
  ];
}
