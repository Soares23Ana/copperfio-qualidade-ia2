import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_integrado/data/models/chamado_model.dart';
import 'package:projeto_integrado/data/repositories/chamados_repository.dart';
import 'package:projeto_integrado/services/auth_service.dart';
import 'package:projeto_integrado/services/firestore_service.dart';

class AlertasViewModel extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  final ChamadosRepository _repository = ChamadosRepository();
  final AuthService _authService = AuthService();

  Stream<QuerySnapshot<Map<String, dynamic>>> feedbacksStream() async* {
    final userData = await _authService.getCurrentUserData();
    final empresaId = userData?['empresaId'] as String? ?? 'copperfio';
    yield* _service.getFeedbacks(empresaId);
  }

  Stream<List<ChamadoModel>> chamadosStream() async* {
    final userData = await _authService.getCurrentUserData();
    final empresaId = userData?['empresaId'] as String? ?? 'copperfio';
    yield* _repository.buscarChamadosDaEmpresa(empresaId);
  }

  bool isFeedbackAlert(Map<String, dynamic> data) {
    final notaMedia = (data['notaMedia'] as num?)?.toDouble() ?? 0.0;
    final generalRating = data['generalRating'] as int? ?? 0;
    final mensagem = (data['mensagem'] as String? ?? '').toLowerCase();
    final titulo = (data['titulo'] as String? ?? '').toLowerCase();
    final descricao = (data['descricao'] as String? ?? '').toLowerCase();
    final tags = (data['tags'] as List<dynamic>?)?.cast<String>() ?? [];
    final atendimentoMood = (data['atendimentoMood'] as String? ?? '').toLowerCase();
    final texto = '$mensagem $titulo $descricao $atendimentoMood'.toLowerCase();

    return notaMedia <= 4.5 ||
        generalRating <= 3 ||
        texto.contains('ruim') ||
        texto.contains('problema') ||
        texto.contains('atraso') ||
        texto.contains('crítico') ||
        texto.contains('insatisfatório') ||
        tags.any((tag) {
          final lower = tag.toLowerCase();
          return lower.contains('crítico') || lower.contains('reclamação') || lower.contains('urgente');
        });
  }

  bool isChamadoAlert(ChamadoModel chamado) {
    final status = chamado.status.toLowerCase();
    final prioridade = chamado.prioridade.toLowerCase();
    final titulo = chamado.titulo.toLowerCase();
    final descricao = chamado.descricao.toLowerCase();

    return prioridade == 'alta' ||
        status == 'aberto' ||
        status == 'em_atendimento' ||
        titulo.contains('urgente') ||
        descricao.contains('urgente') ||
        descricao.contains('falha') ||
        descricao.contains('parada');
  }
}
