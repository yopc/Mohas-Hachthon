import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'splash_screen.dart';
import 'supervisor_dashboard.dart';

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
