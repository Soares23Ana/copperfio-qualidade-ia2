import 'package:flutter/material.dart';

class Chamado {
  final String titulo;
  final String descricao;
  final String codigo;
  final Color cor;

  Chamado({
    required this.titulo,
    required this.descricao,
    required this.codigo,
    required this.cor,
  });
}

class ChamadosViewModel extends ChangeNotifier {
  final List<Chamado> chamados = [
    Chamado(
      titulo: "MC - Qualidade: Calos de Mão - Manutenção Elevadores",
      descricao: "Aguardando atendimento",
      codigo: "ICP-004",
      cor: Colors.pink.shade200,
    ),
    Chamado(
      titulo: "Logística: Mudança Prédio",
      descricao: "Aguardando atendimento",
      codigo: "ICP-003",
      cor: Colors.orange.shade200,
    ),
    Chamado(
      titulo: "Manutenção: Troca de Lâmpadas",
      descricao: "Aguardando atendimento",
      codigo: "ICP-002",
      cor: Colors.blue.shade200,
    ),
    Chamado(
      titulo: "PISO de Produção",
      descricao: "Aguardando atendimento",
      codigo: "ICP-001",
      cor: Colors.red.shade200,
    ),
    Chamado(
      titulo: "MC - Qualidade: Inspeção de Material Dublado",
      descricao: "Aguardando atendimento",
      codigo: "ICP-007",
      cor: Colors.green.shade200,
    ),
    Chamado(
      titulo: "EXTERNO: Solicitação de Ensaio de Laboratório",
      descricao: "Aguardando atendimento",
      codigo: "ICP-006",
      cor: Colors.purple.shade200,
    ),
  ];
}
