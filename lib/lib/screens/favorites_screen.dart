import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../models/favorite.dart';
import '../models/logement.dart';
import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import 'logement_detail_screen.dart';
import '../widgets/favorite_button.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUserEmail = authService.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("❤️ Favoris"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showFavoritesInfo(context);
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Favorite>('favorites').listenable(),
        builder: (context, Box<Favorite> favoritesBox, _) {
          // Filtrer les favoris par utilisateur
          final userFavorites = favoritesBox.values
              .where((fav) => fav.utilisateurEmail == currentUserEmail)
              .toList();

          print('📊 Favoris de l\'utilisateur: ${userFavorites.length}');
          print('📊 IDs des favoris: ${userFavorites.map((f) => f.logementId).toList()}');

          if (userFavorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Aucun favori ajouté",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Ajoutez des logements à vos favoris",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Retourner à l'écran d'accueil
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.explore),
                    label: Text('Explorer les logements'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          // Récupérer tous les logements
          final logementBox = Hive.box<Logement>('logements');
          
          // ✅ Créer une Map pour un accès rapide par ID
          final logementMap = <int, Logement>{};
          for (int i = 0; i < logementBox.length; i++) {
            final logement = logementBox.getAt(i);
            if (logement != null && logement.id != null) {
              logementMap[logement.id!] = logement;
            }
          }

          print('📊 Logements disponibles: ${logementMap.keys.toList()}');

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: userFavorites.length,
            itemBuilder: (context, index) {
              final fav = userFavorites[index];
              
              // ✅ Trouver le logement correspondant par ID
              final logement = logementMap[fav.logementId];
              
              if (logement == null) {
                print('⚠️ Logement non trouvé pour ID: ${fav.logementId}');
                // Afficher une carte d'erreur au lieu de rien
                return Card(
                  margin: EdgeInsets.all(8),
                  color: Colors.red.shade50,
                  child: ListTile(
                    leading: Icon(Icons.error_outline, color: Colors.red),
                    title: Text('Logement introuvable'),
                    subtitle: Text('ID: ${fav.logementId}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Supprimer le favori invalide
                        final favoriteService = Provider.of<FavoriteService>(context, listen: false);
                        await favoriteService.removeFavorite(
                          logementId: fav.logementId,
                          utilisateurEmail: currentUserEmail,
                          type: fav.type,
                        );
                      },
                    ),
                  ),
                );
              }

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LogementDetailScreen(logement: logement),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Image du logement
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: logement.images.isNotEmpty
                              ? Image.network(
                                  logement.images.first,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: Icon(Icons.home, size: 40, color: Colors.grey),
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.home, size: 40, color: Colors.grey),
                                ),
                        ),
                        
                        SizedBox(width: 12),
                        
                        // Informations du logement
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                logement.nom,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      logement.ville,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 14, color: Colors.amber),
                                  SizedBox(width: 4),
                                  Text(
                                    '${logement.note.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '(${logement.nombreAvis} avis)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    "${logement.prix.toStringAsFixed(0)} DT",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "/nuit",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Bouton favori
                        FavoriteButton(
                          logementId: logement.id ?? 0,
                          type: 'logement',
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFavoritesInfo(BuildContext context) {
    final favoritesBox = Hive.box<Favorite>('favorites');
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUserEmail = authService.currentUser?.email ?? '';
    
    final userFavorites = favoritesBox.values
        .where((fav) => fav.utilisateurEmail == currentUserEmail)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('Informations'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📊 Statistiques:'),
            SizedBox(height: 8),
            Text('• Total de favoris: ${userFavorites.length}'),
            Text('• Email: $currentUserEmail'),
            SizedBox(height: 12),
            Text('🔍 IDs des logements favoris:'),
            SizedBox(height: 4),
            ...userFavorites.map((fav) => 
              Padding(
                padding: EdgeInsets.only(left: 8, top: 2),
                child: Text('• ID ${fav.logementId} (${fav.type})'),
              )
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}