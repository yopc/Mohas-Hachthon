import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import 'coaching_session_form.dart';
import '../theme/app_theme2.dart';
import '../widgets/session_card.dart';
import '../widgets/loading_overlay.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    return LoadingOverlay(
      isLoading: sessionProvider.isLoading,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                indicatorWeight: 3,
                tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Completed')],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSessionsList(sessionProvider.upcomingSessions),
                  _buildSessionsList(sessionProvider.completedSessions),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CoachingSessionForm()));
            if (result == true && mounted) sessionProvider.refreshSessions();
          },
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSessionsList(List sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No sessions found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sessions.length,
      itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(bottom: 12), child: SessionCard(session: sessions[index], onTap: () {})),
    );
  }
}
