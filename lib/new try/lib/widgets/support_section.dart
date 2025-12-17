// support_section.dart
import 'package:flutter/material.dart';

class SupportSection extends StatelessWidget {
  final VoidCallback onHelp;
  final VoidCallback onContact;
  final VoidCallback onTerms;

  const SupportSection({
    Key? key,
    required this.onHelp,
    required this.onContact,
    required this.onTerms,
  }) : super(key: key);

  Widget _buildSupportOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFEC407A).withOpacity(0.1), // Rose
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Color(0xFFEC407A), size: 20), // Rose
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
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12),
          _buildSupportOption('Centre d\'aide', Icons.help_rounded, onHelp),
          _buildSupportOption('Contactez-nous', Icons.email_rounded, onContact),
          _buildSupportOption('Conditions', Icons.description_rounded, onTerms),
        ],
      ),
    );
  }
}