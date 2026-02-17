import 'package:flutter/material.dart';
import '../services/coach_service.dart';
import '../services/security_service.dart';
import '../models/coach_model.dart';
import '../models/security_model.dart';
import '../theme/app_theme2.dart';

class CoachListScreen extends StatefulWidget {
  const CoachListScreen({super.key});

  @override
  State<CoachListScreen> createState() => _CoachListScreenState();
}

class _CoachListScreenState extends State<CoachListScreen> {
  final CoachService _coachService = CoachService();
  final SecurityService _securityService = SecurityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaches List'),
      ),
      body: StreamBuilder<List<CoachModel>>(
        stream: _coachService.getCoaches(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final coaches = snapshot.data ?? [];

          if (coaches.isEmpty) {
            return const Center(
              child: Text('No coaches registered yet'),
            );
          }

          return ListView.builder(
            itemCount: coaches.length,
            itemBuilder: (context, index) {
              final coach = coaches[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(coach.fullName),
                  subtitle: Text(coach.email),
                  trailing: Text(coach.securityId != null ? '🔒' : '❌'),
                  onTap: () => _showCoachDetails(coach),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCoachDetails(CoachModel coach) async {
    final security = coach.securityId != null
        ? await _securityService.getSecurityById(coach.securityId!)
        : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(coach.fullName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Email', coach.email),
              _buildDetailRow('Phone', coach.phone),
              _buildDetailRow('Username', coach.username),
              _buildDetailRow('Status', coach.accountStatus),
              _buildDetailRow('Region', coach.region),
              _buildDetailRow('Zone', coach.zone),
              _buildDetailRow('Security ID', coach.securityId ?? 'Not set'),
              if (security != null) ...[const Divider(),
                const Text(
                  'Security Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildDetailRow('2FA Enabled', security.twoFactorEnabled ? 'Yes' : 'No'),
                _buildDetailRow('Security Level', security.securityLevel),
                _buildDetailRow('Trusted Devices', '${security.trustedDevices.length}'),
                _buildDetailRow('Login History', '${security.loginHistory.length} entries'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}