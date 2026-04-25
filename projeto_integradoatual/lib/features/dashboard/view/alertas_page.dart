import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/alertas_viewmodel.dart';
import '../../../core/theme_provider.dart';
import 'dashboard_page.dart';
import 'feedbacks_page.dart' as feedbacks;
import '../../chamados/view/chamados_page.dart';

class AlertasPage extends StatefulWidget {
  const AlertasPage({super.key});

  @override
  State<AlertasPage> createState() => _AlertasPageState();
}

class _AlertasPageState extends State<AlertasPage> {
  int _currentIndex = 2; // Alertas is index 2

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AlertasViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = const Color(0xFF8C1D18);
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'COPPERFIO',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 14,
            backgroundColor: primaryColor.withOpacity(0.2),
            child: Icon(Icons.person, color: primaryColor, size: 18),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Alertas',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${vm.alertas.length} ALERTAS REQUEREM ATENÇÃO IMEDIATA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: vm.alertas.length,
              itemBuilder: (context, index) {
                final alerta = vm.alertas[index];
                
                final timeText = index == 0 ? 'HÁ 5 MINUTOS' : (index == 1 ? 'HÁ 12 MINUTOS' : 'HÁ POUCO TEMPO');
                
                IconData iconData = Icons.warning;
                if (alerta.titulo.toLowerCase().contains('conexão') || alerta.titulo.toLowerCase().contains('rede')) {
                  iconData = Icons.wifi_off;
                } else if (alerta.titulo.toLowerCase().contains('temperatura')) {
                  iconData = Icons.thermostat;
                } else if (alerta.titulo.toLowerCase().contains('energia') || alerta.titulo.toLowerCase().contains('tensão')) {
                  iconData = Icons.electrical_services;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 4,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isDark ? primaryColor.withOpacity(0.2) : const Color(0xFFF2D7D5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(iconData, color: primaryColor, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            alerta.titulo,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            alerta.descricao,
                                            style: TextStyle(
                                              color: isDark ? Colors.grey[400] : Colors.grey[700],
                                              fontSize: 13,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], height: 1),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    timeText,
                                    style: TextStyle(
                                      color: isDark ? Colors.grey[500] : Colors.grey[500],
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (vm.contatosImediatos.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Contato imediato:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: vm.contatosImediatos.map((contato) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          contato,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: isDark ? Colors.grey[600] : Colors.grey[400],
          backgroundColor: cardColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 0.5),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 0.5),
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
            } else if (index == 1) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const feedbacks.FeedbacksPage()));
            } else if (index == 3) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChamadosPage()));
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.dashboard)),
              label: 'Dashboard',
            ),
            const BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.chat_bubble_outline)),
              label: 'Feedbacks',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.notifications, color: Colors.white, size: 20),
                ),
              ),
              label: 'Alertas',
            ),
            const BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.support_agent)),
              label: 'Chamados',
            ),
          ],
        ),
      ),
    );
  }
}
