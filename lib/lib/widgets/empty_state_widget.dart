import 'package:flutter/material.dart';
import '../utils/theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool useGradient;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.useGradient = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.paddingXXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône avec gradient ou couleur unie
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: useGradient ? AppTheme.primaryGradient : null,
                color: useGradient ? null : AppTheme.backgroundAlt,
                shape: BoxShape.circle,
                boxShadow: useGradient ? AppTheme.shadowCard : null,
              ),
              child: Icon(
                icon,
                size: 60,
                color: useGradient ? Colors.white : AppTheme.textTertiary,
              ),
            ),
            SizedBox(height: AppTheme.marginXXL),
            
            // Titre
            Text(
              title,
              style: AppTheme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.marginMD),
            
            // Message
            Text(
              message,
              style: AppTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            
            // Bouton optionnel
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: AppTheme.marginXXL),
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  boxShadow: AppTheme.shadowLight,
                ),
                child: ElevatedButton.icon(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingXXL,
                      vertical: AppTheme.paddingLG,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    ),
                  ),
                  icon: Icon(Icons.explore),
                  label: Text(
                    buttonText!,
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}