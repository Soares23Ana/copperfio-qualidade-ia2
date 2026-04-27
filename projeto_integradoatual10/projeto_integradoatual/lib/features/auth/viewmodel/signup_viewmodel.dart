import '../../../data/models/usuario_model.dart';
import '../../../services/auth_service.dart';

class SignupViewModel {
  final AuthService _authService = AuthService();

  Future<void> cadastrarUsuario(UsuarioModel user) async {
    await _authService.register(
      email: user.email,
      password: user.senha ?? '',
      nome: user.nome,
      empresa: user.empresa ?? '',
    );
  }

  Future<bool> existeEmail(String email) async {
    return await _authService.existsUserByEmail(email);
  }

  Future<void> redefinirSenha(String email) async {
    await _authService.resetPassword(email);
  }
}
