import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  Future<UserCredential> register({
    required String email,
    required String password,
    required String nome,
    required String empresa,
  }) async {
    final normalizedEmail = _normalizeEmail(email);

    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password.trim(),
    );

    final tipo = 'cliente';
    final userId = userCredential.user?.uid;

    if (userId != null) {
      await _db.collection('users').doc(userId).set({
        'email': normalizedEmail,
        'email_lower': normalizedEmail,
        'nome': nome.trim(),
        'empresa': empresa.trim(),
        'tipo': tipo,
        'empresaId': 'copperfio',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return userCredential;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: _normalizeEmail(email));
  }

  String? get currentUserId => _auth.currentUser?.uid;

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDocument(
    String userId,
  ) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists ? doc : null;
  }

  Future<String?> getUserType(String userId) async {
    final doc = await getUserDocument(userId);
    return doc?.data()?['tipo'] as String?;
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final uid = currentUserId;
    if (uid == null) return null;
    final doc = await getUserDocument(uid);
    return doc?.data();
  }

  Future<bool> existsUserByEmail(String email) async {
    try {
      final trimmedEmail = email.trim();
      final normalizedEmail = _normalizeEmail(email);

      try {
        final lowercaseEmailSnapshot = await _db
            .collection('users')
            .where('email_lower', isEqualTo: normalizedEmail)
            .limit(1)
            .get();
        if (lowercaseEmailSnapshot.docs.isNotEmpty) {
          return true;
        }
      } catch (e) {
        print('Erro ao buscar email_lower: $e');
      }

      try {
        final exactEmailSnapshot = await _db
            .collection('users')
            .where('email', isEqualTo: trimmedEmail)
            .limit(1)
            .get();
        if (exactEmailSnapshot.docs.isNotEmpty) {
          return true;
        }
      } catch (e) {
        print('Erro ao buscar email exato: $e');
      }

      try {
        final allUsersSnapshot = await _db.collection('users').get();
        for (var doc in allUsersSnapshot.docs) {
          final userEmail = doc.data()['email']?.toString() ?? '';
          if (userEmail.toLowerCase() == normalizedEmail) {
            return true;
          }
        }
      } catch (e) {
        print('Erro ao buscar todos os usuários: $e');
      }

      return false;
    } catch (e) {
      print('Erro geral em existsUserByEmail: $e');
      return false;
    }
  }

  Future<String?> promoteUserToGestor(String email) async {
    final email_ = email.trim().toLowerCase();
    
    try {
      var querySnapshot = await _db
          .collection('users')
          .where('email', isEqualTo: email_)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _db
            .collection('users')
            .where('email_lower', isEqualTo: email_)
            .limit(1)
            .get();
      }

      if (querySnapshot.docs.isEmpty) {
        final allUsersSnapshot = await _db.collection('users').get();
        for (var doc in allUsersSnapshot.docs) {
          final userEmail = doc.data()['email']?.toString() ?? '';
          if (userEmail.toLowerCase() == email_) {
            querySnapshot = await _db.collection('users').where('email', isEqualTo: userEmail).limit(1).get();
            break;
          }
        }
      }
    
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Usuário com este email não encontrado.');
      }
      
      final userDoc = querySnapshot.docs.first;
      final uid = userDoc.id;
      final currentTipo = userDoc.data()['tipo'] as String?;
      
      if (currentTipo == 'empresa') {
        throw Exception('Este usuário já é gestor.');
      }
      
      await _db.collection('users').doc(uid).update({
        'tipo': 'empresa',
        'promotedAt': FieldValue.serverTimestamp(),
      });
      
      return uid;
    } catch (e) {
      throw Exception('Erro ao promover usuário: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final normalizedEmail = _normalizeEmail(email);
      
      var querySnapshot = await _db
          .collection('users')
          .where('email', isEqualTo: normalizedEmail)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }

      querySnapshot = await _db
          .collection('users')
          .where('email_lower', isEqualTo: normalizedEmail)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }

      final allUsersSnapshot = await _db.collection('users').get();
      for (var doc in allUsersSnapshot.docs) {
        final userEmail = doc.data()['email']?.toString() ?? '';
        if (userEmail.toLowerCase() == normalizedEmail) {
          return doc.data();
        }
      }

      return null;
    } catch (e) {
      print('Erro ao buscar usuário por email: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getFirstEmpresaUser() async {
    final querySnapshot = await _db
        .collection('users')
        .where('tipo', isEqualTo: 'empresa')
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final doc = querySnapshot.docs.first;
    return {...doc.data(), 'id': doc.id};
  }
}
