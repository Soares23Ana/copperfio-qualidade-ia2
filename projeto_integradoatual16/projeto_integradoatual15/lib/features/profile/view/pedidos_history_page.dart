import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrado/core/theme_provider.dart';
import 'package:projeto_integrado/features/profile/model/pedido_record.dart';
import 'package:projeto_integrado/features/profile/view/pedido_detail_page.dart';

class PedidosHistoryPage extends StatelessWidget {
  const PedidosHistoryPage({super.key});

  static const List<PedidoRecord> _orders = [
    PedidoRecord(
      id: '2026-001',
      date: '12/04/2026',
      status: 'Em andamento',
      summary: '1 rolo de cabo de fibra óptica 50m',
      items: ['Cabo de fibra óptica 50m'],
      total: 'R\$ 1.160,00',
      details:
          'Pedido em processamento. Entrega prevista em 3 dias úteis. Status atual: aguardando separação.',
      notes:
          'Cliente solicita envio para São Paulo. Código do projeto: ALM-738.',
    ),
    PedidoRecord(
      id: '2026-012',
      date: '28/03/2026',
      status: 'Concluído',
      summary: '2 cabos de cobre 100m e 3 conectores RJ45',
      items: ['Cabo de cobre 100m', 'Conector RJ45 x3'],
      total: 'R\$ 980,00',
      details:
          'Pedido entregue com sucesso. Nota fiscal gerada e arquivo enviado por e-mail. Avaliação pendente.',
      notes: 'Entregue no endereço informado. Cliente aprovou a instalação.',
    ),
    PedidoRecord(
      id: '2026-018',
      date: '14/03/2026',
      status: 'Cancelado',
      summary: 'Orçamento de 5 cabos de energia',
      items: ['Cabo de energia 5m'],
      total: 'R\$ 350,00',
      details:
          'Pedido cancelado pelo cliente antes da confirmação. Se desejar, faça um novo pedido a partir do catálogo.',
      notes: 'Cliente aguardando retorno do gestor antes de confirmar.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _orders.isEmpty
          ? Center(
              child: Text(
                'Nenhum pedido encontrado.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              separatorBuilder: (context, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pedido ${order.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(order.summary),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: order.status == 'Concluído'
                                    ? const Color(0xFFE3F7E8)
                                    : order.status == 'Cancelado'
                                    ? const Color(0xFFFDEAEA)
                                    : const Color(0xFFEEF3FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: order.status == 'Concluído'
                                      ? const Color(0xFF1B7F35)
                                      : order.status == 'Cancelado'
                                      ? const Color(0xFFB00020)
                                      : const Color(0xFF1A3F9B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              order.date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              order.total,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: order.items
                              .map(
                                (item) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withAlpha(38),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PedidoDetailPage(pedido: order),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'VER PEDIDO',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
