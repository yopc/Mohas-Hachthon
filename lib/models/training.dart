import 'package:cloud_firestore/cloud_firestore.dart';

class Training {
  final String id;
  final String title;
  final String module;
  final DateTime date;
  final String location;
  final String trainerId;
  final int maxSeats;
  final DateTime createdAt;

  Training({
    required this.id,
    required this.title,
    required this.module,
    required this.date,
    required this.location,
    required this.trainerId,
    required this.maxSeats,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'module': module,
      'date': Timestamp.fromDate(date),
      'location': location,
      'trainerId': trainerId,
      'maxSeats': maxSeats,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Training.fromMap(String id, Map<String, dynamic> map) {
    return Training(
      id: id,
      title: map['title'] ?? '',
      module: map['module'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      location: map['location'] ?? '',
      trainerId: map['trainerId'] ?? '',
      maxSeats: map['maxSeats'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
