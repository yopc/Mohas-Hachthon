import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/coach_model.dart';
import '../theme/app_theme2.dart';
import '../widgets/loading_overlay.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _nationalIdController;
  late TextEditingController _educationLevelController;
  late TextEditingController _educationOtherController;
  late TextEditingController _fieldOfStudyController;
  late TextEditingController _fieldOfStudyOtherController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _regionController;
  late TextEditingController _zoneController;
  late TextEditingController _usernameController;
  late TextEditingController _certificationUrlController;

  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  bool _hasCertification = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    final coach = Provider.of<AuthProvider>(context, listen: false).coach;
    if (coach != null) {
      _fullNameController = TextEditingController(text: coach.fullName);
      _phoneController = TextEditingController(text: coach.phone);
      _emailController = TextEditingController(text: coach.email);
      _nationalIdController = TextEditingController(text: coach.nationalId);
      _educationLevelController = TextEditingController(text: coach.educationLevel);
      _educationOtherController = TextEditingController(text: coach.educationOther ?? '');
      _fieldOfStudyController = TextEditingController(text: coach.fieldOfStudy);
      _fieldOfStudyOtherController = TextEditingController(text: coach.fieldOfStudyOther ?? '');
      _yearsOfExperienceController = TextEditingController(text: coach.yearsOfExperience.toString());
      _regionController = TextEditingController(text: coach.region);
      _zoneController = TextEditingController(text: coach.zone);
      _usernameController = TextEditingController(text: coach.username);
      _certificationUrlController = TextEditingController(text: coach.certificationUrl ?? '');
      _selectedGender = coach.gender;
      _selectedDateOfBirth = coach.dateOfBirth;
      _hasCertification = coach.hasCertification;
    } else {
      _fullNameController = TextEditingController();
      _phoneController = TextEditingController();
      _emailController = TextEditingController();
      _nationalIdController = TextEditingController();
      _educationLevelController = TextEditingController();
      _educationOtherController = TextEditingController();
      _fieldOfStudyController = TextEditingController();
      _fieldOfStudyOtherController = TextEditingController();
      _yearsOfExperienceController = TextEditingController();
      _regionController = TextEditingController();
      _zoneController = TextEditingController();
      _usernameController = TextEditingController();
      _certificationUrlController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _educationLevelController.dispose();
    _educationOtherController.dispose();
    _fieldOfStudyController.dispose();
    _fieldOfStudyOtherController.dispose();
    _yearsOfExperienceController.dispose();
    _regionController.dispose();
    _zoneController.dispose();
    _usernameController.dispose();
    _certificationUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        Map<String, dynamic> updates = {
          'fullName': _fullNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'nationalId': _nationalIdController.text.trim(),
          'educationLevel': _educationLevelController.text.trim(),
          'educationOther': _educationOtherController.text.trim().isEmpty ? null : _educationOtherController.text.trim(),
          'fieldOfStudy': _fieldOfStudyController.text.trim(),
          'fieldOfStudyOther': _fieldOfStudyOtherController.text.trim().isEmpty ? null : _fieldOfStudyOtherController.text.trim(),
          'yearsOfExperience': int.tryParse(_yearsOfExperienceController.text.trim()) ?? 0,
          'region': _regionController.text.trim(),
          'zone': _zoneController.text.trim(),
          'username': _usernameController.text.trim(),
          'gender': _selectedGender,
          'dateOfBirth': _selectedDateOfBirth?.toIso8601String(),
          'hasCertification': _hasCertification,
          'certificationUrl': _hasCertification ? _certificationUrlController.text.trim() : null,
        };

        await authProvider.updateCoachProfile(updates);

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating profile: $e'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.backgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person, color: AppTheme.primaryColor),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Full name is required' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: Icon(Icons.people, color: AppTheme.primaryColor),
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
                              initialDate: _selectedDateOfBirth ?? DateTime(2000),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) setState(() => _selectedDateOfBirth = date);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                              prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
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
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.phone, color: AppTheme.primaryColor),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.isEmpty ? 'Phone is required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email, color: AppTheme.primaryColor),
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
                            labelText: 'National ID',
                            prefixIcon: Icon(Icons.badge, color: AppTheme.primaryColor),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'National ID is required' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Professional Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _educationLevelController,
                          decoration: const InputDecoration(
                            labelText: 'Education Level',
                            prefixIcon: Icon(Icons.school, color: AppTheme.primaryColor),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Education level is required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _educationOtherController,
                          decoration: const InputDecoration(
                            labelText: 'Education Other (specify)',
                            prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _fieldOfStudyController,
                          decoration: const InputDecoration(
                            labelText: 'Field of Study',
                            prefixIcon: Icon(Icons.science, color: AppTheme.primaryColor),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Field of study is required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _fieldOfStudyOtherController,
                          decoration: const InputDecoration(
                            labelText: 'Field of Study Other (specify)',
                            prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _yearsOfExperienceController,
                          decoration: const InputDecoration(
                            labelText: 'Years of Experience',
                            prefixIcon: Icon(Icons.work, color: AppTheme.primaryColor),
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
                        if (_hasCertification) ...[                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _certificationUrlController,
                            decoration: const InputDecoration(
                              labelText: 'Certification URL',
                              prefixIcon: Icon(Icons.link, color: AppTheme.primaryColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _regionController,
                          decoration: const InputDecoration(
                            labelText: 'Region',
                            prefixIcon: Icon(Icons.location_on, color: AppTheme.primaryColor),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Region is required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _zoneController,
                          decoration: const InputDecoration(
                            labelText: 'Zone',
                            prefixIcon: Icon(Icons.location_city, color: AppTheme.primaryColor),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Zone is required' : null,
                        ),
                      ],
                    ),
                  ),
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person, color: AppTheme.primaryColor),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Username is required' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Changes'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
