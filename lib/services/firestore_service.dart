// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/enterprise.dart';
// import '../models/assessment.dart';
// import '../models/session.dart';
// import '../models/iap.dart';
// import '../models/training.dart';
// import '../models/attendance.dart';
// import '../models/feedback.dart';
// import '../models/evidence.dart';
// import '../models/qc_check.dart';
// import '../models/graduation_checklist.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // ==================== USER MANAGEMENT ====================
//   Future<void> createUserData(String uid, Map<String, dynamic> userData) async {
//     await _firestore.collection('users').doc(uid).set(userData);
//   }

//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
//     return doc.data() as Map<String, dynamic>?;
//   }

//   Future<void> updateUserData(String uid, Map<String, dynamic> updates) async {
//     await _firestore.collection('users').doc(uid).update(updates);
//   }

//   // ==================== ENTERPRISES ====================
//   Stream<List<Enterprise>> getEnterprisesStream({String? role, String? coachId}) {
//     String? uid = _auth.currentUser?.uid;
//     if (uid == null) return Stream.value([]);
    
//     // If role is supervisor, return all enterprises (no filter)
//     if (role == 'supervisor') {
//       return _firestore
//           .collection('enterprises')
//           .snapshots()
//           .map((snapshot) => snapshot.docs
//               .map((doc) => Enterprise.fromMap(doc.id, doc.data()))
//               .toList());
//     }
    
//     // Otherwise filter by coachId
//     final queryCoachId = coachId ?? uid;
//     return _firestore
//         .collection('enterprises')
//         .where('coachId', isEqualTo: queryCoachId)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => Enterprise.fromMap(doc.id, doc.data()))
//             .toList());
//   }

//   Future<void> addEnterprise(Enterprise enterprise) async {
//     await _firestore.collection('enterprises').add(enterprise.toMap());
//   }

//   Future<void> updateEnterprise(String id, Map<String, dynamic> data) async {
//     await _firestore.collection('enterprises').doc(id).update(data);
//   }

//   Future<void> deleteEnterprise(String id) async {
//     await _firestore.collection('enterprises').doc(id).delete();
//   }

//   // ==================== ASSESSMENTS ====================
//   Stream<List<Assessment>> getAssessmentsStream() {
//     String? uid = _auth.currentUser?.uid;
//     if (uid == null) return Stream.value([]);
//     return _firestore
//         .collection('assessments')
//         .where('coachId', isEqualTo: uid)
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => Assessment.fromMap(doc.id, doc.data()))
//             .toList());
//   }

//   Future<void> addAssessment(Assessment assessment) async {
//     final docRef = await _firestore.collection('assessments').add(assessment.toMap());
//     // Create QC check for baseline
//     if (assessment.type == 'Baseline') {
//       await createQcCheck('baseline_form', docRef.id);
//     }
//   }

//   Future<void> updateAssessment(String id, Map<String, dynamic> data) async {
//     await _firestore.collection('assessments').doc(id).update(data);
//   }

//   Future<void> deleteAssessment(String id) async {
//     await _firestore.collection('assessments').doc(id).delete();
//   }

//   Future<Assessment?> getBaselineForEnterprise(String enterpriseId) async {
//     final snapshot = await _firestore
//         .collection('assessments')
//         .where('enterpriseId', isEqualTo: enterpriseId)
//         .where('type', isEqualTo: 'Baseline')
//         .limit(1)
//         .get();
//     if (snapshot.docs.isEmpty) return null;
//     return Assessment.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
//   }

//   // ==================== COACHING SESSIONS ====================
//   Stream<List<CoachingSession>> getSessionsStream() {
//     String? uid = _auth.currentUser?.uid;
//     if (uid == null) return Stream.value([]);
//     return _firestore
//         .collection('sessions')
//         .where('coachId', isEqualTo: uid)
//         .orderBy('scheduledDate', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => CoachingSession.fromMap(doc.id, doc.data()))
//             .toList());
//   }

//   Future<void> addSession(CoachingSession session) async {
//     await _firestore.collection('sessions').add(session.toMap());
//   }

//   Future<void> updateSession(String id, Map<String, dynamic> data) async {
//     await _firestore.collection('sessions').doc(id).update(data);
//   }

//   Future<void> deleteSession(String id) async {
//     await _firestore.collection('sessions').doc(id).delete();
//   }

//   // ==================== IAP (INDIVIDUAL ACTION PLAN) ====================
//   Future<Iap?> getIap(String enterpriseId) async {
//     final snapshot = await _firestore
//         .collection('iaps')
//         .where('enterpriseId', isEqualTo: enterpriseId)
//         .limit(1)
//         .get();
//     if (snapshot.docs.isEmpty) return null;
//     return Iap.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
//   }

//   Future<void> saveIap(Iap iap) async {
//     final data = iap.toMap();
//     if (iap.id.isEmpty) {
//       await _firestore.collection('iaps').add(data);
//     } else {
//       await _firestore.collection('iaps').doc(iap.id).update(data);
//     }
//   }

//   Future<void> updateIapTaskStatus(String iapId, String taskId, String newStatus) async {
//     final docRef = _firestore.collection('iaps').doc(iapId);
//     final doc = await docRef.get();
//     final data = doc.data()!;
//     final tasks = List<Map<String, dynamic>>.from(data['tasks'] ?? []);
//     final index = tasks.indexWhere((t) => t['id'] == taskId);
//     if (index != -1) {
//       tasks[index]['status'] = newStatus;
//       if (newStatus == 'done') {
//         tasks[index]['completedAt'] = Timestamp.now();
//       }
//       await docRef.update({'tasks': tasks, 'updatedAt': Timestamp.now()});
//     }
//   }

//   // ==================== TRAINING ====================
//   Stream<List<Training>> getTrainingsStream() {
//     return _firestore
//         .collection('trainings')
//         .snapshots()
//         .map((snapshot) =>
//             snapshot.docs.map((doc) => Training.fromMap(doc.id, doc.data())).toList());
//   }

//   Future<void> addTraining(Training training) async {
//     await _firestore.collection('trainings').add(training.toMap());
//   }

//   Future<void> markAttendance(
//       String trainingId, String enterpriseId, String attendeeName, bool qrScanned) async {
//     final attendance = Attendance(
//       id: '',
//       trainingId: trainingId,
//       enterpriseId: enterpriseId,
//       attendeeName: attendeeName,
//       present: true,
//       checkedInAt: DateTime.now(),
//       qrCodeScanned: qrScanned,
//     );
//     await _firestore.collection('attendance').add(attendance.toMap());
//   }

//   // ==================== FEEDBACK ====================
//   Future<void> addFeedback(Feedback feedback) async {
//     await _firestore.collection('feedback').add(feedback.toMap());
//   }

//   // ==================== EVIDENCE ====================
//   Stream<List<Evidence>> getEvidenceStream(String enterpriseId) {
//     return _firestore
//         .collection('evidence')
//         .where('enterpriseId', isEqualTo: enterpriseId)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) =>
//             snapshot.docs.map((doc) => Evidence.fromMap(doc.id, doc.data())).toList());
//   }
//   Future<Enterprise?> getEnterpriseById(String id) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection('enterprises').doc(id).get();
//       if (doc.exists) {
//         return Enterprise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<void> addEvidence(Evidence evidence) async {
//     await _firestore.collection('evidence').add(evidence.toMap());
//   }

//   // ==================== QC CHECKS ====================
//   Stream<List<QcCheck>> getPendingQcStream() {
//     return _firestore
//         .collection('qc_checks')
//         .where('status', isEqualTo: 'pending')
//         .snapshots()
//         .map((snapshot) =>
//             snapshot.docs.map((doc) => QcCheck.fromMap(doc.id, doc.data())).toList());
//   }

//   Future<void> createQcCheck(String recordType, String recordId) async {
//     final qc = QcCheck(
//       id: '',
//       recordType: recordType,
//       recordId: recordId,
//       checkerId: '',
//       status: 'pending',
//       createdAt: DateTime.now(),
//     );
//     await _firestore.collection('qc_checks').add(qc.toMap());
//   }

//   Future<void> verifyQc(String id, String recordType, String recordId) async {
//     await _firestore.collection('qc_checks').doc(id).update({
//       'status': 'verified',
//     });
//     if (recordType == 'baseline_form') {
//       await _firestore.collection('assessments').doc(recordId).update({
//         'status': 'verified',
//       });
//     } else if (recordType == 'coaching_visit') {
//       await _firestore.collection('sessions').doc(recordId).update({
//         'verified': true,
//       });
//     }
//   }

//   Future<void> requestCorrectionQc(String id, String notes) async {
//     await _firestore.collection('qc_checks').doc(id).update({
//       'status': 'needs_correction',
//       'notes': notes,
//     });
//   }

//   // ==================== GRADUATION ====================
//   Future<GraduationChecklist?> getGraduationChecklist(String enterpriseId) async {
//     final snapshot = await _firestore
//         .collection('graduation_checklists')
//         .where('enterpriseId', isEqualTo: enterpriseId)
//         .limit(1)
//         .get();
//     if (snapshot.docs.isEmpty) return null;
//     return GraduationChecklist.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
//   }

//   Future<void> requestGraduationApproval(String enterpriseId) async {
//     final docRef = _firestore.collection('graduation_checklists').doc(enterpriseId);
//     await docRef.set({
//       'enterpriseId': enterpriseId,
//       'requestedAt': Timestamp.now(),
//       'status': 'pending',
//     }, SetOptions(merge: true));
//   }

//   Future<void> approveGraduation(String enterpriseId) async {
//     final docRef = _firestore.collection('graduation_checklists').doc(enterpriseId);
//     await docRef.update({
//       'mAndEApproved': true,
//       'approvedAt': Timestamp.now(),
//       'approvedBy': _auth.currentUser!.uid,
//     });
//     await _firestore.collection('enterprises').doc(enterpriseId).update({
//       'status': 'Graduated',
//     });
//   }
// }





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/enterprise.dart';
import '../models/assessment.dart';
import '../models/session.dart';
import '../models/iap.dart';
import '../models/training.dart';
import '../models/attendance.dart';
import '../models/feedback.dart';
import '../models/evidence.dart';
import '../models/qc_check.dart';
import '../models/graduation_checklist.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================== USER MANAGEMENT ====================
  Future<void> createUserData(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).set(userData);
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(uid).update(updates);
  }

  // ==================== ENTERPRISES ====================
  Stream<List<Enterprise>> getEnterprisesStream({String? role, String? coachId}) {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    
    // If role is supervisor, return all enterprises (no filter)
    if (role == 'supervisor') {
      return _firestore
          .collection('enterprises')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Enterprise.fromMap(doc.id, doc.data()))
              .toList());
    }
    
    // Otherwise filter by coachId
    final queryCoachId = coachId ?? uid;
    return _firestore
        .collection('enterprises')
        .where('coachId', isEqualTo: queryCoachId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Enterprise.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<Enterprise?> getEnterpriseById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('enterprises').doc(id).get();
      if (doc.exists) {
        return Enterprise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> addEnterprise(Enterprise enterprise) async {
    await _firestore.collection('enterprises').add(enterprise.toMap());
  }

  Future<void> updateEnterprise(String id, Map<String, dynamic> data) async {
    await _firestore.collection('enterprises').doc(id).update(data);
  }

  Future<void> deleteEnterprise(String id) async {
    await _firestore.collection('enterprises').doc(id).delete();
  }

  // ==================== ASSESSMENTS ====================
  Stream<List<Assessment>> getAssessmentsStream() {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _firestore
        .collection('assessments')
        .where('coachId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Assessment.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addAssessment(Assessment assessment) async {
    final docRef = await _firestore.collection('assessments').add(assessment.toMap());
    // Create QC check for baseline
    if (assessment.type == 'Baseline') {
      await createQcCheck('baseline_form', docRef.id);
    }
  }

  Future<void> updateAssessment(String id, Map<String, dynamic> data) async {
    await _firestore.collection('assessments').doc(id).update(data);
  }

  Future<void> deleteAssessment(String id) async {
    await _firestore.collection('assessments').doc(id).delete();
  }

  Future<Assessment?> getBaselineForEnterprise(String enterpriseId) async {
    final snapshot = await _firestore
        .collection('assessments')
        .where('enterpriseId', isEqualTo: enterpriseId)
        .where('type', isEqualTo: 'Baseline')
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Assessment.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
  }

  // ==================== COACHING SESSIONS ====================
  Stream<List<CoachingSession>> getSessionsStream() {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _firestore
        .collection('sessions')
        .where('coachId', isEqualTo: uid)
        .orderBy('scheduledDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CoachingSession.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addSession(CoachingSession session) async {
    await _firestore.collection('sessions').add(session.toMap());
  }

  Future<void> updateSession(String id, Map<String, dynamic> data) async {
    await _firestore.collection('sessions').doc(id).update(data);
  }

  Future<void> deleteSession(String id) async {
    await _firestore.collection('sessions').doc(id).delete();
  }

  // ==================== IAP (INDIVIDUAL ACTION PLAN) ====================
  Future<Iap?> getIap(String enterpriseId) async {
    final snapshot = await _firestore
        .collection('iaps')
        .where('enterpriseId', isEqualTo: enterpriseId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Iap.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
  }

  Future<void> saveIap(Iap iap) async {
    final data = iap.toMap();
    if (iap.id.isEmpty) {
      await _firestore.collection('iaps').add(data);
    } else {
      await _firestore.collection('iaps').doc(iap.id).update(data);
    }
  }

  Future<void> updateIapTaskStatus(String iapId, String taskId, String newStatus) async {
    final docRef = _firestore.collection('iaps').doc(iapId);
    final doc = await docRef.get();
    final data = doc.data()!;
    final tasks = List<Map<String, dynamic>>.from(data['tasks'] ?? []);
    final index = tasks.indexWhere((t) => t['id'] == taskId);
    if (index != -1) {
      tasks[index]['status'] = newStatus;
      if (newStatus == 'done') {
        tasks[index]['completedAt'] = Timestamp.now();
      }
      await docRef.update({'tasks': tasks, 'updatedAt': Timestamp.now()});
    }
  }

  // ==================== TRAINING ====================
  Stream<List<Training>> getTrainingsStream() {
    return _firestore
        .collection('trainings')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Training.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addTraining(Training training) async {
    await _firestore.collection('trainings').add(training.toMap());
  }

  Future<void> markAttendance(
      String trainingId, String enterpriseId, String attendeeName, bool qrScanned) async {
    final attendance = Attendance(
      id: '',
      trainingId: trainingId,
      enterpriseId: enterpriseId,
      attendeeName: attendeeName,
      present: true,
      checkedInAt: DateTime.now(),
      qrCodeScanned: qrScanned,
    );
    await _firestore.collection('attendance').add(attendance.toMap());
  }

  // ==================== FEEDBACK ====================
  Future<void> addFeedback(Feedback feedback) async {
    await _firestore.collection('feedback').add(feedback.toMap());
  }

  // ==================== EVIDENCE ====================
  Stream<List<Evidence>> getEvidenceStream(String enterpriseId) {
    return _firestore
        .collection('evidence')
        .where('enterpriseId', isEqualTo: enterpriseId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Evidence.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addEvidence(Evidence evidence) async {
    await _firestore.collection('evidence').add(evidence.toMap());
  }

  // ==================== QC CHECKS ====================
  Stream<List<QcCheck>> getPendingQcStream() {
    return _firestore
        .collection('qc_checks')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => QcCheck.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> createQcCheck(String recordType, String recordId) async {
    final qc = QcCheck(
      id: '',
      recordType: recordType,
      recordId: recordId,
      checkerId: '',
      status: 'pending',
      createdAt: DateTime.now(),
    );
    await _firestore.collection('qc_checks').add(qc.toMap());
  }

  Future<void> verifyQc(String id, String recordType, String recordId) async {
    await _firestore.collection('qc_checks').doc(id).update({
      'status': 'verified',
    });
    if (recordType == 'baseline_form') {
      await _firestore.collection('assessments').doc(recordId).update({
        'status': 'verified',
      });
    } else if (recordType == 'coaching_visit') {
      await _firestore.collection('sessions').doc(recordId).update({
        'verified': true,
      });
    }
  }

  Future<void> requestCorrectionQc(String id, String notes) async {
    await _firestore.collection('qc_checks').doc(id).update({
      'status': 'needs_correction',
      'notes': notes,
    });
  }

  // ==================== GRADUATION ====================
  Future<GraduationChecklist?> getGraduationChecklist(String enterpriseId) async {
    final snapshot = await _firestore
        .collection('graduation_checklists')
        .where('enterpriseId', isEqualTo: enterpriseId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return GraduationChecklist.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
  }

  Future<void> requestGraduationApproval(String enterpriseId) async {
    final docRef = _firestore.collection('graduation_checklists').doc(enterpriseId);
    await docRef.set({
      'enterpriseId': enterpriseId,
      'requestedAt': Timestamp.now(),
      'status': 'pending',
    }, SetOptions(merge: true));
  }

  Future<void> approveGraduation(String enterpriseId) async {
    final docRef = _firestore.collection('graduation_checklists').doc(enterpriseId);
    await docRef.update({
      'mAndEApproved': true,
      'approvedAt': Timestamp.now(),
      'approvedBy': _auth.currentUser!.uid,
    });
    await _firestore.collection('enterprises').doc(enterpriseId).update({
      'status': 'Graduated',
    });
  }
}