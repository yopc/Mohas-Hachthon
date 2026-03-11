import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mohas/screens/coach_list_screen.dart';
<<<<<<< HEAD
import 'package:mohas/screens/register_coach_form.dart';
import 'package:mohas/screens/home_screen.dart';
import 'firebase_options.dart';

import 'theme/app_theme2.dart';
//  this is the main method of the entire project moas
=======
import 'firebase_options.dart';

import 'theme/app_theme.dart';

>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

<<<<<<< HEAD




=======
>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MESMER Coaching',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // home: const SplashScreen(),
<<<<<<< HEAD
      // home: const HomeScreen(),
     
=======
      // home: const RegisterCoachForm(),
>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
      home: const CoachListScreen(),
    );
  }
}
<<<<<<< HEAD


=======
>>>>>>> c206d711cc382b2864036d7ce7bb8a6a1dd640ff
