import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoanRepaymentForm extends StatefulWidget {
  const LoanRepaymentForm({super.key});

  @override
  State<LoanRepaymentForm> createState() => _LoanRepaymentFormState();
}

class _LoanRepaymentFormState extends State<LoanRepaymentForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Payment Entry Controllers
  final _paymentAmountController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _paymentDate;
  String? _paymentMethod;
  String? _otherPaymentMethod;
  
  // Loan Overview (example data)
  final double _totalLoan = 50000;
  final double _totalPaid = 15000;
  double _remainingBalance = 35000;
  final DateTime _nextDueDate = DateTime.now().add(const Duration(days: 15));
  
  final List<String> _paymentMethods = [
    'Cash', 'Bank Transfer', 'Mobile Money', 'Other'
  ];

  void _updateRemainingBalance() {
    double paymentAmount = double.tryParse(_paymentAmountController.text) ?? 0;
    setState(() {
      _remainingBalance = _totalLoan - (_totalPaid + paymentAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Repayment'),
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildLoanOverview(),
                const SizedBox(height: 16),
                _buildPaymentEntry(),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Record Payment'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoanOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Loan Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.secondaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Total Loan:', '\$ ${_totalLoan.toStringAsFixed(2)}'),
                  const SizedBox(height: 12),
                  _buildInfoRow('Total Paid:', '\$ ${_totalPaid.toStringAsFixed(2)}',
                    valueColor: AppTheme.successColor),
                  const SizedBox(height: 12),
                  _buildInfoRow('Remaining Balance:', '\$ ${_remainingBalance.toStringAsFixed(2)}',
                    valueColor: _remainingBalance > 0 ? AppTheme.warningColor : AppTheme.successColor),
                  const SizedBox(height: 12),
                  _buildInfoRow('Next Due Date:', 
                    '${_nextDueDate.day}/${_nextDueDate.month}/${_nextDueDate.year}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentEntry() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.payment, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Payment Entry',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => _paymentDate = date);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Payment Date',
                  prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                ),
                child: Text(
                  _paymentDate != null
                      ? '${_paymentDate!.day}/${_paymentDate!.month}/${_paymentDate!.year}'
                      : 'Select payment date',
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _paymentAmountController,
              decoration: const InputDecoration(
                labelText: 'Payment Amount',
                prefixIcon: Icon(Icons.attach_money, color: AppTheme.primaryColor),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateRemainingBalance(),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Payment amount is required';
                if (double.tryParse(value) == null) return 'Enter a valid amount';
                if (double.parse(value) <= 0) return 'Amount must be greater than 0';
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                prefixIcon: Icon(Icons.payment, color: AppTheme.primaryColor),
              ),
              items: _paymentMethods.map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) => setState(() => _paymentMethod = value),
              validator: (value) => value == null ? 'Payment method is required' : null,
            ),
            if (_paymentMethod == 'Other') ...[
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Specify Payment Method',
                  prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                ),
                onChanged: (value) => _otherPaymentMethod = value,
              ),
            ],
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Upload receipt'),
                    backgroundColor: AppTheme.secondaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Receipt'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes',
                prefixIcon: Icon(Icons.note, color: AppTheme.primaryColor),
                hintText: 'Add any additional notes...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Balance After Payment:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '\$ ${_remainingBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _remainingBalance > 0 ? AppTheme.warningColor : AppTheme.successColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      double paymentAmount = double.parse(_paymentAmountController.text);
      
      if (paymentAmount > _remainingBalance + _totalPaid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment amount cannot exceed remaining balance'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Payment recorded successfully!'),
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
    _paymentAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}