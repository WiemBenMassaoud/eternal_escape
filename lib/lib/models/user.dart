import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3) // typeId: 3 reste inchangé
class User extends HiveObject {
  @HiveField(0)
  String prenom;

  @HiveField(1)
  String nom;

  @HiveField(2)
  String email; // identifiant unique

  @HiveField(3)
  String telephone;

  @HiveField(4)
  DateTime? dateNaissance;

  @HiveField(5)
  String photoProfil;

  @HiveField(6)
  String adresse;

  @HiveField(7)
  String? motDePasse;

  @HiveField(8)
  List<int> reservationsIds;

  User({
    required this.prenom,
    required this.nom,
    required this.email,
    required this.telephone,
    this.dateNaissance,
    String? photoProfil,
    String? adresse,
    this.motDePasse,
    List<int>? reservationsIds,
  })  : photoProfil = photoProfil ?? 'assets/default_user.png',
        adresse = adresse ?? 'Non spécifiée',
        reservationsIds = reservationsIds ?? [];

  /// Méthode pour ajouter une réservation
  void ajouterReservation(int reservationId) {
    reservationsIds.add(reservationId);
    save(); // sauvegarde dans Hive
  }

  /// Méthode pour retirer une réservation
  void retirerReservation(int reservationId) {
    reservationsIds.remove(reservationId);
    save();
  }

  /// Retourne le nom complet
  String get nomComplet => '$prenom $nom';
}
