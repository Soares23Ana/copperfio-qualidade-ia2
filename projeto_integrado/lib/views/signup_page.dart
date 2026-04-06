import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
import '../models/usuario_model.dart';
import '../viewmodels/signup_viewmodel.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nomeController;
  late final TextEditingController _celularEmailController;
  late final TextEditingController _enderecoController;
  late final SignupViewModel _viewModel;

  String? _selectedDia;
  String? _selectedMes;
  String? _selectedAno;
  String? _selectedGenero;
  bool _prefiroNaoDizer = false;

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
    _enderecoController = TextEditingController();
    _viewModel = SignupViewModel();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _celularEmailController.dispose();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDD4E41),
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
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Center(
                                  child: Text(
                                    'Copperfio',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
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
                                const SizedBox(height: 22),
                                const Text(
                                  'Cadastre-Se',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'É novo? Cadastre-se aqui!',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
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
                                  ),
                                  validator: Validatorless.required(
                                    'Nome completo obrigatório',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Celular ou E-mail
                                TextFormField(
                                  controller: _celularEmailController,
                                  decoration: InputDecoration(
                                    hintText: 'Celular ou e-mail',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: Validatorless.required(
                                    'Celular ou e-mail obrigatório',
                                  ),
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
                                        value: _selectedDia,
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
                                          hintText: 'dia',
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
                                                horizontal: 12,
                                                vertical: 8,
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
                                        value: _selectedMes,
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
                                          hintText: 'mês',
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
                                                horizontal: 12,
                                                vertical: 8,
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
                                        value: _selectedAno,
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
                                          hintText: 'ano',
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
                                                horizontal: 12,
                                                vertical: 8,
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
                                          _prefiroNaoDizer = false;
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
                                          _prefiroNaoDizer = false;
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
                                    Checkbox(
                                      value: _prefiroNaoDizer,
                                      onChanged: (value) {
                                        setState(() {
                                          _prefiroNaoDizer = value ?? false;
                                          if (_prefiroNaoDizer) {
                                            _selectedGenero = null;
                                          }
                                        });
                                      },
                                      activeColor: Colors.white,
                                      checkColor: const Color(0xFFDD4E41),
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
                                        if (_selectedGenero == null &&
                                            !_prefiroNaoDizer) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Selecione um gênero ou marque "Prefiro não dizer"',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        // Criar usuário
                                        final usuario = UsuarioModel(
                                          nome: _nomeController.text,
                                          email: _celularEmailController.text,
                                          endereco: _enderecoController.text,
                                          dataNascimento:
                                              '$_selectedDia/$_selectedMes/$_selectedAno',
                                          genero: _prefiroNaoDizer
                                              ? 'Prefiro não dizer'
                                              : _selectedGenero ?? '',
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
                                    child: const Text(
                                      'Cadastre-se',
                                      style: TextStyle(
                                        color: Color(0xFFDD4E41),
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
