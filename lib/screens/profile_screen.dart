import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme2.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final coach = authProvider.coach;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())).then((updated) {
                if (updated == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppTheme.successColor, behavior: SnackBarBehavior.floating),
                  );
                }
              });
            },
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: coach == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                              child: Center(child: Text(coach.fullName.isNotEmpty ? coach.fullName[0] : 'C', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.primaryColor))),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppTheme.secondaryColor, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, size: 20, color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(coach.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Text(coach.email, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                          child: Text('Username: ${coach.username}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              _buildInfoRow(Icons.phone, 'Phone', coach.phone),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.badge, 'National ID', coach.nationalId),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.school, 'Education Level', coach.educationLevel + (coach.educationOther != null ? ' - ${coach.educationOther}' : '')),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.science, 'Field of Study', coach.fieldOfStudy + (coach.fieldOfStudyOther != null ? ' - ${coach.fieldOfStudyOther}' : '')),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.work, 'Years of Experience', '${coach.yearsOfExperience} years'),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.verified, 'Has Certification', coach.hasCertification ? 'Yes' : 'No'),
                              if (coach.hasCertification && coach.certificationUrl != null) ...[
                                const Divider(height: 24),
                                _buildInfoRow(Icons.link, 'Certification URL', coach.certificationUrl!),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Location Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              _buildInfoRow(Icons.location_on, 'Region', coach.region),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.location_city, 'Zone', coach.zone),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Account Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              _buildInfoRow(Icons.person, 'Username', coach.username),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.email, 'Email', coach.email),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.supervisor_account, 'Supervisor', coach.supervisorName.isNotEmpty ? coach.supervisorName : 'Not assigned'),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.calendar_today, 'Member Since', '${coach.createdAt.day}/${coach.createdAt.month}/${coach.createdAt.year}'),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.check_circle, 'Account Status', coach.accountStatus, valueColor: coach.accountStatus == 'active' ? AppTheme.successColor : AppTheme.warningColor),
                              const Divider(height: 24),
                              _buildInfoRow(Icons.login, 'First Login', coach.isFirstLogin ? 'Yes' : 'No'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Account Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              _buildSettingTile(Icons.lock, 'Change Password', onTap: () {}),
                              _buildSettingTile(Icons.notifications, 'Notifications', onTap: () {}, showDivider: true),
                              _buildSettingTile(Icons.language, 'Language', value: 'English', onTap: () {}, showDivider: true),
                              _buildSettingTile(Icons.security, 'Privacy & Security', onTap: () {}, showDivider: true),
                              _buildSettingTile(Icons.info, 'About', value: 'Version 1.0.0', onTap: () {}),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
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
                                        if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                                      },
                                      child: const Text('Sign Out', style: TextStyle(color: AppTheme.errorColor)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor.withOpacity(0.1), foregroundColor: AppTheme.errorColor, elevation: 0),
                            child: const Text('Sign Out'),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: AppTheme.primaryColor)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: valueColor ?? AppTheme.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String label, {String? value, required VoidCallback onTap, bool showDivider = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.textSecondary, size: 20),
          title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null) Text(value, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
          onTap: onTap,
        ),
        if (showDivider) Padding(padding: const EdgeInsets.only(left: 56), child: Divider(height: 0, color: Colors.grey.shade100)),
      ],
    );
  }
}
