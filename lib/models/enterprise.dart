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
  final String? coachId;
  final double? baselineMonthlyRevenue;
  final double? currentMonthlyRevenue;
  final int? baselineEmployees;
  final int? currentEmployees;

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
    this.coachId,
    this.baselineMonthlyRevenue,
    this.currentMonthlyRevenue,
    this.baselineEmployees,
    this.currentEmployees,
  });

  double get financeScore => scores['finance'] ?? 0;
  double get marketingScore => scores['marketing'] ?? 0;
  double get operationsScore => scores['operations'] ?? 0;
  double get hrScore => scores['hr'] ?? 0;
  double get governanceScore => scores['governance'] ?? 0;
  double get overallScore =>
      (financeScore + marketingScore + operationsScore + hrScore + governanceScore) / 5;

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'ownerName': ownerName,
      'sector': sector,
      'location': location,
      'phone': phone,
      'status': status,
      'registrationDate': registrationDate.toIso8601String(),
      'scores': scores,
      'priorities': priorities,
      'imageUrl': imageUrl,
      'coachId': coachId,
      'baselineMonthlyRevenue': baselineMonthlyRevenue,
      'currentMonthlyRevenue': currentMonthlyRevenue,
      'baselineEmployees': baselineEmployees,
      'currentEmployees': currentEmployees,
    };
  }

  factory Enterprise.fromMap(String id, Map<String, dynamic> map) {
    return Enterprise(
      id: id,
      businessName: map['businessName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      sector: map['sector'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'] ?? '',
      status: map['status'] ?? 'Active',
      registrationDate: DateTime.parse(map['registrationDate'] ?? DateTime.now().toIso8601String()),
      scores: Map<String, double>.from(map['scores'] ?? {}),
      priorities: List<String>.from(map['priorities'] ?? []),
      imageUrl: map['imageUrl'],
      coachId: map['coachId'],
      baselineMonthlyRevenue: (map['baselineMonthlyRevenue'] as num?)?.toDouble(),
      currentMonthlyRevenue: (map['currentMonthlyRevenue'] as num?)?.toDouble(),
      baselineEmployees: map['baselineEmployees'] as int?,
      currentEmployees: map['currentEmployees'] as int?,
    );
  }
}