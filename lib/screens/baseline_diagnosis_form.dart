import 'package:flutter/material.dart';
import '../theme/app_theme2.dart';

class BaselineDiagnosisForm extends StatefulWidget {
  const BaselineDiagnosisForm({super.key});

  @override
  State<BaselineDiagnosisForm> createState() => _BaselineDiagnosisFormState();
}

class _BaselineDiagnosisFormState extends State<BaselineDiagnosisForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  DateTime? _followUpDate;

  // Finance checkboxes
  final Map<String, bool> _financeItems = {
    'Keeps bookkeeping': false,
    'Tracks daily expenses': false,
    'Uses bank account': false,
    'Has financial plan': false,
    'Uses digital payment': false,
  };
  String? _financeOther;

  // Marketing checkboxes
  final Map<String, bool> _marketingItems = {
    'Uses social media': false,
    'Has pricing strategy': false,
    'Keeps customer records': false,
    'Has branding': false,
    'Conducts promotion': false,
  };
  String? _marketingOther;

  // HR checkboxes
  final Map<String, bool> _hrItems = {
    'Written contracts': false,
    'Employee training': false,
    'Salary records': false,
    'Performance evaluation': false,
  };
  String? _hrOther;

  // Operations checkboxes
  final Map<String, bool> _operationsItems = {
    'Inventory tracking': false,
    'Quality control': false,
    'Supplier contracts': false,
    'Production planning': false,
  };
  String? _operationsOther;

  // Governance checkboxes
  final Map<String, bool> _governanceItems = {
    'Clear business structure': false,
    'Strategic planning': false,
    'Regular meetings': false,
    'Compliance with tax': false,
  };
  String? _governanceOther;

  // Priority Challenges
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

  double _calculateProgress() {
    int totalItems = _financeItems.length + _marketingItems.length + 
                     _hrItems.length + _operationsItems.length + 
                     _governanceItems.length;
    int completedItems = 0;
    
    _financeItems.values.forEach((v) { if (v) completedItems++; });
    _marketingItems.values.forEach((v) { if (v) completedItems++; });
    _hrItems.values.forEach((v) { if (v) completedItems++; });
    _operationsItems.values.forEach((v) { if (v) completedItems++; });
    _governanceItems.values.forEach((v) { if (v) completedItems++; });
    
    return completedItems / totalItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
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
              decoration: InputDecoration(
                labelText: 'Other (specify)',
                prefixIcon: const Icon(Icons.edit, color: AppTheme.primaryColor),
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

  void _submitForm() {
    if (_formKey.currentState!.validate() && _followUpDate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              const Text('Diagnosis submitted successfully!'),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  void dispose() {
    _recommendedActionsController.dispose();
    super.dispose();
  }
}