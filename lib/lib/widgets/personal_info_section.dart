import 'package:flutter/material.dart';
import '../../models/user.dart';

class PersonalInfoSection extends StatelessWidget {
  final User currentUser;
  final VoidCallback onEditProfile;

  const PersonalInfoSection({
    Key? key,
    required this.currentUser,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF6C63FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFF6C63FF),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Informations personnelles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: onEditProfile,
                  icon: Icon(Icons.edit_rounded, color: Color(0xFF6C63FF)),
                  tooltip: 'Modifier le profil',
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildEnhancedInfoRow(
            Icons.badge_rounded,
            'Prénom',
            currentUser.prenom,
            Color(0xFF6C63FF),
          ),
          Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
          _buildEnhancedInfoRow(
            Icons.person_outline_rounded,
            'Nom',
            currentUser.nom,
            Color(0xFF4CAF50),
          ),
          Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
          _buildEnhancedInfoRow(
            Icons.email_rounded,
            'Email',
            currentUser.email,
            Color(0xFFFF9800),
          ),
          Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
          _buildEnhancedInfoRow(
            Icons.phone_rounded,
            'Téléphone',
            currentUser.telephone,
            Color(0xFF36D1DC),
          ),
          Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
          _buildEnhancedInfoRow(
            Icons.location_on_rounded,
            'Adresse',
            currentUser.adresse,
            Color(0xFFE91E63),
          ),
          if (currentUser.dateNaissance != null) ...[
            Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
            _buildEnhancedInfoRow(
              Icons.cake_rounded,
              'Date de naissance',
              '${currentUser.dateNaissance!.day}/${currentUser.dateNaissance!.month}/${currentUser.dateNaissance!.year}',
              Color(0xFFFF6B6B),
            ),
          ],
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF6C63FF).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF6C63FF).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF6C63FF),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Appuyez sur le bouton d\'édition pour modifier vos informations',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedInfoRow(IconData icon, String label, String value, Color accentColor) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accentColor, size: 22),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}