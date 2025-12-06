import 'package:hive/hive.dart';

part 'logement.g.dart'; // Nécessaire pour générer l'adapter Hive

@HiveType(typeId: 0)
class Logement extends HiveObject {
  @HiveField(0)
  String nom; // Nom de l'hôtel ou maison

  @HiveField(1)
  String ville; // Ville où se situe le logement

  @HiveField(2)
  String type; // "hotel" ou "maison"

  @HiveField(3)
  double prix; // Prix par nuit

  @HiveField(4)
  String categorie; // "famille", "solo", "éco"

  @HiveField(5)
  String description; // Description du logement

  @HiveField(6)
  List<String> images; // Liste des URL ou chemins des images

  @HiveField(7)
  List<String> services; // Wifi, parking, piscine, etc.

  @HiveField(8)
  bool promotion; // true si le logement est en promotion

  Logement({
    required this.nom,
    required this.ville,
    required this.type,
    required this.prix,
    required this.categorie,
    required this.description,
    required this.images,
    required this.services,
    required this.promotion,
  });
}

