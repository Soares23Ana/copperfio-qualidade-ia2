import 'dart:async';

import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
import '../../viewmodels/signup_viewmodel.dart';
import 'password_success_page.dart';

class PasswordRecoveryCodePage extends StatefulWidget {
  final String email;

  const PasswordRecoveryCodePage({super.key, required this.email});

  @override
  State<PasswordRecoveryCodePage> createState() =>
      _PasswordRecoveryCodePageState();
}

class _PasswordRecoveryCodePageState extends State<PasswordRecoveryCodePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _codeController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmSenhaController = TextEditingController();
  final _viewModel = SignupViewModel();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late String _verificationCode;
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _generateVerificationCode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showVerificationCodeSnackBar();
    });
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    _senhaController.dispose();
    _confirmSenhaController.dispose();
    super.dispose();
  }

  void _generateVerificationCode() {
    final random = DateTime.now().microsecondsSinceEpoch % 1000000;
    _verificationCode = random.toString().padLeft(6, '0');
  }

  void _showVerificationCodeSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código enviado: $_verificationCode'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _resendCode() {
    if (_remainingSeconds > 0) return;
    _generateVerificationCode();
    _showVerificationCodeSnackBar();
    _startCountdown();
    _codeController.clear();
  }

  String get _timerLabel {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9C1818),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.maybePop(context),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recuperação de Senha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 6),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.settings_input_hdmi,
                                    size: 64,
                                    color: Color(0xFF9C1818),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Center(
                                  child: Text(
                                    'Copperfio',
                                    style: TextStyle(
                                      color: Color(0xFF9C1818),
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Fios e Cabos de Alumínio',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                const Text(
                                  'Recuperação de Senha',
                                  style: TextStyle(
                                    color: Color(0xFF9C1818),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Email cadastrado:',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Digite o seu email cadastrado',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: Validatorless.email(
                                    'Email inválido',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Digite o código:',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Expira em $_timerLabel',
                                      style: TextStyle(
                                        color: _remainingSeconds > 10
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _codeController,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Código de verificação ($_verificationCode)',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: Validatorless.required(
                                    'Código obrigatório',
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _remainingSeconds == 0
                                        ? _resendCode
                                        : null,
                                    child: Text(
                                      _remainingSeconds == 0
                                          ? 'Reenviar código'
                                          : 'Reenviar em $_timerLabel',
                                      style: TextStyle(
                                        color: _remainingSeconds == 0
                                            ? const Color(0xFFDD4E41)
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Criar nova senha',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  'Não use senhas que você já utilizou anteriormente.',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 77, 73, 73),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _senhaController,
                                  decoration: InputDecoration(
                                    hintText: 'Nova senha',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: _obscurePassword,
                                  validator: Validatorless.multiple([
                                    Validatorless.required('Senha obrigatória'),
                                    Validatorless.min(8, 'Mínimo 8 caracteres'),
                                  ]),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Confirme a senha',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextFormField(
                                  controller: _confirmSenhaController,
                                  decoration: InputDecoration(
                                    hintText: 'Confirme a senha',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: _obscureConfirmPassword,
                                  validator: Validatorless.multiple([
                                    Validatorless.required(
                                      'Confirmação obrigatória',
                                    ),
                                    Validatorless.compare(
                                      _senhaController,
                                      'As senhas não coincidem',
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Comprimento mínimo:\n- Geralmente entre 8 e 12 caracteres.\n- Variedade de caracteres:\n   * Pelo menos uma letra maiúscula (A-Z).\n   * Pelo menos uma letra minúscula (a-z).\n   * Pelo menos um número (0-9).\n   * Pelo menos um caractere especial (ex: @, #, &, %, !)',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 94, 89, 89),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8B0000),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (_codeController.text.trim() !=
                                            _verificationCode) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Código de verificação inválido.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        if (!_viewModel.existeEmail(
                                          _emailController.text,
                                        )) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'E-mail não encontrado. Cadastre-se primeiro.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        if (_senhaController.text !=
                                            _confirmSenhaController.text) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Senhas não coincidem.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        _viewModel.redefinirSenha(
                                          _emailController.text,
                                          _senhaController.text,
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Senha redefinida com sucesso!',
                                            ),
                                          ),
                                        );

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const PasswordSuccessPage(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Redefinir senha',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
