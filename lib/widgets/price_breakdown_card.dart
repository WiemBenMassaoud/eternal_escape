import 'package:flutter/material.dart';
import '../utils/theme.dart';

class PriceBreakdownCard extends StatelessWidget {
  final double pricePerNight;
  final int numberOfNights;
  final double serviceFee;
  final double cleaningFee;
  final double? discount;
  final int nbAdults;
  final int nbChildren3to17;
  final int nbChildrenUnder3;

  const PriceBreakdownCard({
    Key? key,
    required this.pricePerNight,
    required this.numberOfNights,
    this.serviceFee = 0,
    this.cleaningFee = 0,
    this.discount,
    required this.nbAdults,
    required this.nbChildren3to17,
    required this.nbChildrenUnder3,
  }) : super(key: key);

  double get subtotal => pricePerNight * numberOfNights;
  double get total => subtotal + serviceFee + cleaningFee - (discount ?? 0);
  int get totalGuests => nbAdults + nbChildren3to17 + nbChildrenUnder3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.paddingSM),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ),
              SizedBox(width: AppTheme.marginMD),
              Text(
                'Détails du prix',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.marginXL),

          // ✅ AJOUT: Section Voyageurs
          Container(
            padding: EdgeInsets.all(AppTheme.paddingMD),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people_rounded,
                      size: 18,
                      color: AppTheme.primary,
                    ),
                    SizedBox(width: AppTheme.marginSM),
                    Text(
                      'Voyageurs',
                      style: AppTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.marginMD),
                
                // Adultes
                if (nbAdults > 0)
                  _buildGuestDetailRow(
                    icon: Icons.person_rounded,
                    iconColor: AppTheme.primary,
                    label: 'Adultes',
                    count: nbAdults,
                    subtitle: '18 ans et plus',
                  ),
                
                // Enfants 3-17 ans
                if (nbChildren3to17 > 0) ...[
                  SizedBox(height: AppTheme.marginSM),
                  _buildGuestDetailRow(
                    icon: Icons.child_care_rounded,
                    iconColor: AppTheme.accentDark,
                    label: 'Enfants',
                    count: nbChildren3to17,
                    subtitle: '3 à 17 ans (demi-tarif)',
                  ),
                ],
                
                // Bébés < 3 ans
                if (nbChildrenUnder3 > 0) ...[
                  SizedBox(height: AppTheme.marginSM),
                  _buildGuestDetailRow(
                    icon: Icons.baby_changing_station_rounded,
                    iconColor: AppTheme.success,
                    label: 'Bébés',
                    count: nbChildrenUnder3,
                    subtitle: 'Moins de 3 ans',
                    isFree: true,
                  ),
                ],
                
                SizedBox(height: AppTheme.marginMD),
                Divider(color: AppTheme.borderLight, height: 1),
                SizedBox(height: AppTheme.marginMD),
                
                // Total voyageurs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.groups_rounded,
                            color: AppTheme.textLight,
                            size: 14,
                          ),
                        ),
                        SizedBox(width: AppTheme.marginSM),
                        Text(
                          'Total',
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$totalGuests ${totalGuests > 1 ? 'personnes' : 'personne'}',
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.marginXL),
          
          // Prix détaillés
          _buildPriceRow(
            '$pricePerNight DT x $numberOfNights nuit${numberOfNights > 1 ? 's' : ''}',
            subtotal,
          ),
          
          if (serviceFee > 0) ...[
            SizedBox(height: AppTheme.marginMD),
            _buildPriceRow('Frais de service', serviceFee),
          ],
          
          if (cleaningFee > 0) ...[
            SizedBox(height: AppTheme.marginMD),
            _buildPriceRow('Frais de ménage', cleaningFee),
          ],
          
          if (discount != null && discount! > 0) ...[
            SizedBox(height: AppTheme.marginMD),
            _buildPriceRow('Réduction', -discount!, isDiscount: true),
          ],
          
          SizedBox(height: AppTheme.marginLG),
          Divider(color: AppTheme.borderLight, thickness: 2),
          SizedBox(height: AppTheme.marginLG),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${total.toStringAsFixed(2)} DT',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ NOUVELLE MÉTHODE: Ligne de détail pour chaque type de voyageur
  Widget _buildGuestDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required int count,
    required String subtitle,
    bool isFree = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        SizedBox(width: AppTheme.marginMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              '$count',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
            if (isFree) ...[
              SizedBox(width: AppTheme.marginSM),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusCircle),
                  border: Border.all(color: AppTheme.success, width: 1),
                ),
                child: Text(
                  'GRATUIT',
                  style: AppTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w800,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          '${amount.toStringAsFixed(2)} DT',
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            color: isDiscount ? AppTheme.success : AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}