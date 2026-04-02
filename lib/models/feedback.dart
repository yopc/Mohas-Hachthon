import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback {
  final String id;
  final String trainingId;
  final String enterpriseId;
  final int usefulnessRating; // 1-5
  final String unclearPoints;
  final String suggestions;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.trainingId,
    required this.enterpriseId,
    required this.usefulnessRating,
    required this.unclearPoints,
    required this.suggestions,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trainingId': trainingId,
      'enterpriseId': enterpriseId,
      'usefulnessRating': usefulnessRating,
      'unclearPoints': unclearPoints,
      'suggestions': suggestions,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Feedback.fromMap(String id, Map<String, dynamic> map) {
    return Feedback(
      id: id,
      trainingId: map['trainingId'] ?? '',
      enterpriseId: map['enterpriseId'] ?? '',
      usefulnessRating: map['usefulnessRating'] ?? 0,
      unclearPoints: map['unclearPoints'] ?? '',
      suggestions: map['suggestions'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
