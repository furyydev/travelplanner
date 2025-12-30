import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email;

  AuthProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await StorageService.getUserData();
    if (userData != null) {
      _isLoggedIn = true;
      _username = userData['username'];
      _email = userData['email'];
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    // Mock authentication - for MVP, accept any credentials
    // In production, this would validate against a backend
    if (username.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _username = username;
      _email = '$username@example.com';

      await StorageService.saveUserData({
        'username': _username,
        'email': _email,
      });

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _email = null;
    notifyListeners();
  }
}


