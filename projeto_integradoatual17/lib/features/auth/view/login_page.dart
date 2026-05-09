import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme_provider.dart';
import '../viewmodel/login_viewmodel.dart';
import '../../home/view/home_page_gestor.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import '../../home/view/home_page_usuario.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _viewModel = LoginViewModel();
  bool _obscurePassword = true;
  List<String> _emailSuggestions = [];
  Map<String, int> _emailUsageCounts = {};
  List<String> _filteredEmailSuggestions = [];

  @override
  void initState() {
    super.initState();
    _loadEmailSuggestions();
  }

  Future<void> _loadEmailSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    final suggestions = prefs.getStringList('email_suggestions') ?? [];
    final countsJson = prefs.getString('email_usage_counts') ?? '{}';
    Map<String, dynamic> countsMap = {};

    try {
      final decoded = jsonDecode(countsJson);
      if (decoded is Map<String, dynamic>) {
        countsMap = decoded;
      }
    } catch (_) {
      countsMap = {};
    }

    if (!mounted) return;
    setState(() {
      _emailSuggestions = suggestions;
      _emailUsageCounts = countsMap.map(
        (key, value) => MapEntry(key, value is int ? value : int.tryParse(value.toString()) ?? 0),
      );
    });
    _updateFilteredSuggestions(_emailController.text);
  }

  Future<void> _saveEmailSuggestion(String email) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty) return;

    if (!_emailSuggestions.contains(normalizedEmail)) {
      _emailSuggestions.add(normalizedEmail);
    }

    _emailUsageCounts[normalizedEmail] = (_emailUsageCounts[normalizedEmail] ?? 0) + 1;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('email_suggestions', _emailSuggestions);
      await prefs.setString('email_usage_counts', jsonEncode(_emailUsageCounts));
    } catch (e) {
      debugPrint('Erro ao salvar sugestões de email: $e');
    }

    if (!mounted) return;
    setState(() {});
    _updateFilteredSuggestions(normalizedEmail);
  }

  List<String> _getSortedSuggestions() {
    final suggestions = [..._emailSuggestions];
    suggestions.sort((a, b) {
      final countA = _emailUsageCounts[a] ?? 0;
      final countB = _emailUsageCounts[b] ?? 0;
      if (countB != countA) {
        return countB.compareTo(countA);
      }
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return suggestions;
  }

  void _updateFilteredSuggestions(String prefix) {
    final query = prefix.trim().toLowerCase();
    final sorted = _getSortedSuggestions();
    setState(() {
      _filteredEmailSuggestions = sorted
          .where((email) => query.isEmpty || email.toLowerCase().startsWith(query))
          .toList();
    });
  }

  void _selectEmailSuggestion(String email) {
    _emailController.text = email;
    _emailController.selection = TextSelection.collapsed(offset: email.length);
    _updateFilteredSuggestions(email);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final scaffoldColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFF9C1818);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = const Color(0xFF9C1818);
    final subtitleColor = isDark ? Colors.grey[300] : Colors.grey[700];
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white54 : Colors.grey[600];

    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: Colors.white,
                        ),
                        onPressed: themeProvider.toggleTheme,
                        tooltip: isDark ? 'Modo claro' : 'Modo escuro',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.settings_input_hdmi,
                              color: Color(0xFF9C1818),
                              size: 56,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Copperfio',
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fios e Cabos de Alumínio',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'BEM-VINDO(A) USUÁRIO!',
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 18),
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF2A2A2A)
                                    : Colors.grey.shade100,
                                hintText: 'Digite o seu email',
                                hintStyle: TextStyle(color: hintColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Color(0xFF9C1818),
                                ),
                              ),
                              validator: Validatorless.email('Email inválido'),
                              onChanged: _updateFilteredSuggestions,
                            ),
                            if (_filteredEmailSuggestions.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                                child: Column(
                                  children: _filteredEmailSuggestions
                                      .take(5)
                                      .map(
                                        (suggestion) => ListTile(
                                          title: Text(
                                            suggestion,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${_emailUsageCounts[suggestion] ?? 0} logins',
                                            style: TextStyle(
                                              color: subtitleColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          onTap: () => _selectEmailSuggestion(suggestion),
                                          dense: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _senhaController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF2A2A2A)
                                    : Colors.grey.shade100,
                                hintText: 'Digite sua senha',
                                hintStyle: TextStyle(color: hintColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color(0xFF9C1818),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFF9C1818),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: Validatorless.required(
                                'Senha obrigatória',
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9C1818),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) return;

                                  try {
                                    final tipo = await _viewModel.signIn(
                                      email: _emailController.text.trim(),
                                      senha: _senhaController.text.trim(),
                                    );

                                    await _saveEmailSuggestion(_emailController.text.trim());
                                    if (tipo == 'empresa') {
                                      if (context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const HomePageGestor(),
                                          ),
                                        );
                                      }
                                    } else if (tipo == 'cliente') {
                                      if (context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const HomePageUsuario(),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Tipo de usuário inválido.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  } on FirebaseAuthException catch (error) {
                                    String message;
                                    switch (error.code) {
                                      case 'user-not-found':
                                        message =
                                            'Usuário não encontrado. Verifique o e-mail ou cadastre-se.';
                                        break;
                                      case 'wrong-password':
                                        message =
                                            'Senha incorreta. Tente novamente ou recupere a senha.';
                                        break;
                                      case 'invalid-email':
                                        message = 'E-mail inválido.';
                                        break;
                                      case 'invalid-credential':
                                        message =
                                            'Credencial inválida ou expirada. Tente novamente.';
                                        break;
                                      case 'user-no-type':
                                        message =
                                            'Conta criada, mas o perfil não foi salvo corretamente. Tente novamente mais tarde.';
                                        break;
                                      default:
                                        message =
                                            'Erro ao fazer login. Verifique seus dados e tente novamente.';
                                    }

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)),
                                      );
                                    }
                                  } catch (error) {
                                    debugPrint(
                                      'Login error (${error.runtimeType}): ${error.toString()}',
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Erro ao fazer login. Verifique seus dados e tente novamente.',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SignupPage(),
                                    ),
                                  ),
                                  child: Text(
                                    'Cadastrar-se',
                                    style: TextStyle(color: titleColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ForgotPasswordPage(),
                                    ),
                                  ),
                                  child: Text(
                                    'Esqueceu a senha?',
                                    style: TextStyle(color: titleColor),
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
