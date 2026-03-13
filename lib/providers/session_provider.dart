import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/firestore_service.dart';

class SessionProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CoachingSession> _sessions = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoaded = false;

  List<CoachingSession> get sessions => _sessions;
  List<CoachingSession> get upcomingSessions => _sessions.where((s) => !s.isCompleted).toList();
  List<CoachingSession> get completedSessions => _sessions.where((s) => s.isCompleted).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasLoaded => _hasLoaded;

  void fetchSessions() {
    if (_hasLoaded) return;
    
    _setLoading(true);
    _clearError();
    
    print('🔍 SessionProvider: Fetching sessions...');
    
    _firestoreService.getSessionsStream().listen(
      (sessions) {
        print('📊 SessionProvider: Received ${sessions.length} sessions');
        _sessions = sessions;
        _hasLoaded = true;
        _setLoading(false);
        _clearError();
        notifyListeners();
      },
      onError: (error) {
        print('❌ SessionProvider error: $error');
        _errorMessage = error.toString();
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  void refreshSessions() {
    _hasLoaded = false;
    fetchSessions();
  }

  Future<void> addSession(CoachingSession session) async {
    _setLoading(true);
    _clearError();
    try {
      print('➕ Adding session: ${session.enterpriseName}');
      await _firestoreService.addSession(session);
      print('✅ Session added successfully');
    } catch (e) {
      print('❌ Error adding session: $e');
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSession(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();
    try {
      await _firestoreService.updateSession(id, data);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteSession(String id) async {
    _setLoading(true);
    _clearError();
    try {
      await _firestoreService.deleteSession(id);
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
