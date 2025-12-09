import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: AppTheme.marginMD),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.paddingLG,
          vertical: AppTheme.paddingMD,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusCircle),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.borderLight,
            width: 1.5,
          ),
          boxShadow: isSelected ? AppTheme.shadowCard : AppTheme.shadowLight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppTheme.iconSM,
              color: isSelected ? AppTheme.textLight : AppTheme.textSecondary,
            ),
            SizedBox(width: AppTheme.marginSM),
            Text(
              label,
              style: AppTheme.textTheme.labelLarge?.copyWith(
                color: isSelected ? AppTheme.textLight : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}