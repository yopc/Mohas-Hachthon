import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/assessment_provider.dart';
import '../providers/enterprise_provider.dart';
import '../models/assessment.dart';
import '../theme/app_theme2.dart';
import '../widgets/loading_overlay.dart';

class BaselineDiagnosisForm extends StatefulWidget {
  const BaselineDiagnosisForm({super.key});

  @override
  State<BaselineDiagnosisForm> createState() => _BaselineDiagnosisFormState();
}

class _BaselineDiagnosisFormState extends State<BaselineDiagnosisForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  String? _selectedEnterpriseId;
  Map<String, dynamic>? _selectedEnterprise;

  final Map<String, bool> _financeItems = {
    'Keeps bookkeeping': false,
    'Tracks daily expenses': false,
    'Uses bank account': false,
    'Has financial plan': false,
    'Uses digital payment': false,
  };
  String? _financeOther;

  final Map<String, bool> _marketingItems = {
    'Uses social media': false,
    'Has pricing strategy': false,
    'Keeps customer records': false,
    'Has branding': false,
    'Conducts promotion': false,
  };
  String? _marketingOther;

  final Map<String, bool> _hrItems = {
    'Written contracts': false,
    'Employee training': false,
    'Salary records': false,
    'Performance evaluation': false,
  };
  String? _hrOther;

  final Map<String, bool> _operationsItems = {
    'Inventory tracking': false,
    'Quality control': false,
    'Supplier contracts': false,
    'Production planning': false,
  };
  String? _operationsOther;

  final Map<String, bool> _governanceItems = {
    'Clear business structure': false,
    'Strategic planning': false,
    'Regular meetings': false,
    'Compliance with tax': false,
  };
  String? _governanceOther;

  final Map<String, bool> _challenges = {
    'Access to finance': false,
    'Marketing': false,
    'Staff management': false,
    'Operations': false,
    'Business planning': false,
    'Technology adoption': false,
  };
  String? _challengeOther;
  final _recommendedActionsController = TextEditingController();
  DateTime? _followUpDate;

  double _calculateProgress() {
    int totalItems = _financeItems.length + _marketingItems.length + 
                     _hrItems.length + _operationsItems.length + 
                     _governanceItems.length;
    int completedItems = 0;
    
    for (var v in _financeItems.values) { if (v) completedItems++; }
    for (var v in _marketingItems.values) { if (v) completedItems++; }
    for (var v in _hrItems.values) { if (v) completedItems++; }
    for (var v in _operationsItems.values) { if (v) completedItems++; }
    for (var v in _governanceItems.values) { if (v) completedItems++; }
    
    return completedItems / totalItems;
  }

  Map<String, double> _calculateScores() {
    return {
      'finance': (_financeItems.values.where((v) => v).length / _financeItems.length * 100),
      'marketing': (_marketingItems.values.where((v) => v).length / _marketingItems.length * 100),
      'hr': (_hrItems.values.where((v) => v).length / _hrItems.length * 100),
      'operations': (_operationsItems.values.where((v) => v).length / _operationsItems.length * 100),
      'governance': (_governanceItems.values.where((v) => v).length / _governanceItems.length * 100),
    };
  }

  List<String> _getStrengths() {
    List<String> strengths = [];
    if (_financeItems['Keeps bookkeeping'] == true) strengths.add('Maintains bookkeeping');
    if (_marketingItems['Has pricing strategy'] == true) strengths.add('Has pricing strategy');
    if (_hrItems['Employee training'] == true) strengths.add('Provides employee training');
    if (_operationsItems['Quality control'] == true) strengths.add('Has quality control');
    if (_governanceItems['Compliance with tax'] == true) strengths.add('Tax compliant');
    return strengths;
  }

  List<String> _getWeaknesses() {
    List<String> weaknesses = [];
    if (_financeItems['Keeps bookkeeping'] == false) weaknesses.add('No bookkeeping');
    if (_marketingItems['Uses social media'] == false) weaknesses.add('No social media presence');
    if (_hrItems['Written contracts'] == false) weaknesses.add('No written contracts');
    if (_operationsItems['Inventory tracking'] == false) weaknesses.add('No inventory tracking');
    return weaknesses;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedEnterpriseId != null) {
      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
        final enterpriseProvider = Provider.of<EnterpriseProvider>(context, listen: false);

        String coachId = authProvider.user?.uid ?? '';
        String coachName = authProvider.userData?['fullName'] ?? '';
        String enterpriseName = _selectedEnterprise?['businessName'] ?? '';

        Map<String, double> scores = _calculateScores();
        List<String> strengths = _getStrengths();
        List<String> weaknesses = _getWeaknesses();
        List<String> recommendations = _recommendedActionsController.text.split('\n').where((s) => s.isNotEmpty).toList();

        if (recommendations.isEmpty) {
          recommendations = ['Follow up on diagnosis recommendations'];
        }

        Assessment assessment = Assessment(
          id: '',
          enterpriseId: _selectedEnterpriseId!,
          enterpriseName: enterpriseName,
          coachId: coachId,
          coachName: coachName,
          date: DateTime.now(),
          type: 'Baseline',
          scores: scores,
          strengths: strengths,
          weaknesses: weaknesses,
          recommendations: recommendations,
          status: 'Completed',
        );

        await assessmentProvider.addAssessment(assessment);

        await enterpriseProvider.updateEnterprise(_selectedEnterpriseId!, {'scores': scores});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Diagnosis submitted successfully!'),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an enterprise and complete all required fields'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Baseline Diagnosis'),
        ),
        body: Container(
          color: AppTheme.backgroundColor,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedEnterpriseId,
                            decoration: const InputDecoration(
                              labelText: 'Select Enterprise',
                              prefixIcon: Icon(Icons.business, color: AppTheme.primaryColor),
                            ),
                            items: enterpriseProvider.enterprises.map((e) {
                              return DropdownMenuItem(
                                value: e.id,
                                child: Text(e.businessName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedEnterpriseId = value;
                                _selectedEnterprise = enterpriseProvider.enterprises.firstWhere((e) => e.id == value).toMap();
                              });
                            },
                            validator: (value) => value == null ? 'Please select an enterprise' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Diagnosis Progress',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                '${(_calculateProgress() * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getScoreColor(_calculateProgress() * 100),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: _calculateProgress(),
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.getScoreColor(_calculateProgress() * 100)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stepper(
                    type: StepperType.vertical,
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep < 5) {
                        setState(() => _currentStep++);
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep--);
                      }
                    },
                    onStepTapped: (step) => setState(() => _currentStep = step),
                    steps: [
                      Step(
                        title: const Text('Finance'),
                        isActive: true,
                        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                        content: _buildChecklistSection(
                          'Finance',
                          Icons.attach_money,
                          _financeItems,
                          (value) => _financeOther = value,
                        ),
                      ),
                      Step(
                        title: const Text('Marketing'),
                        isActive: true,
                        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                        content: _buildChecklistSection(
                          'Marketing',
                          Icons.campaign,
                          _marketingItems,
                          (value) => _marketingOther = value,
                        ),
                      ),
                      Step(
                        title: const Text('HR'),
                        isActive: true,
                        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                        content: _buildChecklistSection(
                          'HR',
                          Icons.people,
                          _hrItems,
                          (value) => _hrOther = value,
                        ),
                      ),
                      Step(
                        title: const Text('Operations'),
                        isActive: true,
                        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                        content: _buildChecklistSection(
                          'Operations',
                          Icons.settings,
                          _operationsItems,
                          (value) => _operationsOther = value,
                        ),
                      ),
                      Step(
                        title: const Text('Governance'),
                        isActive: true,
                        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
                        content: _buildChecklistSection(
                          'Governance',
                          Icons.account_balance,
                          _governanceItems,
                          (value) => _governanceOther = value,
                        ),
                      ),
                      Step(
                        title: const Text('Final Review'),
                        isActive: true,
                        state: _currentStep > 5 ? StepState.complete : StepState.indexed,
                        content: _buildFinalReview(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistSection(
    String title,
    IconData icon,
    Map<String, bool> items,
    Function(String) onOtherChanged,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.keys.map((key) {
              return CheckboxListTile(
                title: Text(key),
                value: items[key],
                onChanged: (value) {
                  setState(() {
                    items[key] = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Other (specify)',
                prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
              ),
              onChanged: onOtherChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalReview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority Challenges',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._challenges.keys.map((key) {
              return CheckboxListTile(
                title: Text(key),
                value: _challenges[key],
                onChanged: (value) {
                  setState(() {
                    _challenges[key] = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Other Challenge',
                prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
              ),
              onChanged: (value) => _challengeOther = value,
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Recommended Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _recommendedActionsController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter recommended actions...',
                alignLabelWithHint: true,
              ),
              validator: (value) => value == null || value.isEmpty ? 'Recommended actions are required' : null,
            ),
            const SizedBox(height: 20),

            const Text(
              'Next Follow-up Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _followUpDate = date);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                ),
                child: Text(
                  _followUpDate != null
                      ? '${_followUpDate!.day}/${_followUpDate!.month}/${_followUpDate!.year}'
                      : 'Select follow-up date',
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                ),
                child: const Text('Submit Diagnosis'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recommendedActionsController.dispose();
    super.dispose();
  }
}
