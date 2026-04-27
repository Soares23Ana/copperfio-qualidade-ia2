import 'package:flutter/material.dart';

class NotificacoesPage extends StatelessWidget {
  const NotificacoesPage({super.key});

  static const List<_NotificationRecord> _notifications = [
    _NotificationRecord(
      title: 'Pedido confirmado',
      subtitle: 'Seu pedido de cabos foi confirmado pelo gestor.',
      timestamp: 'Agora mesmo',
      icon: Icons.check_circle,
      status: 'Nova',
    ),
    _NotificationRecord(
      title: 'Atualização de chamado',
      subtitle: 'O status do seu chamado mudou para Em Atendimento.',
      timestamp: '1h atrás',
      icon: Icons.update,
      status: 'Importante',
    ),
    _NotificationRecord(
      title: 'Mensagem do chatbot',
      subtitle: 'O Chatbot respondeu à sua última dúvida.',
      timestamp: 'Ontem',
      icon: Icons.smart_toy,
      status: 'Chatbot',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        centerTitle: true,
        backgroundColor: const Color(0xFF9C1818),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF7F2F8),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF9C1818).withOpacity(0.15),
                child: Icon(notification.icon, color: const Color(0xFF9C1818), size: 26),
              ),
              title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(notification.subtitle, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C1818).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          notification.status,
                          style: const TextStyle(color: Color(0xFF9C1818), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(notification.timestamp, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notificação aberta: ${notification.title}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationRecord {
  final String title;
  final String subtitle;
  final String timestamp;
  final IconData icon;
  final String status;

  const _NotificationRecord({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.status,
  });
}
