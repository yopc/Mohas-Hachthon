// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/enterprise.dart';
// import '../providers/enterprise_provider.dart';
// import '../providers/assessment_provider.dart';
// import '../providers/session_provider.dart';
// import '../providers/iap_provider.dart';
// import '../providers/evidence_provider.dart';
// import '../providers/graduation_provider.dart';
// import '../theme/app_theme2.dart';
// import 'iap_editor_screen.dart';
// import 'graduation_checklist_screen.dart';
// import '../widgets/evidence_picker.dart';

// class EnterpriseProfileScreen extends StatefulWidget {
//   final String enterpriseId;
//   const EnterpriseProfileScreen({super.key, required this.enterpriseId});

//   @override
//   State<EnterpriseProfileScreen> createState() => _EnterpriseProfileScreenState();
// }

// class _EnterpriseProfileScreenState extends State<EnterpriseProfileScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   Enterprise? _enterprise;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 6, vsync: this);
//     _loadEnterprise();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadEnterprise() async {
//     final enterpriseProvider = Provider.of<EnterpriseProvider>(context, listen: false);
//     // Try to find in existing list
//     Enterprise? existing;
//     try {
//       existing = enterpriseProvider.enterprises.firstWhere(
//         (e) => e.id == widget.enterpriseId,
//       );
//     } catch (e) {
//       existing = null;
//     }
//     if (existing != null) {
//       setState(() {
//         _enterprise = existing;
//         _isLoading = false;
//       });
//       _loadData();
//       return;
//     }
//     // Fetch directly from Firestore
//     final fetched = await enterpriseProvider.getEnterpriseById(widget.enterpriseId);
//     if (mounted) {
//       setState(() {
//         _enterprise = fetched;
//         _isLoading = false;
//       });
//       if (fetched != null) {
//         _loadData();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Enterprise not found'), backgroundColor: AppTheme.errorColor),
//         );
//       }
//     }
//   }

//   void _loadData() {
//     if (_enterprise == null) return;
//     Provider.of<IapProvider>(context, listen: false).fetchIap(widget.enterpriseId);
//     Provider.of<EvidenceProvider>(context, listen: false).fetchEvidence(widget.enterpriseId);
//     Provider.of<GraduationProvider>(context, listen: false).fetchChecklist(widget.enterpriseId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//     if (_enterprise == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('Enterprise Not Found')),
//         body: const Center(child: Text('Could not load enterprise details.')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_enterprise!.businessName),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Overview'),
//             Tab(text: 'Baseline'),
//             Tab(text: 'IAP'),
//             Tab(text: 'Coaching'),
//             Tab(text: 'Evidence'),
//             Tab(text: 'Certificates'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildOverviewTab(_enterprise!),
//           _buildBaselineTab(_enterprise!),
//           _buildIapTab(),
//           _buildCoachingTab(),
//           _buildEvidenceTab(),
//           _buildCertificatesTab(),
//         ],
//       ),
//       floatingActionButton: _buildFloatingButton(_enterprise!),
//     );
//   }

//   Widget _buildOverviewTab(Enterprise enterprise) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _infoCard(enterprise),
//           const SizedBox(height: 16),
//           _businessMetricsCard(enterprise),
//           const SizedBox(height: 16),
//           _scoresCard(enterprise),
//         ],
//       ),
//     );
//   }

//   Widget _infoCard(Enterprise enterprise) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('Owner'),
//               subtitle: Text(enterprise.ownerName),
//             ),
//             ListTile(
//               leading: const Icon(Icons.phone),
//               title: const Text('Phone'),
//               subtitle: Text(enterprise.phone),
//             ),
//             ListTile(
//               leading: const Icon(Icons.location_on),
//               title: const Text('Location'),
//               subtitle: Text(enterprise.location),
//             ),
//             ListTile(
//               leading: const Icon(Icons.category),
//               title: const Text('Sector'),
//               subtitle: Text(enterprise.sector),
//             ),
//             ListTile(
//               leading: const Icon(Icons.calendar_today),
//               title: const Text('Registered'),
//               subtitle: Text(_formatDate(enterprise.registrationDate)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _businessMetricsCard(Enterprise enterprise) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Business Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text('Monthly Revenue', style: TextStyle(color: Colors.grey.shade600)),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${enterprise.baselineMonthlyRevenue?.toStringAsFixed(0) ?? '—'} ETB',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text('Baseline', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text('Current', style: TextStyle(color: Colors.grey.shade600)),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${enterprise.currentMonthlyRevenue?.toStringAsFixed(0) ?? '—'} ETB',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildChangeIndicator(
//                         enterprise.baselineMonthlyRevenue,
//                         enterprise.currentMonthlyRevenue,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text('Employees', style: TextStyle(color: Colors.grey.shade600)),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${enterprise.baselineEmployees ?? '—'}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text('Baseline', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text('Current', style: TextStyle(color: Colors.grey.shade600)),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${enterprise.currentEmployees ?? '—'}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildEmployeeChange(enterprise.baselineEmployees, enterprise.currentEmployees),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _scoresCard(Enterprise enterprise) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Scores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             _scoreRow('Finance', enterprise.financeScore),
//             _scoreRow('Marketing', enterprise.marketingScore),
//             _scoreRow('Operations', enterprise.operationsScore),
//             _scoreRow('HR', enterprise.hrScore),
//             _scoreRow('Governance', enterprise.governanceScore),
//             const Divider(),
//             _scoreRow('Overall', enterprise.overallScore, isOverall: true),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _scoreRow(String label, double score, {bool isOverall = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(label, style: TextStyle(fontWeight: isOverall ? FontWeight.bold : FontWeight.normal)),
//           ),
//           Expanded(
//             child: LinearProgressIndicator(
//               value: score / 100,
//               backgroundColor: Colors.grey.shade200,
//               valueColor: AlwaysStoppedAnimation<Color>(AppColors.getScoreColor(score)),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             '${score.toInt()}%',
//             style: TextStyle(fontWeight: isOverall ? FontWeight.bold : FontWeight.normal),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChangeIndicator(double? baseline, double? current) {
//     if (baseline == null || current == null) return const SizedBox.shrink();
//     final diff = current - baseline;
//     final percent = (diff / baseline * 100).abs().toStringAsFixed(0);
//     final isPositive = diff >= 0;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 16, color: isPositive ? AppTheme.successColor : AppTheme.errorColor),
//         const SizedBox(width: 4),
//         Text(
//           '$percent%',
//           style: TextStyle(color: isPositive ? AppTheme.successColor : AppTheme.errorColor, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmployeeChange(int? baseline, int? current) {
//     if (baseline == null || current == null) return const SizedBox.shrink();
//     final diff = current - baseline;
//     final isPositive = diff >= 0;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(isPositive ? Icons.add : Icons.remove, size: 16, color: isPositive ? AppTheme.successColor : AppTheme.errorColor),
//         const SizedBox(width: 4),
//         Text(
//           diff.abs().toString(),
//           style: TextStyle(color: isPositive ? AppTheme.successColor : AppTheme.errorColor, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _buildBaselineTab(Enterprise enterprise) {
//     return FutureBuilder(
//       future: Provider.of<AssessmentProvider>(context, listen: false)
//           .getBaselineForEnterprise(enterprise.id),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         final baseline = snapshot.data;
//         if (baseline == null) {
//           return const Center(child: Text('No baseline assessment found.'));
//         }
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       Text('Baseline Assessment', style: Theme.of(context).textTheme.titleLarge),
//                       const SizedBox(height: 8),
//                       Text('Date: ${_formatDate(baseline.date)}'),
//                       const SizedBox(height: 16),
//                       ...baseline.strengths.map((s) => _bulletPoint(Icons.check_circle, s, AppTheme.successColor)),
//                       ...baseline.weaknesses.map((w) => _bulletPoint(Icons.warning, w, AppTheme.warningColor)),
//                       const SizedBox(height: 16),
//                       const Text('Recommendations', style: TextStyle(fontWeight: FontWeight.bold)),
//                       ...baseline.recommendations.map((r) => _bulletPoint(Icons.lightbulb, r, Colors.amber)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _bulletPoint(IconData icon, String text, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 8),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }

//   Widget _buildIapTab() {
//     return Consumer<IapProvider>(
//       builder: (context, iapProvider, _) {
//         final iap = iapProvider.iap;
//         if (iapProvider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (iap == null) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text('No IAP found.'),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => IapEditorScreen(enterpriseId: widget.enterpriseId),
//                       ),
//                     ).then((_) => iapProvider.fetchIap(widget.enterpriseId));
//                   },
//                   child: const Text('Create IAP'),
//                 ),
//               ],
//             ),
//           );
//         }
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: iap.tasks.length,
//           itemBuilder: (context, index) {
//             final task = iap.tasks[index];
//             return Card(
//               child: ListTile(
//                 leading: Checkbox(
//                   value: task.status == 'done',
//                   onChanged: (value) {
//                     iapProvider.updateTaskStatus(iap.id, task.id, value! ? 'done' : 'in_progress');
//                   },
//                 ),
//                 title: Text(task.description),
//                 subtitle: Text('Owner: ${task.owner} | Due: ${task.dueDate != null ? _formatDate(task.dueDate!) : 'No deadline'}'),
//                 trailing: task.status == 'done' ? const Icon(Icons.check_circle, color: AppTheme.successColor) : null,
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildCoachingTab() {
//     final sessions = Provider.of<SessionProvider>(context).sessions
//         .where((s) => s.enterpriseId == widget.enterpriseId)
//         .toList();
//     if (sessions.isEmpty) {
//       return const Center(child: Text('No coaching sessions yet.'));
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: sessions.length,
//       itemBuilder: (context, index) {
//         final session = sessions[index];
//         return Card(
//           child: ListTile(
//             title: Text('${session.type} - ${_formatDate(session.scheduledDate)}'),
//             subtitle: Text(session.notes),
//             trailing: session.isCompleted ? const Icon(Icons.check, color: AppTheme.successColor) : null,
//             onTap: () {},
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildEvidenceTab() {
//     return Consumer<EvidenceProvider>(
//       builder: (context, evidenceProvider, _) {
//         final evidences = evidenceProvider.evidences;
//         if (evidenceProvider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => EvidencePicker(
//                       enterpriseId: widget.enterpriseId,
//                       recordType: 'enterprise',
//                       recordId: widget.enterpriseId,
//                       onUploaded: (newEvidences) async {
//                         for (var evidence in newEvidences) {
//                           await evidenceProvider.addEvidence(evidence);
//                         }
//                         evidenceProvider.fetchEvidence(widget.enterpriseId);
//                       },
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.add_a_photo),
//                 label: const Text('Add Evidence'),
//               ),
//             ),
//             if (evidences.isEmpty)
//               const Expanded(child: Center(child: Text('No evidence uploaded yet.')))
//             else
//               Expanded(
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(16),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                     childAspectRatio: 1,
//                   ),
//                   itemCount: evidences.length,
//                   itemBuilder: (context, index) {
//                     final evidence = evidences[index];
//                     return Card(
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child: Image.network(evidence.url, fit: BoxFit.cover),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(evidence.recordType),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildCertificatesTab() {
//     return Consumer<GraduationProvider>(
//       builder: (context, gradProvider, _) {
//         final checklist = gradProvider.checklist;
//         if (gradProvider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Text('Graduation Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//                       _requirementTile('Baseline present', checklist?.baselinePresent ?? false),
//                       _requirementTile('Minimum 8 coaching visits', checklist?.minCoachingVisits ?? false),
//                       _requirementTile('Midline better than baseline', checklist?.midlineBetter ?? false),
//                       _requirementTile('Coach sign-off', checklist?.coachSignOff ?? false),
//                       _requirementTile('Evidence pack complete', checklist?.evidencePack ?? false),
//                       _requirementTile('M&E approval', checklist?.mAndEApproved ?? false),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               if (checklist != null && !checklist.mAndEApproved)
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => GraduationChecklistScreen(enterpriseId: widget.enterpriseId),
//                       ),
//                     ).then((_) => gradProvider.fetchChecklist(widget.enterpriseId));
//                   },
//                   icon: const Icon(Icons.request_page),
//                   label: const Text('Request Graduation'),
//                 ),
//               if (checklist != null && checklist.mAndEApproved)
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Show certificate
//                   },
//                   icon: const Icon(Icons.verified),
//                   label: const Text('View Certificate'),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _requirementTile(String label, bool isMet) {
//     return ListTile(
//       leading: Icon(isMet ? Icons.check_circle : Icons.cancel, color: isMet ? AppTheme.successColor : AppTheme.errorColor),
//       title: Text(label),
//       trailing: isMet ? const Text('Met', style: TextStyle(color: AppTheme.successColor)) : const Text('Not met', style: TextStyle(color: AppTheme.errorColor)),
//     );
//   }

//   Widget? _buildFloatingButton(Enterprise enterprise) {
//     final isGraduationPending = false; // TODO: check actual graduation status
//     if (!isGraduationPending) {
//       return FloatingActionButton(
//         child: const Icon(Icons.edit),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => IapEditorScreen(enterpriseId: widget.enterpriseId),
//             ),
//           ).then((_) => _loadData());
//         },
//       );
//     }
//     return null;
//   }

//   String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/coach_model.dart';
import '../theme/app_theme2.dart';
import '../widgets/loading_overlay.dart';

class EditProfileScreen extends StatefulWidget {
  final Coach? initialCoach;
  const EditProfileScreen({super.key, this.initialCoach});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _currentStep = 0;

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _nationalIdController;
  late TextEditingController _educationLevelController;
  late TextEditingController _educationOtherController;
  late TextEditingController _fieldOfStudyController;
  late TextEditingController _fieldOfStudyOtherController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _certificationUrlController;
  late TextEditingController _regionController;
  late TextEditingController _zoneController;
  late TextEditingController _usernameController;

  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  bool _hasCertification = false;
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    final coach = widget.initialCoach ?? Provider.of<AuthProvider>(context, listen: false).coach;
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
      _certificationUrlController = TextEditingController(text: coach.certificationUrl ?? '');
      _regionController = TextEditingController(text: coach.region);
      _zoneController = TextEditingController(text: coach.zone);
      _usernameController = TextEditingController(text: coach.username);
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
      _certificationUrlController = TextEditingController();
      _regionController = TextEditingController();
      _zoneController = TextEditingController();
      _usernameController = TextEditingController();
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
    _certificationUrlController.dispose();
    _regionController.dispose();
    _zoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _nextStep() => setState(() => _currentStep++);
  void _previousStep() => setState(() => _currentStep--);

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDateOfBirth = picked);
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
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e'), backgroundColor: AppTheme.errorColor, behavior: SnackBarBehavior.floating),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
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
              color: isCompleted ? AppTheme.successColor : isActive ? AppTheme.primaryColor : Colors.grey.shade300,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text('${step + 1}', style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: isActive ? AppTheme.primaryColor : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildStepLine() => Container(width: 20, height: 2, color: Colors.grey.shade300);

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
              child: const Text('Save', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        backgroundColor: AppTheme.backgroundColor,
        body: Column(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_currentStep == 0) _buildPersonalInfoSection(),
                      if (_currentStep == 1) _buildProfessionalInfoSection(),
                      if (_currentStep == 2) _buildLocationInfoSection(),
                      if (_currentStep == 3) _buildAccountInfoSection(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (_currentStep > 0) Expanded(child: OutlinedButton(onPressed: _previousStep, style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primaryColor, side: const BorderSide(color: AppTheme.primaryColor), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Previous'))),
                          if (_currentStep > 0) const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _currentStep < 3 ? _nextStep : _saveProfile,
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: Text(_currentStep < 3 ? 'Next' : 'Save Changes'),
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
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.person, color: AppTheme.primaryColor)),
                const SizedBox(width: 12),
                const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Full name is required' : null),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.transgender, color: AppTheme.primaryColor)),
              items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => _selectedGender = v),
              validator: (v) => v == null ? 'Gender is required' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDateOfBirth,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Date of Birth', prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor)),
                child: Text(_selectedDateOfBirth != null ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}' : 'Select date of birth'),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryColor)), keyboardType: TextInputType.phone, validator: (v) => v == null || v.isEmpty ? 'Phone number is required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryColor)), keyboardType: TextInputType.emailAddress, validator: (v) { if (v == null || v.isEmpty) return 'Email is required'; if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Enter a valid email'; return null; }),
            const SizedBox(height: 16),
            TextFormField(controller: _nationalIdController, decoration: const InputDecoration(labelText: 'National ID', prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'National ID is required' : null),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.work, color: AppTheme.primaryColor)),
                const SizedBox(width: 12),
                const Text('Professional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(controller: _educationLevelController, decoration: const InputDecoration(labelText: 'Education Level', prefixIcon: Icon(Icons.school_outlined, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Education level is required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _educationOtherController, decoration: const InputDecoration(labelText: 'Education Other (specify)', prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor))),
            const SizedBox(height: 16),
            TextFormField(controller: _fieldOfStudyController, decoration: const InputDecoration(labelText: 'Field of Study', prefixIcon: Icon(Icons.science_outlined, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Field of study is required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _fieldOfStudyOtherController, decoration: const InputDecoration(labelText: 'Field of Study Other (specify)', prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor))),
            const SizedBox(height: 16),
            TextFormField(controller: _yearsOfExperienceController, decoration: const InputDecoration(labelText: 'Years of Experience', prefixIcon: Icon(Icons.timeline_outlined, color: AppTheme.primaryColor)), keyboardType: TextInputType.number, validator: (v) { if (v == null || v.isEmpty) return 'Years of experience is required'; if (int.tryParse(v) == null) return 'Enter a valid number'; return null; }),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(value: _hasCertification, onChanged: (v) => setState(() => _hasCertification = v ?? false), activeColor: AppTheme.primaryColor),
                const Expanded(child: Text('Has Professional Certification', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500))),
              ],
            ),
            if (_hasCertification) ...[
              const SizedBox(height: 16),
              TextFormField(controller: _certificationUrlController, decoration: const InputDecoration(labelText: 'Certification URL', prefixIcon: Icon(Icons.link, color: AppTheme.primaryColor))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.location_on, color: AppTheme.primaryColor)),
                const SizedBox(width: 12),
                const Text('Location Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(controller: _regionController, decoration: const InputDecoration(labelText: 'Region', prefixIcon: Icon(Icons.map_outlined, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Region is required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _zoneController, decoration: const InputDecoration(labelText: 'Zone / District', prefixIcon: Icon(Icons.location_city_outlined, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Zone/District is required' : null),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.computer, color: AppTheme.primaryColor)),
                const SizedBox(width: 12),
                const Text('Account Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor)), validator: (v) { if (v == null || v.isEmpty) return 'Username is required'; if (v.length < 4) return 'Username must be at least 4 characters'; return null; }),
          ],
        ),
      ),
    );
  }
}