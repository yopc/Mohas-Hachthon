import 'package:flutter/material.dart' hide Feedback; // Hide Flutter's Feedback widget
import '../models/training.dart';
import '../models/feedback.dart'; // Now this refers to your model
import '../services/firestore_service.dart';

class TrainingProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  List<Training> _trainings = [];
  bool _isLoading = false;

  List<Training> get trainings => _trainings;
  bool get isLoading => _isLoading;

  void fetchTrainings() {
    _setLoading(true);
    _firestore.getTrainingsStream().listen((list) {
      _trainings = list;
      _setLoading(false);
    }, onError: (e) {
      _setLoading(false);
    });
  }

  Future<void> createTraining(Training training) async {
    await _firestore.addTraining(training);
    fetchTrainings();
  }

  Future<void> markAttendance(String trainingId, String enterpriseId, String attendeeName, bool qrScanned) async {
    await _firestore.markAttendance(trainingId, enterpriseId, attendeeName, qrScanned);
  }

  Future<void> submitFeedback(Feedback feedback) async {
    await _firestore.addFeedback(feedback);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}