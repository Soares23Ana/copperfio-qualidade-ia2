import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrado/core/theme_provider.dart';

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  static const List<_HistoricRecord> _records = [
    _HistoricRecord(
      title: 'Chatbot CopperFio',
      subtitle: 'Pergunta sobre instalação e compras',
      timestamp: 'Hoje, 09:20',
      icon: Icons.smart_toy,
      badge: 'Chatbot',
    ),
    _HistoricRecord(
      title: 'Gestor Comercial',
      subtitle: 'Discussão sobre o pedido de cabos',
      timestamp: 'Ontem, 16:43',
      icon: Icons.person_outline,
      badge: 'Gestor',
    ),
    _HistoricRecord(
      title: 'Chatbot CopperFio',
      subtitle: 'Atualização de prazo de entrega',
      timestamp: '2 dias atrás',
      icon: Icons.smart_toy,
      badge: 'Chatbot',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _records.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final record = _records[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF9C1818).withAlpha((0.12 * 255).round()),
                child: Icon(record.icon, color: const Color(0xFF9C1818), size: 28),
              ),
              title: Text(record.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(record.subtitle, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C1818).withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          record.badge,
                          style: const TextStyle(color: Color(0xFF9C1818), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(record.timestamp, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Abrir histórico: ${record.title}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _HistoricRecord {
  final String title;
  final String subtitle;
  final String timestamp;
  final IconData icon;
  final String badge;

  const _HistoricRecord({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.badge,
  });
}
