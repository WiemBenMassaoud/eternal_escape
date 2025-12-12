import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/favorite.dart';
import '../models/logement.dart';
import 'logement_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<Favorite>('favorites');

    return Scaffold(
      appBar: AppBar(title: Text("❤️ Favoris"), backgroundColor: Colors.deepPurple),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Favorite> favorites, _) {
          if (favorites.isEmpty) {
            return Center(child: Text("Aucun favori ajouté"));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              Favorite fav = favorites.getAt(index)!;
              var logementBox = Hive.box<Logement>('logements');
              var logement = logementBox.get(fav.logementId);

              if (logement == null) return SizedBox();

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: logement.images.isNotEmpty
                      ? Image.asset(logement.images.first, width: 60, height: 60, fit: BoxFit.cover)
                      : Icon(Icons.home, size: 50),
                  title: Text(logement.nom),
                  subtitle: Text("${logement.ville} • ${logement.prix} DT/nuit"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favorites.deleteAt(index);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LogementDetailScreen(logement: logement)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
