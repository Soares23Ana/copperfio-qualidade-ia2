class ChatRepository {
  // Aqui você colocaria a lógica de buscar mensagens de uma API ou Firebase
  Future<List<dynamic>> fetchMessages() async {
    // Exemplo: return await api.get('/messages');
    return [];
  }

  // Método para enviar mensagem
  Future<void> sendMessage(String texto, String usuarioId) async {
    // Exemplo: await api.post('/messages', data: {'text': texto, 'userId': usuarioId});
    // Por enquanto, apenas simula o envio
  }
}