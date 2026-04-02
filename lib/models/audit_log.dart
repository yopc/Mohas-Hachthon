import 'package:cloud_firestore/cloud_firestore.dart';

class AuditLog {
  final String id;
  final String userId;
  final String action; // create, update, delete
  final String collection;
  final String documentId;
  final Map<String, dynamic> oldData;
  final Map<String, dynamic> newData;
  final DateTime timestamp;

  AuditLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.collection,
    required this.documentId,
    required this.oldData,
    required this.newData,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'action': action,
      'collection': collection,
      'documentId': documentId,
      'oldData': oldData,
      'newData': newData,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory AuditLog.fromMap(String id, Map<String, dynamic> map) {
    return AuditLog(
      id: id,
      userId: map['userId'] ?? '',
      action: map['action'] ?? '',
      collection: map['collection'] ?? '',
      documentId: map['documentId'] ?? '',
      oldData: map['oldData'] ?? {},
      newData: map['newData'] ?? {},
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
