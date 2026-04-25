import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodel/feedbacks_viewmodel.dart';
import '../../../core/theme_provider.dart';
import 'feedback_detail_page.dart';
import 'alertas_page.dart' as alertas;
import '../../chamados/view/chamados_page.dart';
import 'dashboard_page.dart';

class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({super.key});

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  int _currentIndex = 1; // Feedbacks is index 1

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FeedbacksViewModel>(context);
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
        title: Row(
          children: [
            Text(
              'Copperfio',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            Text(
              'Feedbacks',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: primaryColor.withOpacity(0.2),
            child: Icon(Icons.person, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5EBEB),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar feedbacks...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                _buildFilterChip('TODOS', true, primaryColor, isDark),
                const SizedBox(width: 8),
                _buildFilterChip('CRÍTICOS', false, primaryColor, isDark),
                const SizedBox(width: 8),
                _buildFilterChip('ELOGIOS', false, primaryColor, isDark),
                const SizedBox(width: 8),
                _buildFilterChip('OPERACIONAL', false, primaryColor, isDark),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: vm.feedbacksStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final feedbacks = snapshot.data?.docs ?? [];

                if (feedbacks.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum feedback encontrado',
                      style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[700]),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbacks[index];
                    final data = feedback.data() as Map<String, dynamic>;
                    
                    final userEmpresa = data['userEmpresa'] as String? ?? data['empresaId'] as String? ?? 'Desconhecido';
                    final feedbackText = data['mensagem'] as String? ?? data['descricao'] as String? ?? data['texto'] as String? ?? data['titulo'] as String? ?? 'Sem descrição fornecida.';
                    
                    DateTime? dateObj;
                    if (data['data'] is Timestamp) {
                      dateObj = (data['data'] as Timestamp).toDate();
                    } else if (data['data'] is String) {
                      dateObj = DateTime.tryParse(data['data']);
                    }
                    
                    final formattedDate = dateObj != null ? DateFormat('dd MMM yyyy • HH:mm').format(dateObj) : '';
                    
                    // Determine Type visually based on text/title heuristic
                    final titleLower = (data['titulo'] as String? ?? '').toLowerCase();
                    final textLower = feedbackText.toLowerCase();
                    Color accentColor = const Color(0xFF5DADE2); // Default Blue
                    IconData trailingIcon = Icons.local_shipping;
                    String type = 'OPERACIONAL';
                    
                    if (titleLower.contains('crítico') || titleLower.contains('urgente') || titleLower.contains('revisão') || textLower.contains('revisão') || textLower.contains('problema') || textLower.contains('atraso')) {
                      accentColor = primaryColor;
                      trailingIcon = Icons.error_outline;
                      type = 'CRÍTICO';
                    } else if (titleLower.contains('elogio') || textLower.contains('excelente') || textLower.contains('ótimo') || textLower.contains('bom')) {
                      accentColor = Colors.grey[400]!;
                      trailingIcon = Icons.sentiment_satisfied_alt;
                      type = 'ELOGIO';
                    } else if (titleLower.contains('sugestão') || textLower.contains('sugestão') || textLower.contains('melhoria')) {
                      accentColor = const Color(0xFF1ABC9C); // Teal
                      trailingIcon = Icons.settings;
                      type = 'SUGESTÃO';
                    }

                    return _buildFeedbackCard(
                      context: context,
                      companyName: userEmpresa.toUpperCase(),
                      dateString: formattedDate,
                      feedbackText: feedbackText,
                      accentColor: accentColor,
                      trailingIcon: trailingIcon,
                      cardColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFCF6F6),
                      textColor: textColor,
                      isDark: isDark,
                      primaryColor: primaryColor,
                      data: data,
                      id: feedback.id,
                      vm: vm,
                      type: type,
                    );
                  },
                );
              },
            ),
          ),
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
            } else if (index == 2) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const alertas.AlertasPage()));
            } else if (index == 3) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChamadosPage()));
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.dashboard)),
              label: 'Dashboard',
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
                  child: const Icon(Icons.chat_bubble, color: Colors.white, size: 20),
                ),
              ),
              label: 'Feedbacks',
            ),
            const BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.notifications_none)),
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

  Widget _buildFilterChip(String label, bool isSelected, Color primaryColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFD4E6F1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : const Color(0xFF34495E)),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFeedbackCard({
    required BuildContext context,
    required String companyName,
    required String dateString,
    required String feedbackText,
    required Color accentColor,
    required IconData trailingIcon,
    required Color cardColor,
    required Color textColor,
    required bool isDark,
    required Color primaryColor,
    required Map<String, dynamic> data,
    required String id,
    required FeedbacksViewModel vm,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackDetailPage(feedbackData: data),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Excluir Feedback'),
                        content: const Text('Deseja realmente excluir este feedback?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                          TextButton(
                            onPressed: () {
                              vm.deletarFeedback(id);
                              Navigator.pop(context);
                            },
                            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    companyName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: textColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateString,
                                    style: TextStyle(
                                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(trailingIcon, color: accentColor, size: 20),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '"$feedbackText"',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            color: isDark ? Colors.grey[300] : Colors.black87,
                            height: 1.4,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildTag(type, isDark ? primaryColor.withOpacity(0.2) : const Color(0xFFF2D7D5), isDark ? Colors.white : primaryColor),
                            const SizedBox(width: 8),
                            _buildTag('TÉCNICO', isDark ? Colors.grey[800]! : const Color(0xFFEAECEE), isDark ? Colors.grey[300]! : Colors.grey[700]!),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
