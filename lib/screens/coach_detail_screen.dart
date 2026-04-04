import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coach_model.dart';
import '../theme/app_theme2.dart';
import 'edit_profile_screen.dart';

class CoachDetailScreen extends StatefulWidget {
  final Coach coach;
  const CoachDetailScreen({super.key, required this.coach});

  @override
  State<CoachDetailScreen> createState() => _CoachDetailScreenState();
}

class _CoachDetailScreenState extends State<CoachDetailScreen> {
  bool _isLoading = false;

  Future<void> _updateCoachStatus(String newStatus) async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.coach.id)
          .update({'accountStatus': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coach status updated to $newStatus'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteCoach() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.warning, color: AppTheme.errorColor, size: 50),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Delete Coach Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Are you sure you want to delete ${widget.coach.fullName}?'),
            const SizedBox(height: 8),
            const Text('This action cannot be undone.', style: TextStyle(color: AppTheme.errorColor, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              try {
                await FirebaseFirestore.instance.collection('users').doc(widget.coach.id).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coach deleted successfully'), backgroundColor: AppTheme.successColor),
                );
                Navigator.pop(context, true);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting coach: $e'), backgroundColor: AppTheme.errorColor),
                );
              } finally {
                setState(() => _isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coach.fullName, 
         style: const TextStyle(color: Colors.white),),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(initialCoach: widget.coach)),
              ).then((_) => setState(() {}));
            },
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteCoach),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              widget.coach.fullName.isNotEmpty ? widget.coach.fullName[0].toUpperCase() : 'C',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(widget.coach.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.coach.accountStatus == 'active' ? AppTheme.successColor.withOpacity(0.1) : AppTheme.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.coach.accountStatus.toUpperCase(),
                            style: TextStyle(
                              color: widget.coach.accountStatus == 'active' ? AppTheme.successColor : AppTheme.errorColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Account Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: widget.coach.accountStatus == 'active' ? null : () => _updateCoachStatus('active'),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor, foregroundColor: Colors.white),
                                  child: const Text('Activate'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: widget.coach.accountStatus == 'inactive' ? null : () => _updateCoachStatus('inactive'),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor, foregroundColor: Colors.white),
                                  child: const Text('Deactivate'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection('Personal Information', Icons.person, [
                    _buildInfoRow('Full Name', widget.coach.fullName),
                    _buildInfoRow('Gender', widget.coach.gender),
                    _buildInfoRow('Date of Birth', widget.coach.dateOfBirth != null ? '${widget.coach.dateOfBirth!.day}/${widget.coach.dateOfBirth!.month}/${widget.coach.dateOfBirth!.year}' : 'Not provided'),
                    _buildInfoRow('Phone', widget.coach.phone),
                    _buildInfoRow('Email', widget.coach.email),
                    _buildInfoRow('National ID', widget.coach.nationalId),
                  ]),
                  _buildInfoSection('Professional Information', Icons.work, [
                    _buildInfoRow('Education', widget.coach.educationLevel + (widget.coach.educationOther != null ? ' - ${widget.coach.educationOther}' : '')),
                    _buildInfoRow('Field of Study', widget.coach.fieldOfStudy + (widget.coach.fieldOfStudyOther != null ? ' - ${widget.coach.fieldOfStudyOther}' : '')),
                    _buildInfoRow('Experience', '${widget.coach.yearsOfExperience} years'),
                    _buildInfoRow('Certification', widget.coach.hasCertification ? 'Yes' : 'No'),
                    if (widget.coach.hasCertification && widget.coach.certificationUrl != null) _buildInfoRow('Cert URL', widget.coach.certificationUrl!),
                  ]),
                  _buildInfoSection('Location Information', Icons.location_on, [
                    _buildInfoRow('Region', widget.coach.region),
                    _buildInfoRow('Zone', widget.coach.zone),
                  ]),
                  _buildInfoSection('Account Information', Icons.account_circle, [
                    _buildInfoRow('Username', widget.coach.username),
                    _buildInfoRow('Supervisor', widget.coach.supervisorName),
                    _buildInfoRow('Member Since', '${widget.coach.createdAt.day}/${widget.coach.createdAt.month}/${widget.coach.createdAt.year}'),
                    _buildInfoRow('First Login', widget.coach.isFirstLogin ? 'Yes' : 'No'),
                  ]),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(icon, color: AppTheme.primaryColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                ],
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
        ],
      ),
    );
  }
}