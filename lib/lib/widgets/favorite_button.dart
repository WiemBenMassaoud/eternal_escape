import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorite_service.dart';
import '../services/auth_service.dart';

class FavoriteButton extends StatefulWidget {
  final int logementId;
  final String type; // "logement" ou "activite"
  final double? size;
  final Color? color;

  const FavoriteButton({
    Key? key,
    required this.logementId,
    required this.type,
    this.size = 30,
    this.color,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ✅ Re-vérifier si le logement a changé
    if (oldWidget.logementId != widget.logementId) {
      _checkIfFavorite();
    }
  }

  Future<void> _checkIfFavorite() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final favoriteService = Provider.of<FavoriteService>(context, listen: false);
    
    if (authService.currentUser == null) {
      if (mounted) {
        setState(() {
          _isFavorite = false;
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔍 Vérification favori pour logement ID: ${widget.logementId}');
      
      final isFav = await favoriteService.isFavorite(
        widget.logementId,
        authService.currentUser!.email,
        widget.type,
      );
      
      print('📌 Résultat: ${isFav ? "Favori" : "Pas favori"}');
      
      if (mounted) {
        setState(() {
          _isFavorite = isFav;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Erreur lors de la vérification du favori: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isFavorite = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final favoriteService = Provider.of<FavoriteService>(context, listen: false);
    
    if (authService.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez vous connecter pour ajouter aux favoris'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // ✅ Vérification de l'ID
    if (widget.logementId == 0 || widget.logementId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ID du logement invalide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFavorite) {
        print('🗑️ Suppression du favori ID: ${widget.logementId}');
        await favoriteService.removeFavorite(
          logementId: widget.logementId,
          utilisateurEmail: authService.currentUser!.email,
          type: widget.type,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.heart_broken, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Retiré des favoris'),
                ],
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.grey[700],
            ),
          );
        }
      } else {
        print('❤️ Ajout du favori ID: ${widget.logementId}');
        await favoriteService.addFavorite(
          logementId: widget.logementId,
          type: widget.type,
          utilisateurEmail: authService.currentUser!.email,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Ajouté aux favoris'),
                ],
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.red[400],
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Erreur lors du toggle favori: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.color ?? Colors.red,
                ),
              ),
            )
          : Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite 
                  ? Colors.red
                  : (widget.color ?? Colors.grey),
              size: widget.size,
            ),
      onPressed: _toggleFavorite,
      splashRadius: widget.size! * 0.7,
      tooltip: _isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
    );
  }
}