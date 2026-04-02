import 'package:cloud_firestore/cloud_firestore.dart';

class Evidence {
  final String id;
  final String enterpriseId;
  final String recordType; // baseline, coaching, final, etc.
  final String recordId;
  final String type; // photo, document, receipt
  final String url;
  final String uploadedBy;
  final DateTime timestamp;
  final List<String> tags;
  final bool isVerified;

  Evidence({
    required this.id,
    required this.enterpriseId,
    required this.recordType,
    required this.recordId,
    required this.type,
    required this.url,
    required this.uploadedBy,
    required this.timestamp,
    required this.tags,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enterpriseId': enterpriseId,
      'recordType': recordType,
      'recordId': recordId,
      'type': type,
      'url': url,
      'uploadedBy': uploadedBy,
      'timestamp': Timestamp.fromDate(timestamp),
      'tags': tags,
      'isVerified': isVerified,
    };
  }

  factory Evidence.fromMap(String id, Map<String, dynamic> map) {
    return Evidence(
      id: id,
      enterpriseId: map['enterpriseId'] ?? '',
      recordType: map['recordType'] ?? '',
      recordId: map['recordId'] ?? '',
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      tags: List<String>.from(map['tags'] ?? []),
      isVerified: map['isVerified'] ?? false,
    );
  }
}
