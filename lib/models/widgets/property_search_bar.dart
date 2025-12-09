import 'package:flutter/material.dart';
import '../utils/theme.dart';

class PropertySearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;

  const PropertySearchBar({
    Key? key,
    this.hintText = "Où allez-vous ?",
    required this.onChanged,
    this.controller,
    this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        boxShadow: AppTheme.shadowLight,
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTheme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.textSecondary,
                  size: AppTheme.iconMD,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingLG,
                  vertical: AppTheme.paddingLG,
                ),
              ),
            ),
          ),
          if (onFilterTap != null)
            Container(
              margin: EdgeInsets.only(right: AppTheme.marginSM),
              child: IconButton(
                onPressed: onFilterTap,
                icon: Container(
                  padding: EdgeInsets.all(AppTheme.paddingSM),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: AppTheme.textLight,
                    size: AppTheme.iconSM,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}