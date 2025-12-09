import 'package:flutter/material.dart';
import '../utils/theme.dart';

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final VoidCallback onTap;
  final Color? iconColor;

  const NotificationCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    required this.onTap,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.marginMD),
      decoration: BoxDecoration(
        color: isRead ? AppTheme.backgroundCard : AppTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(
          color: isRead ? AppTheme.borderLight : AppTheme.primary.withOpacity(0.2),
        ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: iconColor == null ? AppTheme.primaryGradient : null,
                    color: iconColor?.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? Colors.white,
                    size: AppTheme.iconMD,
                  ),
                ),
                SizedBox(width: AppTheme.marginLG),
                
                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTheme.textTheme.titleMedium?.copyWith(
                                fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        message,
                        style: AppTheme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppTheme.marginSM),
                      Text(
                        time,
                        style: AppTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}