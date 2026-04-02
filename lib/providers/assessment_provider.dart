import 'package:flutter/material.dart';
import '../models/assessment.dart';
import '../services/firestore_service.dart';

class AssessmentProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();

  List<Assessment> _assessments = [];
  bool _isLoading = false;
  String? _error;
  bool _hasLoaded = false;

  List<Assessment> get assessments => _assessments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLoaded => _hasLoaded;

  void fetchAssessments() {
    if (_hasLoaded) return;
    _setLoading(true);
    _clearError();
    _firestore.getAssessmentsStream().listen(
      (assessments) {
        _assessments = assessments;
        _hasLoaded = true;
        _setLoading(false);
        _clearError();
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  void refreshAssessments() {
    _hasLoaded = false;
    fetchAssessments();
  }

  Future<void> addAssessment(Assessment assessment) async {
    _setLoading(true);
    _clearError();
    try {
      await _firestore.addAssessment(assessment);
      // Stream will update automatically
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateAssessment(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();
    try {
      await _firestore.updateAssessment(id, data);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAssessment(String id) async {
    _setLoading(true);
    _clearError();
    try {
      await _firestore.deleteAssessment(id);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<Assessment?> getBaselineForEnterprise(String enterpriseId) async {
    return await _firestore.getBaselineForEnterprise(enterpriseId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}