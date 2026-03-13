class CoachingSession {
  final String id;
  final String enterpriseId;
  final String enterpriseName;
  final String coachId;
  final String coachName;
  final DateTime scheduledDate;
  final DateTime? actualDate;
  final String type;
  final String notes;
  final List<String> recommendations;
  final int photoCount;
  final bool followUpRequired;
  final DateTime? nextSessionDate;

  CoachingSession({
    required this.id,
    required this.enterpriseId,
    required this.enterpriseName,
    required this.coachId,
    required this.coachName,
    required this.scheduledDate,
    this.actualDate,
    required this.type,
    required this.notes,
    required this.recommendations,
    required this.photoCount,
    required this.followUpRequired,
    this.nextSessionDate,
  });

  bool get isCompleted => actualDate != null;
  String get status => isCompleted ? 'Completed' : 'Upcoming';

  Map<String, dynamic> toMap() {
    return {
      'enterpriseId': enterpriseId,
      'enterpriseName': enterpriseName,
      'coachId': coachId,
      'coachName': coachName,
      'scheduledDate': scheduledDate.toIso8601String(),
      'actualDate': actualDate?.toIso8601String(),
      'type': type,
      'notes': notes,
      'recommendations': recommendations,
      'photoCount': photoCount,
      'followUpRequired': followUpRequired,
      'nextSessionDate': nextSessionDate?.toIso8601String(),
    };
  }

  factory CoachingSession.fromMap(String id, Map<String, dynamic> map) {
    return CoachingSession(
      id: id,
      enterpriseId: map['enterpriseId'] ?? '',
      enterpriseName: map['enterpriseName'] ?? '',
      coachId: map['coachId'] ?? '',
      coachName: map['coachName'] ?? '',
      scheduledDate: DateTime.parse(map['scheduledDate'] ?? DateTime.now().toIso8601String()),
      actualDate: map['actualDate'] != null ? DateTime.parse(map['actualDate']) : null,
      type: map['type'] ?? '',
      notes: map['notes'] ?? '',
      recommendations: List<String>.from(map['recommendations'] ?? []),
      photoCount: map['photoCount'] ?? 0,
      followUpRequired: map['followUpRequired'] ?? false,
      nextSessionDate: map['nextSessionDate'] != null ? DateTime.parse(map['nextSessionDate']) : null,
    );
  }
}
