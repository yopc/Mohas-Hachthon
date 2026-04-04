import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/iap.dart';
import '../providers/iap_provider.dart';
import '../theme/app_theme2.dart';

class IapEditorScreen extends StatefulWidget {
  final String enterpriseId;
  const IapEditorScreen({super.key, required this.enterpriseId});

  @override
  State<IapEditorScreen> createState() => _IapEditorScreenState();
}

class _IapEditorScreenState extends State<IapEditorScreen> {
  final List<IapTask> _tasks = [];
  final _descriptionController = TextEditingController();
  String _selectedOwner = 'coach';
  DateTime? _dueDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('🟢 IapEditorScreen opened for enterprise ${widget.enterpriseId}');
    _loadIap();
  }

  Future<void> _loadIap() async {
    final provider = Provider.of<IapProvider>(context, listen: false);
    await provider.fetchIap(widget.enterpriseId);
    if (provider.iap != null) {
      setState(() {
        _tasks.clear();
        _tasks.addAll(provider.iap!.tasks);
      });
    }
  }

  void _addTask() {
    if (_descriptionController.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(IapTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descriptionController.text.trim(),
        owner: _selectedOwner,
        dueDate: _dueDate,
        status: 'not_started',
      ));
      _descriptionController.clear();
      _dueDate = null;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _saveIap() async {
    print('🔵 _saveIap STARTED');
    if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one task'), backgroundColor: AppTheme.errorColor),
      );
      return;
    }
    setState(() => _isLoading = true);
    final provider = Provider.of<IapProvider>(context, listen: false);
    final iap = Iap(
      id: provider.iap?.id ?? '',
      enterpriseId: widget.enterpriseId,
      tasks: _tasks,
      coachSigned: provider.iap?.coachSigned ?? false,
      enterpriseSigned: provider.iap?.enterpriseSigned ?? false,
      updatedAt: DateTime.now(),
    );
    print('📦 IAP object: ${iap.enterpriseId}, tasks: ${_tasks.length}');
    try {
      await provider.saveIap(iap);
      print('✅ IAP saved, popping...');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      print('❌ ERROR in _saveIap: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.errorColor),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  @override
  Widget build(BuildContext context) {
    print('🔨 Building IapEditorScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Individual Action Plan'),
        actions: [
          TextButton(
            onPressed: _saveIap,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Task Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedOwner,
                      decoration: const InputDecoration(labelText: 'Responsible'),
                      items: const [
                        DropdownMenuItem(value: 'coach', child: Text('Coach')),
                        DropdownMenuItem(value: 'enterprise', child: Text('Enterprise')),
                      ],
                      onChanged: (v) => setState(() => _selectedOwner = v!),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _selectDueDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Due Date'),
                        child: Text(_dueDate != null ? _formatDate(_dueDate!) : 'Select date'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _addTask,
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task.description),
                    subtitle: Text('Owner: ${task.owner} | Due: ${task.dueDate != null ? _formatDate(task.dueDate!) : 'No deadline'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                      onPressed: () => _removeTask(index),
                    ),
                  ),
                );
              },
            ),
          ),
          // ✅ ADD A VISIBLE SAVE BUTTON AT THE BOTTOM
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveIap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('SAVE IAP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}