import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EnterpriseRegistrationForm extends StatefulWidget {
  const EnterpriseRegistrationForm({super.key});

  @override
  State<EnterpriseRegistrationForm> createState() => _EnterpriseRegistrationFormState();
}

class _EnterpriseRegistrationFormState extends State<EnterpriseRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Page 1 Controllers
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _gpsController = TextEditingController();
  
  // Page 2 Controllers
  final _employeesController = TextEditingController();
  final _femaleEmployeesController = TextEditingController();
  
  // Page 3 Controllers
  final _monthlySalesController = TextEditingController();
  final _monthlyExpensesController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _repaymentPeriodController = TextEditingController();
  
  // New Loan Date Controllers
  DateTime? _loanStartDate;
  DateTime? _firstPaymentDate;
  DateTime? _nextPaymentDate;

  // Dropdown Values
  String? _selectedGender;
  String? _selectedSector;
  String? _selectedBusinessType;
  String? _selectedAccountingMethod;
  String? _selectedLoanSource;
  String? _selectedPaymentFrequency;
  
  DateTime? _businessStartDate;
  bool _hasLicense = false;
  bool _hasBankAccount = false;
  bool _hasExistingLoan = false;
  
  final List<String> _genders = ['Male', 'Female'];
  final List<String> _sectors = [
    'Retail', 'Manufacturing', 'Agriculture', 'Service', 
    'Technology', 'Food & Beverage', 'Construction', 
    'Transport', 'Textile', 'Other'
  ];
  final List<String> _businessTypes = [
    'Sole Proprietorship', 'Partnership', 'Cooperative', 'PLC', 'Other'
  ];
  final List<String> _accountingMethods = ['Manual', 'Excel', 'Software', 'None'];
  final List<String> _loanSources = [
    'Bank', 'Microfinance', 'SACCO', 'Informal lender', 'Other'
  ];
  final List<String> _paymentFrequencies = ['Monthly', 'Weekly', 'Quarterly'];

  double _estimatedProfit = 0;

  void _calculateProfit() {
    double sales = double.tryParse(_monthlySalesController.text) ?? 0;
    double expenses = double.tryParse(_monthlyExpensesController.text) ?? 0;
    setState(() {
      _estimatedProfit = sales - expenses;
    });
  }

  void _calculateNextPaymentDate() {
    if (_firstPaymentDate != null && _selectedPaymentFrequency != null) {
      DateTime nextDate = DateTime(
        _firstPaymentDate!.year,
        _firstPaymentDate!.month,
        _firstPaymentDate!.day,
      );
      
      switch (_selectedPaymentFrequency) {
        case 'Weekly':
          nextDate = nextDate.add(const Duration(days: 7));
          break;
        case 'Monthly':
          nextDate = DateTime(
            nextDate.year,
            nextDate.month + 1,
            nextDate.day,
          );
          break;
        case 'Quarterly':
          nextDate = DateTime(
            nextDate.year,
            nextDate.month + 3,
            nextDate.day,
          );
          break;
      }
      
      setState(() {
        _nextPaymentDate = nextDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Enterprise'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ...List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index <= _currentPage 
                                  ? AppTheme.primaryColor 
                                  : Colors.grey.shade300,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: index <= _currentPage ? Colors.white : AppTheme.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            index == 0 ? 'Business' : index == 1 ? 'Structure' : 'Financial',
                            style: TextStyle(
                              fontSize: 12,
                              color: index <= _currentPage ? AppTheme.primaryColor : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  children: [
                    _buildBusinessInfoPage(),
                    _buildBusinessStructurePage(),
                    _buildFinancialInfoPage(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: const BorderSide(color: AppTheme.primaryColor),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Previous'),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < 2) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _submitForm();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentPage == 2 ? AppTheme.successColor : AppTheme.primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(_currentPage == 2 ? 'Submit' : 'Next'),
                      ),
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

  Widget _buildBusinessInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Business Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _businessNameController,
                decoration: const InputDecoration(
                  labelText: 'Business Name',
                  prefixIcon: Icon(Icons.business, color: AppTheme.primaryColor),
                  hintText: 'Enter business name',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Business name is required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Owner Name',
                  prefixIcon: Icon(Icons.person, color: AppTheme.primaryColor),
                  hintText: 'Enter owner name',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Owner name is required' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.transgender, color: AppTheme.primaryColor),
                ),
                items: _genders.map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
                validator: (value) => value == null ? 'Gender is required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone, color: AppTheme.primaryColor),
                  hintText: 'Enter phone number',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: AppTheme.primaryColor),
                  hintText: 'Enter email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedSector,
                decoration: const InputDecoration(
                  labelText: 'Sector',
                  prefixIcon: Icon(Icons.category, color: AppTheme.primaryColor),
                ),
                items: _sectors.map((sector) {
                  return DropdownMenuItem(value: sector, child: Text(sector));
                }).toList(),
                onChanged: (value) => setState(() => _selectedSector = value),
                validator: (value) => value == null ? 'Sector is required' : null,
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 365)),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _businessStartDate = date);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Business Start Date',
                    prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                  ),
                  child: Text(
                    _businessStartDate != null
                        ? '${_businessStartDate!.day}/${_businessStartDate!.month}/${_businessStartDate!.year}'
                        : 'Select date',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on, color: AppTheme.primaryColor),
                  hintText: 'Enter location',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Location is required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _gpsController,
                decoration: const InputDecoration(
                  labelText: 'GPS Coordinates (Optional)',
                  prefixIcon: Icon(Icons.gps_fixed, color: AppTheme.primaryColor),
                  hintText: 'Enter GPS coordinates',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessStructurePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Business Structure',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _employeesController,
                decoration: const InputDecoration(
                  labelText: 'Number of Employees',
                  prefixIcon: Icon(Icons.people, color: AppTheme.primaryColor),
                  hintText: 'Enter number of employees',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Number of employees is required';
                  if (int.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _femaleEmployeesController,
                decoration: const InputDecoration(
                  labelText: 'Female Employees',
                  prefixIcon: Icon(Icons.female, color: AppTheme.primaryColor),
                  hintText: 'Enter number of female employees',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Number of female employees is required';
                  if (int.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedBusinessType,
                decoration: const InputDecoration(
                  labelText: 'Business Type',
                  prefixIcon: Icon(Icons.business_center, color: AppTheme.primaryColor),
                ),
                items: _businessTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _selectedBusinessType = value),
                validator: (value) => value == null ? 'Business type is required' : null,
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  title: const Text('Has Business License?'),
                  value: _hasLicense,
                  onChanged: (value) => setState(() => _hasLicense = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  title: const Text('Has Bank Account?'),
                  value: _hasBankAccount,
                  onChanged: (value) => setState(() => _hasBankAccount = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedAccountingMethod,
                decoration: const InputDecoration(
                  labelText: 'Accounting Method',
                  prefixIcon: Icon(Icons.calculate, color: AppTheme.primaryColor),
                ),
                items: _accountingMethods.map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) => setState(() => _selectedAccountingMethod = value),
                validator: (value) => value == null ? 'Accounting method is required' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Baseline Financial Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _monthlySalesController,
                    decoration: const InputDecoration(
                      labelText: 'Current Monthly Sales',
                      prefixIcon: Icon(Icons.trending_up, color: AppTheme.primaryColor),
                      hintText: 'Enter monthly sales',
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateProfit(),
                    validator: (value) => value == null || value.isEmpty ? 'Monthly sales is required' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _monthlyExpensesController,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Expenses',
                      prefixIcon: Icon(Icons.trending_down, color: AppTheme.primaryColor),
                      hintText: 'Enter monthly expenses',
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateProfit(),
                    validator: (value) => value == null || value.isEmpty ? 'Monthly expenses is required' : null,
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estimated Profit:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '\$ ${_estimatedProfit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _estimatedProfit >= 0 ? AppTheme.successColor : AppTheme.errorColor,
                          ),
                        ),
                      ],
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
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      title: const Text('Has Existing Loan?'),
                      value: _hasExistingLoan,
                      onChanged: (value) => setState(() => _hasExistingLoan = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  if (_hasExistingLoan) ...[
                    const SizedBox(height: 20),
                    
                    // Loan Amount
                    TextFormField(
                      controller: _loanAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Loan Amount',
                        prefixIcon: Icon(Icons.money, color: AppTheme.primaryColor),
                        prefixText: '\$ ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (_hasExistingLoan && (value == null || value.isEmpty)) {
                          return 'Loan amount is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Loan Source
                    DropdownButtonFormField<String>(
                      value: _selectedLoanSource,
                      decoration: const InputDecoration(
                        labelText: 'Loan Source',
                        prefixIcon: Icon(Icons.account_balance, color: AppTheme.primaryColor),
                      ),
                      items: _loanSources.map((source) {
                        return DropdownMenuItem(value: source, child: Text(source));
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedLoanSource = value),
                    ),
                    const SizedBox(height: 16),

                    // Interest Rate
                    TextFormField(
                      controller: _interestRateController,
                      decoration: const InputDecoration(
                        labelText: 'Interest Rate',
                        prefixIcon: Icon(Icons.percent, color: AppTheme.primaryColor),
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Loan Start Date
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _loanStartDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Loan Start Date',
                          prefixIcon: Icon(Icons.event, color: AppTheme.primaryColor),
                        ),
                        child: Text(
                          _loanStartDate != null
                              ? '${_loanStartDate!.day}/${_loanStartDate!.month}/${_loanStartDate!.year}'
                              : 'Select loan start date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // First Payment Date
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setState(() {
                            _firstPaymentDate = date;
                          });
                          _calculateNextPaymentDate();
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'First Payment Date',
                          prefixIcon: Icon(Icons.calendar_month, color: AppTheme.primaryColor),
                        ),
                        child: Text(
                          _firstPaymentDate != null
                              ? '${_firstPaymentDate!.day}/${_firstPaymentDate!.month}/${_firstPaymentDate!.year}'
                              : 'Select first payment date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Repayment Period
                    TextFormField(
                      controller: _repaymentPeriodController,
                      decoration: const InputDecoration(
                        labelText: 'Repayment Period',
                        prefixIcon: Icon(Icons.timer, color: AppTheme.primaryColor),
                        hintText: 'e.g., 12 months',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Frequency
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentFrequency,
                      decoration: const InputDecoration(
                        labelText: 'Payment Frequency',
                        prefixIcon: Icon(Icons.calendar_month, color: AppTheme.primaryColor),
                      ),
                      items: _paymentFrequencies.map((freq) {
                        return DropdownMenuItem(value: freq, child: Text(freq));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentFrequency = value;
                        });
                        _calculateNextPaymentDate();
                      },
                    ),
                    
                    if (_nextPaymentDate != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications_active, color: AppTheme.warningColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Next Payment Due:',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${_nextPaymentDate!.day}/${_nextPaymentDate!.month}/${_nextPaymentDate!.year}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.warningColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Here you would save all the loan data including dates
      // The system can now track when payments are due using _firstPaymentDate and _selectedPaymentFrequency
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Enterprise registered successfully!'),
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
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _gpsController.dispose();
    _employeesController.dispose();
    _femaleEmployeesController.dispose();
    _monthlySalesController.dispose();
    _monthlyExpensesController.dispose();
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _repaymentPeriodController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}