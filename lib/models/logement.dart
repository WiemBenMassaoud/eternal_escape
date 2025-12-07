import 'package:hive/hive.dart';

part 'logement.g.dart';

@HiveType(typeId: 1)
class Logement extends HiveObject {
  @HiveField(0)
  String nom;

  @HiveField(1)
  String ville;

  @HiveField(2)
  double prix;

  @HiveField(3)
  String description;

  @HiveField(4)
  List<String> images; // URLs ou chemins locaux

  @HiveField(5)
  String adresse; // Adresse complète

  @HiveField(6)
  int nombreChambres; // Nombre de chambres si logement

  @HiveField(7)
  int nombreSallesBain; // Nombre de salles de bain

  @HiveField(8)
  double note; // Note moyenne utilisateurs

  @HiveField(9)
  String type; // "hotel", "maison", "activite", etc.

  Logement({
    required this.nom,
    required this.ville,
    required this.prix,
    required this.description,
    required this.images,
    required this.adresse,
    required this.nombreChambres,
    required this.nombreSallesBain,
    this.note = 0.0,
    required this.type,
  });
}
