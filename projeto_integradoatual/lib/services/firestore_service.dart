import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Criar feedback
  Future<void> criarFeedback({
    required String mensagem,
    required String userId,
    required String empresaId,
    String? lote,
    String? userEmpresa,
    String? userName,
    String? userEmail,
    String? userType,
  }) async {
    await _db.collection('feedbacks').add({
      'mensagem': mensagem,
      'lote': lote ?? '',
      'userId': userId,
      'userEmpresa': userEmpresa ?? '',
      'userName': userName ?? '',
      'userEmail': userEmail ?? '',
      'userType': userType ?? 'cliente',
      'empresaId': empresaId,
      'data': Timestamp.now(),
      'status': 'novo',
      'isRead': false,
    });
  }

  // 🔹 Stream de feedbacks (tempo real)
  Stream<QuerySnapshot<Map<String, dynamic>>> getFeedbacks(String empresaId) {
    return _db
        .collection('feedbacks')
        .where('empresaId', isEqualTo: empresaId)
        .snapshots();
  }
}
