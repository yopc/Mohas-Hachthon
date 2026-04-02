import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/training_provider.dart';

class AttendanceCaptureScreen extends StatefulWidget {
  final String trainingId;
  const AttendanceCaptureScreen({super.key, required this.trainingId});

  @override
  State<AttendanceCaptureScreen> createState() => _AttendanceCaptureScreenState();
}

class _AttendanceCaptureScreenState extends State<AttendanceCaptureScreen> {
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      // code format: enterpriseId:attendeeName
      final parts = code.split(':');
      if (parts.length == 2) {
        final enterpriseId = parts[0];
        final attendeeName = parts[1];
        _markAttendance(enterpriseId, attendeeName);
      }
    }
  }

  Future<void> _markAttendance(String enterpriseId, String attendeeName) async {
    setState(() => _isProcessing = true);
    try {
      final provider = Provider.of<TrainingProvider>(context, listen: false);
      await provider.markAttendance(widget.trainingId, enterpriseId, attendeeName, true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance recorded successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              onDetect: _onDetect,
            ),
          ),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Position the QR code in the frame',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
