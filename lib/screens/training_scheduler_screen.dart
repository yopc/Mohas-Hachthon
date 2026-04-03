// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/training.dart';
// import '../providers/training_provider.dart';
// import '../theme/app_theme2.dart';

// class TrainingSchedulerScreen extends StatefulWidget {
//   const TrainingSchedulerScreen({super.key});

//   @override
//   State<TrainingSchedulerScreen> createState() => _TrainingSchedulerScreenState();
// }

// class _TrainingSchedulerScreenState extends State<TrainingSchedulerScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _moduleController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _maxSeatsController = TextEditingController();
//   DateTime? _selectedDate;
//   bool _isLoading = false;

//   Future<void> _selectDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 7)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (date != null) setState(() => _selectedDate = date);
//   }

//   Future<void> _createTraining() async {
//     if (_formKey.currentState!.validate() && _selectedDate != null) {
//       setState(() => _isLoading = true);
//       final provider = Provider.of<TrainingProvider>(context, listen: false);
//       final training = Training(
//         id: '',
//         title: _titleController.text.trim(),
//         module: _moduleController.text.trim(),
//         date: _selectedDate!,
//         location: _locationController.text.trim(),
//         trainerId: '', // TODO: get from auth
//         maxSeats: int.tryParse(_maxSeatsController.text) ?? 0,
//         createdAt: DateTime.now(),
//       );
//       try {
//         await provider.createTraining(training);
//         if (mounted) Navigator.pop(context, true);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.errorColor),
//         );
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Schedule Training')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(labelText: 'Title'),
//                 validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _moduleController,
//                 decoration: const InputDecoration(labelText: 'Module'),
//                 validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 16),
//               InkWell(
//                 onTap: _selectDate,
//                 child: InputDecorator(
//                   decoration: const InputDecoration(labelText: 'Date'),
//                   child: Text(_selectedDate != null ? _formatDate(_selectedDate!) : 'Select date'),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: const InputDecoration(labelText: 'Location'),
//                 validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _maxSeatsController,
//                 decoration: const InputDecoration(labelText: 'Max Seats'),
//                 keyboardType: TextInputType.number,
//                 validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _createTraining,
//                 child: _isLoading ? const CircularProgressIndicator() : const Text('Schedule'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/training.dart';
import '../providers/training_provider.dart';
import '../theme/app_theme2.dart';
import '../widgets/location_picker.dart';

class TrainingSchedulerScreen extends StatefulWidget {
  const TrainingSchedulerScreen({super.key});

  @override
  State<TrainingSchedulerScreen> createState() => _TrainingSchedulerScreenState();
}

class _TrainingSchedulerScreenState extends State<TrainingSchedulerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _moduleController = TextEditingController();
  final _maxSeatsController = TextEditingController();
  DateTime? _selectedDate;
  GeoPoint? _selectedCoordinates;
  String? _selectedAddress;
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          onLocationSelected: (coordinates, address) {
            setState(() {
              _selectedCoordinates = GeoPoint(coordinates.latitude, coordinates.longitude);
              _selectedAddress = address;
            });
          },
        ),
      ),
    );
  }

  Future<void> _createTraining() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedCoordinates != null) {
      setState(() => _isLoading = true);
      final provider = Provider.of<TrainingProvider>(context, listen: false);
      final training = Training(
        id: '',
        title: _titleController.text.trim(),
        module: _moduleController.text.trim(),
        date: _selectedDate!,
        locationCoordinates: _selectedCoordinates!,
        locationAddress: _selectedAddress!,
        trainerId: '', // TODO: get from auth
        maxSeats: int.tryParse(_maxSeatsController.text) ?? 0,
        createdAt: DateTime.now(),
      );
      try {
        await provider.createTraining(training);
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.errorColor),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a location'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Training')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _moduleController,
                decoration: const InputDecoration(labelText: 'Module'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date'),
                  child: Text(_selectedDate != null ? _formatDate(_selectedDate!) : 'Select date'),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxSeatsController,
                decoration: const InputDecoration(labelText: 'Max Seats'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Select Training Location'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (_selectedAddress != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.successColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedAddress!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createTraining,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}