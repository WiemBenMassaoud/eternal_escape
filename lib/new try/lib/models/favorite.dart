import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 2)
class Favorite extends HiveObject {
  @HiveField(0)
  int logementId;

  @HiveField(1)
  String type;

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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Favorite &&
            runtimeType == other.runtimeType &&
            logementId == other.logementId &&
            utilisateurEmail == other.utilisateurEmail &&
            type == other.type;
  }

  @override
  int get hashCode =>
      logementId.hashCode ^ utilisateurEmail.hashCode ^ type.hashCode;
}