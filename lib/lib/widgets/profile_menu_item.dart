import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showArrow;
  final Widget? trailing;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
    this.showArrow = true,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
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
            child: Row(
              children: [
                // Icône
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDestructive 
                        ? AppTheme.error.withOpacity(0.1)
                        : AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? AppTheme.error : AppTheme.primary,
                    size: AppTheme.iconMD,
                  ),
                ),
                SizedBox(width: AppTheme.marginLG),
                
                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          color: isDestructive ? AppTheme.error : AppTheme.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: AppTheme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Trailing
                if (trailing != null)
                  trailing!
                else if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: AppTheme.iconXS,
                    color: AppTheme.textTertiary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}