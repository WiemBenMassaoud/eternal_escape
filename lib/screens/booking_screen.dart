import 'package:flutter/material.dart';
import '../models/reservation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var reservationsBox = Hive.box<Reservation>('reservations');

    return Scaffold(
      appBar: AppBar(title: Text("Mes Réservations")),
      body: ValueListenableBuilder(
        valueListenable: reservationsBox.listenable(),
        builder: (context, Box<Reservation> box, _) {
          if (box.isEmpty) {
            return Center(child: Text("Aucune réservation pour le moment"));
          }
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: box.length,
            itemBuilder: (context, index) {
              Reservation res = box.getAt(index)!;
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  title: Text("Logement ID: ${res.logementId}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "${res.dateDebut.toLocal()} - ${res.dateFin.toLocal()}\nTotal: ${res.prixTotal} DT"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
