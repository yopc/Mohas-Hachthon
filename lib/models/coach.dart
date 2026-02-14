class Coach {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String region;
  final String profileImage;
  final int enterprisesCount;
  final int sessionsThisMonth;
  final double performanceScore;
  final List<String> specializations;

  Coach({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.region,
    required this.profileImage,
    required this.enterprisesCount,
    required this.sessionsThisMonth,
    required this.performanceScore,
    required this.specializations,
  });
}