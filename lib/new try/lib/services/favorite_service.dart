import 'package:hive_flutter/hive_flutter.dart';
import '../models/favorite.dart';

class FavoriteService {
  static const String _boxName = 'favorites';
  Box<Favorite>? _favoritesBox;

  // ✅ Vérifier si la box est initialisée
  bool get isInitialized => _favoritesBox != null && _favoritesBox!.isOpen;

  Future<void> init() async {
    try {
      // 🔧 IMPORTANT: Vérifier que le typeId est bien 3
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(FavoriteAdapter());
      }
      
      // Ouvrir la box
      _favoritesBox = await Hive.openBox<Favorite>(_boxName);
      print('✅ FavoriteService initialisé avec succès');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation de FavoriteService: $e');
      rethrow;
    }
  }

  // ✅ Méthode pour s'assurer que la box est initialisée
  Future<void> _ensureInitialized() async {
    if (!isInitialized) {
      await init();
    }
  }

  Future<void> addFavorite({
    required int logementId,
    required String type,
    required String utilisateurEmail,
  }) async {
    await _ensureInitialized();
    
    final favorite = Favorite(
      logementId: logementId,
      type: type,
      utilisateurEmail: utilisateurEmail,
      dateAjout: DateTime.now(),
    );

    // Vérifier si le favori existe déjà
    if (!await isFavorite(logementId, utilisateurEmail, type)) {
      await _favoritesBox!.add(favorite);
      print('✅ Favori ajouté: ID=$logementId, Email=$utilisateurEmail');
    } else {
      print('ℹ️ Favori déjà existant');
    }
  }

  Future<void> removeFavorite({
    required int logementId,
    required String utilisateurEmail,
    required String type,
  }) async {
    await _ensureInitialized();
    
    final index = _favoritesBox!.values.toList().indexWhere((fav) =>
        fav.logementId == logementId &&
        fav.utilisateurEmail == utilisateurEmail &&
        fav.type == type);

    if (index != -1) {
      await _favoritesBox!.deleteAt(index);
      print('❌ Favori supprimé: ID=$logementId, Email=$utilisateurEmail');
    }
  }

  Future<bool> isFavorite(
    int logementId,
    String utilisateurEmail,
    String type,
  ) async {
    await _ensureInitialized();
    
    return _favoritesBox!.values.any((fav) =>
        fav.logementId == logementId &&
        fav.utilisateurEmail == utilisateurEmail &&
        fav.type == type);
  }

  Future<List<Favorite>> getUserFavorites(String utilisateurEmail) async {
    await _ensureInitialized();
    
    return _favoritesBox!.values
        .where((fav) => fav.utilisateurEmail == utilisateurEmail)
        .toList();
  }

  Stream<List<Favorite>> watchUserFavorites(String utilisateurEmail) {
    if (!isInitialized) {
      return Stream.value([]);
    }
    
    return _favoritesBox!.watch().map((event) {
      return _favoritesBox!.values
          .where((fav) => fav.utilisateurEmail == utilisateurEmail)
          .toList();
    });
  }

  Future<void> clearAllFavorites() async {
    await _ensureInitialized();
    await _favoritesBox!.clear();
  }

  Future<void> close() async {
    if (isInitialized) {
      await _favoritesBox!.close();
    }
  }
}