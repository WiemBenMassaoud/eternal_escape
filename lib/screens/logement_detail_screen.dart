import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/logement.dart';
import '../models/reservation.dart';

class LogementDetailScreen extends StatelessWidget {
  final Logement logement;

  const LogementDetailScreen({Key? key, required this.logement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(logement.nom)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logement.images.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      logement.images.first,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox(),

            SizedBox(height: 16),
            Text("Ville : ${logement.ville}", style: TextStyle(fontSize: 18)),
            Text("Adresse : ${logement.adresse}", style: TextStyle(fontSize: 18)),
            Text("Prix : ${logement.prix} DT / nuit", style: TextStyle(fontSize: 18)),
            Text("Chambres : ${logement.nombreChambres}", style: TextStyle(fontSize: 18)),
            Text("Salles de bain : ${logement.nombreSallesBain}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Description :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(logement.description),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  var reservationBox = Hive.box<Reservation>('reservations');
                  reservationBox.add(
                    Reservation(
                      logementId: logement.key as int,
                      dateDebut: DateTime.now(),
                      dateFin: DateTime.now().add(Duration(days: 2)),
                      prixTotal: logement.prix * 2,
                      utilisateurEmail: "demo@escape.com",
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Réservation ajoutée !")),
                  );
                },
                child: Text("Réserver"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
