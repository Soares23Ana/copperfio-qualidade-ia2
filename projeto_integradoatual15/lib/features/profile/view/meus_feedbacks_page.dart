import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme_provider.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/feedback_model.dart';

class MeusFeedbacksPage extends StatefulWidget {
  const MeusFeedbacksPage({super.key});

  @override
  State<MeusFeedbacksPage> createState() => _MeusFeedbacksPageState();
}

class _MeusFeedbacksPageState extends State<MeusFeedbacksPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Todos';
  String _currentUserId = '';
  final AuthService _authService = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final userId = _authService.currentUserId;
    setState(() {
      _currentUserId = userId ?? '';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FeedbackModel> _filterFeedbacks(List<FeedbackModel> feedbacks) {
    var filtered = feedbacks.where((feedback) {
      final matchesSearch = feedback.mensagem
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          feedback.lote.toLowerCase().contains(_searchController.text.toLowerCase());

      final effectiveStatus = _getEffectiveStatus(feedback);
      final matchesStatus =
          _selectedStatus == 'Todos' || effectiveStatus == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    // Ordenar por data descendente
    filtered.sort((a, b) => b.data.compareTo(a.data));
    return filtered;
  }

  bool _isNewFeedback(FeedbackModel feedback) {
    final difference = DateTime.now().difference(feedback.data);
    return feedback.status.toLowerCase() == 'novo' && difference.inDays < 3;
  }

  String _getEffectiveStatus(FeedbackModel feedback) {
    if (feedback.status.toLowerCase() == 'novo' && !_isNewFeedback(feedback)) {
      return 'pendente';
    }
    return feedback.status.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFF8C1D18),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Meus Feedbacks',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip:
                themeProvider.isDarkMode ? 'Modo Claro' : 'Modo Noturno',
          ),
        ],
      ),
      body: _currentUserId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Campo de pesquisa
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Pesquisar feedback...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filtro de status
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Todos'),
                          const SizedBox(width: 8),
                          _buildFilterChip('novo'),
                          const SizedBox(width: 8),
                          _buildFilterChip('em análise'),
                          const SizedBox(width: 8),
                          _buildFilterChip('respondido'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Lista de feedbacks
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _db
                        .collection('feedbacks')
                        .where('userId', isEqualTo: _currentUserId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'Erro ao carregar seus feedbacks: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final feedbacks = snapshot.data?.docs
                              .map((doc) => FeedbackModel.fromFirestore(doc))
                              .toList() ??
                          [];

                      final filteredFeedbacks = _filterFeedbacks(feedbacks);

                      if (filteredFeedbacks.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.feedback_outlined,
                                  size: 64,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity( 0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Nenhum feedback encontrado',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity( 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredFeedbacks.length,
                          itemBuilder: (context, index) {
                            return _buildFeedbackCard(
                              filteredFeedbacks[index],
                              context,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterChip(String status) {
    return FilterChip(
      label: Text(status.capitalizeFirst),
      selected: _selectedStatus == status,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = status;
        });
      },
      backgroundColor:
          Theme.of(context).colorScheme.surface.withOpacity( 0.5),
      selectedColor: const Color(0xFF8C1D18),
      labelStyle: TextStyle(
        color: _selectedStatus == status
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackModel feedback, BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDate = dateFormat.format(feedback.data);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showFeedbackDetails(feedback, context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(_getEffectiveStatus(feedback))
                                  .withOpacity( 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getEffectiveStatus(feedback).capitalizeFirst,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(_getEffectiveStatus(feedback)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (feedback.lote.isNotEmpty)
                            Expanded(
                              child: Text(
                                'Lote: ${feedback.lote}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity( 0.7),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (feedback.isRead)
                      Icon(
                        Icons.done_all,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Mensagem
                Text(
                  feedback.mensagem,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Footer com data
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity( 0.6),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity( 0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeedbackDetails(FeedbackModel feedback, BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDate = dateFormat.format(feedback.data);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity( 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Detalhes do Feedback',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow('Status', _getEffectiveStatus(feedback).capitalizeFirst,
                      context, _getEffectiveStatus(feedback)),
                  const SizedBox(height: 12),
                  _buildDetailRow('Data', formattedDate, context),
                  if (feedback.lote.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow('Lote', feedback.lote, context),
                  ],
                  const SizedBox(height: 12),
                  _buildDetailRow('E-mail', feedback.userEmail, context),
                  const SizedBox(height: 12),
                  _buildDetailRow('Empresa', feedback.userEmpresa, context),
                  const SizedBox(height: 20),
                  Text(
                    'Mensagem',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      feedback.mensagem,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Fechar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context,
      [String? status]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity( 0.7),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              if (status != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity( 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ] else
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'novo':
      case 'pendente':
        return Colors.orange;
      case 'em análise':
        return Colors.blue;
      case 'respondido':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}


extension StringExtension on String {
  String get capitalizeFirst =>
      this[0].toUpperCase() + substring(1).toLowerCase();
}
