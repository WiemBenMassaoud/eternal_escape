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
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final nights = reservation.dateFin.difference(reservation.dateDebut).inDays;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppTheme.marginSM,
        horizontal: AppTheme.marginLG,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        boxShadow: AppTheme.shadowLight,
        border: Border.all(
          color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          splashColor: AppTheme.primary.withOpacity(0.1),
          highlightColor: AppTheme.primary.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingLG),
            child: Row(
              children: [
                // Image du logement avec badge de statut
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      child: logementImage != null
                          ? Image.asset(
                              logementImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderImage();
                              },
                            )
                          : _buildPlaceholderImage(),
                    ),
                    // Badge de confirmation
                    Positioned(
                      top: AppTheme.paddingXS,
                      right: AppTheme.paddingXS,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingSM,
                          vertical: AppTheme.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: AppTheme.iconXS,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: AppTheme.marginLG),

                // ============================================
                // SECTION CORRIGÉE - DÉBUT
                // ============================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom du logement avec style premium
                      Text(
                        logementName ?? "Logement #${reservation.logementId}",
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? AppTheme.textLight : AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppTheme.marginMD),

                      // Dates avec icône stylisée
                      _buildInfoRow(
                        icon: Icons.calendar_today_rounded,
                        text: "${_formatDate(reservation.dateDebut)} - ${_formatDate(reservation.dateFin)}",
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: AppTheme.marginSM),

                      // Nombre de nuits avec icône stylisée
                      _buildInfoRow(
                        icon: Icons.nights_stay_rounded,
                        text: "$nights nuit${nights > 1 ? 's' : ''}",
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: AppTheme.marginSM),

                      // ✅ CORRIGÉ: Affichage détaillé des voyageurs
                      _buildGuestsInfo(isDarkMode),
                      
                      SizedBox(height: AppTheme.marginLG),

                      // Prix total avec design premium et flèche
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.paddingLG,
                              vertical: AppTheme.paddingSM,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.promoGradient,
                              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${reservation.prixTotal.toStringAsFixed(0)}",
                                  style: AppTheme.textTheme.titleMedium?.copyWith(
                                    color: AppTheme.textLight,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  " DT",
                                  style: AppTheme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textLight.withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(AppTheme.paddingSM),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: AppTheme.iconXS,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ============================================
                // SECTION CORRIGÉE - FIN
                // ============================================
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ NOUVELLE MÉTHODE: Affichage détaillé des voyageurs
  Widget _buildGuestsInfo(bool isDarkMode) {
    List<Widget> guestParts = [];

    // Adultes
    if (reservation.nbAdultes > 0) {
      guestParts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_rounded,
              size: 14,
              color: AppTheme.primary,
            ),
            SizedBox(width: 4),
            Text(
              '${reservation.nbAdultes}',
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: isDarkMode ? AppTheme.textLight.withOpacity(0.8) : AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Enfants 3-17 ans
    if (reservation.nbEnfants3a17 > 0) {
      if (guestParts.isNotEmpty) {
        guestParts.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '•',
              style: TextStyle(
                color: isDarkMode ? AppTheme.textLight.withOpacity(0.5) : AppTheme.textTertiary,
              ),
            ),
          ),
        );
      }
      guestParts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.child_care_rounded,
              size: 14,
              color: AppTheme.accentDark,
            ),
            SizedBox(width: 4),
            Text(
              '${reservation.nbEnfants3a17}',
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: isDarkMode ? AppTheme.textLight.withOpacity(0.8) : AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Bébés < 3 ans
    if (reservation.nbEnfantsMoins3 > 0) {
      if (guestParts.isNotEmpty) {
        guestParts.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '•',
              style: TextStyle(
                color: isDarkMode ? AppTheme.textLight.withOpacity(0.5) : AppTheme.textTertiary,
              ),
            ),
          ),
        );
      }
      guestParts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.baby_changing_station_rounded,
              size: 14,
              color: AppTheme.success,
            ),
            SizedBox(width: 4),
            Text(
              '${reservation.nbEnfantsMoins3}',
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: isDarkMode ? AppTheme.textLight.withOpacity(0.8) : AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.paddingSM,
        vertical: AppTheme.paddingXS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentLight.withOpacity(0.15),
            AppTheme.accentDark.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_rounded,
            size: 14,
            color: AppTheme.primary,
          ),
          SizedBox(width: 6),
          ...guestParts,
          SizedBox(width: 6),
          Text(
            '(${reservation.totalGuests})',
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: isDarkMode ? AppTheme.textLight.withOpacity(0.6) : AppTheme.textTertiary,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppTheme.paddingXS),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentLight.withOpacity(0.2),
                AppTheme.accentDark.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusXS),
          ),
          child: Icon(
            icon,
            size: AppTheme.iconXS,
            color: AppTheme.primary,
          ),
        ),
        SizedBox(width: AppTheme.marginSM),
        Expanded(
          child: Text(
            text,
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? AppTheme.textLight.withOpacity(0.8) : AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundAlt,
            AppTheme.backgroundAlt.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Icon(
        Icons.home_rounded,
        size: AppTheme.iconXL,
        color: AppTheme.textTertiary.withOpacity(0.5),
      ),
    );
  }
}