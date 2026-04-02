import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enterprise_provider.dart';
import 'enterprise_registration_form.dart';
import 'enterprise_profile_screen.dart';
import '../theme/app_theme2.dart';
import '../widgets/enterprise_card.dart';
import '../widgets/loading_overlay.dart';

class EnterprisesScreen extends StatefulWidget {
  const EnterprisesScreen({super.key});

  @override
  State<EnterprisesScreen> createState() => _EnterprisesScreenState();
}

class _EnterprisesScreenState extends State<EnterprisesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Graduated', 'Needs Attention'];

  @override
  Widget build(BuildContext context) {
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    List filteredEnterprises = enterpriseProvider.enterprises.where((e) {
      final matchesSearch = e.businessName.toLowerCase().contains(_searchQuery.toLowerCase()) || e.ownerName.toLowerCase().contains(_searchQuery.toLowerCase());
      if (_selectedFilter == 'All') return matchesSearch;
      if (_selectedFilter == 'Active') return matchesSearch && e.status == 'Active';
      if (_selectedFilter == 'Graduated') return matchesSearch && e.status == 'Graduated';
      if (_selectedFilter == 'Needs Attention') return matchesSearch && e.overallScore < 50;
      return matchesSearch;
    }).toList();

    return LoadingOverlay(
      isLoading: enterpriseProvider.isLoading,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
                    child: TextField(onChanged: (v) => setState(() => _searchQuery = v), decoration: const InputDecoration(hintText: 'Search enterprises...', prefixIcon: Icon(Icons.search), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) => setState(() => _selectedFilter = filter),
                            backgroundColor: Colors.grey.shade50,
                            selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                            checkmarkColor: AppTheme.primaryColor,
                            labelStyle: TextStyle(color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredEnterprises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text('No enterprises found', style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text('Try adjusting your search or filters', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredEnterprises.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnterpriseProfileScreen(enterpriseId: filteredEnterprises[index].id),
                              ),
                            );
                          },
                          child: EnterpriseCard(enterprise: filteredEnterprises[index], onTap: () {}),
                        ),
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterpriseRegistrationForm()));
            if (result == true && mounted) {}
          },
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
