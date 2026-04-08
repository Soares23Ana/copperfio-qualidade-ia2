import 'package:flutter/material.dart';
import '../data/models/usuario_model.dart'; // Ajuste conforme o nome real do seu model
import '../data/repositories/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  // Instância do repositório (Camada Data)
  final ChatRepository _repository = ChatRepository();

  // Estados da Tela
  List<dynamic> _mensagens = [];
  bool _estaCarregando = false;
  String? _erro;

  // Getters para a View acessar os dados sem alterá-los diretamente
  List<dynamic> get mensagens => _mensagens;
  bool get estaCarregando => _estaCarregando;
  String? get erro => _erro;

  // Função para buscar mensagens
  Future<void> carregarMensagens() async {
    _setLoading(true);
    _erro = null;

    try {
      _mensagens = await _repository.fetchMessages();
    } catch (e) {
      _erro = "Erro ao carregar mensagens: $e";
    } finally {
      _setLoading(false);
    }
  }

  // Função para enviar uma nova mensagem
  Future<void> enviarMensagem(String texto) async {
    if (texto.trim().isEmpty) return;

    try {
      // Opcional: Adicionar a mensagem localmente primeiro para dar sensação de velocidade (UI reativa)
      await _repository.sendMessage(texto, 'usuario_atual'); // Usar ID do usuário logado
      await carregarMensagens(); // Atualiza a lista após enviar
    } catch (e) {
      _erro = "Não foi possível enviar a mensagem.";
      notifyListeners();
    }
  }

  // Método auxiliar para gerenciar o estado de loading e notificar a UI
  void _setLoading(bool valor) {
    _estaCarregando = valor;
    notifyListeners();
  }
}