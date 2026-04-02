import 'package:cloud_firestore/cloud_firestore.dart';

class QcCheck {
  final String id;
  final String recordType; // baseline_form, coaching_visit, etc.
  final String recordId;
  final String checkerId;
  final String status; // verified, needs_correction
  final String? notes;
  final DateTime createdAt;

  QcCheck({
    required this.id,
    required this.recordType,
    required this.recordId,
    required this.checkerId,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recordType': recordType,
      'recordId': recordId,
      'checkerId': checkerId,
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory QcCheck.fromMap(String id, Map<String, dynamic> map) {
    return QcCheck(
      id: id,
      recordType: map['recordType'] ?? '',
      recordId: map['recordId'] ?? '',
      checkerId: map['checkerId'] ?? '',
      status: map['status'] ?? '',
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
