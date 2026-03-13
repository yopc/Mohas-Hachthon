import 'package:flutter/material.dart';
import '../models/assessment.dart';
import '../services/firestore_service.dart';

class AssessmentProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Assessment> _assessments = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoaded = false;

  List<Assessment> get assessments => _assessments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasLoaded => _hasLoaded;

  void fetchAssessments() {
    if (_hasLoaded) {
      return; // Already loaded
    }
    
    _setLoading(true);
    _clearError();
    
    print('🔍 AssessmentProvider: Fetching assessments...');
    
    _firestoreService.getAssessmentsStream().listen(
      (assessments) {
        print('📊 AssessmentProvider: Received ${assessments.length} assessments');
        _assessments = assessments;
        _hasLoaded = true;
        _setLoading(false);
        _clearError();
        notifyListeners();
      },
      onError: (error) {
        print('❌ AssessmentProvider error: $error');
        _errorMessage = error.toString();
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
      print('➕ Adding assessment: ${assessment.enterpriseName}');
      await _firestoreService.addAssessment(assessment);
      print('✅ Assessment added successfully');
    } catch (e) {
      print('❌ Error adding assessment: $e');
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateAssessment(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();
    try {
      await _firestoreService.updateAssessment(id, data);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAssessment(String id) async {
    _setLoading(true);
    _clearError();
    try {
      await _firestoreService.deleteAssessment(id);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
