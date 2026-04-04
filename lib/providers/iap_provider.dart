import 'package:flutter/material.dart';
import '../models/iap.dart';
import '../services/firestore_service.dart';

class IapProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  Iap? _iap;
  bool _isLoading = false;
  String? _error;

  Iap? get iap => _iap;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchIap(String enterpriseId) async {
    _setLoading(true);
    try {
      _iap = await _firestore.getIap(enterpriseId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Future<void> saveIap(Iap iap) async {
  //   _setLoading(true);
  //   try {
  //     await _firestore.saveIap(iap);
  //     _iap = iap;
  //   } catch (e) {
  //     _error = e.toString();
  //     rethrow;
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  // providers/iap_provider.dart
// providers/iap_provider.dart
Future<void> saveIap(Iap iap) async {
  _setLoading(true);
  _error = null;
  try {
    await _firestore.saveIap(iap);
    // Re-fetch to ensure the provider has the latest data (including the correct ID)
    await fetchIap(iap.enterpriseId);
  } catch (e) {
    _error = e.toString();
    rethrow; // This will be caught in the editor screen and show a snackbar
  } finally {
    _setLoading(false);
  }
}

  Future<void> updateTaskStatus(String iapId, String taskId, String newStatus) async {
    _setLoading(true);
    try {
      await _firestore.updateIapTaskStatus(iapId, taskId, newStatus);
      if (_iap != null) {
        await fetchIap(_iap!.enterpriseId);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
