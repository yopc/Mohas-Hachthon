import 'package:flutter/material.dart';
import '../services/sync_service.dart';

class SyncProvider extends ChangeNotifier {
  final SyncService _syncService = SyncService();
  int _pendingCount = 0;
  bool _isSyncing = false;

  int get pendingCount => _pendingCount;
  bool get isSyncing => _isSyncing;

  SyncProvider() {
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    _pendingCount = await _syncService.pendingCount();
    notifyListeners();
  }

  Future<void> queueUpload(String collection, Map<String, dynamic> data) async {
    await _syncService.queueUpload(collection, data);
    await _loadPendingCount();
  }

  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();
    try {
      await _syncService.syncNow();
      await _loadPendingCount();
    } catch (e) {
      // handle error
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
