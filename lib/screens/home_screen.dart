import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/logement.dart';
import 'logement_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box<Logement>('logements');

    // Ajouter quelques logements si la box est vide
    if (box.isEmpty) {
      box.add(
        Logement(
          nom: "Villa Sidi Bou Said",
          ville: "Tunis",
          prix: 220,
          description: "Superbe villa avec vue sur mer.",
          images: ["assets/villa1.jpg"],
          adresse: "Sidi Bou Said, Tunis",
          nombreChambres: 3,
          nombreSallesBain: 2,
          type: "Villa",
        ),
      );
      box.add(
        Logement(
          nom: "Maison Hammamet",
          ville: "Hammamet",
          prix: 180,
          description: "Maison traditionnelle avec terrasse.",
          images: ["assets/maison1.jpg"],
          adresse: "Hammamet, Tunisie",
          nombreChambres: 2,
          nombreSallesBain: 1,
          type: "Maison",
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("🏡 EternalEscape"), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Logement> logements, _) {
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: logements.length,
            itemBuilder: (context, index) {
              Logement logement = logements.getAt(index)!;
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: logement.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            logement.images.first,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(Icons.home, size: 50),
                  title: Text(logement.nom, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${logement.ville} • ${logement.prix} DT/nuit"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LogementDetailScreen(logement: logement),
                      ),
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
