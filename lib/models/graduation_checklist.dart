import 'package:cloud_firestore/cloud_firestore.dart';

class GraduationChecklist {
  final String id;
  final String enterpriseId;
  final bool baselinePresent;
  final bool minCoachingVisits; // >=8
  final bool midlineBetter; // midline > baseline for key indicators OR coach sign‑off
  final bool coachSignOff;
  final bool evidencePack;
  final bool mAndEApproved;
  final DateTime? approvedAt;
  final String? approvedBy;

  GraduationChecklist({
    required this.id,
    required this.enterpriseId,
    required this.baselinePresent,
    required this.minCoachingVisits,
    required this.midlineBetter,
    required this.coachSignOff,
    required this.evidencePack,
    required this.mAndEApproved,
    this.approvedAt,
    this.approvedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enterpriseId': enterpriseId,
      'baselinePresent': baselinePresent,
      'minCoachingVisits': minCoachingVisits,
      'midlineBetter': midlineBetter,
      'coachSignOff': coachSignOff,
      'evidencePack': evidencePack,
      'mAndEApproved': mAndEApproved,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'approvedBy': approvedBy,
    };
  }

  factory GraduationChecklist.fromMap(String id, Map<String, dynamic> map) {
    return GraduationChecklist(
      id: id,
      enterpriseId: map['enterpriseId'] ?? '',
      baselinePresent: map['baselinePresent'] ?? false,
      minCoachingVisits: map['minCoachingVisits'] ?? false,
      midlineBetter: map['midlineBetter'] ?? false,
      coachSignOff: map['coachSignOff'] ?? false,
      evidencePack: map['evidencePack'] ?? false,
      mAndEApproved: map['mAndEApproved'] ?? false,
      approvedAt: map['approvedAt'] != null ? (map['approvedAt'] as Timestamp).toDate() : null,
      approvedBy: map['approvedBy'],
    );
  }
}
