import 'package:hive/hive.dart';

part 'reservation.g.dart';

@HiveType(typeId: 1)
class Reservation extends HiveObject {
  @HiveField(0)
  int logementId;

  @HiveField(1)
  DateTime dateDebut;

  @HiveField(2)
  DateTime dateFin;

  @HiveField(3)
  double prixTotal;

  @HiveField(4)
  String utilisateurEmail;

  @HiveField(5)
  String status; // 'pending', 'confirmed', 'cancelled', 'completed'

  @HiveField(6)
  String? paymentMethod; // 'credit_card', 'paypal', 'cash'

  @HiveField(7)
  double? serviceFee;

  @HiveField(8)
  double? cleaningFee;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime? cancelledAt;

  Reservation({
    required this.logementId,
    required this.dateDebut,
    required this.dateFin,
    required this.prixTotal,
    required this.utilisateurEmail,
    this.status = 'pending',
    this.paymentMethod,
    this.serviceFee = 0,
    this.cleaningFee = 0,
    DateTime? createdAt,
    this.cancelledAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isUpcoming => status == 'confirmed' && dateDebut.isAfter(DateTime.now());
  bool get isCompleted => status == 'completed' || dateFin.isBefore(DateTime.now());
  bool get isCancelled => status == 'cancelled';
  bool get isPending => status == 'pending';
}
