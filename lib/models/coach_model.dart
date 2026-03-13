class CoachModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String region;
  final List<String> specializations;
  final int enterprisesCount;
  final int sessionsThisMonth;
  final double performanceScore;
  final String? profileImage;

  CoachModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.region,
    required this.specializations,
    this.enterprisesCount = 0,
    this.sessionsThisMonth = 0,
    this.performanceScore = 0,
    this.profileImage,
  });

  factory CoachModel.fromMap(Map<String, dynamic> map) {
    return CoachModel(
      id: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      region: map['region'] ?? '',
      specializations: List<String>.from(map['specializations'] ?? []),
      enterprisesCount: map['enterprisesCount'] ?? 0,
      sessionsThisMonth: map['sessionsThisMonth'] ?? 0,
      performanceScore: (map['performanceScore'] ?? 0).toDouble(),
      profileImage: map['profileImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'region': region,
      'specializations': specializations,
      'enterprisesCount': enterprisesCount,
      'sessionsThisMonth': sessionsThisMonth,
      'performanceScore': performanceScore,
      'profileImage': profileImage,
    };
  }
}
