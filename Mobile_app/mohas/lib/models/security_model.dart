import 'package:cloud_firestore/cloud_firestore.dart';

class SecurityModel {
  final String? id;
  final String coachId;
  final String? registeredDevice;
  final List<String> trustedDevices;
  final Map<String, dynamic>? lastLoginSecurity;
  final List<Map<String, dynamic>> loginHistory;
  final bool twoFactorEnabled;
  final String securityLevel;
  final Map<String, dynamic> securitySettings;
  final DateTime createdAt;
  final DateTime updatedAt;

  SecurityModel({
    this.id,
    required this.coachId,
    this.registeredDevice,
    List<String>? trustedDevices,
    this.lastLoginSecurity,
    List<Map<String, dynamic>>? loginHistory,
    bool? twoFactorEnabled,
    String? securityLevel,
    Map<String, dynamic>? securitySettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    trustedDevices = trustedDevices ?? [],
    loginHistory = loginHistory ?? [],
    twoFactorEnabled = twoFactorEnabled ?? false,
    securityLevel = securityLevel ?? 'standard',
    securitySettings = securitySettings ?? {
      'deviceVerification': true,
      'locationTracking': true,
      'sessionTimeout': 30,
      'maxSessions': 3
    },
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'coachId': coachId,
      'registeredDevice': registeredDevice,
      'trustedDevices': trustedDevices,
      'lastLoginSecurity': lastLoginSecurity,
      'loginHistory': loginHistory,
      'twoFactorEnabled': twoFactorEnabled,
      'securityLevel': securityLevel,
      'securitySettings': securitySettings,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory SecurityModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return SecurityModel(
      id: doc.id,
      coachId: data['coachId'] ?? '',
      registeredDevice: data['registeredDevice'],
      trustedDevices: List<String>.from(data['trustedDevices'] ?? []),
      lastLoginSecurity: data['lastLoginSecurity'],
      loginHistory: List<Map<String, dynamic>>.from(data['loginHistory'] ?? []),
      twoFactorEnabled: data['twoFactorEnabled'] ?? false,
      securityLevel: data['securityLevel'] ?? 'standard',
      securitySettings: Map<String, dynamic>.from(data['securitySettings'] ?? {
        'deviceVerification': true,
        'locationTracking': true,
        'sessionTimeout': 30,
        'maxSessions': 3
      }),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  SecurityModel copyWith({
    String? id,
    String? coachId,
    String? registeredDevice,
    List<String>? trustedDevices,
    Map<String, dynamic>? lastLoginSecurity,
    List<Map<String, dynamic>>? loginHistory,
    bool? twoFactorEnabled,
    String? securityLevel,
    Map<String, dynamic>? securitySettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SecurityModel(
      id: id ?? this.id,
      coachId: coachId ?? this.coachId,
      registeredDevice: registeredDevice ?? this.registeredDevice,
      trustedDevices: trustedDevices ?? this.trustedDevices,
      lastLoginSecurity: lastLoginSecurity ?? this.lastLoginSecurity,
      loginHistory: loginHistory ?? this.loginHistory,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      securityLevel: securityLevel ?? this.securityLevel,
      securitySettings: securitySettings ?? this.securitySettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}