import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/coach_service.dart';
import '../services/security_service.dart';
import '../models/coach_model.dart';
import '../models/security_model.dart';
import '../theme/app_theme2.dart';
import '../utils/file_picker_helper.dart';

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
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: coach.profilePictureBase64 != null
                        ? MemoryImage(base64Decode(coach.profilePictureBase64!))
                        : null,
                    child: coach.profilePictureBase64 == null
                        ? Text(
                            coach.fullName.isNotEmpty 
                                ? coach.fullName[0].toUpperCase() 
                                : '?',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  title: Text(
                    coach.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(coach.email),
                      if (coach.hasCertification)
                        Row(
                          children: [
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: AppTheme.successColor,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Certified',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (coach.securityId != null)
                        const Icon(Icons.security, color: Colors.green),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: coach.profilePictureBase64 != null
                  ? MemoryImage(base64Decode(coach.profilePictureBase64!))
                  : null,
              child: coach.profilePictureBase64 == null
                  ? Text(coach.fullName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(coach.fullName)),
          ],
        ),
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
              _buildDetailRow('Education', coach.educationLevel),
              _buildDetailRow('Field of Study', coach.fieldOfStudy),
              _buildDetailRow('Experience', '${coach.yearsOfExperience} years'),
              
              if (coach.hasCertification && coach.certificationBase64 != null) ...[const Divider(),
                const Text(
                  'Certification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FilePickerHelper.getFileIcon(coach.certificationFileName ?? 'file.pdf'),
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coach.certificationFileName ?? 'Certification',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const Text(
                              'Click to view',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => _viewCertification(coach),
                      ),
                    ],
                  ),
                ),
              ],
              
              _buildDetailRow('Security ID', coach.securityId ?? 'Not set'),
              if (security != null) ...[const Divider(),
                const Text(
                  'Security Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('2FA Enabled', security.twoFactorEnabled ? 'Yes' : 'No'),
                _buildDetailRow('Security Level', security.securityLevel),
                _buildDetailRow('Trusted Devices', '${security.trustedDevices.length}'),
                _buildDetailRow('Login History', '${security.loginHistory.length} entries'),
                if (security.registeredDevice != null)
                  _buildDetailRow('Registered Device', security.registeredDevice!),
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

  void _viewCertification(CoachModel coach) {
    if (coach.certificationBase64 == null) return;
    
    // Check if it's an image or document
    final fileName = coach.certificationFileName ?? '';
    final isImage = FilePickerHelper.isImageFile(fileName);
    
    if (isImage) {
      // Show image in dialog
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(fileName),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: FilePickerHelper.base64ToImage(
                  coach.certificationBase64!,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // For non-image files, show info message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Viewing $fileName. Document preview coming soon!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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