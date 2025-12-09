import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.email,
    this.imageUrl,
    this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingXXL),
      child: Column(
        children: [
          // Avatar avec bouton edit
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.shadowCard,
                ),
                child: imageUrl != null
                    ? ClipOval(
                        child: Image.asset(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
              ),
              if (onEditPressed != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditPressed,
                    child: Container(
                      padding: EdgeInsets.all(AppTheme.paddingSM),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.backgroundLight,
                          width: 3,
                        ),
                        boxShadow: AppTheme.shadowLight,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: AppTheme.iconXS,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppTheme.marginXL),
          
          // Nom
          Text(
            name,
            style: AppTheme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.marginSM),
          
          // Email
          Text(
            email,
            style: AppTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}