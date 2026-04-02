import '../models/usuario_model.dart';

class UsuarioMockStore {
  static final UsuarioMockStore _instance = UsuarioMockStore._internal();
  factory UsuarioMockStore() => _instance;
  UsuarioMockStore._internal();

  final List<UsuarioModel> usuarios = [];

  void adicionar(UsuarioModel user) => usuarios.add(user);

  bool existe(String email, String senha) {
    return usuarios.any((u) => u.email == email && u.senha == senha);
  }

  bool existeEmail(String email) {
    return usuarios.any((u) => u.email == email);
  }

  void atualizarSenha(String email, String novaSenha) {
    for (var i = 0; i < usuarios.length; i++) {
      if (usuarios[i].email == email) {
        usuarios[i] = UsuarioModel(
          nome: usuarios[i].nome,
          email: usuarios[i].email,
          senha: novaSenha,
          endereco: usuarios[i].endereco,
          dataNascimento: usuarios[i].dataNascimento,
          genero: usuarios[i].genero,
        );
        break;
      }
    }
  }
}
