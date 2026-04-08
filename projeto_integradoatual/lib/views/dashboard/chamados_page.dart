import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chamados_viewmodel.dart';

class ChamadosPage extends StatelessWidget {
  const ChamadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChamadosViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chamados"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar chamado...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          // Lista de chamados
          Expanded(
            child: ListView.builder(
              itemCount: vm.chamados.length,
              itemBuilder: (context, index) {
                final chamado = vm.chamados[index];
                return Card(
                  color: chamado.cor,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(chamado.titulo,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(chamado.descricao),
                    trailing: Text(chamado.codigo,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

