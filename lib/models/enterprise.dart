class Enterprise {
  final String id;
  final String businessName;
  final String ownerName;
  final String sector;
  final String location;
  final String phone;
  final String status;
  final DateTime registrationDate;
  final Map<String, double> scores;
  final List<String> priorities;
  final String? imageUrl;

  Enterprise({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.sector,
    required this.location,
    required this.phone,
    required this.status,
    required this.registrationDate,
    required this.scores,
    required this.priorities,
    this.imageUrl,
  });

  double get financeScore => scores['finance'] ?? 0;
  double get marketingScore => scores['marketing'] ?? 0;
  double get operationsScore => scores['operations'] ?? 0;
  double get hrScore => scores['hr'] ?? 0;
  double get governanceScore => scores['governance'] ?? 0;
  double get overallScore => 
      (financeScore + marketingScore + operationsScore + hrScore + governanceScore) / 5;
}