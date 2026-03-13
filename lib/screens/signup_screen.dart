import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme2.dart';
import '../widgets/loading_overlay.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _educationLevelController = TextEditingController();
  final _educationOtherController = TextEditingController();
  final _fieldOfStudyController = TextEditingController();
  final _fieldOfStudyOtherController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _regionController = TextEditingController();
  final _zoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _certificationUrlController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  bool _hasCertification = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _educationLevelController.dispose();
    _educationOtherController.dispose();
    _fieldOfStudyController.dispose();
    _fieldOfStudyOtherController.dispose();
    _yearsOfExperienceController.dispose();
    _regionController.dispose();
    _zoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _certificationUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      Map<String, dynamic> userData = {
        'fullName': _fullNameController.text.trim(),
        'gender': _selectedGender,
        'dateOfBirth': _selectedDateOfBirth?.toIso8601String(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'nationalId': _nationalIdController.text.trim(),
        'educationLevel': _educationLevelController.text.trim(),
        'educationOther': _educationOtherController.text.trim().isEmpty ? null : _educationOtherController.text.trim(),
        'fieldOfStudy': _fieldOfStudyController.text.trim(),
        'fieldOfStudyOther': _fieldOfStudyOtherController.text.trim().isEmpty ? null : _fieldOfStudyOtherController.text.trim(),
        'yearsOfExperience': int.tryParse(_yearsOfExperienceController.text.trim()) ?? 0,
        'hasCertification': _hasCertification,
        'certificationUrl': _hasCertification ? _certificationUrlController.text.trim() : null,
        'region': _regionController.text.trim(),
        'zone': _zoneController.text.trim(),
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
        'supervisorId': 'default',
        'supervisorName': 'Default Supervisor',
      };

      bool success = await authProvider.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        userData,
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Signup failed'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
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
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_add,
                            size: 50,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Full name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      hintText: 'Gender',
                      prefixIcon: Icon(Icons.people),
                    ),
                    items: _genders.map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedGender = value),
                    validator: (value) => value == null ? 'Gender is required' : null,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _selectedDateOfBirth = date);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        hintText: 'Date of Birth',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDateOfBirth != null
                            ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                            : 'Select date of birth',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty ? 'Phone number is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nationalIdController,
                    decoration: const InputDecoration(
                      hintText: 'National ID',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'National ID is required' : null,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Professional Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _educationLevelController,
                    decoration: const InputDecoration(
                      hintText: 'Education Level',
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Education level is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _educationOtherController,
                    decoration: const InputDecoration(
                      hintText: 'Education Other (specify)',
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fieldOfStudyController,
                    decoration: const InputDecoration(
                      hintText: 'Field of Study',
                      prefixIcon: Icon(Icons.science),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Field of study is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fieldOfStudyOtherController,
                    decoration: const InputDecoration(
                      hintText: 'Field of Study Other (specify)',
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _yearsOfExperienceController,
                    decoration: const InputDecoration(
                      hintText: 'Years of Experience',
                      prefixIcon: Icon(Icons.work),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Years of experience is required';
                      if (int.tryParse(value) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _hasCertification,
                        onChanged: (value) => setState(() => _hasCertification = value ?? false),
                        activeColor: AppTheme.primaryColor,
                      ),
                      const Expanded(
                        child: Text(
                          'Has Professional Certification',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_hasCertification) ...[                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _certificationUrlController,
                      decoration: const InputDecoration(
                        hintText: 'Certification URL',
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Location Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _regionController,
                    decoration: const InputDecoration(
                      hintText: 'Region',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Region is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _zoneController,
                    decoration: const InputDecoration(
                      hintText: 'Zone',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Zone is required' : null,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Username is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password is required';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please confirm your password';
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                        activeColor: AppTheme.primaryColor,
                      ),
                      const Expanded(
                        child: Text(
                          'I agree to the Terms of Service and Privacy Policy',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleSignUp,
                    child: const Text('Create Account'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
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
