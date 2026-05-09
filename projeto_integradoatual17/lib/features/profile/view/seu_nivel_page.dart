import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrado/core/theme_provider.dart';

class SeuNivelPage extends StatefulWidget {
  const SeuNivelPage({super.key});

  @override
  State<SeuNivelPage> createState() => _SeuNivelPageState();
}

class _SeuNivelPageState extends State<SeuNivelPage> {
  final String _currentLevel = 'Bronze';
  final String _nextLevel = 'Prata';
  final double _progress = 0.12;

  Color _levelColor() {
    switch (_currentLevel.toLowerCase()) {
      case 'bronze':
        return const Color(0xFF9A4A16);
      case 'prata':
        return const Color(0xFF828282);
      case 'ouro':
        return const Color(0xFFCC8A12);
      case 'diamante':
        return const Color(0xFF9EA3A8);
      default:
        return const Color(0xFF9C1818);
    }
  }

  LinearGradient _levelGradient() {
    switch (_currentLevel.toLowerCase()) {
      case 'bronze':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4F2509),
            Color(0xFF8A4515),
            Color(0xFFB26B31),
            Color(0xFFD59E70),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        );
      case 'prata':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6F6F6F),
            Color(0xFF9B9B9B),
            Color(0xFFC3C3C3),
            Color(0xFFE2E2E2),
          ],
          stops: [0.0, 0.28, 0.62, 1.0],
        );
      case 'ouro':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9A6B08),
            Color(0xFFD1911E),
            Color(0xFFE7BA46),
            Color(0xFFF7D47E),
          ],
          stops: [0.0, 0.28, 0.58, 1.0],
        );
      case 'diamante':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD1D4D7),
            Color(0xFFE3E4E6),
            Color(0xFFF2F2F1),
            Color(0xFFBFC3C9),
          ],
          stops: [0.0, 0.28, 0.7, 1.0],
        );
      default:
        return LinearGradient(
          colors: [_levelColor(), _levelColor().withAlpha(166)],
        );
    }
  }

  Color _levelTextColor() {
    return _currentLevel.toLowerCase() == 'diamante'
        ? Colors.black87
        : Colors.white;
  }

  Color _borderColor() {
    return _currentLevel.toLowerCase() == 'diamante'
        ? const Color(0xFF9EA3A8).withAlpha(243)
        : _levelColor().withAlpha(243);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Nível'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: _levelGradient(),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _borderColor(), width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 64 : 46),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nível Corporativo',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: _levelTextColor(),
                      letterSpacing: 0.4,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(41),
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: _levelGradient(),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _levelColor().withAlpha(179),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(64),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _currentLevel,
                      style: TextStyle(
                        color: _levelTextColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Progresso para o próximo nível',
                    style: TextStyle(
                      fontSize: 14,
                      color: _levelTextColor().withAlpha(243),
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(38),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(46),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      _levelColor().withAlpha(235),
                                      _levelColor().withAlpha(199),
                                      _levelColor().withAlpha(173),
                                    ],
                                    stops: const [0.0, 0.45, 1.0],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _levelColor().withAlpha(102),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(_progress * 100).round()}% para $_nextLevel',
                    style: TextStyle(
                      fontSize: 13,
                      color: _levelTextColor().withAlpha(243),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(46),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Progresso atualiza continuamente; sobe ou desce devagar conforme seu uso.',
                    style: TextStyle(
                      fontSize: 12,
                      color: _levelTextColor().withAlpha(217),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Benefícios do nível $_currentLevel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
                shadows: [
                  Shadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white24
                        : Colors.black12,
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildBenefitTile('Descontos exclusivos em cabos'),
            _buildBenefitTile('Atendimento prioritário do gestor'),
            _buildBenefitTile('Acesso antecipado a novas ofertas'),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C1818),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _showLevelUpTips,
              child: const Text(
                'Como subir de nível',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLevelUpTips() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 48,
                height: 6,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Text(
                'Como subir de nível',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'O progresso se constrói ao longo do uso constante. Pedidos, orçamentos e respostas ajudam você a avançar, mas o nível também pode cair devagar se o uso diminuir.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(230),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'O nível é ajustado continuamente: sobe ou desce devagar conforme o seu uso e engajamento.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(191),
                ),
              ),
              const SizedBox(height: 18),
              _buildTipTile(
                context,
                'Faça pedidos ou orçamentos com frequência para manter o hábito ativo.',
              ),
              _buildTipTile(
                context,
                'Responda aos feedbacks do gestor para mostrar engajamento.',
              ),
              _buildTipTile(
                context,
                'Use o app regularmente; o nível pode cair se você usar com menos frequência.',
              ),
              const SizedBox(height: 18),
              Text(
                'Dica: um bom nível é resultado de uso consistente ao longo de semanas, não de ações isoladas.',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(191),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C1818),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Entendi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipTile(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.fiber_manual_record,
              size: 8,
              color: _levelColor(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: _levelColor(), size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
