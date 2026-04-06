import '../data/usuario_mock_store.dart';

class LoginViewModel {
  final _store = UsuarioMockStore();
  bool autenticar(String email, String senha) => _store.existe(email, senha);
}
