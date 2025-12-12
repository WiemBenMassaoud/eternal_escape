import 'package:flutter/material.dart';
import '../models/logement.dart';
import '../utils/theme.dart';

class PropertyCard extends StatelessWidget {
  final Logement logement;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const PropertyCard({
    Key? key,
    required this.logement,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      ),
      elevation: AppTheme.elevationSM,
      margin: EdgeInsets.symmetric(
        vertical: AppTheme.marginSM,
        horizontal: AppTheme.marginLG,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            color: AppTheme.backgroundCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section avec badge favori
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.radiusSM),
                      topRight: Radius.circular(AppTheme.radiusSM),
                    ),
                    child: logement.images.isNotEmpty
                        ? Image.asset(
                            logement.images.first,
                            width: double.infinity,
                            height: AppTheme.imageHeightSM,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          )
                        : _buildPlaceholderImage(),
                  ),
                  // Bouton favori
                  if (onFavoriteToggle != null)
                    Positioned(
                      top: AppTheme.paddingMD,
                      right: AppTheme.paddingMD,
                      child: GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Container(
                          padding: EdgeInsets.all(AppTheme.paddingSM),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: AppTheme.shadowLight,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? AppTheme.primary : AppTheme.textSecondary,
                            size: AppTheme.iconSM,
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
                        vertical: AppTheme.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                      ),
                      child: Text(
                        logement.type,
                        style: AppTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.bold,
                        ),
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
                    Text(
                      logement.nom,
                      style: AppTheme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppTheme.marginXS),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: AppTheme.iconXS,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(width: AppTheme.marginXS),
                        Expanded(
                          child: Text(
                            logement.ville,
                            style: AppTheme.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.marginMD),
                    
                    // Caractéristiques
                    Row(
                      children: [
                        _buildFeature(Icons.bed_outlined, "${logement.nombreChambres}"),
                        SizedBox(width: AppTheme.marginLG),
                        _buildFeature(Icons.bathroom_outlined, "${logement.nombreSallesBain}"),
                      ],
                    ),
                    
                    SizedBox(height: AppTheme.marginMD),
                    Divider(height: 1, color: AppTheme.borderLight),
                    SizedBox(height: AppTheme.marginMD),
                    
                    // Prix
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${logement.prix} DT",
                                style: AppTheme.textTheme.titleLarge?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(
                                text: " /nuit",
                                style: AppTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: AppTheme.iconXS,
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: AppTheme.imageHeightSM,
      color: AppTheme.backgroundAlt,
      child: Icon(
        Icons.home_outlined,
        size: AppTheme.iconXXL,
        color: AppTheme.textTertiary,
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: AppTheme.iconXS, color: AppTheme.textSecondary),
        SizedBox(width: AppTheme.marginXS),
        Text(text, style: AppTheme.textTheme.bodyMedium),
      ],
    );
  }
}