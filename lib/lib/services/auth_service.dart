import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  AuthService() {
    // Simuler un utilisateur connecté pour les tests
    _currentUser = User(
      email: 'demo@eternalescape.com',
      name: 'Utilisateur Demo',
    );
  }

  Future<void> login(String email, String password) async {
    // Simulation de connexion
    _currentUser = User(
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

class User {
  final String email;
  final String name;

  User({
    required this.email,
    required this.name,
  });
}