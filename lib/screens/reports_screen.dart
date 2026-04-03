// import 'package:flutter/material.dart';
// import '../theme/app_theme2.dart';

// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Generate Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//                   const SizedBox(height: 16),
//                   _buildReportOption(
//                     icon: Icons.person,
//                     title: 'Coach Performance Report',
//                     subtitle: 'Your activity, sessions, and enterprise progress',
//                     color: Colors.blue,
//                     onTap: () {},
//                   ),
//                   _buildReportOption(
//                     icon: Icons.business,
//                     title: 'Enterprise Progress Report',
//                     subtitle: 'Detailed progress of all your enterprises',
//                     color: Colors.green,
//                     onTap: () {},
//                   ),
//                   _buildReportOption(
//                     icon: Icons.assignment_turned_in,
//                     title: 'Assessment Summary',
//                     subtitle: 'Overview of all assessments conducted',
//                     color: Colors.orange,
//                     onTap: () {},
//                   ),
//                   _buildReportOption(
//                     icon: Icons.trending_up,
//                     title: 'Impact Analysis',
//                     subtitle: 'Program impact and success metrics',
//                     color: Colors.purple,
//                     onTap: () {},
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Recent Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//                   const SizedBox(height: 16),
//                   _buildRecentReportItem('Coach Performance - March 2025', 'Generated 2 days ago', 'PDF'),
//                   const Divider(height: 24),
//                   _buildRecentReportItem('Enterprise Progress Q1 2025', 'Generated 5 days ago', 'Excel'),
//                   const Divider(height: 24),
//                   _buildRecentReportItem('Assessment Summary - Q1', 'Generated 1 week ago', 'PDF'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: AppTheme.primaryColor.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: AppTheme.primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.schedule, color: AppTheme.primaryColor, size: 24),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Automated Reports', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//                         const SizedBox(height: 4),
//                         Text('Get weekly reports delivered to your email', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
//                       ],
//                     ),
//                   ),
//                   Switch(value: true, onChanged: (value) {}, activeColor: AppTheme.primaryColor),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReportOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, color: color, size: 24),
//       ),
//       title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
//       subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//       trailing: const Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
//       onTap: onTap,
//     );
//   }

//   Widget _buildRecentReportItem(String title, String date, String format) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             format == 'PDF' ? Icons.picture_as_pdf : Icons.insert_drive_file,
//             color: format == 'PDF' ? Colors.red : Colors.green,
//             size: 20,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
//               const SizedBox(height: 2),
//               Text(date, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.download, size: 20),
//           color: Colors.grey.shade600,
//           onPressed: () {},
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';

// import '../providers/auth_provider.dart';
// import '../providers/enterprise_provider.dart';
// import '../providers/session_provider.dart';
// import '../providers/assessment_provider.dart';
// import '../providers/iap_provider.dart';
// import '../providers/training_provider.dart';
// import '../providers/graduation_provider.dart';
// import '../models/enterprise.dart';
// import '../models/assessment.dart';
// import '../models/session.dart';
// import '../models/iap.dart';
// import '../theme/app_theme2.dart';

// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> {
//   DateTimeRange _dateRange = DateTimeRange(
//     start: DateTime(DateTime.now().year, DateTime.now().month, 1),
//     end: DateTime.now(),
//   );
//   bool _isGenerating = false;
//   String? _selectedCoachId;
//   List<String> _coachList = [];
//   bool _isLoadingCoaches = false;

//   // Aggregated data for preview
//   int _totalEnterprises = 0;
//   int _graduatedEnterprises = 0;
//   double _avgRevenueGrowth = 0.0;
//   int _totalJobsCreated = 0;
//   int _totalCoachingSessions = 0;
//   double _avgIapCompletion = 0.0;
//   int _baselineCompleted = 0;
//   int _midlineBetter = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     if (auth.coach?.role == 'supervisor') {
//       _loadCoachList();
//     }
//   }

//   Future<void> _loadInitialData() async {
//     await _fetchDataAndCompute();
//   }

//   Future<void> _loadCoachList() async {
//     setState(() => _isLoadingCoaches = true);
//     try {
//       final usersSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('role', isEqualTo: 'coach')
//           .get();
//       final coaches = usersSnapshot.docs
//           .map((doc) => doc.data()['fullName'] as String)
//           .toList();
//       setState(() {
//         _coachList = coaches;
//         _isLoadingCoaches = false;
//       });
//     } catch (e) {
//       setState(() => _isLoadingCoaches = false);
//     }
//   }

//   Future<void> _fetchDataAndCompute() async {
//     setState(() => _isGenerating = true);

//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     final isSupervisor = auth.coach?.role == 'supervisor';

//     final enterpriseProvider = Provider.of<EnterpriseProvider>(context, listen: false);
//     if (isSupervisor) {
//       enterpriseProvider.fetchEnterprises(role: 'supervisor');
//     } else {
//       enterpriseProvider.fetchEnterprises();
//     }
//     await Future.delayed(const Duration(milliseconds: 800));

//     final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
//     final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
//     final iapProvider = Provider.of<IapProvider>(context, listen: false);

//     List<Enterprise> enterprises = List.from(enterpriseProvider.enterprises);
//     enterprises = enterprises.where((e) =>
//         e.registrationDate.isAfter(_dateRange.start) &&
//         e.registrationDate.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();

//     if (isSupervisor && _selectedCoachId != null && _selectedCoachId!.isNotEmpty) {
//       enterprises = enterprises.where((e) => e.coachId == _selectedCoachId).toList();
//     }

//     int graduated = 0;
//     double totalRevenueGrowth = 0.0;
//     int revenueCount = 0;
//     int totalJobs = 0;
//     int totalSessions = 0;
//     double totalIapCompletion = 0.0;
//     int iapCount = 0;
//     int baselineDone = 0;
//     int midlineImproved = 0;

//     for (var enterprise in enterprises) {
//       if (enterprise.status == 'Graduated') graduated++;

//       if (enterprise.baselineMonthlyRevenue != null &&
//           enterprise.currentMonthlyRevenue != null &&
//           enterprise.baselineMonthlyRevenue! > 0) {
//         final growth = (enterprise.currentMonthlyRevenue! - enterprise.baselineMonthlyRevenue!) /
//             enterprise.baselineMonthlyRevenue! *
//             100;
//         totalRevenueGrowth += growth;
//         revenueCount++;
//       }

//       if (enterprise.baselineEmployees != null && enterprise.currentEmployees != null) {
//         totalJobs += (enterprise.currentEmployees! - enterprise.baselineEmployees!);
//       }

//       final sessions = sessionProvider.sessions
//           .where((s) =>
//               s.enterpriseId == enterprise.id &&
//               s.actualDate != null &&
//               s.actualDate!.isAfter(_dateRange.start) &&
//               s.actualDate!.isBefore(_dateRange.end.add(const Duration(days: 1))))
//           .length;
//       totalSessions += sessions;

//       await iapProvider.fetchIap(enterprise.id);
//       final iap = iapProvider.iap;
//       if (iap != null && iap.tasks.isNotEmpty) {
//         final done = iap.tasks.where((t) => t.status == 'done').length;
//         final percent = (done / iap.tasks.length) * 100;
//         totalIapCompletion += percent;
//         iapCount++;
//       }

//       final baseline = await assessmentProvider.getBaselineForEnterprise(enterprise.id);
//       if (baseline != null) baselineDone++;

//       if (enterprise.currentMonthlyRevenue != null &&
//           enterprise.baselineMonthlyRevenue != null &&
//           enterprise.currentMonthlyRevenue! > enterprise.baselineMonthlyRevenue!) {
//         midlineImproved++;
//       }
//     }

//     setState(() {
//       _totalEnterprises = enterprises.length;
//       _graduatedEnterprises = graduated;
//       _avgRevenueGrowth = revenueCount > 0 ? totalRevenueGrowth / revenueCount : 0.0;
//       _totalJobsCreated = totalJobs;
//       _totalCoachingSessions = totalSessions;
//       _avgIapCompletion = iapCount > 0 ? totalIapCompletion / iapCount : 0.0;
//       _baselineCompleted = baselineDone;
//       _midlineBetter = midlineImproved;
//       _isGenerating = false;
//     });
//   }

//   Future<void> _generateExcelReport() async {
//     setState(() => _isGenerating = true);

//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     final isSupervisor = auth.coach?.role == 'supervisor';

//     final enterpriseProvider = Provider.of<EnterpriseProvider>(context, listen: false);
//     final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
//     final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
//     final iapProvider = Provider.of<IapProvider>(context, listen: false);
//     final graduationProvider = Provider.of<GraduationProvider>(context, listen: false);

//     if (isSupervisor) {
//       enterpriseProvider.fetchEnterprises(role: 'supervisor');
//     } else {
//       enterpriseProvider.fetchEnterprises();
//     }
//     await Future.delayed(const Duration(milliseconds: 800));

//     List<Enterprise> enterprises = List.from(enterpriseProvider.enterprises);
//     enterprises = enterprises.where((e) =>
//         e.registrationDate.isAfter(_dateRange.start) &&
//         e.registrationDate.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();

//     if (isSupervisor && _selectedCoachId != null && _selectedCoachId!.isNotEmpty) {
//       enterprises = enterprises.where((e) => e.coachId == _selectedCoachId).toList();
//     }

//     var excel = Excel.createExcel();
//     var kpiSheet = excel['Program KPIs'];
//     var detailsSheet = excel['Enterprise Details'];

//     // Helper to convert any value to CellValue
//     CellValue? toCellValue(dynamic value) {
//       if (value == null) return null;
//       if (value is String) return TextCellValue(value);
//       if (value is int) return IntCellValue(value);
//       if (value is double) return DoubleCellValue(value);
//       if (value is bool) return BoolCellValue(value);
//       return TextCellValue(value.toString());
//     }

//     // KPI Sheet
//     kpiSheet.appendRow(['Metric', 'Value'].map(toCellValue).toList());
//     kpiSheet.appendRow(['Report Period', '${_dateRange.start.toLocal()} to ${_dateRange.end.toLocal()}'].map(toCellValue).toList());
//     kpiSheet.appendRow(['Total Enterprises', _totalEnterprises].map(toCellValue).toList());
//     kpiSheet.appendRow(['Graduated Enterprises', _graduatedEnterprises].map(toCellValue).toList());
//     kpiSheet.appendRow(['Baseline Completed', _baselineCompleted].map(toCellValue).toList());
//     kpiSheet.appendRow(['Midline Better than Baseline', _midlineBetter].map(toCellValue).toList());
//     kpiSheet.appendRow(['Average Revenue Growth (%)', _avgRevenueGrowth].map(toCellValue).toList());
//     kpiSheet.appendRow(['Total Jobs Created', _totalJobsCreated].map(toCellValue).toList());
//     kpiSheet.appendRow(['Total Coaching Sessions', _totalCoachingSessions].map(toCellValue).toList());
//     kpiSheet.appendRow(['Average IAP Completion (%)', _avgIapCompletion].map(toCellValue).toList());

//     int enterprisesWithMin8Sessions = 0;
//     for (var e in enterprises) {
//       final sessions = sessionProvider.sessions.where((s) => s.enterpriseId == e.id && s.actualDate != null).length;
//       if (sessions >= 8) enterprisesWithMin8Sessions++;
//     }
//     kpiSheet.appendRow(['Enterprises with >=8 Coaching Sessions', enterprisesWithMin8Sessions].map(toCellValue).toList());

//     // Details Sheet
//     detailsSheet.appendRow([
//       'Enterprise Name',
//       'Owner',
//       'Sector',
//       'Region',
//       'Status',
//       'Baseline Revenue',
//       'Current Revenue',
//       'Revenue Growth %',
//       'Baseline Employees',
//       'Current Employees',
//       'Jobs Created',
//       'Coaching Sessions',
//       'IAP Tasks Done/Total',
//       'IAP Completion %',
//       'Graduation Approved'
//     ].map(toCellValue).toList());

//     for (var enterprise in enterprises) {
//       double revenueGrowth = 0.0;
//       if (enterprise.baselineMonthlyRevenue != null &&
//           enterprise.currentMonthlyRevenue != null &&
//           enterprise.baselineMonthlyRevenue! > 0) {
//         revenueGrowth = (enterprise.currentMonthlyRevenue! - enterprise.baselineMonthlyRevenue!) /
//             enterprise.baselineMonthlyRevenue! *
//             100;
//       }

//       int jobsCreated = 0;
//       if (enterprise.baselineEmployees != null && enterprise.currentEmployees != null) {
//         jobsCreated = enterprise.currentEmployees! - enterprise.baselineEmployees!;
//       }

//       final sessionsCount = sessionProvider.sessions
//           .where((s) => s.enterpriseId == enterprise.id && s.actualDate != null)
//           .length;

//       await iapProvider.fetchIap(enterprise.id);
//       final iap = iapProvider.iap;
//       int tasksDone = 0;
//       int totalTasks = 0;
//       double iapCompletion = 0.0;
//       if (iap != null) {
//         totalTasks = iap.tasks.length;
//         tasksDone = iap.tasks.where((t) => t.status == 'done').length;
//         if (totalTasks > 0) iapCompletion = (tasksDone / totalTasks) * 100;
//       }

//       await graduationProvider.fetchChecklist(enterprise.id);
//       bool isGraduated = graduationProvider.checklist?.mAndEApproved ?? false;

//       detailsSheet.appendRow([
//         enterprise.businessName,
//         enterprise.ownerName,
//         enterprise.sector,
//         enterprise.location,
//         enterprise.status,
//         enterprise.baselineMonthlyRevenue?.toStringAsFixed(2) ?? '0',
//         enterprise.currentMonthlyRevenue?.toStringAsFixed(2) ?? '0',
//         revenueGrowth.toStringAsFixed(2),
//         enterprise.baselineEmployees?.toString() ?? '0',
//         enterprise.currentEmployees?.toString() ?? '0',
//         jobsCreated.toString(),
//         sessionsCount.toString(),
//         '$tasksDone/$totalTasks',
//         iapCompletion.toStringAsFixed(2),
//         isGraduated ? 'Yes' : 'No'
//       ].map(toCellValue).toList());
//     }

//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/MESMER_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
//     File(filePath)
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(excel.encode()!);

//     setState(() => _isGenerating = false);
//     await Share.shareXFiles([XFile(filePath)], text: 'MESMER Program Report');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);
//     final isSupervisor = auth.coach?.role == 'supervisor';

//     return Scaffold(
//       appBar: AppBar(title: const Text('Reports & Analytics')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Select Period', style: TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             '${_dateRange.start.toLocal().toString().split(' ')[0]} → ${_dateRange.end.toLocal().toString().split(' ')[0]}',
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.calendar_today),
//                           onPressed: () async {
//                             final picked = await showDateRangePicker(
//                               context: context,
//                               firstDate: DateTime(2020),
//                               lastDate: DateTime.now(),
//                               initialDateRange: _dateRange,
//                             );
//                             if (picked != null) {
//                               setState(() => _dateRange = picked);
//                               await _fetchDataAndCompute();
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (isSupervisor)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: DropdownButtonFormField<String>(
//                     value: _selectedCoachId,
//                     hint: const Text('Filter by Coach (optional)'),
//                     items: _coachList.map((coach) {
//                       return DropdownMenuItem<String>(
//                         value: coach,
//                         child: Text(coach),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() => _selectedCoachId = value);
//                       _fetchDataAndCompute();
//                     },
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             if (!_isGenerating) ...[
//               Row(
//                 children: [
//                   Expanded(child: _buildMetricCard('Total Enterprises', _totalEnterprises.toString(), Icons.business)),
//                   Expanded(child: _buildMetricCard('Graduated', _graduatedEnterprises.toString(), Icons.emoji_events)),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(child: _buildMetricCard('Avg Revenue Growth', '${_avgRevenueGrowth.toStringAsFixed(1)}%', Icons.trending_up)),
//                   Expanded(child: _buildMetricCard('Jobs Created', _totalJobsCreated.toString(), Icons.people)),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(child: _buildMetricCard('Coaching Sessions', _totalCoachingSessions.toString(), Icons.event)),
//                   Expanded(child: _buildMetricCard('IAP Completion', '${_avgIapCompletion.toStringAsFixed(1)}%', Icons.checklist)),
//                 ],
//               ),
//             ] else
//               const Center(child: CircularProgressIndicator()),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _isGenerating ? null : _generateExcelReport,
//                 icon: const Icon(Icons.download),
//                 label: const Text('Download Excel Report'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   backgroundColor: AppTheme.primaryColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMetricCard(String label, String value, IconData icon) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Icon(icon, color: AppTheme.primaryColor, size: 28),
//             const SizedBox(height: 8),
//             Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:html' as html;
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import '../providers/auth_provider.dart';
// import '../models/enterprise.dart';
// import '../theme/app_theme2.dart';

// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> {
//   DateTimeRange _dateRange = DateTimeRange(
//     start: DateTime(2020, 1, 1),
//     end: DateTime.now(),
//   );
//   bool _isLoading = false;
//   bool _isGenerating = false;
//   String? _selectedCoachId;
//   List<String> _coachList = [];
//   bool _isLoadingCoaches = false;

//   int _totalEnterprises = 0;
//   int _graduatedEnterprises = 0;
//   double _avgRevenueGrowth = 0.0;
//   int _totalJobsCreated = 0;
//   int _totalCoachingSessions = 0;
//   double _avgIapCompletion = 0.0;
//   int _baselineCompleted = 0;
//   int _midlineBetter = 0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadData();
//       final auth = Provider.of<AuthProvider>(context, listen: false);
//       if (auth.coach?.role == 'supervisor') {
//         _loadCoachList();
//       }
//     });
//   }

//   Future<void> _loadData() async {
//     setState(() => _isLoading = true);
//     await _fetchReportData();
//     setState(() => _isLoading = false);
//   }

//   Future<void> _loadCoachList() async {
//     setState(() => _isLoadingCoaches = true);
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('role', isEqualTo: 'coach')
//           .get();
//       final coaches = snapshot.docs.map((d) => d.data()['fullName'] as String).toList();
//       setState(() {
//         _coachList = coaches;
//         _isLoadingCoaches = false;
//       });
//     } catch (e) {
//       print('Error loading coaches: $e');
//       setState(() => _isLoadingCoaches = false);
//     }
//   }

//   QueryDocumentSnapshot<Map<String, dynamic>>? _findDoc(
//       List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
//       bool Function(Map<String, dynamic>) predicate) {
//     for (var doc in docs) {
//       if (predicate(doc.data())) return doc;
//     }
//     return null;
//   }

//   Future<void> _fetchReportData() async {
//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     final isSupervisor = auth.coach?.role == 'supervisor';
//     final coachId = auth.user?.uid;

//     Query query = FirebaseFirestore.instance.collection('enterprises');
//     if (!isSupervisor) {
//       query = query.where('coachId', isEqualTo: coachId);
//     }
//     final snapshot = await query.get();
//     List<Enterprise> enterprises = snapshot.docs
//         .map((doc) => Enterprise.fromMap(doc.id, doc.data()! as Map<String, dynamic>))
//         .toList();

//     // Apply date range filter
//     enterprises = enterprises.where((e) =>
//         e.registrationDate.isAfter(_dateRange.start) &&
//         e.registrationDate.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();

//     if (isSupervisor && _selectedCoachId != null && _selectedCoachId!.isNotEmpty) {
//       enterprises = enterprises.where((e) => e.coachId == _selectedCoachId).toList();
//     }

//     final allSessions = await FirebaseFirestore.instance.collection('sessions').get();
//     final allAssessments = await FirebaseFirestore.instance.collection('assessments').get();
//     final allIaps = await FirebaseFirestore.instance.collection('iaps').get();

//     int graduated = 0;
//     double totalRevenueGrowth = 0.0;
//     int revenueCount = 0;
//     int totalJobs = 0;
//     int totalSessions = 0;
//     double totalIapCompletion = 0.0;
//     int iapCount = 0;
//     int baselineDone = 0;
//     int midlineImproved = 0;

//     for (var e in enterprises) {
//       if (e.status == 'Graduated') graduated++;

//       if (e.baselineMonthlyRevenue != null && e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue! > 0) {
//         final growth = (e.currentMonthlyRevenue! - e.baselineMonthlyRevenue!) / e.baselineMonthlyRevenue! * 100;
//         totalRevenueGrowth += growth;
//         revenueCount++;
//       }

//       if (e.baselineEmployees != null && e.currentEmployees != null) {
//         totalJobs += (e.currentEmployees! - e.baselineEmployees!);
//       }

//       final sessions = allSessions.docs
//           .where((doc) => doc.data()['enterpriseId'] == e.id && doc.data()['actualDate'] != null)
//           .length;
//       totalSessions += sessions;

//       final iapDoc = _findDoc(allIaps.docs, (data) => data['enterpriseId'] == e.id);
//       if (iapDoc != null) {
//         final tasks = List<Map<String, dynamic>>.from(iapDoc.data()['tasks'] ?? []);
//         if (tasks.isNotEmpty) {
//           final done = tasks.where((t) => t['status'] == 'done').length;
//           final percent = done / tasks.length * 100;
//           totalIapCompletion += percent;
//           iapCount++;
//         }
//       }

//       final baseline = _findDoc(allAssessments.docs, (data) => data['enterpriseId'] == e.id && data['type'] == 'Baseline');
//       if (baseline != null) baselineDone++;

//       if (e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue != null &&
//           e.currentMonthlyRevenue! > e.baselineMonthlyRevenue!) {
//         midlineImproved++;
//       }
//     }

//     setState(() {
//       _totalEnterprises = enterprises.length;
//       _graduatedEnterprises = graduated;
//       _avgRevenueGrowth = revenueCount > 0 ? totalRevenueGrowth / revenueCount : 0.0;
//       _totalJobsCreated = totalJobs;
//       _totalCoachingSessions = totalSessions;
//       _avgIapCompletion = iapCount > 0 ? totalIapCompletion / iapCount : 0.0;
//       _baselineCompleted = baselineDone;
//       _midlineBetter = midlineImproved;
//     });
//   }

//   Future<void> _generateCSVReport() async {
//     setState(() => _isGenerating = true);

//     try {
//       // Fetch fresh data (same as _fetchReportData but re-fetch to ensure freshness)
//       final auth = Provider.of<AuthProvider>(context, listen: false);
//       final isSupervisor = auth.coach?.role == 'supervisor';
//       final coachId = auth.user?.uid;

//       Query query = FirebaseFirestore.instance.collection('enterprises');
//       if (!isSupervisor) {
//         query = query.where('coachId', isEqualTo: coachId);
//       }
//       final snapshot = await query.get();
//       List<Enterprise> enterprises = snapshot.docs
//           .map((doc) => Enterprise.fromMap(doc.id, doc.data()! as Map<String, dynamic>))
//           .where((e) =>
//               e.registrationDate.isAfter(_dateRange.start) &&
//               e.registrationDate.isBefore(_dateRange.end.add(const Duration(days: 1))))
//           .toList();

//       if (isSupervisor && _selectedCoachId != null && _selectedCoachId!.isNotEmpty) {
//         enterprises = enterprises.where((e) => e.coachId == _selectedCoachId).toList();
//       }

//       if (enterprises.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No data available for the selected period.')),
//         );
//         setState(() => _isGenerating = false);
//         return;
//       }

//       final allSessions = await FirebaseFirestore.instance.collection('sessions').get();
//       final allIaps = await FirebaseFirestore.instance.collection('iaps').get();
//       final allChecklists = await FirebaseFirestore.instance.collection('graduation_checklists').get();

//       // Build CSV content
//       StringBuffer csv = StringBuffer();
      
//       // Headers
//       csv.writeln('"Enterprise Name","Owner","Sector","Region","Status","Baseline Revenue","Current Revenue","Revenue Growth %","Baseline Employees","Current Employees","Jobs Created","Coaching Sessions","IAP Tasks Done/Total","IAP Completion %","Graduation Approved"');
      
//       for (var e in enterprises) {
//         // Revenue growth
//         double revenueGrowth = 0.0;
//         if (e.baselineMonthlyRevenue != null && e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue! > 0) {
//           revenueGrowth = (e.currentMonthlyRevenue! - e.baselineMonthlyRevenue!) / e.baselineMonthlyRevenue! * 100;
//         }
        
//         // Jobs created
//         int jobsCreated = 0;
//         if (e.baselineEmployees != null && e.currentEmployees != null) {
//           jobsCreated = e.currentEmployees! - e.baselineEmployees!;
//         }
        
//         // Coaching sessions count
//         int sessionsCount = allSessions.docs
//             .where((doc) => doc.data()['enterpriseId'] == e.id && doc.data()['actualDate'] != null)
//             .length;
        
//         // IAP details
//         final iapDoc = _findDoc(allIaps.docs, (data) => data['enterpriseId'] == e.id);
//         int tasksDone = 0;
//         int totalTasks = 0;
//         double iapCompletion = 0.0;
//         if (iapDoc != null) {
//           final tasks = List<Map<String, dynamic>>.from(iapDoc.data()['tasks'] ?? []);
//           totalTasks = tasks.length;
//           tasksDone = tasks.where((t) => t['status'] == 'done').length;
//           if (totalTasks > 0) iapCompletion = tasksDone / totalTasks * 100;
//         }
        
//         // Graduation approval
//         final checklist = _findDoc(allChecklists.docs, (data) => data['enterpriseId'] == e.id);
//         bool isGraduated = checklist != null && checklist.data()['mAndEApproved'] == true;
        
//         // Build row (escape quotes by doubling them)
//         String escape(String s) => '"${s.replaceAll('"', '""')}"';
        
//         csv.writeln('${escape(e.businessName)},${escape(e.ownerName)},${escape(e.sector)},${escape(e.location)},${escape(e.status)},'
//             '${e.baselineMonthlyRevenue?.toStringAsFixed(2) ?? '0'},'
//             '${e.currentMonthlyRevenue?.toStringAsFixed(2) ?? '0'},'
//             '${revenueGrowth.toStringAsFixed(2)},'
//             '${e.baselineEmployees ?? 0},'
//             '${e.currentEmployees ?? 0},'
//             '$jobsCreated,'
//             '$sessionsCount,'
//             '"$tasksDone/$totalTasks",'
//             '${iapCompletion.toStringAsFixed(2)},'
//             '${isGraduated ? "Yes" : "No"}');
//       }
      
//       // Add KPI summary as extra rows at the top or bottom? We'll add a separate section.
//       StringBuffer summary = StringBuffer();
//       summary.writeln();
//       summary.writeln('"Program KPIs"');
//       summary.writeln('"Metric","Value"');
//       summary.writeln('"Report Period","${_dateRange.start.toLocal()} to ${_dateRange.end.toLocal()}"');
//       summary.writeln('"Total Enterprises",$_totalEnterprises');
//       summary.writeln('"Graduated Enterprises",$_graduatedEnterprises');
//       summary.writeln('"Baseline Completed",$_baselineCompleted');
//       summary.writeln('"Midline Better than Baseline",$_midlineBetter');
//       summary.writeln('"Average Revenue Growth (%)",${_avgRevenueGrowth.toStringAsFixed(2)}');
//       summary.writeln('"Total Jobs Created",$_totalJobsCreated');
//       summary.writeln('"Total Coaching Sessions",$_totalCoachingSessions');
//       summary.writeln('"Average IAP Completion (%)",${_avgIapCompletion.toStringAsFixed(2)}');
      
//       int enterprisesWithMin8Sessions = 0;
//       for (var e in enterprises) {
//         final sessions = allSessions.docs.where((doc) => doc.data()['enterpriseId'] == e.id && doc.data()['actualDate'] != null).length;
//         if (sessions >= 8) enterprisesWithMin8Sessions++;
//       }
//       summary.writeln('"Enterprises with >=8 Coaching Sessions",$enterprisesWithMin8Sessions');
      
//       String fullCsv = summary.toString() + '\n' + csv.toString();
      
//       // Convert to bytes
//       final bytes = Uint8List.fromList(fullCsv.codeUnits);
      
//       // Download or share
//       if (kIsWeb) {
//         final blob = html.Blob([bytes], 'text/csv');
//         final url = html.Url.createObjectUrlFromBlob(blob);
//         final anchor = html.AnchorElement(href: url)
//           ..setAttribute('download', 'MESMER_Report_${DateTime.now().millisecondsSinceEpoch}.csv')
//           ..click();
//         html.Url.revokeObjectUrl(url);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Report downloaded as CSV.')),
//         );
//       } else {
//         final dir = await getTemporaryDirectory();
//         final filePath = '${dir.path}/MESMER_Report_${DateTime.now().millisecondsSinceEpoch}.csv';
//         await File(filePath).writeAsBytes(bytes);
//         await Share.shareXFiles([XFile(filePath)], text: 'MESMER Program Report');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Report shared.')),
//         );
//       }
//     } catch (e) {
//       print('CSV generation error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to generate report: $e')),
//       );
//     } finally {
//       setState(() => _isGenerating = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSupervisor = Provider.of<AuthProvider>(context).coach?.role == 'supervisor';

//     return Scaffold(
//       appBar: AppBar(title: const Text('Reports & Analytics')),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Select Period', style: TextStyle(fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   '${_dateRange.start.toLocal().toString().split(' ')[0]} → ${_dateRange.end.toLocal().toString().split(' ')[0]}',
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.calendar_today),
//                                 onPressed: () async {
//                                   final picked = await showDateRangePicker(
//                                     context: context,
//                                     firstDate: DateTime(2020),
//                                     lastDate: DateTime.now(),
//                                     initialDateRange: _dateRange,
//                                   );
//                                   if (picked != null) {
//                                     setState(() => _dateRange = picked);
//                                     await _loadData();
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (isSupervisor)
//                     Card(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: DropdownButtonFormField<String>(
//                           value: _selectedCoachId,
//                           hint: const Text('Filter by Coach (optional)'),
//                           items: _coachList.map((coach) => DropdownMenuItem(value: coach, child: Text(coach))).toList(),
//                           onChanged: (value) {
//                             setState(() => _selectedCoachId = value);
//                             _loadData();
//                           },
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(child: _buildMetricCard('Total Enterprises', _totalEnterprises.toString(), Icons.business)),
//                       Expanded(child: _buildMetricCard('Graduated', _graduatedEnterprises.toString(), Icons.emoji_events)),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(child: _buildMetricCard('Avg Revenue Growth', '${_avgRevenueGrowth.toStringAsFixed(1)}%', Icons.trending_up)),
//                       Expanded(child: _buildMetricCard('Jobs Created', _totalJobsCreated.toString(), Icons.people)),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(child: _buildMetricCard('Coaching Sessions', _totalCoachingSessions.toString(), Icons.event)),
//                       Expanded(child: _buildMetricCard('IAP Completion', '${_avgIapCompletion.toStringAsFixed(1)}%', Icons.checklist)),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: _isGenerating ? null : _generateCSVReport,
//                       icon: const Icon(Icons.download),
//                       label: const Text('Download CSV Report (Excel compatible)'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: AppTheme.primaryColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildMetricCard(String label, String value, IconData icon) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Icon(icon, color: AppTheme.primaryColor, size: 28),
//             const SizedBox(height: 8),
//             Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../models/enterprise.dart';
import '../theme/app_theme2.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime(2020, 1, 1),
    end: DateTime.now(),
  );
  bool _isLoading = false;
  bool _isGenerating = false;
  String? _selectedCoachId;
  List<String> _coachList = [];
  bool _isLoadingCoaches = false;

  int _totalEnterprises = 0;
  int _graduatedEnterprises = 0;
  double _avgRevenueGrowth = 0.0;
  int _totalJobsCreated = 0;
  int _totalCoachingSessions = 0;
  double _avgIapCompletion = 0.0;
  int _baselineCompleted = 0;
  int _midlineBetter = 0;

  // Cached data for report generation
  List<Enterprise> _cachedEnterprises = [];
  List<Map<String, dynamic>> _cachedSessionCounts = [];
  List<Map<String, dynamic>> _cachedIapData = [];
  List<Map<String, dynamic>> _cachedChecklistData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.coach?.role == 'supervisor') {
        _loadCoachList();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _fetchReportData();
    setState(() => _isLoading = false);
  }

  Future<void> _loadCoachList() async {
    setState(() => _isLoadingCoaches = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'coach')
          .get();
      final coaches = snapshot.docs.map((d) => d.data()['fullName'] as String).toList();
      setState(() {
        _coachList = coaches;
        _isLoadingCoaches = false;
      });
    } catch (e) {
      print('Error loading coaches: $e');
      setState(() => _isLoadingCoaches = false);
    }
  }

  QueryDocumentSnapshot<Map<String, dynamic>>? _findDoc(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      bool Function(Map<String, dynamic>) predicate) {
    for (var doc in docs) {
      if (predicate(doc.data())) return doc;
    }
    return null;
  }

  Future<void> _fetchReportData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isSupervisor = auth.coach?.role == 'supervisor';
    final coachId = auth.user?.uid;

    Query query = FirebaseFirestore.instance.collection('enterprises');
    if (!isSupervisor) {
      query = query.where('coachId', isEqualTo: coachId);
    }
    final snapshot = await query.get();
    List<Enterprise> enterprises = snapshot.docs
        .map((doc) => Enterprise.fromMap(doc.id, doc.data()! as Map<String, dynamic>))
        .toList();

    // Apply date range filter
    enterprises = enterprises.where((e) =>
        e.registrationDate.isAfter(_dateRange.start) &&
        e.registrationDate.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();

    if (isSupervisor && _selectedCoachId != null && _selectedCoachId!.isNotEmpty) {
      enterprises = enterprises.where((e) => e.coachId == _selectedCoachId).toList();
    }

    _cachedEnterprises = enterprises;

    final allSessions = await FirebaseFirestore.instance.collection('sessions').get();
    final allAssessments = await FirebaseFirestore.instance.collection('assessments').get();
    final allIaps = await FirebaseFirestore.instance.collection('iaps').get();
    final allChecklists = await FirebaseFirestore.instance.collection('graduation_checklists').get();

    // Precompute session counts
    _cachedSessionCounts = [];
    for (var e in enterprises) {
      int count = allSessions.docs
          .where((doc) => doc.data()['enterpriseId'] == e.id && doc.data()['actualDate'] != null)
          .length;
      _cachedSessionCounts.add({'id': e.id, 'count': count});
    }

    // Precompute IAP data
    _cachedIapData = [];
    for (var e in enterprises) {
      final iapDoc = _findDoc(allIaps.docs, (data) => data['enterpriseId'] == e.id);
      if (iapDoc != null) {
        final tasks = List<Map<String, dynamic>>.from(iapDoc.data()['tasks'] ?? []);
        int total = tasks.length;
        int done = tasks.where((t) => t['status'] == 'done').length;
        _cachedIapData.add({'id': e.id, 'total': total, 'done': done});
      } else {
        _cachedIapData.add({'id': e.id, 'total': 0, 'done': 0});
      }
    }

    // Precompute checklist approval
    _cachedChecklistData = [];
    for (var e in enterprises) {
      final checklist = _findDoc(allChecklists.docs, (data) => data['enterpriseId'] == e.id);
      bool approved = checklist != null && checklist.data()['mAndEApproved'] == true;
      _cachedChecklistData.add({'id': e.id, 'approved': approved});
    }

    // Compute aggregate metrics
    int graduated = 0;
    double totalRevenueGrowth = 0.0;
    int revenueCount = 0;
    int totalJobs = 0;
    int totalSessions = 0;
    double totalIapCompletion = 0.0;
    int iapCount = 0;
    int baselineDone = 0;
    int midlineImproved = 0;

    for (var e in enterprises) {
      if (e.status == 'Graduated') graduated++;

      if (e.baselineMonthlyRevenue != null && e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue! > 0) {
        final growth = (e.currentMonthlyRevenue! - e.baselineMonthlyRevenue!) / e.baselineMonthlyRevenue! * 100;
        totalRevenueGrowth += growth;
        revenueCount++;
      }

      if (e.baselineEmployees != null && e.currentEmployees != null) {
        totalJobs += (e.currentEmployees! - e.baselineEmployees!);
      }

      int sessions = _cachedSessionCounts.firstWhere((s) => s['id'] == e.id)['count'];
      totalSessions += sessions;

      var iap = _cachedIapData.firstWhere((i) => i['id'] == e.id);
      if (iap['total'] > 0) {
        totalIapCompletion += (iap['done'] / iap['total'] * 100);
        iapCount++;
      }

      final baseline = _findDoc(allAssessments.docs, (data) => data['enterpriseId'] == e.id && data['type'] == 'Baseline');
      if (baseline != null) baselineDone++;

      if (e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue != null &&
          e.currentMonthlyRevenue! > e.baselineMonthlyRevenue!) {
        midlineImproved++;
      }
    }

    setState(() {
      _totalEnterprises = enterprises.length;
      _graduatedEnterprises = graduated;
      _avgRevenueGrowth = revenueCount > 0 ? totalRevenueGrowth / revenueCount : 0.0;
      _totalJobsCreated = totalJobs;
      _totalCoachingSessions = totalSessions;
      _avgIapCompletion = iapCount > 0 ? totalIapCompletion / iapCount : 0.0;
      _baselineCompleted = baselineDone;
      _midlineBetter = midlineImproved;
    });
  }

  // Helper to generate CSV for a specific report type
  Future<void> _generateReport(String reportType) async {
    setState(() => _isGenerating = true);

    try {
      final enterprises = _cachedEnterprises;
      if (enterprises.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data available. Please adjust filters.')),
        );
        setState(() => _isGenerating = false);
        return;
      }

      StringBuffer csv = StringBuffer();
      String fileName = 'MESMER_${reportType}_${DateTime.now().millisecondsSinceEpoch}.csv';

      switch (reportType) {
        case 'Enterprise Progress':
          csv.writeln('"Enterprise Name","Owner","Sector","Region","Status","Registration Date","Baseline Revenue","Current Revenue","Revenue Growth %","Baseline Employees","Current Employees","Jobs Created"');
          for (var e in enterprises) {
            double revenueGrowth = 0.0;
            if (e.baselineMonthlyRevenue != null && e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue! > 0) {
              revenueGrowth = (e.currentMonthlyRevenue! - e.baselineMonthlyRevenue!) / e.baselineMonthlyRevenue! * 100;
            }
            int jobsCreated = 0;
            if (e.baselineEmployees != null && e.currentEmployees != null) {
              jobsCreated = e.currentEmployees! - e.baselineEmployees!;
            }
            csv.writeln('"${e.businessName.replaceAll('"', '""')}",'
                '"${e.ownerName.replaceAll('"', '""')}",'
                '"${e.sector.replaceAll('"', '""')}",'
                '"${e.location.replaceAll('"', '""')}",'
                '"${e.status}",'
                '"${e.registrationDate.toLocal()}",'
                '${e.baselineMonthlyRevenue?.toStringAsFixed(2) ?? '0'},'
                '${e.currentMonthlyRevenue?.toStringAsFixed(2) ?? '0'},'
                '${revenueGrowth.toStringAsFixed(2)},'
                '${e.baselineEmployees ?? 0},'
                '${e.currentEmployees ?? 0},'
                '$jobsCreated');
          }
          break;

        case 'Coaching Summary':
          csv.writeln('"Enterprise Name","Owner","Total Coaching Sessions","Last Session Date"');
          for (var e in enterprises) {
            int sessions = _cachedSessionCounts.firstWhere((s) => s['id'] == e.id)['count'];
            csv.writeln('"${e.businessName.replaceAll('"', '""')}",'
                '"${e.ownerName.replaceAll('"', '""')}",'
                '$sessions,');
          }
          break;

        case 'Financial Performance':
          csv.writeln('"Enterprise Name","Owner","Baseline Revenue","Current Revenue","Revenue Growth %","Baseline Employees","Current Employees","Jobs Created"');
          for (var e in enterprises) {
            double revenueGrowth = 0.0;
            if (e.baselineMonthlyRevenue != null && e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue! > 0) {
              revenueGrowth = (e.currentMonthlyRevenue! - e.baselineMonthlyRevenue!) / e.baselineMonthlyRevenue! * 100;
            }
            int jobsCreated = 0;
            if (e.baselineEmployees != null && e.currentEmployees != null) {
              jobsCreated = e.currentEmployees! - e.baselineEmployees!;
            }
            csv.writeln('"${e.businessName.replaceAll('"', '""')}",'
                '"${e.ownerName.replaceAll('"', '""')}",'
                '${e.baselineMonthlyRevenue?.toStringAsFixed(2) ?? '0'},'
                '${e.currentMonthlyRevenue?.toStringAsFixed(2) ?? '0'},'
                '${revenueGrowth.toStringAsFixed(2)},'
                '${e.baselineEmployees ?? 0},'
                '${e.currentEmployees ?? 0},'
                '$jobsCreated');
          }
          break;

        case 'IAP Completion':
          csv.writeln('"Enterprise Name","Owner","Total IAP Tasks","Tasks Completed","Completion %"');
          for (var e in enterprises) {
            var iap = _cachedIapData.firstWhere((i) => i['id'] == e.id);
            int total = iap['total'];
            int done = iap['done'];
            double percent = total > 0 ? (done / total * 100) : 0.0;
            csv.writeln('"${e.businessName.replaceAll('"', '""')}",'
                '"${e.ownerName.replaceAll('"', '""')}",'
                '$total,$done,${percent.toStringAsFixed(2)}');
          }
          break;

        case 'Graduation Status':
          csv.writeln('"Enterprise Name","Owner","Status","Graduation Approved","Baseline Completed","Min 8 Coaching Visits","Midline Better","Coach Sign-off","Evidence Pack Complete"');
          for (var e in enterprises) {
            bool approved = _cachedChecklistData.firstWhere((c) => c['id'] == e.id)['approved'];
            // For additional checklist items, we would need to fetch full checklist; for now, show only approval
            csv.writeln('"${e.businessName.replaceAll('"', '""')}",'
                '"${e.ownerName.replaceAll('"', '""')}",'
                '"${e.status}",'
                '"${approved ? "Yes" : "No"}",'
                '"${_baselineCompleted > 0 ? "Yes" : "No"}",'
                '"${_cachedSessionCounts.firstWhere((s) => s['id'] == e.id)['count'] >= 8 ? "Yes" : "No"}",'
                '"${e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue != null && e.currentMonthlyRevenue! > e.baselineMonthlyRevenue! ? "Yes" : "No"}",'
                '"Not Collected",'
                '"Not Collected"');
          }
          break;

        case 'Full Export':
        default:
          // Use existing full CSV generation
          await _generateFullCSV();
          setState(() => _isGenerating = false);
          return;
      }

      // Write summary KPIs at the top of each report (optional)
      StringBuffer summary = StringBuffer();
      summary.writeln('"Report: $reportType"');
      summary.writeln('"Generated on","${DateTime.now().toLocal()}"');
      summary.writeln('"Period","${_dateRange.start.toLocal()} to ${_dateRange.end.toLocal()}"');
      summary.writeln('"Total Enterprises",$_totalEnterprises');
      summary.writeln();
      String fullCsv = summary.toString() + csv.toString();

      final bytes = Uint8List.fromList(fullCsv.codeUnits);

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'text/csv');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$reportType report downloaded as CSV.')),
        );
      } else {
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/$fileName';
        await File(filePath).writeAsBytes(bytes);
        await Share.shareXFiles([XFile(filePath)], text: 'MESMER $reportType Report');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$reportType report shared.')),
        );
      }
    } catch (e) {
      print('Report generation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate report: $e')),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateFullCSV() async {
    final enterprises = _cachedEnterprises;
    final allSessions = await FirebaseFirestore.instance.collection('sessions').get();
    final allIaps = await FirebaseFirestore.instance.collection('iaps').get();
    final allChecklists = await FirebaseFirestore.instance.collection('graduation_checklists').get();

    StringBuffer csv = StringBuffer();
    csv.writeln('"Enterprise Name","Owner","Sector","Region","Status","Baseline Revenue","Current Revenue","Revenue Growth %","Baseline Employees","Current Employees","Jobs Created","Coaching Sessions","IAP Tasks Done/Total","IAP Completion %","Graduation Approved"');

    for (var e in enterprises) {
      double revenueGrowth = 0.0;
      if (e.baselineMonthlyRevenue != null && e.currentMonthlyRevenue != null && e.baselineMonthlyRevenue! > 0) {
        revenueGrowth = (e.currentMonthlyRevenue! - e.baselineMonthlyRevenue!) / e.baselineMonthlyRevenue! * 100;
      }
      int jobsCreated = 0;
      if (e.baselineEmployees != null && e.currentEmployees != null) {
        jobsCreated = e.currentEmployees! - e.baselineEmployees!;
      }
      int sessionsCount = allSessions.docs
          .where((doc) => doc.data()['enterpriseId'] == e.id && doc.data()['actualDate'] != null)
          .length;
      final iapDoc = _findDoc(allIaps.docs, (data) => data['enterpriseId'] == e.id);
      int tasksDone = 0, totalTasks = 0;
      double iapCompletion = 0.0;
      if (iapDoc != null) {
        final tasks = List<Map<String, dynamic>>.from(iapDoc.data()['tasks'] ?? []);
        totalTasks = tasks.length;
        tasksDone = tasks.where((t) => t['status'] == 'done').length;
        if (totalTasks > 0) iapCompletion = tasksDone / totalTasks * 100;
      }
      final checklist = _findDoc(allChecklists.docs, (data) => data['enterpriseId'] == e.id);
      bool isGraduated = checklist != null && checklist.data()['mAndEApproved'] == true;

      csv.writeln('"${e.businessName.replaceAll('"', '""')}",'
          '"${e.ownerName.replaceAll('"', '""')}",'
          '"${e.sector.replaceAll('"', '""')}",'
          '"${e.location.replaceAll('"', '""')}",'
          '"${e.status}",'
          '${e.baselineMonthlyRevenue?.toStringAsFixed(2) ?? '0'},'
          '${e.currentMonthlyRevenue?.toStringAsFixed(2) ?? '0'},'
          '${revenueGrowth.toStringAsFixed(2)},'
          '${e.baselineEmployees ?? 0},'
          '${e.currentEmployees ?? 0},'
          '$jobsCreated,'
          '$sessionsCount,'
          '"$tasksDone/$totalTasks",'
          '${iapCompletion.toStringAsFixed(2)},'
          '${isGraduated ? "Yes" : "No"}');
    }

    // Add KPI summary
    StringBuffer summary = StringBuffer();
    summary.writeln();
    summary.writeln('"Program KPIs"');
    summary.writeln('"Metric","Value"');
    summary.writeln('"Report Period","${_dateRange.start.toLocal()} to ${_dateRange.end.toLocal()}"');
    summary.writeln('"Total Enterprises",$_totalEnterprises');
    summary.writeln('"Graduated Enterprises",$_graduatedEnterprises');
    summary.writeln('"Baseline Completed",$_baselineCompleted');
    summary.writeln('"Midline Better than Baseline",$_midlineBetter');
    summary.writeln('"Average Revenue Growth (%)",${_avgRevenueGrowth.toStringAsFixed(2)}');
    summary.writeln('"Total Jobs Created",$_totalJobsCreated');
    summary.writeln('"Total Coaching Sessions",$_totalCoachingSessions');
    summary.writeln('"Average IAP Completion (%)",${_avgIapCompletion.toStringAsFixed(2)}');

    int enterprisesWithMin8Sessions = 0;
    for (var e in enterprises) {
      final sessions = allSessions.docs.where((doc) => doc.data()['enterpriseId'] == e.id && doc.data()['actualDate'] != null).length;
      if (sessions >= 8) enterprisesWithMin8Sessions++;
    }
    summary.writeln('"Enterprises with >=8 Coaching Sessions",$enterprisesWithMin8Sessions');

    String fullCsv = summary.toString() + '\n' + csv.toString();
    final bytes = Uint8List.fromList(fullCsv.codeUnits);

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'text/csv');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'MESMER_Full_Report_${DateTime.now().millisecondsSinceEpoch}.csv')
        ..click();
      html.Url.revokeObjectUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full report downloaded as CSV.')),
      );
    } else {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/MESMER_Full_Report_${DateTime.now().millisecondsSinceEpoch}.csv';
      await File(filePath).writeAsBytes(bytes);
      await Share.shareXFiles([XFile(filePath)], text: 'MESMER Full Report');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full report shared.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSupervisor = Provider.of<AuthProvider>(context).coach?.role == 'supervisor';

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period selection card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Select Period', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_dateRange.start.toLocal().toString().split(' ')[0]} → ${_dateRange.end.toLocal().toString().split(' ')[0]}',
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  final picked = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                    initialDateRange: _dateRange,
                                  );
                                  if (picked != null) {
                                    setState(() => _dateRange = picked);
                                    await _loadData();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Coach filter (supervisor only)
                  if (isSupervisor)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCoachId,
                          hint: const Text('Filter by Coach (optional)'),
                          items: _coachList.map((coach) => DropdownMenuItem(value: coach, child: Text(coach))).toList(),
                          onChanged: (value) {
                            setState(() => _selectedCoachId = value);
                            _loadData();
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Summary metrics cards
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Total Enterprises', _totalEnterprises.toString(), Icons.business)),
                      Expanded(child: _buildMetricCard('Graduated', _graduatedEnterprises.toString(), Icons.emoji_events)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Avg Revenue Growth', '${_avgRevenueGrowth.toStringAsFixed(1)}%', Icons.trending_up)),
                      Expanded(child: _buildMetricCard('Jobs Created', _totalJobsCreated.toString(), Icons.people)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Coaching Sessions', _totalCoachingSessions.toString(), Icons.event)),
                      Expanded(child: _buildMetricCard('IAP Completion', '${_avgIapCompletion.toStringAsFixed(1)}%', Icons.checklist)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Report group buttons
                  const Text('Download Specific Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildReportButton('Enterprise Progress', Icons.business),
                      _buildReportButton('Coaching Summary', Icons.event),
                      _buildReportButton('Financial Performance', Icons.trending_up),
                      _buildReportButton('IAP Completion', Icons.checklist),
                      _buildReportButton('Graduation Status', Icons.verified),
                      _buildReportButton('Full Export', Icons.download, isFullExport: true),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildReportButton(String title, IconData icon, {bool isFullExport = false}) {
    return ElevatedButton.icon(
      onPressed: _isGenerating ? null : () => _generateReport(title),
      icon: Icon(icon, size: 18),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: isFullExport ? AppTheme.successColor : AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}