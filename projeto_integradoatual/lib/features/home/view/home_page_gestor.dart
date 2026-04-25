import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../../core/theme_provider.dart';
import '../../dashboard/view/dashboard_page.dart';
import '../../dashboard/view/feedbacks_page.dart';
import '../../dashboard/view/alertas_page.dart';
import '../../chamados/view/chamados_page.dart';
import '../../chat/view/conversations_list_page.dart';
import '../../auth/view/login_page.dart';
import 'add_user_page.dart';

class HomePageGestor extends StatefulWidget {
  const HomePageGestor({super.key});

  @override
  State<HomePageGestor> createState() => _HomePageGestorState();
}

class _HomePageGestorState extends State<HomePageGestor> {
  int _currentIndex = 0;

  Future<String> _getGestorName() async {
    final authService = AuthService();
    final userData = await authService.getCurrentUserData();
    final nome = userData?['nome'] as String?;
    if (nome != null && nome.trim().isNotEmpty) {
      // Retorna apenas o primeiro nome para ficar igual ao design
      return nome.split(' ')[0];
    }
    return 'Gestor';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;
        final primaryColor = const Color(0xFF8C1D18);
        final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
        final textColor = isDark ? Colors.white : Colors.black87;
        final gridCardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFBEAEA);
        final whiteCardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.factory, color: primaryColor, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              'GESTOR',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                              onPressed: themeProvider.toggleTheme,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                  (route) => false,
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: primaryColor.withOpacity(0.2),
                              child: Icon(Icons.person, color: primaryColor, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Header Area
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SISTEMA OPERACIONAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<String>(
                      future: _getGestorName(),
                      builder: (context, snapshot) {
                        final gestorName = snapshot.data ?? 'Gestor';
                        return Text(
                          'Bem-vindo(a),\n$gestorName',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Big Stats Card
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(isDark ? 0.2 : 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(
                              Icons.precision_manufacturing,
                              size: 120,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EFICIÊNCIA DE PRODUÇÃO',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  const Text(
                                    '98.4',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '%',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Icon(Icons.trending_up, color: Colors.white, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+2.1% desde o último turno',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Grid Options
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.4,
                      children: [
                        _buildGridCard(
                          context,
                          title: 'DASHBOARD',
                          subtitle: 'Métricas em tempo real',
                          icon: Icons.dashboard,
                          page: const DashboardPage(),
                          cardColor: gridCardColor,
                          textColor: textColor,
                          primaryColor: primaryColor,
                        ),
                        _buildGridCard(
                          context,
                          title: 'FEEDBACKS',
                          subtitle: '8 novos relatos',
                          icon: Icons.feedback,
                          page: const FeedbacksPage(),
                          cardColor: gridCardColor,
                          textColor: textColor,
                          primaryColor: primaryColor,
                        ),
                        _buildGridCard(
                          context,
                          title: 'ALERTAS',
                          subtitle: '2 Manutenções',
                          icon: Icons.warning,
                          page: const AlertasPage(),
                          cardColor: gridCardColor,
                          textColor: textColor,
                          primaryColor: primaryColor,
                        ),
                        _buildGridCard(
                          context,
                          title: 'CHAMADOS',
                          subtitle: 'Setor Operacional',
                          icon: Icons.support_agent,
                          page: const ChamadosPage(),
                          cardColor: gridCardColor,
                          textColor: textColor,
                          primaryColor: primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Add Gestor Button
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AddUserPage()));
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: whiteCardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD), // Light blue
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person_add, color: Color(0xFF1976D2), size: 24),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'ADICIONAR GESTOR',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.5,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.chevron_right, color: isDark ? Colors.grey[400] : Colors.grey[400]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ConversationsListPage()));
            },
            backgroundColor: primaryColor,
            child: const Icon(Icons.chat, color: Colors.white),
            tooltip: 'Chat',
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
              backgroundColor: whiteCardColor,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5),
              elevation: 0,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                // Implementar navegação futura se necessário
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.dashboard)),
                  label: 'STATUS',
                ),
                BottomNavigationBarItem(
                  icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.precision_manufacturing)),
                  label: 'ATIVOS',
                ),
                BottomNavigationBarItem(
                  icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.bolt)),
                  label: 'AÇÕES',
                ),
                BottomNavigationBarItem(
                  icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.group)),
                  label: 'EQUIPE',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget page,
    required Color cardColor,
    required Color textColor,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor, size: 28),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.5,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
