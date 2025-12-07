import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../utils/theme.dart';

class BookingCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onTap;
  final String? logementName;
  final String? logementImage;

  const BookingCard({
    Key? key,
    required this.reservation,
    required this.onTap,
    this.logementName,
    this.logementImage,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 
                    'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final nights = reservation.dateFin.difference(reservation.dateDebut).inDays;

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
          padding: EdgeInsets.all(AppTheme.paddingLG),
          child: Row(
            children: [
              // Image du logement
              if (logementImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                  child: Image.asset(
                    logementImage!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  ),
                )
              else
                _buildPlaceholderImage(),

              SizedBox(width: AppTheme.marginLG),

              // Informations de réservation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom du logement
                    Text(
                      logementName ?? "Logement #${reservation.logementId}",
                      style: AppTheme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppTheme.marginXS),

                    // Dates
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: AppTheme.iconXS,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(width: AppTheme.marginXS),
                        Expanded(
                          child: Text(
                            "${_formatDate(reservation.dateDebut)} - ${_formatDate(reservation.dateFin)}",
                            style: AppTheme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.marginXS),

                    // Nombre de nuits
                    Row(
                      children: [
                        Icon(
                          Icons.nightlight_outlined,
                          size: AppTheme.iconXS,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(width: AppTheme.marginXS),
                        Text(
                          "$nights nuit${nights > 1 ? 's' : ''}",
                          style: AppTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.marginMD),

                    // Prix total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingMD,
                            vertical: AppTheme.paddingXS,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppTheme.promoGradient,
                            borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                          ),
                          child: Text(
                            "${reservation.prixTotal} DT",
                            style: AppTheme.textTheme.titleSmall?.copyWith(
                              color: AppTheme.textLight,
                              fontWeight: FontWeight.w700,
                            ),
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
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.backgroundAlt,
        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
      ),
      child: Icon(
        Icons.home_outlined,
        size: AppTheme.iconLG,
        color: AppTheme.textTertiary,
      ),
    );
  }
}