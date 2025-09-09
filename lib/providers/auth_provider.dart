import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rewardly/services/auth_service.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  AuthStatus _status = AuthStatus.uninitialized;
  User? _user;

  AuthProvider(this._authService) {
    _authService.user.listen((user) {
      if (user == null) {
        _status = AuthStatus.unauthenticated;
      } else {
        _user = user;
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  AuthStatus get status => _status;
  User? get user => _user;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<User?> signIn(String email, String password) async {
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final user = await _authService.createUserWithEmailAndPassword(email, password);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
