import 'package:flutter/material.dart' hide Feedback; // Hide Flutter's built-in Feedback widget
import 'package:provider/provider.dart';
import '../models/feedback.dart';
import '../providers/training_provider.dart';
import '../providers/enterprise_provider.dart';
import '../theme/app_theme2.dart';

class FeedbackFormScreen extends StatefulWidget {
  final String trainingId;
  const FeedbackFormScreen({super.key, required this.trainingId});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEnterpriseId;
  int _usefulnessRating = 3;
  final _unclearPointsController = TextEditingController();
  final _suggestionsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && _selectedEnterpriseId != null) {
      setState(() => _isLoading = true);
      final provider = Provider.of<TrainingProvider>(context, listen: false);
      final feedback = Feedback(
        id: '',
        trainingId: widget.trainingId,
        enterpriseId: _selectedEnterpriseId!,
        usefulnessRating: _usefulnessRating,
        unclearPoints: _unclearPointsController.text,
        suggestions: _suggestionsController.text,
        createdAt: DateTime.now(),
      );
      try {
        await provider.submitFeedback(feedback);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your feedback!'), backgroundColor: AppTheme.successColor),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.errorColor),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final enterprises = Provider.of<EnterpriseProvider>(context).enterprises;
    return Scaffold(
      appBar: AppBar(title: const Text('Session Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedEnterpriseId,
                decoration: const InputDecoration(labelText: 'Select your enterprise'),
                items: enterprises.map((e) => DropdownMenuItem(value: e.id, child: Text(e.businessName))).toList(),
                onChanged: (v) => setState(() => _selectedEnterpriseId = v),
                validator: (v) => v == null ? 'Please select your enterprise' : null,
              ),
              const SizedBox(height: 16),
              const Text('How useful was this session?'),
              Slider(
                value: _usefulnessRating.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _usefulnessRating.toString(),
                onChanged: (v) => setState(() => _usefulnessRating = v.toInt()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unclearPointsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'What was unclear?',
                  hintText: 'Please let us know if any part was confusing',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _suggestionsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Suggestions',
                  hintText: 'How can we improve?',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitFeedback,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}