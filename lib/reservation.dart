import 'package:hive/hive.dart';
import 'logement.dart';

part 'reservation.g.dart';

@HiveType(typeId: 2)
class Reservation extends HiveObject {
  @HiveField(0)
  int logementId; // ID du logement réservé

  @HiveField(1)
  DateTime dateDebut;

  @HiveField(2)
  DateTime dateFin;

  @HiveField(3)
  double prixTotal;

  @HiveField(4)
  String utilisateurEmail; // Email de l’utilisateur qui a réservé

  @HiveField(5)
  String statut; // "en attente", "confirmée", "annulée"

  Reservation({
    required this.logementId,
    required this.dateDebut,
    required this.dateFin,
    required this.prixTotal,
    required this.utilisateurEmail,
    this.statut = "en attente",
  });

  /// Récupérer le logement complet
  Logement? getLogement() {
    var box = Hive.box<Logement>('logements');
    return box.get(logementId);
  }
}
