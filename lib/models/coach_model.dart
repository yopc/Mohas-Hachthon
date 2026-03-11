import 'package:cloud_firestore/cloud_firestore.dart';

class CoachModel {
  // ... existing fields ...
  final String? id;
  final String fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String phone;
  final String email;
  final String nationalId;
  final String? profilePictureBase64;

  final String educationLevel;
  final String? educationOther;
  final String fieldOfStudy;
  final String? fieldOfStudyOther;
  final int yearsOfExperience;
  final bool hasCertification;
  final String? certificationBase64;
  final String? certificationFileName;
  final String region;
  final String zone;

  final String accountStatus;
  final String assignedSupervisor;
  final String role;

  // --- New permission flag ---
  final bool canCreateEnterprises;

  final String? securityId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CoachModel({
    this.id,
    required this.fullName,
    this.gender,
    this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.nationalId,
    this.profilePictureBase64,
    required this.educationLevel,
    this.educationOther,
    required this.fieldOfStudy,
    this.fieldOfStudyOther,
    required this.yearsOfExperience,
    required this.hasCertification,
    this.certificationBase64,
    this.certificationFileName,
    required this.region,
    required this.zone,
    required this.accountStatus,
    required this.assignedSupervisor,
    required this.role,
    this.canCreateEnterprises = true, // default true
    this.securityId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'phone': phone,
      'email': email,
      'nationalId': nationalId,
      'profilePictureBase64': profilePictureBase64,
      'educationLevel': educationLevel,
      'educationOther': educationOther,
      'fieldOfStudy': fieldOfStudy,
      'fieldOfStudyOther': fieldOfStudyOther,
      'yearsOfExperience': yearsOfExperience,
      'hasCertification': hasCertification,
      'certificationBase64': certificationBase64,
      'certificationFileName': certificationFileName,
      'region': region,
      'zone': zone,
      'accountStatus': accountStatus,
      'assignedSupervisor': assignedSupervisor,
      'role': role,
      'canCreateEnterprises': canCreateEnterprises,
      'securityId': securityId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory CoachModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CoachModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      gender: data['gender'],
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate(),
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      nationalId: data['nationalId'] ?? '',
      profilePictureBase64: data['profilePictureBase64'],
      educationLevel: data['educationLevel'] ?? '',
      educationOther: data['educationOther'],
      fieldOfStudy: data['fieldOfStudy'] ?? '',
      fieldOfStudyOther: data['fieldOfStudyOther'],
      yearsOfExperience: data['yearsOfExperience'] ?? 0,
      hasCertification: data['hasCertification'] ?? false,
      certificationBase64: data['certificationBase64'],
      certificationFileName: data['certificationFileName'],
      region: data['region'] ?? '',
      zone: data['zone'] ?? '',
      accountStatus: data['accountStatus'] ?? 'Active',
      assignedSupervisor: data['assignedSupervisor'] ?? '',
      role: data['role'] ?? 'coach',
      canCreateEnterprises: data['canCreateEnterprises'] ?? true,
      securityId: data['securityId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  CoachModel copyWith({
    String? id,
    String? fullName,
    String? gender,
    DateTime? dateOfBirth,
    String? phone,
    String? email,
    String? nationalId,
    String? profilePictureBase64,
    String? educationLevel,
    String? educationOther,
    String? fieldOfStudy,
    String? fieldOfStudyOther,
    int? yearsOfExperience,
    bool? hasCertification,
    String? certificationBase64,
    String? certificationFileName,
    String? region,
    String? zone,
    String? accountStatus,
    String? assignedSupervisor,
    String? role,
    bool? canCreateEnterprises,
    String? securityId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoachModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      profilePictureBase64: profilePictureBase64 ?? this.profilePictureBase64,
      educationLevel: educationLevel ?? this.educationLevel,
      educationOther: educationOther ?? this.educationOther,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      fieldOfStudyOther: fieldOfStudyOther ?? this.fieldOfStudyOther,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      hasCertification: hasCertification ?? this.hasCertification,
      certificationBase64: certificationBase64 ?? this.certificationBase64,
      certificationFileName:
          certificationFileName ?? this.certificationFileName,
      region: region ?? this.region,
      zone: zone ?? this.zone,
      accountStatus: accountStatus ?? this.accountStatus,
      assignedSupervisor: assignedSupervisor ?? this.assignedSupervisor,
      role: role ?? this.role,
      canCreateEnterprises: canCreateEnterprises ?? this.canCreateEnterprises,
      securityId: securityId ?? this.securityId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
