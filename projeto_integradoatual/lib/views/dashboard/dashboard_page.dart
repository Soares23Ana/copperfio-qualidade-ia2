import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard do Gestor"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(title: "Feedbacks (7 dias)", value: vm.feedbacks.toString()),
                _StatCard(title: "Nível de satisfação", value: vm.satisfacao.toString()),
                _StatCard(title: "Alertas ativos", value: vm.alertas.toString()),
              ],
            ),
            const SizedBox(height: 20),

            Card(
              color: Colors.red.shade100,
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: const Text("Alerta Crítico: Queda na Satisfação"),
                subtitle: Text(
                  "Detectada queda de ${vm.satisfacao}% na satisfação nos últimos 7 dias.",
                ),
              ),
            ),
            const SizedBox(height: 20),

            _BarChartWidget(data: vm.problemasPorLote, title: "Problemas por Lote"),
            _PieChartWidget(data: vm.distribuicaoSentimento, title: "Distribuição de Sentimento"),
            _LineChartWidget(title: "Evolução da Satisfação"),
            _BarChartWidget(data: vm.regioes, title: "Região A – Região B"),
            _PieChartWidget(data: vm.valorPorProduto, title: "Valor por Produto"),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _BarChartWidget extends StatelessWidget {
  final Map<String, num> data;
  final String title;

  const _BarChartWidget({required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Expanded(
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(show: true),
                  barGroups: data.entries.map((e) {
                    return BarChartGroupData(
                      x: data.keys.toList().indexOf(e.key),
                      barRods: [BarChartRodData(toY: e.value.toDouble(), color: Colors.red)],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PieChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final String title;

  const _PieChartWidget({required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: data.entries.map((e) {
                    return PieChartSectionData(
                      value: e.value,
                      title: "${e.key} ${e.value}%",
                      color: Colors.primaries[data.keys.toList().indexOf(e.key) % Colors.primaries.length],
                      radius: 50,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChartWidget extends StatelessWidget {
  final String title;

  const _LineChartWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 50),
                        const FlSpot(1, 60),
                        const FlSpot(2, 40),
                        const FlSpot(3, 75),
                      ],
                      isCurved: true,
                      color: Colors.red,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
