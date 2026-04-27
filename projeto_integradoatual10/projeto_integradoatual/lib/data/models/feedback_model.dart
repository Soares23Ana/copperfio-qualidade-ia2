import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String mensagem;
  final String lote;
  final String userId;
  final String userEmpresa;
  final String userName;
  final String userEmail;
  final String userType;
  final String empresaId;
  final DateTime data;
  final String status;
  final bool isRead;

  FeedbackModel({
    required this.id,
    required this.mensagem,
    required this.lote,
    required this.userId,
    required this.userEmpresa,
    required this.userName,
    required this.userEmail,
    required this.userType,
    required this.empresaId,
    required this.data,
    required this.status,
    required this.isRead,
  });

  factory FeedbackModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return FeedbackModel(
      id: doc.id,
      mensagem: data['mensagem'] ?? '',
      lote: data['lote'] ?? '',
      userId: data['userId'] ?? '',
      userEmpresa: data['userEmpresa'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userType: data['userType'] ?? '',
      empresaId: data['empresaId'] ?? '',
      data: (data['data'] as Timestamp).toDate(),
      status: data['status'] ?? 'novo',
      isRead: data['isRead'] ?? false,
    );
  }
}
