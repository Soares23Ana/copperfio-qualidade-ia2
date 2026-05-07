import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/view/login_page.dart';
import '../../chamados/view/user_chamados_page.dart';
import '../../../core/theme_provider.dart';
import '../../../services/auth_service.dart';
import 'atualizar_perfil_page.dart';
import 'historico_page.dart';
import 'notificacoes_page.dart';
import '../../home/view/add_user_page.dart';

class PerfilGestorPage extends StatelessWidget {
  const PerfilGestorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final headerColor = isDark ? Theme.of(context).colorScheme.primary : const Color(0xFF9C1818);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: headerColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Perfil Gestor', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: themeProvider.toggleTheme,
            tooltip: isDark ? 'Modo Claro' : 'Modo Noturno',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: headerColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity( 0.2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 36,
                          color: Color(0xFF9C1818),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<Map<String, dynamic>?>(
                              future: AuthService().getCurrentUserData(),
                              builder: (context, snapshot) {
                                final data = snapshot.data;
                                String userName = 'Gestor';
                                if (data != null) {
                                  userName = data['nome'] ?? userName;
                                }
                                final cargo = data?['cargo'] ?? 'Gestor Operacional';
                                final email = data?['email'] ?? '';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      cargo,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (email.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AtualizarPerfilPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconCard('Chamados', Icons.support_agent, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UserChamadosPage()),
                    );
                  }),
                  _buildIconCard('Alertas', Icons.warning, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoricoPage()),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minha Conta',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity( 0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          'Adm permissões',
                          Icons.admin_panel_settings,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddUserPage()),
                            );
                          },
                        ),
                        _buildMenuDivider(),
                        _buildMenuItem(
                          'Notificações',
                          Icons.notifications,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NotificacoesPage()),
                            );
                          },
                        ),
                        _buildMenuDivider(),
                        _buildMenuItem(
                          'Relatórios',
                          Icons.bar_chart,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HistoricoPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Color(0xFFB02820),
                  ),
                  title: Text(
                    'Sair da Conta',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Sair da Conta?'),
                        content: const Text('Deseja realmente sair?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Sair',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(String label, IconData icon, VoidCallback onTap) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFB02820),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String label, IconData icon, VoidCallback onTap) {
    return Builder(
      builder: (context) => ListTile(
        leading: Icon(icon, color: const Color(0xFFB02820), size: 24),
        title: Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.5),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildMenuDivider() {
    return Builder(
      builder: (context) => Divider(
        height: 1,
        color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.2),
        indent: 16,
        endIndent: 16,
      ),
    );
  }
}
