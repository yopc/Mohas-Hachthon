import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mohas/models/security_model.dart';
import '../models/coach_model.dart';
import 'security_service.dart';

class CoachService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SecurityService _securityService = SecurityService();
  final String collectionName = 'coaches';

  Future<String> registerCoach(CoachModel coach) async {
    try {
      final usernameQuery = await _firestore
          .collection(collectionName)
          .where('username', isEqualTo: coach.username)
          .get();
      
      if (usernameQuery.docs.isNotEmpty) {
        throw Exception('Username already exists');
      }

      final emailQuery = await _firestore
          .collection(collectionName)
          .where('email', isEqualTo: coach.email)
          .get();
      
      if (emailQuery.docs.isNotEmpty) {
        throw Exception('Email already exists');
      }

      DocumentReference docRef = await _firestore
          .collection(collectionName)
          .add(coach.toMap());
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to register coach: $e');
    }
  }

  Future<Map<String, String>> registerCoachWithSecurity(CoachModel coach) async {
    try {
      final batch = _firestore.batch();
      
      final usernameQuery = await _firestore
          .collection(collectionName)
          .where('username', isEqualTo: coach.username)
          .get();
      
      if (usernameQuery.docs.isNotEmpty) {
        throw Exception('Username already exists');
      }

      final emailQuery = await _firestore
          .collection(collectionName)
          .where('email', isEqualTo: coach.email)
          .get();
      
      if (emailQuery.docs.isNotEmpty) {
        throw Exception('Email already exists');
      }

      final coachRef = _firestore.collection(collectionName).doc();
      
      batch.set(coachRef, coach.copyWith(id: coachRef.id).toMap());

      final securityModel = SecurityModel(
        coachId: coachRef.id,
        registeredDevice: null,
        trustedDevices: [],
        lastLoginSecurity: null,
        loginHistory: [],
        twoFactorEnabled: false,
        securityLevel: 'standard',
        securitySettings: {
          'deviceVerification': true,
          'locationTracking': true,
          'sessionTimeout': 30,
          'maxSessions': 3
        },
      );

      final securityRef = _firestore.collection('security').doc();
      batch.set(securityRef, securityModel.copyWith(id: securityRef.id).toMap());

      batch.update(coachRef, {'securityId': securityRef.id});

      await batch.commit();

      return {
        'coachId': coachRef.id,
        'securityId': securityRef.id,
      };
    } catch (e) {
      throw Exception('Failed to register coach with security: $e');
    }
  }

  Stream<List<CoachModel>> getCoaches() {
    return _firestore
        .collection(collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CoachModel.fromFirestore(doc))
              .toList();
        });
  }

  Future<CoachModel?> getCoachById(String coachId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(collectionName)
          .doc(coachId)
          .get();
      
      if (doc.exists) {
        return CoachModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get coach: $e');
    }
  }

  Future<Map<String, dynamic>?> getCoachWithSecurity(String coachId) async {
    try {
      final coach = await getCoachById(coachId);
      if (coach == null) return null;

      SecurityModel? security;
      if (coach.securityId != null) {
        security = await _securityService.getSecurityByCoachId(coachId);
      }

      return {
        'coach': coach,
        'security': security,
      };
    } catch (e) {
      throw Exception('Failed to get coach with security: $e');
    }
  }

  Future<void> updateCoach(String coachId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = Timestamp.now();
      await _firestore
          .collection(collectionName)
          .doc(coachId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update coach: $e');
    }
  }
}