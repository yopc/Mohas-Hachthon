import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/graduation_provider.dart';
import '../providers/enterprise_provider.dart';
import '../theme/app_theme2.dart';

class GraduationChecklistScreen extends StatefulWidget {
  final String enterpriseId;
  const GraduationChecklistScreen({super.key, required this.enterpriseId});

  @override
  State<GraduationChecklistScreen> createState() => _GraduationChecklistScreenState();
}

class _GraduationChecklistScreenState extends State<GraduationChecklistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GraduationProvider>(context, listen: false).fetchChecklist(widget.enterpriseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gradProvider = Provider.of<GraduationProvider>(context);
    final enterprise = Provider.of<EnterpriseProvider>(context).enterprises.firstWhere(
          (e) => e.id == widget.enterpriseId,
        );

    return Scaffold(
      appBar: AppBar(title: Text('Graduation Checklist - ${enterprise.businessName}')),
      body: gradProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _requirementTile('Baseline present', gradProvider.checklist?.baselinePresent ?? false),
                          _requirementTile('Minimum 8 coaching visits', gradProvider.checklist?.minCoachingVisits ?? false),
                          _requirementTile('Midline better than baseline', gradProvider.checklist?.midlineBetter ?? false),
                          _requirementTile('Coach sign-off', gradProvider.checklist?.coachSignOff ?? false),
                          _requirementTile('Evidence pack complete', gradProvider.checklist?.evidencePack ?? false),
                          _requirementTile('M&E approval', gradProvider.checklist?.mAndEApproved ?? false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (gradProvider.checklist != null && !gradProvider.checklist!.mAndEApproved)
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await gradProvider.requestGraduation(widget.enterpriseId);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Graduation request submitted')),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.errorColor),
                            );
                          }
                        }
                      },
                      child: const Text('Request Graduation'),
                    ),
                  if (gradProvider.checklist != null && gradProvider.checklist!.mAndEApproved)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Show certificate
                      },
                      icon: const Icon(Icons.verified),
                      label: const Text('View Certificate'),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _requirementTile(String label, bool isMet) {
    return ListTile(
      leading: Icon(isMet ? Icons.check_circle : Icons.cancel, color: isMet ? AppTheme.successColor : AppTheme.errorColor),
      title: Text(label),
      trailing: isMet ? const Text('Met', style: TextStyle(color: AppTheme.successColor)) : const Text('Not met', style: TextStyle(color: AppTheme.errorColor)),
    );
  }
}
