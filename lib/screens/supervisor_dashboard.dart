
// import 'package:flutter/material.dart';
// import 'package:mohas/screens/register_coach_from.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../providers/auth_provider.dart';
// import '../models/coach_model.dart';
// import '../models/enterprise.dart';
// import '../models/assessment.dart';
// import '../models/session.dart';
// import 'coach_detail_screen.dart';
// import '../theme/app_theme2.dart';
// import 'profile_screen.dart';
// import 'qc_queue_screen.dart';
// import 'training_list_screen.dart';
// import 'enterprise_profile_screen.dart';

// class SupervisorDashboard extends StatefulWidget {
//   const SupervisorDashboard({super.key});

//   @override
//   State<SupervisorDashboard> createState() => _SupervisorDashboardState();
// }

// class _SupervisorDashboardState extends State<SupervisorDashboard> {
//   int _selectedIndex = 0;
//   String _searchQuery = '';
//   String _selectedFilter = 'All';
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final List<String> _filters = ['All', 'Active', 'Inactive'];
//   final List<String> _enterpriseFilters = ['All', 'Active', 'Graduated', 'Needs Attention'];
//   final List<String> _assessmentFilters = ['All', 'Baseline', 'Quarterly', 'Follow-up'];
//   final List<String> _sessionFilters = ['All', 'Upcoming', 'Completed'];

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final supervisor = authProvider.coach;

//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
//         title: Text(_getAppBarTitle(), style: const TextStyle(color: Colors.white)),
//         backgroundColor: AppTheme.primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: () => setState(() {})),
//           IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () async => await authProvider.signOut()),
//         ],
//       ),
//       drawer: _buildDrawer(context, supervisor, authProvider),
//       body: _selectedIndex == 0 ? _buildOverviewDashboard() : _buildTabContent(),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   String _getAppBarTitle() {
//     switch (_selectedIndex) {
//       case 0:
//         return 'Overview Dashboard';
//       case 1:
//         return 'Coaches Management';
//       case 2:
//         return 'Enterprises Overview';
//       case 3:
//         return 'Assessments Overview';
//       case 4:
//         return 'Sessions Overview';
//       case 5:
//         return 'Reports & Analytics';
//       default:
//         return 'Supervisor Dashboard';
//     }
//   }

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))]),
//       child: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) => setState(() => _selectedIndex = index),
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
//         unselectedLabelStyle: const TextStyle(fontSize: 11),
//         elevation: 0,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Overview'),
//           BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Coaches'),
//           BottomNavigationBarItem(icon: Icon(Icons.business_outlined), activeIcon: Icon(Icons.business), label: 'Enterprises'),
//           BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Assessments'),
//           BottomNavigationBarItem(icon: Icon(Icons.event_outlined), activeIcon: Icon(Icons.event), label: 'Sessions'),
//           BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), activeIcon: Icon(Icons.analytics), label: 'Reports'),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabContent() {
//     switch (_selectedIndex) {
//       case 1:
//         return _buildCoachesManagement();
//       case 2:
//         return _buildEnterprisesOverview();
//       case 3:
//         return _buildAssessmentsOverview();
//       case 4:
//         return _buildSessionsOverview();
//       case 5:
//         return _buildReportsAnalytics();
//       default:
//         return _buildOverviewDashboard();
//     }
//   }

//   Widget _buildOverviewDashboard() {
//     return Container(
//       color: AppTheme.backgroundColor,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildWelcomeSection(),
//             const SizedBox(height: 20),
//             _buildKeyMetrics(),
//             const SizedBox(height: 24),
//             _buildQuickActions(),
//             const SizedBox(height: 24),
//             _buildRecentActivity(),
//             const SizedBox(height: 24),
//             _buildPerformanceCharts(),
//             const SizedBox(height: 24),
//             _buildTopCoaches(),
//             const SizedBox(height: 24),
//             _buildRecentEnterprises(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWelcomeSection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//           gradient: LinearGradient(
//               colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight),
//           borderRadius: BorderRadius.circular(20)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Expanded(
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 14)),
//                   SizedBox(height: 4),
//                   Text('Supervisor', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
//                 ],
//               )),
//               Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
//                   child: const Icon(Icons.notifications, color: Colors.white, size: 30)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               _buildWelcomeStat('Total Coaches', _buildTotalCoachesCount(), Icons.people),
//               const SizedBox(width: 12),
//               _buildWelcomeStat('Total Enterprises', _buildTotalEnterprisesCount(), Icons.business),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeStat(String label, Widget value, IconData icon) {
//     return Expanded(
//       child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
//           child: Row(
//             children: [
//               Icon(icon, color: Colors.white, size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [value, Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11))],
//               ))
//             ],
//           )),
//     );
//   }

//   Widget _buildTotalCoachesCount() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
//         builder: (context, snapshot) => Text(snapshot.hasData ? '${snapshot.data!.docs.length}' : '0',
//             style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)));
//   }

//   Widget _buildTotalEnterprisesCount() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
//         builder: (context, snapshot) => Text(snapshot.hasData ? '${snapshot.data!.docs.length}' : '0',
//             style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)));
//   }

//   Widget _buildKeyMetrics() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
//       builder: (context, coachSnapshot) {
//         return StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
//           builder: (context, enterpriseSnapshot) {
//             return StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
//               builder: (context, assessmentSnapshot) {
//                 return StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance.collection('sessions').snapshots(),
//                   builder: (context, sessionSnapshot) {
//                     int totalCoaches = coachSnapshot.hasData ? coachSnapshot.data!.docs.length : 0;
//                     int totalEnterprises = enterpriseSnapshot.hasData ? enterpriseSnapshot.data!.docs.length : 0;
//                     int totalAssessments = assessmentSnapshot.hasData ? assessmentSnapshot.data!.docs.length : 0;
//                     int totalSessions = sessionSnapshot.hasData ? sessionSnapshot.data!.docs.length : 0;
//                     int activeCoaches = coachSnapshot.hasData
//                         ? coachSnapshot.data!.docs
//                             .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'active')
//                             .length
//                         : 0;
//                     int activeEnterprises = enterpriseSnapshot.hasData
//                         ? enterpriseSnapshot.data!.docs
//                             .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Active')
//                             .length
//                         : 0;
//                     return SizedBox(
//                       height: 280,
//                       child: GridView.count(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                         childAspectRatio: 1.4,
//                         children: [
//                           _buildMetricCard('Total Coaches', totalCoaches.toString(), Icons.people, Colors.blue,
//                               '$activeCoaches Active'),
//                           _buildMetricCard('Total Enterprises', totalEnterprises.toString(), Icons.business,
//                               Colors.green, '$activeEnterprises Active'),
//                           _buildMetricCard('Total Assessments', totalAssessments.toString(), Icons.assignment,
//                               Colors.orange, 'Last 30 days'),
//                           _buildMetricCard('Total Sessions', totalSessions.toString(), Icons.event, Colors.purple,
//                               'This month'),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildMetricCard(String label, String value, IconData icon, Color color, String subtitle) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
//               child: Icon(icon, color: color, size: 18)),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//               Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//               const SizedBox(height: 2),
//               Text(subtitle, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500))
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             _buildQuickActionButton('Add Coach', Icons.person_add, Colors.blue, () => setState(() => _selectedIndex = 1)),
//             const SizedBox(width: 8),
//             _buildQuickActionButton('Add Enterprise', Icons.add_business, Colors.green, () {}),
//             const SizedBox(width: 8),
//             _buildQuickActionButton('New Assessment', Icons.assignment_add, Colors.orange,
//                 () => setState(() => _selectedIndex = 3)),
//             const SizedBox(width: 8),
//             _buildQuickActionButton('Schedule Session', Icons.calendar_month, Colors.purple,
//                 () => setState(() => _selectedIndex = 4)),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
//           child: Column(
//             children: [
//               Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
//                   child: Icon(icon, color: color, size: 20)),
//               const SizedBox(height: 4),
//               Text(label,
//                   style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
//                   textAlign: TextAlign.center),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentActivity() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Recent Activity',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//               TextButton(onPressed: () {}, child: const Text('View All'))
//             ]),
//         const SizedBox(height: 12),
//         StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('activity_logs')
//               .orderBy('timestamp', descending: true)
//               .limit(5)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.data!.docs.isEmpty) {
//               return Container(
//                   padding: const EdgeInsets.all(32),
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//                   child: Column(
//                     children: [
//                       Icon(Icons.history, size: 48, color: Colors.grey.shade400),
//                       const SizedBox(height: 12),
//                       Text('No recent activity', style: TextStyle(color: Colors.grey.shade600))
//                     ],
//                   ));
//             }
//             return Container(
//               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: snapshot.data!.docs.length,
//                 separatorBuilder: (_, __) => const Divider(height: 1),
//                 itemBuilder: (context, index) {
//                   final activity = snapshot.data!.docs[index].data() as Map<String, dynamic>;
//                   return ListTile(
//                     leading: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             color: _getActivityColor(activity['action']).withOpacity(0.1), shape: BoxShape.circle),
//                         child: Icon(_getActivityIcon(activity['action']),
//                             color: _getActivityColor(activity['action']), size: 16)),
//                     title: Text(activity['action'] ?? 'Activity', style: const TextStyle(fontWeight: FontWeight.w600)),
//                     subtitle: Text(activity['coachName'] ?? ''),
//                     trailing: Text(_formatTimestamp(activity['timestamp']), style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Color _getActivityColor(String action) {
//     switch (action) {
//       case 'coach_registration':
//         return Colors.blue;
//       case 'enterprise_registration':
//         return Colors.green;
//       case 'assessment_created':
//         return Colors.orange;
//       case 'session_created':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getActivityIcon(String action) {
//     switch (action) {
//       case 'coach_registration':
//         return Icons.person_add;
//       case 'enterprise_registration':
//         return Icons.business;
//       case 'assessment_created':
//         return Icons.assignment;
//       case 'session_created':
//         return Icons.event;
//       default:
//         return Icons.notifications;
//     }
//   }

//   String _formatTimestamp(dynamic timestamp) {
//     if (timestamp == null) return 'Just now';
//     if (timestamp is Timestamp) {
//       final now = DateTime.now();
//       final date = timestamp.toDate();
//       final diff = now.difference(date);
//       if (diff.inDays > 7) return '${date.day}/${date.month}/${date.year}';
//       if (diff.inDays > 0) return '${diff.inDays}d ago';
//       if (diff.inHours > 0) return '${diff.inHours}h ago';
//       if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
//       return 'Just now';
//     }
//     return 'Just now';
//   }

//   Widget _buildPerformanceCharts() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Performance Overview',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//         const SizedBox(height: 12),
//         Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildChartIndicator('Coaches', _buildCoachActivePercentage(), Icons.people, Colors.blue)),
//                     Expanded(
//                         child: _buildChartIndicator('Enterprises', _buildEnterpriseActivePercentage(), Icons.business,
//                             Colors.green)),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildChartIndicator('Assessments', _buildAssessmentCompletionRate(), Icons.assignment,
//                             Colors.orange)),
//                     Expanded(
//                         child:
//                             _buildChartIndicator('Sessions', _buildSessionCompletionRate(), Icons.event, Colors.purple)),
//                   ],
//                 )
//               ],
//             )),
//       ],
//     );
//   }

//   Widget _buildCoachActivePercentage() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Text('0%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           }
//           try {
//             final coaches = snapshot.data!.docs;
//             int active = coaches
//                 .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'active')
//                 .length;
//             int percent = coaches.isEmpty ? 0 : (active * 100 / coaches.length).round();
//             return Text('$percent%',
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           } catch (e) {
//             return const Text('0%',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           }
//         });
//   }

//   Widget _buildEnterpriseActivePercentage() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Text('0%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           }
//           try {
//             final enterprises = snapshot.data!.docs;
//             int active = enterprises
//                 .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Active')
//                 .length;
//             int percent = enterprises.isEmpty ? 0 : (active * 100 / enterprises.length).round();
//             return Text('$percent%',
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           } catch (e) {
//             return const Text('0%',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           }
//         });
//   }

//   Widget _buildAssessmentCompletionRate() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Text('0%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           }
//           try {
//             final assessments = snapshot.data!.docs;
//             int completed = assessments
//                 .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Completed')
//                 .length;
//             int percent = assessments.isEmpty ? 0 : (completed * 100 / assessments.length).round();
//             return Text('$percent%',
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           } catch (e) {
//             return const Text('0%',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           }
//         });
//   }

//   Widget _buildSessionCompletionRate() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('sessions').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Text('0%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           }
//           try {
//             final sessions = snapshot.data!.docs;
//             int completed = sessions.where((doc) => (doc.data() as Map<String, dynamic>)['actualDate'] != null).length;
//             int percent = sessions.isEmpty ? 0 : (completed * 100 / sessions.length).round();
//             return Text('$percent%',
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           } catch (e) {
//             return const Text('0%',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
//           }
//         });
//   }

//   Widget _buildChartIndicator(String label, Widget value, IconData icon, Color color) {
//     return Row(
//       children: [
//         Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
//             child: Icon(icon, color: color, size: 14)),
//         const SizedBox(width: 8),
//         Expanded(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//             value
//           ],
//         ))
//       ],
//     );
//   }

//   Widget _buildTopCoaches() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Top Performing Coaches',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//               TextButton(onPressed: () => setState(() => _selectedIndex = 1), child: const Text('View All'))
//             ]),
//         const SizedBox(height: 12),
//         StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').limit(3).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.data!.docs.isEmpty) {
//               return Container(
//                   padding: const EdgeInsets.all(32),
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//                   child: Column(
//                     children: [
//                       Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
//                       const SizedBox(height: 12),
//                       Text('No coaches yet', style: TextStyle(color: Colors.grey.shade600))
//                     ],
//                   ));
//             }
//             return Column(
//                 children: snapshot.data!.docs.map((doc) {
//               try {
//                 final data = doc.data() as Map<String, dynamic>;
//                 final coach = Coach.fromMap(data, id: doc.id);
//                 return Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//                     child: Row(
//                       children: [
//                         Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
//                             child: Center(
//                                 child: Text(coach.fullName.isNotEmpty ? coach.fullName[0].toUpperCase() : 'C',
//                                     style: const TextStyle(
//                                         fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)))),
//                         const SizedBox(width: 12),
//                         Expanded(
//                             child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(coach.fullName,
//                                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                             Text(coach.email, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
//                           ],
//                         )),
//                         Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                                 color: coach.accountStatus == 'active'
//                                     ? AppTheme.successColor.withOpacity(0.1)
//                                     : AppTheme.errorColor.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(12)),
//                             child: Text(coach.accountStatus,
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                     color: coach.accountStatus == 'active' ? AppTheme.successColor : AppTheme.errorColor)))
//                       ],
//                     ));
//               } catch (e) {
//                 return const SizedBox.shrink();
//               }
//             }).toList());
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildRecentEnterprises() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Recent Enterprises',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//               TextButton(onPressed: () => setState(() => _selectedIndex = 2), child: const Text('View All'))
//             ]),
//         const SizedBox(height: 12),
//         StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('enterprises')
//               .orderBy('registrationDate', descending: true)
//               .limit(3)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.data!.docs.isEmpty) {
//               return Container(
//                   padding: const EdgeInsets.all(32),
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//                   child: Column(
//                     children: [
//                       Icon(Icons.business_outlined, size: 48, color: Colors.grey.shade400),
//                       const SizedBox(height: 12),
//                       Text('No enterprises yet', style: TextStyle(color: Colors.grey.shade600))
//                     ],
//                   ));
//             }
//             return Column(
//                 children: snapshot.data!.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               final enterprise = Enterprise.fromMap(doc.id, data);
//               return Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//                   child: Row(
//                     children: [
//                       Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
//                           child: const Icon(Icons.business, color: AppTheme.primaryColor, size: 20)),
//                       const SizedBox(width: 12),
//                       Expanded(
//                           child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(enterprise.businessName,
//                               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                           Text(enterprise.ownerName, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
//                         ],
//                       )),
//                       Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                               color: enterprise.status == 'Active'
//                                   ? AppTheme.successColor.withOpacity(0.1)
//                                   : Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Text(enterprise.status,
//                               style: TextStyle(
//                                   fontSize: 10,
//                                   color: enterprise.status == 'Active' ? AppTheme.successColor : Colors.grey.shade600)))
//                     ],
//                   ));
//             }).toList());
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildCoachesManagement() {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final supervisor = authProvider.coach;
//     return Container(
//       color: AppTheme.backgroundColor,
//       child: Column(
//         children: [
//           Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   final coaches = snapshot.data!.docs;
//                   int active = coaches
//                       .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'active')
//                       .length;
//                   int inactive = coaches
//                       .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'inactive')
//                       .length;
//                   return Row(
//                     children: [
//                       Expanded(
//                           child: _buildStatCard('Total Coaches', coaches.length.toString(), Icons.people, Colors.blue)),
//                       const SizedBox(width: 12),
//                       Expanded(child: _buildStatCard('Active', active.toString(), Icons.check_circle, Colors.green)),
//                       const SizedBox(width: 12),
//                       Expanded(child: _buildStatCard('Inactive', inactive.toString(), Icons.cancel, Colors.orange)),
//                     ],
//                   );
//                 },
//               )),
//           Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Container(
//                       decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
//                       child: TextField(
//                         onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
//                         decoration: const InputDecoration(
//                             hintText: 'Search coaches by name, email, region...',
//                             prefixIcon: Icon(Icons.search),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                       )),
//                   const SizedBox(height: 12),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                         children: _filters.map((filter) {
//                       final isSelected = _selectedFilter == filter;
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 8),
//                         child: FilterChip(
//                             label: Text(filter),
//                             selected: isSelected,
//                             onSelected: (selected) => setState(() => _selectedFilter = filter),
//                             backgroundColor: Colors.grey.shade50,
//                             selectedColor: AppTheme.primaryColor.withOpacity(0.1),
//                             checkmarkColor: AppTheme.primaryColor,
//                             labelStyle: TextStyle(
//                                 color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
//                                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
//                       );
//                     }).toList()),
//                   )
//                 ],
//               )),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 if (supervisor != null) {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => RegisterCoachForm(
//                               supervisorId: supervisor.id ?? '', supervisorName: supervisor.fullName))).then((_) => setState(() {}));
//                 }
//               },
//               icon: const Icon(Icons.person_add),
//               label: const Text('Register New Coach'),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primaryColor,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                       child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
//                       const SizedBox(height: 16),
//                       Text('Error: ${snapshot.error}')
//                     ],
//                   ));
//                 }
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 var coaches = snapshot.data!.docs
//                     .map((doc) => Coach.fromMap(doc.data() as Map<String, dynamic>, id: doc.id))
//                     .toList();
//                 if (_searchQuery.isNotEmpty) {
//                   coaches = coaches.where((c) =>
//                       c.fullName.toLowerCase().contains(_searchQuery) ||
//                       c.email.toLowerCase().contains(_searchQuery) ||
//                       c.region.toLowerCase().contains(_searchQuery) ||
//                       c.phone.contains(_searchQuery)).toList();
//                 }
//                 if (_selectedFilter != 'All') {
//                   coaches = coaches.where((c) => c.accountStatus.toLowerCase() == _selectedFilter.toLowerCase()).toList();
//                 }
//                 if (coaches.isEmpty) {
//                   return Center(
//                       child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
//                       const SizedBox(height: 16),
//                       Text('No coaches found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
//                       const SizedBox(height: 8),
//                       Text('Click "Register New Coach" to add one', style: TextStyle(fontSize: 14, color: Colors.grey.shade500))
//                     ],
//                   ));
//                 }
//                 return ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: coaches.length,
//                     itemBuilder: (context, index) => _buildCoachCard(coaches[index]));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnterprisesOverview() {
//     String enterpriseSearch = '';
//     String enterpriseFilter = 'All';
//     return StatefulBuilder(
//       builder: (context, setState) => Container(
//         color: AppTheme.backgroundColor,
//         child: Column(
//           children: [
//             Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.white,
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     final enterprises = snapshot.data!.docs;
//                     int active = enterprises
//                         .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Active')
//                         .length;
//                     int graduated = enterprises
//                         .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Graduated')
//                         .length;
//                     return Row(
//                       children: [
//                         Expanded(
//                             child: _buildStatCard('Total', enterprises.length.toString(), Icons.business, Colors.blue)),
//                         const SizedBox(width: 12),
//                         Expanded(child: _buildStatCard('Active', active.toString(), Icons.check_circle, Colors.green)),
//                         const SizedBox(width: 12),
//                         Expanded(child: _buildStatCard('Graduated', graduated.toString(), Icons.emoji_events, Colors.orange)),
//                       ],
//                     );
//                   },
//                 )),
//             Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     Container(
//                         decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
//                         child: TextField(
//                           onChanged: (v) => setState(() => enterpriseSearch = v.toLowerCase()),
//                           decoration: const InputDecoration(
//                               hintText: 'Search enterprises by name, owner...',
//                               prefixIcon: Icon(Icons.search),
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                         )),
//                     const SizedBox(height: 12),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                           children: _enterpriseFilters.map((filter) {
//                         final isSelected = enterpriseFilter == filter;
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: FilterChip(
//                               label: Text(filter),
//                               selected: isSelected,
//                               onSelected: (selected) => setState(() => enterpriseFilter = filter),
//                               backgroundColor: Colors.grey.shade50,
//                               selectedColor: AppTheme.primaryColor.withOpacity(0.1),
//                               checkmarkColor: AppTheme.primaryColor,
//                               labelStyle: TextStyle(
//                                   color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
//                                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
//                         );
//                       }).toList()),
//                     )
//                   ],
//                 )),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   var enterprises = snapshot.data!.docs
//                       .map((doc) => Enterprise.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//                       .toList();
//                   if (enterpriseSearch.isNotEmpty) {
//                     enterprises = enterprises.where((e) =>
//                         e.businessName.toLowerCase().contains(enterpriseSearch) ||
//                         e.ownerName.toLowerCase().contains(enterpriseSearch)).toList();
//                   }
//                   if (enterpriseFilter != 'All') {
//                     if (enterpriseFilter == 'Needs Attention') {
//                       enterprises = enterprises.where((e) => e.overallScore < 50).toList();
//                     } else {
//                       enterprises = enterprises.where((e) => e.status == enterpriseFilter).toList();
//                     }
//                   }
//                   if (enterprises.isEmpty) {
//                     return Center(
//                         child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.business_outlined, size: 64, color: Colors.grey.shade400),
//                         const SizedBox(height: 16),
//                         Text('No enterprises found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600))
//                       ],
//                     ));
//                   }
//                   return ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: enterprises.length,
//                       itemBuilder: (context, index) => _buildEnterpriseCard(enterprises[index]));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAssessmentsOverview() {
//     String assessmentSearch = '';
//     String assessmentFilter = 'All';
//     return StatefulBuilder(
//       builder: (context, setState) => Container(
//         color: AppTheme.backgroundColor,
//         child: Column(
//           children: [
//             Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.white,
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     final assessments = snapshot.data!.docs;
//                     int baseline = assessments
//                         .where((doc) => (doc.data() as Map<String, dynamic>)['type'] == 'Baseline')
//                         .length;
//                     int quarterly = assessments
//                         .where((doc) => (doc.data() as Map<String, dynamic>)['type'] == 'Quarterly')
//                         .length;
//                     return Row(
//                       children: [
//                         Expanded(
//                             child: _buildStatCard('Total', assessments.length.toString(), Icons.assignment, Colors.blue)),
//                         const SizedBox(width: 12),
//                         Expanded(
//                             child: _buildStatCard('Baseline', baseline.toString(), Icons.assignment_turned_in, Colors.green)),
//                         const SizedBox(width: 12),
//                         Expanded(
//                             child: _buildStatCard('Quarterly', quarterly.toString(), Icons.assignment_late, Colors.orange)),
//                       ],
//                     );
//                   },
//                 )),
//             Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     Container(
//                         decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
//                         child: TextField(
//                           onChanged: (v) => setState(() => assessmentSearch = v.toLowerCase()),
//                           decoration: const InputDecoration(
//                               hintText: 'Search assessments by enterprise...',
//                               prefixIcon: Icon(Icons.search),
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                         )),
//                     const SizedBox(height: 12),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                           children: _assessmentFilters.map((filter) {
//                         final isSelected = assessmentFilter == filter;
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: FilterChip(
//                               label: Text(filter),
//                               selected: isSelected,
//                               onSelected: (selected) => setState(() => assessmentFilter = filter),
//                               backgroundColor: Colors.grey.shade50,
//                               selectedColor: AppTheme.primaryColor.withOpacity(0.1),
//                               checkmarkColor: AppTheme.primaryColor,
//                               labelStyle: TextStyle(
//                                   color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
//                                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
//                         );
//                       }).toList()),
//                     )
//                   ],
//                 )),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('assessments')
//                     .orderBy('date', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   var assessments = snapshot.data!.docs
//                       .map((doc) => Assessment.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//                       .toList();
//                   if (assessmentSearch.isNotEmpty) {
//                     assessments = assessments
//                         .where((a) => a.enterpriseName.toLowerCase().contains(assessmentSearch))
//                         .toList();
//                   }
//                   if (assessmentFilter != 'All') {
//                     assessments = assessments.where((a) => a.type == assessmentFilter).toList();
//                   }
//                   if (assessments.isEmpty) {
//                     return Center(
//                         child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
//                         const SizedBox(height: 16),
//                         Text('No assessments found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600))
//                       ],
//                     ));
//                   }
//                   return ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: assessments.length,
//                       itemBuilder: (context, index) => _buildAssessmentCard(assessments[index]));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSessionsOverview() {
//     String sessionSearch = '';
//     String sessionFilter = 'All';
//     return StatefulBuilder(
//       builder: (context, setState) => Container(
//         color: AppTheme.backgroundColor,
//         child: Column(
//           children: [
//             Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.white,
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance.collection('sessions').snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     final sessions = snapshot.data!.docs;
//                     int upcoming = sessions.where((doc) => (doc.data() as Map<String, dynamic>)['actualDate'] == null).length;
//                     int completed = sessions.where((doc) => (doc.data() as Map<String, dynamic>)['actualDate'] != null).length;
//                     return Row(
//                       children: [
//                         Expanded(child: _buildStatCard('Total', sessions.length.toString(), Icons.event, Colors.blue)),
//                         const SizedBox(width: 12),
//                         Expanded(child: _buildStatCard('Upcoming', upcoming.toString(), Icons.schedule, Colors.orange)),
//                         const SizedBox(width: 12),
//                         Expanded(child: _buildStatCard('Completed', completed.toString(), Icons.check_circle, Colors.green)),
//                       ],
//                     );
//                   },
//                 )),
//             Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     Container(
//                         decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
//                         child: TextField(
//                           onChanged: (v) => setState(() => sessionSearch = v.toLowerCase()),
//                           decoration: const InputDecoration(
//                               hintText: 'Search sessions by enterprise...',
//                               prefixIcon: Icon(Icons.search),
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
//                         )),
//                     const SizedBox(height: 12),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                           children: _sessionFilters.map((filter) {
//                         final isSelected = sessionFilter == filter;
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: FilterChip(
//                               label: Text(filter),
//                               selected: isSelected,
//                               onSelected: (selected) => setState(() => sessionFilter = filter),
//                               backgroundColor: Colors.grey.shade50,
//                               selectedColor: AppTheme.primaryColor.withOpacity(0.1),
//                               checkmarkColor: AppTheme.primaryColor,
//                               labelStyle: TextStyle(
//                                   color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
//                                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
//                         );
//                       }).toList()),
//                     )
//                   ],
//                 )),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('sessions')
//                     .orderBy('scheduledDate', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   var sessions = snapshot.data!.docs
//                       .map((doc) => CoachingSession.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//                       .toList();
//                   if (sessionSearch.isNotEmpty) {
//                     sessions = sessions.where((s) => s.enterpriseName.toLowerCase().contains(sessionSearch)).toList();
//                   }
//                   if (sessionFilter != 'All') {
//                     if (sessionFilter == 'Upcoming') {
//                       sessions = sessions.where((s) => !s.isCompleted).toList();
//                     } else if (sessionFilter == 'Completed') {
//                       sessions = sessions.where((s) => s.isCompleted).toList();
//                     }
//                   }
//                   if (sessions.isEmpty) {
//                     return Center(
//                         child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
//                         const SizedBox(height: 16),
//                         Text('No sessions found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600))
//                       ],
//                     ));
//                   }
//                   return ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: sessions.length,
//                       itemBuilder: (context, index) => _buildSessionCard(sessions[index]));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReportsAnalytics() {
//     return Container(
//       color: AppTheme.backgroundColor,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Generate Reports',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//             const SizedBox(height: 16),
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 1.2,
//               children: [
//                 _buildReportCard('Coach Performance', Icons.analytics, Colors.blue, () {}),
//                 _buildReportCard('Enterprise Progress', Icons.business, Colors.green, () {}),
//                 _buildReportCard('Assessment Summary', Icons.assignment, Colors.orange, () {}),
//                 _buildReportCard('Session Analytics', Icons.event, Colors.purple, () {}),
//               ],
//             ),
//             const SizedBox(height: 24),
//             const Text('Recent Reports',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//               child: Column(
//                 children: [
//                   _buildReportItem('Coach Performance - March 2025', 'Generated 2 days ago', 'PDF'),
//                   const Divider(height: 1),
//                   _buildReportItem('Enterprise Progress Q1 2025', 'Generated 5 days ago', 'Excel'),
//                   const Divider(height: 1),
//                   _buildReportItem('Assessment Summary - Q1', 'Generated 1 week ago', 'PDF'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text('Key Insights',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight),
//                   borderRadius: BorderRadius.circular(16)),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(child: _buildInsightItem('Total Coaches', _buildTotalCoachesCount(), Icons.people)),
//                       Expanded(child: _buildInsightItem('Active Coaches', _buildActiveCoachesCount(), Icons.check_circle)),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                           child: _buildInsightItem('Total Enterprises', _buildTotalEnterprisesCount(), Icons.business)),
//                       Expanded(child: _buildInsightItem('Graduated', _buildGraduatedEnterprisesCount(), Icons.emoji_events)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCoachCard(Coach coach) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CoachDetailScreen(coach: coach)))
//             .then((_) => setState(() {})),
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
//                       child: Center(
//                           child: Text(coach.fullName.isNotEmpty ? coach.fullName[0].toUpperCase() : 'C',
//                               style: const TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)))),
//                   const SizedBox(width: 12),
//                   Expanded(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(coach.fullName,
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//                       const SizedBox(height: 4),
//                       Text(coach.email, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
//                           const SizedBox(width: 4),
//                           Text('${coach.region}, ${coach.zone}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
//                         ],
//                       )
//                     ],
//                   )),
//                   Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                           color: coach.accountStatus == 'active'
//                               ? AppTheme.successColor.withOpacity(0.1)
//                               : AppTheme.errorColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Text(coach.accountStatus,
//                           style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: coach.accountStatus == 'active' ? AppTheme.successColor : AppTheme.errorColor))),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   _buildInfoChip(Icons.work, '${coach.yearsOfExperience} yrs'),
//                   const SizedBox(width: 8),
//                   _buildInfoChip(Icons.school, coach.educationLevel),
//                   const SizedBox(width: 8),
//                   _buildInfoChip(Icons.phone, coach.phone),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoChip(IconData icon, String label) {
//     return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 12, color: Colors.grey.shade600),
//             const SizedBox(width: 4),
//             Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700))
//           ],
//         ));
//   }

//   Widget _buildStatCard(String label, String value, IconData icon, Color color) {
//     return Expanded(
//       child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
//           child: Column(
//             children: [
//               Icon(icon, color: color, size: 24),
//               const SizedBox(height: 4),
//               Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
//               Text(label, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)), textAlign: TextAlign.center)
//             ],
//           )),
//     );
//   }

//   Widget _buildEnterpriseCard(Enterprise enterprise) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => EnterpriseProfileScreen(enterpriseId: enterprise.id),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
//                       child: const Icon(Icons.business, color: AppTheme.primaryColor, size: 30)),
//                   const SizedBox(width: 12),
//                   Expanded(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(enterprise.businessName,
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//                       const SizedBox(height: 4),
//                       Text(enterprise.ownerName, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
//                           const SizedBox(width: 4),
//                           Text(enterprise.location, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
//                         ],
//                       )
//                     ],
//                   )),
//                   Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                           color: enterprise.status == 'Active' ? AppTheme.successColor.withOpacity(0.1) : Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Text(enterprise.status,
//                           style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: enterprise.status == 'Active' ? AppTheme.successColor : Colors.grey.shade600))),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildScoreChip('Finance', enterprise.financeScore),
//                   _buildScoreChip('Marketing', enterprise.marketingScore),
//                   _buildScoreChip('Ops', enterprise.operationsScore),
//                   _buildScoreChip('HR', enterprise.hrScore),
//                   _buildScoreChip('Gov', enterprise.governanceScore),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildScoreChip(String label, double score) {
//     return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//         decoration: BoxDecoration(
//             color: AppColors.getScoreColor(score).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
//         child: Column(
//           children: [
//             Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
//             Text('${score.toInt()}%',
//                 style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.getScoreColor(score)))
//           ],
//         ));
//   }

//   Widget _buildAssessmentCard(Assessment assessment) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         onTap: () {},
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
//                       child: const Icon(Icons.assignment, color: AppTheme.primaryColor, size: 20)),
//                   const SizedBox(width: 12),
//                   Expanded(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(assessment.enterpriseName,
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.person_outline, size: 12, color: Colors.grey.shade600),
//                           const SizedBox(width: 4),
//                           Text(assessment.coachName, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//                           const SizedBox(width: 12),
//                           Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
//                           const SizedBox(width: 4),
//                           Text('${assessment.date.day}/${assessment.date.month}/${assessment.date.year}',
//                               style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
//                         ],
//                       )
//                     ],
//                   )),
//                   Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                           color: _getAssessmentTypeColor(assessment.type).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
//                       child: Text(assessment.type,
//                           style: TextStyle(
//                               fontSize: 11, fontWeight: FontWeight.w600, color: _getAssessmentTypeColor(assessment.type)))),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildScoreChip('Finance', assessment.scores['finance'] ?? 0),
//                   _buildScoreChip('Marketing', assessment.scores['marketing'] ?? 0),
//                   _buildScoreChip('Ops', assessment.scores['operations'] ?? 0),
//                   _buildScoreChip('HR', assessment.scores['hr'] ?? 0),
//                   _buildScoreChip('Gov', assessment.scores['governance'] ?? 0),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getAssessmentTypeColor(String type) {
//     switch (type) {
//       case 'Baseline':
//         return Colors.blue;
//       case 'Quarterly':
//         return Colors.purple;
//       case 'Follow-up':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   Widget _buildSessionCard(CoachingSession session) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         onTap: () {},
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       color: session.isCompleted
//                           ? AppTheme.successColor.withOpacity(0.1)
//                           : AppTheme.primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('${session.scheduledDate.day}',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: session.isCompleted ? AppTheme.successColor : AppTheme.primaryColor)),
//                       Text(_getMonthAbbreviation(session.scheduledDate.month),
//                           style: TextStyle(
//                               fontSize: 10,
//                               color: session.isCompleted ? AppTheme.successColor : AppTheme.primaryColor))
//                     ],
//                   )),
//               const SizedBox(width: 12),
//               Expanded(
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(session.enterpriseName,
//                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//                   const SizedBox(height: 4),
//                   Text(session.type, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//                   const SizedBox(height: 4),
//                   Text(session.coachName, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
//                 ],
//               )),
//               Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                       color: session.isCompleted
//                           ? AppTheme.successColor.withOpacity(0.1)
//                           : AppTheme.warningColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Text(session.status,
//                       style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: session.isCompleted ? AppTheme.successColor : AppTheme.warningColor))),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getMonthAbbreviation(int month) {
//     const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return months[month - 1];
//   }

//   Widget _buildReportCard(String title, IconData icon, Color color, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
//                   child: Icon(icon, color: color, size: 30)),
//               const SizedBox(height: 12),
//               Text(title,
//                   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
//                   textAlign: TextAlign.center)
//             ],
//           )),
//     );
//   }

//   Widget _buildReportItem(String title, String date, String format) {
//     return ListTile(
//       leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
//           child: Icon(format == 'PDF' ? Icons.picture_as_pdf : Icons.insert_drive_file,
//               color: format == 'PDF' ? Colors.red : Colors.green, size: 20)),
//       title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
//       subtitle: Text(date, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//       trailing: IconButton(icon: Icon(Icons.download, size: 20, color: Colors.grey.shade600), onPressed: () {}),
//     );
//   }

//   Widget _buildInsightItem(String label, Widget value, IconData icon) {
//     return Row(
//       children: [
//         Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
//             child: Icon(icon, color: Colors.white, size: 16)),
//         const SizedBox(width: 8),
//         Expanded(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [value, Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10))],
//         )),
//       ],
//     );
//   }

//   Widget _buildActiveCoachesCount() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Text('0', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
//           }
//           int active = snapshot.data!.docs
//               .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'active')
//               .length;
//           return Text(active.toString(),
//               style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
//         });
//   }

//   Widget _buildGraduatedEnterprisesCount() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Text('0', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
//           }
//           int graduated = snapshot.data!.docs
//               .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Graduated')
//               .length;
//           return Text(graduated.toString(),
//               style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
//         });
//   }

//   Widget _buildDrawer(BuildContext context, Coach? supervisor, AuthProvider authProvider) {
//     return Drawer(
//       child: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
//               decoration: const BoxDecoration(
//                   color: AppTheme.primaryColor,
//                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.white,
//                         child: Text(
//                           (supervisor?.fullName.isNotEmpty ?? false) ? supervisor!.fullName[0].toUpperCase() : 'S',
//                           style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(supervisor?.fullName ?? 'Supervisor',
//                                 style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 4),
//                             Text(supervisor?.email ?? '',
//                                 style: const TextStyle(color: Colors.white70, fontSize: 12)),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
//                               child: const Text('SUPERVISOR',
//                                   style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 children: [
//                   _buildDrawerItem(Icons.dashboard, 'Overview', () => setState(() => _selectedIndex = 0)),
//                   _buildDrawerItem(Icons.people, 'Manage Coaches', () => setState(() => _selectedIndex = 1)),
//                   _buildDrawerItem(Icons.business, 'Enterprises', () => setState(() => _selectedIndex = 2)),
//                   _buildDrawerItem(Icons.assignment, 'Assessments', () => setState(() => _selectedIndex = 3)),
//                   _buildDrawerItem(Icons.event, 'Sessions', () => setState(() => _selectedIndex = 4)),
//                   _buildDrawerItem(Icons.analytics, 'Reports', () => setState(() => _selectedIndex = 5)),
//                   _buildDrawerItem(Icons.qr_code_scanner, 'QC Queue', () {
//                     Navigator.pop(context);
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => const QcQueueScreen()));
//                   }),
//                   _buildDrawerItem(Icons.school, 'Training Management', () {
//                     Navigator.pop(context);
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => const TrainingListScreen()));
//                   }),
//                   _buildDrawerItem(Icons.person_add, 'Register New Coach', () {
//                     Navigator.pop(context);
//                     if (supervisor != null) {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => RegisterCoachForm(
//                                   supervisorId: supervisor.id ?? '', supervisorName: supervisor.fullName)));
//                     }
//                   }),
//                   const Divider(),
//                   _buildDrawerItem(Icons.person, 'My Profile', () {
//                     Navigator.pop(context);
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
//                   }),
//                   _buildDrawerItem(Icons.settings, 'Settings', () => Navigator.pop(context)),
//                   _buildDrawerItem(Icons.help, 'Help & Support', () => Navigator.pop(context)),
//                   const Divider(),
//                   _buildDrawerItem(Icons.logout, 'Sign Out', () {
//                     Navigator.pop(context);
//                     _showSignOutDialog(context, authProvider);
//                   }, color: AppTheme.errorColor),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text('Version 1.0.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
//     return ListTile(
//       leading: Icon(icon, color: color ?? AppTheme.textPrimary),
//       title: Text(label, style: TextStyle(color: color ?? AppTheme.textPrimary, fontWeight: FontWeight.w500)),
//       trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
//       onTap: onTap,
//     );
//   }

//   void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Sign Out'),
//         content: const Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await authProvider.signOut();
//             },
//             child: const Text('Sign Out', style: TextStyle(color: AppTheme.errorColor)),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:mohas/screens/register_coach_from.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../providers/enterprise_provider.dart';
import '../models/coach_model.dart';
import '../models/enterprise.dart';
import '../models/assessment.dart';
import '../models/session.dart';
import 'coach_detail_screen.dart';
import '../theme/app_theme2.dart';
import 'profile_screen.dart';
import 'qc_queue_screen.dart';
import 'training_list_screen.dart';
import 'enterprise_profile_screen.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _filters = ['All', 'Active', 'Inactive'];
  final List<String> _enterpriseFilters = ['All', 'Active', 'Graduated', 'Needs Attention'];
  final List<String> _assessmentFilters = ['All', 'Baseline', 'Quarterly', 'Follow-up'];
  final List<String> _sessionFilters = ['All', 'Upcoming', 'Completed'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EnterpriseProvider>(context, listen: false).fetchEnterprises(role: 'supervisor');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final supervisor = authProvider.coach;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
        title: Text(_getAppBarTitle(), style: const TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: () => setState(() {})),
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () async => await authProvider.signOut()),
        ],
      ),
      drawer: _buildDrawer(context, supervisor, authProvider),
      body: _selectedIndex == 0 ? _buildOverviewDashboard() : _buildTabContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Overview Dashboard';
      case 1:
        return 'Coaches Management';
      case 2:
        return 'Enterprises Overview';
      case 3:
        return 'Assessments Overview';
      case 4:
        return 'Sessions Overview';
      case 5:
        return 'Reports & Analytics';
      default:
        return 'Supervisor Dashboard';
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))]),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Coaches'),
          BottomNavigationBarItem(icon: Icon(Icons.business_outlined), activeIcon: Icon(Icons.business), label: 'Enterprises'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Assessments'),
          BottomNavigationBarItem(icon: Icon(Icons.event_outlined), activeIcon: Icon(Icons.event), label: 'Sessions'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), activeIcon: Icon(Icons.analytics), label: 'Reports'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 1:
        return _buildCoachesManagement();
      case 2:
        return _buildEnterprisesOverview();
      case 3:
        return _buildAssessmentsOverview();
      case 4:
        return _buildSessionsOverview();
      case 5:
        return _buildReportsAnalytics();
      default:
        return _buildOverviewDashboard();
    }
  }

  Widget _buildOverviewDashboard() {
    return Container(
      color: AppTheme.backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 20),
            _buildKeyMetrics(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildRecentActivity(),
            const SizedBox(height: 24),
            _buildPerformanceCharts(),
            const SizedBox(height: 24),
            _buildTopCoaches(),
            const SizedBox(height: 24),
            _buildRecentEnterprises(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 4),
                  Text('Supervisor', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
                ],
              )),
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.notifications, color: Colors.white, size: 30)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildWelcomeStat('Total Coaches', _buildTotalCoachesCount(), Icons.people)),
              const SizedBox(width: 12),
              Expanded(child: _buildWelcomeStat('Total Enterprises', _buildTotalEnterprisesCount(), Icons.business)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeStat(String label, Widget value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [value, Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11))],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTotalCoachesCount() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
        builder: (context, snapshot) => Text(snapshot.hasData ? '${snapshot.data!.docs.length}' : '0',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)));
  }

  Widget _buildTotalEnterprisesCount() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
        builder: (context, snapshot) => Text(snapshot.hasData ? '${snapshot.data!.docs.length}' : '0',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)));
  }

  Widget _buildKeyMetrics() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
      builder: (context, coachSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
          builder: (context, enterpriseSnapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
              builder: (context, assessmentSnapshot) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('sessions').snapshots(),
                  builder: (context, sessionSnapshot) {
                    int totalCoaches = coachSnapshot.hasData ? coachSnapshot.data!.docs.length : 0;
                    int totalEnterprises = enterpriseSnapshot.hasData ? enterpriseSnapshot.data!.docs.length : 0;
                    int totalAssessments = assessmentSnapshot.hasData ? assessmentSnapshot.data!.docs.length : 0;
                    int totalSessions = sessionSnapshot.hasData ? sessionSnapshot.data!.docs.length : 0;
                    int activeCoaches = coachSnapshot.hasData
                        ? coachSnapshot.data!.docs
                            .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'active')
                            .length
                        : 0;
                    int activeEnterprises = enterpriseSnapshot.hasData
                        ? enterpriseSnapshot.data!.docs
                            .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Active')
                            .length
                        : 0;
                    return SizedBox(
                      height: 280,
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.4,
                        children: [
                          _buildMetricCard('Total Coaches', totalCoaches.toString(), Icons.people, Colors.blue,
                              '$activeCoaches Active'),
                          _buildMetricCard('Total Enterprises', totalEnterprises.toString(), Icons.business,
                              Colors.green, '$activeEnterprises Active'),
                          _buildMetricCard('Total Assessments', totalAssessments.toString(), Icons.assignment,
                              Colors.orange, 'Last 30 days'),
                          _buildMetricCard('Total Sessions', totalSessions.toString(), Icons.event, Colors.purple,
                              'This month'),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 18)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildQuickActionButton('Add Coach', Icons.person_add, Colors.blue, () => setState(() => _selectedIndex = 1))),
            const SizedBox(width: 8),
            Expanded(child: _buildQuickActionButton('Add Enterprise', Icons.add_business, Colors.green, () {})),
            const SizedBox(width: 8),
            Expanded(child: _buildQuickActionButton('New Assessment', Icons.assignment_add, Colors.orange,
                () => setState(() => _selectedIndex = 3))),
            const SizedBox(width: 8),
            Expanded(child: _buildQuickActionButton('Schedule Session', Icons.calendar_month, Colors.purple,
                () => setState(() => _selectedIndex = 4))),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              TextButton(onPressed: () {}, child: const Text('View All'))
            ]),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('activity_logs')
              .orderBy('timestamp', descending: true)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text('No recent activity', style: TextStyle(color: Colors.grey.shade600))
                    ],
                  ));
            }
            return Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final activity = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: _getActivityColor(activity['action']).withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(_getActivityIcon(activity['action']),
                            color: _getActivityColor(activity['action']), size: 16)),
                    title: Text(activity['action'] ?? 'Activity', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(activity['coachName'] ?? ''),
                    trailing: Text(_formatTimestamp(activity['timestamp']), style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getActivityColor(String action) {
    switch (action) {
      case 'coach_registration':
        return Colors.blue;
      case 'enterprise_registration':
        return Colors.green;
      case 'assessment_created':
        return Colors.orange;
      case 'session_created':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String action) {
    switch (action) {
      case 'coach_registration':
        return Icons.person_add;
      case 'enterprise_registration':
        return Icons.business;
      case 'assessment_created':
        return Icons.assignment;
      case 'session_created':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    if (timestamp is Timestamp) {
      final now = DateTime.now();
      final date = timestamp.toDate();
      final diff = now.difference(date);
      if (diff.inDays > 7) return '${date.day}/${date.month}/${date.year}';
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    }
    return 'Just now';
  }

  Widget _buildPerformanceCharts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Performance Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 12),
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildChartIndicator('Coaches', _buildCoachActivePercentage(), Icons.people, Colors.blue)),
                    Expanded(
                        child: _buildChartIndicator('Enterprises', _buildEnterpriseActivePercentage(), Icons.business,
                            Colors.green)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildChartIndicator('Assessments', _buildAssessmentCompletionRate(), Icons.assignment,
                            Colors.orange)),
                    Expanded(
                        child:
                            _buildChartIndicator('Sessions', _buildSessionCompletionRate(), Icons.event, Colors.purple)),
                  ],
                )
              ],
            )),
      ],
    );
  }

  Widget _buildCoachActivePercentage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('0%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          }
          try {
            final coaches = snapshot.data!.docs;
            int active = coaches
                .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'active')
                .length;
            int percent = coaches.isEmpty ? 0 : (active * 100 / coaches.length).round();
            return Text('$percent%',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          } catch (e) {
            return const Text('0%',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          }
        });
  }

  Widget _buildEnterpriseActivePercentage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('0%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          }
          try {
            final enterprises = snapshot.data!.docs;
            int active = enterprises
                .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Active')
                .length;
            int percent = enterprises.isEmpty ? 0 : (active * 100 / enterprises.length).round();
            return Text('$percent%',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          } catch (e) {
            return const Text('0%',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          }
        });
  }

  Widget _buildAssessmentCompletionRate() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('0%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          }
          try {
            final assessments = snapshot.data!.docs;
            int completed = assessments
                .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Completed')
                .length;
            int percent = assessments.isEmpty ? 0 : (completed * 100 / assessments.length).round();
            return Text('$percent%',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          } catch (e) {
            return const Text('0%',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          }
        });
  }

  Widget _buildSessionCompletionRate() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('sessions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('0%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          }
          try {
            final sessions = snapshot.data!.docs;
            int completed = sessions.where((doc) => (doc.data() as Map<String, dynamic>)['actualDate'] != null).length;
            int percent = sessions.isEmpty ? 0 : (completed * 100 / sessions.length).round();
            return Text('$percent%',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          } catch (e) {
            return const Text('0%',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
          }
        });
  }

  Widget _buildChartIndicator(String label, Widget value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 14)),
        const SizedBox(width: 8),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            value
          ],
        ))
      ],
    );
  }

  Widget _buildTopCoaches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Performing Coaches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              TextButton(onPressed: () => setState(() => _selectedIndex = 1), child: const Text('View All'))
            ]),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').limit(3).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text('No coaches yet', style: TextStyle(color: Colors.grey.shade600))
                    ],
                  ));
            }
            return Column(
                children: snapshot.data!.docs.map((doc) {
              try {
                final data = doc.data() as Map<String, dynamic>;
                final coach = Coach.fromMap(data, id: doc.id);
                return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                            child: Center(
                                child: Text(coach.fullName.isNotEmpty ? coach.fullName[0].toUpperCase() : 'C',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(coach.fullName,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(coach.email, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
                          ],
                        )),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: coach.accountStatus == 'active'
                                    ? AppTheme.successColor.withOpacity(0.1)
                                    : AppTheme.errorColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(coach.accountStatus,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: coach.accountStatus == 'active' ? AppTheme.successColor : AppTheme.errorColor)))
                      ],
                    ));
              } catch (e) {
                return const SizedBox.shrink();
              }
            }).toList());
          },
        ),
      ],
    );
  }

  Widget _buildRecentEnterprises() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Enterprises',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              TextButton(onPressed: () => setState(() => _selectedIndex = 2), child: const Text('View All'))
            ]),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('enterprises')
              .orderBy('registrationDate', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Icon(Icons.business_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text('No enterprises yet', style: TextStyle(color: Colors.grey.shade600))
                    ],
                  ));
            }
            return Column(
                children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final enterprise = Enterprise.fromMap(doc.id, data);
              return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.business, color: AppTheme.primaryColor, size: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(enterprise.businessName,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text(enterprise.ownerName, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
                        ],
                      )),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: enterprise.status == 'Active'
                                  ? AppTheme.successColor.withOpacity(0.1)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(enterprise.status,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: enterprise.status == 'Active' ? AppTheme.successColor : Colors.grey.shade600)))
                    ],
                  ));
            }).toList());
          },
        ),
      ],
    );
  }

  Widget _buildCoachesManagement() {
    final authProvider = Provider.of<AuthProvider>(context);
    final supervisor = authProvider.coach;
    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final coaches = snapshot.data!.docs;
                  int active = coaches
                      .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'active')
                      .length;
                  int inactive = coaches
                      .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'inactive')
                      .length;
                  return Row(
                    children: [
                      Expanded(
                          child: _buildStatCard('Total Coaches', coaches.length.toString(), Icons.people, Colors.blue)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('Active', active.toString(), Icons.check_circle, Colors.green)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard('Inactive', inactive.toString(), Icons.cancel, Colors.orange)),
                    ],
                  );
                },
              )),
          Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                        decoration: const InputDecoration(
                            hintText: 'Search coaches by name, email, region...',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      )),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) => setState(() => _selectedFilter = filter),
                            backgroundColor: Colors.grey.shade50,
                            selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                            checkmarkColor: AppTheme.primaryColor,
                            labelStyle: TextStyle(
                                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                      );
                    }).toList()),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                if (supervisor != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterCoachForm(
                              supervisorId: supervisor.id ?? '', supervisorName: supervisor.fullName))).then((_) => setState(() {}));
                }
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Register New Coach'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}')
                    ],
                  ));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var coaches = snapshot.data!.docs
                    .map((doc) => Coach.fromMap(doc.data() as Map<String, dynamic>, id: doc.id))
                    .toList();
                if (_searchQuery.isNotEmpty) {
                  coaches = coaches.where((c) =>
                      c.fullName.toLowerCase().contains(_searchQuery) ||
                      c.email.toLowerCase().contains(_searchQuery) ||
                      c.region.toLowerCase().contains(_searchQuery) ||
                      c.phone.contains(_searchQuery)).toList();
                }
                if (_selectedFilter != 'All') {
                  coaches = coaches.where((c) => c.accountStatus.toLowerCase() == _selectedFilter.toLowerCase()).toList();
                }
                if (coaches.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('No coaches found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      Text('Click "Register New Coach" to add one', style: TextStyle(fontSize: 14, color: Colors.grey.shade500))
                    ],
                  ));
                }
                return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: coaches.length,
                    itemBuilder: (context, index) => _buildCoachCard(coaches[index]));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterprisesOverview() {
    String enterpriseSearch = '';
    String enterpriseFilter = 'All';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EnterpriseProvider>(context, listen: false).fetchEnterprises(role: 'supervisor');
    });
    return StatefulBuilder(
      builder: (context, setState) => Container(
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final enterprises = snapshot.data!.docs;
                    int active = enterprises
                        .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Active')
                        .length;
                    int graduated = enterprises
                        .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Graduated')
                        .length;
                    return Row(
                      children: [
                        Expanded(
                            child: _buildStatCard('Total', enterprises.length.toString(), Icons.business, Colors.blue)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Active', active.toString(), Icons.check_circle, Colors.green)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Graduated', graduated.toString(), Icons.emoji_events, Colors.orange)),
                      ],
                    );
                  },
                )),
            Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          onChanged: (v) => setState(() => enterpriseSearch = v.toLowerCase()),
                          decoration: const InputDecoration(
                              hintText: 'Search enterprises by name, owner...',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        )),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _enterpriseFilters.map((filter) {
                        final isSelected = enterpriseFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) => setState(() => enterpriseFilter = filter),
                              backgroundColor: Colors.grey.shade50,
                              selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                              checkmarkColor: AppTheme.primaryColor,
                              labelStyle: TextStyle(
                                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                        );
                      }).toList()),
                    )
                  ],
                )),
            Expanded(
              child: Consumer<EnterpriseProvider>(
                builder: (context, enterpriseProvider, _) {
                  var enterprises = enterpriseProvider.enterprises;
                  if (enterpriseSearch.isNotEmpty) {
                    enterprises = enterprises.where((e) =>
                        e.businessName.toLowerCase().contains(enterpriseSearch) ||
                        e.ownerName.toLowerCase().contains(enterpriseSearch)).toList();
                  }
                  if (enterpriseFilter != 'All') {
                    if (enterpriseFilter == 'Needs Attention') {
                      enterprises = enterprises.where((e) => e.overallScore < 50).toList();
                    } else {
                      enterprises = enterprises.where((e) => e.status == enterpriseFilter).toList();
                    }
                  }
                  if (enterprises.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('No enterprises found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600))
                      ],
                    ));
                  }
                  return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: enterprises.length,
                      itemBuilder: (context, index) => _buildEnterpriseCard(enterprises[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentsOverview() {
    String assessmentSearch = '';
    String assessmentFilter = 'All';
    return StatefulBuilder(
      builder: (context, setState) => Container(
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final assessments = snapshot.data!.docs;
                    int baseline = assessments
                        .where((doc) => (doc.data() as Map<String, dynamic>)['type'] == 'Baseline')
                        .length;
                    int quarterly = assessments
                        .where((doc) => (doc.data() as Map<String, dynamic>)['type'] == 'Quarterly')
                        .length;
                    return Row(
                      children: [
                        Expanded(
                            child: _buildStatCard('Total', assessments.length.toString(), Icons.assignment, Colors.blue)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildStatCard('Baseline', baseline.toString(), Icons.assignment_turned_in, Colors.green)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildStatCard('Quarterly', quarterly.toString(), Icons.assignment_late, Colors.orange)),
                      ],
                    );
                  },
                )),
            Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          onChanged: (v) => setState(() => assessmentSearch = v.toLowerCase()),
                          decoration: const InputDecoration(
                              hintText: 'Search assessments by enterprise...',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        )),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _assessmentFilters.map((filter) {
                        final isSelected = assessmentFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) => setState(() => assessmentFilter = filter),
                              backgroundColor: Colors.grey.shade50,
                              selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                              checkmarkColor: AppTheme.primaryColor,
                              labelStyle: TextStyle(
                                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                        );
                      }).toList()),
                    )
                  ],
                )),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('assessments')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var assessments = snapshot.data!.docs
                      .map((doc) => Assessment.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                      .toList();
                  if (assessmentSearch.isNotEmpty) {
                    assessments = assessments
                        .where((a) => a.enterpriseName.toLowerCase().contains(assessmentSearch))
                        .toList();
                  }
                  if (assessmentFilter != 'All') {
                    assessments = assessments.where((a) => a.type == assessmentFilter).toList();
                  }
                  if (assessments.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('No assessments found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600))
                      ],
                    ));
                  }
                  return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: assessments.length,
                      itemBuilder: (context, index) => _buildAssessmentCard(assessments[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsOverview() {
    String sessionSearch = '';
    String sessionFilter = 'All';
    return StatefulBuilder(
      builder: (context, setState) => Container(
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('sessions').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final sessions = snapshot.data!.docs;
                    int upcoming = sessions.where((doc) => (doc.data() as Map<String, dynamic>)['actualDate'] == null).length;
                    int completed = sessions.where((doc) => (doc.data() as Map<String, dynamic>)['actualDate'] != null).length;
                    return Row(
                      children: [
                        Expanded(child: _buildStatCard('Total', sessions.length.toString(), Icons.event, Colors.blue)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Upcoming', upcoming.toString(), Icons.schedule, Colors.orange)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Completed', completed.toString(), Icons.check_circle, Colors.green)),
                      ],
                    );
                  },
                )),
            Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          onChanged: (v) => setState(() => sessionSearch = v.toLowerCase()),
                          decoration: const InputDecoration(
                              hintText: 'Search sessions by enterprise...',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        )),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _sessionFilters.map((filter) {
                        final isSelected = sessionFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) => setState(() => sessionFilter = filter),
                              backgroundColor: Colors.grey.shade50,
                              selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                              checkmarkColor: AppTheme.primaryColor,
                              labelStyle: TextStyle(
                                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                        );
                      }).toList()),
                    )
                  ],
                )),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sessions')
                    .orderBy('scheduledDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var sessions = snapshot.data!.docs
                      .map((doc) => CoachingSession.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                      .toList();
                  if (sessionSearch.isNotEmpty) {
                    sessions = sessions.where((s) => s.enterpriseName.toLowerCase().contains(sessionSearch)).toList();
                  }
                  if (sessionFilter != 'All') {
                    if (sessionFilter == 'Upcoming') {
                      sessions = sessions.where((s) => !s.isCompleted).toList();
                    } else if (sessionFilter == 'Completed') {
                      sessions = sessions.where((s) => s.isCompleted).toList();
                    }
                  }
                  if (sessions.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('No sessions found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600))
                      ],
                    ));
                  }
                  return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) => _buildSessionCard(sessions[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsAnalytics() {
    return Container(
      color: AppTheme.backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Generate Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildReportCard('Coach Performance', Icons.analytics, Colors.blue, () {}),
                _buildReportCard('Enterprise Progress', Icons.business, Colors.green, () {}),
                _buildReportCard('Assessment Summary', Icons.assignment, Colors.orange, () {}),
                _buildReportCard('Session Analytics', Icons.event, Colors.purple, () {}),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Recent Reports',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildReportItem('Coach Performance - March 2025', 'Generated 2 days ago', 'PDF'),
                  const Divider(height: 1),
                  _buildReportItem('Enterprise Progress Q1 2025', 'Generated 5 days ago', 'Excel'),
                  const Divider(height: 1),
                  _buildReportItem('Assessment Summary - Q1', 'Generated 1 week ago', 'PDF'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Key Insights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildInsightItem('Total Coaches', _buildTotalCoachesCount(), Icons.people)),
                      Expanded(child: _buildInsightItem('Active Coaches', _buildActiveCoachesCount(), Icons.check_circle)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInsightItem('Total Enterprises', _buildTotalEnterprisesCount(), Icons.business)),
                      Expanded(child: _buildInsightItem('Graduated', _buildGraduatedEnterprisesCount(), Icons.emoji_events)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachCard(Coach coach) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CoachDetailScreen(coach: coach)))
            .then((_) => setState(() {})),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Center(
                          child: Text(coach.fullName.isNotEmpty ? coach.fullName[0].toUpperCase() : 'C',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(coach.fullName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text(coach.email, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text('${coach.region}, ${coach.zone}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
                        ],
                      )
                    ],
                  )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: coach.accountStatus == 'active'
                              ? AppTheme.successColor.withOpacity(0.1)
                              : AppTheme.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(coach.accountStatus,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: coach.accountStatus == 'active' ? AppTheme.successColor : AppTheme.errorColor))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(Icons.work, '${coach.yearsOfExperience} yrs'),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.school, coach.educationLevel),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.phone, coach.phone),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700))
          ],
        ));
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)), textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget _buildEnterpriseCard(Enterprise enterprise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnterpriseProfileScreen(enterpriseId: enterprise.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.business, color: AppTheme.primaryColor, size: 30)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(enterprise.businessName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text(enterprise.ownerName, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(enterprise.location, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
                        ],
                      )
                    ],
                  )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: enterprise.status == 'Active' ? AppTheme.successColor.withOpacity(0.1) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(enterprise.status,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: enterprise.status == 'Active' ? AppTheme.successColor : Colors.grey.shade600))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScoreChip('Finance', enterprise.financeScore),
                  _buildScoreChip('Marketing', enterprise.marketingScore),
                  _buildScoreChip('Ops', enterprise.operationsScore),
                  _buildScoreChip('HR', enterprise.hrScore),
                  _buildScoreChip('Gov', enterprise.governanceScore),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreChip(String label, double score) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
            color: AppColors.getScoreColor(score).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
            Text('${score.toInt()}%',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.getScoreColor(score)))
          ],
        ));
  }

  Widget _buildAssessmentCard(Assessment assessment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.assignment, color: AppTheme.primaryColor, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(assessment.enterpriseName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 12, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(assessment.coachName, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          const SizedBox(width: 12),
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text('${assessment.date.day}/${assessment.date.month}/${assessment.date.year}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
                        ],
                      )
                    ],
                  )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: _getAssessmentTypeColor(assessment.type).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(assessment.type,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600, color: _getAssessmentTypeColor(assessment.type)))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScoreChip('Finance', assessment.scores['finance'] ?? 0),
                  _buildScoreChip('Marketing', assessment.scores['marketing'] ?? 0),
                  _buildScoreChip('Ops', assessment.scores['operations'] ?? 0),
                  _buildScoreChip('HR', assessment.scores['hr'] ?? 0),
                  _buildScoreChip('Gov', assessment.scores['governance'] ?? 0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAssessmentTypeColor(String type) {
    switch (type) {
      case 'Baseline':
        return Colors.blue;
      case 'Quarterly':
        return Colors.purple;
      case 'Follow-up':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSessionCard(CoachingSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: session.isCompleted
                          ? AppTheme.successColor.withOpacity(0.1)
                          : AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${session.scheduledDate.day}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: session.isCompleted ? AppTheme.successColor : AppTheme.primaryColor)),
                      Text(_getMonthAbbreviation(session.scheduledDate.month),
                          style: TextStyle(
                              fontSize: 10,
                              color: session.isCompleted ? AppTheme.successColor : AppTheme.primaryColor))
                    ],
                  )),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.enterpriseName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text(session.type, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(session.coachName, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
                ],
              )),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: session.isCompleted
                          ? AppTheme.successColor.withOpacity(0.1)
                          : AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(session.status,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: session.isCompleted ? AppTheme.successColor : AppTheme.warningColor))),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildReportCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 30)),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  textAlign: TextAlign.center)
            ],
          )),
    );
  }

  Widget _buildReportItem(String title, String date, String format) {
    return ListTile(
      leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
          child: Icon(format == 'PDF' ? Icons.picture_as_pdf : Icons.insert_drive_file,
              color: format == 'PDF' ? Colors.red : Colors.green, size: 20)),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      subtitle: Text(date, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      trailing: IconButton(icon: Icon(Icons.download, size: 20, color: Colors.grey.shade600), onPressed: () {}),
    );
  }

  Widget _buildInsightItem(String label, Widget value, IconData icon) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 16)),
        const SizedBox(width: 8),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [value, Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10))],
        )),
      ],
    );
  }

  Widget _buildActiveCoachesCount() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'coach').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('0', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
          }
          int active = snapshot.data!.docs
              .where((doc) => (doc.data() as Map<String, dynamic>)['accountStatus'] == 'active')
              .length;
          return Text(active.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
        });
  }

  Widget _buildGraduatedEnterprisesCount() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('enterprises').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('0', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
          }
          int graduated = snapshot.data!.docs
              .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'Graduated')
              .length;
          return Text(graduated.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));
        });
  }

  Widget _buildDrawer(BuildContext context, Coach? supervisor, AuthProvider authProvider) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          (supervisor?.fullName.isNotEmpty ?? false) ? supervisor!.fullName[0].toUpperCase() : 'S',
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(supervisor?.fullName ?? 'Supervisor',
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(supervisor?.email ?? '',
                                style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                              child: const Text('SUPERVISOR',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(Icons.dashboard, 'Overview', () => setState(() => _selectedIndex = 0)),
                  _buildDrawerItem(Icons.people, 'Manage Coaches', () => setState(() => _selectedIndex = 1)),
                  _buildDrawerItem(Icons.business, 'Enterprises', () => setState(() => _selectedIndex = 2)),
                  _buildDrawerItem(Icons.assignment, 'Assessments', () => setState(() => _selectedIndex = 3)),
                  _buildDrawerItem(Icons.event, 'Sessions', () => setState(() => _selectedIndex = 4)),
                  _buildDrawerItem(Icons.analytics, 'Reports', () => setState(() => _selectedIndex = 5)),
                  _buildDrawerItem(Icons.qr_code_scanner, 'QC Queue', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const QcQueueScreen()));
                  }),
                  _buildDrawerItem(Icons.school, 'Training Management', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TrainingListScreen()));
                  }),
                  _buildDrawerItem(Icons.person_add, 'Register New Coach', () {
                    Navigator.pop(context);
                    if (supervisor != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterCoachForm(
                                  supervisorId: supervisor.id ?? '', supervisorName: supervisor.fullName)));
                    }
                  }),
                  const Divider(),
                  _buildDrawerItem(Icons.person, 'My Profile', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  }),
                  _buildDrawerItem(Icons.settings, 'Settings', () => Navigator.pop(context)),
                  _buildDrawerItem(Icons.help, 'Help & Support', () => Navigator.pop(context)),
                  const Divider(),
                  _buildDrawerItem(Icons.logout, 'Sign Out', () {
                    Navigator.pop(context);
                    _showSignOutDialog(context, authProvider);
                  }, color: AppTheme.errorColor),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Version 1.0.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.textPrimary),
      title: Text(label, style: TextStyle(color: color ?? AppTheme.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.signOut();
            },
            child: const Text('Sign Out', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}