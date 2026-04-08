import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chat_viewmodel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assistência - Portal de Chamados"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.mensagens.length,
              itemBuilder: (context, index) {
                final msg = vm.mensagens[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.green.shade200 : Colors.pink.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.texto),
                  ),
                );
              },
            ),
          ),

          // Campo de digitação + botões
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Digitar...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // ação de tirar foto
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Tirar foto"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // ação de gravar vídeo
                  },
                  icon: const Icon(Icons.videocam),
                  label: const Text("Gravar vídeo"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          if (_controller.text.isNotEmpty) {
            vm.enviarMensagem(_controller.text);
            _controller.clear();
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
