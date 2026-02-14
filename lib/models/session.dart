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
}