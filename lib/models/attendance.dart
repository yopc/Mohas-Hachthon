import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String id;
  final String trainingId;
  final String enterpriseId;
  final String attendeeName;
  final bool present;
  final DateTime checkedInAt;
  final bool qrCodeScanned;

  Attendance({
    required this.id,
    required this.trainingId,
    required this.enterpriseId,
    required this.attendeeName,
    required this.present,
    required this.checkedInAt,
    required this.qrCodeScanned,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trainingId': trainingId,
      'enterpriseId': enterpriseId,
      'attendeeName': attendeeName,
      'present': present,
      'checkedInAt': Timestamp.fromDate(checkedInAt),
      'qrCodeScanned': qrCodeScanned,
    };
  }

  factory Attendance.fromMap(String id, Map<String, dynamic> map) {
    return Attendance(
      id: id,
      trainingId: map['trainingId'] ?? '',
      enterpriseId: map['enterpriseId'] ?? '',
      attendeeName: map['attendeeName'] ?? '',
      present: map['present'] ?? false,
      checkedInAt: (map['checkedInAt'] as Timestamp).toDate(),
      qrCodeScanned: map['qrCodeScanned'] ?? false,
    );
  }
}
