import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
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
  String photoProfil; // chemin local ou URL, non null pour éviter erreurs

  @HiveField(6)
  String adresse; // non null pour simplifier affichage

  @HiveField(7)
  String? motDePasse; // si nécessaire pour login futur

  @HiveField(8)
  List<int> reservationsIds; // IDs des réservations de l'utilisateur

  User({
    required this.prenom,
    required this.nom,
    required this.email,
    required this.telephone,
    this.dateNaissance,
    String? photoProfil,
    String? adresse,
    this.motDePasse,
    this.reservationsIds = const [],
  })  : this.photoProfil = photoProfil ?? 'assets/default_user.png',
        this.adresse = adresse ?? 'Non spécifiée';

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
