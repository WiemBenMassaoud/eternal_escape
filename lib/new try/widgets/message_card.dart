import 'package:flutter/material.dart';
import '../utils/theme.dart';

class MessageCard extends StatelessWidget {
  final String userName;
  final String message;
  final String time;
  final String? avatarUrl;
  final bool isRead;
  final int unreadCount;
  final VoidCallback onTap;

  const MessageCard({
    Key? key,
    required this.userName,
    required this.message,
    required this.time,
    this.avatarUrl,
    this.isRead = false,
    this.unreadCount = 0,
    required this.onTap,
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
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.shadowLight,
                  ),
                  child: avatarUrl != null
                      ? ClipOval(
                          child: Image.asset(
                            avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: AppTheme.iconLG,
                                color: Colors.white,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: AppTheme.iconLG,
                          color: Colors.white,
                        ),
                ),
                SizedBox(width: AppTheme.marginLG),
                
                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userName,
                            style: AppTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                            ),
                          ),
                          Text(
                            time,
                            style: AppTheme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              style: AppTheme.textTheme.bodySmall?.copyWith(
                                fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            SizedBox(width: AppTheme.marginSM),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppTheme.paddingSM,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(AppTheme.radiusCircle),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              child: Text(
                                unreadCount > 9 ? '9+' : unreadCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
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