import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart'; 
Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  print('🚀 Starting supervisor creation...');
  await createSupervisorManually();
  print('✨ Done! You can now close this app.');
}

Future<void> createSupervisorManually() async {
  try {
    // Check if user already exists
    print('📧 Checking if supervisor@mesmer.com exists...');
    try {
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail('supervisor@mesmer.com');
      if (methods.isNotEmpty) {
        print('⚠️ Supervisor already exists!');
        print('📧 Email: supervisor@mesmer.com');
        print('🔑 Password: Supervisor@123');
        return;
      }
    } catch (e) {
      // Continue if check fails
    }

    // Create auth user
    print('👤 Creating Firebase Auth user...');
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: 'supervisor1@mesmer.com',
          password: '123456',
        );
    
    print('✅ Auth user created with UID: ${userCredential.user!.uid}');

    // Add Firestore data
    print('💾 Saving to Firestore...');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'fullName': 'Admin Supervisor',
      'gender': 'Male',
      'dateOfBirth': '1985-06-15',
      'phone': '+251911234567',
      'email': 'supervisor@mesmer.com',
      'nationalId': 'SN12345678',
      'educationLevel': 'Master',
      'educationOther': null,
      'fieldOfStudy': 'Business Administration',
      'fieldOfStudyOther': null,
      'yearsOfExperience': 10,
      'hasCertification': true,
      'certificationUrl': 'https://example.com/certificate.pdf',
      'region': 'Addis Ababa',
      'zone': 'Bole',
      'username': 'supervisor_admin',
      'password': 'Supervisor@123',
      'accountStatus': 'active',
      'supervisorId': 'none',
      'supervisorName': 'System',
      'createdAt': DateTime.now().toIso8601String(),
      'isFirstLogin': false,
      'role': 'supervisor',
    });

    print('\n${'=' * 50}');
    print('✅ SUPERVISOR CREATED SUCCESSFULLY!');
    print('=' * 50);
    print('📧 Email: supervisor@mesmer.com');
    print('🔑 Password: Supervisor@123');
    print('🆔 UID: ${userCredential.user!.uid}');
    print('👤 Name: Admin Supervisor');
    print('=' * 50);
    
  } catch (e) {
    print('\n❌ Error: $e');
    if (e.toString().contains('email-already-in-use')) {
      print('⚠️ Email already exists. Try logging in with:');
      print('📧 supervisor@mesmer.com');
      print('🔑 Supervisor@123');
    }
  }
}