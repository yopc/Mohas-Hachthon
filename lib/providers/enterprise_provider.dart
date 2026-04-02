// import 'package:flutter/material.dart';
// import '../models/enterprise.dart';
// import '../services/firestore_service.dart';

// class EnterpriseProvider extends ChangeNotifier {
//   final FirestoreService _firestoreService = FirestoreService();

//   List<Enterprise> _enterprises = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<Enterprise> get enterprises => _enterprises;
//   List<Enterprise> get activeEnterprises => _enterprises.where((e) => e.status == 'Active').toList();
//   List<Enterprise> get graduatedEnterprises => _enterprises.where((e) => e.status == 'Graduated').toList();
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   void fetchEnterprises() {
//     _setLoading(true);
//     _firestoreService.getEnterprisesStream().listen(
//       (enterprises) {
//         _enterprises = enterprises;
//         _setLoading(false);
//         _clearError();
//         notifyListeners();
//       },
//       onError: (error) {
//         _errorMessage = error.toString();
//         _setLoading(false);
//         notifyListeners();
//       },
//     );
//   }

//   Future<void> addEnterprise(Enterprise enterprise) async {
//     _setLoading(true);
//     try {
//       await _firestoreService.addEnterprise(enterprise);
//     } catch (e) {
//       _errorMessage = e.toString();
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> updateEnterprise(String id, Map<String, dynamic> data) async {
//     _setLoading(true);
//     try {
//       await _firestoreService.updateEnterprise(id, data);
//     } catch (e) {
//       _errorMessage = e.toString();
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> deleteEnterprise(String id) async {
//     _setLoading(true);
//     try {
//       await _firestoreService.deleteEnterprise(id);
//     } catch (e) {
//       _errorMessage = e.toString();
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void _clearError() {
//     _errorMessage = null;
//   }
// }



import 'package:flutter/material.dart';
import '../models/enterprise.dart';
import '../services/firestore_service.dart';

class EnterpriseProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Enterprise> _enterprises = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Enterprise> get enterprises => _enterprises;
  List<Enterprise> get activeEnterprises => _enterprises.where((e) => e.status == 'Active').toList();
  List<Enterprise> get graduatedEnterprises => _enterprises.where((e) => e.status == 'Graduated').toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void fetchEnterprises({String? role, String? coachId}) {
    _setLoading(true);
    _firestoreService.getEnterprisesStream(role: role, coachId: coachId).listen(
      (enterprises) {
        _enterprises = enterprises;
        _setLoading(false);
        _clearError();
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  Future<Enterprise?> getEnterpriseById(String id) async {
    try {
      return await _firestoreService.getEnterpriseById(id);
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  Future<void> addEnterprise(Enterprise enterprise) async {
    _setLoading(true);
    try {
      await _firestoreService.addEnterprise(enterprise);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateEnterprise(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _firestoreService.updateEnterprise(id, data);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteEnterprise(String id) async {
    _setLoading(true);
    try {
      await _firestoreService.deleteEnterprise(id);
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