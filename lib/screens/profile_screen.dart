import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/reservation.dart';
import '../models/logement.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var userBox = Hive.box<User>('users');

    // On prend le premier utilisateur pour cette démo
    User user = userBox.isNotEmpty
        ? userBox.getAt(0)!
        : User(
            prenom: "John",
            nom: "Doe",
            email: "john.doe@example.com",
            telephone: "+21612345678",
          );

    return Scaffold(
      appBar: AppBar(
        title: Text("Mon Profil"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Photo Profil
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(user.photoProfil),
            ),
            SizedBox(height: 16),

            // Nom complet
            Text(
              user.nomComplet,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Email
            Row(
              children: [
                Icon(Icons.email, color: Colors.deepPurple),
                SizedBox(width: 10),
                Text(user.email, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 8),

            // Téléphone
            Row(
              children: [
                Icon(Icons.phone, color: Colors.deepPurple),
                SizedBox(width: 10),
                Text(user.telephone, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 8),

            // Adresse
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.deepPurple),
                SizedBox(width: 10),
                Text(user.adresse, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 16),

            // Historique des réservations
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mes Réservations",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),

            // Liste des réservations
            ValueListenableBuilder(
              valueListenable: Hive.box<Reservation>('reservations').listenable(),
              builder: (context, Box<Reservation> resBox, _) {
                List<Reservation> userReservations = resBox.values
                    .where((r) => r.utilisateurEmail == user.email)
                    .toList();

                if (userReservations.isEmpty) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Vous n'avez aucune réservation."),
                  ));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userReservations.length,
                  itemBuilder: (context, index) {
                    Reservation res = userReservations[index];
                    Logement? logement = res.getLogement();

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: logement != null && logement.images.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  logement.images.first,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.home, size: 50),
                        title: Text(logement?.nom ?? "Logement supprimé"),
                        subtitle: Text(
                            "Du ${res.dateDebut.toLocal().toString().split(' ')[0]} au ${res.dateFin.toLocal().toString().split(' ')[0]}\nTotal: ${res.prixTotal} DT"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    );
                  },
                );
              },
            ),

            SizedBox(height: 20),

            // Boutons Edit / Logout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Edit profile
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Modifier"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Logout
                  },
                  icon: Icon(Icons.logout),
                  label: Text("Déconnexion"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
