import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
import '../../data/models/usuario_model.dart';
import '../../viewmodels/signup_viewmodel.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nomeController;
  late final TextEditingController _celularEmailController;
  late final TextEditingController _senhaController;
  late final TextEditingController _confirmSenhaController;
  late final TextEditingController _enderecoController;
  late final SignupViewModel _viewModel;
  bool _obscureSenha = true;
  bool _obscureConfirmSenha = true;

  String? _selectedDia;
  String? _selectedMes;
  String? _selectedAno;
  String? _selectedGenero;

  final List<String> dias = List.generate(31, (i) => (i + 1).toString());
  final List<String> meses = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  final List<String> anos = List.generate(
    100,
    (i) => (DateTime.now().year - i).toString(),
  );

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nomeController = TextEditingController();
    _celularEmailController = TextEditingController();
    _senhaController = TextEditingController();
    _confirmSenhaController = TextEditingController();
    _enderecoController = TextEditingController();
    _viewModel = SignupViewModel();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _celularEmailController.dispose();
    _senhaController.dispose();
    _confirmSenhaController.dispose();
    _enderecoController.dispose();
    super.dispose();
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
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.settings_input_hdmi,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Center(
                                  child: Text(
                                    'Copperfio',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    'Fios e Cabos de Alumínio',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Nome Completo
                                TextFormField(
                                  controller: _nomeController,
                                  decoration: InputDecoration(
                                    hintText: 'Nome completo',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    errorStyle: const TextStyle(color: Colors.white70),
                                  ),
                                  validator: Validatorless.required(
                                    'Nome completo obrigatório',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // E-mail
                                TextFormField(
                                  controller: _celularEmailController,
                                  decoration: InputDecoration(
                                    hintText: 'Digite seu e-mail',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Color(0xFF9C1818),
                                    ),
                                    errorStyle: const TextStyle(color: Colors.white70),
                                  ),
                                  validator: Validatorless.multiple([
                                    Validatorless.required(
                                      'E-mail obrigatório',
                                    ),
                                    Validatorless.email('E-mail inválido'),
                                  ]),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 12),
                                // Senha
                                TextFormField(
                                  controller: _senhaController,
                                  decoration: InputDecoration(
                                    hintText: 'Senha',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureSenha
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFF9C1818),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureSenha = !_obscureSenha;
                                        });
                                      },
                                    ),
                                    errorStyle: const TextStyle(color: Colors.white70),
                                  ),
                                  obscureText: _obscureSenha,
                                  validator: Validatorless.multiple([
                                    Validatorless.required('Senha obrigatória'),
                                    (value) {
                                      if (value != null && value.isNotEmpty && value.length < 8) {
                                        return 'Mínimo 8 caracteres';
                                      }
                                      return null;
                                    }
                                  ]),
                                ),
                                const SizedBox(height: 12),
                                // Confirmação de senha
                                TextFormField(
                                  controller: _confirmSenhaController,
                                  decoration: InputDecoration(
                                    hintText: 'Confirme a senha',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmSenha
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFF9C1818),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmSenha =
                                              !_obscureConfirmSenha;
                                        });
                                      },
                                    ),
                                    errorStyle: const TextStyle(color: Colors.white70),
                                  ),
                                  obscureText: _obscureConfirmSenha,
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
                                const SizedBox(height: 12),
                                // Endereço
                                TextFormField(
                                  controller: _enderecoController,
                                  decoration: InputDecoration(
                                    hintText: 'Endereço',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    errorStyle: const TextStyle(color: Colors.white70),
                                  ),
                                  validator: Validatorless.required(
                                    'Endereço obrigatório',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Data de Nascimento
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Data de nascimento:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        initialValue: _selectedDia,
                                        isExpanded: true,
                                        hint: const Text('dia'),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xFF9C1818),
                                        ),
                                        iconSize: 24,
                                        dropdownColor: Colors.white,
                                        items: dias
                                            .map(
                                              (dia) => DropdownMenuItem(
                                                value: dia,
                                                child: Text(dia),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedDia = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                        ),
                                        validator: Validatorless.required(
                                          'Dia obrigatório',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        initialValue: _selectedMes,
                                        isExpanded: true,
                                        hint: const Text('mês'),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xFF9C1818),
                                        ),
                                        iconSize: 24,
                                        dropdownColor: Colors.white,
                                        items: meses
                                            .map(
                                              (mes) => DropdownMenuItem(
                                                value: mes,
                                                child: Text(mes),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedMes = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                        ),
                                        validator: Validatorless.required(
                                          'Mês obrigatório',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        initialValue: _selectedAno,
                                        isExpanded: true,
                                        hint: const Text('ano'),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xFF9C1818),
                                        ),
                                        iconSize: 24,
                                        dropdownColor: Colors.white,
                                        items: anos
                                            .map(
                                              (ano) => DropdownMenuItem(
                                                value: ano,
                                                child: Text(ano),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedAno = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                        ),
                                        validator: Validatorless.required(
                                          'Ano obrigatório',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Gênero
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Gênero:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'feminino',
                                      groupValue: _selectedGenero,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGenero = value;
                                        });
                                      },
                                      activeColor: Colors.white,
                                    ),
                                    const Text(
                                      'F',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Radio<String>(
                                      value: 'masculino',
                                      groupValue: _selectedGenero,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGenero = value;
                                        });
                                      },
                                      activeColor: Colors.white,
                                    ),
                                    const Text(
                                      'M',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Radio<String>(
                                      value: 'prefiro_nao_dizer',
                                      groupValue: _selectedGenero,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGenero = value;
                                        });
                                      },
                                      activeColor: Colors.white,
                                    ),
                                    const Flexible(
                                      child: Text(
                                        'Prefiro não dizer',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Botão Cadastre-se
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (_selectedGenero == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Selecione um gênero',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        // Criar usuário
                                        String generoTexto = _selectedGenero ?? '';
                                        if (generoTexto == 'prefiro_nao_dizer') {
                                          generoTexto = 'Prefiro não dizer';
                                        } else if (generoTexto == 'feminino') {
                                          generoTexto = 'Feminino';
                                        } else if (generoTexto == 'masculino') {
                                          generoTexto = 'Masculino';
                                        }

                                        final usuario = UsuarioModel(
                                          nome: _nomeController.text,
                                          email: _celularEmailController.text,
                                          senha: _senhaController.text,
                                          endereco: _enderecoController.text,
                                          dataNascimento:
                                              '$_selectedDia/$_selectedMes/$_selectedAno',
                                          genero: generoTexto,
                                          role: 'usuario',
                                        );

                                        _viewModel.cadastrarUsuario(usuario);

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Cadastro realizado com sucesso!',
                                            ),
                                          ),
                                        );

                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      'Cadastrar',
                                      style: TextStyle(
                                        color: const Color(0xFF9C1818),
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
