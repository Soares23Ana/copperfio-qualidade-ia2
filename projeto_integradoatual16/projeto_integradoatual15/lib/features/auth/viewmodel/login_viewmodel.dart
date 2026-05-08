import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';

class LoginViewModel {
  final AuthService _authService = AuthService();

  Future<String?> signIn({
    required String email,
    required String senha,
  }) async {
    final credential = await _authService.signIn(
      email: email,
      password: senha,
    );

    final uid = credential.user?.uid;
    if (uid == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Usuário não encontrado.',
      );
    }

    final tipo = await _authService.getUserType(uid);
    return tipo ?? 'cliente';
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }
}
