import 'package:flutter/material.dart';
import '../models/qc_check.dart';
import '../services/firestore_service.dart';

class QcProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  List<QcCheck> _pending = [];
  bool _isLoading = false;

  List<QcCheck> get pending => _pending;
  bool get isLoading => _isLoading;

  void fetchPending() {
    _setLoading(true);
    _firestore.getPendingQcStream().listen((list) {
      _pending = list;
      _setLoading(false);
    });
  }

  Future<void> verify(String id, String recordType, String recordId) async {
    await _firestore.verifyQc(id, recordType, recordId);
    fetchPending();
  }

  Future<void> requestCorrection(String id, String notes) async {
    await _firestore.requestCorrectionQc(id, notes);
    fetchPending();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
