import 'dart:async';

import 'package:flutter/material.dart';

class ClientChatHomePage extends StatefulWidget {
  const ClientChatHomePage({super.key});

  @override
  State<ClientChatHomePage> createState() => _ClientChatHomePageState();
}

class _ClientChatHomePageState extends State<ClientChatHomePage> {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add({
      'sender': 'bot',
      'text': 'Olá! Eu sou o assistente virtual Copper. Posso ajudar com orçamento, pedido, chamado ou dúvidas sobre produtos.',
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _sendUserMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _chatController.clear();
      _isBotTyping = true;
    });

    final response = _getBotResponse(text);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _messages.add({'sender': 'bot', 'text': response});
        _isBotTyping = false;
      });
    });
  }

  String _getBotResponse(String text) {
    final message = text.toLowerCase();

    if (message.contains('horário') || message.contains('atendimento')) {
      return 'Nosso atendimento é de segunda a sexta, das 8h às 18h.';
    }
    if (message.contains('orçamento') || message.contains('preço')) {
      return 'Para orçamento, me diga o tipo de cabo e a metragem. Posso encaminhar a solicitação para a equipe de vendas.';
    }
    if (message.contains('problema') || message.contains('chamado') || message.contains('suporte')) {
      return 'Entendi. Posso ajudar na criação do seu chamado e esclarecer o processo.';
    }
    if (message.contains('produto') || message.contains('cabo') || message.contains('alumínio')) {
      return 'Tenho informações sobre nossos cabos e fios de alumínio. Qual é a sua dúvida específica?';
    }
    if (message.contains('falar com') || message.contains('alguém') || message.contains('atendente') || message.contains('humano')) {
      return 'Sou o assistente virtual Copper e posso ajudar você aqui mesmo com orçamento, pedido ou chamado.';
    }
    return 'Obrigado pela sua mensagem! Posso ajudar com orçamento, pedido ou chamado.';
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    final bubbleColor = isUser ? const Color(0xFF9C1818) : Colors.white;
    final textColor = isUser ? Colors.white : Colors.black87;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: isUser ? 16 : 14),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isUser ? 18 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.06 * 255).round()),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message['text'] ?? '',
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C1818),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        title: const Text('Chat com o assistente'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.05 * 255).round()),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inicie pelo assistente virtual',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pergunte sobre produtos, orçamento ou chamado. Nosso chat funciona apenas com o assistente virtual no momento.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).round()),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(_messages[index]);
                        },
                      ),
                    ),
                    if (_isBotTyping)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Assistente está digitando...', style: TextStyle(color: Colors.grey)),
                      ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              decoration: InputDecoration(
                                hintText: 'Digite sua pergunta...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendUserMessage(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFF9C1818),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: _sendUserMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Este chat é com o assistente virtual Copper. Pergunte sobre orçamento, pedido ou chamado.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
