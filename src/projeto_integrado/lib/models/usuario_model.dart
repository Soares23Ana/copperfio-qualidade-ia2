class UsuarioModel {
  final String nome;
  final String email;
  final String? senha;
  final String? endereco;
  final String? dataNascimento;
  final String? genero;

  UsuarioModel({
    required this.nome,
    required this.email,
    this.senha,
    this.endereco,
    this.dataNascimento,
    this.genero,
  });
}
