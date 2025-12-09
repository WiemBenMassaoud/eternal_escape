import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(color: AppTheme.borderLight, width: 1),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.paddingLG,
            vertical: AppTheme.paddingSM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Explorer',
                index: 0,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite,
                label: 'Favoris',
                index: 1,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Voyages',
                index: 2,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                index: 3,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMD,
          vertical: AppTheme.paddingSM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: AppTheme.iconMD,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.textTheme.labelSmall?.copyWith(
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}