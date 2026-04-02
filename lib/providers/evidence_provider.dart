import 'package:flutter/material.dart';
import '../models/evidence.dart';
import '../services/firestore_service.dart';

class EvidenceProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  List<Evidence> _evidences = [];
  bool _isLoading = false;
  String? _error;

  List<Evidence> get evidences => _evidences;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void fetchEvidence(String enterpriseId) {
    _setLoading(true);
    _firestore.getEvidenceStream(enterpriseId).listen((list) {
      _evidences = list;
      _setLoading(false);
    }, onError: (e) {
      _error = e.toString();
      _setLoading(false);
    });
  }

  Future<void> addEvidence(Evidence evidence) async {
    try {
      await _firestore.addEvidence(evidence);
      // The stream will update automatically
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
