import 'dart:async';
import 'package:flutter/material.dart';
import '../models/logement.dart';
import '../utils/theme.dart';
import '../widgets/favorite_button.dart';

class PropertyCard extends StatefulWidget {
  final Logement logement;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const PropertyCard({
    Key? key,
    required this.logement,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    
    // ✅ AUTO-DÉFILEMENT TOUTES LES 2 SECONDES
    if (widget.logement.images.isNotEmpty && widget.logement.images.length > 1) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!mounted || !_pageController.hasClients) {
        timer.cancel();
        return;
      }

      int nextPage = (_currentPage + 1) % widget.logement.images.length;
      
      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ RÉCUPÉRER L'ID CORRECT DU LOGEMENT
    final int logementId = widget.logement.id ?? 0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppTheme.paddingLG,
          vertical: AppTheme.marginMD,
        ),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          boxShadow: AppTheme.shadowLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ IMAGE AVEC AUTO-DÉFILEMENT
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusMD),
                  ),
                  child: widget.logement.images.isNotEmpty
                      ? SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemCount: widget.logement.images.length,
                            itemBuilder: (context, index) {
                              return Image.asset(
                                widget.logement.images[index],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(
                                        Icons.home,
                                        size: 60,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.home,
                              size: 60,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                ),

                // ✅ INDICATEURS DE PAGE (points)
                if (widget.logement.images.length > 1)
                  Positioned(
                    bottom: AppTheme.paddingMD,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.logement.images.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.primary
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Badge type de logement
                Positioned(
                  top: AppTheme.paddingMD,
                  left: AppTheme.paddingMD,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingMD,
                      vertical: AppTheme.paddingSM,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTypeIcon(widget.logement.type),
                          size: AppTheme.iconSM,
                          color: AppTheme.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          widget.logement.type,
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ BOUTON FAVORI AVEC FAVORITEBUTTON WIDGET
                Positioned(
                  top: AppTheme.paddingMD,
                  right: AppTheme.paddingMD,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.shadowLight,
                    ),
                    child: FavoriteButton(
                      logementId: logementId,
                      type: 'logement',
                      size: 24,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),

            // Informations du logement
            Padding(
              padding: EdgeInsets.all(AppTheme.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.logement.nom,
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.logement.note > 0) ...[
                        SizedBox(width: AppTheme.marginSM),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: AppTheme.iconSM,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.logement.note.toStringAsFixed(1),
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: AppTheme.marginSM),

                  // Ville
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: AppTheme.iconSM,
                        color: AppTheme.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.logement.ville,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.marginMD),

                  // Caractéristiques
                  Row(
                    children: [
                      _buildFeature(
                        Icons.bed,
                        "${widget.logement.nombreChambres} ch.",
                      ),
                      SizedBox(width: AppTheme.marginLG),
                      _buildFeature(
                        Icons.bathtub,
                        "${widget.logement.nombreSallesBain} sdb",
                      ),
                      if (widget.logement.type.toLowerCase() == 'hôtel' &&
                          widget.logement.nombreEtoiles > 0) ...[
                        SizedBox(width: AppTheme.marginLG),
                        Row(
                          children: List.generate(
                            widget.logement.nombreEtoiles.clamp(0, 5),
                            (index) => Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: AppTheme.marginMD),

                  // Équipements
                  Wrap(
                    spacing: AppTheme.marginSM,
                    children: [
                      if (widget.logement.hasWiFi)
                        _buildAmenityChip(Icons.wifi, "Wi-Fi"),
                      if (widget.logement.hasParking)
                        _buildAmenityChip(Icons.local_parking, "Parking"),
                      if (widget.logement.hasPool)
                        _buildAmenityChip(Icons.pool, "Piscine"),
                    ],
                  ),
                  SizedBox(height: AppTheme.marginMD),

                  // Prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${widget.logement.prix.toStringAsFixed(0)} DT",
                              style: AppTheme.textTheme.titleLarge?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " /nuit",
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingMD,
                          vertical: AppTheme.paddingSM,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                        ),
                        child: Text(
                          "Voir détails",
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: AppTheme.iconSM, color: AppTheme.textSecondary),
        SizedBox(width: 4),
        Text(
          text,
          style: AppTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primary),
          SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'villa':
        return Icons.villa;
      case 'maison':
        return Icons.house;
      case 'hôtel':
        return Icons.hotel;
      case 'appartement':
        return Icons.apartment;
      default:
        return Icons.home;
    }
  }
}