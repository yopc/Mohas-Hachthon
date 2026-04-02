import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mohas/providers/auth_wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/enterprise_provider.dart';
import 'providers/session_provider.dart';
import 'providers/assessment_provider.dart';
import 'providers/iap_provider.dart';
import 'providers/training_provider.dart';
import 'providers/evidence_provider.dart';
import 'providers/qc_provider.dart';
import 'providers/graduation_provider.dart';
import 'theme/app_theme2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EnterpriseProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
        ChangeNotifierProvider(create: (_) => IapProvider()),
        ChangeNotifierProvider(create: (_) => TrainingProvider()),
        ChangeNotifierProvider(create: (_) => EvidenceProvider()),
        ChangeNotifierProvider(create: (_) => QcProvider()),
        ChangeNotifierProvider(create: (_) => GraduationProvider()),
      ],
      child: MaterialApp(
        title: 'MESMER Coaching',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}