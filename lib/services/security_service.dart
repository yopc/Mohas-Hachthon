import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/security_model.dart';

class SecurityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'security';

  Future<String> createSecurityRecord(SecurityModel security) async {
    try {
      final existingQuery = await _firestore
          .collection(collectionName)
          .where('coachId', isEqualTo: security.coachId)
          .get();
      
      if (existingQuery.docs.isNotEmpty) {
        throw Exception('Security record already exists for this coach');
      }

      DocumentReference docRef = await _firestore
          .collection(collectionName)
          .add(security.toMap());
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create security record: $e');
    }
  }

  Future<SecurityModel?> getSecurityByCoachId(String coachId) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('coachId', isEqualTo: coachId)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return SecurityModel.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get security record: $e');
    }
  }

  Future<SecurityModel?> getSecurityById(String securityId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(collectionName)
          .doc(securityId)
          .get();
      
      if (doc.exists) {
        return SecurityModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get security record: $e');
    }
  }

  Future<void> updateSecurity(String securityId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = Timestamp.now();
      await _firestore
          .collection(collectionName)
          .doc(securityId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update security record: $e');
    }
  }

  Future<void> addLoginHistory(String coachId, Map<String, dynamic> loginData) async {
    try {
      final security = await getSecurityByCoachId(coachId);
      if (security == null) throw Exception('Security record not found');

      final updatedHistory = List<Map<String, dynamic>>.from(security.loginHistory)
        ..insert(0, {
          ...loginData,
          'timestamp': Timestamp.now(),
        });

      if (updatedHistory.length > 50) {
        updatedHistory.removeRange(50, updatedHistory.length);
      }

      await _firestore
          .collection(collectionName)
          .doc(security.id)
          .update({
            'loginHistory': updatedHistory,
            'lastLoginSecurity': {
              ...loginData,
              'timestamp': Timestamp.now(),
            },
            'updatedAt': Timestamp.now(),
          });
    } catch (e) {
      throw Exception('Failed to add login history: $e');
    }
  }

  Future<void> registerDevice(String coachId, String deviceId) async {
    try {
      final security = await getSecurityByCoachId(coachId);
      if (security == null) throw Exception('Security record not found');

      final updatedDevices = List<String>.from(security.trustedDevices);
      if (!updatedDevices.contains(deviceId)) {
        updatedDevices.add(deviceId);
      }

      await _firestore
          .collection(collectionName)
          .doc(security.id)
          .update({
            'registeredDevice': deviceId,
            'trustedDevices': updatedDevices,
            'updatedAt': Timestamp.now(),
          });
    } catch (e) {
      throw Exception('Failed to register device: $e');
    }
  }

  Future<void> updateSecuritySettings(String coachId, Map<String, dynamic> newSettings) async {
    try {
      final security = await getSecurityByCoachId(coachId);
      if (security == null) throw Exception('Security record not found');

      final updatedSettings = Map<String, dynamic>.from(security.securitySettings)
        ..addAll(newSettings);

      await _firestore
          .collection(collectionName)
          .doc(security.id)
          .update({
            'securitySettings': updatedSettings,
            'updatedAt': Timestamp.now(),
          });
    } catch (e) {
      throw Exception('Failed to update security settings: $e');
    }
  }

  Future<void> toggleTwoFactor(String coachId, bool enabled) async {
    try {
      final security = await getSecurityByCoachId(coachId);
      if (security == null) throw Exception('Security record not found');

      await _firestore
          .collection(collectionName)
          .doc(security.id)
          .update({
            'twoFactorEnabled': enabled,
            'updatedAt': Timestamp.now(),
          });
    } catch (e) {
      throw Exception('Failed to toggle two-factor authentication: $e');
    }
  }
}