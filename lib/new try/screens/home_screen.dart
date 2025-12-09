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

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.home, 'label': 'Tous'},
    {'icon': Icons.villa, 'label': 'Villa'},
    {'icon': Icons.house, 'label': 'Maison'},
    {'icon': Icons.apartment, 'label': 'Appartement'},
    {'icon': Icons.landscape, 'label': 'Chalet'},
  ];

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<Logement>('logements');

    // Ajouter quelques logements si la box est vide
    if (box.isEmpty) {
      box.add(
        Logement(
          nom: "Villa Sidi Bou Said",
          ville: "Tunis",
          prix: 220,
          description: "Superbe villa avec vue sur mer.",
          images: ["assets/villa1.jpg"],
          adresse: "Sidi Bou Said, Tunis",
          nombreChambres: 3,
          nombreSallesBain: 2,
          type: "Villa",
        ),
      );
      box.add(
        Logement(
          nom: "Maison Hammamet",
          ville: "Hammamet",
          prix: 180,
          description: "Maison traditionnelle avec terrasse.",
          images: ["assets/maison1.jpg"],
          adresse: "Hammamet, Tunisie",
          nombreChambres: 2,
          nombreSallesBain: 1,
          type: "Maison",
        ),
      );
      box.add(
        Logement(
          nom: "Appartement Marina",
          ville: "Sousse",
          prix: 150,
          description: "Appartement moderne avec vue sur la marina.",
          images: ["assets/appart1.jpg"],
          adresse: "Port El Kantaoui, Sousse",
          nombreChambres: 2,
          nombreSallesBain: 1,
          type: "Appartement",
        ),
      );
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

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLG),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(AppTheme.paddingXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filtres",
                    style: AppTheme.textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.marginXL),
              Text(
                "Prix par nuit",
                style: AppTheme.textTheme.titleMedium,
              ),
              SizedBox(height: AppTheme.marginMD),
              RangeSlider(
                values: RangeValues(100, 300),
                min: 50,
                max: 500,
                divisions: 45,
                labels: RangeLabels('100 DT', '300 DT'),
                onChanged: (values) {},
              ),
              SizedBox(height: AppTheme.marginXL),
              Text(
                "Nombre de chambres",
                style: AppTheme.textTheme.titleMedium,
              ),
              SizedBox(height: AppTheme.marginMD),
              Wrap(
                spacing: AppTheme.marginMD,
                children: [1, 2, 3, 4, 5].map((nb) {
                  return ChoiceChip(
                    label: Text("$nb"),
                    selected: false,
                    onSelected: (selected) {},
                  );
                }).toList(),
              ),
              SizedBox(height: AppTheme.marginXXL),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.backgroundLight,
                        foregroundColor: AppTheme.primary,
                        elevation: 0,
                        side: BorderSide(color: AppTheme.primary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Réinitialiser",
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
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
                        child: Text(
                          "Appliquer",
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.textLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}