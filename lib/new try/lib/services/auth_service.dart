import 'package:flutter/material.dart';

class AuthUser {
  final String email;
  final String name;

  AuthUser({
    required this.email,
    required this.name,
  });
}

class AuthService extends ChangeNotifier {
  AuthUser? _currentUser;

  AuthUser? get currentUser => _currentUser;

  AuthService() {
    _currentUser = AuthUser(
      email: 'demo@eternalescape.com',
      name: 'Amal BenAli',
    );
  }

  Future<void> login(String email, String password) async {
    _currentUser = AuthUser(
      email: email,
      name: email.split('@').first,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  bool get isLoggedIn => _currentUser != null;
}