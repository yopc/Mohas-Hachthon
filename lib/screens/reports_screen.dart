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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../providers/auth_provider.dart';
import '../providers/enterprise_provider.dart';
import '../providers/session_provider.dart';
import '../providers/assessment_provider.dart';
import '../providers/iap_provider.dart';
import '../providers/training_provider.dart';
import '../providers/graduation_provider.dart';
import '../models/enterprise.dart';
import '../models/assessment.dart';
import '../models/session.dart';
import '../models/iap.dart';
import '../theme/app_theme2.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  );
  bool _isGenerating = false;
  String? _selectedCoachId;
  List<String> _coachList = [];
  bool _isLoadingCoaches = false;

  // Aggregated data for preview
  int _totalEnterprises = 0;
  int _graduatedEnterprises = 0;
  double _avgRevenueGrowth = 0.0;
  int _totalJobsCreated = 0;
  int _totalCoachingSessions = 0;
  double _avgIapCompletion = 0.0;
  int _baselineCompleted = 0;
  int _midlineBetter = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.coach?.role == 'supervisor') {
      _loadCoachList();
    }
  }

  Future<void> _loadInitialData() async {
    await _fetchDataAndCompute();
  }

  Future<void> _loadCoachList() async {
    setState(() => _isLoadingCoaches = true);
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'coach')
          .get();
      final coaches = usersSnapshot.docs
          .map((doc) => doc.data()['fullName'] as String)
          .toList();
      setState(() {
        _coachList = coaches;
        _isLoadingCoaches = false;
      });
    } catch (e) {
      setState(() => _isLoadingCoaches = false);
    }
  }

  Future<void> _fetchDataAndCompute() async {
    setState(() => _isGenerating = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isSupervisor = auth.coach?.role == 'supervisor';

    final enterpriseProvider = Provider.of<EnterpriseProvider>(context, listen: false);
    if (isSupervisor) {
      enterpriseProvider.fetchEnterprises(role: 'supervisor');
    } else {
      enterpriseProvider.fetchEnterprises();
    }
    await Future.delayed(const Duration(milliseconds: 800));

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
    final iapProvider = Provider.of<IapProvider>(context, listen: false);

    List<Enterprise> enterprises = List.from(enterpriseProvider.enterprises);
    enterprises = enterprises.where((e) =>
        e.registrationDate.isAfter(_dateRange.start) &&
        e.registrationDate.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();

    if (isSupervisor && _selectedCoachId != null && _selectedCoachId!.isNotEmpty) {
      enterprises = enterprises.where((e) => e.coachId == _selectedCoachId).toList();
    }

    int graduated = 0;
    double totalRevenueGrowth = 0.0;
    int revenueCount = 0;
    int totalJobs = 0;
    int totalSessions = 0;
    double totalIapCompletion = 0.0;
    int iapCount = 0;
    int baselineDone = 0;
    int midlineImproved = 0;

    for (var enterprise in enterprises) {
      if (enterprise.status == 'Graduated') graduated++;

      if (enterprise.baselineMonthlyRevenue != null &&
          enterprise.currentMonthlyRevenue != null &&
          enterprise.baselineMonthlyRevenue! > 0) {
        final growth = (enterprise.currentMonthlyRevenue! - enterprise.baselineMonthlyRevenue!) /
            enterprise.baselineMonthlyRevenue! *
            100;
        totalRevenueGrowth += growth;
        revenueCount++;
      }

      if (enterprise.baselineEmployees != null && enterprise.currentEmployees != null) {
        totalJobs += (enterprise.currentEmployees! - enterprise.baselineEmployees!);
      }

      final sessions = sessionProvider.sessions
          .where((s) =>
              s.enterpriseId == enterprise.id &&
              s.actualDate != null &&
              s.actualDate!.isAfter(_dateRange.start) &&
              s.actualDate!.isBefore(_dateRange.end.add(const Duration(days: 1))))
          .length;
      totalSessions += sessions;

      await iapProvider.fetchIap(enterprise.id);
      final iap = iapProvider.iap;
      if (iap != null && iap.tasks.isNotEmpty) {
        final done = iap.tasks.where((t) => t.status == 'done').length;
        final percent = (done / iap.tasks.length) * 100;
        totalIapCompletion += percent;
        iapCount++;
      }

      final baseline = await assessmentProvider.getBaselineForEnterprise(enterprise.id);
      if (baseline != null) baselineDone++;

      if (enterprise.currentMonthlyRevenue != null &&
          enterprise.baselineMonthlyRevenue != null &&
          enterprise.currentMonthlyRevenue! > enterprise.baselineMonthlyRevenue!) {
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
      _isGenerating = false;
    });
  }

  Future<void> _generateExcelReport() async {
    setState(() => _isGenerating = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isSupervisor = auth.coach?.role == 'supervisor';

    final enterpriseProvider = Provider.of<EnterpriseProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
    final iapProvider = Provider.of<IapProvider>(context, listen: false);
    final graduationProvider = Provider.of<GraduationProvider>(context, listen: false);

    if (isSupervisor) {
      enterpriseProvider.fetchEnterprises(role: 'supervisor');
    } else {
      enterpriseProvider.fetchEnterprises();
    }
    await Future.delayed(const Duration(milliseconds: 800));

    List<Enterprise> enterprises = List.from(enterpriseProvider.enterprises);
    enterprises = enterprises.where((e) =>
        e.registrationDate.isAfter(_dateRange.start) &&
        e.registrationDate.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();

    if (isSupervisor && _selectedCoachId != null && _selectedCoachId!.isNotEmpty) {
      enterprises = enterprises.where((e) => e.coachId == _selectedCoachId).toList();
    }

    var excel = Excel.createExcel();
    var kpiSheet = excel['Program KPIs'];
    var detailsSheet = excel['Enterprise Details'];

    // Helper to convert any value to CellValue
    CellValue? toCellValue(dynamic value) {
      if (value == null) return null;
      if (value is String) return TextCellValue(value);
      if (value is int) return IntCellValue(value);
      if (value is double) return DoubleCellValue(value);
      if (value is bool) return BoolCellValue(value);
      return TextCellValue(value.toString());
    }

    // KPI Sheet
    kpiSheet.appendRow(['Metric', 'Value'].map(toCellValue).toList());
    kpiSheet.appendRow(['Report Period', '${_dateRange.start.toLocal()} to ${_dateRange.end.toLocal()}'].map(toCellValue).toList());
    kpiSheet.appendRow(['Total Enterprises', _totalEnterprises].map(toCellValue).toList());
    kpiSheet.appendRow(['Graduated Enterprises', _graduatedEnterprises].map(toCellValue).toList());
    kpiSheet.appendRow(['Baseline Completed', _baselineCompleted].map(toCellValue).toList());
    kpiSheet.appendRow(['Midline Better than Baseline', _midlineBetter].map(toCellValue).toList());
    kpiSheet.appendRow(['Average Revenue Growth (%)', _avgRevenueGrowth].map(toCellValue).toList());
    kpiSheet.appendRow(['Total Jobs Created', _totalJobsCreated].map(toCellValue).toList());
    kpiSheet.appendRow(['Total Coaching Sessions', _totalCoachingSessions].map(toCellValue).toList());
    kpiSheet.appendRow(['Average IAP Completion (%)', _avgIapCompletion].map(toCellValue).toList());

    int enterprisesWithMin8Sessions = 0;
    for (var e in enterprises) {
      final sessions = sessionProvider.sessions.where((s) => s.enterpriseId == e.id && s.actualDate != null).length;
      if (sessions >= 8) enterprisesWithMin8Sessions++;
    }
    kpiSheet.appendRow(['Enterprises with >=8 Coaching Sessions', enterprisesWithMin8Sessions].map(toCellValue).toList());

    // Details Sheet
    detailsSheet.appendRow([
      'Enterprise Name',
      'Owner',
      'Sector',
      'Region',
      'Status',
      'Baseline Revenue',
      'Current Revenue',
      'Revenue Growth %',
      'Baseline Employees',
      'Current Employees',
      'Jobs Created',
      'Coaching Sessions',
      'IAP Tasks Done/Total',
      'IAP Completion %',
      'Graduation Approved'
    ].map(toCellValue).toList());

    for (var enterprise in enterprises) {
      double revenueGrowth = 0.0;
      if (enterprise.baselineMonthlyRevenue != null &&
          enterprise.currentMonthlyRevenue != null &&
          enterprise.baselineMonthlyRevenue! > 0) {
        revenueGrowth = (enterprise.currentMonthlyRevenue! - enterprise.baselineMonthlyRevenue!) /
            enterprise.baselineMonthlyRevenue! *
            100;
      }

      int jobsCreated = 0;
      if (enterprise.baselineEmployees != null && enterprise.currentEmployees != null) {
        jobsCreated = enterprise.currentEmployees! - enterprise.baselineEmployees!;
      }

      final sessionsCount = sessionProvider.sessions
          .where((s) => s.enterpriseId == enterprise.id && s.actualDate != null)
          .length;

      await iapProvider.fetchIap(enterprise.id);
      final iap = iapProvider.iap;
      int tasksDone = 0;
      int totalTasks = 0;
      double iapCompletion = 0.0;
      if (iap != null) {
        totalTasks = iap.tasks.length;
        tasksDone = iap.tasks.where((t) => t.status == 'done').length;
        if (totalTasks > 0) iapCompletion = (tasksDone / totalTasks) * 100;
      }

      await graduationProvider.fetchChecklist(enterprise.id);
      bool isGraduated = graduationProvider.checklist?.mAndEApproved ?? false;

      detailsSheet.appendRow([
        enterprise.businessName,
        enterprise.ownerName,
        enterprise.sector,
        enterprise.location,
        enterprise.status,
        enterprise.baselineMonthlyRevenue?.toStringAsFixed(2) ?? '0',
        enterprise.currentMonthlyRevenue?.toStringAsFixed(2) ?? '0',
        revenueGrowth.toStringAsFixed(2),
        enterprise.baselineEmployees?.toString() ?? '0',
        enterprise.currentEmployees?.toString() ?? '0',
        jobsCreated.toString(),
        sessionsCount.toString(),
        '$tasksDone/$totalTasks',
        iapCompletion.toStringAsFixed(2),
        isGraduated ? 'Yes' : 'No'
      ].map(toCellValue).toList());
    }

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/MESMER_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    setState(() => _isGenerating = false);
    await Share.shareXFiles([XFile(filePath)], text: 'MESMER Program Report');
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isSupervisor = auth.coach?.role == 'supervisor';

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                              await _fetchDataAndCompute();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isSupervisor)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCoachId,
                    hint: const Text('Filter by Coach (optional)'),
                    items: _coachList.map((coach) {
                      return DropdownMenuItem<String>(
                        value: coach,
                        child: Text(coach),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCoachId = value);
                      _fetchDataAndCompute();
                    },
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (!_isGenerating) ...[
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
            ] else
              const Center(child: CircularProgressIndicator()),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateExcelReport,
                icon: const Icon(Icons.download),
                label: const Text('Download Excel Report'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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