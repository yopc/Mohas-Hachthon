import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/coach_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  Coach? _coach;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  Coach? get coach => _coach;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        final userData = await _firestoreService.getUserData(user.uid);
        if (userData != null) {
          _coach = Coach.fromMap(userData, id: user.uid);
        }
      } else {
        _coach = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      UserCredential? credential = await _authService.signInWithEmail(email, password);
      if (credential != null) {
        _user = credential.user;
        final userData = await _firestoreService.getUserData(_user!.uid);
        if (userData != null) {
          _coach = Coach.fromMap(userData, id: _user!.uid);
        }
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFriendlyErrorMessage(e);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUpWithEmail(String email, String password, Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();
    try {
      UserCredential? credential = await _authService.signUpWithEmail(email, password);
      if (credential != null) {
        String uid = credential.user!.uid;
        userData['uid'] = uid;
        userData['email'] = email;
        userData['role'] = 'coach';
        userData['createdAt'] = DateTime.now().toIso8601String();
        userData['accountStatus'] = 'active';
        userData['isFirstLogin'] = true;
        await _firestoreService.createUserData(uid, userData);
        _user = credential.user;
        _coach = Coach.fromMap(userData, id: uid);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFriendlyErrorMessage(e);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateCoachProfile(Map<String, dynamic> updates) async {
    if (_user == null) return;
    _setLoading(true);
    _clearError();
    try {
      await _firestoreService.updateUserData(_user!.uid, updates);
      final updatedData = await _firestoreService.getUserData(_user!.uid);
      if (updatedData != null) {
        _coach = Coach.fromMap(updatedData, id: _user!.uid);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
      _coach = null;
    } catch (e) {
      _errorMessage = 'Error signing out';
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

  String _getFriendlyErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Email is not valid';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
