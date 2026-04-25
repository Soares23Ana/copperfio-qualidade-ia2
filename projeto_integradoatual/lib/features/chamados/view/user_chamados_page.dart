import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrado/data/models/chamado_model.dart';
import '../viewmodel/chamados_viewmodel.dart';

class UserChamadosPage extends StatelessWidget {
  const UserChamadosPage({super.key});

  Color _getPriorityColor(String prioridade) {
    switch (prioridade.toLowerCase()) {
      case 'alta':
        return Colors.red.shade100;
      case 'media':
        return Colors.yellow.shade100;
      case 'baixa':
        return Colors.green.shade100;
      default:
        return Colors.blue.shade100;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aberto':
        return Colors.blue;
      case 'em_atendimento':
        return Colors.orange;
      case 'resolvido':
        return Colors.green;
      case 'fechado':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChamadosViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F1F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C1818),
        title: const Text('Meus Chamados'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar chamado...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ChamadoModel>>(
                stream: vm.obterChamadosDoUsuario(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Erro ao carregar chamados: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final chamados = snapshot.data ?? [];

                  if (chamados.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'Você ainda não criou nenhum chamado.\nClique no botão para criar um novo.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: chamados.length,
                    itemBuilder: (context, index) {
                      final chamado = chamados[index];
                      final priorityColor =
                          _getPriorityColor(chamado.prioridade);
                      final statusColor = _getStatusColor(chamado.status);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: priorityColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: statusColor,
                              width: 3,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chamado.titulo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Empresa: ${chamado.empresaNome}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                chamado.descricao,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    chamado.status
                                        .replaceAll('_', ' ')
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9C1818),
        onPressed: () {
          Navigator.pop(context);
          // The home page should handle navigation to create new ticket
        },
        tooltip: 'Novo Chamado',
        child: const Icon(Icons.add),
      ),
    );
  }
}
