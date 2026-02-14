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
}