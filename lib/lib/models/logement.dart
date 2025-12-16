import 'package:hive/hive.dart';

part 'logement.g.dart';

@HiveType(typeId: 0)
class Logement extends HiveObject {
  @HiveField(0)
  int? id; // ✅ AJOUT DU CHAMP ID
  
  @HiveField(1)
  String nom;

  @HiveField(2)
  String ville;

  @HiveField(3)
  double prix;

  @HiveField(4)
  String description;

  @HiveField(5)
  List<String> images;

  @HiveField(6)
  String adresse;

  @HiveField(7)
  int nombreChambres;

  @HiveField(8)
  int nombreSallesBain;

  @HiveField(9)
  double note;

  @HiveField(10)
  String type;

  @HiveField(11)
  String? pensionType;

  @HiveField(12)
  int? nombreChambresDisponibles;

  @HiveField(13)
  bool? hasSuites;

  @HiveField(14)
  double? prixSuite;

  @HiveField(15)
  int nombreEtoiles;

  @HiveField(16)
  int nombreAvis;

  @HiveField(17)
  List<String>? equippements;

  @HiveField(18)
  bool hasWiFi;

  @HiveField(19)
  bool hasParking;

  @HiveField(20)
  bool hasPool;

  @HiveField(21)
  List<Map<String, dynamic>>? avis;

  Logement({
    this.id,
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

  // ✅ GETTER ID AMÉLIORÉ
  int get logementId => id ?? (key as int? ?? 0);

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
  
  // ✅ GÉNÉRATION AUTOMATIQUE D'IMAGES
  static List<String> generateImages(String type, int count) {
    final baseUrl = 'https://picsum.photos/seed/';
    final random = DateTime.now().millisecondsSinceEpoch;
    
    List<String> images = [];
    for (int i = 0; i < count; i++) {
      images.add('$baseUrl${type.toLowerCase()}_$random$i/800/600');
    }
    return images;
  }
}