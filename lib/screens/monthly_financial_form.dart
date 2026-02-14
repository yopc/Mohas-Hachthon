import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MonthlyFinancialForm extends StatefulWidget {
  const MonthlyFinancialForm({super.key});

  @override
  State<MonthlyFinancialForm> createState() => _MonthlyFinancialFormState();
}

class _MonthlyFinancialFormState extends State<MonthlyFinancialForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Sales Controllers
  final _revenueController = TextEditingController();
  final _creditOutstandingController = TextEditingController();
  
  // Expenses Controllers
  final _rentController = TextEditingController();
  final _salaryController = TextEditingController();
  final _utilitiesController = TextEditingController();
  final _inventoryController = TextEditingController();
  final _transportController = TextEditingController();
  final _marketingController = TextEditingController();
  final _taxController = TextEditingController();
  final _loanRepaymentController = TextEditingController();
  final _otherExpenseController = TextEditingController();
  final _otherExpenseDescController = TextEditingController();
  
  // Investment Controllers
  final _equipmentController = TextEditingController();
  final _expansionController = TextEditingController();
  final _renovationController = TextEditingController();
  final _otherInvestmentController = TextEditingController();
  final _otherInvestmentDescController = TextEditingController();

  DateTime? _selectedMonth;
  String? _salesType;
  String? _otherExpenseDesc;
  String? _otherInvestmentDesc;

  final List<String> _salesTypes = ['Cash', 'Credit', 'Mixed'];

  double _totalExpenses = 0;
  double _profit = 0;
  double _profitGrowth = 0;
  double _lastMonthProfit = 5000; // Example previous month profit

  void _calculateTotals() {
    double rent = double.tryParse(_rentController.text) ?? 0;
    double salary = double.tryParse(_salaryController.text) ?? 0;
    double utilities = double.tryParse(_utilitiesController.text) ?? 0;
    double inventory = double.tryParse(_inventoryController.text) ?? 0;
    double transport = double.tryParse(_transportController.text) ?? 0;
    double marketing = double.tryParse(_marketingController.text) ?? 0;
    double tax = double.tryParse(_taxController.text) ?? 0;
    double loanRepayment = double.tryParse(_loanRepaymentController.text) ?? 0;
    double otherExpense = double.tryParse(_otherExpenseController.text) ?? 0;

    setState(() {
      _totalExpenses = rent + salary + utilities + inventory + 
                      transport + marketing + tax + loanRepayment + otherExpense;
      
      double revenue = double.tryParse(_revenueController.text) ?? 0;
      _profit = revenue - _totalExpenses;
      
      if (_lastMonthProfit > 0) {
        _profitGrowth = ((_profit - _lastMonthProfit) / _lastMonthProfit) * 100;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Financial Data'),
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSalesSection(),
                const SizedBox(height: 16),
                _buildExpensesSection(),
                const SizedBox(height: 16),
                _buildInvestmentSection(),
                const SizedBox(height: 16),
                _buildSummarySection(),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Submit Financial Data'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Sales Information',
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
                if (date != null) setState(() => _selectedMonth = date);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Month',
                  prefixIcon: Icon(Icons.calendar_month, color: AppTheme.primaryColor),
                ),
                child: Text(
                  _selectedMonth != null
                      ? '${_selectedMonth!.month}/${_selectedMonth!.year}'
                      : 'Select month',
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _revenueController,
              decoration: const InputDecoration(
                labelText: 'Total Revenue',
                prefixIcon: Icon(Icons.attach_money, color: AppTheme.primaryColor),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _calculateTotals(),
              validator: (value) => value == null || value.isEmpty ? 'Revenue is required' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _salesType,
              decoration: const InputDecoration(
                labelText: 'Sales Type',
                prefixIcon: Icon(Icons.shopping_cart, color: AppTheme.primaryColor),
              ),
              items: _salesTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _salesType = value),
              validator: (value) => value == null ? 'Sales type is required' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _creditOutstandingController,
              decoration: const InputDecoration(
                labelText: 'Credit Outstanding',
                prefixIcon: Icon(Icons.credit_card, color: AppTheme.primaryColor),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_down, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Expenses (Detailed)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildExpenseRow('Rent', _rentController, Icons.home),
            _buildExpenseRow('Salary', _salaryController, Icons.people),
            _buildExpenseRow('Utilities', _utilitiesController, Icons.bolt),
            _buildExpenseRow('Inventory Purchase', _inventoryController, Icons.inventory),
            _buildExpenseRow('Transport', _transportController, Icons.local_shipping),
            _buildExpenseRow('Marketing', _marketingController, Icons.campaign),
            _buildExpenseRow('Tax', _taxController, Icons.receipt),
            _buildExpenseRow('Loan Repayment', _loanRepaymentController, Icons.account_balance),
            
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _otherExpenseDescController,
                    decoration: const InputDecoration(
                      labelText: 'Other Expense Description',
                      prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _otherExpenseController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.attach_money, color: AppTheme.primaryColor),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateTotals(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseRow(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          prefixText: '\$ ',
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) => _calculateTotals(),
      ),
    );
  }

  Widget _buildInvestmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Investment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildInvestmentRow('Equipment Purchase', _equipmentController, Icons.build),
            _buildInvestmentRow('Expansion', _expansionController, Icons.area_chart),
            _buildInvestmentRow('Renovation', _renovationController, Icons.construction),
            
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _otherInvestmentDescController,
                    decoration: const InputDecoration(
                      labelText: 'Other Investment Description',
                      prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _otherInvestmentController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.attach_money, color: AppTheme.primaryColor),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentRow(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          prefixText: '\$ ',
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildSummarySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Total Expenses:', _totalExpenses),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Profit:', _profit, isProfit: true),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Profit Growth:', _profitGrowth, isPercentage: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isProfit = false, bool isPercentage = false}) {
    Color valueColor = isProfit 
        ? (value >= 0 ? AppTheme.successColor : AppTheme.errorColor)
        : AppTheme.textPrimary;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          isPercentage 
              ? '${value.toStringAsFixed(1)}%'
              : '\$ ${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              const Text('Financial data submitted successfully!'),
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
    _revenueController.dispose();
    _creditOutstandingController.dispose();
    _rentController.dispose();
    _salaryController.dispose();
    _utilitiesController.dispose();
    _inventoryController.dispose();
    _transportController.dispose();
    _marketingController.dispose();
    _taxController.dispose();
    _loanRepaymentController.dispose();
    _otherExpenseController.dispose();
    _otherExpenseDescController.dispose();
    _equipmentController.dispose();
    _expansionController.dispose();
    _renovationController.dispose();
    _otherInvestmentController.dispose();
    _otherInvestmentDescController.dispose();
    super.dispose();
  }
}