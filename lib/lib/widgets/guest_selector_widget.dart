import 'package:flutter/material.dart';
import '../utils/theme.dart';

class GuestSelector extends StatefulWidget {
  final int initialAdults;
  final int initialChildren3to17;
  final int initialChildrenUnder3;
  final Function(int adults, int children3to17, int childrenUnder3) onGuestsChanged;

  const GuestSelector({
    Key? key,
    this.initialAdults = 1,
    this.initialChildren3to17 = 0,
    this.initialChildrenUnder3 = 0,
    required this.onGuestsChanged,
  }) : super(key: key);

  @override
  State<GuestSelector> createState() => _GuestSelectorState();
}

class _GuestSelectorState extends State<GuestSelector> {
  late int adults;
  late int children3to17;
  late int childrenUnder3;

  @override
  void initState() {
    super.initState();
    adults = widget.initialAdults;
    children3to17 = widget.initialChildren3to17;
    childrenUnder3 = widget.initialChildrenUnder3;
  }

  void _updateGuests() {
    widget.onGuestsChanged(adults, children3to17, childrenUnder3);
  }

  int get totalGuests => adults + children3to17 + childrenUnder3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
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
                  Icons.people_rounded,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ),
              SizedBox(width: AppTheme.marginMD),
              Text(
                'Voyageurs',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingLG,
                  vertical: AppTheme.paddingSM,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.promoGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCircle),
                ),
                child: Text(
                  '$totalGuests ${totalGuests > 1 ? 'personnes' : 'personne'}',
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.marginXL),

          // Adultes
          _buildGuestCounter(
            icon: Icons.person_rounded,
            iconColor: AppTheme.primary,
            label: 'Adultes',
            subtitle: '18 ans et plus',
            count: adults,
            onIncrement: () {
              if (adults < 20) {
                setState(() => adults++);
                _updateGuests();
              }
            },
            onDecrement: () {
              if (adults > 1) {
                setState(() => adults--);
                _updateGuests();
              }
            },
          ),

          SizedBox(height: AppTheme.marginLG),

          // Enfants 3-17 ans
          _buildGuestCounter(
            icon: Icons.child_care_rounded,
            iconColor: AppTheme.accentDark,
            label: 'Enfants',
            subtitle: '3 à 17 ans (demi-tarif)',
            count: children3to17,
            onIncrement: () {
              if (children3to17 < 20) {
                setState(() => children3to17++);
                _updateGuests();
              }
            },
            onDecrement: () {
              if (children3to17 > 0) {
                setState(() => children3to17--);
                _updateGuests();
              }
            },
          ),

          SizedBox(height: AppTheme.marginLG),

          // Enfants moins de 3 ans
          _buildGuestCounter(
            icon: Icons.baby_changing_station_rounded,
            iconColor: AppTheme.success,
            label: 'Bébés',
            subtitle: 'Moins de 3 ans (gratuit)',
            count: childrenUnder3,
            onIncrement: () {
              if (childrenUnder3 < 10) {
                setState(() => childrenUnder3++);
                _updateGuests();
              }
            },
            onDecrement: () {
              if (childrenUnder3 > 0) {
                setState(() => childrenUnder3--);
                _updateGuests();
              }
            },
          ),

          SizedBox(height: AppTheme.marginLG),

          // Information
          Container(
            padding: EdgeInsets.all(AppTheme.paddingMD),
            decoration: BoxDecoration(
              color: AppTheme.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              border: Border.all(color: AppTheme.info.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: AppTheme.info,
                ),
                SizedBox(width: AppTheme.marginMD),
                Expanded(
                  child: Text(
                    'Les bébés de moins de 3 ans sont gratuits',
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestCounter({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingLG),
      decoration: BoxDecoration(
        color: AppTheme.backgroundAlt,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppTheme.paddingSM),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: AppTheme.marginMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildCounterButton(
                icon: Icons.remove_rounded,
                onPressed: onDecrement,
                enabled: (label == 'Adultes' && count > 1) || 
                        (label != 'Adultes' && count > 0),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              _buildCounterButton(
                icon: Icons.add_rounded,
                onPressed: onIncrement,
                enabled: count < 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: enabled ? AppTheme.primaryGradient : null,
        color: enabled ? null : AppTheme.backgroundAlt,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(
          color: enabled ? Colors.transparent : AppTheme.borderLight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.paddingSM),
            child: Icon(
              icon,
              size: 20,
              color: enabled ? AppTheme.textLight : AppTheme.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}