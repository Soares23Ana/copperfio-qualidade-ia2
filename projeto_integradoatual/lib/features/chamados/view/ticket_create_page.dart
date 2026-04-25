import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrado/features/chamados/viewmodel/chamados_viewmodel.dart';

class TicketCreatePage extends StatefulWidget {
  const TicketCreatePage({super.key});

  @override
  State<TicketCreatePage> createState() => _TicketCreatePageState();
}

class _TicketCreatePageState extends State<TicketCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedPriority = 'media';
  String? _selectedCategory;
  final List<String> _priorities = ['baixa', 'media', 'alta'];
  final List<String> _categories = ['Técnico', 'Administrativo', 'Financeiro', 'Outros'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _sendTicket() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final viewModel = Provider.of<ChamadosViewModel>(context, listen: false);
        await viewModel.criarChamado(
          titulo: _titleController.text,
          descricao: _descriptionController.text,
          prioridade: _selectedPriority ?? 'media',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chamado criado com sucesso!')),
          );
          Navigator.maybePop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao criar chamado: $e')),
          );
        }
      }
    }
  }

  void _cancel() {
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildFormCard(context),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _sendTicket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9C1818),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Enviar Chamado',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _cancel,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF9C1818)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9C1818),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF9C1818),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.maybePop(context),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Novo Chamado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 110,
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF9C1818)),
            child: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 160,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        bottomLeft: Radius.circular(80),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Central de Chamados',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Descreva seu problema ou solicitação',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Título do Chamado'),
              const SizedBox(height: 8),
              _buildInputField(
                controller: _titleController,
                hintText: 'Digite um título breve',
                suffixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Categoria'),
              const SizedBox(height: 8),
              _buildDropdownField(),
              const SizedBox(height: 20),
              _buildFieldLabel('Prioridade'),
              const SizedBox(height: 8),
              _buildPriorityField(),
              const SizedBox(height: 20),
              _buildFieldLabel('Descrição'),
              const SizedBox(height: 8),
              _buildDescriptionField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF7F7F9),
        suffixIcon: Icon(suffixIcon, color: const Color(0xFF9C1818)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: const InputDecoration(
          hintText: 'Selecione a categoria',
          border: InputBorder.none,
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9C1818)),
        items: _categories
            .map(
              (category) =>
                  DropdownMenuItem(value: category, child: Text(category)),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Selecione a categoria';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPriorityField() {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      items: _priorities.map((priority) {
        return DropdownMenuItem(
          value: priority,
          child: Text(priority.replaceFirst(priority[0], priority[0].toUpperCase())),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPriority = value;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Descreva o ocorrido';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Descreva em detalhes o ocorrido',
        filled: true,
        fillColor: const Color(0xFFF7F7F9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}