import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/logement.dart';
import '../utils/theme.dart';
import '../widgets/property_card.dart';
import '../widgets/property_search_bar.dart';
import '../widgets/category_chip.dart';
import 'logement_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  Set<int> _favoriteIds = {};

  // Variables pour les filtres
  double _minPrice = 50;
  double _maxPrice = 500;
  int? _selectedRooms;
  String? _selectedTypeFilter;
  double _ratingFilter = 0.0;
  int _starsFilter = 0;
  bool _hasPool = false;
  bool _hasWifi = false;
  bool _hasParking = false;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.home, 'label': 'Tous'},
    {'icon': Icons.villa, 'label': 'Villa'},
    {'icon': Icons.house, 'label': 'Maison'},
    {'icon': Icons.hotel, 'label': 'Hôtel'},
    {'icon': Icons.apartment, 'label': 'Appartement'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  void _initializeFilters() {
    // Réinitialiser tous les filtres
    _minPrice = 50;
    _maxPrice = 500;
    _selectedRooms = null;
    _selectedTypeFilter = null;
    _ratingFilter = 0.0;
    _starsFilter = 0;
    _hasPool = false;
    _hasWifi = false;
    _hasParking = false;
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<Logement>('logements');

    // Ajouter les logements réels si la box est vide
    if (box.isEmpty) {
      _addRealEstateData(box);
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on, color: AppTheme.primary, size: AppTheme.iconMD),
            SizedBox(width: AppTheme.marginSM),
            Text(
              "EternalEscape",
              style: AppTheme.textTheme.displaySmall?.copyWith(
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          // Bouton pour réinitialiser les filtres
          IconButton(
            icon: Icon(Icons.filter_alt_off),
            onPressed: _clearAllFilters,
            tooltip: "Réinitialiser tous les filtres",
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Aucune notification"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de recherche
          Padding(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            child: PropertySearchBar(
              controller: _searchController,
              hintText: "Où allez-vous ?",
              onChanged: (value) {
                setState(() {});
              },
              onFilterTap: () {
                _showFilterDialog(context);
              },
            ),
          ),

          // Catégories
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppTheme.paddingLG),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryChip(
                  icon: category['icon'],
                  label: category['label'],
                  isSelected: _selectedCategory == category['label'],
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['label'];
                    });
                  },
                );
              },
            ),
          ),

          // Indicateur de filtres actifs
          if (_hasActiveFilters())
            _buildActiveFiltersIndicator(),

          SizedBox(height: AppTheme.marginMD),

          // Liste des logements
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<Logement> logements, _) {
                if (logements.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 80,
                          color: AppTheme.textTertiary,
                        ),
                        SizedBox(height: AppTheme.marginLG),
                        Text(
                          "Aucun logement disponible",
                          style: AppTheme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                // Filtrer les logements
                List<int> visibleIndices = [];
                for (int i = 0; i < logements.length; i++) {
                  Logement logement = logements.getAt(i)!;
                  
                  // Filtre de recherche
                  if (_searchController.text.isNotEmpty &&
                      !logement.nom.toLowerCase().contains(_searchController.text.toLowerCase()) &&
                      !logement.ville.toLowerCase().contains(_searchController.text.toLowerCase())) {
                    continue;
                  }

                  // Filtre de catégorie
                  if (_selectedCategory != 'Tous' && logement.type != _selectedCategory) {
                    continue;
                  }

                  // Appliquer les filtres avancés
                  if (!logement.matchesFilters(
                    minPrice: _minPrice,
                    maxPrice: _maxPrice,
                    minRooms: _selectedRooms,
                    typeFilter: _selectedTypeFilter,
                    minRating: _ratingFilter,
                    minStars: _starsFilter > 0 ? _starsFilter : null,
                    hasPoolFilter: _hasPool,
                    hasWifiFilter: _hasWifi,
                    hasParkingFilter: _hasParking,
                  )) {
                    continue;
                  }
                  
                  visibleIndices.add(i);
                }

                if (visibleIndices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: AppTheme.textTertiary,
                        ),
                        SizedBox(height: AppTheme.marginLG),
                        Text(
                          "Aucun résultat trouvé",
                          style: AppTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: AppTheme.marginSM),
                        Text(
                          "Essayez d'autres critères de recherche",
                          style: AppTheme.textTheme.bodyMedium,
                        ),
                        SizedBox(height: AppTheme.marginLG),
                        ElevatedButton(
                          onPressed: _clearAllFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                            ),
                          ),
                          child: Text(
                            "Réinitialiser les filtres",
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: AppTheme.paddingXXL),
                  itemCount: visibleIndices.length,
                  itemBuilder: (context, index) {
                    int logementIndex = visibleIndices[index];
                    Logement logement = logements.getAt(logementIndex)!;
                    int logementId = logement.key as int;

                    return PropertyCard(
                      logement: logement,
                      isFavorite: _favoriteIds.contains(logementId),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LogementDetailScreen(logement: logement),
                          ),
                        );
                      },
                      onFavoriteToggle: () {
                        setState(() {
                          if (_favoriteIds.contains(logementId)) {
                            _favoriteIds.remove(logementId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Retiré des favoris"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } else {
                            _favoriteIds.add(logementId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Ajouté aux favoris ❤️"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersIndicator() {
    List<Widget> filterChips = [];

    if (_minPrice > 50 || _maxPrice < 500) {
      filterChips.add(
        FilterChip(
          label: Text('${_minPrice.round()}-${_maxPrice.round()} DT'),
          onSelected: (selected) {
            setState(() {
              _minPrice = 50;
              _maxPrice = 500;
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
        ),
      );
    }

    if (_selectedRooms != null) {
      filterChips.add(
        FilterChip(
          label: Text('${_selectedRooms!}+ chambres'),
          onSelected: (selected) {
            setState(() {
              _selectedRooms = null;
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
        ),
      );
    }

    if (_ratingFilter > 0) {
      filterChips.add(
        FilterChip(
          label: Text('${_ratingFilter.toStringAsFixed(1)}+ ★'),
          onSelected: (selected) {
            setState(() {
              _ratingFilter = 0.0;
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
        ),
      );
    }

    if (_starsFilter > 0) {
      filterChips.add(
        FilterChip(
          label: Text('${_starsFilter}+ étoiles'),
          onSelected: (selected) {
            setState(() {
              _starsFilter = 0;
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
        ),
      );
    }

    if (_hasPool) {
      filterChips.add(
        FilterChip(
          label: Text('Piscine'),
          onSelected: (selected) {
            setState(() {
              _hasPool = false;
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
        ),
      );
    }

    if (_hasWifi) {
      filterChips.add(
        FilterChip(
          label: Text('Wi-Fi'),
          onSelected: (selected) {
            setState(() {
              _hasWifi = false;
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
        ),
      );
    }

    if (_hasParking) {
      filterChips.add(
        FilterChip(
          label: Text('Parking'),
          onSelected: (selected) {
            setState(() {
              _hasParking = false;
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
        ),
      );
    }

    if (filterChips.isEmpty) return SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.paddingLG, vertical: AppTheme.paddingSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_alt, size: 16, color: AppTheme.primary),
              SizedBox(width: 4),
              Text(
                'Filtres actifs:',
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: filterChips,
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _minPrice > 50 ||
           _maxPrice < 500 ||
           _selectedRooms != null ||
           _ratingFilter > 0 ||
           _starsFilter > 0 ||
           _hasPool ||
           _hasWifi ||
           _hasParking;
  }

  void _clearAllFilters() {
    setState(() {
      _initializeFilters();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tous les filtres ont été réinitialisés"),
          backgroundColor: AppTheme.primary,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _showFilterDialog(BuildContext context) {
    // Variables locales pour le filtre
    RangeValues _priceRange = RangeValues(_minPrice, _maxPrice);
    int? _selectedRoomsLocal = _selectedRooms;
    String? _selectedTypeLocal = _selectedTypeFilter;
    double _ratingFilterLocal = _ratingFilter;
    int _starsFilterLocal = _starsFilter;
    bool _hasPoolLocal = _hasPool;
    bool _hasWifiLocal = _hasWifi;
    bool _hasParkingLocal = _hasParking;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLG),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(AppTheme.paddingXXL),
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filtres Avancés",
                        style: AppTheme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.clear_all),
                            onPressed: () {
                              setState(() {
                                _priceRange = RangeValues(50, 500);
                                _selectedRoomsLocal = null;
                                _selectedTypeLocal = null;
                                _ratingFilterLocal = 0.0;
                                _starsFilterLocal = 0;
                                _hasPoolLocal = false;
                                _hasWifiLocal = false;
                                _hasParkingLocal = false;
                              });
                            },
                            tooltip: "Tout effacer",
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppTheme.marginLG),
                  
                  // Contenu défilant
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Prix
                          _buildFilterSection(
                            title: "Budget par nuit",
                            icon: Icons.attach_money,
                            child: Column(
                              children: [
                                RangeSlider(
                                  values: _priceRange,
                                  min: 50,
                                  max: 500,
                                  divisions: 45,
                                  labels: RangeLabels(
                                    '${_priceRange.start.round()} DT',
                                    '${_priceRange.end.round()} DT',
                                  ),
                                  onChanged: (values) {
                                    setState(() => _priceRange = values);
                                  },
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildPriceChip(_priceRange.start.round()),
                                    Text("à", style: AppTheme.textTheme.bodyMedium),
                                    _buildPriceChip(_priceRange.end.round()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: AppTheme.marginXL),
                          
                          // Type de logement
                          _buildFilterSection(
                            title: "Type de logement",
                            icon: Icons.category,
                            child: Wrap(
                              spacing: AppTheme.marginSM,
                              runSpacing: AppTheme.marginSM,
                              children: ['Tous', 'Villa', 'Maison', 'Hôtel', 'Appartement'].map((type) {
                                return FilterChip(
                                  label: Text(type),
                                  selected: _selectedTypeLocal == type,
                                  selectedColor: AppTheme.primary.withOpacity(0.2),
                                  checkmarkColor: AppTheme.primary,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedTypeLocal = selected ? type : null;
                                    });
                                  },
                                  avatar: _selectedTypeLocal == type 
                                      ? Icon(Icons.check, size: 16, color: AppTheme.primary)
                                      : null,
                                );
                              }).toList(),
                            ),
                          ),
                          
                          SizedBox(height: AppTheme.marginXL),
                          
                          // Nombre de chambres
                          _buildFilterSection(
                            title: "Nombre de chambres",
                            icon: Icons.bed,
                            child: Wrap(
                              spacing: AppTheme.marginSM,
                              runSpacing: AppTheme.marginSM,
                              children: [1, 2, 3, 4, 5].map((nb) {
                                return ChoiceChip(
                                  label: Text("$nb+"),
                                  selected: _selectedRoomsLocal == nb,
                                  selectedColor: AppTheme.primary.withOpacity(0.2),
                                  checkmarkColor: AppTheme.primary,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedRoomsLocal = selected ? nb : null;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          
                          SizedBox(height: AppTheme.marginXL),
                          
                          // Nombre d'étoiles (pour hôtels)
                          _buildFilterSection(
                            title: "Nombre d'étoiles (hôtels)",
                            icon: Icons.star,
                            child: Wrap(
                              spacing: AppTheme.marginSM,
                              runSpacing: AppTheme.marginSM,
                              children: [1, 2, 3, 4, 5].map((stars) {
                                return ChoiceChip(
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(stars, (index) => 
                                      Icon(Icons.star, size: 16, color: Colors.amber)
                                    ),
                                  ),
                                  selected: _starsFilterLocal == stars,
                                  selectedColor: AppTheme.primary.withOpacity(0.2),
                                  checkmarkColor: AppTheme.primary,
                                  onSelected: (selected) {
                                    setState(() {
                                      _starsFilterLocal = selected ? stars : 0;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          
                          SizedBox(height: AppTheme.marginXL),
                          
                          // Note minimale
                          _buildFilterSection(
                            title: "Note minimale",
                            icon: Icons.star_rate,
                            child: Column(
                              children: [
                                Slider(
                                  value: _ratingFilterLocal,
                                  min: 0,
                                  max: 5,
                                  divisions: 5,
                                  label: "${_ratingFilterLocal.toStringAsFixed(1)}+",
                                  onChanged: (value) {
                                    setState(() => _ratingFilterLocal = value);
                                  },
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < _ratingFilterLocal.floor()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 24,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: AppTheme.marginXL),
                          
                          // Équipements
                          _buildFilterSection(
                            title: "Équipements",
                            icon: Icons.emoji_objects,
                            child: Column(
                              children: [
                                _buildAmenitySwitch(
                                  "Piscine",
                                  Icons.pool,
                                  _hasPoolLocal,
                                  (value) => setState(() => _hasPoolLocal = value),
                                ),
                                _buildAmenitySwitch(
                                  "Wi-Fi Rapide",
                                  Icons.wifi,
                                  _hasWifiLocal,
                                  (value) => setState(() => _hasWifiLocal = value),
                                ),
                                _buildAmenitySwitch(
                                  "Parking",
                                  Icons.local_parking,
                                  _hasParkingLocal,
                                  (value) => setState(() => _hasParkingLocal = value),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: AppTheme.marginXXL),
                        ],
                      ),
                    ),
                  ),
                  
                  // Boutons d'action
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: AppTheme.borderLight)),
                      color: AppTheme.backgroundLight,
                    ),
                    padding: EdgeInsets.only(top: AppTheme.marginLG),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.backgroundLight,
                              foregroundColor: AppTheme.textSecondary,
                              elevation: 0,
                              side: BorderSide(color: AppTheme.borderLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              "Annuler",
                              style: AppTheme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                        SizedBox(width: AppTheme.marginLG),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                              boxShadow: AppTheme.shadowLight,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Appliquer les filtres
                                _applyFilters(
                                  minPrice: _priceRange.start,
                                  maxPrice: _priceRange.end,
                                  minRooms: _selectedRoomsLocal,
                                  type: _selectedTypeLocal,
                                  minRating: _ratingFilterLocal,
                                  minStars: _starsFilterLocal,
                                  hasPool: _hasPoolLocal,
                                  hasWifi: _hasWifiLocal,
                                  hasParking: _hasParkingLocal,
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_alt, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Appliquer",
                                    style: AppTheme.textTheme.titleMedium?.copyWith(
                                      color: AppTheme.textLight,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _applyFilters({
    required double minPrice,
    required double maxPrice,
    int? minRooms,
    String? type,
    double minRating = 0.0,
    int minStars = 0,
    bool hasPool = false,
    bool hasWifi = false,
    bool hasParking = false,
  }) {
    setState(() {
      _minPrice = minPrice;
      _maxPrice = maxPrice;
      _selectedRooms = minRooms;
      _selectedTypeFilter = type;
      _ratingFilter = minRating;
      _starsFilter = minStars;
      _hasPool = hasPool;
      _hasWifi = hasWifi;
      _hasParking = hasParking;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Filtres appliqués avec succès"),
        backgroundColor: AppTheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            SizedBox(width: AppTheme.marginSM),
            Text(
              title,
              style: AppTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.marginMD),
        child,
      ],
    );
  }

  Widget _buildPriceChip(int price) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Text(
        "$price DT",
        style: AppTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildAmenitySwitch(String label, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginSM),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: value ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value ? AppTheme.primary : AppTheme.borderLight,
          width: value ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: value ? AppTheme.primary : AppTheme.textSecondary),
          SizedBox(width: AppTheme.marginMD),
          Expanded(child: Text(label, style: AppTheme.textTheme.bodyMedium)),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  void _addRealEstateData(Box<Logement> box) {
    // OCEANA Hotel & Spa - Hammamet
    box.add(
      Logement(
        nom: "OCEANA Hotel & Spa",
        ville: "Hammamet",
        prix: 195,
        description: "Hôtel de luxe en bord de mer avec 4 piscines, spa et plage privée. Parfait pour des vacances relaxantes avec petit-déjeuner fabuleux inclus.",
        images: ["assets/images/oceana1.jpg",
                 "assets/images/oceana2.jpg",
                 "assets/images/oceana3.jpg",
                 "assets/images/ocean3.jpg",
                 "assets/images/oceana5.jpg",],
        adresse: "BP58, 8056 Hammamet",
        nombreChambres: 2,
        nombreSallesBain: 1,
        type: "Hôtel",
        note: 4.7,
        nombreEtoiles: 5,
        nombreAvis: 128,
        hasWiFi: true,
        hasParking: true,
        hasPool: true,
      ),
    );

    // Misk Villa - Sidi Bou Said
    box.add(
      Logement(
        nom: "Misk Villa - Boutique Hotel & Spa",
        ville: "Sidi Bou Said",
        prix: 250,
        description: "Hôtel boutique avec piscine intérieure, spa et excellent emplacement (9.2/10). À 900m de la Plage d'Amilcar avec restaurant et bar sur place.",
        images: ["assets/images/misk1.jpg",
                "assets/images/misk2.jpg",
                "assets/images/misk3.jpg",
                "assets/images/misk4.jpg",
                "assets/images/misk5.jpg",],
        adresse: "Rue Abou El Kacem Chebbi, Sidi Bou Saïd",
        nombreChambres: 1,
        nombreSallesBain: 1,
        type: "Hôtel",
        note: 4.9,
        nombreEtoiles: 4,
        nombreAvis: 89,
        hasWiFi: true,
        hasParking: true,
        hasPool: true,
      ),
    );

    // Mille & une nuit - Djerba
    box.add(
      Logement(
        nom: "Mille & une nuit",
        ville: "Djerba",
        prix: 160,
        description: "Maison avec piscine extérieure et Wi-Fi ultra-rapide (123 Mb/s). Vue magnifique, idéal pour les familles. À 4,1 km du Golf Club.",
        images: ["assets/images/mille1.jpg",
                "assets/images/mille2.jpg",
                "assets/images/mille3.jpg",
                "assets/images/mille4.jpg",
                "assets/images/mille5.jpg",],
        adresse: "Megerssa, Al Maqārisah, Djerba",
        nombreChambres: 3,
        nombreSallesBain: 2,
        type: "Maison",
        note: 4.5,
        nombreEtoiles: 0,
        nombreAvis: 67,
        hasWiFi: true,
        hasParking: true,
        hasPool: true,
      ),
    );

    // Alex House - Aïn Draham
    box.add(
      Logement(
        nom: "Alex House",
        ville: "Aïn Draham",
        prix: 140,
        description: "Hébergement entier de 80m² avec vue sur la montagne et bain à remous. Excellent emplacement (9.5/10). Parfait pour les escapades nature.",
        images: ["assets/images/alex1.jpg",
                "assets/images/alex2.jpg",
                "assets/images/alex3.jpg",
                "assets/images/alex4.jpg",
                "assets/images/alex5.jpg",
                "assets/images/alex6.jpg",],
        adresse: "Fej errih, 8130 Aïn Draham",
        nombreChambres: 2,
        nombreSallesBain: 1,
        type: "Maison",
        note: 4.8,
        nombreEtoiles: 0,
        nombreAvis: 42,
        hasWiFi: true,
        hasParking: false,
        hasPool: false,
      ),
    );

    // Golden Tulip President - Hammamet
    box.add(
      Logement(
        nom: "Golden Tulip President Hammamet",
        ville: "Hammamet",
        prix: 175,
        description: "Hôtel 4 étoiles près de la plage avec 2 piscines extérieures, spa complet et salle d'arcade. Service et personnel d'exception.",
        images: ["assets/images/golden2.jpg",
                "assets/images/golden3.jpg",
                "assets/images/golden4.jpg",
                "assets/images/golden5.jpg",
                "assets/images/golden6.jpg",],
        adresse: "Hammamet",
        nombreChambres: 2,
        nombreSallesBain: 1,
        type: "Hôtel",
        note: 4.3,
        nombreEtoiles: 4,
        nombreAvis: 156,
        hasWiFi: true,
        hasParking: true,
        hasPool: true,
      ),
    );

    // Casa Firma Hammamet
    box.add(
      Logement(
        nom: "Casa Firma Hammamet",
        ville: "Korba",
        prix: 185,
        description: "Villa à Korba avec piscine extérieure, jardin et barbecue. Animaux acceptés. Idéal pour les familles recherchant calme et confort.",
        images: ["assets/images/firma1.jpg",
                "assets/images/firma2.jpg",
                "assets/images/firma3.jpg",
                "assets/images/firma4.jpg",],
        adresse: "Korba, Hammamet",
        nombreChambres: 3,
        nombreSallesBain: 2,
        type: "Villa",
        note: 4.6,
        nombreEtoiles: 0,
        nombreAvis: 31,
        hasWiFi: true,
        hasParking: true,
        hasPool: true,
      ),
    );

    // Maison de Luxe Pour Toute la Famille
    box.add(
      Logement(
        nom: "Maison de Luxe Pour Toute la Famille",
        ville: "Hammamet",
        prix: 155,
        description: "Villa entière au bord de l'eau avec 3 chambres, piscine extérieure, cuisine équipée et barbecue. Parfait pour 10 personnes.",
        images: [
                "assets/images/maison_luxe1.jpg",
                "assets/images/maison_luxe3.jpg",
                "assets/images/maison_luxe4.jpg",],
        adresse: "Hammamet",
        nombreChambres: 3,
        nombreSallesBain: 1,
        type: "Villa",
        note: 4.4,
        nombreEtoiles: 0,
        nombreAvis: 23,
        hasWiFi: true,
        hasParking: true,
        hasPool: true,
      ),
    );

    // Le Monaco Hôtel & Thalasso
    box.add(
      Logement(
        nom: "Le Monaco Hôtel & Thalasso",
        ville: "Sousse",
        prix: 120,
        description: "B&B en bord de plage avec piscine extérieure, restaurant français et soins spa. Centre de fitness sur place avec vue sur la mer.",
        images: ["assets/images/monaco1.jpg",
                "assets/images/monaco2.jpg",
                "assets/images/monaco3.jpg",
                "assets/images/monaco4.jpg",
                "assets/images/monaco5.jpg",
                "assets/images/monaco6.jpg",],

        adresse: "Sousse, Plage de Sousse",
        nombreChambres: 1,
        nombreSallesBain: 1,
        type: "Hôtel",
        note: 4.1,
        nombreEtoiles: 3,
        nombreAvis: 78,
        hasWiFi: true,
        hasParking: true,
        hasPool: true,
      ),
    );

    // Sousse Palace Hotel & Spa
    box.add(
      Logement(
        nom: "Sousse Palace Hotel & Spa",
        ville: "Sousse",
        prix: 210,
        description: "Hôtel de luxe sur plage privée avec 2 piscines, bain à remous et spa. Petit déjeuner buffet inclus. Vue mer et restaurant international.",
        images: ["assets/images/sousse1.jpg",
                "assets/images/sousse2.jpg",
                "assets/images/sousse3.jpg",
                "assets/images/sousse4.jpg",
                "assets/images/sousse5.jpg",
                "assets/images/sousse6.jpg",],
        adresse: "30 Avenue Habib Bourguiba, Sousse",
        nombreChambres: 2,
        nombreSallesBain: 1,
        type: "Hôtel",
        note: 4.7,
        nombreEtoiles: 5,
        nombreAvis: 212,
        hasWiFi: true,
        hasParking: true,
        hasPool: true,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}