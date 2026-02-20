import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_theme2.dart';
import '../models/coach_model.dart';
import '../services/coach_service.dart';
import '../utils/file_picker_helper.dart';

class RegisterCoachForm extends StatefulWidget {
  const RegisterCoachForm({super.key});

  @override
  State<RegisterCoachForm> createState() => _RegisterCoachFormState();
}

class _RegisterCoachFormState extends State<RegisterCoachForm> {
  final _formKey = GlobalKey<FormState>();
  final _coachService = CoachService();
  int _currentStep = 0;
  bool _isLoading = false;

  // Personal Information Controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();
  
  // Professional Information Controllers
  final _yearsOfExperienceController = TextEditingController();
  final _fieldOfStudyOtherController = TextEditingController();
  final _educationOtherController = TextEditingController();
  final _zoneController = TextEditingController();
  
  // System Access Controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dropdown Values
  String? _selectedGender;
  String? _selectedEducationLevel;
  String? _selectedFieldOfStudy;
  String? _selectedRegion;
  String? _selectedAccountStatus;
  String? _selectedSupervisor;
  
  DateTime? _selectedDate;
  
  // File handling
  bool _hasCertification = false;
  Map<String, String>? _profilePicture;
  Map<String, String>? _certificationFile;
  
  final List<String> _genders = ['Male', 'Female', 'Prefer not to say', 'Other'];
  final List<String> _educationLevels = ['Diploma', 'Bachelor', 'Master', 'PhD', 'Other'];
  final List<String> _fieldsOfStudy = [
    'Computer Science', 'Business', 'Economics', 
    'Management', 'Finance', 'Other'
  ];
  final List<String> _regions = [
    'North', 'South', 'East', 'West', 'Central', 
    'Northeast', 'Northwest', 'Southeast', 'Southwest'
  ];
  final List<String> _accountStatuses = ['Active', 'Inactive'];
  final List<String> _supervisors = [
    'John Smith - Senior Coach',
    'Sarah Johnson - Regional Manager',
    'Michael Brown - Team Lead',
    'Emily Davis - Program Director'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Coach'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: AppTheme.backgroundColor,
              child: Form(
                key: _formKey,
                child: Stepper(
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 2) {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep--;
                      });
                    }
                  },
                  onStepTapped: (step) {
                    setState(() {
                      _currentStep = step;
                    });
                  },
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: details.onStepCancel,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryColor,
                                  side: const BorderSide(color: AppTheme.primaryColor),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Previous'),
                              ),
                            ),
                          if (_currentStep > 0) const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _currentStep == 2 ? _submitForm : details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(_currentStep == 2 ? 'Submit' : 'Next'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  steps: [
                    Step(
                      title: Text(
                        'Personal Info',
                        style: TextStyle(
                          color: _currentStep >= 0 ? AppTheme.primaryColor : AppTheme.textSecondary,
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                      content: _buildPersonalInfoStep(),
                    ),
                    Step(
                      title: Text(
                        'Professional',
                        style: TextStyle(
                          color: _currentStep >= 1 ? AppTheme.primaryColor : AppTheme.textSecondary,
                        ),
                      ),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                      content: _buildProfessionalInfoStep(),
                    ),
                    Step(
                      title: Text(
                        'System Access',
                        style: TextStyle(
                          color: _currentStep >= 2 ? AppTheme.primaryColor : AppTheme.textSecondary,
                        ),
                      ),
                      isActive: _currentStep >= 2,
                      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                      content: _buildSystemAccessStep(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            
            // Profile Picture Section
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  // Profile Picture Preview
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryColor, width: 2),
                      image: _profilePicture != null
                          ? DecorationImage(
                              image: MemoryImage(
                                base64Decode(_profilePicture!['base64']!),
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _profilePicture == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 20),
                  // Upload Buttons
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickProfilePicture,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            minimumSize: const Size(double.infinity, 40),
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => _pickProfilePicture(fromCamera: true),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Camera'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: const BorderSide(color: AppTheme.primaryColor),
                            minimumSize: const Size(double.infinity, 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
                hintText: 'Enter full name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Full name is required';
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                prefixIcon: Icon(Icons.transgender, color: AppTheme.primaryColor),
              ),
              items: _genders.map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              onChanged: (value) => setState(() => _selectedGender = value),
              validator: (value) => value == null ? 'Gender is required' : null,
            ),
            if (_selectedGender == 'Other') ...[const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Specify Gender',
                  prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                ),
              ),
            ],
            const SizedBox(height: 16),

            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                ),
                child: Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Select date',
                  style: TextStyle(
                    color: _selectedDate != null ? AppTheme.textPrimary : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryColor),
                hintText: '+1234567890',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.isEmpty ? 'Phone number is required' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryColor),
                hintText: 'email@example.com',
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
                prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.primaryColor),
                hintText: 'Enter national ID',
              ),
              validator: (value) => value == null || value.isEmpty ? 'National ID is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfoStep() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Professional Information',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedEducationLevel,
              decoration: const InputDecoration(
                labelText: 'Education Level',
                prefixIcon: Icon(Icons.school_outlined, color: AppTheme.primaryColor),
              ),
              items: _educationLevels.map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (value) => setState(() => _selectedEducationLevel = value),
              validator: (value) => value == null ? 'Education level is required' : null,
            ),
            if (_selectedEducationLevel == 'Other') ...[const SizedBox(height: 8),
              TextFormField(
                controller: _educationOtherController,
                decoration: const InputDecoration(
                  labelText: 'Specify Education Level',
                  prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                ),
              ),
            ],
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedFieldOfStudy,
              decoration: const InputDecoration(
                labelText: 'Field of Study',
                prefixIcon: Icon(Icons.science_outlined, color: AppTheme.primaryColor),
              ),
              items: _fieldsOfStudy.map((field) {
                return DropdownMenuItem(value: field, child: Text(field));
              }).toList(),
              onChanged: (value) => setState(() => _selectedFieldOfStudy = value),
              validator: (value) => value == null ? 'Field of study is required' : null,
            ),
            if (_selectedFieldOfStudy == 'Other') ...[const SizedBox(height: 8),
              TextFormField(
                controller: _fieldOfStudyOtherController,
                decoration: const InputDecoration(
                  labelText: 'Specify Field of Study',
                  prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                ),
              ),
            ],
            const SizedBox(height: 16),

            TextFormField(
              controller: _yearsOfExperienceController,
              decoration: const InputDecoration(
                labelText: 'Years of Experience',
                prefixIcon: Icon(Icons.timeline_outlined, color: AppTheme.primaryColor),
                hintText: 'Enter years',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Years of experience is required';
                if (int.tryParse(value) == null) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Certification Section
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Has Coaching Certification'),
                    value: _hasCertification,
                    onChanged: (value) {
                      setState(() {
                        _hasCertification = value ?? false;
                        if (!_hasCertification) {
                          _certificationFile = null;
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: Icon(
                      Icons.verified_outlined,
                      color: _hasCertification ? AppTheme.successColor : AppTheme.textSecondary,
                    ),
                  ),
                  if (_hasCertification) ...[const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (_certificationFile != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getFileIcon(_certificationFile!['fileName']!),
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _certificationFile!['fileName']!,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          _formatFileSize(int.parse(_certificationFile!['fileSize']!)),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _certificationFile = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: _pickCertificationFile,
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Upload Certification Document'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.secondaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedRegion,
              decoration: const InputDecoration(
                labelText: 'Region',
                prefixIcon: Icon(Icons.map_outlined, color: AppTheme.primaryColor),
              ),
              items: _regions.map((region) {
                return DropdownMenuItem(value: region, child: Text(region));
              }).toList(),
              onChanged: (value) => setState(() => _selectedRegion = value),
              validator: (value) => value == null ? 'Region is required' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _zoneController,
              decoration: const InputDecoration(
                labelText: 'Zone / District',
                prefixIcon: Icon(Icons.location_city_outlined, color: AppTheme.primaryColor),
                hintText: 'Enter zone or district',
              ),
              validator: (value) => value == null || value.isEmpty ? 'Zone/District is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemAccessStep() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Access',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
                hintText: 'Choose a username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Username is required';
                if (value.length < 4) return 'Username must be at least 4 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Temporary Password',
                prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primaryColor),
                hintText: 'Set temporary password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Password is required';
                if (value.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedAccountStatus,
              decoration: const InputDecoration(
                labelText: 'Account Status',
                prefixIcon: Icon(Icons.toggle_on_outlined, color: AppTheme.primaryColor),
              ),
              items: _accountStatuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: status == 'Active' ? AppTheme.successColor : AppTheme.errorColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(status),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedAccountStatus = value),
              validator: (value) => value == null ? 'Account status is required' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedSupervisor,
              decoration: const InputDecoration(
                labelText: 'Supervisor Assigned',
                prefixIcon: Icon(Icons.supervisor_account_outlined, color: AppTheme.primaryColor),
              ),
              items: _supervisors.map((supervisor) {
                return DropdownMenuItem(value: supervisor, child: Text(supervisor));
              }).toList(),
              onChanged: (value) => setState(() => _selectedSupervisor = value),
              validator: (value) => value == null ? 'Supervisor is required' : null,
            ),
            
            const SizedBox(height: 24),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Register Coach'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickProfilePicture({bool fromCamera = false}) async {
    final result = await FilePickerHelper.pickImage(fromCamera: fromCamera);
    if (result != null) {
      setState(() {
        _profilePicture = result;
      });
    }
  }

  Future<void> _pickCertificationFile() async {
    final result = await FilePickerHelper.pickFile(
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _certificationFile = result;
      });
    }
  }

  IconData _getFileIcon(String fileName) {
    return FilePickerHelper.getFileIcon(fileName);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final coach = CoachModel(
          fullName: _fullNameController.text,
          gender: _selectedGender,
          dateOfBirth: _selectedDate,
          phone: _phoneController.text,
          email: _emailController.text,
          nationalId: _nationalIdController.text,
          profilePictureBase64: _profilePicture?['base64'],
          educationLevel: _selectedEducationLevel ?? '',
          educationOther: _educationOtherController.text.isNotEmpty 
              ? _educationOtherController.text 
              : null,
          fieldOfStudy: _selectedFieldOfStudy ?? '',
          fieldOfStudyOther: _fieldOfStudyOtherController.text.isNotEmpty 
              ? _fieldOfStudyOtherController.text 
              : null,
          yearsOfExperience: int.parse(_yearsOfExperienceController.text),
          hasCertification: _hasCertification,
          certificationBase64: _certificationFile?['base64'],
          certificationFileName: _certificationFile?['fileName'],
          region: _selectedRegion ?? '',
          zone: _zoneController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          accountStatus: _selectedAccountStatus ?? 'Active',
          assignedSupervisor: _selectedSupervisor ?? '',
          securityId: null,
        );

        String coachId = await _coachService.registerCoach(coach);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Coach registered successfully! Coach ID: $coachId',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _yearsOfExperienceController.dispose();
    _fieldOfStudyOtherController.dispose();
    _educationOtherController.dispose();
    _zoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}