import 'package:flutter/material.dart';
import '../utils/theme.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.borderLight),
          boxShadow: AppTheme.shadowLight,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            child: Padding(
              padding: EdgeInsets.all(AppTheme.paddingLG),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppTheme.paddingMD),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppTheme.primary).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppTheme.primary,
                      size: AppTheme.iconLG,
                    ),
                  ),
                  SizedBox(height: AppTheme.marginMD),
                  Text(
                    value,
                    style: AppTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    label,
                    style: AppTheme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}