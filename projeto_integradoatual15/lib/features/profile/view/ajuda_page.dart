import 'package:flutter/material.dart';

class AjudaPage extends StatelessWidget {
  const AjudaPage({super.key});

  static const List<_AjudaTopic> _topics = [
    _AjudaTopic(
      title: 'Como fazer um pedido',
      description:
          'Para fazer um pedido, navegue pelo catálogo, escolha o produto desejado e siga o botão de fazer pedido na parte inferior da página.',
      icon: Icons.shopping_cart,
    ),
    _AjudaTopic(
      title: 'Como enviar um feedback',
      description:
          'Vá para a área de Feedbacks no seu perfil, clique em "Enviar Feedback" e preencha sua mensagem. O gestor receberá automaticamente.',
      icon: Icons.comment,
    ),
    _AjudaTopic(
      title: 'Como ver as medidas dos fios',
      description:
          'Abra a ficha técnica de cada produto para encontrar descrição e especificações técnicas completas, incluindo medidas e materiais.',
      icon: Icons.straighten,
    ),
    _AjudaTopic(
      title: 'Como salvar um produto',
      description:
          'Toque no ícone de coração nos produtos do catálogo para salvar o item. Depois acesse "Itens Salvos" no seu perfil.',
      icon: Icons.favorite,
    ),
    _AjudaTopic(
      title: 'Como baixar a ficha técnica',
      description:
          'Na página do produto, use o botão de download para salvar o PDF no seu celular. Você poderá abrir o arquivo pela pasta de downloads.',
      icon: Icons.picture_as_pdf,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF9C1818).withOpacity(0.12),
                child: Icon(topic.icon, color: const Color(0xFF9C1818)),
              ),
              title: Text(
                topic.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  topic.description,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: _topics.length,
      ),
    );
  }
}

class _AjudaTopic {
  final String title;
  final String description;
  final IconData icon;

  const _AjudaTopic({
    required this.title,
    required this.description,
    required this.icon,
  });
}
                
