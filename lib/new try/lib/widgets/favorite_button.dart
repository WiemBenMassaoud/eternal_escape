import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../models/favorite.dart';
import '../services/auth_service.dart';

class FavoriteButton extends StatefulWidget {
  final int logementId;
  final String type;
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

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() {
    final authService = context.read<AuthService>();
    final currentUserEmail = authService.currentUser?.email;
    
    if (currentUserEmail == null) {
      setState(() => _isFavorite = false);
      return;
    }

    final box = Hive.box<Favorite>('favorites');
    
    final isFav = box.values.any((fav) =>
        fav.logementId == widget.logementId &&
        fav.utilisateurEmail == currentUserEmail &&
        fav.type == widget.type);
    
    setState(() => _isFavorite = isFav);
  }

  Future<void> _toggleFavorite() async {
    final authService = context.read<AuthService>();
    final currentUserEmail = authService.currentUser?.email;
    
    if (currentUserEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez vous connecter pour ajouter aux favoris'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (widget.logementId <= 0) return;

    final box = Hive.box<Favorite>('favorites');
    
    if (_isFavorite) {
      final index = box.values.toList().indexWhere((fav) =>
          fav.logementId == widget.logementId &&
          fav.utilisateurEmail == currentUserEmail &&
          fav.type == widget.type);
      
      if (index != -1) {
        await box.deleteAt(index);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Retiré des favoris'),
          backgroundColor: Colors.grey[700],
        ),
      );
    } else {
      final favorite = Favorite(
        logementId: widget.logementId,
        type: widget.type,
        utilisateurEmail: currentUserEmail,
        dateAjout: DateTime.now(),
      );
      
      await box.add(favorite);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ajouté aux favoris'),
          backgroundColor: Colors.red[400],
        ),
      );
    }

    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Favorite>('favorites').listenable(),
      builder: (context, Box<Favorite> box, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkIfFavorite();
        });
        
        return IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : (widget.color ?? Colors.grey),
            size: widget.size,
          ),
          onPressed: _toggleFavorite,
          splashRadius: widget.size! * 0.7,
          tooltip: _isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
        );
      },
    );
  }
}