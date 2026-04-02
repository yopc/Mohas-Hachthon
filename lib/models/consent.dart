import 'package:cloud_firestore/cloud_firestore.dart';

class Consent {
  final String id;
  final String enterpriseId;
  final DateTime timestamp;
  final String version;
  final bool signed;
  final String? signatureUrl;
  final bool safeguardingAcknowledged;
  final String? uploadedBy;

  Consent({
    required this.id,
    required this.enterpriseId,
    required this.timestamp,
    required this.version,
    required this.signed,
    this.signatureUrl,
    required this.safeguardingAcknowledged,
    this.uploadedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enterpriseId': enterpriseId,
      'timestamp': Timestamp.fromDate(timestamp),
      'version': version,
      'signed': signed,
      'signatureUrl': signatureUrl,
      'safeguardingAcknowledged': safeguardingAcknowledged,
      'uploadedBy': uploadedBy,
    };
  }

  factory Consent.fromMap(String id, Map<String, dynamic> map) {
    return Consent(
      id: id,
      enterpriseId: map['enterpriseId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      version: map['version'] ?? '',
      signed: map['signed'] ?? false,
      signatureUrl: map['signatureUrl'],
      safeguardingAcknowledged: map['safeguardingAcknowledged'] ?? false,
      uploadedBy: map['uploadedBy'],
    );
  }
}
