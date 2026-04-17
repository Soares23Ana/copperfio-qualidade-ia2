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

  Future<UserCredential> register({
    required String email,
    required String password,
    required String nome,
    required String empresa,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final tipo = 'cliente';
    final userId = userCredential.user?.uid;

    if (userId != null) {
      await _db.collection('users').doc(userId).set({
        'email': email.trim(),
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
    await _auth.sendPasswordResetEmail(email: email.trim());
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
    final querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<String?> promoteUserToGestor(String email) async {
    final email_ = email.trim().toLowerCase();
    
    final querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email_)
        .limit(1)
        .get();
    
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
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();
    
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    
    return querySnapshot.docs.first.data();
  }
}
