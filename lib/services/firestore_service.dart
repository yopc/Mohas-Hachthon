// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import '../models/enterprise.dart';
// // import '../models/assessment.dart';
// // import '../models/session.dart';

// // class FirestoreService {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final FirebaseAuth _auth = FirebaseAuth.instance;

// //   Future<void> createUserData(String uid, Map<String, dynamic> userData) async {
// //     await _firestore.collection('users').doc(uid).set(userData);
// //   }

// //   Future<Map<String, dynamic>?> getUserData(String uid) async {
// //     DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
// //     return doc.data() as Map<String, dynamic>?;
// //   }

// //   Future<void> updateUserData(String uid, Map<String, dynamic> updates) async {
// //     await _firestore.collection('users').doc(uid).update(updates);
// //   }

// //   Stream<List<Enterprise>> getEnterprisesStream() {
// //     String? uid = _auth.currentUser?.uid;
// //     if (uid == null) return Stream.value([]);

// //     return _firestore
// //         .collection('enterprises')
// //         .where('coachId', isEqualTo: uid)
// //         .snapshots()
// //         .map((snapshot) {
// //           return snapshot.docs.map((doc) {
// //             return Enterprise.fromMap(doc.id, doc.data());
// //           }).toList();
// //         });
// //   }

// //   Future<void> addEnterprise(Enterprise enterprise) async {
// //     await _firestore.collection('enterprises').add(enterprise.toMap());
// //   }

// //   Future<void> updateEnterprise(String id, Map<String, dynamic> data) async {
// //     await _firestore.collection('enterprises').doc(id).update(data);
// //   }

// //   Future<void> deleteEnterprise(String id) async {
// //     await _firestore.collection('enterprises').doc(id).delete();
// //   }

// //   Stream<List<Assessment>> getAssessmentsStream() {
// //     String? uid = _auth.currentUser?.uid;
// //     if (uid == null) return Stream.value([]);

// //     return _firestore
// //         .collection('assessments')
// //         .where('coachId', isEqualTo: uid)
// //         .orderBy('date', descending: true)
// //         .snapshots()
// //         .map((snapshot) {
// //           return snapshot.docs.map((doc) {
// //             return Assessment.fromMap(doc.id, doc.data());
// //           }).toList();
// //         });
// //   }

// //   Future<void> addAssessment(Assessment assessment) async {
// //     await _firestore.collection('assessments').add(assessment.toMap());
// //   }

// //   Future<void> updateAssessment(String id, Map<String, dynamic> data) async {
// //     await _firestore.collection('assessments').doc(id).update(data);
// //   }

// //   Future<void> deleteAssessment(String id) async {
// //     await _firestore.collection('assessments').doc(id).delete();
// //   }

// //   Stream<List<CoachingSession>> getSessionsStream() {
// //     String? uid = _auth.currentUser?.uid;
// //     if (uid == null) return Stream.value([]);

// //     return _firestore
// //         .collection('sessions')
// //         .where('coachId', isEqualTo: uid)
// //         .orderBy('scheduledDate', descending: true)
// //         .snapshots()
// //         .map((snapshot) {
// //           return snapshot.docs.map((doc) {
// //             return CoachingSession.fromMap(doc.id, doc.data());
// //           }).toList();
// //         });
// //   }

// //   Future<void> addSession(CoachingSession session) async {
// //     await _firestore.collection('sessions').add(session.toMap());
// //   }

// //   Future<void> updateSession(String id, Map<String, dynamic> data) async {
// //     await _firestore.collection('sessions').doc(id).update(data);
// //   }

// //   Future<void> deleteSession(String id) async {
// //     await _firestore.collection('sessions').doc(id).delete();
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/enterprise.dart';
// import '../models/assessment.dart';
// import '../models/session.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

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

//   Stream<List<Enterprise>> getEnterprisesStream() {
//     String? uid = _auth.currentUser?.uid;
//     if (uid == null) return Stream.value([]);

//     return _firestore
//         .collection('enterprises')
//         .where('coachId', isEqualTo: uid)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             return Enterprise.fromMap(doc.id, doc.data());
//           }).toList();
//         });
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

//   Stream<List<Assessment>> getAssessmentsStream() {
//     String? uid = _auth.currentUser?.uid;
//     if (uid == null) {
//       return Stream.value([]);
//     }

//     return _firestore
//         .collection('assessments')
//         .where('coachId', isEqualTo: uid)
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             return Assessment.fromMap(doc.id, doc.data());
//           }).toList();
//         });
//   }

//   Future<void> addAssessment(Assessment assessment) async {
//     await _firestore.collection('assessments').add(assessment.toMap());
//   }

//   Future<void> updateAssessment(String id, Map<String, dynamic> data) async {
//     await _firestore.collection('assessments').doc(id).update(data);
//   }

//   Future<void> deleteAssessment(String id) async {
//     await _firestore.collection('assessments').doc(id).delete();
//   }

//   Stream<List<CoachingSession>> getSessionsStream() {
//     String? uid = _auth.currentUser?.uid;
//     if (uid == null) return Stream.value([]);

//     return _firestore
//         .collection('sessions')
//         .where('coachId', isEqualTo: uid)
//         .orderBy('scheduledDate', descending: true)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             return CoachingSession.fromMap(doc.id, doc.data());
//           }).toList();
//         });
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
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/enterprise.dart';
import '../models/assessment.dart';
import '../models/session.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Stream<List<Enterprise>> getEnterprisesStream() {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('enterprises')
        .where('coachId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          print('🏢 Firestore: Got ${snapshot.docs.length} enterprises');
          return snapshot.docs.map((doc) {
            return Enterprise.fromMap(doc.id, doc.data());
          }).toList();
        });
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

  Stream<List<Assessment>> getAssessmentsStream() {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      print('⚠️ Firestore: No authenticated user');
      return Stream.value([]);
    }

    print('🔍 Firestore: Fetching assessments for user: $uid');

    return _firestore
        .collection('assessments')
        .where('coachId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          print('📊 Firestore: Got ${snapshot.docs.length} assessment documents');
          
          // Log each document for debugging
          for (var doc in snapshot.docs) {
            print('📄 Document ID: ${doc.id}');
            print('📄 Document data: ${doc.data()}');
          }
          
          return snapshot.docs.map((doc) {
            try {
              return Assessment.fromMap(doc.id, doc.data());
            } catch (e) {
              print('❌ Error parsing assessment ${doc.id}: $e');
              // Return a default assessment or skip
              return Assessment(
                id: doc.id,
                enterpriseId: '',
                enterpriseName: 'Error loading',
                coachId: uid,
                coachName: '',
                date: DateTime.now(),
                type: 'Error',
                scores: {},
                strengths: [],
                weaknesses: [],
                recommendations: [],
                status: 'Error',
              );
            }
          }).toList();
        });
  }

  Future<void> addAssessment(Assessment assessment) async {
    print('➕ Firestore: Adding assessment');
    await _firestore.collection('assessments').add(assessment.toMap());
    print('✅ Firestore: Assessment added');
  }

  Future<void> updateAssessment(String id, Map<String, dynamic> data) async {
    await _firestore.collection('assessments').doc(id).update(data);
  }

  Future<void> deleteAssessment(String id) async {
    await _firestore.collection('assessments').doc(id).delete();
  }

  // Stream<List<CoachingSession>> getSessionsStream() {
  //   String? uid = _auth.currentUser?.uid;
  //   if (uid == null) return Stream.value([]);

  //   return _firestore
  //       .collection('sessions')
  //       .where('coachId', isEqualTo: uid)
  //       .orderBy('scheduledDate', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //         return snapshot.docs.map((doc) {
  //           return CoachingSession.fromMap(doc.id, doc.data());
  //         }).toList();
  //       });
  // }



  // In firestore_service.dart, update the getSessionsStream method
Stream<List<CoachingSession>> getSessionsStream() {
  String? uid = _auth.currentUser?.uid;
  if (uid == null) {
    print('⚠️ Firestore: No authenticated user for sessions');
    return Stream.value([]);
  }

  print('🔍 Firestore: Fetching sessions for user: $uid');

  return _firestore
      .collection('sessions')
      .where('coachId', isEqualTo: uid)
      .orderBy('scheduledDate', descending: true)
      .snapshots()
      .map((snapshot) {
        print('📊 Firestore: Got ${snapshot.docs.length} session documents');
        
        for (var doc in snapshot.docs) {
          print('📄 Session ID: ${doc.id}');
          print('📄 Session data: ${doc.data()}');
        }
        
        return snapshot.docs.map((doc) {
          try {
            return CoachingSession.fromMap(doc.id, doc.data());
          } catch (e) {
            print('❌ Error parsing session ${doc.id}: $e');
            return CoachingSession(
              id: doc.id,
              enterpriseId: '',
              enterpriseName: 'Error loading',
              coachId: uid,
              coachName: '',
              scheduledDate: DateTime.now(),
              type: 'Error',
              notes: '',
              recommendations: [],
              photoCount: 0,
              followUpRequired: false,
            );
          }
        }).toList();
      });
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
}
