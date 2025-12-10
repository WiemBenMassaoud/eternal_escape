import 'package:flutter/material.dart';
import '../models/logement.dart';
import '../utils/theme.dart';

class PropertyCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppTheme.paddingLG,
          vertical: AppTheme.paddingSM,
        ),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          boxShadow: AppTheme.shadowLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du logement
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.radiusMD),
                      topRight: Radius.circular(AppTheme.radiusMD),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.radiusMD),
                      topRight: Radius.circular(AppTheme.radiusMD),
                    ),
                    child: Image.asset(
                      logement.images.isNotEmpty ? logement.images[0] : 'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.backgroundAlt,
                          child: Center(
                            child: Icon(
                              Icons.home_rounded,
                              size: 60,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Badge type
                Positioned(
                  top: AppTheme.marginMD,
                  left: AppTheme.marginMD,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingMD,
                      vertical: AppTheme.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: Text(
                      logement.type,
                      style: AppTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Bouton favori
                Positioned(
                  top: AppTheme.marginMD,
                  right: AppTheme.marginMD,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundLight,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.shadowLight,
                      ),
                      child: Center(
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? AppTheme.primary : AppTheme.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                // Indicateur d'étoiles pour les hôtels
                if (logement.type == 'Hôtel' && logement.nombreEtoiles > 0)
                  Positioned(
                    bottom: AppTheme.marginMD,
                    left: AppTheme.marginMD,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingSM,
                        vertical: AppTheme.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(logement.nombreEtoiles, (index) {
                          return Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.white,
                          );
                        }),
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
                  // Nom et ville
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          logement.nom,
                          style: AppTheme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Prix
                      Text(
                        "${logement.prix.toStringAsFixed(0)} DT",
                        style: AppTheme.textTheme.headlineSmall?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        logement.ville,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (logement.note > 0) ...[
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingSM,
                            vertical: AppTheme.paddingXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 4),
                              Text(
                                logement.note.toStringAsFixed(1),
                                style: AppTheme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                              if (logement.nombreAvis > 0) ...[
                                SizedBox(width: 2),
                                Text(
                                  "(${logement.nombreAvis})",
                                  style: AppTheme.textTheme.labelSmall?.copyWith(
                                    color: AppTheme.textTertiary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: AppTheme.marginMD),

                  // Caractéristiques
                  Row(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.bed_rounded,
                        text: "${logement.nombreChambres} chambre${logement.nombreChambres > 1 ? 's' : ''}",
                      ),
                      SizedBox(width: AppTheme.marginLG),
                      _buildFeatureItem(
                        icon: Icons.bathroom_rounded,
                        text: "${logement.nombreSallesBain} salle${logement.nombreSallesBain > 1 ? 's' : ''} de bain",
                      ),
                    ],
                  ),

                  // Équipements
                  if (logement.hasPool || logement.hasWiFi || logement.hasParking) ...[
                    SizedBox(height: AppTheme.marginMD),
                    Wrap(
                      spacing: AppTheme.marginSM,
                      runSpacing: AppTheme.marginXS,
                      children: [
                        if (logement.hasWiFi)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.paddingSM,
                              vertical: AppTheme.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundAlt,
                              borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.wifi, size: 12, color: AppTheme.textSecondary),
                                SizedBox(width: 4),
                                Text(
                                  "Wi-Fi",
                                  style: AppTheme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        if (logement.hasPool)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.paddingSM,
                              vertical: AppTheme.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundAlt,
                              borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.pool, size: 12, color: AppTheme.textSecondary),
                                SizedBox(width: 4),
                                Text(
                                  "Piscine",
                                  style: AppTheme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        if (logement.hasParking)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.paddingSM,
                              vertical: AppTheme.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundAlt,
                              borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.local_parking, size: 12, color: AppTheme.textSecondary),
                                SizedBox(width: 4),
                                Text(
                                  "Parking",
                                  style: AppTheme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.textTertiary,
          ),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}