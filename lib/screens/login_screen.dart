import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import '../theme/app_theme2.dart';
import '../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.signInWithEmail(_emailController.text.trim(), _passwordController.text.trim());
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Login failed'), backgroundColor: AppTheme.errorColor, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return LoadingOverlay(
      isLoading: authProvider.isLoading,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.business_center, size: 40, color: AppTheme.primaryColor)),
                  const SizedBox(height: 32),
                  const Text('Welcome Back!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const SizedBox(height: 8),
                  const Text('Sign in to continue coaching', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
                  const SizedBox(height: 32),
                  TextFormField(controller: _emailController, decoration: const InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.email_outlined)), keyboardType: TextInputType.emailAddress, validator: (v) { if (v == null || v.isEmpty) return 'Email is required'; if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Enter a valid email'; return null; }),
                  const SizedBox(height: 16),
                  TextFormField(controller: _passwordController, decoration: const InputDecoration(hintText: 'Password', prefixIcon: Icon(Icons.lock_outline), suffixIcon: Icon(Icons.visibility_off)), obscureText: true, validator: (v) { if (v == null || v.isEmpty) return 'Password is required'; if (v.length < 6) return 'Password must be at least 6 characters'; return null; }),
                  const SizedBox(height: 12),
                  Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot Password?'))),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: _handleLogin, child: const Text('Sign In')),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: TextStyle(color: AppTheme.textSecondary)),
                      TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen())), child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
