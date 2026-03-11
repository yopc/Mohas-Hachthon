import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mohas/models/security_model.dart';
import '../models/coach_model.dart';
import 'security_service.dart';

class CoachService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SecurityService _securityService = SecurityService();
  final String collectionName = 'coaches';

<<<<<<< HEAD
 Future<String> registerCoach(CoachModel coach) async {
  try {
    // Check if email already exists
    final emailQuery = await _firestore
        .collection(collectionName)
        .where('email', isEqualTo: coach.email)
        .get();
    
    if (emailQuery.docs.isNotEmpty) {
      throw Exception('Email already exists');
    }

    // Log that we're saving with base64 data
    print('Saving coach with profile picture: ${coach.profilePictureBase64 != null}');
    print('Saving coach with certification: ${coach.certificationBase64 != null}');

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
      
      // Check if email already exists
=======
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

>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
      final emailQuery = await _firestore
          .collection(collectionName)
          .where('email', isEqualTo: coach.email)
          .get();
      
      if (emailQuery.docs.isNotEmpty) {
        throw Exception('Email already exists');
      }

<<<<<<< HEAD
      // Create coach document
      final coachRef = _firestore.collection(collectionName).doc();
      
      // Create coach with id
      final coachWithId = CoachModel(
        id: coachRef.id,
        fullName: coach.fullName,
        gender: coach.gender,
        dateOfBirth: coach.dateOfBirth,
        phone: coach.phone,
        email: coach.email,
        nationalId: coach.nationalId,
        profilePictureBase64: coach.profilePictureBase64,
        educationLevel: coach.educationLevel,
        educationOther: coach.educationOther,
        fieldOfStudy: coach.fieldOfStudy,
        fieldOfStudyOther: coach.fieldOfStudyOther,
        yearsOfExperience: coach.yearsOfExperience,
        hasCertification: coach.hasCertification,
        certificationBase64: coach.certificationBase64,
        certificationFileName: coach.certificationFileName,
        region: coach.region,
        zone: coach.zone,
        accountStatus: coach.accountStatus,
        assignedSupervisor: coach.assignedSupervisor,
        role: coach.role,
        canCreateEnterprises: coach.canCreateEnterprises,
        securityId: null, // Will be updated after security creation
        createdAt: coach.createdAt,
        updatedAt: coach.updatedAt,
      );
      
      batch.set(coachRef, coachWithId.toMap());

      // Create security record
=======
      final coachRef = _firestore.collection(collectionName).doc();
      
      batch.set(coachRef, coach.copyWith(id: coachRef.id).toMap());

>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
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
<<<<<<< HEAD
      batch.set(securityRef, securityModel.toMap());

      // Update coach with securityId
=======
      batch.set(securityRef, securityModel.copyWith(id: securityRef.id).toMap());

>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
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

<<<<<<< HEAD
  Stream<List<CoachModel>> getActiveCoaches() {
    return _firestore
        .collection(collectionName)
        .where('accountStatus', isEqualTo: 'Active')
        .orderBy('fullName')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CoachModel.fromFirestore(doc))
              .toList();
        });
  }

=======
>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
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
<<<<<<< HEAD
        security = await _securityService.getSecurityById(coach.securityId!);
=======
        security = await _securityService.getSecurityByCoachId(coachId);
>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
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
<<<<<<< HEAD

  Future<void> deactivateCoach(String coachId) async {
    try {
      await _firestore.collection(collectionName).doc(coachId).update({
        'accountStatus': 'Inactive',
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to deactivate coach: $e');
    }
  }
=======
>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
}