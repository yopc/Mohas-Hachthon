import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/enterprise_provider.dart';
import '../models/enterprise.dart';
import '../theme/app_theme2.dart';
import '../widgets/loading_overlay.dart';

class EnterpriseRegistrationForm extends StatefulWidget {
  const EnterpriseRegistrationForm({super.key});

  @override
  State<EnterpriseRegistrationForm> createState() => _EnterpriseRegistrationFormState();
}

class _EnterpriseRegistrationFormState extends State<EnterpriseRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _sectorController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _sectorController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final enterpriseProvider = Provider.of<EnterpriseProvider>(context, listen: false);
        String coachId = authProvider.user?.uid ?? '';
        Enterprise enterprise = Enterprise(
          id: '',
          businessName: _businessNameController.text.trim(),
          ownerName: _ownerNameController.text.trim(),
          sector: _sectorController.text.trim(),
          location: _locationController.text.trim(),
          phone: _phoneController.text.trim(),
          status: 'Active',
          registrationDate: DateTime.now(),
          scores: {'finance': 0, 'marketing': 0, 'operations': 0, 'hr': 0, 'governance': 0},
          priorities: [],
          coachId: coachId,
        );
        await enterpriseProvider.addEnterprise(enterprise);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enterprise registered successfully!'), backgroundColor: AppTheme.successColor, behavior: SnackBarBehavior.floating),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.errorColor, behavior: SnackBarBehavior.floating),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Register Enterprise')),
        body: Container(
          color: AppTheme.backgroundColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enterprise Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      const SizedBox(height: 20),
                      TextFormField(controller: _businessNameController, decoration: const InputDecoration(labelText: 'Business Name', prefixIcon: Icon(Icons.business, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Business name is required' : null),
                      const SizedBox(height: 16),
                      TextFormField(controller: _ownerNameController, decoration: const InputDecoration(labelText: 'Owner Name', prefixIcon: Icon(Icons.person, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Owner name is required' : null),
                      const SizedBox(height: 16),
                      TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone, color: AppTheme.primaryColor)), keyboardType: TextInputType.phone, validator: (v) => v == null || v.isEmpty ? 'Phone is required' : null),
                      const SizedBox(height: 16),
                      TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email, color: AppTheme.primaryColor)), keyboardType: TextInputType.emailAddress, validator: (v) { if (v == null || v.isEmpty) return 'Email is required'; if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Enter a valid email'; return null; }),
                      const SizedBox(height: 16),
                      TextFormField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.location_on, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Location is required' : null),
                      const SizedBox(height: 16),
                      TextFormField(controller: _sectorController, decoration: const InputDecoration(labelText: 'Sector', prefixIcon: Icon(Icons.category, color: AppTheme.primaryColor)), validator: (v) => v == null || v.isEmpty ? 'Sector is required' : null),
                      const SizedBox(height: 24),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submitForm, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor, minimumSize: const Size(double.infinity, 50)), child: const Text('Register Enterprise'))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
