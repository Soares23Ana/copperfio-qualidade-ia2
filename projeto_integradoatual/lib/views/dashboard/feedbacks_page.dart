import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/feedbacks_viewmodel.dart';

class FeedbacksPage extends StatelessWidget {
  const FeedbacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FeedbacksViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedbacks"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar por lote ou cliente...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          // Lista de feedbacks
          Expanded(
            child: ListView.builder(
              itemCount: vm.feedbacks.length,
              itemBuilder: (context, index) {
                final fb = vm.feedbacks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(fb.cliente, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(fb.comentario),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        Text(fb.nota.toStringAsFixed(1)),
                      ],
                    ),
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
