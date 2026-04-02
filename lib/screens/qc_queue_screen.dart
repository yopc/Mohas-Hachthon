import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qc_provider.dart';
import '../models/qc_check.dart';
import '../theme/app_theme2.dart';

class QcQueueScreen extends StatelessWidget {
  const QcQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QcProvider>(context);
    provider.fetchPending();

    return Scaffold(
      appBar: AppBar(title: const Text('QC Queue')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.pending.isEmpty
              ? const Center(child: Text('No pending records'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.pending.length,
                  itemBuilder: (context, index) {
                    final qc = provider.pending[index];
                    return Card(
                      child: ListTile(
                        title: Text('${qc.recordType} - ${qc.recordId}'),
                        subtitle: Text('Submitted: ${_formatDate(qc.createdAt)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: AppTheme.successColor),
                              onPressed: () => _showVerifyDialog(context, provider, qc),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: AppTheme.errorColor),
                              onPressed: () => _showCorrectionDialog(context, provider, qc),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showVerifyDialog(BuildContext context, QcProvider provider, QcCheck qc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Record'),
        content: const Text('Are you sure this record is correct?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await provider.verify(qc.id, qc.recordType, qc.recordId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _showCorrectionDialog(BuildContext context, QcProvider provider, QcCheck qc) {
    final notesController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Correction'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(hintText: 'Please specify what needs correction'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (notesController.text.trim().isEmpty) return;
              await provider.requestCorrection(qc.id, notesController.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Request Correction'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
