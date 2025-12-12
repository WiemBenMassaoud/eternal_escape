import 'package:flutter/material.dart';
import '../utils/theme.dart';

class SettingSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  const SettingSwitchTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.paddingLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFEAEAFF)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color(0xFF6C63FF).withOpacity(0.2)),
            ),
            child: Icon(icon, color: Color(0xFF6C63FF), size: 24),
          ),
          SizedBox(width: AppTheme.marginLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF6C63FF),
            activeTrackColor: Color(0xFF6C63FF).withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}