import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart';

class SignupViewModel {
  final _store = UsuarioMockStore();

  void cadastrar(UsuarioModel user) => _store.adicionar(user);

  void cadastrarUsuario(UsuarioModel user) => _store.adicionar(user);

  bool existeEmail(String email) => _store.existeEmail(email);

  void redefinirSenha(String email, String novaSenha) =>
      _store.atualizarSenha(email, novaSenha);
}
