import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 3)
class Favorite extends HiveObject {
  @HiveField(0)
  int logementId; // ID du logement ou activité

  @HiveField(1)
  String type; // "logement" ou "activite"

  @HiveField(2)
  String utilisateurEmail; // Email de l’utilisateur

  @HiveField(3)
  DateTime dateAjout; // Quand l’utilisateur a ajouté ce favori

  Favorite({
    required this.logementId,
    required this.type,
    required this.utilisateurEmail,
    required this.dateAjout,
  });

  /// Récupérer l’objet complet
  dynamic getItem() {
    var box = Hive.box('logements'); // ou activités si séparée
    return box.get(logementId);
  }
}
