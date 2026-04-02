class Coach {
  final String? id;
  final String fullName;
  final String gender;
  final DateTime? dateOfBirth;
  final String phone;
  final String email;
  final String nationalId;
  final String educationLevel;
  final String? educationOther;
  final String fieldOfStudy;
  final String? fieldOfStudyOther;
  final int yearsOfExperience;
  final bool hasCertification;
  final String? certificationUrl;
  final String region;
  final String zone;
  final String? role;
  final String username;
  final String password;
  final String accountStatus;
  final String supervisorId;
  final String supervisorName;
  final DateTime createdAt;
  final bool isFirstLogin;

  Coach({
    this.id,
    this.role,
    required this.fullName,
    required this.gender,
    this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.nationalId,
    required this.educationLevel,
    this.educationOther,
    required this.fieldOfStudy,
    this.fieldOfStudyOther,
    required this.yearsOfExperience,
    required this.hasCertification,
    this.certificationUrl,
    required this.region,
    required this.zone,
    required this.username,
    required this.password,
    required this.accountStatus,
    required this.supervisorId,
    required this.supervisorName,
    required this.createdAt,
    this.isFirstLogin = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phone': phone,
      'email': email,
      'nationalId': nationalId,
      'educationLevel': educationLevel,
      'educationOther': educationOther,
      'fieldOfStudy': fieldOfStudy,
      'fieldOfStudyOther': fieldOfStudyOther,
      'yearsOfExperience': yearsOfExperience,
      'hasCertification': hasCertification,
      'certificationUrl': certificationUrl,
      'region': region,
      'zone': zone,
      'username': username,
      'accountStatus': accountStatus,
      'supervisorId': supervisorId,
      'supervisorName': supervisorName,
      'createdAt': createdAt.toIso8601String(),
      'isFirstLogin': isFirstLogin,
      'role': role ?? 'coach',
    };
  }

  factory Coach.fromMap(Map<String, dynamic> map, {String? id}) {
    return Coach(
      id: id ?? map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      nationalId: map['nationalId'] ?? '',
      educationLevel: map['educationLevel'] ?? '',
      educationOther: map['educationOther'],
      fieldOfStudy: map['fieldOfStudy'] ?? '',
      fieldOfStudyOther: map['fieldOfStudyOther'],
      yearsOfExperience: map['yearsOfExperience'] ?? 0,
      hasCertification: map['hasCertification'] ?? false,
      certificationUrl: map['certificationUrl'],
      region: map['region'] ?? '',
      zone: map['zone'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      accountStatus: map['accountStatus'] ?? 'active',
      supervisorId: map['supervisorId'] ?? '',
      supervisorName: map['supervisorName'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      isFirstLogin: map['isFirstLogin'] ?? true,
      role: map['role'] ?? 'coach',
    );
  }

  get performanceScore => null;
}
