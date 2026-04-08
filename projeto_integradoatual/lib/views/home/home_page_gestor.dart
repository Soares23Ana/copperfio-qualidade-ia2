import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';
import '../dashboard/feedbacks_page.dart';
import '../dashboard/alertas_page.dart';
import '../dashboard/chamados_page.dart';
import '../chat/chat_page.dart';

class HomePageGestor extends StatelessWidget {
  const HomePageGestor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9C1818),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDD4E41),
        title: Image.asset(
          'assets/images/copperfio_logo.png',
          width: 130,
          height: 45,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Text(
            'Copperfio',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Bem-vindo, Gestor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use os botões abaixo para acessar o dashboard e as áreas administrativas.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              _buildNavigationButton(
                context,
                label: 'Dashboard',
                icon: Icons.dashboard,
                page: const DashboardPage(),
              ),
              _buildNavigationButton(
                context,
                label: 'Feedbacks',
                icon: Icons.feedback,
                page: const FeedbacksPage(),
              ),
              _buildNavigationButton(
                context,
                label: 'Alertas',
                icon: Icons.warning,
                page: const AlertasPage(),
              ),
              _buildNavigationButton(
                context,
                label: 'Chamados',
                icon: Icons.support_agent,
                page: const ChamadosPage(),
              ),
              _buildNavigationButton(
                context,
                label: 'Chat',
                icon: Icons.chat,
                page: const ChatPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF9C1818),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
