import 'package:cloud_firestore/cloud_firestore.dart';

class Assessment {
  final String id;
  final String enterpriseId;
  final String enterpriseName;
  final String coachId;
  final String coachName;
  final DateTime date;
  final String type;
  final Map<String, double> scores;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;
  final String status;

  Assessment({
    required this.id,
    required this.enterpriseId,
    required this.enterpriseName,
    required this.coachId,
    required this.coachName,
    required this.date,
    required this.type,
    required this.scores,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'enterpriseId': enterpriseId,
      'enterpriseName': enterpriseName,
      'coachId': coachId,
      'coachName': coachName,
      'date': date.toIso8601String(),
      'type': type,
      'scores': scores,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'recommendations': recommendations,
      'status': status,
    };
  }

  factory Assessment.fromMap(String id, Map<String, dynamic> map) {
    return Assessment(
      id: id,
      enterpriseId: map['enterpriseId'] ?? '',
      enterpriseName: map['enterpriseName'] ?? '',
      coachId: map['coachId'] ?? '',
      coachName: map['coachName'] ?? '',
      date: _parseDate(map['date']),
      type: map['type'] ?? 'Baseline',
      scores: _parseScores(map['scores']),
      strengths: List<String>.from(map['strengths'] ?? []),
      weaknesses: List<String>.from(map['weaknesses'] ?? []),
      recommendations: List<String>.from(map['recommendations'] ?? []),
      status: map['status'] ?? 'Completed',
    );
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is Timestamp) return dateValue.toDate();
    if (dateValue is String) return DateTime.parse(dateValue);
    return DateTime.now();
  }

  static Map<String, double> _parseScores(dynamic scoresValue) {
    if (scoresValue == null) return {};
    if (scoresValue is Map) {
      return scoresValue.map((key, value) => 
          MapEntry(key.toString(), (value as num).toDouble()));
    }
    return {};
  }
}
