import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/preferences.dart';

typedef VoidCallbackParam = void Function();

/// Header displayed in the SliverAppBar flexible space
class ProfileHeader extends StatelessWidget {
  final User currentUser;
  final VoidCallback onEdit;

  const ProfileHeader({Key? key, required this.currentUser, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF857BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    image: currentUser.photoProfil != 'assets/default_user.png'
                        ? DecorationImage(image: NetworkImage(currentUser.photoProfil), fit: BoxFit.cover)
                        : null,
                  ),
                  child: currentUser.photoProfil == 'assets/default_user.png'
                      ? const Icon(Icons.person_rounded, size: 50, color: Colors.white)
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                      ),
                      child: const Icon(Icons.camera_alt_rounded, size: 18, color: Color(0xFF6C63FF)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(currentUser.nomComplet, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 8),
            Text(currentUser.email, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                  SizedBox(width: 8),
                  Text('Membre Premium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card displaying personal informations
class PersonalInfoCard extends StatelessWidget {
  final User currentUser;
  final Preferences userPreferences;
  final VoidCallback onEdit;

  const PersonalInfoCard({
    Key? key,
    required this.currentUser,
    required this.userPreferences,
    required this.onEdit,
  }) : super(key: key);

  Widget _enhancedRow(IconData icon, String label, String value, Color accentColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: accentColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF999999), fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)), maxLines: 2, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person_rounded, color: Color(0xFF6C63FF), size: 24)),
            const SizedBox(width: 12),
            const Text('Informations personnelles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
          ]),
          Container(
            decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_rounded, color: Color(0xFF6C63FF)), tooltip: 'Modifier le profil'),
          ),
        ]),
        const SizedBox(height: 20),
        _enhancedRow(Icons.badge_rounded, 'Prénom', currentUser.prenom, const Color(0xFF6C63FF)),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _enhancedRow(Icons.person_outline_rounded, 'Nom', currentUser.nom, const Color(0xFF4CAF50)),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _enhancedRow(Icons.email_rounded, 'Email', currentUser.email, const Color(0xFFFF9800)),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _enhancedRow(Icons.phone_rounded, 'Téléphone', currentUser.telephone, const Color(0xFF36D1DC)),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _enhancedRow(Icons.location_on_rounded, 'Adresse', currentUser.adresse, const Color(0xFFE91E63)),
        if (currentUser.dateNaissance != null) ...[
          const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
          _enhancedRow(Icons.cake_rounded, 'Date de naissance', '${currentUser.dateNaissance!.day}/${currentUser.dateNaissance!.month}/${currentUser.dateNaissance!.year}', const Color(0xFFFF6B6B)),
        ],
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2), width: 1)), child: Row(children: const [
          Icon(Icons.info_outline_rounded, color: Color(0xFF6C63FF), size: 20),
          SizedBox(width: 12),
          Expanded(child: Text('Appuyez sur le bouton d\'édition pour modifier vos informations', style: TextStyle(fontSize: 12, color: Color(0xFF666666)))),
        ])),
      ]),
    );
  }
}

/// Quick action buttons (Historique, Notifications, Messages, Paramètres)
class QuickActions extends StatelessWidget {
  final VoidCallback onReservations;
  final VoidCallback onNotifications;
  final VoidCallback onMessages;
  final VoidCallback onSettings;

  const QuickActions({Key? key, required this.onReservations, required this.onNotifications, required this.onMessages, required this.onSettings}) : super(key: key);

  Widget _action(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFF6C63FF), size: 24)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Actions rapides', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _action('Historique', Icons.history_rounded, onReservations),
          _action('Notifications', Icons.notifications_rounded, onNotifications),
          _action('Messages', Icons.chat_rounded, onMessages),
          _action('Paramètres', Icons.settings_rounded, onSettings),
        ]),
      ]),
    );
  }
}

/// Settings section card with three options
class SettingsSection extends StatelessWidget {
  final VoidCallback onSecurityTap;
  final VoidCallback onPreferencesTap;
  final VoidCallback onNotificationsTap;

  const SettingsSection({Key? key, required this.onSecurityTap, required this.onPreferencesTap, required this.onNotificationsTap}) : super(key: key);

  Widget _tile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFF6C63FF), size: 20)),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Paramètres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
      const SizedBox(height: 12),
      _tile('Sécurité et confidentialité', Icons.security_rounded, onSecurityTap),
      _tile('Préférences', Icons.tune_rounded, onPreferencesTap),
      _tile('Notifications', Icons.notifications_rounded, onNotificationsTap),
    ]));
  }
}

/// Support section card
class SupportSection extends StatelessWidget {
  final VoidCallback onHelpTap;
  final VoidCallback onContactTap;
  final VoidCallback onTermsTap;

  const SupportSection({Key? key, required this.onHelpTap, required this.onContactTap, required this.onTermsTap}) : super(key: key);

  Widget _supportTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF36D1DC).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFF36D1DC), size: 20)),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF999999)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
      const SizedBox(height: 12),
      _supportTile('Centre d\'aide', Icons.help_rounded, onHelpTap),
      _supportTile('Contactez-nous', Icons.email_rounded, onContactTap),
      _supportTile('Conditions', Icons.description_rounded, onTermsTap),
    ]));
  }
}

/// Logout button
class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16), child: ElevatedButton(onPressed: onLogout, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.logout_rounded, size: 20), SizedBox(width: 8), Text('Se déconnecter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))])));
  }
}