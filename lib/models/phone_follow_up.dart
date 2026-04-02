import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneFollowUp {
  final String id;
  final String enterpriseId;
  final DateTime date;
  final String purpose;
  final String issue;
  final String adviceGiven;
  final String nextAction;

  PhoneFollowUp({
    required this.id,
    required this.enterpriseId,
    required this.date,
    required this.purpose,
    required this.issue,
    required this.adviceGiven,
    required this.nextAction,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enterpriseId': enterpriseId,
      'date': Timestamp.fromDate(date),
      'purpose': purpose,
      'issue': issue,
      'adviceGiven': adviceGiven,
      'nextAction': nextAction,
    };
  }

  factory PhoneFollowUp.fromMap(String id, Map<String, dynamic> map) {
    return PhoneFollowUp(
      id: id,
      enterpriseId: map['enterpriseId'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      purpose: map['purpose'] ?? '',
      issue: map['issue'] ?? '',
      adviceGiven: map['adviceGiven'] ?? '',
      nextAction: map['nextAction'] ?? '',
    );
  }
}
