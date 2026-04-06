import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
import '../models/usuario_model.dart';
import '../viewmodels/signup_viewmodel.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _codeController = TextEditingController();
    final _senhaController = TextEditingController();
    final _confirmSenhaController = TextEditingController();
    final _viewModel = SignupViewModel();

    const verificationCode = '123456';

    return Scaffold(
      backgroundColor: Color(0xFF9C1818),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.maybePop(context),
              ),
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'recuperação de senha2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
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
                                Center(
                                  child: Icon(
                                    Icons.settings_input_hdmi,
                                    size: 64,
                                    color: Color(0xFF9C1818),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Center(
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
                                SizedBox(height: 22),
                                Text(
                                  'Recuperação de Senha',
                                  style: TextStyle(
                                    color: Color(0xFF9C1818),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Email cadastrado:',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
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
                                SizedBox(height: 16),
                                Text(
                                  'Cole o código abaixo:',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: _codeController,
                                  decoration: InputDecoration(
                                    hintText: 'Código de verificação (123456)',
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
                                SizedBox(height: 16),
                                Text(
                                  'Criar nova senha',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Não use senhas que você já utilizou anteriormente.',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 10),
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
                                  ),
                                  obscureText: true,
                                  validator: Validatorless.multiple([
                                    Validatorless.required('Senha obrigatória'),
                                    Validatorless.min(8, 'Mínimo 8 caracteres'),
                                  ]),
                                ),
                                SizedBox(height: 12),
                                Text(
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
                                  ),
                                  obscureText: true,
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
                                SizedBox(height: 14),
                                Text(
                                  'Comprimento mínimo:\n- Geralmente entre 8 e 12 caracteres.\n- Variedade de caracteres:\n   * Pelo menos uma letra maiúscula (A-Z).\n   * Pelo menos uma letra minúscula (a-z).\n   * Pelo menos um número (0-9).\n   * Pelo menos um caractere especial (ex: @, #, &, %, !)',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFDD4E41),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (_codeController.text.trim() !=
                                            verificationCode) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
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
                                            SnackBar(
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
                                            SnackBar(
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
                                          SnackBar(
                                            content: Text(
                                              'Senha redefinida com sucesso!',
                                            ),
                                          ),
                                        );

                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
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
