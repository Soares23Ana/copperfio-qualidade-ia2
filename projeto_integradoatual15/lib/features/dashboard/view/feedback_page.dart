import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/theme_provider.dart';
import '../viewmodel/feedbacks_viewmodel.dart';
import 'feedback_success_page.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _loteController = TextEditingController();
  final _moodController = TextEditingController();
  final _feedbackController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _photoFile;
  int _currentStep = 1;
  int _satisfaction = 0;
  int? _selectedMood;
  final List<String> _availableTags = [
    'No Prazo',
    'Alta Qualidade',
    'Embalagem OK',
    'Comunicação Clara',
    'Atendimento Ágil',
  ];
  final List<String> _selectedTags = [];
  final Map<String, bool?> _questionAnswers = {
    'Chegou no prazo?': null,
    'Qualidade do produto adequada?': null,
    'Comunicação clara e objetiva?': null,
  };

  @override
  void dispose() {
    _loteController.dispose();
    _moodController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _selectMood(int mood) {
    setState(() {
      _selectedMood = mood;
      if (mood == 0) {
        _moodController.text = 'Sinto que o atendimento precisa melhorar.';
      } else if (mood == 1) {
        _moodController.text = 'O atendimento foi suficiente, mas pode evoluir.';
      } else {
        _moodController.text = 'Fui bem atendido e fiquei satisfeito.';
      }
    });
  }

  double get _progress {
    int answeredFields = 0;
    if (_loteController.text.trim().isNotEmpty) answeredFields++;
    if (_satisfaction > 0) answeredFields++;
    if (_selectedMood != null) answeredFields++;
    if (_moodController.text.trim().isNotEmpty) answeredFields++;
    if (_selectedTags.isNotEmpty) answeredFields++;
    if (_feedbackController.text.trim().isNotEmpty) answeredFields++;
    answeredFields += _questionAnswers.values.where((value) => value != null).length;
    return answeredFields / 8;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (pickedImage == null) return;

      if (!mounted) return;
      setState(() {
        _photoFile = File(pickedImage.path);
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível selecionar a imagem: $error')),
      );
    }
  }

  Future<void> _showPhotoOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _goToNextStep() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_currentStep == 1) {
      if (_satisfaction == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione sua satisfação geral.')),
        );
        return;
      }
      setState(() => _currentStep = 2);
    }
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha uma opção de atendimento.')),
      );
      return;
    }
    if (_moodController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conte-nos mais sobre o atendimento.')),
      );
      return;
    }
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva seu feedback por favor.')),
      );
      return;
    }
    if (_questionAnswers.values.any((value) => value == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Responda todas as perguntas da etapa 2.')),
      );
      return;
    }

    final vm = Provider.of<FeedbacksViewModel>(context, listen: false);
    final atendimentoMood =
        _selectedMood == 0 ? 'Triste' : _selectedMood == 1 ? 'Neutro' : 'Feliz';
    final listaPerguntas = _questionAnswers.entries
        .map((entry) => '${entry.key} ${entry.value! ? 'Sim' : 'Não'}')
        .join('\n');
    final mensagem = [
      'Avaliação da Copperfio: $_satisfaction estrelas',
      'Atendimento: $atendimentoMood',
      'Detalhes do atendimento: ${_moodController.text.trim()}',
      'Feedback escrito: ${_feedbackController.text.trim()}',
      if (_selectedTags.isNotEmpty) 'Tags: ${_selectedTags.join(', ')}',
      listaPerguntas,
    ].join('\n');
    final lote = _loteController.text.trim();
    final itemScores = List<int>.filled(8, _satisfaction);

    try {
      await vm.enviarFeedback(
        mensagem: mensagem,
        lote: lote,
        itemScores: itemScores,
        generalRating: _satisfaction,
        atendimentoMood: atendimentoMood,
        tags: _selectedTags,
        photoFile: _photoFile,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback enviado com sucesso!')),
      );

      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FeedbackSuccessPage()),
        );
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar feedback: $error')),
      );
    }
  }

  Widget _buildHeader(String title, String subtitle, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.cable, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  color: const Color(0xFFF9A825),
                  backgroundColor: const Color(0xFFFFE0B2),
                ),
              ),
            ),
            if (progress == 1.0) ...[
              const SizedBox(width: 12),
              const Text(
                '100%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final value = index + 1;
        return IconButton(
          padding: EdgeInsets.zero,
          iconSize: 38,
          icon: Icon(
            value <= _satisfaction ? Icons.star : Icons.star_border,
            color: value <= _satisfaction ? const Color(0xFFDD7632) : Colors.black26,
          ),
          onPressed: () {
            setState(() => _satisfaction = value);
          },
        );
      }),
    );
  }

  Widget _buildMoodButton(int mood, String label, IconData icon, Color color) {
    final bool selected = _selectedMood == mood;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectMood(mood),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? color.withAlpha(46) : Colors.white,
            border: Border.all(
              color: selected ? color : const Color(0xFFE0DED9),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: selected ? color : Colors.black38),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? color : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    final selected = _selectedTags.contains(tag);
    return ChoiceChip(
      label: Text(tag),
      selected: selected,
      selectedColor: const Color(0xFF9C1818),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
      ),
      backgroundColor: const Color(0xFFF3F1F6),
      onSelected: (_) => _toggleTag(tag),
    );
  }

  Widget _buildQuestionRow(String question) {
    final selected = _questionAnswers[question];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _questionAnswers[question] = true);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selected == true ? const Color(0xFF9C1818) : null,
                    foregroundColor: selected == true ? Colors.white : null,
                    side: const BorderSide(color: Color(0xFF9C1818)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Sim'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _questionAnswers[question] = false);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selected == false ? const Color(0xFF9C1818) : null,
                    foregroundColor: selected == false ? Colors.white : null,
                    side: const BorderSide(color: Color(0xFF9C1818)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Não'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;
        final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF7F3F1);
        final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;
        final fieldBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF7F3F1);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFF9C1818),
            centerTitle: true,
            title: const Text('Feedback Copperfio'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: isDark ? 'Modo Claro' : 'Modo Noturno',
                onPressed: themeProvider.toggleTheme,
              ),
            ],
          ),
          body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFD54F),
                        Color(0xFFFFB300),
                        Color(0xFFEF6C00),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.18 * 255).round()),
                        blurRadius: 18,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Copperfio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Identificação e início',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 18),
                      _buildHeader(
                        'Etapa 1: Início do lote',
                        'Insira o código e faça sua avaliação da Copperfio.',
                        _progress,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                if (_currentStep == 1) ...[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: isDark ? Colors.grey[800]! : const Color(0xFFE9E5E2)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Identificação do Lote',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _loteController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldBg,
                              hintText: 'Digite o código',
                              suffixIcon: const Icon(Icons.qr_code),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Informe o código do lote';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Qual sua satisfação com a Copperfio?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildStars(),
                          const SizedBox(height: 8),
                          Text(
                            _satisfaction == 0
                                ? 'Avalie a experiência da empresa.'
                                : 'Sua avaliação da Copperfio: $_satisfaction estrelas',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textColor.withOpacity(0.75)),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _goToNextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9C1818),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'PRÓXIMA ETAPA',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: isDark ? Colors.grey[800]! : const Color(0xFFE9E5E2)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Aprofundamento do Lote',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildHeader(
                            'Etapa 2: Atendimento e logística',
                            'Conte-nos como foi o suporte e a entrega deste lote.',
                            _progress,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Atendimento',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildMoodButton(
                                0,
                                'Triste',
                                Icons.sentiment_very_dissatisfied,
                                const Color(0xFFD04F3E),
                              ),
                              const SizedBox(width: 10),
                              _buildMoodButton(
                                1,
                                'Neutro',
                                Icons.sentiment_neutral,
                                const Color(0xFF9C753E),
                              ),
                              const SizedBox(width: 10),
                              _buildMoodButton(
                                2,
                                'Feliz',
                                Icons.sentiment_satisfied_alt,
                                const Color(0xFF30864A),
                              ),
                            ],
                          ),
                          if (_selectedMood != null) ...[
                            const SizedBox(height: 18),
                            const Text(
                              'Conte-nos mais...',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _moodController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: fieldBg,
                                hintText: 'Descreva o que aconteceu...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (_selectedMood != null &&
                                    (value == null || value.trim().isEmpty)) {
                                  return 'Compartilhe mais detalhes do atendimento';
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 20),
                          const Text(
                            'Perguntas importantes',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildQuestionRow('Chegou no prazo?'),
                          _buildQuestionRow('Qualidade do produto adequada?'),
                          _buildQuestionRow('Comunicação clara e objetiva?'),
                          const SizedBox(height: 20),
                          const Text(
                            'Produto e Logística',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _availableTags.map(_buildTagChip).toList(),
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'Seu feedback escrito',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _feedbackController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldBg,
                              hintText: 'Conte o que aconteceu e o que podemos melhorar...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Escreva seu feedback.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'Foto do produto (opcional)',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (_photoFile != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.file(
                                _photoFile!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _showPhotoOptions,
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Adicionar foto'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF9C1818),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _submitFeedback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9C1818),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'ENVIAR FEEDBACK',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  },
);
  }
}