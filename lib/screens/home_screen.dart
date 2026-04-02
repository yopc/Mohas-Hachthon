// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/enterprise_provider.dart';
// import '../providers/session_provider.dart';
// import '../providers/assessment_provider.dart';
// import '../models/coach_model.dart';
// import 'enterprises_screen.dart';
// import 'assessments_screen.dart';
// import 'sessions_screen.dart';
// import 'progress_screen.dart';
// import 'reports_screen.dart';
// import 'profile_screen.dart';
// import '../widgets/bottom_nav_bar.dart';
// import '../widgets/enterprise_card.dart';
// import '../widgets/session_card.dart';
// import '../theme/app_theme2.dart';
// import '../widgets/loading_overlay.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<EnterpriseProvider>(context, listen: false).fetchEnterprises();
//       Provider.of<SessionProvider>(context, listen: false).fetchSessions();
//       Provider.of<AssessmentProvider>(context, listen: false).fetchAssessments();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
//     final sessionProvider = Provider.of<SessionProvider>(context);
//     Coach? currentCoach = authProvider.coach;

//     return LoadingOverlay(
//       isLoading: enterpriseProvider.isLoading || sessionProvider.isLoading,
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: AppTheme.backgroundColor,
//         appBar: AppBar(
//           title: Text(_getAppBarTitle()),
//           leading: IconButton(icon: const Icon(Icons.menu), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
//           actions: [
//             Stack(
//               children: [
//                 IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
//                 Positioned(
//                   right: 8,
//                   top: 8,
//                   child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppTheme.errorColor, shape: BoxShape.circle), child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         drawer: _buildDrawer(currentCoach, authProvider),
//         body: _buildBody(),
//         bottomNavigationBar: CustomBottomNavBar(currentIndex: _selectedIndex, onTap: (index) => setState(() => _selectedIndex = index)),
//       ),
//     );
//   }

//   String _getAppBarTitle() {
//     switch (_selectedIndex) {
//       case 0: return 'Dashboard';
//       case 1: return 'Enterprises';
//       case 2: return 'Assessments';
//       case 3: return 'Sessions';
//       case 4: return 'Reports';
//       default: return 'MESMER';
//     }
//   }

//   Widget _buildBody() {
//     switch (_selectedIndex) {
//       case 0: return _buildDashboard();
//       case 1: return const EnterprisesScreen();
//       case 2: return const AssessmentsScreen();
//       case 3: return const SessionsScreen();
//       case 4: return const ReportsScreen();
//       default: return _buildDashboard();
//     }
//   }

//   Widget _buildDashboard() {
//     final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
//     final sessionProvider = Provider.of<SessionProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context);
//     String coachName = authProvider.coach?.fullName ?? 'Coach';

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(radius: 25, backgroundColor: Colors.white, child: Text(coachName.isNotEmpty ? coachName[0] : 'C', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor))),
//                     const SizedBox(width: 16),
//                     Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Hello, ${coachName.split(' ')[0]}!', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text('You have ${sessionProvider.upcomingSessions.length} upcoming sessions', style: const TextStyle(color: Colors.white70, fontSize: 14))])),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           Row(
//             children: [
//               Expanded(child: _buildStatCard('Enterprises', enterpriseProvider.enterprises.length.toString(), Icons.business, Colors.blue)),
//               const SizedBox(width: 12),
//               Expanded(child: _buildStatCard('Sessions', sessionProvider.sessions.length.toString(), Icons.event, Colors.orange)),
//               const SizedBox(width: 12),
//               Expanded(child: _buildStatCard('Active', enterpriseProvider.activeEnterprises.length.toString(), Icons.trending_up, Colors.green)),
//             ],
//           ),
//           const SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)), TextButton(onPressed: () {}, child: const Text('View All'))],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(child: _buildQuickActionButton('New Assessment', Icons.assignment, AppTheme.primaryColor, () => setState(() => _selectedIndex = 2))),
//               const SizedBox(width: 12),
//               Expanded(child: _buildQuickActionButton('Schedule Session', Icons.calendar_today, AppTheme.secondaryColor, () => setState(() => _selectedIndex = 3))),
//               const SizedBox(width: 12),
//               Expanded(child: _buildQuickActionButton('Add Enterprise', Icons.add_business, AppTheme.accentColor, () => setState(() => _selectedIndex = 1))),
//             ],
//           ),
//           const SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [const Text('Upcoming Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)), TextButton(onPressed: () => setState(() => _selectedIndex = 3), child: const Text('View All'))],
//           ),
//           const SizedBox(height: 12),
//           sessionProvider.upcomingSessions.isEmpty
//               ? Container(padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(children: [Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400), const SizedBox(height: 12), Text('No upcoming sessions', style: TextStyle(color: Colors.grey.shade600, fontSize: 16))]))
//               : Column(children: sessionProvider.upcomingSessions.take(2).map((session) => Padding(padding: const EdgeInsets.only(bottom: 12), child: SessionCard(session: session, onTap: () {}))).toList()),
//           const SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [const Text('Needs Attention', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)), TextButton(onPressed: () => setState(() => _selectedIndex = 1), child: const Text('View All'))],
//           ),
//           const SizedBox(height: 12),
//           Column(children: enterpriseProvider.enterprises.where((e) => e.overallScore < 50).take(2).map((enterprise) => Padding(padding: const EdgeInsets.only(bottom: 12), child: EnterpriseCard(enterprise: enterprise, onTap: () {}))).toList()),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
//           const SizedBox(height: 12),
//           Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
//           Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
//     return InkWell(
//       onTap: onPressed,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//         child: Column(
//           children: [
//             Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
//             const SizedBox(height: 8),
//             Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawer(Coach? currentCoach, AuthProvider authProvider) {
//     return Drawer(
//       child: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
//               decoration: const BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Text((currentCoach?.fullName.isNotEmpty ?? false) ? currentCoach!.fullName[0] : 'C', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppTheme.primaryColor))),
//                       const SizedBox(width: 16),
//                       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(currentCoach?.fullName ?? 'Coach', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(currentCoach?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12))])),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 children: [
//                   _buildDrawerItem(Icons.dashboard, 'Dashboard', () => setState(() => _selectedIndex = 0)),
//                   _buildDrawerItem(Icons.business, 'Enterprises', () => setState(() => _selectedIndex = 1)),
//                   _buildDrawerItem(Icons.assignment, 'Assessments', () => setState(() => _selectedIndex = 2)),
//                   _buildDrawerItem(Icons.event, 'Sessions', () => setState(() => _selectedIndex = 3)),
//                   _buildDrawerItem(Icons.analytics, 'Progress', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressScreen()))),
//                   _buildDrawerItem(Icons.insert_chart, 'Reports', () => setState(() => _selectedIndex = 4)),
//                   const Divider(),
//                   _buildDrawerItem(Icons.person, 'Profile', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()))),
//                   _buildDrawerItem(Icons.settings, 'Settings', () {}),
//                   _buildDrawerItem(Icons.help, 'Help & Support', () {}),
//                   const Divider(),
//                   _buildDrawerItem(Icons.logout, 'Sign Out', () => _showSignOutDialog(context, authProvider), color: AppTheme.errorColor),
//                 ],
//               ),
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
//               await authProvider.signOut();
//               if (context.mounted) Navigator.pop(context);
//             },
//             child: const Text('Sign Out', style: TextStyle(color: AppTheme.errorColor)),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/enterprise_provider.dart';
import '../providers/session_provider.dart';
import '../providers/assessment_provider.dart';
import '../models/coach_model.dart';
import 'enterprises_screen.dart';
import 'assessments_screen.dart';
import 'sessions_screen.dart';
import 'progress_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'training_list_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/enterprise_card.dart';
import '../widgets/session_card.dart';
import '../theme/app_theme2.dart';
import '../widgets/loading_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EnterpriseProvider>(context, listen: false).fetchEnterprises();
      Provider.of<SessionProvider>(context, listen: false).fetchSessions();
      Provider.of<AssessmentProvider>(context, listen: false).fetchAssessments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    Coach? currentCoach = authProvider.coach;

    return LoadingOverlay(
      isLoading: enterpriseProvider.isLoading || sessionProvider.isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(_getAppBarTitle()),
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
          actions: [
            Stack(
              children: [
                IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppTheme.errorColor, shape: BoxShape.circle), child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          ],
        ),
        drawer: _buildDrawer(currentCoach, authProvider),
        body: _buildBody(),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: _selectedIndex, onTap: (index) => setState(() => _selectedIndex = index)),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0: return 'Dashboard';
      case 1: return 'Enterprises';
      case 2: return 'Assessments';
      case 3: return 'Sessions';
      case 4: return 'Reports';
      default: return 'MESMER';
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return _buildDashboard();
      case 1: return const EnterprisesScreen();
      case 2: return const AssessmentsScreen();
      case 3: return const SessionsScreen();
      case 4: return const ReportsScreen();
      default: return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    String coachName = authProvider.coach?.fullName ?? 'Coach';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 25, backgroundColor: Colors.white, child: Text(coachName.isNotEmpty ? coachName[0] : 'C', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor))),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Hello, ${coachName.split(' ')[0]}!', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text('You have ${sessionProvider.upcomingSessions.length} upcoming sessions', style: const TextStyle(color: Colors.white70, fontSize: 14))])),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildStatCard('Enterprises', enterpriseProvider.enterprises.length.toString(), Icons.business, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Sessions', sessionProvider.sessions.length.toString(), Icons.event, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Active', enterpriseProvider.activeEnterprises.length.toString(), Icons.trending_up, Colors.green)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)), TextButton(onPressed: () {}, child: const Text('View All'))],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildQuickActionButton('New Assessment', Icons.assignment, AppTheme.primaryColor, () => setState(() => _selectedIndex = 2))),
              const SizedBox(width: 12),
              Expanded(child: _buildQuickActionButton('Schedule Session', Icons.calendar_today, AppTheme.secondaryColor, () => setState(() => _selectedIndex = 3))),
              const SizedBox(width: 12),
              Expanded(child: _buildQuickActionButton('Add Enterprise', Icons.add_business, AppTheme.accentColor, () => setState(() => _selectedIndex = 1))),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Upcoming Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)), TextButton(onPressed: () => setState(() => _selectedIndex = 3), child: const Text('View All'))],
          ),
          const SizedBox(height: 12),
          sessionProvider.upcomingSessions.isEmpty
              ? Container(padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(children: [Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400), const SizedBox(height: 12), Text('No upcoming sessions', style: TextStyle(color: Colors.grey.shade600, fontSize: 16))]))
              : Column(children: sessionProvider.upcomingSessions.take(2).map((session) => Padding(padding: const EdgeInsets.only(bottom: 12), child: SessionCard(session: session, onTap: () {}))).toList()),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Needs Attention', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)), TextButton(onPressed: () => setState(() => _selectedIndex = 1), child: const Text('View All'))],
          ),
          const SizedBox(height: 12),
          Column(children: enterpriseProvider.enterprises.where((e) => e.overallScore < 50).take(2).map((enterprise) => Padding(padding: const EdgeInsets.only(bottom: 12), child: EnterpriseCard(enterprise: enterprise, onTap: () {}))).toList()),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(Coach? currentCoach, AuthProvider authProvider) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Text((currentCoach?.fullName.isNotEmpty ?? false) ? currentCoach!.fullName[0] : 'C', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppTheme.primaryColor))),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(currentCoach?.fullName ?? 'Coach', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(currentCoach?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12))])),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(Icons.dashboard, 'Dashboard', () => setState(() => _selectedIndex = 0)),
                  _buildDrawerItem(Icons.business, 'Enterprises', () => setState(() => _selectedIndex = 1)),
                  _buildDrawerItem(Icons.assignment, 'Assessments', () => setState(() => _selectedIndex = 2)),
                  _buildDrawerItem(Icons.event, 'Sessions', () => setState(() => _selectedIndex = 3)),
                  _buildDrawerItem(Icons.school, 'Training', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TrainingListScreen()))),
                  _buildDrawerItem(Icons.analytics, 'Progress', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressScreen()))),
                  _buildDrawerItem(Icons.insert_chart, 'Reports', () => setState(() => _selectedIndex = 4)),
                  const Divider(),
                  _buildDrawerItem(Icons.person, 'Profile', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()))),
                  _buildDrawerItem(Icons.settings, 'Settings', () {}),
                  _buildDrawerItem(Icons.help, 'Help & Support', () {}),
                  const Divider(),
                  _buildDrawerItem(Icons.logout, 'Sign Out', () => _showSignOutDialog(context, authProvider), color: AppTheme.errorColor),
                ],
              ),
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
              await authProvider.signOut();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Sign Out', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}