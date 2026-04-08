import '../data/usuario_mock_store.dart';
import '../data/models/usuario_model.dart';

class LoginViewModel {
  final _store = UsuarioMockStore();

  UsuarioModel? autenticar(String email, String senha) {
    return _store.autenticar(email, senha);
  }
}
