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

  @HiveField(11)
  int numberOfGuests; // Nombre total de personnes

  // NOUVEAUX CHAMPS pour détails des voyageurs
  @HiveField(12)
  int nbAdultes; // Nombre d'adultes (18+)

  @HiveField(13)
  int nbEnfants3a17; // Nombre d'enfants 3-17 ans (demi-tarif)

  @HiveField(14)
  int nbEnfantsMoins3; // Nombre de bébés < 3 ans (gratuit)

  // Nouveaux champs que vous souhaitez ajouter
  @HiveField(15)
  int? nombreChambresReservees;
  
  @HiveField(16)
  int? nombreSuites;
  
  @HiveField(17)
  String pensionType;
  
  @HiveField(18)
  double? pensionFee;

  Reservation({
    required this.logementId,
    required this.dateDebut,
    required this.dateFin,
    required this.prixTotal,
    required this.utilisateurEmail,
    this.status = 'pending',
    this.paymentMethod,
    double? serviceFee,
    double? cleaningFee,
    DateTime? createdAt,
    this.cancelledAt,
    int? numberOfGuests,
    int? nbAdultes,
    int? nbEnfants3a17,
    int? nbEnfantsMoins3,
    this.nombreChambresReservees,
    this.nombreSuites,
    this.pensionType = '',
    this.pensionFee,
  })  : serviceFee = serviceFee ?? 0.0,
        cleaningFee = cleaningFee ?? 0.0,
        nbAdultes = nbAdultes ?? 1,
        nbEnfants3a17 = nbEnfants3a17 ?? 0,
        nbEnfantsMoins3 = nbEnfantsMoins3 ?? 0,
        numberOfGuests = numberOfGuests ??
            ((nbAdultes ?? 1) + (nbEnfants3a17 ?? 0) + (nbEnfantsMoins3 ?? 0)),
        createdAt = createdAt ?? DateTime.now();

  /// Fabrication sûre à partir d'une Map/dynamic (ex: JSON, form controller values).
  /// Convertit automatiquement String -> int/double/DateTime si nécessaire.
  factory Reservation.fromMap(dynamic m) {
    // m peut être Map<String, dynamic> ou Map<int, dynamic> selon ton usage
    dynamic get(dynamic key) {
      if (m is Map<String, dynamic>) return m[key];
      if (m is Map<int, dynamic>) return m[key];
      return null;
    }

    int logementId = _parseInt(get('logementId') ?? get(0)) ?? 0;
    DateTime dateDebut =
        _parseDate(get('dateDebut') ?? get(1)) ?? DateTime.now();
    DateTime dateFin =
        _parseDate(get('dateFin') ?? get(2)) ?? DateTime.now().add(Duration(days: 1));
    double prixTotal = _parseDouble(get('prixTotal') ?? get(3)) ?? 0.0;
    String utilisateurEmail =
        (get('utilisateurEmail') ?? get(4) ?? '').toString();
    String status = (get('status') ?? get(5) ?? 'pending').toString();
    String? paymentMethod = (get('paymentMethod') ?? get(6))?.toString();
    double? serviceFee = _parseDouble(get('serviceFee') ?? get(7)) ?? 0.0;
    double? cleaningFee = _parseDouble(get('cleaningFee') ?? get(8)) ?? 0.0;
    DateTime? createdAt = _parseDate(get('createdAt') ?? get(9));
    DateTime? cancelledAt = _parseDate(get('cancelledAt') ?? get(10));
    int nbAdultes = _parseInt(get('nbAdultes') ?? get(12)) ?? 1;
    int nbEnfants3a17 = _parseInt(get('nbEnfants3a17') ?? get(13)) ?? 0;
    int nbEnfantsMoins3 = _parseInt(get('nbEnfantsMoins3') ?? get(14)) ?? 0;
    int? nombreChambresReservees = _parseInt(get('nombreChambresReservees') ?? get(15));
    int? nombreSuites = _parseInt(get('nombreSuites') ?? get(16));
    String pensionType = (get('pensionType') ?? get(17) ?? '').toString();
    double? pensionFee = _parseDouble(get('pensionFee') ?? get(18));

    int numberOfGuests = _parseInt(get('numberOfGuests') ?? get(11)) ??
        (nbAdultes + nbEnfants3a17 + nbEnfantsMoins3);

    return Reservation(
      logementId: logementId,
      dateDebut: dateDebut,
      dateFin: dateFin,
      prixTotal: prixTotal,
      utilisateurEmail: utilisateurEmail,
      status: status,
      paymentMethod: paymentMethod,
      serviceFee: serviceFee,
      cleaningFee: cleaningFee,
      createdAt: createdAt,
      cancelledAt: cancelledAt,
      numberOfGuests: numberOfGuests,
      nbAdultes: nbAdultes,
      nbEnfants3a17: nbEnfants3a17,
      nbEnfantsMoins3: nbEnfantsMoins3,
      nombreChambresReservees: nombreChambresReservees,
      nombreSuites: nombreSuites,
      pensionType: pensionType,
      pensionFee: pensionFee,
    );
  }

  /// Sérialisation simple (utile pour logs / envoi)
  Map<String, dynamic> toMap() {
    return {
      'logementId': logementId,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'prixTotal': prixTotal,
      'utilisateurEmail': utilisateurEmail,
      'status': status,
      'paymentMethod': paymentMethod,
      'serviceFee': serviceFee,
      'cleaningFee': cleaningFee,
      'createdAt': createdAt.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'nbAdultes': nbAdultes,
      'nbEnfants3a17': nbEnfants3a17,
      'nbEnfantsMoins3': nbEnfantsMoins3,
      'nombreChambresReservees': nombreChambresReservees,
      'nombreSuites': nombreSuites,
      'pensionType': pensionType,
      'pensionFee': pensionFee,
    };
  }

  // Helpers pour l'état
  bool get isUpcoming =>
      status == 'confirmed' && dateDebut.isAfter(DateTime.now());
  bool get isCompleted => status == 'completed' || dateFin.isBefore(DateTime.now());
  bool get isCancelled => status == 'cancelled';
  bool get isPending => status == 'pending';

  // Calcule le nombre total de voyageurs
  int get totalGuests => nbAdultes + nbEnfants3a17 + nbEnfantsMoins3;

  // Met à jour numberOfGuests automatiquement
  void updateTotalGuests() {
    numberOfGuests = totalGuests;
  }

  // ---------- Parsers privés ----------
  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    final s = v.toString();
    return int.tryParse(s);
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    final s = v.toString().replaceAll(',', '.');
    return double.tryParse(s);
  }

  /// Accepte DateTime, int(millisecondsSinceEpoch), ou String ISO
  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is int) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(v);
      } catch (_) {
        return null;
      }
    }
    final s = v.toString();
    try {
      return DateTime.parse(s);
    } catch (_) {
      // essayer un parse plus permissif
      try {
        final millis = int.parse(s);
        return DateTime.fromMillisecondsSinceEpoch(millis);
      } catch (_) {
        return null;
      }
    }
  }
}