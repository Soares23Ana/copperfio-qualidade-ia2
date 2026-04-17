import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _empresaController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _estadoController = TextEditingController(text: 'SP');
  final _cidadeController = TextEditingController(text: 'São Paulo');
  final _cepController = TextEditingController();
  final _foneController = TextEditingController();
  final _emailController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _empresaController.dispose();
    _enderecoController.dispose();
    _bairroController.dispose();
    _estadoController.dispose();
    _cidadeController.dispose();
    _cepController.dispose();
    _foneController.dispose();
    _emailController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação enviada com sucesso!')),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _estadoController.text = 'SP';
      _cidadeController.text = 'São Paulo';
    });
    _nomeController.clear();
    _empresaController.clear();
    _enderecoController.clear();
    _bairroController.clear();
    _cepController.clear();
    _foneController.clear();
    _emailController.clear();
    _observacoesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB02820),
        centerTitle: true,
        elevation: 0,
        // COR DA SETA: Definida via iconTheme
        iconTheme: const IconThemeData(color: Colors.white),
        // COR DO TEXTO: Definida via titleTextStyle
        title: const Text(
          'Contato',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFB02820),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.contact_mail, color: Colors.white, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Copperfio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Fios e Cabos de Alumínio',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Para solicitar orçamentos ou pedidos preencha nosso formulário informando-nos o tipo de cabo e a metragem.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Nome',
                      _nomeController,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Digite seu nome'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Empresa', _empresaController),
                    const SizedBox(height: 12),
                    _buildTextField('Endereço', _enderecoController),
                    const SizedBox(height: 12),
                    _buildTextField('Bairro', _bairroController),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Estado', _estadoController),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('Cidade', _cidadeController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'CEP',
                            _cepController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            'Fone',
                            _foneController,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'E-mail',
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return 'Digite seu e-mail';
                        if (!RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value.trim()))
                          return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _observacoesController,
                      minLines: 4,
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: 'Observações (tipo de cabo + metragem)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB02820),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _enviarFormulario,
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          'Enviar solicitação',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _resetForm,
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpar formulário'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
