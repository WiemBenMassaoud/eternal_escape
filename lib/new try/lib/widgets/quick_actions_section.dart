// quick_actions_section.dart
import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback onReservations;
  final VoidCallback onNotifications;
  final VoidCallback onMessages;
  final VoidCallback onSettings;

  const QuickActionsSection({
    Key? key,
    required this.onReservations,
    required this.onNotifications,
    required this.onMessages,
    required this.onSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions rapides',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton('Historique', Icons.history_rounded, onReservations),
              _buildActionButton('Notifications', Icons.notifications_rounded, onNotifications),
              _buildActionButton('Messages', Icons.chat_rounded, onMessages),
              _buildActionButton('Paramètres', Icons.settings_rounded, onSettings),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF42A5F5).withOpacity(0.1), // Bleu
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Color(0xFF42A5F5), size: 24), // Bleu
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}