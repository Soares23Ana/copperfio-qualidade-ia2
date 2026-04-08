import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/alertas_viewmodel.dart';

class AlertasPage extends StatelessWidget {
  const AlertasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AlertasViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alertas"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Alertas em Tempo Real",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("${vm.alertas.length} alertas requerem atenção imediata"),
            const SizedBox(height: 16),

            // Lista de alertas
            Expanded(
              child: ListView.builder(
                itemCount: vm.alertas.length,
                itemBuilder: (context, index) {
                  final alerta = vm.alertas[index];
                  return Card(
                    color: Colors.red.shade50,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Colors.red),
                      title: Text(alerta.titulo,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(alerta.descricao),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Contato imediato:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Lista de contatos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: vm.contatosImediatos.map((contato) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text("• Entre em contato com $contato"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
