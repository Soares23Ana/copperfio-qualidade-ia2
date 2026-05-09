import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> uploadFeedbackImage(File imageFile, String userId) async {
    if (!await imageFile.exists()) {
      throw Exception('Arquivo de imagem não encontrado. Tente novamente.');
    }

    final storage = FirebaseStorage.instance;
    final reference = storage
        .ref()
        .child('feedback_images')
        .child('$userId-${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      final uploadTask = reference.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      await uploadTask.whenComplete(() {});
      return await reference.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Falha ao enviar imagem: ${e.message ?? e.code}');
    }
  }

  // 🔹 Criar feedback
  Future<void> criarFeedback({
    required String mensagem,
    required String userId,
    required String empresaId,
    String? lote,
    int? item1,
    int? item2,
    int? item3,
    int? item4,
    int? item5,
    int? item6,
    int? item7,
    int? item8,
    double? notaMedia,
    String? userEmpresa,
    String? userName,
    String? userEmail,
    String? userType,
    String? atendimentoMood,
    List<String>? tags,
    String? photoUrl,
    int? generalRating,
  }) async {
    await _db.collection('feedbacks').add({
      'mensagem': mensagem,
      'lote': lote ?? '',
      'item1': item1 ?? 0,
      'item2': item2 ?? 0,
      'item3': item3 ?? 0,
      'item4': item4 ?? 0,
      'item5': item5 ?? 0,
      'item6': item6 ?? 0,
      'item7': item7 ?? 0,
      'item8': item8 ?? 0,
      'notaMedia': notaMedia ?? 0.0,
      'generalRating': generalRating ?? 0,
      'atendimentoMood': atendimentoMood ?? '',
      'tags': tags ?? [],
      'photoUrl': photoUrl ?? '',
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

  // 🔹 Deletar feedback
  Future<void> deletarFeedback(String feedbackId) async {
    await _db.collection('feedbacks').doc(feedbackId).delete();
  }

  // 🔹 Marcar feedback como lido
  Future<void> marcarFeedbackComoLido(String feedbackId) async {
    await _db.collection('feedbacks').doc(feedbackId).update({'isRead': true});
  }

  // 🔹 Contar feedbacks da empresa
  Future<int> getFeedbacksCount(String empresaId) async {
    final snapshot = await _db
        .collection('feedbacks')
        .where('empresaId', isEqualTo: empresaId)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  // 🔹 Contar feedbacks não lidos (alertas)
  Future<int> getUnreadFeedbacksCount(String empresaId) async {
    final snapshot = await _db
        .collection('feedbacks')
        .where('empresaId', isEqualTo: empresaId)
        .where('isRead', isEqualTo: false)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  // 🔹 Contar chamados da empresa
  Future<int> getChamadosCount(String empresaId) async {
    final snapshot = await _db
        .collection('chamados')
        .where('empresaId', isEqualTo: empresaId)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
