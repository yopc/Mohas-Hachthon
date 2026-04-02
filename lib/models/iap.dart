import 'package:cloud_firestore/cloud_firestore.dart';

class IapTask {
  final String id;
  final String description;
  final String owner; // 'coach' or 'enterprise'
  final DateTime? dueDate;
  final String status; // 'not_started', 'in_progress', 'done'
  final DateTime? completedAt;
  final bool verifiedByCoach;
  final DateTime? verifiedAt;

  IapTask({
    required this.id,
    required this.description,
    required this.owner,
    this.dueDate,
    required this.status,
    this.completedAt,
    this.verifiedByCoach = false,
    this.verifiedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'owner': owner,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'status': status,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'verifiedByCoach': verifiedByCoach,
      'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
    };
  }

  factory IapTask.fromMap(Map<String, dynamic> map) {
    return IapTask(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      owner: map['owner'] ?? '',
      dueDate: map['dueDate'] != null ? (map['dueDate'] as Timestamp).toDate() : null,
      status: map['status'] ?? 'not_started',
      completedAt: map['completedAt'] != null ? (map['completedAt'] as Timestamp).toDate() : null,
      verifiedByCoach: map['verifiedByCoach'] ?? false,
      verifiedAt: map['verifiedAt'] != null ? (map['verifiedAt'] as Timestamp).toDate() : null,
    );
  }
}

class Iap {
  final String id;
  final String enterpriseId;
  final List<IapTask> tasks;
  final bool coachSigned;
  final bool enterpriseSigned;
  final DateTime? coachSignedAt;
  final DateTime? enterpriseSignedAt;
  final DateTime updatedAt;

  Iap({
    required this.id,
    required this.enterpriseId,
    required this.tasks,
    this.coachSigned = false,
    this.enterpriseSigned = false,
    this.coachSignedAt,
    this.enterpriseSignedAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enterpriseId': enterpriseId,
      'tasks': tasks.map((t) => t.toMap()).toList(),
      'coachSigned': coachSigned,
      'enterpriseSigned': enterpriseSigned,
      'coachSignedAt': coachSignedAt != null ? Timestamp.fromDate(coachSignedAt!) : null,
      'enterpriseSignedAt': enterpriseSignedAt != null ? Timestamp.fromDate(enterpriseSignedAt!) : null,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Iap.fromMap(String id, Map<String, dynamic> map) {
    return Iap(
      id: id,
      enterpriseId: map['enterpriseId'] ?? '',
      tasks: (map['tasks'] as List?)?.map((t) => IapTask.fromMap(t)).toList() ?? [],
      coachSigned: map['coachSigned'] ?? false,
      enterpriseSigned: map['enterpriseSigned'] ?? false,
      coachSignedAt: map['coachSignedAt'] != null ? (map['coachSignedAt'] as Timestamp).toDate() : null,
      enterpriseSignedAt: map['enterpriseSignedAt'] != null ? (map['enterpriseSignedAt'] as Timestamp).toDate() : null,
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
