// import 'package:flutter/material.dart' hide Feedback; // Hide Flutter's Feedback widget
// import '../models/training.dart';
// import '../models/feedback.dart'; // Now this refers to your model
// import '../services/firestore_service.dart';

// class TrainingProvider extends ChangeNotifier {
//   final FirestoreService _firestore = FirestoreService();
//   List<Training> _trainings = [];
//   bool _isLoading = false;

//   List<Training> get trainings => _trainings;
//   bool get isLoading => _isLoading;

//   void fetchTrainings() {
//     _setLoading(true);
//     _firestore.getTrainingsStream().listen((list) {
//       _trainings = list;
//       _setLoading(false);
//     }, onError: (e) {
//       _setLoading(false);
//     });
//   }

//   Future<void> createTraining(Training training) async {
//     await _firestore.addTraining(training);
//     fetchTrainings();
//   }

//   Future<void> markAttendance(String trainingId, String enterpriseId, String attendeeName, bool qrScanned) async {
//     await _firestore.markAttendance(trainingId, enterpriseId, attendeeName, qrScanned);
//   }

//   Future<void> submitFeedback(Feedback feedback) async {
//     await _firestore.addFeedback(feedback);
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart' hide Feedback;
import '../models/training.dart';
import '../models/feedback.dart';
import '../services/firestore_service.dart';

class TrainingProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  List<Training> _trainings = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Training>>? _subscription;

  List<Training> get trainings => _trainings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Starts or restarts the Firestore stream.
  /// Call this whenever you need to (re)load trainings.
  void fetchTrainings() {
    // Cancel any existing subscription to avoid duplicates
    _subscription?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = _firestore.getTrainingsStream().listen(
      (list) {
        _trainings = list;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        print('❌ Training stream error: $error');
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Manually refresh by restarting the stream (useful after errors)
  void refreshTrainings() {
    fetchTrainings();
  }

  Future<void> createTraining(Training training) async {
    try {
      await _firestore.addTraining(training);
      // The stream will automatically update, no need to call fetch again.
      // However, if the stream was in an error state, this might not trigger.
      // So we optionally restart the stream to ensure it picks up new data.
      // But be careful not to cause multiple subscriptions.
      // Instead, we rely on the stream; if it errored, the user can manually refresh.
    } catch (e) {
      print('❌ Failed to create training: $e');
      rethrow;
    }
  }

  Future<void> markAttendance(String trainingId, String enterpriseId, String attendeeName, bool qrScanned) async {
    await _firestore.markAttendance(trainingId, enterpriseId, attendeeName, qrScanned);
  }

  Future<void> submitFeedback(Feedback feedback) async {
    await _firestore.addFeedback(feedback);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}