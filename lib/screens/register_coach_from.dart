
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coach_model.dart';
import '../theme/app_theme2.dart';

class RegisterCoachForm extends StatefulWidget {
  final String supervisorId;
  final String supervisorName;
  const RegisterCoachForm(
      {super.key, required this.supervisorId, required this.supervisorName});

  @override
  State<RegisterCoachForm> createState() => _RegisterCoachFormState();
}

class _RegisterCoachFormState extends State<RegisterCoachForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentStep = 0;

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _fieldOfStudyOtherController = TextEditingController();
  final _educationOtherController = TextEditingController();
  final _certificationUrlController = TextEditingController();
  final _zoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  String? _selectedEducationLevel;
  String? _selectedFieldOfStudy;
  String? _selectedRegion;
  String? _selectedAccountStatus = 'active';
  DateTime? _selectedDateOfBirth;
  bool _hasCertification = false;

  final List<String> _genders = ['Male', 'Female'];
  final List<String> _educationLevels = [
    'Diploma',
    'Bachelor',
    'Master',
    'PhD',
    'Other'
  ];
  final List<String> _fieldsOfStudy = [
    'Computer Science',
    'Business',
    'Economics',
    'Management',
    'Finance',
    'Education',
    'Other'
  ];
  final List<String> _regions = [
    'Addis Ababa',
    'Oromia',
    'Amhara',
    'Tigray',
    'Sidama',
    'SNNPR',
    'Harari',
    'Gambella',
    'Benishangul-Gumuz'
  ];
  final List<String> _accountStatuses = ['active', 'inactive'];

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDateOfBirth = picked);
  }

  void _nextStep() => setState(() => _currentStep++);
  void _previousStep() => setState(() => _currentStep--);

  Future<void> _registerCoach() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: AppTheme.errorColor),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      // Check if email already exists
      final emailQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();
      if (emailQuery.docs.isNotEmpty) throw 'Email already registered';

      // Check if username already exists
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _usernameController.text.trim())
          .get();
      if (usernameQuery.docs.isNotEmpty) throw 'Username already taken';

      // Create Firebase Auth user
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Create coach object with role field
      final coach = Coach(
        id: userCredential.user!.uid,
        fullName: _fullNameController.text.trim(),
        gender: _selectedGender!,
        dateOfBirth: _selectedDateOfBirth,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        educationLevel: _selectedEducationLevel!,
        educationOther: _selectedEducationLevel == 'Other'
            ? _educationOtherController.text.trim()
            : null,
        fieldOfStudy: _selectedFieldOfStudy!,
        fieldOfStudyOther: _selectedFieldOfStudy == 'Other'
            ? _fieldOfStudyOtherController.text.trim()
            : null,
        yearsOfExperience: int.parse(_yearsOfExperienceController.text),
        hasCertification: _hasCertification,
        certificationUrl:
            _hasCertification ? _certificationUrlController.text.trim() : null,
        region: _selectedRegion!,
        zone: _zoneController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        accountStatus: _selectedAccountStatus!,
        supervisorId: widget.supervisorId,
        supervisorName: widget.supervisorName,
        createdAt: DateTime.now(),
        isFirstLogin: true,
        role: 'coach', // ✅ CRITICAL: Set role to coach
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(coach.toMap());

      print(
          '✅ Coach registered successfully with UID: ${userCredential.user!.uid}');
      if (mounted) _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      }
      _showErrorDialog(message);
    } catch (e) {
      print('❌ Registration error: $e');
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle,
            color: AppTheme.successColor, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Registration Successful!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Email', _emailController.text.trim()),
                  const Divider(),
                  _buildInfoRow('Username', _usernameController.text),
                  const Divider(),
                  _buildInfoRow('Password', _passwordController.text),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please share these credentials with the coach securely',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.error, color: AppTheme.errorColor, size: 50),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Coach',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: AppTheme.backgroundColor,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildStepIndicator(0, 'Personal'),
                      _buildStepLine(),
                      _buildStepIndicator(1, 'Professional'),
                      _buildStepLine(),
                      _buildStepIndicator(2, 'Location'),
                      _buildStepLine(),
                      _buildStepIndicator(3, 'Account'),
                    ],
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (_currentStep == 0) _buildPersonalInfoSection(),
                          if (_currentStep == 1)
                            _buildProfessionalInfoSection(),
                          if (_currentStep == 2) _buildLocationInfoSection(),
                          if (_currentStep == 3) _buildAccountInfoSection(),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              if (_currentStep > 0)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _previousStep,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.primaryColor,
                                      side: const BorderSide(
                                          color: AppTheme.primaryColor),
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Previous'),
                                  ),
                                ),
                              if (_currentStep > 0) const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _currentStep < 3
                                      ? _nextStep
                                      : _registerCoach,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                      _currentStep < 3 ? 'Next' : 'Submit'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Creating coach account...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    bool isActive = _currentStep == step;
    bool isCompleted = _currentStep > step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? AppTheme.successColor
                  : isActive
                      ? AppTheme.primaryColor
                      : Colors.grey.shade300,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text('${step + 1}',
                      style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey.shade600,
                          fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppTheme.primaryColor : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine() =>
      Container(width: 20, height: 2, color: Colors.grey.shade300);

  Widget _buildPersonalInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.person, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                const Text('Personal Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Full name is required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                prefixIcon:
                    const Icon(Icons.person_outline, color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _genders
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedGender = v),
              validator: (v) => v == null ? 'Gender is required' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDateOfBirth,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: const Icon(Icons.calendar_today,
                      color: AppTheme.primaryColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(_selectedDateOfBirth != null
                    ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                    : 'Select date of birth'),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Phone number is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nationalIdController,
              decoration: InputDecoration(
                labelText: 'National ID',
                prefixIcon: const Icon(Icons.badge_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'National ID is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.work, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                const Text('Professional Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedEducationLevel,
              decoration: InputDecoration(
                labelText: 'Education Level',
                prefixIcon: const Icon(Icons.school_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _educationLevels
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedEducationLevel = v),
              validator: (v) =>
                  v == null ? 'Education level is required' : null,
            ),
            if (_selectedEducationLevel == 'Other') ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _educationOtherController,
                decoration: InputDecoration(
                  labelText: 'Specify Education Level',
                  prefixIcon:
                      const Icon(Icons.edit, color: AppTheme.primaryColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedFieldOfStudy,
              decoration: InputDecoration(
                labelText: 'Field of Study',
                prefixIcon: const Icon(Icons.science_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _fieldsOfStudy
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedFieldOfStudy = v),
              validator: (v) => v == null ? 'Field of study is required' : null,
            ),
            if (_selectedFieldOfStudy == 'Other') ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _fieldOfStudyOtherController,
                decoration: InputDecoration(
                  labelText: 'Specify Field of Study',
                  prefixIcon:
                      const Icon(Icons.edit, color: AppTheme.primaryColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearsOfExperienceController,
              decoration: InputDecoration(
                labelText: 'Years of Experience',
                prefixIcon: const Icon(Icons.timeline_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Years of experience is required';
                }
                if (int.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: const Text('Has Coaching Certification'),
                value: _hasCertification,
                onChanged: (v) =>
                    setState(() => _hasCertification = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(Icons.verified_outlined,
                    color: _hasCertification
                        ? AppTheme.successColor
                        : AppTheme.textSecondary),
              ),
            ),
            if (_hasCertification) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _certificationUrlController,
                decoration: InputDecoration(
                  labelText: 'Certification URL',
                  prefixIcon:
                      const Icon(Icons.link, color: AppTheme.primaryColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.location_on,
                      color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                const Text('Location Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedRegion,
              decoration: InputDecoration(
                labelText: 'Region',
                prefixIcon: const Icon(Icons.map_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _regions
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedRegion = v),
              validator: (v) => v == null ? 'Region is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _zoneController,
              decoration: InputDecoration(
                labelText: 'Zone / District',
                prefixIcon: const Icon(Icons.location_city_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Zone/District is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child:
                      const Icon(Icons.computer, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                const Text('Account Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person_outline,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Username is required';
                if (v.length < 4) {
                  return 'Username must be at least 4 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Temporary Password',
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              obscureText: _obscureConfirmPassword,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please confirm password';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedAccountStatus,
              decoration: InputDecoration(
                labelText: 'Account Status',
                prefixIcon: const Icon(Icons.toggle_on_outlined,
                    color: AppTheme.primaryColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _accountStatuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: status == 'active'
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(status),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedAccountStatus = v),
              validator: (v) => v == null ? 'Account status is required' : null,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.supervisor_account,
                        color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Supervisor',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(widget.supervisorName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _yearsOfExperienceController.dispose();
    _fieldOfStudyOtherController.dispose();
    _educationOtherController.dispose();
    _certificationUrlController.dispose();
    _zoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
