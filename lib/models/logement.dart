import 'package:hive/hive.dart';

part 'logement.g.dart';

@HiveType(typeId: 0)
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
  List<String> images;

  @HiveField(5)
  String adresse;

  @HiveField(6)
  int nombreChambres;

  @HiveField(7)
  int nombreSallesBain;

  @HiveField(8)
  double note; // Note moyenne (1-5)

  @HiveField(9)
  String type; // "Hôtel", "Maison", "Villa", etc.

  // ✅ NOUVEAUX CHAMPS
  @HiveField(10)
  String? pensionType; // "All Inclusive", "Demi-pension", "Petit déjeuner", "Sans pension"

  @HiveField(11)
  int? nombreChambresDisponibles; // Nombre total de chambres disponibles

  @HiveField(12)
  bool? hasSuites; // Si le logement propose des suites

  @HiveField(13)
  double? prixSuite; // Prix supplémentaire pour une suite (par chambre)

  // ✅ NOUVEAUX CHAMPS POUR LES ÉTOILES ET AVIS
  @HiveField(14)
  int nombreEtoiles; // Nombre d'étoiles (1-5) pour les hôtels

  @HiveField(15)
  int nombreAvis; // Nombre total d'avis

  @HiveField(16)
  List<String>? equippements; // Liste des équipements disponibles

  @HiveField(17)
  bool hasWiFi; // Wi-Fi disponible

  @HiveField(18)
  bool hasParking; // Parking disponible

  @HiveField(19)
  bool hasPool; // Piscine disponible

  @HiveField(20)
  List<Map<String, dynamic>>? avis; // Liste des avis détaillés

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
    this.pensionType,
    this.nombreChambresDisponibles,
    this.hasSuites,
    this.prixSuite,
    this.nombreEtoiles = 0,
    this.nombreAvis = 0,
    this.equippements,
    this.hasWiFi = false,
    this.hasParking = false,
    this.hasPool = false,
    this.avis,
  });

  // Helper pour savoir si le logement inclut des repas
  bool get hasBreakfast => pensionType != null && pensionType != "Sans pension";
  
  bool get hasDemiPension => pensionType == "Demi-pension";
  
  bool get hasAllInclusive => pensionType == "All Inclusive";

  // Prix par défaut pour la pension selon le type de logement
  String getDefaultPensionType() {
    switch (type.toLowerCase()) {
      case 'hôtel':
        return 'Demi-pension';
      case 'villa':
      case 'maison':
        return 'Petit déjeuner';
      default:
        return 'Sans pension';
    }
  }

  // Méthode pour ajouter un avis
  void addAvis(String utilisateur, String commentaire, double note, DateTime date) {
    avis ??= [];
    avis!.add({
      'utilisateur': utilisateur,
      'commentaire': commentaire,
      'note': note,
      'date': date.toIso8601String(),
    });
    
    // Mettre à jour la note moyenne
    if (avis!.isNotEmpty) {
      double total = 0;
      for (var avisItem in avis!) {
        total += avisItem['note'];
      }
      this.note = total / avis!.length;
      nombreAvis = avis!.length;
    }
  }

  // Méthode pour vérifier si le logement correspond aux critères de filtrage
  bool matchesFilters({
    double? minPrice,
    double? maxPrice,
    int? minRooms,
    String? typeFilter,
    double? minRating,
    bool? hasPoolFilter,
    bool? hasWifiFilter,
    bool? hasParkingFilter,
    int? minStars,
  }) {
    // Filtre par prix
    if (minPrice != null && prix < minPrice) return false;
    if (maxPrice != null && prix > maxPrice) return false;
    
    // Filtre par nombre de chambres
    if (minRooms != null && nombreChambres < minRooms) return false;
    
    // Filtre par type
    if (typeFilter != null && typeFilter != 'Tous' && type != typeFilter) return false;
    
    // Filtre par note
    if (minRating != null && note < minRating) return false;
    
    // Filtre par étoiles (pour les hôtels)
    if (minStars != null && type.toLowerCase() == 'hôtel' && nombreEtoiles < minStars) return false;
    
    // Filtre par équipements
    if (hasPoolFilter != null && hasPoolFilter && !hasPool) return false;
    if (hasWifiFilter != null && hasWifiFilter && !hasWiFi) return false;
    if (hasParkingFilter != null && hasParkingFilter && !hasParking) return false;
    
    return true;
  }
}