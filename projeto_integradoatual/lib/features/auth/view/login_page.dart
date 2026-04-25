import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9C1818),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                color: Color(0xFF9C1818),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Fios e Cabos de Alumínio',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'BEM-VINDO(A) USUÁRIO!',
                              style: TextStyle(
                                color: Color(0xFF9C1818),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 18),
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Digite o seu email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color(0xFF9C1818),
                                ),
                              ),
                              validator: Validatorless.email('Email inválido'),
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _senhaController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Digite sua senha',
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

                                    if (tipo == 'empresa') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomePageGestor(),
                                        ),
                                      );
                                    } else if (tipo == 'cliente') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomePageUsuario(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).
                                          showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Tipo de usuário inválido.',
                                          ),
                                        ),
                                      );
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
                                      case 'user-no-type':
                                        message =
                                            'Conta criada, mas o perfil não foi salvo corretamente. Tente novamente mais tarde.';
                                        break;
                                      default:
                                        message =
                                            'Erro ao fazer login: ${error.message ?? error.code}';
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(message),
                                      ),
                                    );
                                  } catch (error) {
                                    final errorMessage = error.toString();
                                    debugPrint('Login error (${error.runtimeType}): $errorMessage');
                                    final message = 'Erro ao fazer login: $errorMessage';

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(message),
                                      ),
                                    );
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
                                    style: TextStyle(color: Color(0xFF9C1818)),
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
                                    style: TextStyle(color: Color(0xFF9C1818)),
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
