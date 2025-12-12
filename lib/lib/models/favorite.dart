import 'package:hive/hive.dart';
part 'favorite.g.dart';

@HiveType(typeId: 3)
class Favorite extends HiveObject {
  @HiveField(0)
  int logementId;

  @HiveField(1)
  String type; // "logement" ou "activite"

  @HiveField(2)
  String utilisateurEmail;

  @HiveField(3)
  DateTime dateAjout;

  Favorite({
    required this.logementId,
    required this.type,
    required this.utilisateurEmail,
    required this.dateAjout,
  });
}
