// settings_section.dart
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final VoidCallback onShowPreferences;
  final VoidCallback onShowNotifications;

  const SettingsSection({
    Key? key,
    required this.onShowPreferences,
    required this.onShowNotifications,
  }) : super(key: key);

  Widget _buildSettingOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF42A5F5).withOpacity(0.1), // Bleu
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Color(0xFF42A5F5), size: 20), // Bleu
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12),
          _buildSettingOption('Préférences', Icons.tune_rounded, onShowPreferences),
          _buildSettingOption('Notifications', Icons.notifications_rounded, onShowNotifications),
        ],
      ),
    );
  }
}