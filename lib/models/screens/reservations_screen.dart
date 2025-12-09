import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/reservation.dart';
import '../models/logement.dart';
import 'logement_detail_screen.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<Reservation>('reservations');

    return Scaffold(
      appBar: AppBar(title: Text("📅 Réservations"), backgroundColor: Colors.deepPurple),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Reservation> reservations, _) {
          if (reservations.isEmpty) return Center(child: Text("Aucune réservation"));

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              Reservation res = reservations.getAt(index)!;
              var logementBox = Hive.box<Logement>('logements');
              var logement = logementBox.get(res.logementId);

              if (logement == null) return SizedBox();

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: logement.images.isNotEmpty
                      ? Image.asset(logement.images.first, width: 60, height: 60, fit: BoxFit.cover)
                      : Icon(Icons.home, size: 50),
                  title: Text(logement.nom),
                  subtitle: Text(
                      "${res.dateDebut.toLocal()} - ${res.dateFin.toLocal()}\nPrix total: ${res.prixTotal} DT"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => reservations.deleteAt(index),
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
