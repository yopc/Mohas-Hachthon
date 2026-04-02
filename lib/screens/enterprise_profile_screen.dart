
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

// class _EnterpriseProfileScreenState extends State<EnterpriseProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 6, vsync: this);
//     _loadData();
//   }

//   void _loadData() {
//     Provider.of<IapProvider>(context, listen: false).fetchIap(widget.enterpriseId);
//     Provider.of<EvidenceProvider>(context, listen: false).fetchEvidence(widget.enterpriseId);
//     Provider.of<GraduationProvider>(context, listen: false).fetchChecklist(widget.enterpriseId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
//     final enterprise = enterpriseProvider.enterprises.firstWhere(
//       (e) => e.id == widget.enterpriseId,
//       orElse: () => throw Exception('Enterprise not found'),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(enterprise.businessName),
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
//           _buildOverviewTab(enterprise),
//           _buildBaselineTab(enterprise),
//           _buildIapTab(),
//           _buildCoachingTab(),
//           _buildEvidenceTab(),
//           _buildCertificatesTab(),
//         ],
//       ),
//       floatingActionButton: _buildFloatingButton(enterprise),
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
import '../models/enterprise.dart';
import '../providers/enterprise_provider.dart';
import '../providers/assessment_provider.dart';
import '../providers/session_provider.dart';
import '../providers/iap_provider.dart';
import '../providers/evidence_provider.dart';
import '../providers/graduation_provider.dart';
import '../theme/app_theme2.dart';
import 'iap_editor_screen.dart';
import 'graduation_checklist_screen.dart';
import '../widgets/evidence_picker.dart';

class EnterpriseProfileScreen extends StatefulWidget {
  final String enterpriseId;
  const EnterpriseProfileScreen({super.key, required this.enterpriseId});

  @override
  State<EnterpriseProfileScreen> createState() => _EnterpriseProfileScreenState();
}

class _EnterpriseProfileScreenState extends State<EnterpriseProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Enterprise? _enterprise;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadEnterprise();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEnterprise() async {
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context, listen: false);
    // Try to find in existing list
    Enterprise? existing = enterpriseProvider.enterprises.firstWhere(
      (e) => e.id == widget.enterpriseId,
      orElse: () => null as Enterprise,
    );
    setState(() {
      _enterprise = existing;
      _isLoading = false;
    });
    _loadData();
    return;
      // Fetch directly from Firestore
    final fetched = await enterpriseProvider.getEnterpriseById(widget.enterpriseId);
    if (mounted) {
      setState(() {
        _enterprise = fetched;
        _isLoading = false;
      });
      if (fetched != null) {
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enterprise not found'), backgroundColor: AppTheme.errorColor),
        );
      }
    }
  }

  void _loadData() {
    if (_enterprise == null) return;
    Provider.of<IapProvider>(context, listen: false).fetchIap(widget.enterpriseId);
    Provider.of<EvidenceProvider>(context, listen: false).fetchEvidence(widget.enterpriseId);
    Provider.of<GraduationProvider>(context, listen: false).fetchChecklist(widget.enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_enterprise == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Enterprise Not Found')),
        body: const Center(child: Text('Could not load enterprise details.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_enterprise!.businessName),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Baseline'),
            Tab(text: 'IAP'),
            Tab(text: 'Coaching'),
            Tab(text: 'Evidence'),
            Tab(text: 'Certificates'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(_enterprise!),
          _buildBaselineTab(_enterprise!),
          _buildIapTab(),
          _buildCoachingTab(),
          _buildEvidenceTab(),
          _buildCertificatesTab(),
        ],
      ),
      floatingActionButton: _buildFloatingButton(_enterprise!),
    );
  }

  Widget _buildOverviewTab(Enterprise enterprise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoCard(enterprise),
          const SizedBox(height: 16),
          _businessMetricsCard(enterprise),
          const SizedBox(height: 16),
          _scoresCard(enterprise),
        ],
      ),
    );
  }

  Widget _infoCard(Enterprise enterprise) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Owner'),
              subtitle: Text(enterprise.ownerName),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(enterprise.phone),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
              subtitle: Text(enterprise.location),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Sector'),
              subtitle: Text(enterprise.sector),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Registered'),
              subtitle: Text(_formatDate(enterprise.registrationDate)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _businessMetricsCard(Enterprise enterprise) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Business Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Monthly Revenue', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(
                        '${enterprise.baselineMonthlyRevenue?.toStringAsFixed(0) ?? '—'} ETB',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Baseline', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Current', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(
                        '${enterprise.currentMonthlyRevenue?.toStringAsFixed(0) ?? '—'} ETB',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildChangeIndicator(
                        enterprise.baselineMonthlyRevenue,
                        enterprise.currentMonthlyRevenue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Employees', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(
                        '${enterprise.baselineEmployees ?? '—'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Baseline', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Current', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(
                        '${enterprise.currentEmployees ?? '—'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildEmployeeChange(enterprise.baselineEmployees, enterprise.currentEmployees),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoresCard(Enterprise enterprise) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _scoreRow('Finance', enterprise.financeScore),
            _scoreRow('Marketing', enterprise.marketingScore),
            _scoreRow('Operations', enterprise.operationsScore),
            _scoreRow('HR', enterprise.hrScore),
            _scoreRow('Governance', enterprise.governanceScore),
            const Divider(),
            _scoreRow('Overall', enterprise.overallScore, isOverall: true),
          ],
        ),
      ),
    );
  }

  Widget _scoreRow(String label, double score, {bool isOverall = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(fontWeight: isOverall ? FontWeight.bold : FontWeight.normal)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.getScoreColor(score)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${score.toInt()}%',
            style: TextStyle(fontWeight: isOverall ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeIndicator(double? baseline, double? current) {
    if (baseline == null || current == null) return const SizedBox.shrink();
    final diff = current - baseline;
    final percent = (diff / baseline * 100).abs().toStringAsFixed(0);
    final isPositive = diff >= 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 16, color: isPositive ? AppTheme.successColor : AppTheme.errorColor),
        const SizedBox(width: 4),
        Text(
          '$percent%',
          style: TextStyle(color: isPositive ? AppTheme.successColor : AppTheme.errorColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEmployeeChange(int? baseline, int? current) {
    if (baseline == null || current == null) return const SizedBox.shrink();
    final diff = current - baseline;
    final isPositive = diff >= 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isPositive ? Icons.add : Icons.remove, size: 16, color: isPositive ? AppTheme.successColor : AppTheme.errorColor),
        const SizedBox(width: 4),
        Text(
          diff.abs().toString(),
          style: TextStyle(color: isPositive ? AppTheme.successColor : AppTheme.errorColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBaselineTab(Enterprise enterprise) {
    return FutureBuilder(
      future: Provider.of<AssessmentProvider>(context, listen: false)
          .getBaselineForEnterprise(enterprise.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final baseline = snapshot.data;
        if (baseline == null) {
          return const Center(child: Text('No baseline assessment found.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Baseline Assessment', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Date: ${_formatDate(baseline.date)}'),
                      const SizedBox(height: 16),
                      ...baseline.strengths.map((s) => _bulletPoint(Icons.check_circle, s, AppTheme.successColor)),
                      ...baseline.weaknesses.map((w) => _bulletPoint(Icons.warning, w, AppTheme.warningColor)),
                      const SizedBox(height: 16),
                      const Text('Recommendations', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...baseline.recommendations.map((r) => _bulletPoint(Icons.lightbulb, r, Colors.amber)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bulletPoint(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildIapTab() {
    return Consumer<IapProvider>(
      builder: (context, iapProvider, _) {
        final iap = iapProvider.iap;
        if (iapProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (iap == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No IAP found.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IapEditorScreen(enterpriseId: widget.enterpriseId),
                      ),
                    ).then((_) => iapProvider.fetchIap(widget.enterpriseId));
                  },
                  child: const Text('Create IAP'),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: iap.tasks.length,
          itemBuilder: (context, index) {
            final task = iap.tasks[index];
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: task.status == 'done',
                  onChanged: (value) {
                    iapProvider.updateTaskStatus(iap.id, task.id, value! ? 'done' : 'in_progress');
                  },
                ),
                title: Text(task.description),
                subtitle: Text('Owner: ${task.owner} | Due: ${task.dueDate != null ? _formatDate(task.dueDate!) : 'No deadline'}'),
                trailing: task.status == 'done' ? const Icon(Icons.check_circle, color: AppTheme.successColor) : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCoachingTab() {
    final sessions = Provider.of<SessionProvider>(context).sessions
        .where((s) => s.enterpriseId == widget.enterpriseId)
        .toList();
    if (sessions.isEmpty) {
      return const Center(child: Text('No coaching sessions yet.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          child: ListTile(
            title: Text('${session.type} - ${_formatDate(session.scheduledDate)}'),
            subtitle: Text(session.notes),
            trailing: session.isCompleted ? const Icon(Icons.check, color: AppTheme.successColor) : null,
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildEvidenceTab() {
    return Consumer<EvidenceProvider>(
      builder: (context, evidenceProvider, _) {
        final evidences = evidenceProvider.evidences;
        if (evidenceProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EvidencePicker(
                      enterpriseId: widget.enterpriseId,
                      recordType: 'enterprise',
                      recordId: widget.enterpriseId,
                      onUploaded: (newEvidences) async {
                        for (var evidence in newEvidences) {
                          await evidenceProvider.addEvidence(evidence);
                        }
                        evidenceProvider.fetchEvidence(widget.enterpriseId);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Add Evidence'),
              ),
            ),
            if (evidences.isEmpty)
              const Expanded(child: Center(child: Text('No evidence uploaded yet.')))
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: evidences.length,
                  itemBuilder: (context, index) {
                    final evidence = evidences[index];
                    return Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(evidence.url, fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(evidence.recordType),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCertificatesTab() {
    return Consumer<GraduationProvider>(
      builder: (context, gradProvider, _) {
        final checklist = gradProvider.checklist;
        if (gradProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Graduation Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _requirementTile('Baseline present', checklist?.baselinePresent ?? false),
                      _requirementTile('Minimum 8 coaching visits', checklist?.minCoachingVisits ?? false),
                      _requirementTile('Midline better than baseline', checklist?.midlineBetter ?? false),
                      _requirementTile('Coach sign-off', checklist?.coachSignOff ?? false),
                      _requirementTile('Evidence pack complete', checklist?.evidencePack ?? false),
                      _requirementTile('M&E approval', checklist?.mAndEApproved ?? false),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (checklist != null && !checklist.mAndEApproved)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GraduationChecklistScreen(enterpriseId: widget.enterpriseId),
                      ),
                    ).then((_) => gradProvider.fetchChecklist(widget.enterpriseId));
                  },
                  icon: const Icon(Icons.request_page),
                  label: const Text('Request Graduation'),
                ),
              if (checklist != null && checklist.mAndEApproved)
                ElevatedButton.icon(
                  onPressed: () {
                    // Show certificate
                  },
                  icon: const Icon(Icons.verified),
                  label: const Text('View Certificate'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _requirementTile(String label, bool isMet) {
    return ListTile(
      leading: Icon(isMet ? Icons.check_circle : Icons.cancel, color: isMet ? AppTheme.successColor : AppTheme.errorColor),
      title: Text(label),
      trailing: isMet ? const Text('Met', style: TextStyle(color: AppTheme.successColor)) : const Text('Not met', style: TextStyle(color: AppTheme.errorColor)),
    );
  }

  Widget? _buildFloatingButton(Enterprise enterprise) {
    const isGraduationPending = false; // TODO: check actual graduation status
    if (!isGraduationPending) {
      return FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IapEditorScreen(enterpriseId: widget.enterpriseId),
            ),
          ).then((_) => _loadData());
        },
      );
    }
    return null;
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}