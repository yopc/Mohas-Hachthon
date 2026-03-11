import 'package:flutter/material.dart';
import '../theme/app_theme2.dart';

class CoachingSessionForm extends StatefulWidget {
  const CoachingSessionForm({super.key});

  @override
  State<CoachingSessionForm> createState() => _CoachingSessionFormState();
}

class _CoachingSessionFormState extends State<CoachingSessionForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _enterpriseNameController = TextEditingController(text: 'Sample Enterprise Ltd.');
  final _issuesDiscussedController = TextEditingController();
  final _progressController = TextEditingController();
  final _actionItemsController = TextEditingController();
  final _deadlineController = TextEditingController();
  
  DateTime? _sessionDate;
  DateTime? _nextVisitDate;
  String? _visitType;
  String? _salesTrend;
  String? _loanStatus;
  
  final List<String> _visitTypes = ['Physical', 'Phone', 'Online'];
  final List<String> _salesTrends = ['Increase', 'Decrease', 'Same'];
  final List<String> _loanStatuses = ['On Track', 'Delayed', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaching Session'),
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Session Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _enterpriseNameController,
                          decoration: const InputDecoration(
                            labelText: 'Enterprise Name',
                            prefixIcon: Icon(Icons.business, color: AppTheme.primaryColor),
                          ),
                          readOnly: true,
                          enabled: false,
                        ),
                        const SizedBox(height: 16),

                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) setState(() => _sessionDate = date);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Session Date',
                              prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                            ),
                            child: Text(
                              _sessionDate != null
                                  ? '${_sessionDate!.day}/${_sessionDate!.month}/${_sessionDate!.year}'
                                  : 'Select session date',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _visitType,
                          decoration: const InputDecoration(
                            labelText: 'Visit Type',
                            prefixIcon: Icon(Icons.tour, color: AppTheme.primaryColor),
                          ),
                          items: _visitTypes.map((type) {
                            return DropdownMenuItem(value: type, child: Text(type));
                          }).toList(),
                          onChanged: (value) => setState(() => _visitType = value),
                          validator: (value) => value == null ? 'Visit type is required' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _issuesDiscussedController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Issues Discussed',
                            prefixIcon: Icon(Icons.chat, color: AppTheme.primaryColor),
                            hintText: 'Describe the issues discussed...',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Issues discussed is required' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _progressController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Progress Since Last Visit',
                            prefixIcon: Icon(Icons.trending_up, color: AppTheme.primaryColor),
                            hintText: 'Describe progress made...',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Progress description is required' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Business Indicators',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _salesTrend,
                          decoration: const InputDecoration(
                            labelText: 'Sales Trend',
                            prefixIcon: Icon(Icons.show_chart, color: AppTheme.primaryColor),
                          ),
                          items: _salesTrends.map((trend) {
                            return DropdownMenuItem(value: trend, child: Text(trend));
                          }).toList(),
                          onChanged: (value) => setState(() => _salesTrend = value),
                          validator: (value) => value == null ? 'Sales trend is required' : null,
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _loanStatus,
                          decoration: const InputDecoration(
                            labelText: 'Loan Status',
                            prefixIcon: Icon(Icons.account_balance, color: AppTheme.primaryColor),
                          ),
                          items: _loanStatuses.map((status) {
                            return DropdownMenuItem(value: status, child: Text(status));
                          }).toList(),
                          onChanged: (value) => setState(() => _loanStatus = value),
                          validator: (value) => value == null ? 'Loan status is required' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Action Plan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _actionItemsController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Action Items',
                            prefixIcon: Icon(Icons.checklist, color: AppTheme.primaryColor),
                            hintText: 'List action items...',
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Action items are required' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _deadlineController,
                          decoration: const InputDecoration(
                            labelText: 'Deadline',
                            prefixIcon: Icon(Icons.event, color: AppTheme.primaryColor),
                            hintText: 'e.g., 2 weeks, 1 month',
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Deadline is required' : null,
                        ),
                        const SizedBox(height: 16),

                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Upload evidence'),
                                backgroundColor: AppTheme.secondaryColor,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Upload Evidence'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Next Session',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),

                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) setState(() => _nextVisitDate = date);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Schedule Next Visit',
                              prefixIcon: Icon(Icons.calendar_month, color: AppTheme.primaryColor),
                            ),
                            child: Text(
                              _nextVisitDate != null
                                  ? '${_nextVisitDate!.day}/${_nextVisitDate!.month}/${_nextVisitDate!.year}'
                                  : 'Select next visit date',
                            ),
                          ),
                        ),
                      ],
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
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Save Session'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Coaching session saved successfully!'),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _enterpriseNameController.dispose();
    _issuesDiscussedController.dispose();
    _progressController.dispose();
    _actionItemsController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }
}