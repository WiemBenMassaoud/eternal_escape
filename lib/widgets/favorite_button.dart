// widgets/favorite_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorite_service.dart';
import '../services/auth_service.dart';

class FavoriteButton extends StatefulWidget {
  final int logementId;
  final String type; // "logement" ou "activite"

  const FavoriteButton({
    Key? key,
    required this.logementId,
    required this.type,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  late FavoriteService _favoriteService;
  late String _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService();
    _currentUserEmail = AuthService().currentUser?.email ?? '';
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await _favoriteService.isFavorite(
      widget.logementId,
      _currentUserEmail,
      widget.type,
    );
    
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_currentUserEmail.isEmpty) {
      // Rediriger vers l'écran de connexion si l'utilisateur n'est pas connecté
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez vous connecter pour ajouter aux favoris'),
        ),
      );
      return;
    }

    if (_isFavorite) {
      await _favoriteService.removeFavorite(
        logementId: widget.logementId,
        utilisateurEmail: _currentUserEmail,
        type: widget.type,
      );
    } else {
      await _favoriteService.addFavorite(
        logementId: widget.logementId,
        type: widget.type,
        utilisateurEmail: _currentUserEmail,
      );
    }

    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.grey,
        size: 30,
      ),
      onPressed: _toggleFavorite,
    );
  }
}