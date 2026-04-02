import 'package:flutter/material.dart';
import 'package:mohas/screens/home_screen.dart';
import 'package:mohas/screens/login_screen.dart';
import 'package:mohas/screens/splash_screen.dart';
import 'package:mohas/screens/supervisor_dashboard.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const SplashScreen();
    }

    if (authProvider.isAuthenticated) {
      final isSupervisor = authProvider.coach?.role == 'supervisor';
      if (isSupervisor) {
        return const SupervisorDashboard();
      } else {
        return const HomeScreen();
      }
    }

    return const LoginScreen();
  }
}
