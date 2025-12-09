
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAvailable;

  const AmenityChip({
    Key? key,
    required this.icon,
    required this.label,
    this.isAvailable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMD,
        vertical: AppTheme.paddingSM,
      ),
      decoration: BoxDecoration(
        color: isAvailable 
            ? AppTheme.primary.withOpacity(0.1)
            : AppTheme.backgroundAlt,
        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
        border: Border.all(
          color: isAvailable ? AppTheme.primary.withOpacity(0.3) : AppTheme.borderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppTheme.iconXS,
            color: isAvailable ? AppTheme.primary : AppTheme.textTertiary,
          ),
          SizedBox(width: AppTheme.marginXS),
          Text(
            label,
            style: AppTheme.textTheme.labelMedium?.copyWith(
              color: isAvailable ? AppTheme.primary : AppTheme.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}