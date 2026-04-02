import 'package:flutter/material.dart';
import '../models/graduation_checklist.dart';
import '../services/firestore_service.dart';

class GraduationProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  GraduationChecklist? _checklist;
  bool _isLoading = false;

  GraduationChecklist? get checklist => _checklist;
  bool get isLoading => _isLoading;

  Future<void> fetchChecklist(String enterpriseId) async {
    _setLoading(true);
    _checklist = await _firestore.getGraduationChecklist(enterpriseId);
    _setLoading(false);
  }

  Future<void> requestGraduation(String enterpriseId) async {
    bool allMet = (_checklist?.baselinePresent ?? false) &&
        (_checklist?.minCoachingVisits ?? false) &&
        (_checklist?.midlineBetter ?? false) &&
        (_checklist?.coachSignOff ?? false) &&
        (_checklist?.evidencePack ?? false);
    if (!allMet) {
      throw Exception('Not all requirements met');
    }
    await _firestore.requestGraduationApproval(enterpriseId);
    await fetchChecklist(enterpriseId);
  }

  Future<void> approveGraduation(String enterpriseId) async {
    await _firestore.approveGraduation(enterpriseId);
    await fetchChecklist(enterpriseId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
