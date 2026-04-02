import 'package:flutter/material.dart';
import '../models/training.dart';
import 'attendance_capture_screen.dart';
import 'feedback_form_screen.dart';

class TrainingSessionScreen extends StatelessWidget {
  final Training training;
  const TrainingSessionScreen({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(training.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.category),
                      title: const Text('Module'),
                      subtitle: Text(training.module),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Date'),
                      subtitle: Text('${training.date.day}/${training.date.month}/${training.date.year}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Location'),
                      subtitle: Text(training.location),
                    ),
                    ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Max Seats'),
                      subtitle: Text('${training.maxSeats}'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceCaptureScreen(trainingId: training.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Mark Attendance'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackFormScreen(trainingId: training.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.feedback),
                    label: const Text('Give Feedback'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
